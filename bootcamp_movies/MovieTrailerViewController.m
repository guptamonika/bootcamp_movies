//
//  MovieTrailerViewController.m
//  bootcamp_movies
//
//  Created by Monika Gupta on 9/15/16.
//  Copyright (c) 2016 codepath. All rights reserved.
//

#import "MovieTrailerViewController.h"
#import "XCDYouTubeVideoPlayerViewController.h"

@implementation MovieTrailerViewController

- (void) viewDidLoad {
    [self playVideo];
}

- (void) playVideo
{
    XCDYouTubeVideoPlayerViewController *videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:@"9bZkp7q19f0"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerPlaybackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:videoPlayerViewController.moviePlayer];
    [self presentMoviePlayerViewControllerAnimated:videoPlayerViewController];
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

@end
