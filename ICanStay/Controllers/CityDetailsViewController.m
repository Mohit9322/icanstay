//
//  CityDetailsViewController.m
//  ICanStay
//
//  Created by Planet on 11/3/17.
//  Copyright © 2017 verticallogics. All rights reserved.
//

#import "CityDetailsViewController.h"
#import "NotificationScreen.h"
#import "CityDetailTableViewCell.h"
#import <MoEngage.h>
#import "BuyCouponViewController.h"
#import "HotelDetailsViewController.h"
#import "HomeScreenController.h"
#import "SideMenuController.h"

#define kTagCellCountryCheckboxBtn  1288
#define kTagCellBookNowBtn          1287

@interface CityDetailsViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    CGRect screenRect;
    UIImageView *baseImageView;
}
@property (nonatomic, strong) UIView         *topWhiteBaseView;
@property (nonatomic, strong) UIButton       *backButton;
@property (nonatomic, strong) UIButton       *notificationButton;
@property (nonatomic, strong) UIImageView    *logoIconImgView;
@property (nonatomic, strong) UILabel        *hotelNameLbl;
@property (nonatomic, strong) UITableView    *hotelDetailLTblView;
@end

@implementation CityDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    screenRect = [[UIScreen mainScreen] bounds];
    
    self.topWhiteBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,screenRect.size.width , 64)];
    self.topWhiteBaseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topWhiteBaseView];
    
    self.notificationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.notificationButton.frame = CGRectMake(self.topWhiteBaseView.frame.size.width - 40 - 10, 20, 24, 24);
    [self.notificationButton setBackgroundImage:[UIImage imageNamed:@"notification1"] forState:UIControlStateNormal];
    [self.notificationButton addTarget:self action:@selector(notificationButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.topWhiteBaseView addSubview:self.notificationButton];
      
    
    self.logoIconImgView = [[UIImageView alloc]initWithFrame:CGRectMake((self.topWhiteBaseView.frame.size.width - 150)/2, 15, 150, 34)];
    self.logoIconImgView.image = [UIImage imageNamed:@"topBanner"];
     self.logoIconImgView.userInteractionEnabled = YES;
    [self.topWhiteBaseView addSubview:self.logoIconImgView];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.topWhiteBaseView addGestureRecognizer:singleFingerTap];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.backButton.frame = CGRectMake(20, 22, 30, 20);
    [self.backButton setBackgroundImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.topWhiteBaseView addSubview:self.backButton];
    
    
    baseImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, self.topWhiteBaseView.frame.origin.y + self.topWhiteBaseView.frame.size.height, self.view.frame.size.width - 20, 60)];
    baseImageView.image = [UIImage imageNamed:@"PackageBaseImg"];
    [self.view addSubview:baseImageView];
    
    self.hotelNameLbl = [[UILabel alloc]init];

    self.hotelNameLbl.textAlignment = NSTextAlignmentCenter;
    self.hotelNameLbl.textColor = [ICSingletonManager colorFromHexString:@"#bd9854"];
    self.hotelNameLbl.lineBreakMode = NSLineBreakByWordWrapping;
    self.hotelNameLbl.numberOfLines = 2;
    self.hotelNameLbl.backgroundColor = [UIColor clearColor];
    [baseImageView addSubview:self.hotelNameLbl];
    
    NSString *cName = @"";
    NSString* stringName = @"";
    if ([self.arrayHotelList count]==1) {
        NSString *cName1 = @"icanstay Luxury Hotel \n";
        stringName = [cName1 stringByAppendingString:[ICSingletonManager getStringValue:self.cityNameStr]];
    }else
    {
        cName = [cName stringByAppendingString:@" icanstay Luxury Hotels \n"];
        stringName = [cName stringByAppendingString:[ICSingletonManager getStringValue:self.cityNameStr]];
    }
    
    NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
    style.minimumLineHeight = 20.f;
    style.maximumLineHeight = 20.f;
    NSDictionary *attributtes = @{NSParagraphStyleAttributeName : style,};
    self.hotelNameLbl.attributedText = [[NSAttributedString alloc] initWithString:stringName
                                                                   attributes:attributtes];
    self.hotelNameLbl.textAlignment = NSTextAlignmentCenter;
    
    self.hotelNameLbl.frame = CGRectMake(0, 0, baseImageView.frame.size.width, baseImageView.frame.size.height);
    
    [self getHotelList];
   
    
    // Do any additional setup after loading the view.
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    HomeScreenController *vcHomeScreen = [storyboard instantiateViewControllerWithIdentifier:@"HomeScreenController"];
    SideMenuController *vcSideMenu =     [storyboard instantiateViewControllerWithIdentifier:@"SideMenuController"];
    
    MMDrawerController *drawerController = [[MMDrawerController alloc]initWithCenterViewController:vcHomeScreen
                                                                          leftDrawerViewController:vcSideMenu];
    [drawerController setRestorationIdentifier:@"MMDrawer"];
    
    
    [drawerController setMaximumLeftDrawerWidth:SCREEN_WIDTH*2/3];
    
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    drawerController.shouldStretchDrawer = NO;
    
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:drawerController];
    [navController setNavigationBarHidden:YES];
    [self.view.window setRootViewController:navController];
    [self.view.window makeKeyAndVisible];
    
    
}
#pragma mark - UITableViewDataSource
-(void)getHotelList
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    //http://www.icanstay.com/Api/FAQApi/GetCityApi
    //http://www.icanstay.com/api/FAQApi/GetCityDetailsByCityIdApi?CityID=1
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/FAQApi/GetCityDetailsByCityIdApiLastMinute?CityID=%@",kServerUrl, self.cityId];
    
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);

        self.arrayHotelList = [responseObject objectForKey:@"OrderCityWiseHotels1"];
        self.availableAmenties = [responseObject objectForKey:@"OrderCityAvailableAmenities"];
       
        self.hotelDetailLTblView = [[UITableView alloc]initWithFrame:CGRectMake(5,baseImageView.frame.size.height + baseImageView.frame.origin.y , screenRect.size.width - 10, screenRect.size.height - (baseImageView.frame.size.height + baseImageView.frame.origin.y) )];
        self.hotelDetailLTblView.delegate = self;
        self.hotelDetailLTblView.dataSource = self;
        
        [self.view addSubview:self.hotelDetailLTblView];
      
        LoginManager *loginManage = [[LoginManager alloc]init];
        NSDictionary *dict = [loginManage isUserLoggedIn];
        
        if ([dict count] > 0) {
            /****************** Mo Engage *******************/
            
            NSMutableDictionary *purchaseDict = [NSMutableDictionary dictionaryWithDictionary:@{@"Mobile No.": [dict objectForKey:@"Phone1"],@"User name":[NSString stringWithFormat:@"%@ %@", [dict objectForKey:@"FirstName"],[dict objectForKey:@"LastName"]],@"City Name":self.cityNameStr}];
            
            
            [[MoEngage sharedInstance]trackEvent:@"App City Checked IOS" andPayload:purchaseDict];
            [[MoEngage sharedInstance] syncNow];
            [MoEngage debug:LOG_ALL];
            
            /****************** Mo Engage *******************/
            
            /****************** Google Analytics *******************/
            
            // Track the Event for UserSuccessfulRegistrationMobile
            
            NSString *actionStr = [NSString  stringWithFormat:@"%@ %@ %@",[NSString stringWithFormat:@"%@ %@", [dict objectForKey:@"FirstName"],[dict objectForKey:@"LastName"]],[dict objectForKey:@"Phone1"],self.cityNameStr];
            id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"App City Checked IOS"
                                                                  action:actionStr
                                                                   label:[dict objectForKey:@"Phone1"]
                                                                   value:nil] build]];
            
            /****************** Google Analytics *******************/
        }
        
        
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:error.localizedDescription onController:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}
// number of section(s), now I assume there is only 1 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

