//
//  MovieTableViewCell.h
//  bootcamp_movies
//
//  Created by Monika Gupta on 9/12/16.
//  Copyright (c) 2016 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *overview;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIButton *toPosterButton;

@end
