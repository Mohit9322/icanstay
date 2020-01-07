//
//  CityDetailTableViewCell.m
//  ICanStay
//
//  Created by Planet on 11/3/17.
//  Copyright © 2017 verticallogics. All rights reserved.
//

#import "CityDetailTableViewCell.h"

@implementation CityDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.baseView = [[BaseView alloc]init];
        self.baseView.layer.borderColor = [ICSingletonManager colorFromHexString:@"#bd9854"].CGColor;
        self.baseView.layer.borderWidth = 2.0;
        [self.contentView addSubview:self.baseView];
        
        self.hotelImageView = [[UIImageView alloc]init];
        [self.baseView addSubview:self.hotelImageView];
        
        self.hotelNameLbl = [[UILabel alloc]init];
        self.hotelNameLbl.textAlignment = NSTextAlignmentCenter;
        [self.baseView addSubview:self.hotelNameLbl];
        
        self.hotelDetailwebView = [[UIWebView alloc]init];
        self.hotelDetailwebView.scrollView.scrollEnabled = NO;
        [self.baseView addSubview:self.hotelDetailwebView];
        
        self.seeMoreButton = [[seeMoreBtn alloc]init];
        [self.seeMoreButton setTitle:@"SEE MORE" forState:UIControlStateNormal];
        [self.seeMoreButton setTintColor:[UIColor blackColor]];
        self.seeMoreButton.layer.cornerRadius = 5.0;
        [self.seeMoreButton useRedDeleteStyle];
       
        [self.baseView addSubview:self.seeMoreButton];
        
        self.BuyVoucherBtn = [[BookNowBtn alloc]init];
        [self.BuyVoucherBtn setTitle:@"BUY VOUCHER" forState:UIControlStateNormal];
        [self.BuyVoucherBtn setTintColor:[UIColor blackColor]];
        self.BuyVoucherBtn.layer.cornerRadius = 5.0;
        [self.BuyVoucherBtn useRedDeleteStyle];
       
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
             [self.seeMoreButton.titleLabel setFont:[UIFont systemFontOfSize:20]];
             [self.BuyVoucherBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
        }else{
             [self.seeMoreButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
             [self.BuyVoucherBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        }
        [self.baseView addSubview:self.BuyVoucherBtn];
        
 
    }
    
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
