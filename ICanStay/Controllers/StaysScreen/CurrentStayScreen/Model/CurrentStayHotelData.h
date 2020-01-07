//
//  CurrentStayHotelData.h
//  ICanStay
//
//  Created by Vertical Logics on 11/03/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrentStayHotelData : NSObject
@property (nonatomic,copy)NSString *strHotelName;
@property (nonatomic,copy)NSString *strAddress;
@property (nonatomic,copy)NSString *strState;
@property (nonatomic,copy)NSString *strCity;
@property (nonatomic,copy)NSString *strBookingDate;
@property (nonatomic,copy)NSString *strStayDate;
@property (nonatomic)NSNumber *numFeedBackReceived;
+(CurrentStayHotelData *)instanceFromDictionary:(NSDictionary *)dict;

@end
