//
//  NotificationList.h
//  ICanStay
//
//  Created by Vertical Logics on 10/03/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationList : NSObject

@property (nonatomic)NSMutableArray *arrNotificationList;
+(NotificationList*)instanceFromNotificationList:(NSArray *)array;

@end
