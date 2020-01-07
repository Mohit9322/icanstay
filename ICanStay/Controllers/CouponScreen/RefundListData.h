//
//  RefundListData.h
//  
//
//  Created by Vertical Logics on 13/05/16.
//
//

#import <Foundation/Foundation.h>

@interface RefundListData : NSObject
@property (nonatomic,copy)NSString *strCreatedDate;
@property (nonatomic,copy)NSString *strExpiryDate;
@property (nonatomic,copy)NSString *strName;
@property (nonatomic,copy)NSString *strCouponCode;

//@property (nonatomic,copy)NSString *strBookingDate;
//@property (nonatomic,copy)NSString *strStayDate;
//@property (nonatomic)NSNumber *numFeedBackReceived;
+(RefundListData *)instanceFromDictionary:(NSDictionary *)dict;


@end
