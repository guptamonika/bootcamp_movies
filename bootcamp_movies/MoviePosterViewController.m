//
//  MoviePosterViewController.m
//  bootcamp_movies
//
//  Created by Monika Gupta on 9/15/16.
//  Copyright (c) 2016 codepath. All rights reserved.
//

#import "MoviePosterViewController.h"
#import "Utils.h"

@interface MoviePosterViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *posterScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *posterImageOutlet;
@property (nonatomic, strong) Utils *utils;

@end
@implementation MoviePosterViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *imageUrl = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/original%@", self.movie[@"poster_path"]];
    NSString *lowImageUrl = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/w45%@", self.movie[@"poster_path"]];
    self.utils = [[Utils alloc]init];
    [self.utils loadImageWithEffect:self.posterImageOutlet :imageUrl :lowImageUrl];
    
    self.posterScrollView.delegate = self;
    self.posterScrollView.minimumZoomScale = 0.25;
    self.posterScrollView.maximumZoomScale = 2;
    self.posterScrollView.contentSize = CGSizeMake(self.posterScrollView.frame.size.width, self.posterImageOutlet.frame.size.height);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.posterImageOutlet;
}
@end

