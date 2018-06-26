//
//  DetailViewController.m
//  ITMSSearch
//
//  Created by Michael Dautermann on 6/25/18.
//  Copyright © 2018 Michael Dautermann. All rights reserved.
//

#import "DetailViewController.h"
#import "SFSearchResultCell.h"
#import "ITMSSearch-Swift.h"

@interface DetailViewController ()

@property (weak) IBOutlet SFImageView *bigPosterImageView;
@property (weak) IBOutlet UITextView *movieDescriptionView;

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.bigPosterImageView.userInteractionEnabled = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    [super viewWillAppear:animated];

    self.navigationItem.title = self.movieObjectToDisplay.name;
    self.bigPosterImageView.imageURL = self.movieObjectToDisplay.posterBigURL;
    self.movieDescriptionView.text = self.movieObjectToDisplay.longDescription;
    
    [[PhotoBrowserCache sharedInstance] performGetPhoto:self.movieObjectToDisplay.posterBigURL intoImageView:self.bigPosterImageView];
}

- (void)viewDidLayoutSubviews
{
    // if text is scrollable, start the text at the top
    [self.movieDescriptionView setContentOffset:CGPointZero animated:NO];
}

@end
