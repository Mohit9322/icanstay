//
//  HotelDetailsViewController.m
//  ICanStay
//
//  Created by Harish on 17/11/16.
//  Copyright © 2016 verticallogics. All rights reserved.
//

#import "HotelDetailsViewController.h"
#import "BuyCouponViewController.h"
#import "NotificationScreen.h"
#import "DashboardScreen.h"
#import "CollectionViewCell.h"
#import "AppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>
#import "HomeScreenController.h"
#import "SideMenuController.h"

@interface HotelDetailsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    NSMutableArray *arr_amenties;
    IBOutlet UICollectionView *clcv_Ameneties;
    IBOutlet NSLayoutConstraint *clcv_Height;
        UIButton              *baseBookNowBtn;
    GMSCircle *circ;
}
@property (strong, nonatomic) IBOutlet GMSMapView *hotelMapView;
@property (strong, nonatomic) IBOutlet UIImageView *icsLogoImgView;

@end

@implementation HotelDetailsViewController
@synthesize ratingView,amentiesDict;

- (void)viewDidLoad {
    [super viewDidLoad];
     DLog(@"DEBUG-VC");
    // Do any additional setup after loading the view.
    
    AppDelegate *delegate =   (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.fromPageScrollController  = @"NO";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.hotelCity.text = [@"icanstay Hotel, " stringByAppendingString:[ICSingletonManager getStringValue:[self.hotelDict objectForKey:@"HotelName"]]];
//    self.hotelDescription.text = [ICSingletonManager getStringValue:[self.hotelDict objectForKey:@"HotelContent"]];
    self.ratingView.value = [[self.hotelDict objectForKey:@"Hotel_Rating"] intValue];
    
    [self.buyButton setTitle:[NSString stringWithFormat:@"Buy Luxury Stay Voucher \n for ₹2,999 (Incl. GST)"] forState:UIControlStateNormal];
    
        // 978 21
    NSString *MapUrl = [ICSingletonManager getStringValue:[self.hotelDict objectForKey:@"MapUrl"]];
    NSString *urlAddress = [@"<!DOCTYPE html>\n<html>\n<body>\n<iframe  style=\"width:100%;height:500px\" src=\"" stringByAppendingString:MapUrl];
    urlAddress = [urlAddress stringByAppendingString:@"\">\n<p>Your browser does not support iframes.</p>\n</iframe>\n</body>\n</html>"];
   
    arr_amenties = [[NSMutableArray alloc]init];
    NSArray *arr_Name = @[@"Parking",@"Fitness Center",@"Free Wifi",@"Airport Shuttle",@"No Smoking",@"Spa",@"Facilities for Disabled Guests",@"Swimming Pool"];
    NSArray *arr_Icon = @[@"parking",@"fitnesscenetr",@"free-wifi",@"airportshuttle",@"nosmoking",@"spa",@"disabild",@"swimingpool"];
    NSString * Aminity = [amentiesDict valueForKey:@"Aminity"];
    NSArray * amenitiestype = [Aminity componentsSeparatedByString:@","];
    
    NSInteger num = amenitiestype.count;
    if (num % 2){
        // odd
        num++;
    }
    num = num/2;
    NSInteger height = 55*num;
    clcv_Height.constant= height-10;
    
    for (int i = 0; i<amenitiestype.count; i++) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        NSString *str_name = [arr_Name objectAtIndex:[[amenitiestype objectAtIndex:i] intValue]-1];
        [dict setValue:str_name forKey:@"name"];
        NSString *str_icon = [arr_Icon objectAtIndex:[[amenitiestype objectAtIndex:i] intValue]-1];
        [dict setValue:str_icon forKey:@"icon"];
        [arr_amenties addObject:dict];
    }
    //Create a URL object.
    [self.webView loadHTMLString:urlAddress  baseURL:nil];
    [self getHotelImageList];
    
    self.webView.hidden = YES;
    
    float lat = [[_hotelDict objectForKey:@"LATITUDE"] floatValue];
    float longitude = [[_hotelDict objectForKey:@"LONGITUDE"] floatValue];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat
                                                            longitude:longitude
                                                                 zoom:15];
    self.hotelMapView.camera = camera;
    self.hotelMapView.myLocationEnabled = YES;
    self.hotelMapView.userInteractionEnabled = NO;
    
    // Creates a marker in the center of the map.
       [self addCircleToCordinateLatitude:lat andLongitude:longitude withRadius:400];
    
    baseBookNowBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [baseBookNowBtn setBackgroundColor:[ICSingletonManager colorFromHexString:@"#bd9854"]];
    [baseBookNowBtn setTintColor:[UIColor blackColor]];
   
   
    [baseBookNowBtn addTarget:self action:@selector(bookNowBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
      [baseBookNowBtn setTitle:@"Buy Luxury Stay Voucher for ₹2,999(Incl. GST)" forState:UIControlStateNormal];
    
    baseBookNowBtn.frame = CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [baseBookNowBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
    }else{
        [baseBookNowBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    }
    [self.view addSubview:baseBookNowBtn];
    self.icsLogoImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.icsLogoImgView addGestureRecognizer:singleFingerTap];

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
- (void)addCircleToCordinateLatitude:(double)lat andLongitude:(double)longitude withRadius:(int)rad
{
    CLLocationCoordinate2D circleCenter = CLLocationCoordinate2DMake(lat, longitude);
    circ = [GMSCircle circleWithPosition:circleCenter
                                  radius:rad];
    circ.fillColor = [UIColor  colorWithRed:0.8196 green:0.8784 blue:0.9137 alpha:1.0];
    circ.strokeColor = [ICSingletonManager colorFromHexString:@"#1E90FF"];
    
    circ.map = self.hotelMapView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"Hotel Detail"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    self.imagePager.pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
    self.imagePager.pageControl.pageIndicatorTintColor = [UIColor blackColor];
    self.imagePager.slideshowTimeInterval = 2.5f;
    self.imagePager.slideshowShouldCallScrollToDelegate = YES;
    
    if (IS_IPAD) {
        [self.buyButton setTitle:[NSString stringWithFormat:@"Buy Luxury Stay Voucher for  ₹2,999 (Incl. GST)"] forState:UIControlStateNormal];
        self.pageerHeight.constant = 350;
        //self.viewHeight.constant = 1200;
        [self.hotelCity setFont:[UIFont fontWithName:@"JosefinSans" size:29]];
        //[self.hotelDescription setFont:[UIFont fontWithName:@"JosefinSans" size:22]];
        [self.label1 setFont:[UIFont fontWithName:@"JosefinSans-Light" size:22]];
        [self.label2 setFont:[UIFont fontWithName:@"JosefinSans-Light" size:22]];
        [self.label3 setFont:[UIFont fontWithName:@"JosefinSans-Light" size:22]];
        [self.label4 setFont:[UIFont fontWithName:@"JosefinSans-Light" size:22]];
        [self.label5 setFont:[UIFont fontWithName:@"JosefinSans-Light" size:22]];
        [self.label6 setFont:[UIFont fontWithName:@"JosefinSans-Light" size:22]];
        [self.label7 setFont:[UIFont fontWithName:@"JosefinSans-Light" size:22]];
        [self.label8 setFont:[UIFont fontWithName:@"JosefinSans-Light" size:22]];
        [self.buyButton.titleLabel setFont:[UIFont fontWithName:@"JosefinSans-Bold" size:27]];
    }
    else
    {
        [self.buyButton setTitle:[NSString stringWithFormat:@"Buy Luxury Stay Voucher \n for  ₹2,999 (Incl. GST)"] forState:UIControlStateNormal];
        
        self.buyButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.hotelCity setFont:[UIFont fontWithName:@"JosefinSans" size:24]];
        //[self.hotelDescription setFont:[UIFont fontWithName:@"JosefinSans" size:18]];
        [self.label1 setFont:[UIFont fontWithName:@"JosefinSans-Light" size:18]];
        [self.label2 setFont:[UIFont fontWithName:@"JosefinSans-Light" size:18]];
        [self.label3 setFont:[UIFont fontWithName:@"JosefinSans-Light" size:18]];
        [self.label4 setFont:[UIFont fontWithName:@"JosefinSans-Light" size:18]];
        [self.label5 setFont:[UIFont fontWithName:@"JosefinSans-Light" size:18]];
        [self.label6 setFont:[UIFont fontWithName:@"JosefinSans-Light" size:18]];
        [self.label7 setFont:[UIFont fontWithName:@"JosefinSans-Light" size:18]];
        [self.label8 setFont:[UIFont fontWithName:@"JosefinSans-Light" size:18]];
        [self.buyButton.titleLabel setFont:[UIFont fontWithName:@"JosefinSans-Bold" size:23]];
    }
    
    NSString * cityName = [ICSingletonManager getStringValue:[self.hotelDict objectForKey:@"HotelContent"]];

    NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
    style.minimumLineHeight = 25.f;
    style.maximumLineHeight = 25.f;
    NSDictionary *attributtes = @{NSParagraphStyleAttributeName : style,};
    self.hotelDescription.attributedText = [[NSAttributedString alloc] initWithString:cityName
                                                                   attributes:attributtes];
    //self.hotelDescription.textAlignment = NSTextAlignmentCenter;
    
    CGSize h;
    if (IS_IPAD) {
        h  = [ICSingletonManager findHeightForText:[ICSingletonManager getStringValue:[self.hotelDict objectForKey:@"HotelContent"]] havingWidth:SCREEN_WIDTH-10 andFont:[UIFont fontWithName:@"JosefinSans-Light" size:23]];
        [self.hotelDescription setFont:[UIFont fontWithName:@"JosefinSans-Light" size:23]];
        self.hotelDescHeight.constant = h.height+30;
    }
    else
    {
        h  = [ICSingletonManager findHeightForText:[ICSingletonManager getStringValue:[self.hotelDict objectForKey:@"HotelContent"]] havingWidth:SCREEN_WIDTH-10 andFont:[UIFont fontWithName:@"JosefinSans-Light" size:18]];
        [self.hotelDescription setFont:[UIFont fontWithName:@"JosefinSans-Light" size:18]];
        self.hotelDescHeight.constant = h.height+115;
    }
    
    

    
    self.viewHeight.constant = 1080 + h.height;
    
    if (IS_IPAD) 
        self.viewHeight.constant = 1050+ h.height+130;
}

- (IBAction)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

-(void)bookNowBtnTapped:(id)sender
{
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    globals.isFromMenuForBuyVoucher = false;
    BuyCouponViewController *buyCoupon =[self.storyboard instantiateViewControllerWithIdentifier:@"BuyCouponViewController"];
    [self.navigationController pushViewController:buyCoupon animated:YES];
}
- (IBAction)buyVoucherTapped:(id)sender {
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
//        ICSingletonManager *globals = [ICSingletonManager sharedManager];
//        globals.isFromMenu = false;
//        
//        LoginScreen *vcLogin = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
//        [self.navigationController pushViewController:vcLogin animated:YES];    }

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

#pragma mark - KIImagePager DataSource
- (NSArray *) arrayWithImages:(KIImagePager*)pager
{
    return imageArray;
}

- (UIViewContentMode) contentModeForImage:(NSUInteger)image inPager:(KIImagePager *)pager
{
    return UIViewContentModeScaleAspectFill;
}

- (NSString *) captionForImageAtIndex:(NSUInteger)index inPager:(KIImagePager *)pager
{
    return nil;
}

#pragma mark - KIImagePager Delegate
- (void) imagePager:(KIImagePager *)imagePager didScrollToIndex:(NSUInteger)index
{
    //NSLog(@"%s %lu", __PRETTY_FUNCTION__, (unsigned long)index);
}

- (void) imagePager:(KIImagePager *)imagePager didSelectImageAtIndex:(NSUInteger)index
{
    //NSLog(@"%s %lu", __PRETTY_FUNCTION__, (unsigned long)index);
}


#pragma mark - Api Calling Methods
//service to get City List
-(void)getHotelImageList
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    //http://www.icanstay.com/Api/FAQApi/GetCityApi
    //http://www.icanstay.com/api/FAQApi/GetHotelsImageIOSApi?hId=60614

    [manager GET:[NSString stringWithFormat:@"http://www.icanstay.com/api/FAQApi/GetHotelsImageIOSApi?hId=%@",[self.hotelDict objectForKey:@"Hotel_Id"]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        NSArray *tempImageArray = responseObject;
    
        NSMutableArray *tempMarray = [[NSMutableArray alloc] init];
        for (int i=0; i<tempImageArray.count; i++) {
            
//            NSString * userImage = @"https://1790472363.rsc.cdn77.org/images/cities/";
//            userImage = [userImage stringByAppendingString:[ICSingletonManager getStringValue:[[tempImageArray objectAtIndex:i] valueForKey:@"CityImage"]]];
            [tempMarray addObject:[[tempImageArray objectAtIndex:i] valueForKey:@"CityImage"]];
        }
        
        imageArray = [tempMarray mutableCopy];
        [self.imagePager reloadData];
        
//        [self.hotelTableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
       
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:error.localizedDescription onController:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return arr_amenties.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.lbl_Name.text = [[arr_amenties valueForKey:@"name"] objectAtIndex:indexPath.row];
    cell.img_Icon.image = [UIImage imageNamed:[[arr_amenties valueForKey:@"icon"] objectAtIndex:indexPath.row]];
    
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(collectionView.frame.size.width/2-10, 40);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
