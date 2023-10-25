//
//  MovieDetailPresenter.swift
//  TestAssessmentMovie
//
//  Created by Chrismanto Natanail Manik on 24/10/23.
//

import Foundation


class MovieDetailPresenter: ViewToPresenterMovieDetailProtocol{
    
    
    
    var view: PresenterToViewMovieDetailProtocol?
    var interactor: PresenterToInteractorMovieDetailProtocol?
    var router: PresenterToRouterMovieDetailProtocol?
    
    var detail: MovieDetail?
    
    var trailers: [Video]?
    var reviews: [MovieReview]?
    var isLoadMore: Bool?

    func viewDidLoad() {
        view?.showLoading()
        fetchData(isRefresh: false)
    }
    
    func refresh() {
        fetchData(isRefresh: true)
    }
    
    func loadMoreReviews() {
        interactor?.loadMoreReview()
    }
    
    private func fetchData(isRefresh: Bool){
        interactor?.loadAllApi(isRefresh: isRefresh)
    }
    
    func setupDetail() -> MovieDetail? {
        guard let movieDetail = self.detail else {return nil}
        
        return movieDetail
    }
    
    func setupVideoCell(indexPath: Int) -> Video? {
        guard let trailers = self.trailers else {return nil}
        
        return trailers[indexPath]
    }
    
    func setupReviewCell(indexPath: Int) -> MovieReview? {
        guard let reviews = self.reviews else {return nil}
        
        return reviews[indexPath]
    }
}

extension MovieDetailPresenter: InteractorToPresenterMovieDetailProtocol{
    func fetchAllApiSuccess(detail: MovieDetail, video: [Video], reviews: MovieReviewsResponse, isRefresh: Bool) {
        self.detail = detail
        self.trailers = video
        self.reviews = reviews.results
        self.isLoadMore = reviews.page != reviews.totalPages
        
        if isRefresh{
            view?.onRefreshSuccess()
        }else{
            view?.onFetchApiSuccess()
        }
    }
    
    func fetchMoreReviewsSuccess(reviews: MovieReviewsResponse) {
        if isLoadMore ?? false{
            self.reviews! += reviews.results
            self.isLoadMore = reviews.page != reviews.totalPages
            view?.onLoadMoreReviewSuccess()
        }
    }
    func fetchReviewsFailure(errorMsg: String) {
        view?.onFetchReviewsFailure(error: errorMsg)
    }
    
    
    func fetchDetailFailure(errorMsg: String) {
        view?.onFetchDetailFailure(error: errorMsg)
    }
    
    func fetchTrailerFailure(errorMsg: String) {
        view?.onFetchTrailerFailure(error: errorMsg)
    }
}
