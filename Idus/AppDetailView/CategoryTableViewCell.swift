import UIKit
import SnapKit
import AlignedCollectionViewFlowLayout

private let categoryCellReuseIdentifier = "tagCell"

final class CategoryTableViewCell: UITableViewCell, AppDetailTableViewCellProtocol {
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // UI
    private let titleView = UILabel()
    private let categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: AlignedCollectionViewFlowLayout())

    // Data
    var categorysDataSource = [String]()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // UI
        titleView.text = "카테고리"
        titleView.font = .boldSystemFont(ofSize: 18)
        self.contentView.addSubview(titleView)

        let flowLayout = categoryCollectionView.collectionViewLayout as? AlignedCollectionViewFlowLayout
        flowLayout?.horizontalAlignment = .left
        flowLayout?.estimatedItemSize = .init(width: 100, height: 20)
        categoryCollectionView.backgroundColor = .clear
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        categoryCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: categoryCellReuseIdentifier)
        self.contentView.addSubview(categoryCollectionView)

        // SnapKit
        titleView.snp.makeConstraints { make -> Void in
            make.top.equalTo(self.contentView).offset(8)
            make.left.equalTo(self.contentView).offset(20)
            make.width.greaterThanOrEqualTo(100)
            make.height.equalTo(21)
        }
        categoryCollectionView.snp.makeConstraints { make -> Void in
            make.top.equalTo(self.titleView.snp.bottom).offset(16)
            make.left.equalTo(self.contentView).offset(8)
            make.right.equalTo(self.contentView).offset(-8)
            make.height.greaterThanOrEqualTo(30)

            make.bottom.equalTo(self.contentView).offset(-16).priority(999)
        }
    }

    // AppDetailTableViewCellProtocol
    var appDetailViewControllerProtocol: AppDetailViewControllerProtocol?
    var cellType: CellType?
    func updateCell(appData: [String: Any]) {
        categorysDataSource = appData["genres"] as? [String] ?? []
    }
}

extension CategoryTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categorysDataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryCellReuseIdentifier, for: indexPath)
        if let categoryCollectionViewCell = cell as? CategoryCollectionViewCell {
            categoryCollectionViewCell.categoryLabel.text = "# \(categorysDataSource[indexPath.item])"
        }
        return cell
    }

//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if categorysDataSource.count > indexPath.row {
//            let selectedCategory = categorysDataSource[indexPath.row]
//            print(#function, selectedCategory)
//        }
//    }
}

// MARK: - CategoryCollectionViewCell
final class CategoryCollectionViewCell: UICollectionViewCell {
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // UI
    let categoryLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        // UI
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.black.cgColor

        categoryLabel.font = .systemFont(ofSize: 12)
        self.contentView.addSubview(categoryLabel)

        // SnapKit
        categoryLabel.snp.makeConstraints { make -> Void in
            make.left.equalTo(self.contentView).offset(12)
            make.right.equalTo(self.contentView).offset(-12)
            make.top.equalTo(self.contentView).offset(6)
            make.bottom.equalTo(self.contentView).offset(-6)

            make.width.greaterThanOrEqualTo(20).priority(999)
            make.height.greaterThanOrEqualTo(10).priority(999)
        }
    }
}
