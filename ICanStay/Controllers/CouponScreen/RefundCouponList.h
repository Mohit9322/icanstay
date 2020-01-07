//
//  RefundCouponList.h
//  
//
//  Created by Vertical Logics on 13/05/16.
//
//

#import <Foundation/Foundation.h>


@interface RefundCouponList : NSObject

@property (nonatomic,retain)NSMutableArray *arrRefundCouponList;
@property (nonatomic,retain)NSMutableArray *arrRefundReasonList;

+(RefundCouponList*)instanceFromDictionary:(NSDictionary *)dict;


@end
