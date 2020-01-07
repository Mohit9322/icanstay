//
//  ICSingletonManager.m
//  ICanStay
//
//  Created by Namit Aggarwal on 25/02/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import "ICSingletonManager.h"
#import "BottomMenu.h"
#import "LoginManager.h"

@implementation ICSingletonManager

#define kMaleText   @"Male"
#define kFemaleText @"Female"

+ (id)sharedManager {
    static ICSingletonManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        self.isFromMenu = false;
        self.strWhichScreen = @"";
        self.isFromMenuForBuyVoucher = false;
        self.isFromMenuForMakeWishe = false;
        self.isWithoutLoginNoti = false;
        self.isFromMenuForWishList = false;
        self.isFromMenuForSearchRedeem = false;
        self.isFirstTimeFromPageScrollController = false;
        self.isFirstTimeImageDownloadAndVideoUrl = false;
        self.isFromBuyVocherToMapScreen = false;
        self.isFromEditMakeWishlist = false;
        self.isFromMywishlistToCreateWishlist = false;
        self.youtubeVideoUrl = @"";
        self.imgArrForHomeScreen = [[NSArray alloc]init];
        self.isFirstTimeMenuLoadWebService = @"";
        self.wishlistCount = @"";
        self.myVoucherCount = @"";
        self.staysCount = @"";
        self.menuLoadArry = [[NSMutableArray alloc]init];
        self.firstTimeGifImageLoader = @"";
        self.StrDeviceToken = @"";
        self.strMenuFromSearchStay = @"";
        self.isFromBuyVoucherSearchByCity = false;
        self.isFromBuyVoucherByCurrentLocation = false;
        self.isShowVersionUpdatePopup = @"";
        self.isFromDeepLinkToMapScreen = @"";
        self.isFromDeepLinkToViewhotelsScreen = @"";
        self.isFromDeepLinkToPackageScreen = @"";
        self.isFromDeepLinkToWishListScreen = @"";
        self.isFromDeepLinkToBuyCoupon = @"";
        self.isFromDeepLinkToLoginAndRegisterScreen = @"";
        self.isFromHomeScreenToPackageScreen = @"";
        self.isFromLastMinuteBookingPaymentSuccess = @"NO";
         self.isFromLastMinuteBookingPaymentFail = @"NO";
        self.isFromMenuLastMinuteDeal = @"NO";
        self.isFromLoginContinueGuestBuyVoucher = @"NO";
        self.flagStatusSale = @"";
        self.htmlTxtArrForHomeScreen = [[NSArray alloc]init];
        self.webImageLinkFroHomeScreenArr = [[NSArray alloc]init];
        self.btnTextFroHomeScreenArr = [[NSArray alloc]init];
        self.isFromRegisteredNewUser = @"NO";
        self.userCancashAmountAvailable = @"0";
        self.userContactSyncStr = @"NO";
        self.canCashFromRefer = @"NO";
        self.referralCode = @"";
        self.firstTimeVoucherPurchase = @"NO";
        self.registrationBackManage = @"";
        self.FirstTimeAppLoginOrRegister = @"NO";
        self.ReferAndEarnFromHome = @"";
        self.contactSyncOrNot = @"NO";
   //     self.userReferralCode = @"";
        self.userLoginFromReferAndEarn = @"NO";
    }
    
    return self;
}

-(void)addBottomMenuToViewController:(UIViewController *)vc onView:(UIView *)view{
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:[NSBundle mainBundle]];
    BottomMenu *bottomVc = [storyboard instantiateViewControllerWithIdentifier:@"BottomMenu"];
    
    
    bottomVc.view.frame = view.bounds;
    [view addSubview:bottomVc.view];
//    /*Calling the addChildViewController: method also calls
//     the child’s willMoveToParentViewController: method automatically */
    [vc addChildViewController:bottomVc];
    [bottomVc didMoveToParentViewController:vc];
}

-(void)homeScreenImageViewer
{
    
}
/// Trim String by Hitaishin (Harish)
/// Trim for String
+(NSString*)Trim:(NSString*)value
{
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return value;
}

// checks whether string value exists or it contains null or null in string
+(BOOL)stringExists:(NSString *)str{
    if(str==nil){
        return false;
    }
    if (![str isKindOfClass:[NSString class]]) {
        return false;
    }
    if(str==(NSString *)[NSNull null]){
        return false;
    }
    if([str isEqualToString:@"<null>"]){
        return false;
    }
    if([str isEqualToString:@"(null)"]){
        return false;
    }
    str=[ICSingletonManager Trim:str];
    if([str isEqualToString:@""]){
        return false;
    }
    if(str.length == 0){
        return false;
    }
    return true;
}

