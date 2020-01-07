//
//  IphoneSoldInTableViewCell.h
//  ICanStay
//
//  Created by Planet on 10/31/17.
//  Copyright © 2017 verticallogics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
#import "seeMoreBtn.h"
#import "BookNowBtn.h"

@interface IphoneSoldInTableViewCell : UITableViewCell
@property (strong, nonatomic)                      BaseView  *baseView;
@property (strong, nonatomic)                      UIImageView *hotelImageView;
@property (strong, nonatomic)                      UILabel *hotelNameLbl;
@property (strong, nonatomic)                      UIWebView *hotelDetailwebView;
@property (strong, nonatomic)                      UILabel *actualAndOfferPriceLbl;
@property (strong, nonatomic)                      seeMoreBtn *seeMoreButton;
@property (strong, nonatomic)                      BookNowBtn *bookNowButon;
@property (strong, nonatomic)                      UIImageView *soldOutImgView;
@property (strong, nonatomic)                      UIView *narrowLinePriceBaseView;

@end
