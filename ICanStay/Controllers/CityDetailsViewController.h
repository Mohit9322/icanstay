//
//  CityDetailsViewController.h
//  ICanStay
//
//  Created by Planet on 11/3/17.
//  Copyright © 2017 verticallogics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityDetailsViewController : UIViewController
@property (strong, nonatomic) NSString *cityId;
@property (strong, nonatomic) NSString *cityNameStr;
@property (strong, nonatomic) NSString *cityDescriptionStr;
@property (strong,nonatomic)  NSArray *arrayHotelList;
@property (strong,nonatomic)  NSArray *availableAmenties;
@end
