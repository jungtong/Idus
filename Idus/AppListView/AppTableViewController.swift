import UIKit
import SnapKit
import RxSwift
import NSObject_Rx

final class AppTableViewController: UIViewController {

    // init - storyboard 를 통해서 초기화
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // UI
    private let titleLabel = UILabel()
    private let titleView = UIView()
    private let appTableView = UITableView()

    // Data
    private let appDataManager = RxAppDataManager()

    override func awakeFromNib() {
        super.awakeFromNib()

        // UI
        self.title = "핸드메이드"

        // titleView
        titleLabel.text = self.title
        titleLabel.font = .boldSystemFont(ofSize: 20)
        self.titleView.addSubview(titleLabel)
        titleView.backgroundColor = .white
        self.view.addSubview(titleView)

        // appListTableView
        appTableView.backgroundColor = .gray
        appTableView.separatorStyle = .none
        appTableView.rowHeight = UITableView.automaticDimension
        appTableView.estimatedRowHeight = 100
        appTableView.register(AppTableViewCell.self, forCellReuseIdentifier: "AppTableViewCell")
        self.view.addSubview(appTableView)

        // bind
        appDataManager
            .outputs
            .appDataSource
            .bind(to: appTableView.rx.items(cellIdentifier: "AppTableViewCell",
                                            cellType: AppTableViewCell.self)) {
                                                (_, element: [String: Any], cell: AppTableViewCell) in
                                                cell.selectionStyle = .none
                                                cell.updateCell(appData: element)
        }.disposed(by: rx.disposeBag)

        // tableview cell selected
        appTableView.rx.itemSelected.asDriver().drive(onNext: { [weak self] indexPath in
            guard let appData = self?.appDataManager.outputs.appDataSource.value[indexPath.row] else {
                self?.presentErrorPopup(message: NSLocalizedString("Data load error \(indexPath.row)", comment: "Data load error"))
                return
            }
            self?.navigationController?.pushViewController(AppDetailViewController(appData: appData), animated: true)
        }).disposed(by: rx.disposeBag)

        // SnapKit
        titleView.snp.makeConstraints { make -> Void in
            make.top.left.right.equalTo(self.view)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.view.snp.topMargin).offset(44)
            }
            else {
                make.bottom.equalTo(self.view.snp.topMargin).offset(64)
            }
        }
        titleLabel.snp.makeConstraints { make -> Void in
            make.left.equalTo(self.titleView.snp.left).offset(16)
            make.width.greaterThanOrEqualTo(200)
            make.height.equalTo(32)
            make.bottom.equalTo(self.titleView.snp.bottom).offset(-8)
        }
        appTableView.snp.makeConstraints { make -> Void in
            make.top.equalTo(self.titleView.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        // refresh appData
        if appDataManager.outputs.appDataSource.value.isEmpty {
            appDataManager.inputs.fetchAppData()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

extension AppTableViewController {
    private func presentErrorPopup(message: String) {
        let alertController = UIAlertController(title: NSLocalizedString("Error", comment: "Error"),
                                                message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("Donw", comment: "Done"),
                                     style: .default,
                                     handler: nil)
        alertController.addAction(okAction)

        self.present(alertController, animated: true, completion: nil)
    }
}
