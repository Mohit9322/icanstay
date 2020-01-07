//
//  CitiesDetailsViewController.m
//  ICanStay
//
//  Created by Namit on 17/11/16.
//  Copyright © 2016 verticallogics. All rights reserved.
//

#import "CitiesDetailsViewController.h"
#import "CitiesDetailTableViewCell.h"
#import "HotelDetailsViewController.h"
#import "NotificationScreen.h"
#import "DashboardScreen.h"
#import "BuyCouponViewController.h"
#import <MoEngage.h>

@interface CitiesDetailsViewController () <UITableViewDelegate,UITableViewDataSource>



@end

@implementation CitiesDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     DLog(@"DEBUG-VC");
    // Do any additional setup after loading the view.
    
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"Hotel By City Name"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    self.cityName.text = @"";
    [self getHotelList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:true];
    if (IS_IPAD) {
        [self.cityName setFont:[UIFont fontWithName:@"JosefinSans-Light" size:29]];
        //self.sliderHeight.constant = 250;
    }
    else
    {
        [self.cityName setFont:[UIFont fontWithName:@"JosefinSans-Light" size:26]];
    }
}

#pragma mark -Notification Actions Methods
- (IBAction)notificationButtonTapped:(id)sender
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
- (void)pushToDashBoardScreenAfterLoggingIn
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    DashboardScreen *dashboardScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"DashboardScreen"];
    [self.mm_drawerController setCenterViewController:dashboardScreen withCloseAnimation:NO completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//http://www.icanstay.com/Api/FAQApi/GetCityiosApi
//http://www.icanstay.com/api/FAQApi/GetCityDetailsByCityIdIOSApi?CityID=1
//http://www.icanstay.com/api/FAQApi/GetHotelsImageIOSApi?hId=60614

#pragma mark - Api Calling Methods
//service to get City List
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
        //self.arrayHotelList = [responseObject objectForKey:@"AvailableHotels"];
        self.arrayHotelList = [responseObject objectForKey:@"OrderCityWiseHotels1"];
        self.availableAmenties = [responseObject objectForKey:@"OrderCityAvailableAmenities"];
//        NSString *cName = [NSString stringWithFormat:@"%lu",(unsigned long)[self.arrayHotelList count]];
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
        style.minimumLineHeight = 30.f;
        style.maximumLineHeight = 30.f;
        NSDictionary *attributtes = @{NSParagraphStyleAttributeName : style,};
        self.cityName.attributedText = [[NSAttributedString alloc] initWithString:stringName
                                                                 attributes:attributtes];
        self.cityName.textAlignment = NSTextAlignmentCenter;

        [self.hotelTableView reloadData];
      
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


#pragma mark - UITableViewDataSource

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
    
    NSAttributedString *attributedText = [self getHTMLAttributedString:webViewHeight];
    CGSize size = CGSizeMake(tableView.frame.size.width-10, CGFLOAT_MAX);
    CGRect paragraphRect =     [attributedText boundingRectWithSize:size
                                                            options:(NSStringDrawingUsesLineFragmentOrigin)
                                                            context:nil];
    

    return 270+paragraphRect.size.height+30;
    
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
    static NSString *cellIdentifier = @"hotelListCell";
    //Storing dictionary value from array at index
    NSDictionary *hotelListDictionary;
    
    hotelListDictionary = [self.arrayHotelList objectAtIndex:indexPath.row];
    
    CitiesDetailTableViewCell *cell = (CitiesDetailTableViewCell *)[theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[CitiesDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    cell.layer.cornerRadius = 5;
    cell.clipsToBounds = true;
    cell.layer.borderWidth = 2.0;
    cell.layer.borderColor = [[UIColor groupTableViewBackgroundColor] CGColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    NSString *hName = @"Luxury Hotel, ";
    cell.hotelName.text = [hName stringByAppendingString:[ICSingletonManager getStringValue:[hotelListDictionary objectForKey:@"HotelName"]]];
    
    cell.ratingView.value = [[hotelListDictionary objectForKey:@"Hotel_Rating"] intValue];
    
   // cell.hotelDescription.text = [ICSingletonManager getStringValue:[hotelListDictionary objectForKey:@"HotelBulletContent"]];
    
    NSString *htmlStr = [ICSingletonManager getStringValue:[NSString stringWithFormat:@"<html><head><style>@import url('https://fonts.googleapis.com/css?family=Gotham');ul{list-style:none;padding: 1px 0px 0px 0px; }ul li {background-image: url(http://www.icanstay.com/Content/Home/images/rev-slider/dot.png);  background-repeat: no-repeat; background-position: 0 0px; padding: 0px 10px 12px 18px; background-size: 13px;font-size: 18px; color:#555;  line-height: 20px; font-family:Josefin Sans, Verdana, Segoe, sans-serif;}</style></head><body>%@</body></html>",[hotelListDictionary objectForKey:@"HotelBulletContent"]]];
    
    [cell.hotelDescriptionWebView loadHTMLString:[ICSingletonManager getStringValue:htmlStr] baseURL:nil];
    
    NSString *webViewHeight = [hotelListDictionary objectForKey:@"HotelBulletContent"];
    
    NSAttributedString *attributedText = [self getHTMLAttributedString:webViewHeight];
    CGSize size = CGSizeMake(theTableView.frame.size.width-10, CGFLOAT_MAX);
    CGRect paragraphRect =     [attributedText boundingRectWithSize:size
                                                            options:(NSStringDrawingUsesLineFragmentOrigin)
                                                            context:nil];
    
    cell.webViewHeightC.constant = paragraphRect.size.height+25;
    
    cell.hotelDescriptionWebView.scrollView.scrollEnabled = NO;
    cell.hotelDescriptionWebView.userInteractionEnabled = YES;

    [cell.btn_BuyVoucher addTarget:self action:@selector(doclickonBuyVoucher) forControlEvents:UIControlEventTouchUpInside];
    //https://1573322668.rsc.cdn77.org/images/cities/
//    
//    NSString * userImage =@"https://1790472363.rsc.cdn77.org/images/cities/";
//    userImage = [userImage stringByAppendingString:[ICSingletonManager getStringValue:[hotelListDictionary objectForKey:@"img1"]]];
//    //userImage = [self getURLFromString:[userImage stringByAppendingString:[ICSingletonManager getStringValue:[userData objectForKey:kDriverProfileImage]]]];
    NSString *str_url =[hotelListDictionary objectForKey:@"img1"];
    NSString *urlStr = [NSString stringWithFormat:@"%@/DataImages/%@",kServerUrl, str_url ];
    NSURL *url =[NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    [cell.hotelImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"photo_frame"]];
    //[cell.cityImage set];
    //cell.cityImage.image = [UIImage imageNamed:@"b1"];
    
    return cell;
}
-(void)doclickonBuyVoucher{
//    LoginManager *login = [[LoginManager alloc]init];
//    if ([[login isUserLoggedIn] count]>0)
//    {
        ICSingletonManager *globals = [ICSingletonManager sharedManager];
        globals.isFromMenuForBuyVoucher = false;
        
        BuyCouponViewController *buyCoupon =[self.storyboard instantiateViewControllerWithIdentifier:@"BuyCouponViewController"];
        [self.navigationController pushViewController:buyCoupon animated:YES];
//    }
//    else
//    {
//        [self switchToLoginScreen];
//    }
    
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

- (IBAction)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

@end
