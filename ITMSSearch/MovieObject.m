//
//  MovieObject.m
//  ITMSSearch
//
//  Created by Michael Dautermann on 2/27/16.
//  Copyright © 2016 Michael Dautermann. All rights reserved.
//

#import "MovieObject.h"
#import "NSDate+Extension.h"
#import "ITMSSearch-Swift.h"
#import <UIKit/UIKit.h>

@interface MovieObject ()

@property (strong, readonly) UIImage *posterImage;

@end

@implementation MovieObject

// designated initializer
- (instancetype) initWithDictionary: (NSDictionary *) movieDictionary
{
    self = [super init];
    if(self)
    {
        // I actually prefer to use a property's underlying ivar in init methods
        // for reasons listed in the "Don't Use Accessor Methods in Initializer Methods..." section
        // of this apple documentation ->
        // https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/MemoryMgmt/Articles/mmPractical.html#//apple_ref/doc/uid/TP40004447-SW6
        _name = movieDictionary[@"trackName"];
        _director = movieDictionary[@"artistName"];
        _releaseDate = [NSDate dateWithString: movieDictionary[@"releaseDate"]];
        _posterSmallURL = [NSURL URLWithString: movieDictionary[@"artworkUrl100"]];
        _longDescription = movieDictionary[@"longDescription"];
        
        NSNumber *trackIDNumber = movieDictionary[@"trackId"];
        // I'm surprised trackId coming from ITMS is numeric; I would have expected it to be a UUID-like thing...
        if(trackIDNumber!= nil)
        {
            _movieIDString = [trackIDNumber stringValue];
            _isFavorite = [[MovieFavoritesController sharedInstance] isThisMovieAFavorite:_movieIDString];
        }
        
        // I want a big poster
        //
        // http://stackoverflow.com/questions/8781725/larger-itunes-search-api-images
        NSMutableString *posterString = [[NSMutableString alloc] initWithString:movieDictionary[@"artworkUrl100"]];
        if([posterString length] > 0)
        {
            [posterString replaceOccurrencesOfString:@"100x100" withString:@"600x600" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [posterString length])];
            
            _posterBigURL = [NSURL URLWithString: posterString];
        }
    }
    return self;
}

- (UIImage *) thumbnailImage{
    
    return nil;
}

@end
