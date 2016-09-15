//
//  MovieTableViewCell.m
//  bootcamp_movies
//
//  Created by Monika Gupta on 9/12/16.
//  Copyright (c) 2016 codepath. All rights reserved.
//

#import "MovieTableViewCell.h"

@implementation MovieTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
