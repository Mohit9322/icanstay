//
//  RedeemCouponCell.h
//  ICanStay
//
//  Created by Vertical Logics on 04/04/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

@protocol RedeemCouponCellDelegate <NSObject>

-(BOOL)checkIfCouponNumberExceedsPermittedNumberWithCouponId:(NSNumber *)couponId;

@end

#import <UIKit/UIKit.h>
#import "UIActionButton.h"
@class CouponData;
@interface RedeemCouponCell : UITableViewCell

- (IBAction)btnCheckBoxTapped:(id)sender;

@property (strong, nonatomic)  UIButton *bnCheckbox;
@property (strong, nonatomic)  UILabel *strCouponCode;

@property (strong, nonatomic)  UILabel *strCouponStartAndEndDate;

@property (weak, nonatomic) IBOutlet UILabel *strCouponEndDate;
@property (nonatomic , strong) UIImageView *baseImageView;
@property (nonatomic ,strong)  UILabel *luxStayVoucher;

@property (nonatomic,weak)id<RedeemCouponCellDelegate>m_delegate;
@property (nonatomic)CouponData * couponData;
@property (nonatomic,weak) UIActionButton *selectCheckBox;
-(void)settingCouponValues:(CouponData *)couponData;
@end
