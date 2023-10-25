//
//  MovieListInteractor.swift
//  TestAssessmentMovie
//
//  Created by Chrismanto Natanail Manik on 23/10/23.
//

import Foundation

class MovieListInteractor: PresenterToInteractorMovieListProtocol{
    
    var presenter: InteractorToPresenterMovieListProtocol?
    var movieList: [Movie]?
    var genres: [Genre]?
    private var networkClient = NetworkSessionClient<MovieEndpoint>()
    
    func loadAllApi(urlMovieParams: Parameters, isRefresh: Bool) {
        let group = DispatchGroup()
        
        group.enter()
        getGenres { genreResponse in
            self.genres = genreResponse.genres
            group.leave()
        }
        
        group.enter()
        
        getMovieList(by: urlMovieParams) { result in
            self.movieList = result.results
            group.leave()
        }
        
        group.notify(queue: .main) {
            if let movieList = self.movieList, let genres = self.genres {
                self.presenter?.fetchAllApiSuccess(genres: genres, movieList: movieList, isRefresh: isRefresh)
            }
        }
    }
    
    func loadMovieListByGenre(urlParams: Parameters) {
        getMovieList(by: urlParams) { result in
            self.movieList = result.results
            self.presenter?.fetchMovieListByGenreSuccess(movieList: result.results)
        }
    }
    private func getGenres(completion: @escaping(GenreResults) ->()){
        networkClient.requestData(.fetchGenre) { (_ result: Result<GenreResults, NetworkError>) in
            switch result{
            case .success(let response):
                completion(response)
            case .failure(let failure):
                self.presenter?.fetchGenresFailed(errorMsg: failure.descriptionString ?? "")
            }
        }
    }
    private func getMovieList(by urlParams: Parameters, completion: @escaping(MovieListResults) -> ()){
        networkClient.requestData(.fetchMovieByGenre(urlParam: urlParams)) { (_ result: Result<MovieListResults, NetworkError>) in
            switch result{
            case .success(let response):
                completion(response)
            case .failure(let failure):
                self.presenter?.fetchMovieListFailure(errorMsg: failure.descriptionString ?? "")
            }
        }
    }
}
