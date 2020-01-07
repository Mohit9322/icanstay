//
//  CitiesDetailTableViewCell.h
//  ICanStay
//
//  Created by Namit on 17/11/16.
//  Copyright © 2016 verticallogics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"
@interface CitiesDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *hotelName;
@property (weak, nonatomic) IBOutlet UILabel *hotelDescription;
@property (weak, nonatomic) IBOutlet UIImageView *hotelImage;
@property (weak, nonatomic) IBOutlet UIWebView *hotelDescriptionWebView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeightC;

@property (weak, nonatomic) IBOutlet UILabel *seeMore;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *ratingView;

@property (strong, nonatomic) IBOutlet UIButton *btn_BuyVoucher;

@end
