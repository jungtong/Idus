import UIKit
import SnapKit

final class AppInfoTableViewCell: UITableViewCell, AppDetailTableViewCellProtocol {
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // UI
    private let screenShotView = ScreenShotScrollView()
    private let titleLabel = UILabel()
    private let sellerLabel = UILabel()
    private let priceLabel = UILabel()
    private let showInWebButton = UIButton()
    private let shareButton = UIButton()

    // Data
    private var shareLink: String?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // UI
        self.contentView.addSubview(screenShotView)

        titleLabel.font = .boldSystemFont(ofSize: 18)
        self.contentView.addSubview(titleLabel)

        sellerLabel.font = .systemFont(ofSize: 14)
        sellerLabel.textColor = .gray
        self.contentView.addSubview(sellerLabel)

        priceLabel.font = .boldSystemFont(ofSize: 18)
        self.contentView.addSubview(priceLabel)

        showInWebButton.layer.borderColor = UIColor.lightGray.cgColor
        showInWebButton.layer.borderWidth = 1.0
        showInWebButton.setTitle("웹에서 보기", for: .normal)
        showInWebButton.setTitleColor(.black, for: .normal)
        showInWebButton.addTarget(self, action: #selector(showInWebButtonPressed(_:)), for: .touchUpInside)
        self.contentView.addSubview(showInWebButton)

        shareButton.layer.borderColor = UIColor.lightGray.cgColor
        shareButton.layer.borderWidth = 1.0
        shareButton.setTitle("공유하기", for: .normal)
        shareButton.setTitleColor(.black, for: .normal)
        shareButton.addTarget(self, action: #selector(shareButtonPressed(_:)), for: .touchUpInside)
        self.contentView.addSubview(shareButton)

        // SnapKit
        screenShotView.snp.makeConstraints { make -> Void in
            make.top.equalTo(self.contentView).offset(8)
            make.height.equalTo(348)
            make.left.right.equalTo(self.contentView)
        }
        titleLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(self.screenShotView.snp.bottom).offset(16)
            make.height.equalTo(25)
            make.left.right.equalTo(self.contentView).offset(8)
        }
        sellerLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(4)
            make.height.equalTo(22)
            make.left.right.equalTo(self.contentView).offset(8)
        }
        priceLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(self.sellerLabel.snp.bottom).offset(4)
            make.height.equalTo(25)
            make.left.right.equalTo(self.contentView).offset(8)
        }
        showInWebButton.snp.makeConstraints { make -> Void in
            make.top.equalTo(self.priceLabel.snp.bottom).offset(16)
            make.right.equalTo(self.snp.centerX)
            make.width.equalTo(self).multipliedBy(0.45)
            make.height.equalTo(44)

            make.bottom.equalTo(self.contentView).offset(-16).priority(999)
        }
        shareButton.snp.makeConstraints { make -> Void in
            make.top.equalTo(self.priceLabel.snp.bottom).offset(16)
            make.left.equalTo(self.snp.centerX)
            make.width.equalTo(self).multipliedBy(0.45)
            make.height.equalTo(44)
        }
    }

    // AppDetailTableViewCellProtocol
    var appDetailViewControllerProtocol: AppDetailViewControllerProtocol?
    var cellType: CellType?
    func updateCell(appData: [String: Any]) {
        self.screenShotView.setImageUrls(appData["screenshotUrls"] as? [String] ?? [String]())
        self.titleLabel.text = appData["trackName"] as? String
        self.sellerLabel.text = appData["sellerName"] as? String
        self.priceLabel.text = appData["formattedPrice"] as? String
        self.shareLink = appData["trackViewUrl"] as? String
    }
}

extension AppInfoTableViewCell {
    @objc private func showInWebButtonPressed(_ sender: UIButton) {
        appDetailViewControllerProtocol?.showInWebButtonPressed(shareLink: shareLink)
    }

    @objc private func shareButtonPressed(_ sender: UIButton) {
        appDetailViewControllerProtocol?.shareButtonPressed(shareLink: shareLink)
    }
}
