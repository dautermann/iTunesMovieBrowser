//
//  SFSearchResultCell.m
//  ITMSSearch
//
//  Created by Michael Dautermann on 2/27/16.
//  Copyright © 2016 Michael Dautermann. All rights reserved.
//

#import "SFSearchResultCell.h"
#import "UIImage+Extension.h"
#import "ITMSSearch-Swift.h"

@interface SFSearchResultCell ()
@property (weak) IBOutlet SFImageView *posterImageView;
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

- (void) setPosterImageToURL: (NSURL *)imageURL
{
    self.posterImageView.imageURL = imageURL;

    [[PhotoBrowserCache sharedInstance] performGetPhoto:imageURL intoImageView:self.posterImageView];
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
    UIColor *averageColor = [imageToAverage averageColor];
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
    [averageColor getRed:&red green:&green blue:&blue alpha:&alpha];
    
    long threshold = 155;
    float bgDelta = ((red * 0.299) + (green * 0.587) + (blue * 0.114));
    
    NSLog(@"255 - bgDelta = %f < %ld", 255 - bgDelta, threshold);
    UIColor *textColor = (255 - bgDelta < threshold) ? [UIColor blackColor] : [UIColor whiteColor] ;
    self.nameLabel.textColor = textColor;
}

@end
