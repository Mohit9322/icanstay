//
//  MyCouponTableViewCell.m
//  ICanStay
//
//  Created by Namit on 01/04/16.
//  Copyright © 2016 verticallogics. All rights reserved.
//

#import "MyCouponTableViewCell.h"

@implementation MyCouponTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnShareExperienceTapped:(id)sender {
    if ([self.m_delegate respondsToSelector:@selector(switchToShareExperienceScreenWithDictionary:)]) {
        [self.m_delegate  switchToShareExperienceScreenWithDictionary:self.dictCouponData];
    }
    
//    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Coming Soon" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    
//    [alert show];
}
@end
