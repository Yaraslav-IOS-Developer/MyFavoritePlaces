//
//  CustomTableViewCell.swift
//  MyFavoritePlaces
//
//  Created by Yaroslav on 2.02.21.
//

import UIKit
import Cosmos

class CustomTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var imageOfPlace: UIImageView!
    @IBOutlet weak var shadowImageOfPlaceView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView! {
        didSet {
            cosmosView.settings.updateOnTouch = false
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupTopView()
        setupImageOfPlace()
    }
    

    // MARK: - Methods
    private func setupImageOfPlace() {
        
        imageOfPlace.layer.cornerRadius = imageOfPlace.frame.size.height / 2
        shadowImageOfPlaceView.layer.cornerRadius = imageOfPlace.frame.size.height / 2
        
        addShadow(view: shadowImageOfPlaceView, opacity: 0.8, x: 2, y: 3, radius: 6)
    
    }
    
    private func setupTopView() {
        
        topView.layer.cornerRadius = 20
        addShadow(view: topView, opacity: 0.4, x: 2, y: 3, radius: 4)
    }
    
    private func addShadow(view: UIView, opacity: Float, x: Int, y: Int, radius: CGFloat) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = opacity
        view.layer.shadowOffset = CGSize(width: x, height: y)
        view.layer.shadowRadius = radius
    }
    
    
    func configureCell(_ place: Place) {
        nameLabel.text = place.name
        locationLabel.text = place.location
        typeLabel.text = place.type
        imageOfPlace.image = UIImage(data: place.imageData!)
        cosmosView.rating = place.rating
        
    }
    
}
