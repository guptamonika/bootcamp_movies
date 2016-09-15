//
//  MovieCollectionViewCell.h
//  bootcamp_movies
//
//  Created by Monika Gupta on 9/14/16.
//  Copyright (c) 2016 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *collectionMovie;
@property (weak, nonatomic) IBOutlet UILabel *movieName;

@end
