//
//  CityZone.m
//  ICanStay
//
//  Created by Vertical Logics on 08/03/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import "CityZone.h"

@implementation CityZone
+(CityZone *)instanceFromDictionary:(NSDictionary *)dict{
    
    CityZone *cityZone = [[CityZone alloc]init];
    [cityZone setAttributesFromDictionary:dict];
    return cityZone;
}

- (void)setAttributesFromDictionary:(NSDictionary *)dict{
    self.zoneName = [dict valueForKey:@"Text"];
    
    
}
@end
