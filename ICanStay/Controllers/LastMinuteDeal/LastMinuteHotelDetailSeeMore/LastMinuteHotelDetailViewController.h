//
//  LastMinuteHotelDetailViewController.h
//  ICanStay
//
//  Created by Planet on 6/16/17.
//  Copyright © 2017 verticallogics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LastMinuteHotelDetailViewController : UIViewController

@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *hotelId;
@property (nonatomic, strong) NSString *cityId;

@property (strong, nonatomic) NSDictionary *hotelDetailDict;
@property (strong, nonatomic) NSDictionary *amentieDetailsDict;


@property (nonatomic, strong) NSString *checkInDate;
@property (nonatomic, strong) NSString *checkoutDate;
@property (nonatomic, strong) NSString *noOfRomms;
@property (nonatomic, strong) NSString *totalAmount;
@property (nonatomic, strong) NSString *offerPrice;
@property (nonatomic, strong) NSString *actualPrice;
@property (nonatomic, strong) NSString *manageSeeMoreHideObjects;
@property (nonatomic, strong) NSString *soldOutHotel;
@property (nonatomic, strong) NSString *offerPriceHotelRoom;
@property (nonatomic, strong) NSString *hotelTitle;

@end
