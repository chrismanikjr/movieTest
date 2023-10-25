//
//  MovieListRouter.swift
//  TestAssessmentMovie
//
//  Created by Chrismanto Natanail Manik on 23/10/23.
//

import UIKit

class MovieListRouter: PresenterToRouterMovieListProtocol{
    static func createModule() -> UINavigationController {
        let viewController = MovieListViewController()
        viewController.navigationItem.backButtonTitle = ""

        let navController = UINavigationController(rootViewController: viewController)
        
        
        let presenter: ViewToPresenterMovieListProtocol & InteractorToPresenterMovieListProtocol = MovieListPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = MovieListRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = MovieListInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return navController
    }
    
    func pushToMovieDetail(on view: PresenterToViewMovieListProtocol, with movie: Movie) {
        let movieDetailVC = MovieDetailRouter.createModule(with: movie)
        let viewController = view as! MovieListViewController
        viewController.navigationController?.pushViewController(movieDetailVC, animated: true)
    }
}
