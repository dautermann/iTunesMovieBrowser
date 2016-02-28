//
//  ViewController.m
//  ITMSSearch
//
//  Created by Michael Dautermann on 2/27/16.
//  Copyright © 2016 Michael Dautermann. All rights reserved.
//

#import "ViewController.h"
#import "SFSearchResultCell.h"
#import "MovieObject.h"
#import "DetailViewController.h"

@interface ViewController ()

// private properties accessible from only
// within this view controller
//
// I typically can do these as instance variables (ivars)
// but every company I've ever worked at has different
// approaches and philosophies.  What is your preference??
@property (strong) NSURLSessionDataTask *searchTask;

// useful to dismiss the keyboard
@property (strong) UIGestureRecognizer *tapOutsideSearchBarRecognizer;

@property (weak) IBOutlet UILabel *noMoviesVisibleLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    // stop doing whatever we were doing to cause a memory warning to fire
    if (self.searchTask != nil )
    {
        [self.searchTask cancel];
        self.searchTask = nil;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] compare:@"ShowDetail" options:NSCaseInsensitiveSearch range:NSMakeRange(0,10)] == NSOrderedSame)
    {
        [[self navigationController] setNavigationBarHidden:NO animated:NO];

        NSArray *indexPaths = [self.movieCollectionView indexPathsForSelectedItems];
        NSIndexPath *selectedCell = indexPaths[0];
        
        // Get reference to the destination view controller
        DetailViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        vc.movieObjectToDisplay = [self.movieArray objectAtIndex:selectedCell.row];
    }
}

#pragma mark search bar delegate methods

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if (self.tapOutsideSearchBarRecognizer == nil)
    {
        self.tapOutsideSearchBarRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:searchBar action:@selector(resignFirstResponder)];
    }
    
    [self.view addGestureRecognizer:self.tapOutsideSearchBarRecognizer];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.view removeGestureRecognizer: self.tapOutsideSearchBarRecognizer];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *encodedSearchTerm = [searchBar.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *urlToSearch = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/search?term=%@&entity=movie", encodedSearchTerm]];
    
    if (self.searchTask != nil )
    {
        [self.searchTask cancel];
        self.searchTask = nil;
    }
    
    self.searchTask = [[NSURLSession sharedSession] dataTaskWithURL:urlToSearch completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError *error) {
        
        if (error != nil)
        {
            NSLog(@"error when trying to connect to %@ - %@", urlToSearch.absoluteString, error.localizedDescription);
       
        } else {
            
            NSDictionary *itmsResultDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (error != nil)
            {
                NSLog(@"error when trying to deserialize data from %@ - %@", urlToSearch.absoluteString, error.localizedDescription);
            } else {
                NSArray *rawMovieArray = itmsResultDict[@"results"];
                
                NSMutableArray *movieObjectMutableArray = [[NSMutableArray alloc] initWithCapacity: [rawMovieArray count]];

                NSLog(@"movieArray is %ld", (unsigned long)[rawMovieArray count]);
                
                NSLog(@"%@", rawMovieArray);
                
                for (NSDictionary *movieDictionary in rawMovieArray)
                {
                    MovieObject *newObject = [[MovieObject alloc] initWithDictionary:movieDictionary];
                    [movieObjectMutableArray addObject: newObject];
                }
                
                // replace mutable with immutable ; we won't make any changes to the array
                self.movieArray = movieObjectMutableArray;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([self.movieArray count] > 0)
                    {
                        self.noMoviesVisibleLabel.hidden = YES;
                    }
                    [self.movieCollectionView reloadData];
                });
            }
        }

    }];
    
    [self.searchTask resume];
}

#pragma mark collection view data source methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // only one section
    return [self.movieArray count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SFSearchResultCell *cell = (SFSearchResultCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"SFSearchResultCell" forIndexPath:indexPath];
    
    MovieObject *movieObject = [self.movieArray objectAtIndex:indexPath.row];

    // since the cell needs to retain a copy of MovieObject (for setting/unsetting favorites),
    // we'll just do all the outlet setting in there via this call:
    [cell setCellToMovieObject:movieObject];
    
    return cell;
}

#pragma mark collection view delegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"ShowDetail" sender:self];
}

@end

