//
//  NotificationData.m
//  ICanStay
//
//  Created by Vertical Logics on 10/03/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import "NotificationData.h"

@implementation NotificationData


+(NotificationData *)instanceFromDictionary:(NSDictionary *)dict{
    
    NotificationData *notifData = [[NotificationData alloc]init];
    [notifData setAttributesFromDictionary:dict];
    return notifData;
}

- (void)setAttributesFromDictionary:(NSDictionary *)dict
{
    self.msgNotification = [dict valueForKey:@"Message_Desc"];
    self.dateNotification = [dict valueForKey:@"NotificationDate"];
    
    self.dateNotification = [[ICSingletonManager sharedManager] removeNullObjectFromString:self.dateNotification];
    self.msgNotification = [[ICSingletonManager sharedManager] removeNullObjectFromString:self.msgNotification];
}

@end
