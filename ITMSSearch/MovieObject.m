//
//  MovieObject.m
//  ITMSSearch
//
//  Created by Michael Dautermann on 2/27/16.
//  Copyright © 2016 Michael Dautermann. All rights reserved.
//

#import "MovieObject.h"
#import "NSDate+Extension.h"
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
        _posterSmallURL = [NSURL URLWithString: movieDictionary[@"artworkUrl30"]];
        _posterMediumURL = [NSURL URLWithString: movieDictionary[@"artworkUrl60"]];
        _posterBigURL = [NSURL URLWithString: movieDictionary[@"artworkUrl100"]];
    }
    return self;
}

- (UIImage *) thumbnailImage{
    
    return nil;
}

@end
