//
//  SFSearchResultCell.h
//  ITMSSearch
//
//  Created by Michael Dautermann on 2/27/16.
//  Copyright © 2016 Michael Dautermann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieObject.h"

@interface SFImageView : UIImageView
@property (strong) NSURL *imageURL;
@end

@interface SFSearchResultCell : UICollectionViewCell

- (void) setCellToMovieObject: (MovieObject *)moToSet;

@end
