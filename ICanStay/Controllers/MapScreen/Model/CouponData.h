//
//  CouponData.h
//  ICanStay
//
//  Created by Vertical Logics on 04/04/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponData : NSObject


@property (nonatomic,strong) NSString *strCouponCode;
@property (nonatomic,copy)   NSNumber *couponId;
@property (nonatomic,copy)  NSString *strCouponStartDate;
@property (nonatomic,copy)  NSString *strCouponEndDate;
+(CouponData *)instanceFromDictionary:(NSDictionary *)dict;

@end
