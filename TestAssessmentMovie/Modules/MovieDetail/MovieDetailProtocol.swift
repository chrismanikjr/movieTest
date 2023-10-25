//
//  MovieDetailProtocol.swift
//  TestAssessmentMovie
//
//  Created by Chrismanto Natanail Manik on 23/10/23.
//

import UIKit

protocol ViewToPresenterMovieDetailProtocol{
    var view: PresenterToViewMovieDetailProtocol? {get set}
    var interactor: PresenterToInteractorMovieDetailProtocol? {get set}
    var router: PresenterToRouterMovieDetailProtocol? {get set}
    var detail: MovieDetail? {get set}
    var trailers: [Video]? {get set}
    var reviews: [MovieReview]? {get set}
    var isLoadMore: Bool? {get set}
    func setupDetail() -> MovieDetail?
    func setupVideoCell(indexPath: Int) -> Video?
    func setupReviewCell(indexPath: Int) -> MovieReview?
    func viewDidLoad()
    func refresh()
    func loadMoreReviews()
}
protocol PresenterToViewMovieDetailProtocol{
    func onFetchApiSuccess()
    func onLoadMoreReviewSuccess()
    func onRefreshSuccess()

    func onFetchDetailFailure(error: String)
    func onFetchTrailerFailure(error: String)
    func onFetchReviewsFailure(error: String)
    func showLoading()
}

protocol PresenterToInteractorMovieDetailProtocol{
    var presenter: InteractorToPresenterMovieDetailProtocol? {get set}
    var movie: Movie? { get set }
    func loadAllApi(isRefresh: Bool)
    func loadMoreReview()
}

protocol InteractorToPresenterMovieDetailProtocol{
    func fetchAllApiSuccess(detail: MovieDetail , video: [Video], reviews: MovieReviewsResponse, isRefresh: Bool)
    func fetchMoreReviewsSuccess(reviews: MovieReviewsResponse)
    func fetchDetailFailure(errorMsg: String)
    func fetchTrailerFailure(errorMsg: String)
    func fetchReviewsFailure(errorMsg: String)
}

protocol PresenterToRouterMovieDetailProtocol{
    static func createModule(with Movie: Movie) -> UIViewController
}
