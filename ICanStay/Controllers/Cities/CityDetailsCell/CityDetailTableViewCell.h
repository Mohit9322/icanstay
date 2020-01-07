//
//  CityDetailTableViewCell.h
//  ICanStay
//
//  Created by Planet on 11/3/17.
//  Copyright © 2017 verticallogics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
#import "seeMoreBtn.h"
#import "BookNowBtn.h"

@interface CityDetailTableViewCell : UITableViewCell
@property (strong, nonatomic)                      BaseView  *baseView;
@property (strong, nonatomic)                      UIImageView *hotelImageView;
@property (strong, nonatomic)                      UILabel *hotelNameLbl;
@property (strong, nonatomic)                      UIWebView *hotelDetailwebView;
@property (strong, nonatomic)                      seeMoreBtn *seeMoreButton;
@property (strong, nonatomic)                      BookNowBtn *BuyVoucherBtn;
@end
