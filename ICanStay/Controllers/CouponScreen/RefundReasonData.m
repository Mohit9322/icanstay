//
//  RefundReasonData.m
//  
//
//  Created by Vertical Logics on 13/05/16.
//
//

#import "RefundReasonData.h"

@implementation RefundReasonData
+(RefundReasonData *)instanceFromDictionary:(NSDictionary *)dict{
    
    RefundReasonData *hotelData = [[RefundReasonData alloc]init];
    [hotelData setAttributesFromDictionary:dict];
    return hotelData;
}
//
//@property (nonatomic,strong)NSString *strRefundReason;
//@property (nonatomic)NSNumber *numReasonId;

- (void)setAttributesFromDictionary:(NSDictionary *)dict{
    self.strRefundReason = [dict valueForKey:@"Refund_Reason"];
    self.numReasonId = [dict valueForKey:@"Reason_Id"];
    
    
    
    //    if ([dict valueForKey:@"FeedBackStatus"]) {
    //        self.numFeedBackReceived = [dict valueForKey:@"FeedBackStatus"];
    //    }
    //    self.strHotelName = [[ICSingletonManager sharedManager] removeNullObjectFromString:self.strHotelName];
    //    self.strAddress = [[ICSingletonManager sharedManager] removeNullObjectFromString:self.strAddress];
    //    self.strBookingDate = [[ICSingletonManager sharedManager] removeNullObjectFromString:self.strBookingDate];
    //    self.strStayDate = [[ICSingletonManager sharedManager] removeNullObjectFromString:self.strStayDate];
    //    self.strCity = [[ICSingletonManager sharedManager] removeNullObjectFromString:self.strCity];
    //    self.strState = [[ICSingletonManager sharedManager] removeNullObjectFromString:self.strState];
}

@end
