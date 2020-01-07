//
//  RefundCouponCell.m
//  
//
//  Created by Vertical Logics on 16/05/16.
//
//

#import "RefundCouponCell.h"
#import "RefundListData.h"
@implementation RefundCouponCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnSelectTapped:(id)sender {
    UIButton *btn = (UIButton *)sender;
    UIImage *image = [btn backgroundImageForState:UIControlStateNormal];
    
    if ([image isEqual: [UIImage imageNamed:@"checkbox"]]) {
        image = [UIImage imageNamed:@"checkbox_selected"];
       // [self.txtPassword setSecureTextEntry:NO];
        [btn setBackgroundImage:image forState:UIControlStateNormal];
        
        
        
    }
    else{
        image = [UIImage imageNamed:@"checkbox"];
        [btn setBackgroundImage:image forState:UIControlStateNormal];
     //   [self.txtPassword setSecureTextEntry:YES];
    }
    
    if ([self.m_delegate respondsToSelector:@selector(addOrRemoveCouponFromArray:)]) {
       [ self.m_delegate addOrRemoveCouponFromArray:self.refundData.strCouponCode];
    }
    

}


//*strCreatedDate;
//@property (nonatomic,copy)NSString *strExpiryDate;
//@property (nonatomic,copy)NSString *strName;
//@property (nonatomic,copy)NSString *strCouponCode;


- (void)settingRefundValuesFrom:(RefundListData *)refundData
{
    self.refundData = refundData;
    
    [self.lblCouponCode setText:refundData.strCouponCode];
    [self.lblValidFrom setText:refundData.strCreatedDate];
    [self.lblValidTill setText:refundData.strExpiryDate];
    
    [self.btnSelect setBackgroundImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];

    
}

@end
