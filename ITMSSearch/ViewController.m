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

@interface ViewController ()

// private properties accessible from only
// within this view controller
//
// I typically can do these as instance variables (ivars)
// but every company I've ever worked at has different
// approaches and philosophies.  What is your preference??
@property (strong) NSURLSessionDataTask *searchTask;
@property (strong) NSArray *movieArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
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

#pragma mark search bar delegate methods

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
            NSArray *rawMovieArray = itmsResultDict[@"results"];

            NSMutableArray *movieObjectMutableArray = [[NSMutableArray alloc] initWithCapacity: [rawMovieArray count]];
            if (error != nil)
            {
                NSLog(@"error when trying to deserialize data from %@ - %@", urlToSearch.absoluteString, error.localizedDescription);
            } else {
                NSLog(@"movieArray is %ld", [rawMovieArray count]);
                
                NSLog(@"%@", rawMovieArray);
                
                for (NSDictionary *movieDictionary in rawMovieArray)
                {
                    MovieObject *newObject = [[MovieObject alloc] initWithDictionary:movieDictionary];
                    [movieObjectMutableArray addObject: newObject];
                }
                
                // replace mutable with immutable ; we won't make any changes to the array
                self.movieArray = movieObjectMutableArray;
            }
        }

    }];
    
    NSLog(@"supposedly starting self.searchTask %@", self.searchTask);
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
    
    // probably move this logic into a movie object
//    NSString *dateString = movieDictionary[@"releaseDate"];
    
    cell.nameLabel.text = movieObject.name;
    
//    cell.yearAndDirectorLabel = [NSString stringWithFormat:@"%@ %@", yearString, [movieDictionary[@"artistName"]];
    
    return cell;
}

@end

