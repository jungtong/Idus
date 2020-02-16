import UIKit
import SnapKit

// protocol
protocol AppDetailViewControllerProtocol: AnyObject {
    func showInWebButtonPressed(shareLink: String?)
    func shareButtonPressed(shareLink: String?)
    func moreButtonPressed(cellType: CellType?, isToggleOn: Bool)
}

final class AppDetailViewController: UIViewController {
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // UI
    private let appDetailTableView = UITableView(frame: .zero, style: .grouped)

    // Data
    private var appData: [String: Any]
    private var cellTypeArray: [[CellType]] =
        [
            [
                .appInfo,
                .keyValueAppSize,
                .keyValueContentRating,
                .keyValueNewFeature,
                .description
            ],
            [
                .category
            ]
    ]

    init(appData: [String: Any]) {
        // Data
        self.appData = appData
        super.init(nibName: nil, bundle: nil)

        // UI
        appDetailTableView.backgroundColor = .lightGray
        appDetailTableView.rowHeight = UITableView.automaticDimension
        appDetailTableView.estimatedRowHeight = 44
        appDetailTableView.delegate = self
        appDetailTableView.dataSource = self
        appDetailTableView.register(AppInfoTableViewCell.self, forCellReuseIdentifier: appInfoCellIdentifier)
        appDetailTableView.register(KeyValueTableViewCell.self, forCellReuseIdentifier: keyValueCellIdentifier)
        appDetailTableView.register(DetailTableViewCell.self, forCellReuseIdentifier: detailInfoCellIdentifier)
        appDetailTableView.register(DescriptionTableViewCell.self, forCellReuseIdentifier: descriptionCellIdentifier)
        appDetailTableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: categoryCellIdentifier)
        appDetailTableView.contentInset = UIEdgeInsets(top: -36, left: 0, bottom: -36, right: 0)
        self.view.addSubview(appDetailTableView)

        // SnapKit
        appDetailTableView.snp.makeConstraints { make -> Void in
            make.edges.equalTo(self.view)
        }
    }
}

// UITableViewDelegate, UITableViewDataSource
extension AppDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellTypeArray.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTypeArray[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = cellTypeArray[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellType.identifier, for: indexPath)
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

        if let appDetailTableViewCellProtocolCell = cell  as? AppDetailTableViewCellProtocol {
            appDetailTableViewCellProtocolCell.appDetailViewControllerProtocol = self
            appDetailTableViewCellProtocolCell.cellType = cellType
            appDetailTableViewCellProtocolCell.updateCell(appData: appData)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? KeyValueTableViewCell else {
            return
        }

        cell.updateDetailCellOpen(isOpen: cell.isDetailViewOpen)
        let cellType = cellTypeArray[indexPath.section][indexPath.row]
        let targetIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)

        self.appDetailTableView.beginUpdates()
        if cellType == .keyValueNewFeature {
            if cell.isDetailViewOpen {
                // insert with animation
                cellTypeArray[targetIndexPath.section].insert(.detailNewFeature, at: targetIndexPath.row)
                self.appDetailTableView.insertRows(at: [targetIndexPath], with: .automatic)
            }
            else {
                // delete with animation
                cellTypeArray[targetIndexPath.section].remove(at: targetIndexPath.row)
                self.appDetailTableView.deleteRows(at: [targetIndexPath], with: .automatic)
            }
        }
        self.appDetailTableView.endUpdates()
    }
}

// AppDetailViewControllerProtocol
extension AppDetailViewController: AppDetailViewControllerProtocol {
    func showInWebButtonPressed(shareLink: String?) {
        if let encodedString = shareLink?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: encodedString),
            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:])
        }
    }

    func shareButtonPressed(shareLink: String?) {
        if let encodedString = shareLink?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: encodedString),
            UIApplication.shared.canOpenURL(url) {
            let avtivityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            self.present(avtivityViewController, animated: true, completion: nil)
        }
    }

    func moreButtonPressed(cellType: CellType?, isToggleOn: Bool) {
        guard let cellType = cellType else {
            return
        }

        var findIndexPath: IndexPath?
        for (section, array) in cellTypeArray.enumerated() {
            if let row = array.firstIndex(of: cellType) { // find
                findIndexPath = IndexPath(row: row + 1, section: section)
            }
        }

        guard let targetIndexPath = findIndexPath else {
            return
        }

        self.appDetailTableView.beginUpdates()
        if cellType == .keyValueNewFeature {
            if isToggleOn {
                // insert with animation
                cellTypeArray[targetIndexPath.section].insert(.detailNewFeature, at: targetIndexPath.row)
                self.appDetailTableView.insertRows(at: [targetIndexPath], with: .automatic)
            }
            else {
                // delete with animation
                cellTypeArray[targetIndexPath.section].remove(at: targetIndexPath.row)
                self.appDetailTableView.deleteRows(at: [targetIndexPath], with: .automatic)
            }
        }
        self.appDetailTableView.endUpdates()
    }
}
