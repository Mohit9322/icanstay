//
//  CityZoneList.h
//  ICanStay
//
//  Created by Vertical Logics on 08/03/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityZoneList : NSObject
@property (nonatomic,strong)NSMutableArray *arrZoneList;
+(CityZoneList*)instanceFromCityZoneList:(NSArray *)array;

@end
