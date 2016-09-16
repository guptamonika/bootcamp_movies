//
//  MovieDetailViewController.m
//  bootcamp_movies
//
//  Created by Monika Gupta on 9/12/16.
//  Copyright (c) 2016 codepath. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MovieViewController.h"
#import "Utils.h"
#import "XCDYouTubeVideoPlayerViewController.h"

@interface MovieDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;
@property (weak, nonatomic) IBOutlet UILabel *movieOverview;
@property (weak, nonatomic) IBOutlet UIImageView *movieImage;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *releaseDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *popularityLabel;
@property (weak, nonatomic) IBOutlet UIView *detailsView;
@property (weak, nonatomic) IBOutlet UIImageView *crownIcon;
@property (nonatomic, strong) Utils *utils;
- (IBAction)playTrailor:(id)sender;

@end

@implementation MovieDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.utils =[[Utils alloc]init];
    // Do any additional setup after loading the view.
    self.movieTitle.text = self.movie[@"title"];
    self.movieOverview.text = self.movie[@"overview"];
    [self.movieOverview sizeToFit];

    // Date formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    //[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate *releaseDate = [dateFormatter dateFromString:self.movie[@"release_date"]];
    dateFormatter.dateFormat = @"MMM dd, yyyy";
    self.releaseDateLabel.text = [dateFormatter stringFromDate:releaseDate];
    
    // popularity
    self.popularityLabel.text = [NSString stringWithFormat:@"%2.0f%%", [self.movie[@"vote_average"] floatValue] * 10] ;
    //[self.ratingIconLabel setFont:[UIFont fontWithName:@"IcoMoon-Free" size:130]];
    //[self.ratingIconLabel setText:[NSString stringWithUTF8String:"\ue9d9"]];
    self.crownIcon.image = [UIImage imageNamed:@"crown.png"];

    //scrollview
    CGRect frame = self.detailsView.frame;
    frame.size.height = self.movieOverview.frame.size.height + self.movieOverview.frame.origin.y + 10;
    self.detailsView.frame = frame;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,  100 + self.detailsView.frame.origin.y + self.detailsView.frame.size.height);
 
    // show the image
    NSString *imageUrl = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/original%@", self.movie[@"poster_path"]];
    NSString *lowImageUrl = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/w45%@", self.movie[@"poster_path"]];
                     
    [self.utils loadImageWithEffect:self.movieImage :imageUrl :lowImageUrl];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// start video functions
- (void) playVideo
{
    NSString *urlString = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed", self.movie[@"id"]];
    
    //get the movies from API
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSession *session =
    [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                  delegate:nil
                             delegateQueue:[NSOperationQueue mainQueue]];
    
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
                                                    NSString *vidid = responseDictionary[@"results"][0][@"key"];
                                                    XCDYouTubeVideoPlayerViewController *videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:vidid];
                                                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerPlaybackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:videoPlayerViewController.moviePlayer];
                                                    [self presentMoviePlayerViewControllerAnimated:videoPlayerViewController];
                                                    
                                                    
                                                } else {
                                                    NSLog(@"An error occurred: %@", error.description);
                                                }
                                            }];
    [task resume];

    }

- (void) moviePlayerPlaybackDidFinish:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:notification.object];
    MPMovieFinishReason finishReason = [notification.userInfo[MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] integerValue];
    if (finishReason == MPMovieFinishReasonPlaybackError)
    {
        NSError *error = notification.userInfo[XCDMoviePlayerPlaybackDidFinishErrorUserInfoKey];
        // Handle error
    }
}
// end video functions


- (IBAction)playTrailor:(id)sender {
    [self playVideo];
}
@end
