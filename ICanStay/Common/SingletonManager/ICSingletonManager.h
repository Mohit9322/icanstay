//
//  ICSingletonManager.h
//  ICanStay
//
//  Created by Namit Aggarwal on 25/02/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@import UIKit;
@interface ICSingletonManager : NSObject
+ (id)sharedManager ;


-(void)addBottomMenuToViewController:(UIViewController *)vc onView:(UIView *)view;
- (void)showAlertViewWithMsg:(NSString *)msg onController:(UIViewController *)controller;
- (NSString *)gettingDateStringToBeSendInPastStayApiFromStrDate:(NSString *)str;
- (NSString *)gettingMaleOrFemaleStringFromString:(NSString *)str;
- (NSString *)returnFormatedStringDateFromString:(NSString *)str;
-(NSString *) stringByStrippingHTMLFromString:(NSString *)str;
-(NSString *)removeNullObjectFromString:(NSString *)str;
- (BOOL)detectingIfUserLoggedIn;
-(void)addingBorderToUIView:(UIView * )view withColor:(UIColor *)clr;
- (NSString *)gettingNewlyFormattedDateStringFromString:(NSString *)str;
- (NSString *)gettingGenderFromString:(NSString *)str;
- (NSNumber *)removeNullObjectFromNumber:(NSNumber *)num;
- (NSString *)encodeToBase64String:(UIImage *)image ;
-(UIImage *)imageFromBase64EncodedString:(NSString *)str;
-(NSString *)convertToNSStringFromTodaysDate;
- (NSDate *)gettingDateFromString:(NSString *)str;

+ (CGSize)findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font;
+ (UIColor *)colorFromHexString:(NSString *)hexString;
+(NSString *) stringByStrippingHTML:(NSString *)htmlString;
+(NSString *)getStringValue:(NSString *)str;
+(BOOL)stringExists:(NSString *)str;
+(NSString*)Trim:(NSString*)value;

+ (NSString *)gettingDateStringFromString:(NSString *)str;
+ (NSString *)gettingDateFromString:(NSString *)str;

@property (nonatomic) BOOL isFromMenu;
@property (nonatomic) NSString  *strWhichScreen;
@property (nonatomic) int  validVoucher;
@property (nonatomic) BOOL isFromMenuForBuyVoucher;
@property (nonatomic) BOOL isFromMenuForSearchRedeem;
@property (nonatomic) BOOL isFromMenuForMakeWishe;
@property (nonatomic) BOOL isWithoutLoginNoti;
@property (nonatomic) BOOL isFirstTimeFromPageScrollController;
@property (nonatomic) BOOL isFromBuyVocherToMapScreen;
@property (nonatomic) BOOL isFirstTimeImageDownloadAndVideoUrl;

@property (nonatomic) BOOL isFromMywishlistToCreateWishlist;
@property (nonatomic) BOOL isFromEditMakeWishlist;
@property (nonatomic) BOOL isFromMenuForWishList;


@property (nonatomic) NSString *youtubeVideoUrl;
@property (nonatomic) NSString *isFirstTimeMenuLoadWebService;
@property (nonatomic) NSString *wishlistCount;
@property (nonatomic) NSString *myVoucherCount;
@property (nonatomic) NSString *staysCount;
@property (nonatomic, strong) NSMutableArray *menuLoadArry;
@property (nonatomic, strong) NSString *firstTimeGifImageLoader;
@property (nonatomic, strong) NSString *StrDeviceToken;
@property (nonatomic, strong) NSString *strMenuFromSearchStay;
@property (nonatomic) BOOL isFromBuyVoucherSearchByCity;
@property  (nonatomic) BOOL isFromBuyVoucherByCurrentLocation;
@property (nonatomic, strong) NSString *isShowVersionUpdatePopup;
@property (nonatomic, strong) NSString *isFromDeepLinkToMapScreen;
@property (nonatomic, strong) NSString *isFromDeepLinkToPackageScreen;
@property (nonatomic, strong) NSString *isFromDeepLinkToViewhotelsScreen;
@property (nonatomic, strong) NSString *isFromDeepLinkToWishListScreen;
@property (nonatomic, strong) NSString *isFromDeepLinkToBuyCoupon;
@property (nonatomic, strong) NSString *isFromDeepLinkToLoginAndRegisterScreen;
@property (nonatomic, strong) NSString *isFromHomeScreenToPackageScreen;
@property (nonatomic, strong) NSString *isFromLastMinuteBookingPaymentSuccess;
@property (nonatomic, strong) NSString *isFromLastMinuteBookingPaymentFail;
@property (nonatomic, strong) NSString *isFromMenuLastMinuteDeal;
@property (nonatomic, strong) NSString *isFromLoginContinueGuestBuyVoucher;
@property (nonatomic, strong) NSString *flagStatusSale;
@property (nonatomic, strong) NSArray *imgArrForHomeScreen;
@property (nonatomic, strong) NSArray *htmlTxtArrForHomeScreen;
@property (nonatomic, strong) NSArray *webImageLinkFroHomeScreenArr;
@property (nonatomic, strong) NSArray *btnTextFroHomeScreenArr;
@property (nonatomic, strong) NSString *isFromRegisteredNewUser;
@property (nonatomic, strong) NSString *userCancashAmountAvailable;
@property (nonatomic, strong) NSString *userContactSyncStr;
@property (nonatomic, strong) NSString *canCashFromRefer;
@property (nonatomic, strong) NSString *referralCode;
@property (nonatomic, strong) NSString *firstTimeVoucherPurchase;
@property (nonatomic, strong) NSString *registrationBackManage;
@property (nonatomic, strong) NSString *FirstTimeAppLoginOrRegister;
@property (nonatomic, strong) NSString *ReferAndEarnFromHome;
@property (nonatomic, strong) NSString *userReferralCode;
@property (nonatomic, strong) NSString *contactSyncOrNot;
@property (nonatomic, strong) NSString *userLoginFromReferAndEarn;

@end
