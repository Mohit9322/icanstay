//
//  IphoneSoldInTableViewCell.m
//  ICanStay
//
//  Created by Planet on 10/31/17.
//  Copyright © 2017 verticallogics. All rights reserved.
//

#import "IphoneSoldInTableViewCell.h"

@implementation IphoneSoldInTableViewCell

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
        self.hotelDetailwebView.backgroundColor = [UIColor whiteColor];
        [self.baseView addSubview:self.hotelDetailwebView];
        
        self.actualAndOfferPriceLbl  = [[UILabel alloc]init];
           self.actualAndOfferPriceLbl.textAlignment = NSTextAlignmentLeft;
        self.actualAndOfferPriceLbl.textColor = [UIColor blackColor];
        [self.baseView addSubview:self.actualAndOfferPriceLbl];
        
        self.narrowLinePriceBaseView = [[UIView alloc]init];
        self.narrowLinePriceBaseView.backgroundColor = [UIColor grayColor];
        [self.baseView addSubview:self.narrowLinePriceBaseView];
         
        self.seeMoreButton = [[seeMoreBtn alloc]init];
          [self.seeMoreButton setTitle:@"SEE MORE" forState:UIControlStateNormal];
        [self.seeMoreButton setTintColor:[UIColor blackColor]];
        self.seeMoreButton.layer.cornerRadius = 5.0;
        [self.seeMoreButton useRedDeleteStyle];
       
        [self.baseView addSubview:self.seeMoreButton];
        
        self.bookNowButon = [[BookNowBtn alloc]init];
        [self.bookNowButon setTitle:@"BOOK NOW" forState:UIControlStateNormal];
        [self.bookNowButon setTintColor:[UIColor blackColor]];
        self.bookNowButon.layer.cornerRadius = 5.0;
        [self.bookNowButon useRedDeleteStyle];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
             [self.bookNowButon.titleLabel setFont:[UIFont systemFontOfSize:20]];
             [self.seeMoreButton.titleLabel setFont:[UIFont systemFontOfSize:20]];
        }else{
            [self.bookNowButon.titleLabel setFont:[UIFont systemFontOfSize:14]];
             [self.seeMoreButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        }
       
        [self.baseView addSubview:self.bookNowButon];
     
        self.soldOutImgView = [[UIImageView alloc]init];
        [self.baseView addSubview:self.soldOutImgView];
        
    }
    
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
