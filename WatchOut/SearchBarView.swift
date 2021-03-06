//
//  SearchBarView.swift
//  WatchOut
//
//  Created by admin on 06/06/2017.
//  Copyright © 2017 quentin. All rights reserved.
//

import UIKit

enum BarSearchState:String {
    case start = "start"
    case ended = "ended"
    case canceled = "canceled"
}

class SearchBarView: UIView {

    @IBOutlet weak var searchBar: UISearchBar!
    
    fileprivate var searchBarShouldBeginEditing = true
    
    var searchStateChanged:((BarSearchState)->())?
    var textChangedAction:((_ searchText:String?)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupSearchBar()
    }
    
    private func setupSearchBar(){
        
        searchBar.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        
        self.searchBar.delegate = self
        
        searchBar.backgroundImage = UIImage()
        
        
        if let textField = self.searchBar.value(forKey: "searchField") as? UITextField {
            //Magnifying glass
            if let glassIconView = textField.leftView as? UIImageView {
                glassIconView.image = #imageLiteral(resourceName: "search")
                glassIconView.tintColor = UIColor.white
            }
            
            let buttonAttribute = [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
                                   NSAttributedString.Key.font : UIFont.woFont(size: 13, weight: .demibold)] as [NSAttributedString.Key : Any]
            
            UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(buttonAttribute, for: .normal)
            
            textField.textColor = UIColor.white
            textField.tintColor = UIColor.white
            
            textField.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1508989726)
            textField.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1508989726).cgColor
            textField.layer.cornerRadius = 12
            textField.clipsToBounds = true
            textField.font = UIFont.woFont(size: 16)
            
            
            searchBar.setImage(#imageLiteral(resourceName: "crossSearch"), for: UISearchBar.Icon.clear, state: .normal)
            searchBar.setImage(#imageLiteral(resourceName: "crossSearch"), for: UISearchBar.Icon.clear, state: .highlighted)
            
        }
        searchBar.keyboardAppearance = .dark
    }

}

extension SearchBarView : UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if !searchBar.isFirstResponder {
            // user tapped the 'clear' button
            searchBarShouldBeginEditing = false
            textChangedAction?(nil)
        }
        else {
            if searchText == "" {
                textChangedAction?(nil)
            }
            else {
                textChangedAction?(searchText)
            }
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        if searchBarShouldBeginEditing {
            searchStateChanged?(.start)
            searchBar.setShowsCancelButton(true, animated: true)
            return true
        }
        else {
            searchBarShouldBeginEditing = true
            return false
        }
        
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        
        searchStateChanged?(.ended)
        searchBar.setShowsCancelButton(false, animated: true)
        
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchStateChanged?(.canceled)
        searchBar.resignFirstResponder()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}
