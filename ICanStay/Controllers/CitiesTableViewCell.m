//
//  CitiesTableViewCell.m
//  ICanStay
//
//  Created by Harish on 14/11/16.
//  Copyright © 2016 verticallogics. All rights reserved.
//

#import "CitiesTableViewCell.h"

@implementation CitiesTableViewCell

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
    if (IS_IPAD)
    {
        [self.exploreHotels setFont:[UIFont fontWithName:@"JosefinSans-Light" size:19]];
        [self.cityName setFont:[UIFont fontWithName:@"JosefinSans-Light" size:27]];
    }
    else
    {
        [self.exploreHotels setFont:[UIFont fontWithName:@"JosefinSans-Light" size:17]];
        [self.cityName setFont:[UIFont fontWithName:@"JosefinSans-Light" size:23]];
    }
}

@end
