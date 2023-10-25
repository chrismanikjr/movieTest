//
//  MovieDetailViewController.swift
//  TestAssessmentMovie
//
//  Created by Chrismanto Natanail Manik on 23/10/23.
//

import UIKit

class MovieDetailViewController: UIViewController {
    var loadingView: FooterLoadingSupplementaryView?
    var isLoading: Bool = false
    private enum Section: String, CaseIterable{
        case detail
        case trailer = "Trailer"
        case review = "Review"
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>! = nil
    private var detailCollection : UICollectionView! = nil
    private let refreshControl = UIRefreshControl()
    
    var presenter: ViewToPresenterMovieDetailProtocol?
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        return scrollView
    }()
    private lazy var defaultView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var movieImage : ReusableImage = ReusableImage(styleImg: .big)
    private lazy var titleLabel: ReusableLabel = ReusableLabel(labelText: "", color: .black, type: .title)
    private lazy var topStack : ReusableStackView = ReusableStackView(type: .horizontal, alignmentStack: .center, distributionStack: .fill, spacingStack: 10)
    
    private lazy var ratingImage: ReusableImage = ReusableImage(styleImg: .rating)
    private lazy var ratingLabel: ReusableLabel = ReusableLabel(labelText: "", color: .black, type: .title)
    private lazy var ratingStack: ReusableStackView = ReusableStackView(type: .horizontal, alignmentStack: .fill, distributionStack: .fill, spacingStack: 5)
    
    private lazy var descLabel: ReusableLabel = ReusableLabel(labelText: "Desc", color: .black, type: .desc)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    func setupUI(){
        view.backgroundColor = .white
        configureCollection()
        setupConstraint()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
    }
    
    @objc func refreshData(){
        presenter?.refresh()
    }
    
    func setupConstraint(){
        self.view.addSubview(detailCollection)
        detailCollection.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0, bottom: view.bottomAnchor, paddingBottom: 0, left: view.leadingAnchor, paddingLeft: 0, right: view.trailingAnchor, paddingRight: 0, width: 0, height: 0)
    }
    
    private func passData(){
        if let movieDetail = presenter?.setupDetail(){
            movieImage.changeImageUrl(urlString: movieDetail.imgURL, isCircle: false)
            titleLabel.text = movieDetail.title
            ratingLabel.text = movieDetail.rating
            descLabel.text = movieDetail.overview
        }
    }
}

extension MovieDetailViewController: PresenterToViewMovieDetailProtocol{
    func onFetchApiSuccess() {
        DispatchQueue.main.async {
            self.removeSpinner()
            self.configureDataSource()
        }
    }
    
    func onRefreshSuccess() {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.reloadCollectionView()
        }
    }
    
    func onLoadMoreReviewSuccess() {
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
            DispatchQueue.main.async {
                self.isLoading = false
                self.reloadCollectionView()
            }
        }
    }
    
    func onFetchDetailFailure(error: String) {
        DispatchQueue.main.async {
            self.removeSpinner()
            
            AlertHelper.present(title: "Error Get Movie Detail", actions: .close, message: error, from: self)
            
        }
    }
    
    func onFetchTrailerFailure(error: String) {
        DispatchQueue.main.async {
            self.removeSpinner()
            
            AlertHelper.present(title: "Error Get Trailers Data", actions: .close, message: error, from: self)
        }
    }
    func onFetchReviewsFailure(error: String) {
        DispatchQueue.main.async {
            self.removeSpinner()
            
            AlertHelper.present(title: "Error Get Reviews Data", actions: .close, message: error, from: self)
        }
    }
    func showLoading() {
        showSpinner(onView: view)
    }
}

//MARK: - Configure CollectionView
extension MovieDetailViewController{
    private func configureCollection(){
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
        collectionView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.register(MovieDetailCollectionViewCell.self, forCellWithReuseIdentifier: MovieDetailCollectionViewCell.identifier)
        collectionView.register(TrailerCollectionViewCell.self, forCellWithReuseIdentifier: TrailerCollectionViewCell.identifier)
        collectionView.register(ReviewCollectionViewCell.self, forCellWithReuseIdentifier: ReviewCollectionViewCell.identifier)
        collectionView.register(TitleSupplementaryView.self, forSupplementaryViewOfKind: K.ElementKind.sectionHeader, withReuseIdentifier: TitleSupplementaryView.reuseIdentifier)
        collectionView.register(FooterLoadingSupplementaryView.self, forSupplementaryViewOfKind: K.ElementKind.sectionFooter, withReuseIdentifier: FooterLoadingSupplementaryView.reuseIdentifier)
        
        
        collectionView.addSubview(refreshControl)
        collectionView.collectionViewLayout.invalidateLayout()
        detailCollection = collectionView
    }
    
