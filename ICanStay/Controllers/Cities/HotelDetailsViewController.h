//
//  HotelDetailsViewController.h
//  ICanStay
//
//  Created by Harish on 17/11/16.
//  Copyright © 2016 verticallogics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KIImagePager.h"
#import "HCSStarRatingView.h"
@interface HotelDetailsViewController : UIViewController <KIImagePagerDelegate, KIImagePagerDataSource>
{
    NSArray * imageArray;

}
@property (strong, nonatomic) NSDictionary *hotelDict;
@property (strong, nonatomic) NSDictionary *amentiesDict;

@property (weak, nonatomic) IBOutlet UILabel *hotelCity;
@property (weak, nonatomic) IBOutlet KIImagePager *imagePager;
@property (weak, nonatomic) IBOutlet UILabel *hotelDescription;
- (IBAction)buyVoucherTapped:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hotelDescHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UILabel *label6;
@property (weak, nonatomic) IBOutlet UILabel *label7;
@property (weak, nonatomic) IBOutlet UILabel *label8;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *ratingView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *pageerHeight;

@end
