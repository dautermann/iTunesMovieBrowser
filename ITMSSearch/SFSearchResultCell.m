//
//  SFSearchResultCell.m
//  ITMSSearch
//
//  Created by Michael Dautermann on 2/27/16.
//  Copyright © 2016 Michael Dautermann. All rights reserved.
//

#import "SFSearchResultCell.h"
#import "UIImage+Extension.h"
#import "NSDate+Extension.h"
#import "UIColor+Extension.h"
#import "ITMSSearch-Swift.h"

@interface SFSearchResultCell ()

@property (weak) IBOutlet SFImageView *posterImageView;
@property (weak) IBOutlet UILabel *nameLabel;
@property (weak) IBOutlet UILabel *yearAndDirectorLabel;

@property (strong) MovieObject *movieObject; // what we're currently rendering
@end

@implementation SFImageView

@end

@implementation SFSearchResultCell

- (void) awakeFromNib
{
    [self registerSelfAsObserverForImageView];
}

- (void) dealloc
{
    [self.posterImageView removeObserver:self forKeyPath:@"image"];
}

- (void) prepareForReuse
{
    self.favoriteButton.selected = NO;

    self.posterImageView.imageURL = nil;
}

- (void) setPosterImageToURL: (NSURL *)imageURL
{
    self.posterImageView.imageURL = imageURL;

    [[PhotoBrowserCache sharedInstance] performGetPhoto:imageURL intoImageView:self.posterImageView];
}

- (void) setCellToMovieObject:(MovieObject *)moToSet
{
    self.movieObject = moToSet;
 
    if ([moToSet.name length] > 0)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.nameLabel.text = moToSet.name;
            
            self.yearAndDirectorLabel.text = [NSString stringWithFormat:@"%@ %@", [moToSet.releaseDate yearAsString], moToSet.director];
            
            self.favoriteButton.selected = moToSet.isFavorite;
            
            [self setPosterImageToURL:moToSet.posterSmallURL];
        });
    }
}

- (IBAction)favoriteButtonTouched:(id)sender
{
    if (self.favoriteButton.selected == NO)
    {
        [[MovieFavoritesController sharedInstance] addMovieID:self.movieObject.movieIDString];
        self.favoriteButton.selected = YES;
        self.movieObject.isFavorite = YES;
    } else {
        [[MovieFavoritesController sharedInstance] removeMovieID:self.movieObject.movieIDString];
        self.favoriteButton.selected = NO;
        self.movieObject.isFavorite = NO;
    }
    
    // I want to add a notification here to tell observers
    // that this movie object's favorite status has changed
}

// Bells & whistles like this are fun to do, but I wish I knew if
// you guys would actually appreciate this work.
- (void)registerSelfAsObserverForImageView
{
    [self.posterImageView addObserver:self
                forKeyPath:@"image"
                   options:(NSKeyValueObservingOptionNew)
                   context:NULL];
}


- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    UIImage *newImage = [change objectForKey:NSKeyValueChangeNewKey];

    [self setMagicFontColorsForImage: newImage];
}

- (void) setMagicFontColorsForImage: (UIImage *)imageToAverage
{
    // this code attempts to set a contrasting text color based on the average color of the image
    UIColor *averageColor = [imageToAverage averageColor];
    UIColor *textColor = [averageColor blackOrWhiteContrastingColor];

    self.nameLabel.textColor = textColor;
    self.yearAndDirectorLabel.textColor = textColor;
}

@end
