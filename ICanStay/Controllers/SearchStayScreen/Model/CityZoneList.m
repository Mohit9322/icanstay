//
//  CityZoneList.m
//  ICanStay
//
//  Created by Vertical Logics on 08/03/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import "CityZoneList.h"
#import "CityZone.h"

@implementation CityZoneList

+(CityZoneList*)instanceFromCityZoneList:(NSArray *)array{

    CityZoneList *instance = [[CityZoneList alloc] init];
    
    
    [instance setAttributesFromArray:array];
    return instance;
}



- (void)setAttributesFromArray:(NSArray *)arr{
    
    self.arrZoneList = [NSMutableArray array];
    for (id valueMember in arr) {
        CityZone *cityData = [CityZone instanceFromDictionary:valueMember];
        [self.arrZoneList addObject:cityData];
    }
    
    
}

@end
