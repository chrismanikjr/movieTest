//
//  MovieListProtocol.swift
//  TestAssessmentMovie
//
//  Created by Chrismanto Natanail Manik on 23/10/23.
//

import UIKit

protocol ViewToPresenterMovieListProtocol{
    var view: PresenterToViewMovieListProtocol? {get set}
    var interactor: PresenterToInteractorMovieListProtocol? {get set}
    var router: PresenterToRouterMovieListProtocol? {get set}
    var genres: [Genre]? {get set}
    var movieList: [Movie]? {get set}
    var page: Int {get set}
    var genre:String {get set}
    func viewDidLoad()
    func refresh()
    func loadMoreMovies()
    func setupDataMovieListCell(indextPath: IndexPath) -> Movie?
    func setupDataGenreCell(indexPath: IndexPath) -> Genre?
    func didSelectGenre(genre: String)
    func didSelectMovie(index: Int)
}

protocol PresenterToViewMovieListProtocol{
    func onFetchApiSuccess()
    func onFetchMovieListByGenreSuccess()
    func onFetchLoadMoviesMoreSuccess()
    func onRefreshSuccess()
    func onFetchGenreFailure(error: String)
    func onFetchMovieListFailure(error: String)
    func showLoading()
}

protocol PresenterToInteractorMovieListProtocol{
    var presenter: InteractorToPresenterMovieListProtocol? {get set}
    func loadAllApi(urlMovieParams: Parameters, isRefresh: Bool)
    func loadMovieListByGenre(urlParams: Parameters)
}

protocol InteractorToPresenterMovieListProtocol{
    func fetchAllApiSuccess(genres: [Genre], movieList: [Movie], isRefresh: Bool)
    func fetchMovieListByGenreSuccess(movieList: [Movie])
    func fetchGenresFailed(errorMsg: String)
    func fetchMovieListFailure(errorMsg: String)
}

protocol PresenterToRouterMovieListProtocol{
    static func createModule() -> UINavigationController
    func pushToMovieDetail(on view: PresenterToViewMovieListProtocol, with movie: Movie)
}
