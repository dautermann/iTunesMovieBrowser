//
//  MovieFavoritesController.swift
//  ITMSSearch
//
//  Created by Michael Dautermann on 6/25/18.
//  Copyright © 2018 Michael Dautermann. All rights reserved.
//

import UIKit

// I hope you guys don't mind me using UserDefaults to manage movie favorites for now
//
// I'm designing this so if I had more quality time to work on the app, I could replace this
// with a plist parser, or some magic in CoreData, or calls to a cloud database like Parse (soon to be R.I.P.),
// maintaining the API
class MovieFavoritesController: NSObject {

    @objc static let sharedInstance = MovieFavoritesController()
    
    var favoriteSet : Set<String>?
    
    // http://krakendev.io/blog/the-right-way-to-write-a-singleton
    fileprivate override init() {
        
        super.init()
        
        populateFavoriteSetIfNecessary()
    }

    func populateFavoriteSetIfNecessary()
    {
        let ud = UserDefaults.standard
        
        if favoriteSet == nil
        {
            let favoritesData = ud.object(forKey: "favorite-set") as? Data
            
            if let favoritesData = favoritesData {
                favoriteSet = NSKeyedUnarchiver.unarchiveObject(with: favoritesData) as? Set<String>
                return
            }
            
            // no preference ever saved, create an empty set
            favoriteSet = Set()
        }
    }
    
    @objc func isThisMovieAFavorite(_ movieID : String) -> Bool
    {
        if let _ = favoriteSet?.index(of: movieID)
        {
            return true
        } else {
            return false
        }
    }
    
    func updateToDisk()
    {
        let ud = UserDefaults.standard
        
        let favoriteData = NSKeyedArchiver.archivedData(withRootObject: self.favoriteSet!)
        ud.set(favoriteData, forKey: "favorite-set")
        ud.synchronize()
    }
    
    @objc func addMovieID(_ movieID : String)
    {
        favoriteSet?.insert(movieID)
        
        updateToDisk()
    }
    
    @objc func removeMovieID(_ movieID : String)
    {
        favoriteSet?.remove(movieID)
        
        updateToDisk()
    }
    
    @objc func getAllFavorites() -> Set<String>?
    {
        return favoriteSet
    }
    
}
