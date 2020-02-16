import RxSwift
import RxCocoa
import RxAlamofire

// MARK: - Error
enum RxAppDataManagerError: Error {
    case urlEncoding
    case parseJSON
}

extension RxAppDataManagerError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .urlEncoding:
            return NSLocalizedString("URL encoding error", comment: "URL encoding error")
        case .parseJSON:
            return NSLocalizedString("Parse JSON error", comment: "Parse JSON error")
        }
    }
}

// MARK: - Protocol
public protocol RxAppDataManagerInputs {
    func fetchAppData()
}

public protocol RxAppDataManagerOutputs {
    var appDataSource: BehaviorRelay<[[String: Any]]> {get}
    var appDataRefreshFail: PublishRelay<Error> { get }
}

public protocol RxAppDataManagerType {
    var inputs: RxAppDataManagerInputs { get }
    var outputs: RxAppDataManagerOutputs { get }
}

// MARK: - Impl
public final class RxAppDataManager: RxAppDataManagerType {
    private let disposeBag = DisposeBag()
    public var inputs: RxAppDataManagerInputs { return self }
    public var outputs: RxAppDataManagerOutputs { return self }

    // output var
    public var appDataSource = BehaviorRelay<[[String: Any]]>(value: [[String: Any]]())
    public let appDataRefreshFail = PublishRelay<Error>()
}

// MARK: - Inputs
extension RxAppDataManager: RxAppDataManagerInputs {
    public func fetchAppData() {
        let sourceString = "http://itunes.apple.com/search?term=핸드메이드&country=kr&media=software"
        let requireKeys = [
            "artworkUrl512",
            "averageUserRating",
            "contentAdvisoryRating",
            "description",
            "fileSizeBytes",
            "formattedPrice",
            "genres",
            "releaseNotes",
            "screenshotUrls",
            "sellerName",
            "trackName",
            "trackViewUrl",
            "version"
        ]

        guard let encodedString = sourceString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            self.outputs.appDataRefreshFail.accept(RxAppDataManagerError.urlEncoding)
            return
        }

        json(.get, encodedString)
            .subscribe(
                onNext: { [weak self] in
                    if let dictionary = $0 as? [String: Any],
                        let results = dictionary["results"] as? [[String: Any]] {
                        let resultAppData: [[String: Any]] = results.map {
                            $0.filter {
                                return requireKeys.contains($0.key)
                            }
                        }
                        self?.outputs.appDataSource.accept(resultAppData)
                    }
                    else {
                        self?.outputs.appDataRefreshFail.accept(RxAppDataManagerError.parseJSON)
                    }
                },
                onError: { [weak self] in
                    self?.outputs.appDataRefreshFail.accept($0)
            })
            .disposed(by: self.disposeBag)
    }
}

// MARK: - Outputs
extension RxAppDataManager: RxAppDataManagerOutputs {
}
