//
//  SideMenuCell.m
//  ICanStay
//
//  Created by Namit Aggarwal on 25/02/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import "SideMenuCell.h"

@implementation SideMenuCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
//    UIView * selectedBackgroundView = [[UIView alloc] init];
//    //244,142,32
//    [selectedBackgroundView setBackgroundColor:[UIColor colorWithRed:0.956f green:0.556f blue:0.125f alpha:1]]; // set color here
//    [self setSelectedBackgroundView:selectedBackgroundView];
    // Configure the view for the selected state
}

@end
