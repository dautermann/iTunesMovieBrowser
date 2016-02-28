//
//  FavoritesViewController.m
//  ITMSSearch
//
//  Created by Michael Dautermann on 2/27/16.
//  Copyright © 2016 Michael Dautermann. All rights reserved.
//

#import "FavoritesViewController.h"
#import "ITMSSearch-Swift.h"
#import "MovieObject.h"
#import "DetailViewController.h"
#import "SFSearchResultCell.h"

@interface FavoritesViewController ()

@end

@implementation FavoritesViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self updateFavoritesView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateFavoritesView];
}

- (void)updateFavoritesView
{
    NSSet *favoriteSet = [[MovieFavoritesController sharedInstance] getAllFavorites];
    NSMutableArray *movieObjectMutableArray = [[NSMutableArray alloc] initWithCapacity: [favoriteSet count]];
    
    for (NSString *movieID in favoriteSet)
    {
        MovieObject *newObject = [[MovieObject alloc] initWithMovieID:movieID];
        [newObject fetchInformationAboutMovie];
        [movieObjectMutableArray addObject: newObject];
    }
    
    self.movieArray = movieObjectMutableArray;
    
    [self.movieCollectionView reloadData];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SFSearchResultCell *cell = (SFSearchResultCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    // would be nice to allow unfavoriting a cell from within the Favorites View,
    // but we can do that a little later...
    cell.favoriteButton.hidden = YES;
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
