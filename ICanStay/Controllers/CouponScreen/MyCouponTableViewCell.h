//
//  MyCouponTableViewCell.h
//  ICanStay
//
//  Created by Namit on 01/04/16.
//  Copyright © 2016 verticallogics. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  MyCouponTableViewCellDelegate <NSObject>

-(void)switchToShareExperienceScreenWithDictionary:(NSDictionary *)dict;

@end

@interface MyCouponTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *destinationName;
@property (weak, nonatomic) IBOutlet UILabel *couponCode;
@property (weak, nonatomic) IBOutlet UILabel *dateOfStay;

@property (weak, nonatomic) IBOutlet UIButton *btnShareYourFeedback;
@property (nonatomic)NSDictionary *dictCouponData;
@property (nonatomic) id<MyCouponTableViewCellDelegate>m_delegate;

- (IBAction)btnShareExperienceTapped:(id)sender;

@end
