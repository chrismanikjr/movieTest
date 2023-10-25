//
//  ReusableImageView.swift
//  TestAssessmentMovie
//
//  Created by Chrismanto Natanail Manik on 23/10/23.
//

import UIKit
import Combine
class ReusableImage: UIImageView{
    enum ImageStyle{
        case small
        case medium
        case big
        case rating
    }
    
    public private(set) var styleImg: ImageStyle
    

    private var cancellable: AnyCancellable?

    
    init(styleImg: ImageStyle) {
        self.styleImg = styleImg
        super.init(frame: .zero)
        configureImage()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("Init coder cant implement")
    }
    
    private func configureImage(){
        switch styleImg {
        case .small:
            self.setSize(width: 40, height: 40)

        case .medium:
            self.setSize(width: 80, height: 120)

        case .big:
            self.setSize(width: Size.widthScreen, height: Size.widthScreen * 0.7)
        case .rating:
            self.setSize(width: 20, height: 20)
            self.image = Images.favoriteSelectd
        }
    }
    
    
    func changeImageUrl(urlString: String, isCircle: Bool){
        cancellable = loadImage(for: urlString).sink(receiveValue: { image in
            self.image = image
            if isCircle{
                self.clipsToBounds = true
                self.layer.cornerRadius = self.bounds.height / 2
            }
        })
    }
    
    private func loadImage(for imageUrl: String) -> AnyPublisher<UIImage?, Never> {
        return Just(imageUrl)
            .flatMap({ poster -> AnyPublisher<UIImage?, Never> in
                let url = URL(string: imageUrl)!
                return ImageLoader.shared.loadImage(from: url)
            })
            .eraseToAnyPublisher()
    }
}
