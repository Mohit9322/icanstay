//
//  FeedbackScreen.h
//  
//
//  Created by Vertical Logics on 25/05/16.
//
//

#import <Foundation/Foundation.h>

@interface FeedbackScreen : NSObject
@property (nonatomic,copy)NSString *strCityName;
@property (nonatomic,copy)NSNumber *numRating;
@property (nonatomic,copy)NSString *strTestImage1;
@property (nonatomic,copy)NSString *strTestImage2;
@property (nonatomic,copy)NSString *strTestImage3;
@property (nonatomic,copy)NSString *strTestImage4;
@property (nonatomic,copy)NSString *strTestImage5;
@property (nonatomic,copy)NSString *strTestImageName1;
@property (nonatomic,copy)NSString *strTestImageName2;
@property (nonatomic,copy)NSString *strTestImageName3;
@property (nonatomic,copy)NSString *strTestImageName4;
@property (nonatomic,copy)NSString *strTestImageName5;
@property (nonatomic,copy)NSString *strTestimonialDesc;


+(FeedbackScreen *)instanceFromDictionary:(NSDictionary *)dict;


@end
