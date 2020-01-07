//
//  CurrentStayHotelList.m
//  ICanStay
//
//  Created by Vertical Logics on 11/03/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import "CurrentStayHotelList.h"
#import "CurrentStayHotelData.h"
@implementation CurrentStayHotelList

+(CurrentStayHotelList*)instanceFromArray:(NSArray *)array{
    
    CurrentStayHotelList *instance = [[CurrentStayHotelList alloc] init];
    [instance setAttributesFromArray:array];
    return instance;
}



- (void)setAttributesFromArray:(NSArray *)arr
{
    self.arrHotelList = [NSMutableArray array];
    for (id valueMember in arr) {
        CurrentStayHotelData *hotelData = [CurrentStayHotelData instanceFromDictionary:valueMember];
        [self.arrHotelList addObject:hotelData];
    }
}


@end
