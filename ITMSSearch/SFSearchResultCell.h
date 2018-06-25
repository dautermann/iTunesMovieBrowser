//
//  SFSearchResultCell.h
//  ITMSSearch
//
//  Created by Michael Dautermann on 6/25/18.
//  Copyright © 2018 Michael Dautermann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieObject.h"

@interface SFImageView : UIImageView
@property (strong) NSURL *imageURL;
@end

@interface SFSearchResultCell : UICollectionViewCell

@property (weak) IBOutlet UIButton *favoriteButton;

- (void)configureCell;
- (void)setCellToMovieObject:(MovieObject *)moToSet;

@end
