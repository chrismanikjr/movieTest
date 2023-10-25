//
//  ViewController.swift
//  TestAssessmentMovie
//
//  Created by Chrismanto Natanail Manik on 22/10/23.
//

import UIKit

class MovieListViewController: UIViewController {
    var loadingView: FooterLoadingSupplementaryView?
    var isLoading: Bool = false
    private enum Section: String, CaseIterable{
        case genre = "Genre"
        case movieList = "MovieList"
    }
    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>! = nil
    private var homeCollection : UICollectionView! = nil
    private let refreshControl = UIRefreshControl()
    
    
    var presenter: ViewToPresenterMovieListProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setupView()
        view.backgroundColor = .red
        // Do any additional setup after loading the view.
    }
    
    func setupView(){
        configureCollection()
        setupConstraint()
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    @objc func refreshData(){
        presenter?.refresh()
    }
    
    private func setupConstraint(){
        self.view.addSubview(homeCollection)
        homeCollection.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0, bottom: view.bottomAnchor, paddingBottom: 0, left: view.leadingAnchor, paddingLeft: 0, right: view.trailingAnchor, paddingRight: 0, width: 0, height: 0)
    }
}
//MARK: - Configure CollectionView
extension MovieListViewController{
    private func configureCollection(){
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
        collectionView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.register(GenreCollectionViewCell.self, forCellWithReuseIdentifier: GenreCollectionViewCell.identifier)
        
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.register(FooterLoadingSupplementaryView.self, forSupplementaryViewOfKind: K.ElementKind.sectionFooter, withReuseIdentifier: FooterLoadingSupplementaryView.reuseIdentifier)
        collectionView.addSubview(refreshControl)
        homeCollection = collectionView
    }
    
    private func generateLayout() -> UICollectionViewLayout{
        let sectionProvider = {(sectionNumber: Int, layoutEnv: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let sectionType = Section.allCases[sectionNumber]
            
            switch sectionType{
            case .genre:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .estimated(150), heightDimension: .absolute(40)))
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .estimated(150), heightDimension: .absolute(40)), subitems: [item])
                group.interItemSpacing = .fixed(10)
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 10
                section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20)
                
                return section
            case .movieList:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(150)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .none
                section.interGroupSpacing = 10
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
                
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
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: homeCollection){ (collectionView: UICollectionView, indexPath: IndexPath, item: AnyHashable) -> UICollectionViewCell? in
            
            
            let sectionType = Section.allCases[indexPath.section]
            switch sectionType{
            case .genre:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCollectionViewCell.identifier, for: indexPath) as? GenreCollectionViewCell else {fatalError("Could not create Genre cell")}
                if let genre = self.presenter?.setupDataGenreCell(indexPath: indexPath){
                    cell.setupData(genre: genre)
                }
                return cell
            case .movieList:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {fatalError("Could not create Movie cell")}
                if let movie = self.presenter?.setupDataMovieListCell(indextPath: indexPath) {
                    cell.setupData(movie: movie)
                }
                return cell
            }
            
        }
        
        let footerRegistration = UICollectionView.SupplementaryRegistration
        <FooterLoadingSupplementaryView>(elementKind: K.ElementKind.sectionFooter) {
            (supplementaryView, string, indexPath) in
            supplementaryView.backgroundColor = .red
        }
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.homeCollection.dequeueReusableSupplementaryView(ofKind: K.ElementKind.sectionFooter, withReuseIdentifier: FooterLoadingSupplementaryView.reuseIdentifier, for: index)
        }
        reloadCollectionView()
        
    }
    
    private func reloadCollectionView(){
        let snapshot = snapshotForCurrentState()
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, AnyHashable>{
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.genre])
        snapshot.appendItems(presenter?.genres ?? [], toSection: .genre)
        snapshot.appendSections([.movieList])
        snapshot.appendItems(presenter?.movieList ?? [], toSection: .movieList)
        return snapshot
    }
}

extension MovieListViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionType = Section.allCases[indexPath.section]
        switch sectionType{
        case .genre:
            if let genreId = presenter?.genres?[indexPath.row].id{
                presenter?.didSelectGenre(genre: "\(genreId)")
            }
        case .movieList:
            presenter?.didSelectMovie(index: indexPath.row)

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == K.ElementKind.sectionFooter {
            let aFooterView = homeCollection.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: FooterLoadingSupplementaryView.reuseIdentifier, for: indexPath) as! FooterLoadingSupplementaryView
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
        case .movieList:
            if indexPath.row == (presenter?.movieList?.count ?? 0) - 1 && !self.isLoading{
                loadMoreData()
            }
        default:
            break
        }
        
    }
    func loadMoreData() {
        if !self.isLoading {
            self.isLoading = true
            presenter?.loadMoreMovies()
        }
    }
}
extension MovieListViewController: PresenterToViewMovieListProtocol{
    func onFetchLoadMoviesMoreSuccess() {
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
            DispatchQueue.main.async {
                self.isLoading = false
                self.reloadCollectionView()
            }
        }
    }
    
    func onFetchMovieListByGenreSuccess() {
        DispatchQueue.main.async {
            self.removeSpinner()
            self.reloadCollectionView()
        }
    }
    
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
    func onFetchGenreFailure(error: String) {
        DispatchQueue.main.async {
            self.removeSpinner()
            AlertHelper.present(title: "Error Get Genre Data", actions: .close, message: error, from: self)
        }
    }
    
    func onFetchMovieListFailure(error: String) {
        DispatchQueue.main.async {
            self.removeSpinner()
            AlertHelper.present(title: "Error Get Movie Data", actions: .close, message: error, from: self)
        }
    }
    
    func showLoading() {
        showSpinner(onView: view)
    }

}



