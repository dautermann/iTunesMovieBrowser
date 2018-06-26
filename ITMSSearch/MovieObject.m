//
//  MovieObject.m
//  ITMSSearch
//
//  Created by Michael Dautermann on 6/25/18.
//  Copyright © 2018 Michael Dautermann. All rights reserved.
//

#import "MovieObject.h"
#import "NSDate+Extension.h"
#import "ITMSSearch-Swift.h"
#import "SFSearchResultCell.h"
#import "SFAlertManager.h"

@interface MovieObject ()

@property (strong, readonly) UIImage *posterImage;
@property (strong) NSURLSessionDataTask *fetchTask;

@end

@implementation MovieObject

// designated initializers
- (instancetype)init
{
    self = [super init];
    if (self)
    {

    }
    return self;
}

- (instancetype)initWithMovieID:(NSString *)movieID
{
    self = [super init];
    if (self)
    {
        _movieIDString = movieID;
    }
    return self;
}

- (BOOL)populateMovieFieldsWith:(NSDictionary *)movieDictionary
{
    // I actually prefer to use a property's underlying ivar in init methods
    // for reasons listed in the "Don't Use Accessor Methods in Initializer Methods..." section
    // of this apple documentation ->
    // https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/MemoryMgmt/Articles/mmPractical.html#//apple_ref/doc/uid/TP40004447-SW6
    //
    // but also, more importantly, I purposefully set these properties to be publicly read-only.
    //
    // I suppose I could have set properties to readwrite &/or allowed setters in a private category extension.  Which do you guys prefer?

    // we only want to display single movies, not full collections (e.g. Star Wars six volume set)
    //
    // to do this, single movies are the dictionary objects that have a "trackName" key
    _name = movieDictionary[@"trackName"];
    if(_name == nil)
    {
        return FALSE;
    }
    NSNumber *trackIDNumber = movieDictionary[@"trackId"];
    // I'm surprised trackId coming from ITMS is numeric; I would have expected it to be a UUID-like thing...
    if (trackIDNumber != nil)
    {
        _movieIDString = [trackIDNumber stringValue];
    }
    _director = movieDictionary[@"artistName"];
    _releaseDate = [NSDate dateWithString:movieDictionary[@"releaseDate"]];
    _posterSmallURL = [NSURL URLWithString:movieDictionary[@"artworkUrl100"]];
    _longDescription = movieDictionary[@"longDescription"];
    _shortDescription = movieDictionary[@"shortDescription"]; // only for certain movies
    _isFavorite = [[MovieFavoritesManager sharedInstance] isThisMovieAFavorite:self.movieIDString];

    // I want a big poster
    //
    // http://stackoverflow.com/questions/8781725/larger-itunes-search-api-images
    NSMutableString *posterString = [[NSMutableString alloc] initWithString:movieDictionary[@"artworkUrl100"] ? movieDictionary[@"artworkUrl100"]:@""];
    if ([posterString length] > 0)
    {
        [posterString replaceOccurrencesOfString:@"100x100" withString:@"600x600" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [posterString length])];

        _posterBigURL = [NSURL URLWithString:posterString];
    }
    return TRUE;
}

// yes, this is a duplicate of the code in the SearchViewController and it's
// probably a super duper place to use a single function with a block for the completion
- (void)fetchInformationAboutMovie
{
    NSURL *urlToSearch = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@", self.movieIDString]];
    self.fetchTask = [[NSURLSession sharedSession] dataTaskWithURL:urlToSearch completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil)
        {
            NSLog(@"error when trying to connect to %@ - %@", urlToSearch.absoluteString, error.localizedDescription);
            [[SFAlertManager sharedInstance] displayAlertIfPossible:[NSString stringWithFormat:@"error when trying to connect to server - %@", error.localizedDescription]];
        }
        else
        {
            NSDictionary *itmsResultDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];

            if (error != nil)
            {
                NSLog(@"error when trying to deserialize data from %@ - %@", urlToSearch.absoluteString, error.localizedDescription);
                [[SFAlertManager sharedInstance] displayAlertIfPossible:[NSString stringWithFormat:@"can't decode response from server - %@", error.localizedDescription]];
            }
            else
            {
                NSArray *rawMovieArray = itmsResultDict[@"results"];

                // should only be one entry since we're looking up via ID
                if ([rawMovieArray count] > 0)
                {
                    NSDictionary *movieDictionary = rawMovieArray[0];
                    // NSLog(@"movie dict is %@", movieDictionary);
                    [self populateMovieFieldsWith:movieDictionary];

                    if (self.collectionCell != nil)
                    {
                        [self.collectionCell configureCell];
                    }
                }
            }
        }
    }];

    [self.fetchTask resume];
}

@end