    private func generateLayout() -> UICollectionViewLayout{
        let sectionProvider = {(sectionNumber: Int, layoutEnv: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let sectionType = Section.allCases[sectionNumber]
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .estimated(44))
            
            let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .estimated(self.isLoading ? 44 : 0))
            
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: K.ElementKind.sectionHeader, alignment: .top)
            let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: K.ElementKind.sectionFooter, alignment: .bottom)
            switch sectionType{
            case .detail:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.6)), subitems: [item])
                group.interItemSpacing = .fixed(10)
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .none
                section.interGroupSpacing = 10
                
                return section
                
            case .trailer:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.7), heightDimension: .estimated(150)), subitems: [item])
                group.interItemSpacing = .fixed(10)
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 10
                section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20)
                section.boundarySupplementaryItems = [sectionHeader]
                
                return section
            case .review:
                let estimatedHeight = CGFloat(150)
                
                let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .estimated(estimatedHeight))
                
                let item = NSCollectionLayoutItem(layoutSize: layoutSize)
                let group = NSCollectionLayoutGroup.vertical(layoutSize: layoutSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .none
                section.interGroupSpacing = 10
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
                section.boundarySupplementaryItems = [sectionHeader, sectionFooter]
                
                return section
            }
            
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        
        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: sectionProvider, configuration: config)
        
        
        return layout
    }
    
    private func configureDataSource(){
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: detailCollection){ (collectionView: UICollectionView, indexPath: IndexPath, item: AnyHashable) -> UICollectionViewCell? in
            
            
            let sectionType = Section.allCases[indexPath.section]
            switch sectionType{
            case .detail:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieDetailCollectionViewCell.identifier, for: indexPath) as? MovieDetailCollectionViewCell else {fatalError("Could not create Movie Detail cell")}
                if let movieDetail = self.presenter?.setupDetail(){
                    cell.setupData(movieDetail: movieDetail)
                }
                return cell
            case .trailer:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrailerCollectionViewCell.identifier, for: indexPath) as? TrailerCollectionViewCell else {fatalError("Could not create Trailers cell")}
                if let trailer = self.presenter?.setupVideoCell(indexPath: indexPath.row){
                    cell.setupData(video: trailer)
                }
                return cell
            case .review:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCollectionViewCell.identifier, for: indexPath) as? ReviewCollectionViewCell else {fatalError("Could not create Movie cell")}
                if let review = self.presenter?.setupReviewCell(indexPath: indexPath.row) {
                    cell.setupData(review: review)
                }
                return cell
            }
            
        }
        
        dataSource.supplementaryViewProvider = { (
            collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            let sectionType = Section.allCases[indexPath.section]
            switch sectionType{
            case .trailer:
                switch kind{
                case K.ElementKind.sectionHeader:
                    guard let headerSupplementaryView = self.detailCollection.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleSupplementaryView.reuseIdentifier, for: indexPath) as? TitleSupplementaryView else{fatalError("Cannot Create Header More Rank Detail Bottom")}
                    headerSupplementaryView.label.text = sectionType.rawValue

                    return headerSupplementaryView
                default:
                    return nil
                }
            case .review:
                switch kind{
                case K.ElementKind.sectionHeader:
                    guard let headerSupplementaryView = self.detailCollection.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleSupplementaryView.reuseIdentifier, for: indexPath) as? TitleSupplementaryView else{fatalError("Cannot Create Header")}
                    headerSupplementaryView.label.text = sectionType.rawValue
                    return headerSupplementaryView
                case K.ElementKind.sectionFooter:
                    guard let footerSupplementaryView = self.detailCollection.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FooterLoadingSupplementaryView.reuseIdentifier, for: indexPath) as? FooterLoadingSupplementaryView else {fatalError("Can't create footer loading")}
                    return footerSupplementaryView
                    
                default:
                    return nil
                }
            default:
                return nil
            }
        }
        reloadCollectionView()
    }
    
    private func reloadCollectionView(){
        let snapshot = snapshotForCurrentState()
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, AnyHashable>{
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.detail])
        snapshot.appendItems([presenter?.detail ?? nil], toSection: .detail)
        snapshot.appendSections([.trailer])
        snapshot.appendItems(presenter?.trailers ?? [], toSection: .trailer)
        snapshot.appendSections([.review])
        snapshot.appendItems(presenter?.reviews ?? [], toSection: .review)
        return snapshot
    }
}

extension MovieDetailViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionType = Section.allCases[indexPath.section]
        switch sectionType{
        case .trailer:
            if let trailer = self.presenter?.setupVideoCell(indexPath: indexPath.row), let videoUrl = URL(string: trailer.videoUrl) {
                UIApplication.shared.open(videoUrl)
            }
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == K.ElementKind.sectionFooter {
            let aFooterView = detailCollection.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: FooterLoadingSupplementaryView.reuseIdentifier, for: indexPath) as! FooterLoadingSupplementaryView
            loadingView = aFooterView
            self.loadingView?.refreshControl.startAnimating()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == K.ElementKind.sectionFooter {
            self.loadingView?.refreshControl.stopAnimating()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let sectionType = Section.allCases[indexPath.section]
        switch sectionType{
        case .review:
            if indexPath.row == (presenter?.reviews?.count ?? 0) - 1 && !(presenter?.isLoadMore ?? false){
                loadMoreData()
            }
        default:
            break
        }
        
    }
    func loadMoreData() {
        if !self.isLoading {
            self.isLoading = true
            presenter?.loadMoreReviews()
        }
    }
}
