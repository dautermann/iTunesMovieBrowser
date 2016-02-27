//
//  MovieFavoritesController.swift
//  ITMSSearch
//
//  Created by Michael Dautermann on 2/27/16.
//  Copyright © 2016 Michael Dautermann. All rights reserved.
//

import UIKit


// I hope you guys don't mind me using NSUserDefaults to manage movie favorites for now
//
// I'm designing this so if I had more quality time to work on the app, I could replace this
// with a plist parser, or some magic in CoreData, or calls to a cloud database like Parse (soon to be R.I.P.),
// maintaining the API
class MovieFavoritesController: NSObject {

    static let sharedInstance = MovieFavoritesController()
    
    var favoriteSet : Set<String>?
    
    // http://krakendev.io/blog/the-right-way-to-write-a-singleton
    private override init() {
        
        super.init()
        
    }

    func populateFavoriteSetIfNecessary()
    {
        let ud = NSUserDefaults.standardUserDefaults()
        
        if favoriteSet == nil
        {
            let favoritesData = ud.objectForKey("favorite-set") as? NSData
            
            if let favoritesData = favoritesData {
                favoriteSet = NSKeyedUnarchiver.unarchiveObjectWithData(favoritesData) as? Set<String>
                print(favoriteSet)
                return
            }
            
            // no preference ever saved, create an empty set
            favoriteSet = Set()
        }
    }
    
    func isThisMovieAFavorite(movieID : String) -> Bool
    {
        populateFavoriteSetIfNecessary()
        
        if let _ = favoriteSet?.indexOf(movieID)
        {
            return true
        } else {
            return false
        }
    }
    
    func updateToDisk()
    {
        let ud = NSUserDefaults.standardUserDefaults()
        
        let favoriteData = NSKeyedArchiver.archivedDataWithRootObject(self.favoriteSet!)
        ud.setObject(favoriteData, forKey: "favorite-set")
        ud.synchronize()
    }
    
    func addMovieID(movieID : String)
    {
        populateFavoriteSetIfNecessary()

        favoriteSet?.insert(movieID)
        
        updateToDisk()
    }
    
    func removeMovieID(movieID : String)
    {
        populateFavoriteSetIfNecessary()
        
        favoriteSet?.remove(movieID)
        
        updateToDisk()
    }
    
}
