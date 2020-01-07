    //
//  MyCouponCollectionViewCell.h
//  ICanStay
//
//  Created by Namit on 01/04/16.
//  Copyright © 2016 verticallogics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCouponCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;

@property (weak, nonatomic) IBOutlet UILabel *couponMessage;
@property (weak, nonatomic) IBOutlet UILabel *couponExpiryDate;
@property (weak, nonatomic) IBOutlet UILabel *couponTitle;
@property (weak, nonatomic) IBOutlet UILabel *couponStartDate;
@property (weak, nonatomic) IBOutlet UILabel *lblRefundRequested;
@property (strong, nonatomic) IBOutlet UIButton *btn_Checkmark;

@end
