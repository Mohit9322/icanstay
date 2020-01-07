//
//  NewCouponData.h
//  ICanStay
//
//  Created by Planet on 4/10/17.
//  Copyright © 2017 verticallogics. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewCouponData : NSObject
@property (nonatomic, strong, readonly) NSString *couponCode;
@property (nonatomic, strong, readonly) NSString *startDate;
@property (nonatomic, strong, readonly) NSString *endDate;
@property (nonatomic, strong, readonly) NSString *couponId;

@property (nonatomic, assign, readonly) BOOL      isSelected;


-(NewCouponData *) initCouponData:(nonnull NSString *) couponCode startDate:(nonnull NSString *) startDate endDate:(nonnull NSString *) endDate couponId:(NSString *)couponId isSelected:(BOOL) isselected;

-(void)setName:(nonnull NSString *)name;
-(void) setSelected:(BOOL)selected;

@end
