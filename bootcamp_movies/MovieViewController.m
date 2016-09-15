//
//  MovieViewController.m
//  bootcamp_movies
//
//  Created by Monika Gupta on 9/12/16.
//  Copyright (c) 2016 codepath. All rights reserved.
//

#import "MovieViewController.h"
#import "MovieTableViewCell.h"
#import "MovieCollectionViewCell.h"
#import "MovieDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MovieNavigationControllerViewController.h"
#import "MBProgressHUD.h"

@interface MovieViewController () <UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) NSArray *filteredMovies;
@property (nonatomic, strong) NSArray *layoutOptions;
@property (nonatomic) BOOL filtered;
@property (nonatomic, strong) NSString *template;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *layoutControl;

@end

@implementation MovieViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // table view dataSource and delegate to self
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchBar.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;

    self.layoutOptions = [NSArray arrayWithObjects: @"list",@"grid",nil];
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(getMovies) forControlEvents:UIControlEventValueChanged];
    
    self.title = self.navigationController.title;
    self.template = self.layoutOptions[self.layoutControl.selectedSegmentIndex];
    [self changeLayout:self.template];
}

- (void) viewDidAppear:(BOOL)animated {
    self.errorLabel.hidden = true;
    self.template = self.layoutOptions[self.layoutControl.selectedSegmentIndex];
    [self changeLayout:self.template];
    [self getMovies];
}

- (void) getMovies {
    MovieNavigationControllerViewController *currentNavController = self.navigationController;
    
    NSString *apiKey = @"a07e22bc18f5cb106bfe4cc1f83ad8ed";
    NSString *urlString = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@?api_key=%@",currentNavController.endpoint, apiKey];
    
    [self getDataFromAPI:urlString];
}

- (void) getDataFromAPI: (NSString*) urlString {
    
    //get the movies from API
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSession *session =
    [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                  delegate:nil
                             delegateQueue:[NSOperationQueue mainQueue]];
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * data,
                                                                NSURLResponse * response,
                                                                NSError * error) {
                                                if (!error) {
                                                    NSError *jsonError = nil;
                                                    NSDictionary *responseDictionary =
                                                    [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:kNilOptions
                                                                                      error:&jsonError];
                                                    NSLog(@"Response: %@", responseDictionary);
                                                    self.movies = responseDictionary[@"results"];
                                                    [self.tableView reloadData];
                                                    [self.collectionView reloadData];
                                                } else {
                                                    NSLog(@"An error occurred: %@", error.description);
                                                    self.errorLabel.hidden = false;
                                                    self.tableView.hidden = true;
                                                }
                                                [self.refreshControl endRefreshing];
                                                [MBProgressHUD hideHUDForView:self.view animated:true];
                                                
                                            }];
    [task resume];

}
// start table functions
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.filtered) {
        return self.filteredMovies.count;
    } else {
        return self.movies.count;
    }

}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieTableViewCell"];
    NSDictionary *movie;
    if (self.filtered) {
        movie = self.filteredMovies[indexPath.row];
    } else {
        movie = self.movies[indexPath.row];
    }
    cell.title.text = movie[@"title"];
    cell.overview.text = movie[@"overview"];
    NSURL* imageURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"https://image.tmdb.org/t/p/w342%@", movie[@"poster_path"]]];
    [cell.image setImageWithURL:imageURL];
                       
    return cell;
}
// end of table functions

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// start search bar functions
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"search bar text changed");
    NSPredicate *bPredicate;
    if ([searchText isEqualToString:@""]) {
        self.filtered = NO;
        self.filteredMovies = nil;
    } else {
        self.filtered = YES;
        bPredicate = [NSPredicate predicateWithFormat:@"SELF.title BEGINSWITH[cd] %@",searchText];
        
        // filter movies
        self.filteredMovies = [self.movies filteredArrayUsingPredicate:bPredicate];
        
    }
    
    // refresh the table
    [self.tableView reloadData];

}
// end search bar functions

// start segmentedcontrol functions
- (IBAction)changeTemplate:(id)sender {
    self.template = self.layoutOptions[self.layoutControl.selectedSegmentIndex];
    [self changeLayout:self.template];
}

- (void) changeLayout:(NSString*) template {
    if([template isEqualToString:@"list"]) {
        self.tableView.hidden = false;
        self.collectionView.hidden = true;
    } else {
        self.tableView.hidden = true;
        self.collectionView.hidden = false;
    }
}

// end segmentedcontrol functions

// start collectionview functions
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.filtered) {
        return self.filteredMovies.count;
    } else {
        return self.movies.count;
    }
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionViewCell" forIndexPath:indexPath];
    NSDictionary *movie;
    if (self.filtered) {
        movie = self.filteredMovies[indexPath.row];
    } else {
        movie = self.movies[indexPath.row];
    }
    
    NSURL* imageURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"https://image.tmdb.org/t/p/w342%@", movie[@"poster_path"]]];
    [cell.collectionMovie setImageWithURL:imageURL];
    cell.movieName.text = movie[@"title"];
    
    return cell;
}

// end collectionview functions

// start segue functions
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goToDetail" ] || [segue.identifier isEqualToString:@"goToDetailGrid"]) {
        NSIndexPath *indexPath;
        if([self.template isEqualToString:@"list"]) {
            UITableViewCell *cell = sender;
            indexPath = [self.tableView indexPathForCell:cell];
        } else {
            UICollectionViewCell *cell = sender;
            indexPath = [self.collectionView indexPathForCell:cell];
        }

        MovieDetailViewController *movieViewController = segue.destinationViewController;
        movieViewController.movie = self.movies[indexPath.row];
    }
}
// end segue functions

@end
