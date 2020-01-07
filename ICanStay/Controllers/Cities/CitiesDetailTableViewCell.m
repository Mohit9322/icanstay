//
//  CitiesDetailTableViewCell.m
//  ICanStay
//
//  Created by Namit on 17/11/16.
//  Copyright © 2016 verticallogics. All rights reserved.
//

#import "CitiesDetailTableViewCell.h"

@implementation CitiesDetailTableViewCell
@synthesize ratingView;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (IS_IPAD) {
        [self.hotelName setFont:[UIFont fontWithName:@"JosefinSans-Light" size:25]];
        [self.seeMore setFont:[UIFont fontWithName:@"JosefinSans" size:25]];
    }
    else
    {
        [self.hotelName setFont:[UIFont fontWithName:@"JosefinSans-Light" size:22]];
        [self.seeMore setFont:[UIFont fontWithName:@"JosefinSans" size:22]];
    }
}

@end
