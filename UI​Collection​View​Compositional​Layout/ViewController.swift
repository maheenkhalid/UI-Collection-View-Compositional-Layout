import UIKit

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    enum Section: Int {
        case page
        case thumbnail
    }

    struct Item: Hashable {
        let id = UUID()
        let title: String
        let subtext: String
        let section: Section

        static let data: [Item] = [
            .init(title: "Top 10 Games", subtext: "Explore top 10 games downloaded this month", section: .page),
            .init(title: "Top 10 Utility Apps", subtext: "Explore top 10 Utility apps downloaded this month", section: .page),
            .init(title: "Top 10 Free Apps", subtext: "Explore top 10 Free apss downloaded this month", section: .page),
            .init(title: "Good Food: Recipe Finder", subtext: "Formerly BBC Good Food", section: .thumbnail),
            .init(title: "Reddit", subtext: "Real Answers, from Real People", section: .thumbnail),
            .init(title: "Citymapper", subtext: "Maps & Routes for 400+ Cities", section: .thumbnail),
            .init(title: "Doulingo", subtext: "Learn Languages, Math and Music", section: .thumbnail),
        ]
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Collection View example"
        
        collectionView.collectionViewLayout = createCollectionViewLayout()
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        setupDataSource()
    }

    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                cell.contentView.backgroundColor = indexPath.section == 0 ? .yellow : .systemBackground
                print("IndexPath: \(indexPath.section).\(indexPath.item)")
                return cell
            })

        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(Array(Set(Item.data.map { $0.section })))
        snapshot.appendItems(Item.data.filter { $0.section == .page }, toSection: .page)
        snapshot.appendItems(Item.data.filter { $0.section == .thumbnail }, toSection: .thumbnail)
        print("Sections: \(snapshot.numberOfSections)")
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, environment in
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            
            switch sectionKind {
            case .page:
                return self.bannerSection()
            case .thumbnail:
                return self.tileSection()
            }
        }
    }

    private func bannerSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.5)
        )

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous

        return section
    }

    private func tileSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.25),
            heightDimension: .absolute(100)
        )

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)

        return section
    }
}
