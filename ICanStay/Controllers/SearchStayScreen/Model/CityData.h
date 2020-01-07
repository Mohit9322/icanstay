//
//  CityData.h
//  ICanStay
//
//  Created by Vertical Logics on 04/03/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityData : NSObject

@property (nonatomic,copy)NSString *strCityName;
@property (nonatomic,retain)NSNumber *cityId;


+(CityData *)instanceFromDictionary:(NSDictionary *)dict;
@end
