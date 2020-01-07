//
//  CurrentStayHotelData.m
//  ICanStay
//
//  Created by Vertical Logics on 11/03/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import "CurrentStayHotelData.h"

@implementation CurrentStayHotelData

+(CurrentStayHotelData *)instanceFromDictionary:(NSDictionary *)dict{
    
    CurrentStayHotelData *hotelData = [[CurrentStayHotelData alloc]init];
    [hotelData setAttributesFromDictionary:dict];
    return hotelData;
}

- (void)setAttributesFromDictionary:(NSDictionary *)dict{
    self.strHotelName = [dict valueForKey:@"HOTEL_NAME"];
    self.strAddress = [dict valueForKey:@"ADDRESS"];
    self.strBookingDate = [dict valueForKey:@"BookingDate"];
    self.strCity = [dict valueForKey:@"CITY_NAME"];
    self.strState = [dict valueForKey:@"STATE"];
    self.strStayDate = [dict valueForKey:@"StayDate"];
    
    if ([dict valueForKey:@"FeedBackStatus"]) {
        self.numFeedBackReceived = [dict valueForKey:@"FeedBackStatus"];
    }
    self.strHotelName = [[ICSingletonManager sharedManager] removeNullObjectFromString:self.strHotelName];
    self.strAddress = [[ICSingletonManager sharedManager] removeNullObjectFromString:self.strAddress];
    self.strBookingDate = [[ICSingletonManager sharedManager] removeNullObjectFromString:self.strBookingDate];
    self.strStayDate = [[ICSingletonManager sharedManager] removeNullObjectFromString:self.strStayDate];
    self.strCity = [[ICSingletonManager sharedManager] removeNullObjectFromString:self.strCity];
    self.strState = [[ICSingletonManager sharedManager] removeNullObjectFromString:self.strState];
}
@end
