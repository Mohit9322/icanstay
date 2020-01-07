//
//  NotificationData.h
//  ICanStay
//
//  Created by Vertical Logics on 10/03/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationData : NSObject
@property (nonatomic,copy)NSString *msgNotification,*dateNotification;
+(NotificationData *)instanceFromDictionary:(NSDictionary *)dict;

@end
