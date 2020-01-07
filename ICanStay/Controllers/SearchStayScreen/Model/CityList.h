//
//  CityList.h
//  ICanStay
//
//  Created by Vertical Logics on 04/03/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityList : NSObject

@property (nonatomic,retain)NSMutableArray *arrCities;

+(CityList*)instanceFromCityData:(NSArray *)array;

@end
