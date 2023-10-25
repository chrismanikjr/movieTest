//
//  MoviePresenter.swift
//  TestAssessmentMovie
//
//  Created by Chrismanto Natanail Manik on 23/10/23.
//

import Foundation

class MovieListPresenter: ViewToPresenterMovieListProtocol{
    var view: PresenterToViewMovieListProtocol?
    var interactor: PresenterToInteractorMovieListProtocol?
    var router: PresenterToRouterMovieListProtocol?
        
    var genres: [Genre]?
    var movieList: [Movie]?
    var page: Int = 1
    var genre: String = ""
    
    func viewDidLoad() {
        view?.showLoading()
        fetchData(isRefresh: false)
    }
    func refresh() {
        fetchData(isRefresh: true)
    }
    private func fetchData(isRefresh: Bool) {
        page = 1
        let urlParams: Parameters = ["with_genres": genre, "page": page]
        interactor?.loadAllApi(urlMovieParams: urlParams, isRefresh: isRefresh)
    }
    
    
    func loadMoreMovies() {
        page += 1
        movieByGenre()
    }
    
    func setupDataGenreCell(indexPath: IndexPath) -> Genre? {
        guard let genres = self.genres else {return nil}
        
        return genres[indexPath.row]
    }
    
    func setupDataMovieListCell(indextPath: IndexPath) -> Movie? {
        guard let movieList = self.movieList else {return nil}
        
        return movieList[indextPath.row]
    }
    
    func didSelectGenre(genre: String) {
        page = 1
        self.genre = genre
        movieByGenre()
    }

    func didSelectMovie(index: Int) {
        if let movies = self.movieList{
            router?.pushToMovieDetail(on: view!, with: movies[index])
        }
    }
    
    private func movieByGenre() {
        let urlParams: Parameters = ["with_genres": genre, "page": page]
        interactor?.loadMovieListByGenre(urlParams: urlParams)
    }

    
}

extension MovieListPresenter: InteractorToPresenterMovieListProtocol{
    func fetchAllApiSuccess(genres: [Genre], movieList: [Movie], isRefresh: Bool) {
        self.genres = genres
        self.movieList = movieList
        if isRefresh{
            view?.onRefreshSuccess()
        }else{
            view?.onFetchApiSuccess()
        }

    }
  
    func fetchMovieListByGenreSuccess(movieList: [Movie]) {

        if page > 1{
            self.movieList! += movieList

            view?.onFetchLoadMoviesMoreSuccess()
            return
        }
        self.movieList = movieList

        view?.onFetchMovieListByGenreSuccess()

    }
    
    func fetchGenresFailed(errorMsg: String) {
        view?.onFetchGenreFailure(error: errorMsg)
    }
    
    func fetchMovieListFailure(errorMsg: String) {
        view?.onFetchGenreFailure(error: errorMsg)
    }
}
