//
//  RedeemCouponCell.m
//  ICanStay
//
//  Created by Vertical Logics on 04/04/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import "RedeemCouponCell.h"
#import "CouponData.h"
@implementation RedeemCouponCell

- (void)awakeFromNib {
    
     [super awakeFromNib];
    // Initialization code
   
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _baseImageView = [[UIImageView alloc]init];
        _baseImageView.image = [UIImage imageNamed:@"NoVoucherPopupImage"];
        _baseImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_baseImageView];
        
        self.strCouponCode = [[UILabel alloc]init];
        self.strCouponCode.textAlignment = NSTextAlignmentCenter;
        self.strCouponCode.textColor = [UIColor whiteColor];
        self.strCouponCode.font = [UIFont systemFontOfSize:20];
        
        [_baseImageView addSubview:self.strCouponCode];
        
        self.bnCheckbox = [UIButton buttonWithType:UIButtonTypeRoundedRect];
      
        [self.bnCheckbox setBackgroundImage:[UIImage imageNamed:@"voucherListChkBox"] forState:UIControlStateNormal];
        [self.bnCheckbox addTarget:self action:@selector(btnCheckBoxTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_baseImageView addSubview:self.bnCheckbox];
        
        _luxStayVoucher = [[UILabel alloc]init];
        _luxStayVoucher.textAlignment = NSTextAlignmentCenter;
        _luxStayVoucher.textColor = [UIColor whiteColor];
        _luxStayVoucher.font = [UIFont systemFontOfSize:20];
        _luxStayVoucher.text = @"Luxury Stay Voucher";
        [_baseImageView addSubview:_luxStayVoucher];
        
        self.strCouponStartAndEndDate = [[UILabel alloc]init];
        self.strCouponStartAndEndDate.textAlignment = NSTextAlignmentCenter;
        self.strCouponStartAndEndDate.font = [UIFont systemFontOfSize:20];
        self.strCouponStartAndEndDate.textColor = [UIColor whiteColor];
        [_baseImageView addSubview:self.strCouponStartAndEndDate];
        
        
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)settingCouponValues:(CouponData *)couponData{
     [self.bnCheckbox setBackgroundImage:[UIImage imageNamed:@"voucherListChkBox"] forState:UIControlStateNormal];
    self.couponData = couponData;
    [self.strCouponCode setText:couponData.strCouponCode];
    [self.strCouponStartAndEndDate setText:[NSString stringWithFormat:@"VALID FROM %@ To %@",couponData.strCouponStartDate,couponData.strCouponEndDate]];
  //  [self.strCouponEndDate setText:couponData.strCouponEndDate];
}

- (void)btnCheckBoxTapped:(id)sender {
    
   
    if ([self.m_delegate respondsToSelector:@selector(checkIfCouponNumberExceedsPermittedNumberWithCouponId:)]) {
   BOOL canProceed = [self.m_delegate checkIfCouponNumberExceedsPermittedNumberWithCouponId:self.couponData.couponId];
        if (canProceed) {
            UIButton *btn = (UIButton *)sender;
            
            UIImage *image = [btn backgroundImageForState:UIControlStateNormal];
            
            if ([image isEqual: [UIImage imageNamed:@"voucherListChkBox"]]) {
                image = [UIImage imageNamed:@"voucherChkBoxSelected"];
                
                [btn setBackgroundImage:image forState:UIControlStateNormal];
                
            }
            else{
                image = [UIImage imageNamed:@"voucherListChkBox"];
                [btn setBackgroundImage:image forState:UIControlStateNormal];
                
            }

        }
    }
    
    
}
@end
