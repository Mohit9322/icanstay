//
//  CouponList.h
//  ICanStay
//
//  Created by Vertical Logics on 04/04/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponList : NSObject
@property (nonatomic)NSMutableArray *arrHotelList;
+(CouponList*)instanceFromArray:(NSArray *)array;

@end
