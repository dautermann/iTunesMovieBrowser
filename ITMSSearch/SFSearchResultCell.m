//
//  SFSearchResultCell.m
//  ITMSSearch
//
//  Created by Michael Dautermann on 6/25/18.
//  Copyright © 2018 Michael Dautermann. All rights reserved.
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
@property (weak) IBOutlet UILabel *shortDescriptionLabel;

@property (strong) MovieObject *movieObject; // what we're currently rendering
@end

@implementation SFImageView

@end

@implementation SFSearchResultCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self registerSelfAsObserverForImageView];

    [self.posterImageView.layer setOpacity:0.6f];
}

- (void)dealloc
{
    [self.posterImageView removeObserver:self forKeyPath:@"image"];
}

- (void)prepareForReuse
{
    if (self.movieObject != nil)
    {
        // tell the about-to-be-forgotten movie object to forget about us
        self.movieObject.collectionCell = nil;
        // and forget the movie object (because we're about to get reused)
        self.movieObject = nil;
    }
    self.favoriteButton.selected = NO;

    self.posterImageView.imageURL = nil;

    self.posterImageView.image = nil;
}

- (void)setPosterImageToURL:(NSURL *)imageURL
{
    self.posterImageView.imageURL = imageURL;

    [[PhotoBrowserCache sharedInstance] performGetPhoto:imageURL intoImageView:self.posterImageView];
}

- (void)configureCell
{
    if ([self.movieObject.name length] > 0)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.nameLabel.text = self.movieObject.name;

            self.yearAndDirectorLabel.text = [NSString stringWithFormat:@"%@ %@", [self.movieObject.releaseDate yearAsString], self.movieObject.director];

            self.shortDescriptionLabel.text = self.movieObject.shortDescription;

            self.favoriteButton.selected = self.movieObject.isFavorite;

            // the 100 x 100 simply looks too grainy to be sexy, so we'll use the BIG poster...
            //
            // the only issue might be on large iPads where a lot of images are on screen.
            //
            // if I see any memory warnings during extensive testing, I'd probably want to
            // write a UIImage category to generate thumbnails directly from this big UIImage object
            [self setPosterImageToURL:self.movieObject.posterBigURL];
        });
    }
}

- (void)setCellToMovieObject:(MovieObject *)moToSet
{
    self.movieObject = moToSet;

    [self configureCell];
}

- (IBAction)favoriteButtonTouched:(id)sender
{
    if (self.favoriteButton.selected == NO)
    {
        [[MovieFavoritesController sharedInstance] addMovieID:self.movieObject.movieIDString];
        self.favoriteButton.selected = YES;
        self.movieObject.isFavorite = YES;
    }
    else
    {
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

    // sometimes we get NSNull back...
    if ([newImage isKindOfClass:[UIImage class]])
    {
        [self setMagicFontColorsForImage:newImage];
    }
}

- (void)setMagicFontColorsForImage:(UIImage *)imageToAverage
{
    // this code attempts to set a contrasting text color based on the average color of the image
    UIColor *averageColor = [imageToAverage averageColor];
    UIColor *textColor = [averageColor blackOrWhiteContrastingColor];

    self.nameLabel.textColor = textColor;
    self.yearAndDirectorLabel.textColor = textColor;
    self.shortDescriptionLabel.textColor = textColor;
}

@end
