//
//  MovieDetailViewController.m
//  bootcamp_movies
//
//  Created by Monika Gupta on 9/12/16.
//  Copyright (c) 2016 codepath. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MovieDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;
@property (weak, nonatomic) IBOutlet UILabel *movieOverview;
@property (weak, nonatomic) IBOutlet UIImageView *movieImage;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
//@property (weak, nonatomic) IBOutlet UILabel *ratingIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *popularityLabel;
@property (weak, nonatomic) IBOutlet UIView *detailsView;
@property (weak, nonatomic) IBOutlet UIImageView *crownIcon;

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
    NSURL* imageURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"https://image.tmdb.org/t/p/w342%@", self.movie[@"poster_path"]]];
    [self.movieImage setImageWithURL:imageURL];
    
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

@end
