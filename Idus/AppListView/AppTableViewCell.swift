import UIKit
import Cosmos
import SnapKit
import Kingfisher

final class AppTableViewCell: UITableViewCell {
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // UI
    private let baseView = UIView()
    private let mainImageView = UIImageView()
    private let appTitleLabel = UILabel()
    private let sellerNameLabel = UILabel()
    private let seperatorView = UIView()
    private let genresLabel = UILabel()
    private let priceLabel = UILabel()
    private let rateView = CosmosView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // UI
        self.backgroundColor = .clear

        // baseView
        baseView.layer.borderColor = UIColor.lightGray.cgColor
        baseView.layer.borderWidth = 1.0
        baseView.layer.cornerRadius = 10.0
        baseView.backgroundColor = .white
        self.contentView.addSubview(baseView)

        // appIamgeView
        mainImageView.layer.masksToBounds = true
        mainImageView.layer.cornerRadius = 10.0
        self.baseView.addSubview(mainImageView)

        // appTitleLabel
        self.baseView.addSubview(appTitleLabel)

        // sellerNameLabel
        sellerNameLabel.textColor = .lightGray
        sellerNameLabel.font = .systemFont(ofSize: 14)
        self.baseView.addSubview(sellerNameLabel)

        // seperatorView
        seperatorView.backgroundColor = .lightGray
        self.baseView.addSubview(seperatorView)

        // genresLabel
        self.baseView.addSubview(genresLabel)

        // priceLabel
        priceLabel.textColor = .lightGray
        self.baseView.addSubview(priceLabel)

        // rateView
        rateView.settings.fillMode = .precise
        rateView.settings.emptyColor = .gray
        rateView.settings.starMargin = 0.0
        rateView.settings.updateOnTouch = false
        self.baseView.addSubview(rateView)

        // SnapKit
        baseView.snp.makeConstraints { make -> Void in
            make.top.equalTo(self.contentView).offset(4).priority(999)
            make.bottom.equalTo(self.contentView).offset(-4).priority(999)
            make.left.equalTo(self.contentView).offset(8).priority(999)
            make.right.equalTo(self.contentView).offset(-8).priority(999)
        }
        mainImageView.snp.makeConstraints { make -> Void in
            make.top.left.right.equalTo(self.baseView)
            make.height.equalTo(self.baseView.snp.width)
        }
        appTitleLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(self.mainImageView.snp.bottom).offset(4)
            make.height.equalTo(21)
            make.left.equalTo(self.baseView).offset(8)
            make.right.equalTo(self.baseView).offset(-8)
        }
        sellerNameLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(self.appTitleLabel.snp.bottom).offset(2)
            make.height.equalTo(21)
            make.left.equalTo(self.baseView.snp.left).offset(8)
            make.right.equalTo(self.baseView).offset(-8)
        }
        seperatorView.snp.makeConstraints { make -> Void in
            make.top.equalTo(self.sellerNameLabel.snp.bottom).offset(4)
            make.height.equalTo(1)
            make.left.right.equalTo(self.baseView)
        }
        genresLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(self.seperatorView.snp.bottom).offset(4)
            make.height.equalTo(21)
            make.left.equalTo(self.baseView).offset(8)
            make.right.equalTo(self.rateView).offset(-8)
        }
        rateView.snp.makeConstraints { make -> Void in
            make.top.equalTo(self.seperatorView.snp.bottom).offset(4)
            make.height.equalTo(21)
            make.right.equalTo(self.baseView).offset(-8)
            make.width.greaterThanOrEqualTo(100)
        }
        priceLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(self.genresLabel.snp.bottom).offset(4)
            make.height.equalTo(21)
            make.left.equalTo(self.baseView).offset(8)
            make.width.greaterThanOrEqualTo(200)
            make.bottom.equalTo(self.baseView).offset(-8)
        }
    }

    func updateCell(appData: [String: Any]) {
        if let urlString = appData["artworkUrl512"] as? String,
            let url = URL(string: urlString) {
            mainImageView.kf.setImage(with: url,
                                      placeholder: UIImage(named: "backpackrlogo"))
        }

        appTitleLabel.text = appData["trackName"] as? String
        sellerNameLabel.text = appData["sellerName"] as? String
        if let genresArray = appData["genres"] as? [String],
            genresArray.isEmpty == false {
            genresLabel.text = genresArray[0]
        }
        rateView.rating = appData["averageUserRating"] as? Double ?? 0.0
        priceLabel.text = appData["formattedPrice"] as? String
    }
}
