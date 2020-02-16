import UIKit
import SnapKit

final class KeyValueTableViewCell: UITableViewCell, AppDetailTableViewCellProtocol {
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // UI
    private let keyLabel = UILabel()
    private let valueLabel = UILabel()
    private let arrowLabel = UILabel()

    // Data
    var isDetailViewOpen = false

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // UI
        self.contentView.addSubview(keyLabel)

        valueLabel.textColor = .green
        self.contentView.addSubview(valueLabel)

        arrowLabel.text = "⌄"
        arrowLabel.textColor = .gray
        self.contentView.addSubview(arrowLabel)

        // SnapKit
        keyLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(self.contentView).offset(10)
            make.height.equalTo(24)
            make.left.equalTo(self.contentView).offset(20)
            make.width.lessThanOrEqualTo(self.contentView.snp.width).multipliedBy(0.4)

            make.bottom.equalTo(self.contentView).offset(-10).priority(999)
        }
        valueLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(self.contentView).offset(10)
            make.right.equalTo(self.contentView).offset(-40)
            make.width.lessThanOrEqualTo(self.contentView.snp.width).multipliedBy(0.4)
            make.height.equalTo(30)
        }
        arrowLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(self.contentView).offset(10)
            make.right.equalTo(self.contentView).offset(-16)
            make.width.lessThanOrEqualTo(20)
            make.height.equalTo(30)
        }
    }

    // AppDetailTableViewCellProtocol
    var appDetailViewControllerProtocol: AppDetailViewControllerProtocol?
    var cellType: CellType?
    func updateCell(appData: [String: Any]) {
        switch cellType {
        case .keyValueAppSize:
            self.keyLabel.text = "크기"
            if let fileSize = appData["fileSizeBytes"] as? String,
                let fileSizeInt = Int64(fileSize) {
                self.valueLabel.text = ByteCountFormatter.string(fromByteCount: fileSizeInt, countStyle: .file)
            }
            else {
                self.valueLabel.text = "-"
            }
        arrowLabel.isHidden = true
        case .keyValueContentRating:
            self.keyLabel.text = "연령"
            self.valueLabel.text = appData["contentAdvisoryRating"] as? String
            arrowLabel.isHidden = true
        case .keyValueNewFeature:
            self.keyLabel.text = "새로운 기능"
            self.valueLabel.text = appData["version"] as? String
            arrowLabel.isHidden = false
        default:
            fatalError("\(#file)[\(#line)] cellType error")
        }
    }

    func updateDetailCellOpen(isOpen: Bool) {
        if isOpen {
            isDetailViewOpen = false
            arrowLabel.text = "⌄"
        }
        else {
            isDetailViewOpen = true
            arrowLabel.text = "⌃"
        }
    }
}
