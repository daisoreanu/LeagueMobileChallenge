//
//  UserPostsCollectionViewController.swift
//  LeagueMobileChallenge
//
//  Created by Daisoreanu Laurentiu on 27.08.2022.
//

import UIKit



class UserPostsCollectionViewController: UICollectionViewController {
    
    // MARK: - Properties
    private lazy var dataSource = makeDataSource()
    private let viewModel: UserPostsCollectionViewModelProtocol

    // MARK: - Value Types
    typealias DataSource = UICollectionViewDiffableDataSource<UserPostSection, UserPostSectionItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<UserPostSection, UserPostSectionItem>
    
    
    init(viewModel: UserPostsCollectionViewModelProtocol) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: UICollectionViewLayout())
        self.viewModel.setDelegate(self)
    }
    
    @available(*, unavailable, message: "Unsuported method, use DI constructor.")
    required init?(coder aDecoder: NSCoder) {
        fatalError("View controller created from a storyboard is unsupported in favor of dependency injection.")
    }
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        registerCells()
        viewModel.fetchData()
    }
    
}

// MARK: - Layout Handling
private extension UserPostsCollectionViewController {
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView,
                                    cellProvider: { (collectionView, indexPath, feedItem) -> UICollectionViewCell? in
            
            func configureInstructionsCell(viewModel:  InstructionItemViewModel) -> UICollectionViewCell? {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InstructionsCollectionViewCell.identifier,
                                                              for: indexPath) as! InstructionsCollectionViewCell
                cell.configure(viewModel: viewModel, delegate: self)
                return cell
            }
            
            switch feedItem {
            case .userPost(let post):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserPostCollectionViewCell.identifier,
                                                              for: indexPath) as! UserPostCollectionViewCell
                cell.configure(viewModel: post)
                return cell
            case .error(let errorInstruction):
                let cell = configureInstructionsCell(viewModel: errorInstruction)
                return cell
            case .empty(let noDataInstruction):
                let cell = configureInstructionsCell(viewModel: noDataInstruction)
                return cell
            case .loading(_):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyCollectionViewCell.identifier,
                                                              for: indexPath) as! EmptyCollectionViewCell
                return cell
            }
        })
        return dataSource
    }
    
    func applySnapshot(sections: [UserPostSectionViewModel], animatingDifferences: Bool = false) {
        var snapshot = Snapshot()
        sections.forEach { podcastSectionViewModel in
            snapshot.appendSections([podcastSectionViewModel.section])
            snapshot.appendItems(podcastSectionViewModel.userPostSectionItems)
        }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

// MARK: - Methods
private extension UserPostsCollectionViewController {
    func configureUI() {
        title = "Posts"
        collectionView.backgroundColor = .white
    }
    
    func registerCells() {
        let emptyCellNib = UINib(nibName: EmptyCollectionViewCell.identifier, bundle: nil)
        collectionView.register(emptyCellNib,
                                forCellWithReuseIdentifier: EmptyCollectionViewCell.identifier)
        
        let userPostCellNib = UINib(nibName: UserPostCollectionViewCell.identifier, bundle: nil)
        collectionView.register(userPostCellNib,
                                forCellWithReuseIdentifier: UserPostCollectionViewCell.identifier)
        
        let instructionsCellNib = UINib(nibName: InstructionsCollectionViewCell.identifier, bundle: nil)
        collectionView.register(instructionsCellNib,
                                forCellWithReuseIdentifier: InstructionsCollectionViewCell.identifier)
    }
    
    func configureLayout() {
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let size = self.itemLayout(sectionIndex: sectionIndex)
            let item = NSCollectionLayoutItem(layoutSize: size)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets.zero
            section.interGroupSpacing = 0
            section.supplementariesFollowContentInsets = false
            return section
        })
    }
    
    func itemLayout(sectionIndex: Int) -> NSCollectionLayoutSize {
        let cellType = viewModel.data().first!.userPostSectionItems.first!
        var height: NSCollectionLayoutDimension = .fractionalHeight(1.0)
        switch cellType {
        case .userPost(_):
            height = .estimated(UserPostCollectionViewCell.cellSize.height)
        case .error(_), .empty(_):
            height = .fractionalHeight(1.0)
        case .loading(_):
            height = .estimated(EmptyCollectionViewCell.cellSize.height)
        }
        return NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: height
        )
    }
}

// MARK: - Protocol conformance
extension UserPostsCollectionViewController: InstructionsCollectionViewCellDelegate {
    func userTappedReloadData() {
        viewModel.fetchData()
    }
}

extension UserPostsCollectionViewController: UserPostsCollectionViewModelDelegate {
    func reloadData() {
        configureLayout()
        applySnapshot(sections: viewModel.data())
    }
}
