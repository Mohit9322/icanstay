//
//  MapScreen.h
//  ICanStay
//
//  Created by Vertical Logics on 08/03/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapScreen : UIViewController
@property(nonatomic)BOOL isByCurrentLocation;
@property (nonatomic) BOOL isByCity;
@property (strong, nonatomic) NSString        *isFromPurchasedVooucherScreen;
@property (strong, nonatomic) NSString        *alertMasgFromPurchasedVoucher;
@end
