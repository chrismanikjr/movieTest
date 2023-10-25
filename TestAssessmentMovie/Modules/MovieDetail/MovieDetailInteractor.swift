//
//  MovieDetailInteractro.swift
//  TestAssessmentMovie
//
//  Created by Chrismanto Natanail Manik on 24/10/23.
//

import Foundation

class MovieDetailInteractor: PresenterToInteractorMovieDetailProtocol{
    
    
    var presenter: InteractorToPresenterMovieDetailProtocol?
    
    var movie: Movie?
    private var movieDetail: MovieDetail?
    private var trailers: [Video]?
    private var reviews: MovieReviewsResponse?
    private var networkClient = NetworkSessionClient<MovieEndpoint>()

    func loadAllApi(isRefresh: Bool) {
        let group = DispatchGroup()
        
        group.enter()
        getMovieDetail { movieDetail in
            self.movieDetail = movieDetail
            group.leave()
        }
        
        group.enter()
        getMovieTrailer { movieTrailers in
            self.trailers = movieTrailers
            group.leave()
        }
        
        group.enter()
        getMovieReview { movieReviews in
            self.reviews = movieReviews
            group.leave()
        }
        
        group.notify(queue: .main) {
            if let movieDetail = self.movieDetail, let trailers = self.trailers, let reviews = self.reviews{
                self.presenter?.fetchAllApiSuccess(detail: movieDetail, video: trailers, reviews: reviews, isRefresh: isRefresh)
            }
        }
        
    }
    
    func loadMoreReview() {
        getMovieReview { movieReviews in
            self.presenter?.fetchMoreReviewsSuccess(reviews: movieReviews)
        }
    }
    
    private func getMovieDetail(completion: @escaping(MovieDetail) -> ()){
        networkClient.requestData(.fetchMovieDetail(movieId: movie?.id ?? 0)) { (_ result: Result<MovieDetail, NetworkError>) in
            switch result{
            case .success(let movieDetail):
                completion(movieDetail)
            case .failure(let failure):
                self.presenter?.fetchDetailFailure(errorMsg: failure.descriptionString ?? "")
            }
        }
    }
    
    private func getMovieTrailer(completion: @escaping([Video]) -> ()){
        networkClient.requestData(.fetchMovieTrailer(movieId: movie?.id ?? 0)) { (_ result: Result<VideoResponse, NetworkError>) in
            switch result{
            case .success(let videoResponse):
                let videoType = "Trailer"
                let trailers = videoResponse.results.filter({$0.type == videoType})
                completion(trailers)
            case .failure(let failure):
                self.presenter?.fetchTrailerFailure(errorMsg: failure.descriptionString ?? "")
            }
        }
    }
    
    private func getMovieReview(completion: @escaping(MovieReviewsResponse) -> ()){
        print(movie?.id)
        networkClient.requestData(.fetchMovieReview(movieId: movie?.id ?? 0)) { (_ result: Result<MovieReviewsResponse, NetworkError>) in
            switch result{
            case .success(let movieReviewsResponse):
                completion(movieReviewsResponse)
            case .failure(let failure):
                self.presenter?.fetchReviewsFailure(errorMsg: failure.descriptionString ?? "")
            }
        }
    }

}
