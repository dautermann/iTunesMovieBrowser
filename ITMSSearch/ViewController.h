//
//  ViewController.h
//  ITMSSearch
//
//  Created by Michael Dautermann on 6/25/18.
//  Copyright © 2018 Michael Dautermann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate>

@property (strong) NSArray *movieArray;
@property (weak) IBOutlet UICollectionView *movieCollectionView;

@end
