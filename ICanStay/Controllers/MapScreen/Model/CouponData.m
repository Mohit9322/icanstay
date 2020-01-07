//
//  CouponData.m
//  ICanStay
//
//  Created by Vertical Logics on 04/04/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import "CouponData.h"

@implementation CouponData
+(CouponData *)instanceFromDictionary:(NSDictionary *)dict{
    
    CouponData *data = [[CouponData alloc]init];
    [data setAttributesFromDictionary:dict];
    return data;
}

- (void)setAttributesFromDictionary:(NSDictionary *)dict{
    
    
  //  self.strCouponCode = [dict valueForKey:@"CouponCode"];
    self.couponId =         [dict valueForKey:@"CouponDetailId"];
    self.strCouponStartDate = [dict valueForKey:@"CreatedDate"];
    self.strCouponEndDate = [dict valueForKey:@"ExpiryDate"];
    
    //self.strCouponCode = [[ICSingletonManager sharedManager] removeNullObjectFromString:self.strCouponCode];
    self.strCouponStartDate = [[ICSingletonManager sharedManager] removeNullObjectFromString:self.strCouponStartDate];
    self.strCouponEndDate = [[ICSingletonManager sharedManager] removeNullObjectFromString:self.strCouponEndDate];
    
    
    self.strCouponStartDate = [[ICSingletonManager sharedManager] returnFormatedStringDateFromString:self.strCouponStartDate];
    
      self.strCouponEndDate = [[ICSingletonManager sharedManager] returnFormatedStringDateFromString:self.strCouponEndDate];
    
}
@end
