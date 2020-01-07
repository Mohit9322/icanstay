//
//  CityData.m
//  ICanStay
//
//  Created by Vertical Logics on 04/03/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import "CityData.h"

@implementation CityData

+(CityData *)instanceFromDictionary:(NSDictionary *)dict{
    
    CityData *cityData = [[CityData alloc]init];
    [cityData setAttributesFromDictionary:dict];
    return cityData;
}

- (void)setAttributesFromDictionary:(NSDictionary *)dict{
    self.strCityName = [dict valueForKey:@"CITY_NAME"];
    self.cityId = [dict valueForKey:@"CITY_ID"];
    
    
}
@end
