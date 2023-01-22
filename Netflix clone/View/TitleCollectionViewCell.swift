//
//  TitleCollectionViewCell.swift
//  Netflix clone
//
//  Created by Varun Bagga on 27/12/22.
//

import UIKit
import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell {
    
    
    static let identifier = "TitleCollectionViewCell"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        contentView.addSubview(posterImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //LayoutSubviews() is a method that is called on a UIView object in the UIKit framework when the layout of its subviews needs to be updated. This method is usually called automatically by the system when the layout of a view or its subviews changes, such as when the view's frame changes or when new subviews are added.
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
    
    public func configure(with model:String){
        guard let url = URL(string:"https://image.tmdb.org/t/p/w500/\(model)") else{
            return
        }
//        print(model)
        posterImageView.sd_setImage(with: url)
    }
    
    
}
