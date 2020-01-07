//
//  RefundCouponList.m
//  
//
//  Created by Vertical Logics on 13/05/16.
//
//

#import "RefundCouponList.h"
#import "RefundListData.h"
#import "RefundReasonData.h"
@implementation RefundCouponList

+(RefundCouponList*)instanceFromDictionary:(NSDictionary *)dict{
    
    RefundCouponList *instance = [[RefundCouponList alloc] init];
    [instance setAttributesFromArray:[dict valueForKey:@"CouponDetails"]];
    [instance setRefundReasonFromArray:[dict valueForKey:@"RefundReasonList"]];
    return instance;
}



- (void)setAttributesFromArray:(NSArray *)arr
{
    self.arrRefundCouponList = [NSMutableArray array];
    for (id valueMember in arr) {
        RefundListData *hotelData = [RefundListData instanceFromDictionary:valueMember];
        [self.arrRefundCouponList addObject:hotelData];
    }
    
    
}


- (void)setRefundReasonFromArray:(NSArray *)arr{
    self.arrRefundReasonList = [NSMutableArray array];
    for (id valueMember in arr) {
        RefundReasonData *hotelData = [RefundReasonData instanceFromDictionary:valueMember];
        [self.arrRefundReasonList addObject:hotelData];
    }

}

@end
