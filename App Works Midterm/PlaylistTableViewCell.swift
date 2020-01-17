//
//  TableViewCell.swift
//  App Works Midterm
//
//  Created by FISH on 2020/1/17.
//  Copyright © 2020 FISH. All rights reserved.
//

import UIKit
import Kingfisher

class PlaylistTableViewCell: UITableViewCell {
    
    @IBOutlet weak var albumImageView: UIImageView!
    
    @IBOutlet weak var albumNameLabel: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    var playlist: Playlist? {
        didSet {
            guard let playlist = playlist else { return }
            albumImageView.kf.setImage(with: URL(string:  playlist.album.images[0].url))
            albumNameLabel.text = playlist.name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
}
