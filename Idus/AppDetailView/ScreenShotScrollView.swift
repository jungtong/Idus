import UIKit
import SnapKit
import Kingfisher

final class ScreenShotScrollView: UIScrollView {
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // UI
    private let contentView = UIView()

    override init(frame: CGRect) {
        super.init(frame: .zero)

        // UI
        self.addSubview(contentView)

        // SnapKit
        contentView.snp.makeConstraints { make -> Void in
            make.edges.equalTo(self)
        }
    }

    func setImageUrls(_ imageUrls: [String]) {
        for (index, urlString) in imageUrls.enumerated() {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.backgroundColor = .clear
            self.addSubview(imageView)

            let imageViewWidth = 196
            let imageViewHeight = 348
            let imageViewMarginWidth = 8
            imageView.snp.makeConstraints { make -> Void in
                make.top.equalTo(self.contentView)
                make.left.equalTo(self.contentView).offset((imageViewWidth + imageViewMarginWidth) * index)
                make.width.equalTo(imageViewWidth)
                make.height.equalTo(imageViewHeight)
            }

            if index == imageUrls.count-1 {
                imageView.snp.makeConstraints { make -> Void in
                    make.right.equalTo(self.contentView)
                }
            }

            if let url = URL(string: urlString) {
                imageView.kf.setImage(with: url)
            }
        }
    }
}