// number of row in the section, I assume there is only 1 row
- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayHotelList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *hotelListDictionary;
    hotelListDictionary = [self.arrayHotelList objectAtIndex:indexPath.row];
     NSString * webViewHeight =[hotelListDictionary objectForKey:@"HotelBulletContent"];
     NSString *htmlStr = [ICSingletonManager getStringValue:[NSString stringWithFormat:@"<html><head><style>@import url('https://fonts.googleapis.com/css?family=Gotham');ul{list-style:none;padding: 1px 0px 0px 0px; }ul li {background-image: url(http://www.icanstay.com/Content/Home/images/rev-slider/dot.png);  background-repeat: no-repeat; background-position: 0 0px; padding: 0px 10px 12px 18px; background-size: 13px;font-size: 16px; color:#808080; line-height: 17px; font-family:Josefin Sans, Verdana, Segoe, sans-serif;}</style></head><body bgcolor=\"#ffffff\" >%@</body></html>",webViewHeight]];
   
    
    NSAttributedString *attributedText = [self getHTMLAttributedString:htmlStr];
    CGSize size = CGSizeMake(self.hotelDetailLTblView.frame.size.width - 10, CGFLOAT_MAX);
    CGRect paragraphRect =     [attributedText boundingRectWithSize:size
                                                            options:(NSStringDrawingUsesLineFragmentOrigin)
                                                            context:nil];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
         return 300+paragraphRect.size.height+10 +35;
    }else{
         return 300+paragraphRect.size.height+10 +20;
    }
    
    return 0;
    
}
-(NSAttributedString *) getHTMLAttributedString:(NSString *) string{
    NSError *errorFees=nil;
    NSString *sourceFees = [NSString stringWithFormat:
                            @"<span style=\"font-family: 'JosefinSans-Light';font-size: 18px\">%@</span>",string];
    NSMutableAttributedString* strFees = [[NSMutableAttributedString alloc] initWithData:[sourceFees dataUsingEncoding:NSUTF8StringEncoding]
                                                                                 options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                           NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]}
                                                                      documentAttributes:nil error:&errorFees];
    return strFees;
    
}