// returns string value after removing null and unwanted characters
+(NSString *)getStringValue:(NSString *)str{
    if ([ICSingletonManager stringExists:str]) {
        str=[str stringByReplacingOccurrencesOfString:@"\t" withString:@" "];
        
        str=[ICSingletonManager Trim:str];
        
        if ([str isEqualToString:@"{}"]) {
            str=@"";
        }
        
        if ([str isEqualToString:@"()"]) {
            str=@"";
        }if ([str isEqualToString:@"null"]) {
            str=@"";
        }
        return str;
    }
    return @"";
}

- (void)showAlertViewWithMsg:(NSString *)msg onController:(UIViewController *)controller{
    if ([UIAlertController class])
    {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:msg message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
//        [controller presentViewController:alertController animated:YES completion:nil];
        UIWindow *topWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        topWindow.rootViewController = [[UIViewController alloc] init];
        topWindow.windowLevel = UIWindowLevelAlert + 1;
        [topWindow makeKeyAndVisible];
        [topWindow.rootViewController presentViewController:alertController animated:true completion:nil];

    }
    else
    {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:msg message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    }
}

- (NSString *)gettingDateStringToBeSendInPastStayApiFromStrDate:(NSString *)str
{
    if ([str isEqualToString:@"Today"])
    {
        NSDate *todayDate = [NSDate date]; // get today date
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date..
        [dateFormatter setDateFormat:@"yyyy-MM-dd"]; //Here we can set the format which we need
        NSString *convertedDateString = [dateFormatter stringFromDate:todayDate];// here convert date in
        NSLog(@"Today formatted date is %@",convertedDateString);
         return convertedDateString;
        
    }
    else if ([str isEqualToString:@"Tommorow"]) {
        
        NSDate *todayDate = [NSDate date]; // get today date
        
        int daysToAdd = 1;
        NSDate *tommorowDate= [todayDate dateByAddingTimeInterval:60*60*24*daysToAdd];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date..
        [dateFormatter setDateFormat:@"yyyy-MM-dd"]; //Here we can set the format which we need
        NSString *convertedDateString = [dateFormatter stringFromDate:tommorowDate];// here convert date in
        NSLog(@"Today formatted date is %@",convertedDateString);
         return convertedDateString;
        
    }
    else if ([str isEqualToString:@"Day After"]) {
        NSDate *todayDate = [NSDate date]; // get today date
        int daysToAdd = 2;
        NSDate *dayAfetrDate= [todayDate dateByAddingTimeInterval:60*60*24*daysToAdd];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date..
        [dateFormatter setDateFormat:@"yyyy-MM-dd"]; //Here we can set the format which we need
        NSString *convertedDateString = [dateFormatter stringFromDate:dayAfetrDate];// here convert date in
        NSLog(@"Today formatted date is %@",convertedDateString);
        return convertedDateString;
        
    }
    else
    {
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateStyle=NSDateFormatterMediumStyle;
    [dateFormat setDateFormat:@"dd MMM yyyy"];
    NSDate *date = [dateFormat dateFromString:str];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *string = [NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:date]];
    NSLog(@"%@",string);
         return string;
    }
   
}


- (NSString *)gettingMaleOrFemaleStringFromString:(NSString *)str{
    NSString *string = @"";
    if ([str isEqualToString:@"M"]) {
        string =@"Male";
    }
    else if ([str isEqualToString:@"F"]){
        string = @"Female";
    }
    
    
    return string;
}

- (NSString *)returnFormatedStringDateFromString:(NSString *)str{
    NSString *string = @"";
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateStyle=NSDateFormatterMediumStyle;
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
   // [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    NSDate *date = [dateFormat dateFromString:str];
    [dateFormat setDateFormat:@"dd MMM yyyy"];
    string = [NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:date]];

    if ([string isEqualToString:@"(null)"]) {
        string = @"";
    }
    return string;
    
    
}

- (NSString *)gettingNewlyFormattedDateStringFromString:(NSString *)str{
    NSString *string = @"";
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateStyle=NSDateFormatterMediumStyle;
   // [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    NSDate *date = [dateFormat dateFromString:str];
    [dateFormat setDateFormat:@"dd MMMM yyyy"];
    string = [NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:date]];
    
    
    return string;

}

