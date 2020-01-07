//
//  RefundReasonData.h
//  
//
//  Created by Vertical Logics on 13/05/16.
//
//

#import <Foundation/Foundation.h>

@interface RefundReasonData : NSObject

@property (nonatomic,strong)NSString *strRefundReason;
@property (nonatomic)NSNumber *numReasonId;

+(RefundReasonData *)instanceFromDictionary:(NSDictionary *)dict;

@end
