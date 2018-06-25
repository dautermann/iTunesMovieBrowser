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
@property (weak) IBOutlet NSLayoutConstraint *descriptionTextViewHeight;
@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.bigPosterImageView.userInteractionEnabled = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    [super viewWillAppear:animated];

    self.navigationItem.title = self.movieObjectToDisplay.name;
    self.bigPosterImageView.imageURL = self.movieObjectToDisplay.posterBigURL;
    self.movieDescriptionView.text = self.movieObjectToDisplay.longDescription;

    self.descriptionTextViewHeight.constant = [self.movieDescriptionView sizeThatFits:CGSizeMake(self.movieDescriptionView.frame.size.width, CGFLOAT_MAX)].height;

    [[PhotoBrowserCache sharedInstance] performGetPhoto:self.movieObjectToDisplay.posterBigURL intoImageView:self.bigPosterImageView];
}

@end
