//
//  FeedbackScreen.m
//  
//
//  Created by Vertical Logics on 25/05/16.
//
//

#import "FeedbackScreen.h"

@implementation FeedbackScreen
+(FeedbackScreen *)instanceFromDictionary:(NSDictionary *)dict{
    
    FeedbackScreen *data = [[FeedbackScreen alloc]init];
    [data setAttributesFromDictionary:dict];
    return data;
}

- (void)setAttributesFromDictionary:(NSDictionary *)dict{
    
    
   // self.strCityName = [dict valueForKey:@"CouponCode"];
    self.strTestImage1 = [dict valueForKey:@"TestImage1"];
    self.strTestImage2 = [dict valueForKey:@"TestImage2"];
    self.strTestImage3 = [dict valueForKey:@"TestImage3"];
    self.strTestImage4 = [dict valueForKey:@"TestImage4"];
    self.strTestImage5 = [dict valueForKey:@"TestImage5"];
    self.strTestImageName1 = [dict valueForKey:@"TestImageName1"];
    self.strTestImageName2 = [dict valueForKey:@"TestImageName2"];
    self.strTestImageName3 = [dict valueForKey:@"TestImageName3"];
    self.strTestImageName4 = [dict valueForKey:@"TestImageName4"];
    self.strTestImageName5 = [dict valueForKey:@"TestImageName5"];
    
    self.numRating = [dict valueForKey:@"Rating"];
    self.strTestimonialDesc = [dict valueForKey:@"TestimonialDesc"];

    self.strTestImage1 = [[ICSingletonManager sharedManager] removeNullObjectFromString:self.strTestImage1];
    self.strTestImage2 = [[ICSingletonManager sharedManager] removeNullObjectFromString:self.strTestImage2];
    self.strTestImage3 = [[ICSingletonManager sharedManager] removeNullObjectFromString:self.strTestImage3];
    self.strTestImage4 = [[ICSingletonManager sharedManager] removeNullObjectFromString:self.strTestImage4];
    self.strTestImage5 = [[ICSingletonManager sharedManager] removeNullObjectFromString:self.strTestImage5];
    self.strTestImageName1 = [[ICSingletonManager sharedManager] removeNullObjectFromString:self.strTestImageName1];
    self.strTestImageName2 = [[ICSingletonManager sharedManager] removeNullObjectFromString:self.strTestImageName2];
    self.strTestImageName3 = [[ICSingletonManager sharedManager] removeNullObjectFromString:self.strTestImageName3];
    self.strTestImageName4 = [[ICSingletonManager sharedManager] removeNullObjectFromString:self.strTestImageName4];
    self.strTestImageName5 = [[ICSingletonManager sharedManager] removeNullObjectFromString:self.strTestImageName5];
    self.strTestimonialDesc = [[ICSingletonManager sharedManager] removeNullObjectFromString:self.strTestimonialDesc];
    self.numRating = [[ICSingletonManager sharedManager]removeNullObjectFromNumber:self.numRating];
   // self.strTestImage1 = [[ICSingletonManager sharedManager] removeNullObjectFromString:self.strTestImage1];
    
//    self.strTestImage5 = [[ICSingletonManager sharedManager] removeNullObjectFromString:self.strCouponStartDate];
//    self.strCouponEndDate = [[ICSingletonManager sharedManager] removeNullObjectFromString:self.strCouponEndDate];
    
    
   
    
}

@end
