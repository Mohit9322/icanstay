//
//  CouponList.m
//  ICanStay
//
//  Created by Vertical Logics on 04/04/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import "CouponList.h"
#import "CouponData.h"
@implementation CouponList

+(CouponList*)instanceFromArray:(NSArray *)array{
    
    CouponList *instance = [[CouponList alloc] init];
    [instance setAttributesFromArray:array];
    return instance;
}



- (void)setAttributesFromArray:(NSArray *)arr
{
    self.arrHotelList = [NSMutableArray array];
    for (id valueMember in arr) {
        CouponData *data = [CouponData instanceFromDictionary:valueMember];
        [self.arrHotelList addObject:data];
    }
}


@end
