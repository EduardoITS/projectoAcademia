//
//  DetailsViewController.swift
//  BookStore_Eduardo
//
//  Created by itsector on 29/01/2020.
//  Copyright © 2020 itsector. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet var bookTitleLabel: UILabel!
    @IBOutlet var bookAuthorLabel: UILabel!
    @IBOutlet var bookDescriptionLabel: UILabel!
    @IBOutlet var favoriteSwitch: UISwitch!
    @IBOutlet var buyButton: UIButton!
    
    var bookTitle = ""
    var bookAuthor = ""
    var bookDescription = ""
    var isFavorite = false
    var buyLink = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bookTitleLabel.text = bookTitle
        bookAuthorLabel.text = bookAuthor
        bookDescriptionLabel.text = bookDescription
        favoriteSwitch.isOn = isFavorite
        
        if(buyLink.isEmpty) {
            buyButton.isHidden = true
        }
        else {
            buyButton.isHidden = false;
        }
    }
    
    @IBAction func buyButtonTouch(_ sender: UIButton) {
        guard let url = URL(string: buyLink) else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func favoriteSwitchTouch(_ sender: UISwitch) {
        
    }
    
}
