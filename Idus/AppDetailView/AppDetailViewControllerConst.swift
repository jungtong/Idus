// AppDetailTableViewCell Type
let appInfoCellIdentifier = "appInfoCell"
let keyValueCellIdentifier = "keyValueCell"
let detailInfoCellIdentifier = "detailInfoCell"
let descriptionCellIdentifier = "descriptionCell"
let categoryCellIdentifier = "categoryCell"

enum CellType: String {
    case appInfo
    case keyValueAppSize
    case keyValueContentRating
    case keyValueNewFeature
    case detailNewFeature
    case description
    case category
}

extension CellType {
    var identifier: String {
        switch self {
        case .appInfo:
            return appInfoCellIdentifier
        case .keyValueAppSize,
             .keyValueContentRating,
             .keyValueNewFeature:
            return keyValueCellIdentifier
        case .detailNewFeature:
            return detailInfoCellIdentifier
        case .description:
            return descriptionCellIdentifier
        case .category:
            return categoryCellIdentifier
        }
    }
}

// AppDetailTableViewCell Protocol
protocol AppDetailTableViewCellProtocol: AnyObject {
    var appDetailViewControllerProtocol: AppDetailViewControllerProtocol? { get set }
    var cellType: CellType? { get set }
    func updateCell(appData: [String: Any])
}