+ (NSString *)gettingDateStringFromString:(NSString *)str{
    NSString *string = @"";
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateStyle=NSDateFormatterMediumStyle;
     [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
//    [dateFormat setDateFormat:@"yyyy-MM-ddTHH:mm:ss.SSS"];
    NSDate *date = [dateFormat dateFromString:str];
    [dateFormat setDateFormat:@"dd MMMM yyyy"];
    string = [NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:date]];
    
    
    return string;
    
}
+ (NSString *)gettingDateFromString:(NSString *)str{
    NSString *string = @"";
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateStyle=NSDateFormatterMediumStyle;
     [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
//    [dateFormat setDateFormat:@"yyyy-MM-ddTHH:mm:ss.SSS"];
    NSDate *date = [dateFormat dateFromString:str];
    [dateFormat setDateFormat:@"dd"];
    string = [NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:date]];
    
    
    return string;
    
}


-(NSString *) stringByStrippingHTMLFromString:(NSString *)str {
    NSRange r;
    NSString *s = str;
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}


-(NSString *)removeNullObjectFromString:(NSString *)str{
    if ([str isEqual:[NSNull null]]) {
        str = @"";
    }
    
    return str;
}

- (BOOL)detectingIfUserLoggedIn{
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    if (dict.count >0) {
        return YES;
    }
    else
        return NO;
}
//[UIColor lightGrayColor]
-(void)addingBorderToUIView:(UIView * )view withColor:(UIColor *)clr{
    view.layer.borderWidth=0.5f;
    view.layer.borderColor=[clr CGColor];
    view.layer.cornerRadius = 2;
    view.layer.masksToBounds = YES;
}


- (NSNumber *)removeNullObjectFromNumber:(NSNumber *)num{
    NSNumber *numNew = [NSNumber numberWithInt:0];
    if ([num isEqual:[NSNull null]]) {
        numNew = [NSNumber numberWithInt:0];
    }
    else
        numNew = num;
    
    return numNew;
}

- (NSString *)gettingGenderFromString:(NSString *)str{
    NSString *strReturn = nil;
    if ([str isEqualToString:@"F"]) {
        strReturn = kFemaleText;
    }
    else if ([str isEqualToString:@"M"]){
        strReturn = kMaleText;
        
    }
    else if ([str isEqualToString:kFemaleText]){
        strReturn = @"F";
        
    }
    else if ([str isEqualToString:kMaleText]){
        strReturn = @"M";
    }
    return strReturn;
}

- (NSString *)encodeToBase64String:(UIImage *)image {
    
    if (image) {
        
        NSData * data = [UIImagePNGRepresentation(image) base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
        return [NSString stringWithUTF8String:[data bytes]];
        
        
//        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
//        NSString *encodedString = [imageData base64Encoding];
//        return encodedString;
        //return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];

    }
    else
        return nil;
    
    
}
-(UIImage *)imageFromBase64EncodedString:(NSString *)str{
    
   // NSString *string64 =nil; //... some string base 64 encoded
    
    //convert your string to data
    
    NSData *data = [[NSData alloc]initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
//    NSData *data = [[NSData alloc] initWithBase64EncodedString:string64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    //initiate image from data
    
    UIImage *captcha_image = [[UIImage alloc] initWithData:data];
    
    return captcha_image;
    // do something with image
}


-(NSString *)convertToNSStringFromTodaysDate{
    NSString *dateString=@"";
    
    NSDate *today = [NSDate date]; //Swapped for an autorelease class method
    NSDateFormatter *df = [[NSDateFormatter alloc] init] ; //Will release itself for us
    [df setDateFormat:@"yyyy-MM-dd"];
    dateString = [df stringFromDate:today] ; //Simplified the code
    
    
    return dateString;
}



+ (CGSize)findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font {
    CGSize size = CGSizeZero;
    if (text) {
        //iOS 7
        CGRect frame = [text boundingRectWithSize:CGSizeMake(widthValue, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:font } context:nil];
        size = CGSizeMake(frame.size.width, frame.size.height + 1);
    }
    return size;
}
#pragma mark - Color Methods

+(UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+(NSString *) stringByStrippingHTML:(NSString *)htmlString {
    NSRange r;
    while ((r = [htmlString rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        htmlString = [htmlString stringByReplacingCharactersInRange:r withString:@""];
    return htmlString;
}

@end
