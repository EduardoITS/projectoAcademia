//
//  ListViewController.swift
//  BookStore_Eduardo
//
//  Created by itsector on 29/01/2020.
//  Copyright © 2020 itsector. All rights reserved.
//

import UIKit
import CoreData

import Alamofire
import SDWebImage

class ListViewController: UICollectionViewController {
    
    @IBOutlet var favoritesButton: UIBarButtonItem!
    
    private let sectionInsets = UIEdgeInsets( top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    private let reuseIdentifier = "BookCell"
    private let itemsPerRow: CGFloat = 2
    
    let helper = FavoriteBooksHelper()
    var detailsVC = DetailsViewController()
    
    var bookList: [GoogleApiResponse.book] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchBooks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(favoritesButton.title == "All") {
            let favoriteBooks = helper.getFavoritesList()
            var filteredList: [GoogleApiResponse.book] = []
            for book in bookList {
                if(favoriteBooks.contains(book.id)){
                    filteredList.append(book)
                }
            }
            bookList = filteredList
            self.collectionView.reloadData()
        }
    }

    // fetch data with Alamofire
    func fetchBooks(){
        let url = "https://www.googleapis.com/books/v1/volumes?q=ios&maxResults=20&startIndex=0"
        
        AF.request(url, method: .get)
        .validate()
            .responseDecodable(of: GoogleApiResponse.self) { response in
                
            if(response.value?.items != nil)
            {
                self.bookList = response.value!.items
            }
            
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func favoritesButtonTouch(_ sender: UIBarButtonItem) {
        if(favoritesButton.title == "Favorites") {
            let favoriteBooks = helper.getFavoritesList()
            var filteredList: [GoogleApiResponse.book] = []
            for book in bookList {
                if(favoriteBooks.contains(book.id)){
                    filteredList.append(book)
                }
            }
            bookList = filteredList
            self.collectionView.reloadData()
            favoritesButton.title = "All"
        } else {
            self.fetchBooks()
            favoritesButton.title = "Favorites"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DetailsSegue",
            let destinationVC = segue.destination as? DetailsViewController {
                detailsVC = destinationVC
        }
    }
}



// UICollectionViewDataSource
extension ListViewController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return bookList.count
  }
  
  override func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BookPhotoCell
                                                  
    let bookPhotoUrl = photo(for: indexPath)
    cell.backgroundColor = .white
    cell.imageView.sd_setImage(with: URL(string: bookPhotoUrl), placeholderImage: UIImage(named: "Placeholder.png"))
      
    return cell
  }
}

// Collection View Flow Layout Delegate
extension ListViewController : UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
    let availableWidth = view.frame.width - paddingSpace
    let widthPerItem = availableWidth / itemsPerRow
    
    return CGSize(width: widthPerItem, height: widthPerItem)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return sectionInsets
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return sectionInsets.left
  }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedBook = bookList[indexPath.row]
        
        detailsVC.bookId = selectedBook.id
        detailsVC.bookTitle = selectedBook.volumeInfo.title
        detailsVC.bookAuthor = selectedBook.volumeInfo.authors?.first ?? ""
        detailsVC.bookDescription = selectedBook.volumeInfo.description ?? ""
        detailsVC.buyLink = selectedBook.saleInfo.buyLink ?? ""

        detailsVC.isFavorite = helper.isFavorite(bookId: selectedBook.id)
        
        self.shouldPerformSegue(withIdentifier: "DetailsSegue", sender: self)
    }
}

private extension ListViewController {
  func photo(for indexPath: IndexPath) -> String {
    return bookList[indexPath.row].volumeInfo.imageLinks.smallThumbnail
  }
}

