//
//  CityList.m
//  ICanStay
//
//  Created by Vertical Logics on 04/03/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import "CityList.h"
#import "CityData.h"

@implementation CityList



+(CityList*)instanceFromCityData:(NSArray *)array{
    CityList *instance = [[CityList alloc] init];
   
    
    [instance setAttributesFromArray:array];
    return instance;
}



- (void)setAttributesFromArray:(NSArray *)arr{
 
    self.arrCities = [NSMutableArray array];
    for (id valueMember in arr) {
        CityData *cityData = [CityData instanceFromDictionary:valueMember];
        [self.arrCities addObject:cityData];
    }
    
    
}
@end
