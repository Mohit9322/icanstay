//
//  CanStayConstant.h
//  ICanStay
//
//  Created by Namit Aggarwal on 29/02/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface CanStayConstant : NSObject


//#define kServerUrl  @"http://testing.icanstay.businesstowork.com/"
//#define kServerUrl  @"http://dev.staging.icanstay.businesstowork.com"
//#define kServerUrl  @"http://dev.icanstay.com"
//

#define kServerUrl  @"http://www.icanstay.com"
#define kLiveServerUrl  @"http://www.icanstay.com"

//#define kServerUrl  @"http://staging.icanstay.com"
//#define kLiveServerUrl  @"http://staging.icanstay.com"


#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define KGoogleMapApiKey @"AIzaSyD_4MPT0eFh_vi9zRmKujjMx2f79pV9Kug"

#define kUpdateFamilyDetail @"updateFamilyDetail"

#define APPDELEGATE (AppDelegate*)[UIApplication sharedApplication].delegate


#define IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)480) < DBL_EPSILON)
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)568) < DBL_EPSILON)
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)667) < DBL_EPSILON)
#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)736) < DBL_EPSILON)
#define IS_IPAD     (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)1024) < DBL_EPSILON)

#define SCREEN_WIDTH        ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT       ([[UIScreen mainScreen] bounds].size.height)


FOUNDATION_EXPORT NSString *const KUserLogin;
FOUNDATION_EXPORT NSString *const kEnterValidFirstName;
FOUNDATION_EXPORT NSString *const kEnterValidLastName;
FOUNDATION_EXPORT NSString *const kEnterValidEmailAddress;
FOUNDATION_EXPORT NSString *const kEnterValidPhoneNumber;
FOUNDATION_EXPORT NSString *const kSwitchToDashBoardScreen;
FOUNDATION_EXPORT NSString *const kAcceptTermsCondition;

@end
