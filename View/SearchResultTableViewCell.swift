//
//  SearchResultTableViewCell.swift
//  MoneyTapTask
//
//  Created by Prashant Pandey on 23/07/18.
//  Copyright © 2018 Prashant Pandey. All rights reserved.
//

import UIKit
import SDWebImage

class SearchResultTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var wikiDescription: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupCellDesign()
    }
    
    override func prepareForReuse() {
        profileImageView.image = nil
        title.text = nil
        wikiDescription.text = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupCellDesign() {
        
        wikiDescription.numberOfLines = 0
        containerView.layer.cornerRadius = 6
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.layer.bounds, cornerRadius: 7).cgPath
        containerView.layer.shadowColor = UIColor.lightText.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.shadowRadius = 5
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.masksToBounds = false
        
        
        profileImageView.layer.cornerRadius = profileImageView.bounds.size.width * 0.5
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 1.5
        profileImageView.layer.borderColor = UIColor.lightText.cgColor
    }
    
    func configureCell(_ page: Pages) {
        title.text = "Title"
        if let text = page.title {
            title.text = text
        }
        
        if let imagePath = page.thumbnail {
            if let source = imagePath.source {
                if let url = URL(string: source) {
                    profileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "profile_icon"), options: SDWebImageOptions.cacheMemoryOnly, completed: nil)
                } else {
                    profileImageView.image = UIImage(named: "profile_icon")
                }
            } else {
                profileImageView.image = UIImage(named: "profile_icon")
            }
        } else {
            profileImageView.image = UIImage(named: "profile_icon")
        }
        if let term = page.terms {
            if let desc = term.description {
                var message: String = "Description"
                var i = 0
                for des in desc {
                    if i == 0 {
                        message = des
                    } else {
                        message.append(" \(des)")
                    }
                    i += 1
                }
                wikiDescription.text = message.count == 0 ? "Description" : message
            }
        }
    }

}
