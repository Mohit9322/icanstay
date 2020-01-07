//
//  NotificationList.m
//  ICanStay
//
//  Created by Vertical Logics on 10/03/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import "NotificationList.h"
#import "NotificationData.h"
@implementation NotificationList

+(NotificationList*)instanceFromNotificationList:(NSArray *)array{
    
    NotificationList *instance = [[NotificationList alloc] init];
    
    
    [instance setAttributesFromArray:array];
    return instance;
}



- (void)setAttributesFromArray:(NSArray *)arr{
    
    self.arrNotificationList = [NSMutableArray array];
    for (id valueMember in arr) {
        NotificationData *notificationData = [NotificationData instanceFromDictionary:valueMember];
        [self.arrNotificationList addObject:notificationData];
    }
    
    
}

@end
