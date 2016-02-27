//
//  DetailViewController.m
//  ITMSSearch
//
//  Created by Michael Dautermann on 2/27/16.
//  Copyright © 2016 Michael Dautermann. All rights reserved.
//

#import "DetailViewController.h"
#import "SFSearchResultCell.h"
#import "ITMSSearch-Swift.h"

@interface DetailViewController ()

@property (weak) IBOutlet SFImageView *bigPosterImageView;

@property (weak) IBOutlet UILabel *movieNameLabel;
@property (weak) IBOutlet UITextView *movieDescriptionView;

@end

@implementation DetailViewController

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
    [self.navigationController setNavigationBarHidden:NO];
    [super viewWillAppear:animated];
    
    self.movieNameLabel.text = self.movieObjectToDisplay.name;
    self.bigPosterImageView.imageURL = self.movieObjectToDisplay.posterBigURL;
    self.movieDescriptionView.text = self.movieObjectToDisplay.longDescription;
    
    [[PhotoBrowserCache sharedInstance] performGetPhoto:self.movieObjectToDisplay.posterBigURL intoImageView:self.bigPosterImageView];
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
