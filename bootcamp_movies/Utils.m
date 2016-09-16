//
//  Utils.m
//  bootcamp_movies
//
//  Created by Monika Gupta on 9/15/16.
//  Copyright (c) 2016 codepath. All rights reserved.
//

#import "Utils.h"
#import <Foundation/Foundation.h>
#import "UIImageView+AFNetworking.h"

@interface Utils ()
@end

@implementation Utils

- (void) loadImageWithEffect:(UIImageView *) imageViewHolder :(NSString*) url  :(NSString*) lowImageUrlStr{
    __weak UIImageView* weakimageViewHolder = imageViewHolder;
    NSURL *imageURL, *imageURL2;
    if (lowImageUrlStr == nil) {
        imageURL = [[NSURL alloc] initWithString:url];
        imageURL2 = nil;
    } else {
        imageURL = [[NSURL alloc] initWithString:lowImageUrlStr];
        imageURL2 = [[NSURL alloc] initWithString:url];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
    
    [weakimageViewHolder setImageWithURLRequest:request
                               placeholderImage:[UIImage imageNamed:@"placeholder"]
                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                            if (response == nil) { // from cache. do not animate
                                                [weakimageViewHolder setImage:image];
                                            } else {
                                                weakimageViewHolder.alpha = 0.0;
                                                [weakimageViewHolder setImage:image];
                                                [UIView animateWithDuration:1.0
                                                                 animations:^{
                                                                     weakimageViewHolder.alpha = 1.0;
                                                                 }
                                                 ];
                                            }
                                            // if we have loaded the low res right now
                                            if (imageURL2 != nil) {
                                                
                                                NSURLRequest *request2 = [NSURLRequest requestWithURL:imageURL2];
                                                [weakimageViewHolder setImageWithURLRequest:request2
                                                                           placeholderImage:[UIImage imageNamed:@"placeholder"]
                                                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                        [weakimageViewHolder setImage:image];
                                                                                    }
                                                                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                        NSLog(@"image load fail");
                                                                                    }
                                                 ];
                                            }
                                        }
                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                            NSLog(@"image load fail");
                                        }
     ];
}

@end