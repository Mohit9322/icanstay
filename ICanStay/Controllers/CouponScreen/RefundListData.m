//
//  RefundListData.m
//  
//
//  Created by Vertical Logics on 13/05/16.
//
//

#import "RefundListData.h"

@implementation RefundListData
+(RefundListData *)instanceFromDictionary:(NSDictionary *)dict{
    
    RefundListData *hotelData = [[RefundListData alloc]init];
    [hotelData setAttributesFromDictionary:dict];
    return hotelData;
}

//*strCreatedDate;
//@property (nonatomic,copy)NSString *strExpiryDate;
//@property (nonatomic,copy)NSString *strName;
//@property (nonatomic,copy)NSString *strCouponCode;


- (void)setAttributesFromDictionary:(NSDictionary *)dict{
    self.strCreatedDate = [dict valueForKey:@"CreatedDate"];
    self.strExpiryDate = [dict valueForKey:@"ExpiryDate"];
    self.strName = [dict valueForKey:@"Name"];
    self.strCouponCode = [dict valueForKey:@"CouponCode"];
    
    
    
//    if ([dict valueForKey:@"FeedBackStatus"]) {
//        self.numFeedBackReceived = [dict valueForKey:@"FeedBackStatus"];
//    }
    self.strCreatedDate = [[ICSingletonManager sharedManager] removeNullObjectFromString:self.strCreatedDate];
    self.strExpiryDate = [[ICSingletonManager sharedManager] removeNullObjectFromString:self.strExpiryDate];
    self.strName = [[ICSingletonManager sharedManager] removeNullObjectFromString:self.strName];
    self.strCouponCode = [[ICSingletonManager sharedManager] removeNullObjectFromString:self.strCouponCode];
    
//    self.strCity = [[ICSingletonManager sharedManager] removeNullObjectFromString:self.strCity];
//    self.strState = [[ICSingletonManager sharedManager] removeNullObjectFromString:self.strState];
}

@end
