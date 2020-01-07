//
//  NewCouponData.m
//  ICanStay
//
//  Created by Planet on 4/10/17.
//  Copyright © 2017 verticallogics. All rights reserved.
//

#import "NewCouponData.h"

@interface NewCouponData ()
@property (nonatomic, strong, readwrite) NSString *couponCode;
@property (nonatomic, strong, readwrite) NSString *startDate;
@property (nonatomic, strong, readwrite) NSString *endDate;
@property (nonatomic, strong, readwrite) NSString *couponId;
@property (nonatomic, assign, readwrite) BOOL      isSelected;

@end

@implementation NewCouponData
@synthesize couponCode;
@synthesize startDate;
@synthesize endDate;
@synthesize isSelected;
@synthesize couponId;

-(NewCouponData *) initCouponData:(nonnull NSString *) couponCode startDate:(nonnull NSString *) startDate endDate:(nonnull NSString *) endDate couponId:(NSString *)couponId isSelected:(BOOL) isselected  {
    if(self == [super init])    {
        self.couponCode    = couponCode;
        self.isSelected     = isselected;
        self.startDate =      startDate;
        self.endDate   =      endDate;
        self.couponId    =   couponId;
    }
    return self;
}


-(void) setSelected:(BOOL)lisSelected  {
  
    self.isSelected = lisSelected;

}
@end
