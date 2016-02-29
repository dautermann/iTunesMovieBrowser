//
//  PhotoBrowserCache.swift
//  LevelMoney500pxBrowser
//
//  Created by Michael Dautermann on 2/18/16.
//  Copyright © 2016 Michael Dautermann. All rights reserved.
//

import Foundation
import UIKit

@objc class PhotoBrowserCache: NSObject, NSURLSessionDelegate, NSURLSessionTaskDelegate {
    
    static let sharedInstance = PhotoBrowserCache()
    
    var cacheFolderURL : NSURL
    
    var urlSession : NSURLSession
    
    // http://krakendev.io/blog/the-right-way-to-write-a-singleton
    private override init() {
        
        // I dislike having to do these "placeholder" temporary property settings before doing the real thing
        // later on. more info at: http://stackoverflow.com/a/28431379/981049
        urlSession = NSURLSession.sharedSession()
        cacheFolderURL = NSURL(fileURLWithPath: "/tmp")
        
        super.init()
        
        let cachesDirectory = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)
        
        if cachesDirectory.count > 0
        {
            cacheFolderURL = NSURL(fileURLWithPath: cachesDirectory[0])
        } else {
            print("uh oh... there is no cache folder in this sandbox! -- guess we'll use /tmp for now")
        }
        
        urlSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue: NSOperationQueue.mainQueue())
    }
    
    // if I have any time, I would write a hash function
    // to match the behavior that a URL shortner might be using
    func getFilenameFromURL(urlToFetch: NSURL) -> String
    {
        let originalURLString = "\(urlToFetch.path)\(urlToFetch.parameterString)"
        return originalURLString.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
    }
    
    func performGetPhoto(urlToFetch: NSURL, intoImageView imageView: SFImageView)
    {
        // our crafty (and simple) cache simply saves the very unique (or UUID-looking) filename 
        // into the caches folder...
        let cacheFilename = getFilenameFromURL(urlToFetch)
        let cachedFilenameURL = cacheFolderURL.URLByAppendingPathComponent(cacheFilename)

        let imageData = NSData.init(contentsOfURL: cachedFilenameURL)
        
        if let imageData = imageData
        {
            let image = UIImage(data: imageData)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                imageView.image = image
            })
        }

        let request = NSMutableURLRequest(URL: urlToFetch)
        
        request.HTTPMethod = "GET"
        
        let task = urlSession.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            // the data that comes back isn't JSON, but instead it's picture data!
            if let data = data
            {
                let image = UIImage(data: data)
                
                if let imageViewURL = imageView.imageURL
                {
                    if imageViewURL.isEqual(urlToFetch) == true
                    {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            imageView.image = image
                        })
                    }

                    do {
                        try data.writeToURL(cachedFilenameURL, options: .AtomicWrite)
                    } catch let error as NSError {
                        print("couldn't write data to \(cachedFilenameURL.absoluteString) - \(error.localizedDescription)")
                    }
                }
            } else {
                print("got an error when fetching from \(request.URL?.absoluteString) - \(error?.localizedDescription)")
                
                SFAlertController.sharedInstance().displayAlertIfPossible("Didn't get a picture back")
            }
        })
        task.resume()
    }
}

