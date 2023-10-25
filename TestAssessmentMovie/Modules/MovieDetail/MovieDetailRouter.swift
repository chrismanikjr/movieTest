//
//  MovieDetailRouter.swift
//  TestAssessmentMovie
//
//  Created by Chrismanto Natanail Manik on 23/10/23.
//

import UIKit

class MovieDetailRouter: PresenterToRouterMovieDetailProtocol{
    static func createModule(with movie: Movie) -> UIViewController {
        let viewController = MovieDetailViewController()
        let presenter: ViewToPresenterMovieDetailProtocol & InteractorToPresenterMovieDetailProtocol = MovieDetailPresenter()

        viewController.presenter = presenter
        viewController.presenter?.router = MovieDetailRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = MovieDetailInteractor()
        viewController.presenter?.interactor?.movie = movie
        viewController.presenter?.interactor?.presenter = presenter

        return viewController
    }
}
