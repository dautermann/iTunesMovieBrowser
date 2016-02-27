//
//  SFSearchResultCell.h
//  ITMSSearch
//
//  Created by Michael Dautermann on 2/27/16.
//  Copyright © 2016 Michael Dautermann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFImageView : UIImageView
@property (strong) NSURL *imageURL;
@end

@interface SFSearchResultCell : UICollectionViewCell

@property (weak) IBOutlet UILabel *nameLabel;
@property (weak) IBOutlet UILabel *yearAndDirectorLabel;

- (void) setPosterImageToURL: (NSURL *)imageURL;

@end