// the cell will be returned to the tableView
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
       
        NSDictionary *hotelListDictionary;
        hotelListDictionary = [self.arrayHotelList objectAtIndex:indexPath.row];
        NSString * webViewHeight =[hotelListDictionary objectForKey:@"HotelBulletContent"];
        NSString *htmlStr = [ICSingletonManager getStringValue:[NSString stringWithFormat:@"<html><head><style>@import url('https://fonts.googleapis.com/css?family=Gotham');ul{list-style:none;padding: 1px 0px 0px 0px; }ul li {background-image: url(http://www.icanstay.com/Content/Home/images/rev-slider/dot.png);  background-repeat: no-repeat; background-position: 0 0px; padding: 0px 10px 12px 18px; background-size: 13px;font-size: 16px; color:#808080; line-height: 17px; font-family:Josefin Sans, Verdana, Segoe, sans-serif;}</style></head><body bgcolor=\"#ffffff\" >%@</body></html>",webViewHeight]];
        
        
        NSAttributedString *attributedText = [self getHTMLAttributedString:htmlStr];
        CGSize size = CGSizeMake(self.hotelDetailLTblView.frame.size.width - 10, CGFLOAT_MAX);
        CGRect paragraphRect =     [attributedText boundingRectWithSize:size
                                                                options:(NSStringDrawingUsesLineFragmentOrigin)
                                                                context:nil];
        
        static NSString *CellIdentifier1      = @"CityDetailCell";
        CityDetailTableViewCell *cell           = [[CityDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                                 reuseIdentifier:CellIdentifier1];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [[cell contentView] setFrame:[cell bounds]];
        [[cell contentView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        cell.frame = CGRectMake(0, 0, self.hotelDetailLTblView.frame.size.width, 300 + paragraphRect.size.height +10 +20 + 20);
        cell.baseView.frame = CGRectMake(10, 10, cell.frame.size.width - 20, cell.frame.size.height - 20);
        cell.hotelImageView.frame = CGRectMake(0, 0, cell.baseView.frame.size.width , 200);
        cell.hotelNameLbl.frame = CGRectMake(10, cell.hotelImageView.frame.origin.y + cell.hotelImageView.frame.size.height + 10, cell.baseView.frame.size.width - 20, 20);
        cell.hotelDetailwebView.frame = CGRectMake(5,cell.hotelNameLbl.frame.origin.y + cell.hotelNameLbl.frame.size.height + 10 ,self.hotelDetailLTblView.frame.size.width - 10 , paragraphRect.size.height + 10 + 20);
        cell.seeMoreButton.frame = CGRectMake((cell.baseView.frame.size.width - 400)/3, cell.hotelDetailwebView.frame.origin.y + cell.hotelDetailwebView.frame.size.height + 10, 200, 40);
        cell.BuyVoucherBtn.frame = CGRectMake(((cell.baseView.frame.size.width - 400)/3)*2 +200 , cell.hotelDetailwebView.frame.origin.y + cell.hotelDetailwebView.frame.size.height + 10, 200, 40);
        
        cell.seeMoreButton.tag = kTagCellCountryCheckboxBtn;
        [cell.seeMoreButton addTarget:self action:@selector(seeMoreBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.BuyVoucherBtn.tag = kTagCellBookNowBtn;
        [cell.BuyVoucherBtn addTarget:self action:@selector(doclickonBuyVoucher:) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *str_url =[hotelListDictionary objectForKey:@"img1"];
        NSString *urlStr = [NSString stringWithFormat:@"%@/DataImages/%@",kServerUrl, str_url ];
        NSURL *url =[NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        
        [cell.hotelImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"photo_frame"]];
        NSString *hName = @"Luxury Hotel, ";
        cell.hotelNameLbl.text = [hName stringByAppendingString:[ICSingletonManager getStringValue:[hotelListDictionary objectForKey:@"HotelName"]]];
        
        [cell.hotelDetailwebView loadHTMLString:[NSString stringWithFormat:@"%@", htmlStr ]baseURL:nil];
        
        cell.seeMoreButton.hotelIdStr = [NSString stringWithFormat:@"%ld", indexPath.row];
         return cell;
    }else{
        NSDictionary *hotelListDictionary;
        hotelListDictionary = [self.arrayHotelList objectAtIndex:indexPath.row];
        NSString * webViewHeight =[hotelListDictionary objectForKey:@"HotelBulletContent"];
        NSString *htmlStr = [ICSingletonManager getStringValue:[NSString stringWithFormat:@"<html><head><style>@import url('https://fonts.googleapis.com/css?family=Gotham');ul{list-style:none;padding: 1px 0px 0px 0px; }ul li {background-image: url(http://www.icanstay.com/Content/Home/images/rev-slider/dot.png);  background-repeat: no-repeat; background-position: 0 0px; padding: 0px 10px 12px 18px; background-size: 13px;font-size: 16px; color:#808080; line-height: 17px; font-family:Josefin Sans, Verdana, Segoe, sans-serif;}</style></head><body bgcolor=\"#ffffff\" >%@</body></html>",webViewHeight]];
        
        
        NSAttributedString *attributedText = [self getHTMLAttributedString:htmlStr];
        CGSize size = CGSizeMake(self.hotelDetailLTblView.frame.size.width - 10, CGFLOAT_MAX);
        CGRect paragraphRect =     [attributedText boundingRectWithSize:size
                                                                options:(NSStringDrawingUsesLineFragmentOrigin)
                                                                context:nil];
        
        static NSString *CellIdentifier1      = @"CityDetailCell";
        CityDetailTableViewCell *cell           = [[CityDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                                 reuseIdentifier:CellIdentifier1];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [[cell contentView] setFrame:[cell bounds]];
        [[cell contentView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        cell.frame = CGRectMake(0, 0, self.hotelDetailLTblView.frame.size.width, 300 + paragraphRect.size.height +10 +20);
        cell.baseView.frame = CGRectMake(10, 10, cell.frame.size.width - 20, cell.frame.size.height - 20);
        cell.hotelImageView.frame = CGRectMake(0, 0, cell.baseView.frame.size.width , 200);
        cell.hotelNameLbl.frame = CGRectMake(10, cell.hotelImageView.frame.origin.y + cell.hotelImageView.frame.size.height + 10, cell.baseView.frame.size.width - 20, 20);
        cell.hotelDetailwebView.frame = CGRectMake(5,cell.hotelNameLbl.frame.origin.y + cell.hotelNameLbl.frame.size.height + 10 ,self.hotelDetailLTblView.frame.size.width - 10 , paragraphRect.size.height + 10);
        cell.seeMoreButton.frame = CGRectMake((cell.baseView.frame.size.width - 260)/3, cell.hotelDetailwebView.frame.origin.y + cell.hotelDetailwebView.frame.size.height + 10, 130, 40);
        cell.BuyVoucherBtn.frame = CGRectMake(((cell.baseView.frame.size.width - 260)/3)*2 +130 , cell.hotelDetailwebView.frame.origin.y + cell.hotelDetailwebView.frame.size.height + 10, 130, 40);
        
        cell.seeMoreButton.tag = kTagCellCountryCheckboxBtn;
        [cell.seeMoreButton addTarget:self action:@selector(seeMoreBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.BuyVoucherBtn.tag = kTagCellBookNowBtn;
        [cell.BuyVoucherBtn addTarget:self action:@selector(doclickonBuyVoucher:) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *str_url =[hotelListDictionary objectForKey:@"img1"];
        NSString *urlStr = [NSString stringWithFormat:@"%@/DataImages/%@",kServerUrl, str_url ];
        NSURL *url =[NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        
        [cell.hotelImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"photo_frame"]];
        NSString *hName = @"Luxury Hotel, ";
        cell.hotelNameLbl.text = [hName stringByAppendingString:[ICSingletonManager getStringValue:[hotelListDictionary objectForKey:@"HotelName"]]];
        
        [cell.hotelDetailwebView loadHTMLString:[NSString stringWithFormat:@"%@", htmlStr ]baseURL:nil];
        
        cell.seeMoreButton.hotelIdStr = [NSString stringWithFormat:@"%ld", indexPath.row];
        return cell;
    }

    return nil;
    
}

-(NSString *)getURLFromString:(NSString *)str{
    
    NSString *urlStr = [str stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    return urlStr;
}
-(void)doclickonBuyVoucher:(id)sender{
   
    
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    globals.isFromMenuForBuyVoucher = false;
    
    BuyCouponViewController *buyCoupon =[self.storyboard instantiateViewControllerWithIdentifier:@"BuyCouponViewController"];
    [self.navigationController pushViewController:buyCoupon animated:YES];
    
}
#pragma mark - UITableViewDelegate

// when user tap the row, what action you want to perform
- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *hotelListDictionary = [self.arrayHotelList objectAtIndex:indexPath.row];
    //NSLog(@"selected %d row", indexPath.row);
    HotelDetailsViewController *hotelDetails =[self.storyboard instantiateViewControllerWithIdentifier:@"HotelDetailsViewController"];
    hotelDetails.hotelDict = hotelListDictionary;
    hotelDetails.amentiesDict =[self.availableAmenties objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:hotelDetails animated:YES];
    
}

-(void)seeMoreBtnTapped:(id)sender
{
    __weak seeMoreBtn *seeMoreBtn = sender;
    NSDictionary *hotelListDictionary = [self.arrayHotelList objectAtIndex:[seeMoreBtn.hotelIdStr intValue]];
    //NSLog(@"selected %d row", indexPath.row);
    HotelDetailsViewController *hotelDetails =[self.storyboard instantiateViewControllerWithIdentifier:@"HotelDetailsViewController"];
    hotelDetails.hotelDict = hotelListDictionary;
    hotelDetails.amentiesDict =[self.availableAmenties objectAtIndex:[seeMoreBtn.hotelIdStr intValue]];
    [self.navigationController pushViewController:hotelDetails animated:YES];
}
-(void)backButtonTapped:(id)sender
{
    
     [self.navigationController popViewControllerAnimated:true];
    
}
-(void)notificationButtonTapped:(id)sender
{
    LoginManager *login = [[LoginManager alloc]init];
    if ([[login isUserLoggedIn] count]>0)
    {
        ICSingletonManager *globals = [ICSingletonManager sharedManager];
        globals.isWithoutLoginNoti = false;
        NotificationScreen *notification = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationScreen"];
        [self.navigationController pushViewController:notification animated:YES];
        
        
        
    }
    else
    {
        ICSingletonManager *globals = [ICSingletonManager sharedManager];
        globals.isWithoutLoginNoti = true;
        [self switchToLoginScreen];
    }
    
}

- (void)switchToLoginScreen
{
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(pushToDashBoardScreenAfterLoggingIn) name:kSwitchToDashBoardScreen object:nil];
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    globals.isFromMenu = false;
    
    LoginScreen *vcLogin = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
    [self.navigationController pushViewController:vcLogin animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
