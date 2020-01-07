//
//  CurrentStayHotelList.h
//  ICanStay
//
//  Created by Vertical Logics on 11/03/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrentStayHotelList : NSObject
@property (nonatomic)NSMutableArray *arrHotelList;
+(CurrentStayHotelList*)instanceFromArray:(NSArray *)array;

@end
