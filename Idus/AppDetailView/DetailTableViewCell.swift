import UIKit
import SnapKit

final class DetailTableViewCell: UITableViewCell, AppDetailTableViewCellProtocol {
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // UI
    private let textView = UITextView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // UI
        textView.backgroundColor = .lightGray
        textView.textColor = .darkText
        textView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isSelectable = false
        self.contentView.addSubview(textView)

        // SnapKit
        textView.snp.makeConstraints { make -> Void in
            make.top.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(20)
            make.right.equalTo(self.contentView).offset(-20)
            make.height.greaterThanOrEqualTo(44)

            make.bottom.equalTo(self.contentView).priority(999)
        }
    }

    // AppDetailTableViewCellProtocol
    var appDetailViewControllerProtocol: AppDetailViewControllerProtocol?
    var cellType: CellType?
    func updateCell(appData: [String: Any]) {
        switch cellType {
        case .detailNewFeature:
            textView.text = appData["releaseNotes"] as? String
        default:
            fatalError("\(#file)[\(#line)] cellType error")
        }
    }
}
