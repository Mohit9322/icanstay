//
//  SideMenuController.m
//  ICanStay
//
//  Created by Namit Aggarwal on 23/02/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import "SideMenuController.h"
#import "SideMenuCell.h"
#import "AboutUsScreen.h"
#import "FaqScreen.h"
#import "ContactUsScreen.h"
#import "HelpScreen.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "HomeScreenController.h"
#import "DashboardScreen.h"
#import <AFNetworking/AFNetworking.h>
#import "MBProgressHUD.h"
#import "NSDictionary+JsonString.h"
#import "BuyCouponViewController.h"
#import "CitiesViewController.h"
#import "MapScreen.h"
#import "MakeAWishlistViewController.h"
#import "MyCouponViewController.h"
#import "CurrentStayScreen.h"
#import "AccountScreen.h"
#import "ProfileScreen.h"
#import "MyWishlistViewController.h"
#import <Google/Analytics.h>
#import "GiftaStayViewController.h"
#import "GiftVouchersViewController.h"
#import "AppDelegate.h"
#import "PackagesViewController.h"
#import "LastMinuteViewController.h"
#import "OfferViewController.h"
#import "SideMenuNewTableViewCell.h"
#import "ReferAndEarnVC.h"
#import "CancashController.h"
#import "RegistrationScreen.h"
#import "ReferAndEarnUnregistered.h"

@interface SideMenuController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate
>{
    NSMutableArray *arr_result;
}
@property (weak, nonatomic) IBOutlet UIView *profileImageBaseView;
@property (weak, nonatomic) IBOutlet UIView *tableBaseView;
@property (nonatomic,retain)NSMutableArray *arrOptionsInSideMenu;
@property (weak, nonatomic) IBOutlet UITableView *tblViewSideMenuOptions;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewProfilePic;

@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UIButton *btnLogout;
@property (retain, nonatomic) NSArray* arrOptionsInSideMenuImages;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;

@property (strong, nonatomic) IBOutlet UIView *viewForHeight;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tblheight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *profileViewHeight;




- (IBAction)btnLogOutTapped:(id)sender;
- (IBAction)btnEditImageTapped:(id)sender;


@end

@implementation SideMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
     DLog(@"DEBUG-VC");
    // Do any additional setup after loading the view.
    _tblheight.constant = 1100;
    _viewHeight.constant = 1100;
    
    _scrollview.contentSize = CGSizeMake(self.view.frame.size.width, _tblViewSideMenuOptions.frame.origin.y+_tblViewSideMenuOptions.frame.size.height);
    
    _imgViewProfilePic.layer.cornerRadius = _imgViewProfilePic.frame.size.height/2;
    _imgViewProfilePic.clipsToBounds = YES;
    
   
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:true];
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"Drawer"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    self.arrOptionsInSideMenu = [[NSMutableArray alloc]init];
    //    [self.arrOptionsInSideMenu addObject:@"Home"];
    //    [self.arrOptionsInSideMenu addObject:@"Dashboard"];
    //    [self.arrOptionsInSideMenu addObject:@"Cities"];
    //    [self.arrOptionsInSideMenu addObject:@"Buy Voucher"];
    //    [self.arrOptionsInSideMenu addObject:@"Redeem Voucher"];
    
//    ((AppDelegate *)[UIApplication sharedApplication].delegate).loginStatusVar = @"NotLogin";
//    NSLog(@"session id = %@", ((AppDelegate *)[UIApplication sharedApplication].delegate).loginStatusVar);

    
    LoginManager *login = [[LoginManager alloc]init];
        if ([[login isUserLoggedIn] count]>0)
        {
 self.arrOptionsInSideMenuImages = @[@"home",@"buy_menu",@"plan",@"search1",@"Hotels",@"lastMinuteDeal",@"packages",@"OfferIcon",@"giftStay",@"voucher_menu",@"stay_menu",@"wishlist_menu",@"giftStay"];
        }else{
            
             self.arrOptionsInSideMenuImages = @[@"home",@"buy_menu",@"plan",@"search1",@"Hotels",@"lastMinuteDeal",@"packages",@"OfferIcon",@"giftStay"];
        }
    
    
    [self.arrOptionsInSideMenu addObject:@"Home"];
    [self.arrOptionsInSideMenu addObject:@"Buy Voucher"];
    [self.arrOptionsInSideMenu addObject:@"Create Wishlist"];
    [self.arrOptionsInSideMenu addObject:@"Search Your Stay"];
    [self.arrOptionsInSideMenu addObject:@"Hotels"];
    [self.arrOptionsInSideMenu addObject:@"Last Minute Deals"];
    [self.arrOptionsInSideMenu addObject:@"Packages"];
    [self.arrOptionsInSideMenu addObject:@"Offers"];
    [self.arrOptionsInSideMenu addObject:@"Gift a Stay"];
   
    if ([[login isUserLoggedIn] count]>0)
    {
        [self.arrOptionsInSideMenu addObject:@"My Vouchers"];
        [self.arrOptionsInSideMenu addObject:@"My Stays"];
        [self.arrOptionsInSideMenu addObject:@"Wishlist"];
        [self.arrOptionsInSideMenu addObject:@"Gift Your Vouchers"];
        
       
        [self.arrOptionsInSideMenu addObject:@"My Profile"];
        [self.arrOptionsInSideMenu addObject:@"Account Details"];
        [self.arrOptionsInSideMenu addObject:@"Refer & Earn"];
        [self.arrOptionsInSideMenu addObject:@"My icanCash"];
        
    }else{
         [self.arrOptionsInSideMenu addObject:@"Refer & Earn"];
         [self.arrOptionsInSideMenu addObject:@"Login"];
        [self.arrOptionsInSideMenu addObject:@"Register"];
    }
   
    
    [self.arrOptionsInSideMenu addObject:@"FAQ"];
    [self.arrOptionsInSideMenu addObject:@"About Us"];
    [self.arrOptionsInSideMenu addObject:@"Contact Us"];
    
    
//    LoginManager *loginManage = [[LoginManager alloc]init];
//    NSDictionary *dict = [loginManage isUserLoggedIn];
//    if (dict.count >0)
//    {
//        [self.arrOptionsInSideMenu addObject:@"Logout"];
//    }
//    else{
//        [self.arrOptionsInSideMenu addObject:@"Login/Register"];
//        
//    }
   
  
    
    
    //    self.arrOptionsInSideMenuImages = @[@"home", @"dashboard", @"cities", @"buy_menu", @"redeem_menu"];
    
   
      [self addingBordersToProfilePic];
    
   
    if ([[login isUserLoggedIn] count]>0)
    {
         ICSingletonManager *globals = [ICSingletonManager sharedManager];
        if ([globals.isFirstTimeMenuLoadWebService isEqualToString:@""]) {
            [self startServiceToGeticanCash];
            
        }else if (![globals.isFirstTimeMenuLoadWebService isEqualToString:@""])
        {
            
            [self.arrOptionsInSideMenu removeObjectAtIndex:9];
            [self.arrOptionsInSideMenu insertObject:[NSString stringWithFormat:@"My Vouchers (%@)",globals.myVoucherCount] atIndex:9];
            
            [self.arrOptionsInSideMenu removeObjectAtIndex:10];
            [self.arrOptionsInSideMenu insertObject:[NSString stringWithFormat:@"My Stays (%@)",globals.staysCount] atIndex:10];
            [self.arrOptionsInSideMenu removeObjectAtIndex:11];
            [self.arrOptionsInSideMenu insertObject:[NSString stringWithFormat:@"Wishlist (%@)",globals.wishlistCount] atIndex:11];
            
            [self.arrOptionsInSideMenu removeObjectAtIndex:16];
            [self.arrOptionsInSideMenu insertObject:[NSString stringWithFormat:@"%@ (%@)",@"My icanCash", globals.userCancashAmountAvailable] atIndex:16];
            
            
        }
        
       
        
    }
    
     [self.tblViewSideMenuOptions reloadData];
//    else
//    {
//        [self.arrOptionsInSideMenu removeObjectAtIndex:8];
//        [self.arrOptionsInSideMenu insertObject:[NSString stringWithFormat:@"My Vouchers"] atIndex:8];
//        
//        [self.arrOptionsInSideMenu removeObjectAtIndex:7];
//        [self.arrOptionsInSideMenu insertObject:[NSString stringWithFormat:@"Stays"] atIndex:7];
//        
//        [self.arrOptionsInSideMenu removeObjectAtIndex:6];
//        [self.arrOptionsInSideMenu insertObject:[NSString stringWithFormat:@"Wishlist"] atIndex:6];
//        [self.tblViewSideMenuOptions reloadData];
//    }

    
   }

- (void)addingBordersToProfilePic
{
    //12,38,62
//    CGFloat borderWidth = 5.0f;
//    
//   // self.frame = CGRectInset(self.frame, -borderWidth, -borderWidth);
//    self.imgViewProfilePic.layer.borderColor = [UIColor colorWithRed:0.047f green:0.149f blue:0.243f alpha:1].CGColor;
//    self.imgViewProfilePic.layer.borderWidth = borderWidth;
//    self.imgViewProfilePic.layer.cornerRadius = self.imgViewProfilePic.frame.size.width/2;
//    self.imgViewProfilePic.clipsToBounds = YES;
    
    [self showingProfilePicFromStoredUserDefaultsData];
    
}


- (void)showingProfilePicFromStoredUserDefaultsData{
    
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    if (dict.count >0)
    {
        NSString *strProfilePic = [dict valueForKey:@"ProfilePic"];
        NSData* data = [[NSData alloc] initWithBase64EncodedString:[ICSingletonManager getStringValue:strProfilePic] options:NSDataBase64DecodingIgnoreUnknownCharacters];
        self.imgViewProfilePic.image = nil;

        UIImage *ret = [UIImage imageWithData:data];
            if (ret)
                [self.imgViewProfilePic setImage:ret];
            else
                if ([[dict objectForKey:@"Gender"] isEqualToString:@"M"]) {
                    [self.imgViewProfilePic setImage:[UIImage imageNamed:@"man"]];
                }else{
                  //  [self.imgViewProfilePic setImage:[UIImage imageNamed:@"woman"]];
                     [self.imgViewProfilePic setImage:[UIImage imageNamed:@"man"]];

                }

        self.lblUserName.text =[NSString stringWithFormat:@"%@ %@", [dict objectForKey:@"FirstName"], [dict objectForKey:@"LastName"]];

        [self.btnLogout setTitle:@"Logout" forState:UIControlStateNormal];

        [self.btnLogout setHidden:NO];
        [self.imgViewProfilePic setHidden:NO];
        
        _profileViewHeight.constant = 200;
//        _tblheight.constant = 710;
//        _viewHeight.constant = 710;
        _tblheight.constant = 1100;
        _viewHeight.constant = 1000;
        _viewForHeight.frame = CGRectMake(0, 200, _viewForHeight.frame.size.width, _viewForHeight.frame.size.height);
        _scrollview.contentSize = CGSizeMake(self.view.frame.size.width, _viewForHeight.frame.origin.y+_viewForHeight.frame.size.height );
    }
    else
    {
        [self.btnLogout setHidden:NO];
        [self.btnLogout setTitle:@"Login / Register" forState:UIControlStateNormal];
        [self.imgViewProfilePic setImage:[UIImage imageNamed:@"man"]];
//        self.imgViewProfilePic.image = nil;
        [self.lblUserName setText:@""];
        [self.imgViewProfilePic setHidden:YES];
        
        _profileViewHeight.constant = 0;
//        _tblheight.constant = 710-200;
        //_viewHeight.constant = 710-200;
        _tblheight.constant = 800;
        _viewHeight.constant = 800;
        _viewForHeight.frame = CGRectMake(0, 0, _viewForHeight.frame.size.width, _viewForHeight.frame.size.height);
        _scrollview.contentSize = CGSizeMake(self.view.frame.size.width, _viewForHeight.frame.origin.y+_viewForHeight.frame.size.height );
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITableViewDelegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.arrOptionsInSideMenu count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    
    
    LoginManager *login = [[LoginManager alloc]init];
    if ([[login isUserLoggedIn] count]>0)
    {    if (indexPath.row < 13)
    {
        SideMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SideMenuCell"];
        cell.lblOptions.text = [self.arrOptionsInSideMenu objectAtIndex:indexPath.row];
        [cell.imageOptions setImage:[UIImage imageNamed:[self.arrOptionsInSideMenuImages objectAtIndex:indexPath.row]]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0)
        {
            [cell.lblLine setHidden:false];
        }else if (indexPath.row == 9){
             [cell.lblLine setHidden:false];
        }else
        {
            [cell.lblLine setHidden:true];
        }
        return cell;
    }else if (indexPath.row == 15 || indexPath.row == 16){
        
        SideMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SideNewCell"];
        [cell.lblLine setHidden:true];
        cell.lblOptions.text = [self.arrOptionsInSideMenu objectAtIndex:indexPath.row];
        
        UILabel *newLbl = [[UILabel alloc]init];
        if (indexPath.row == 15) {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                 newLbl.frame =  CGRectMake(170, 10, 50, 20);
            }else{
                newLbl.frame =  CGRectMake(135, 10, 50, 20);
            }
            
        }else if (indexPath.row == 16){
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                newLbl.frame =  CGRectMake(240, 10, 50, 20);
            }else{
                newLbl.frame =  CGRectMake(165, 0, 50, 20);
            }
           
        }
        newLbl.backgroundColor = [UIColor redColor];
        newLbl.text = @"New";
        newLbl.textColor = [UIColor whiteColor];
        newLbl.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:newLbl];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
         return cell;
    }else
    {
        NSLog(@"indexpath- %ld value %@",(long)indexPath.row,[self.arrOptionsInSideMenu objectAtIndex:indexPath.row]);
        SideMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SideCell"];
        if (indexPath.row == 13)
        {
            [cell.lblLine setHidden:false];
        }
        else
        {
            [cell.lblLine setHidden:true];
        }
        cell.lblOptions.text = [self.arrOptionsInSideMenu objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    }else  {
        
   if ((indexPath.row >= 0) &&  indexPath.row < 9)
   {
        SideMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SideMenuCell"];
        cell.lblOptions.text = [self.arrOptionsInSideMenu objectAtIndex:indexPath.row];
        [cell.imageOptions setImage:[UIImage imageNamed:[self.arrOptionsInSideMenuImages objectAtIndex:indexPath.row]]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
       if (indexPath.row == 9)
        {
            [cell.lblLine setHidden:false];
        }else
        {
            [cell.lblLine setHidden:true];
        }
        return cell;
   }else
    {
        NSLog(@"indexpath- %ld value %@",(long)indexPath.row,[self.arrOptionsInSideMenu objectAtIndex:indexPath.row]);
        SideMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SideCell"];
        if (indexPath.row == 9)
        {
            
            UILabel *newLbl = [[UILabel alloc]init];
           
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                    newLbl.frame =  CGRectMake(170, 10, 50, 20);
                }else{
                    newLbl.frame =  CGRectMake(135, 10, 50, 20);
                }
            
            newLbl.backgroundColor = [UIColor redColor];
            newLbl.text = @"New";
            newLbl.textColor = [UIColor whiteColor];
            newLbl.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:newLbl];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.lblLine setHidden:false];
        }
        else
        {
            [cell.lblLine setHidden:true];
       }
        cell.lblOptions.text = [self.arrOptionsInSideMenu objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //   cell.backgroundColor = [UIColor colorWithRed:239/255 green:140/255 blue:63/255 alpha:1.0];

    //cell.selectionStyle =UITableViewCellSelectionStyleBlue;
    SideMenuCell *sideMenuCell = (SideMenuCell *)cell;
 
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    LoginManager *login = [[LoginManager alloc]init];
   
   
    if ([sideMenuCell.lblOptions.text isEqualToString:@"Offers"])
    {
        
        OfferViewController *offer = [self.storyboard instantiateViewControllerWithIdentifier:@"OfferViewController"];
        [self.mm_drawerController setCenterViewController:offer withCloseAnimation:YES completion:nil];
    }else   if ([sideMenuCell.lblOptions.text isEqualToString:@"Login"])
         {
             ICSingletonManager *globals = [ICSingletonManager sharedManager];
             globals.isFromMenu = true;
             LoginScreen *vcLogin = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
             [self.mm_drawerController setCenterViewController:vcLogin withCloseAnimation:YES completion:nil];
         }else   if ([sideMenuCell.lblOptions.text isEqualToString:@"Register"])
         {
             ICSingletonManager *globals = [ICSingletonManager sharedManager];
             globals.isFromMenu = true;
              globals.registrationBackManage = @"YES";
             
             RegistrationScreen *registerScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"RegistrationScreen"];
            
             [self.mm_drawerController setCenterViewController:registerScreen withCloseAnimation:YES completion:nil];
         }else   if ([sideMenuCell.lblOptions.text isEqualToString:@"Refer & Earn"])
         {
             LoginManager *login = [[LoginManager alloc]init];
             if ([[login isUserLoggedIn] count]>0)
             {
                 ICSingletonManager *globals = [ICSingletonManager sharedManager];
                 globals.isFromMenu = true;
                 ReferAndEarnVC *refer = [self.storyboard instantiateViewControllerWithIdentifier:@"ReferAndEarnVC"];
                 
                 globals.isFromMenuLastMinuteDeal = @"NO";
                 [self.mm_drawerController setCenterViewController:refer withCloseAnimation:YES completion:nil];
             }else{
                 ReferAndEarnUnregistered *refer = [self.storyboard instantiateViewControllerWithIdentifier:@"ReferAndEarnUnregistered"];
                 ICSingletonManager *globals = [ICSingletonManager sharedManager];
                 globals.ReferAndEarnFromHome = @"YES";
                [self.mm_drawerController setCenterViewController:refer withCloseAnimation:YES completion:nil];
             }
             
         }else if ([sideMenuCell.lblOptions.text isEqualToString:@"Home"])
         {
             HomeScreenController *homeScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeScreenController"];
             [self.mm_drawerController setCenterViewController:homeScreen withCloseAnimation:YES completion:nil];
         }
         else if ([sideMenuCell.lblOptions.text isEqualToString:@"Dashboard"])
         {
             LoginManager *login = [[LoginManager alloc]init];
             if ([[login isUserLoggedIn] count]>0)
             {
                 DashboardScreen *dashboardScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"DashboardScreen"];
                 [self.mm_drawerController setCenterViewController:dashboardScreen withCloseAnimation:YES completion:nil];
             }
             else
             {
                 globals.isFromMenu = true;
                 LoginScreen *vcLogin = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
                 [self.mm_drawerController setCenterViewController:vcLogin withCloseAnimation:YES completion:nil];
             }
         }
         else if ([sideMenuCell.lblOptions.text isEqualToString:@"Hotels"])
         {
             globals.isFromMenu = true;
             CitiesViewController *cityScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"CitiesViewController"];
             [self.mm_drawerController setCenterViewController:cityScreen withCloseAnimation:YES completion:nil];
         }
         else if ([sideMenuCell.lblOptions.text isEqualToString:@"Packages"])
         {
             globals.isFromMenu = true;
             PackagesViewController *PackageScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"PackagesViewController"];
                         [self.mm_drawerController setCenterViewController:PackageScreen withCloseAnimation:YES completion:nil];
         }
         else if ([sideMenuCell.lblOptions.text isEqualToString:@"Buy Voucher"])
         {
             //        LoginManager *login = [[LoginManager alloc]init];
             //        if ([[login isUserLoggedIn] count]>0)
             //        {
             ICSingletonManager *globals = [ICSingletonManager sharedManager];
             globals.isFromMenuForBuyVoucher = true;
             
             BuyCouponViewController *buyCoupon =[self.storyboard instantiateViewControllerWithIdentifier:@"BuyCouponViewController"];
             [self.mm_drawerController setCenterViewController:buyCoupon withCloseAnimation:YES completion:nil];
             //        }
             //        else
             //        {
             //            globals.isFromMenu = true;
             //            globals.isFromMenuForBuyVoucher = true;
             //            globals.strWhichScreen = @"BuyVoucher";
             //            LoginScreen *vcLogin = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
             //            [self.mm_drawerController setCenterViewController:vcLogin withCloseAnimation:YES completion:nil];
             //        }
         }
         else if ([sideMenuCell.lblOptions.text isEqualToString:@"Gift a Stay"])
         {
             //        ICSingletonManager *globals = [ICSingletonManager sharedManager];
             GiftaStayViewController *giftaStay =[self.storyboard instantiateViewControllerWithIdentifier:@"GiftaStayViewController"];
             [self.mm_drawerController setCenterViewController:giftaStay withCloseAnimation:YES completion:nil];
             
         }
         else if ([sideMenuCell.lblOptions.text isEqualToString:@"Search Your Stay"])
         {
             LoginManager *manager = [[LoginManager alloc]init];
             NSDictionary *dict = [manager isUserLoggedIn];
             if (dict.count>0)
             {
//                 ICSingletonManager *globals = [ICSingletonManager sharedManager];
//                 if ([[NSUserDefaults standardUserDefaults] integerForKey:@"validVoucher"] != 0) {
                     UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Search Your Stay" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"By Current Location",@"By City", nil];
                     [alert show];
//                 }
//                 else{
//                     ICSingletonManager *globals = [ICSingletonManager sharedManager];
//                     globals.isFromMenuForBuyVoucher = true;
//                     
//                     BuyCouponViewController *buyCoupon =[self.storyboard instantiateViewControllerWithIdentifier:@"BuyCouponViewController"];
//                     [self.mm_drawerController setCenterViewController:buyCoupon withCloseAnimation:YES completion:nil];
//                 }
             }
             else
             {
                 globals.isFromMenu = true;
                 globals.strWhichScreen = @"SearchYourStay";
                 LoginScreen *vcLogin = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
                 [self.mm_drawerController setCenterViewController:vcLogin withCloseAnimation:YES completion:nil];
             }
             
             //        ContactUsScreen *contactScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactUsScreen"];
             //        [self.mm_drawerController setCenterViewController:contactScreen withCloseAnimation:YES completion:nil];
         }
         else if ([sideMenuCell.lblOptions.text isEqualToString:@"Create Wishlist"])
         {
             LoginManager *login = [[LoginManager alloc]init];
             if ([[login isUserLoggedIn] count]>0)
             {
                 ICSingletonManager *globals = [ICSingletonManager sharedManager];
                 globals.isFromMenuForWishList = true;
                 
                 MyWishlistViewController *buyCoupon =[self.storyboard instantiateViewControllerWithIdentifier:@"MyWishlistViewController"];
                 [self.mm_drawerController setCenterViewController:buyCoupon withCloseAnimation:YES completion:nil];
             }
             else
             {
                 globals.isFromMenu = true;
                 LoginScreen *vcLogin = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
                 globals.isFromMenuForMakeWishe = true;
                 globals.strWhichScreen = @"MakeWishList";
                 [self.mm_drawerController setCenterViewController:vcLogin withCloseAnimation:YES completion:nil];
             }
         }
    
    
    
    if ([[login isUserLoggedIn] count]>0){
        
        if (indexPath.row == 16) {
            CancashController *CancashController = [self.storyboard instantiateViewControllerWithIdentifier:@"CancashController"];
            [self.mm_drawerController setCenterViewController:CancashController withCloseAnimation:YES completion:nil];
            
        }else if (indexPath.row == 9)
                 {
                     LoginManager *login = [[LoginManager alloc]init];
                     if ([[login isUserLoggedIn] count]>0)
                     {
                         if ([[globals.menuLoadArry valueForKey:@"UserCouponCount"] intValue]!=0) {
                             ICSingletonManager *globals = [ICSingletonManager sharedManager];
                             globals.isFromMenu = true;
                             
                             MyCouponViewController *buyCoupon =[self.storyboard instantiateViewControllerWithIdentifier:@"MyCouponViewController"];
                             buyCoupon.str_CoupenCount = [globals.menuLoadArry valueForKey:@"UserCouponCount"];
                             [self.mm_drawerController setCenterViewController:buyCoupon withCloseAnimation:YES completion:nil];
                         }
                         else{
                             [[ICSingletonManager sharedManager] showAlertViewWithMsg:@"No Voucher Found" onController:self];
                         }
                         
                     }
                     else
                     {
                         globals.isFromMenu = true;
                         globals.strWhichScreen = @"MyCoupon";
                         LoginScreen *vcLogin = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
                         [self.mm_drawerController setCenterViewController:vcLogin withCloseAnimation:YES completion:nil];
                     }
                 }
                 else if (indexPath.row == 11)
                 {
                     LoginManager *login = [[LoginManager alloc]init];
                     if ([[login isUserLoggedIn] count]>0)
                     {
                         if ([[globals.menuLoadArry valueForKey:@"UserWishlistCount"] intValue]!=0) {
                             ICSingletonManager *globals = [ICSingletonManager sharedManager];
                             globals.isFromMenuForWishList = true;
                             
                             MyWishlistViewController *buyCoupon =[self.storyboard instantiateViewControllerWithIdentifier:@"MyWishlistViewController"];
                             [self.mm_drawerController setCenterViewController:buyCoupon withCloseAnimation:YES completion:nil];
                         }
                         else{
                             [[ICSingletonManager sharedManager] showAlertViewWithMsg:@"No Wishlist Found" onController:self];
                         }
                         
                         
                     }
                     else
                     {
                         globals.isFromMenu = true;
                         globals.strWhichScreen = @"MyWishlist";
                         LoginScreen *vcLogin = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
                         [self.mm_drawerController setCenterViewController:vcLogin withCloseAnimation:YES completion:nil];
                     }
                 }
                 else if (indexPath.row == 10)
                 {
                     LoginManager *login = [[LoginManager alloc]init];
                     if ([[login isUserLoggedIn] count]>0)
                     {
                         if ([[globals.menuLoadArry valueForKey:@"UserPastStayCount"] intValue]!=0) {
                             ICSingletonManager *globals = [ICSingletonManager sharedManager];
                             globals.isFromMenu = true;
                             
                             CurrentStayScreen *buyCoupon =[self.storyboard instantiateViewControllerWithIdentifier:@"CurrentStayScreen"];
                             [self.mm_drawerController setCenterViewController:buyCoupon withCloseAnimation:YES completion:nil];
                         }
                         else{
                             [[ICSingletonManager sharedManager] showAlertViewWithMsg:@"No Current Stay Found" onController:self];
                         }
                         
                     }
                     else
                     {
                         globals.isFromMenu = true;
                         globals.strWhichScreen = @"CurrentStayScreen";
                         LoginScreen *vcLogin = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
                         [self.mm_drawerController setCenterViewController:vcLogin withCloseAnimation:YES completion:nil];
                     }
                 }
        
        if ([sideMenuCell.lblOptions.text isEqualToString:@"Gift Your Vouchers"])
        {
            LoginManager *login = [[LoginManager alloc]init];
            if ([[login isUserLoggedIn] count]>0)
            {
                GiftVouchersViewController *giftVouchers =[self.storyboard instantiateViewControllerWithIdentifier:@"GiftVouchersViewController"];
                [self.mm_drawerController setCenterViewController:giftVouchers withCloseAnimation:YES completion:nil];
            }
            else
            {
                globals.isFromMenu = true;
                globals.strWhichScreen = @"GiftVouchers";
                LoginScreen *vcLogin = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
                [self.mm_drawerController setCenterViewController:vcLogin withCloseAnimation:YES completion:nil];
            }
        }
        
        if ([sideMenuCell.lblOptions.text isEqualToString:@"FAQ"]) {
            ICSingletonManager *globals = [ICSingletonManager sharedManager];
            globals.isFromMenu = true;
            
            FaqScreen *faqScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"FaqScreen"];
            [self.mm_drawerController setCenterViewController:faqScreen withCloseAnimation:YES completion:nil];
        }
        if ([sideMenuCell.lblOptions.text isEqualToString:@"About Us"]) {
            AboutUsScreen *aboutUsScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutUsScreen"];
            [self.mm_drawerController setCenterViewController:aboutUsScreen withCloseAnimation:YES completion:nil];
        }
        if ([sideMenuCell.lblOptions.text isEqualToString:@"Contact Us"]) {
            ContactUsScreen *contactScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactUsScreen"];
            [self.mm_drawerController setCenterViewController:contactScreen withCloseAnimation:YES completion:nil];
            
        }
        
        if ([sideMenuCell.lblOptions.text isEqualToString:@"Last Minute Deals"]) {
            
            LastMinuteViewController *lastMinuteScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"LastMinuteViewController"];
            [self.mm_drawerController setCenterViewController:lastMinuteScreen withCloseAnimation:YES completion:nil];
        }

        if ([sideMenuCell.lblOptions.text isEqualToString:@"My Profile"])
        {
            LoginManager *login = [[LoginManager alloc]init];
            if ([[login isUserLoggedIn] count]>0)
            {
                ICSingletonManager *globals = [ICSingletonManager sharedManager];
                globals.isFromMenu = true;
                
                ProfileScreen *buyCoupon =[self.storyboard instantiateViewControllerWithIdentifier:@"ProfileScreen"];
                [self.mm_drawerController setCenterViewController:buyCoupon withCloseAnimation:YES completion:nil];
            }
            else
            {
                globals.isFromMenu = true;
                globals.strWhichScreen = @"ProfileScreen";
                LoginScreen *vcLogin = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
                [self.mm_drawerController setCenterViewController:vcLogin withCloseAnimation:YES completion:nil];
            }
        }
        if ([sideMenuCell.lblOptions.text isEqualToString:@"Account Details"])
        {
            LoginManager *login = [[LoginManager alloc]init];
            if ([[login isUserLoggedIn] count]>0)
            {
                ICSingletonManager *globals = [ICSingletonManager sharedManager];
                globals.isFromMenu = true;
                
                AccountScreen *buyCoupon =[self.storyboard instantiateViewControllerWithIdentifier:@"AccountScreen"];
                [self.mm_drawerController setCenterViewController:buyCoupon withCloseAnimation:YES completion:nil];
            }
            else
            {
                globals.isFromMenu = true;
                globals.strWhichScreen = @"AccountScreen";
                LoginScreen *vcLogin = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
                [self.mm_drawerController setCenterViewController:vcLogin withCloseAnimation:YES completion:nil];
            }
        }

             } else {
//                 if ([sideMenuCell.lblOptions.text isEqualToString:@"My Vouchers"])
//                 {
//                     LoginManager *login = [[LoginManager alloc]init];
//                     if ([[login isUserLoggedIn] count]>0)
//                     {
//                         if ([[globals.menuLoadArry valueForKey:@"UserCouponCount"] intValue]!=0) {
//                             ICSingletonManager *globals = [ICSingletonManager sharedManager];
//                             globals.isFromMenu = true;
//                             
//                             MyCouponViewController *buyCoupon =[self.storyboard instantiateViewControllerWithIdentifier:@"MyCouponViewController"];
//                             buyCoupon.str_CoupenCount = [globals.menuLoadArry valueForKey:@"UserCouponCount"];
//                             [self.mm_drawerController setCenterViewController:buyCoupon withCloseAnimation:YES completion:nil];
//                         }
//                         else{
//                             [[ICSingletonManager sharedManager] showAlertViewWithMsg:@"No Voucher Found" onController:self];
//                         }
//                         
//                     }
//                     else
//                     {
//                         globals.isFromMenu = true;
//                         globals.strWhichScreen = @"MyCoupon";
//                         LoginScreen *vcLogin = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
//                         [self.mm_drawerController setCenterViewController:vcLogin withCloseAnimation:YES completion:nil];
//                     }
//                 }
//                 else if ([sideMenuCell.lblOptions.text isEqualToString:@"Wishlist"])
//                 {
//                     LoginManager *login = [[LoginManager alloc]init];
//                     if ([[login isUserLoggedIn] count]>0)
//                     {
//                         if ([[globals.menuLoadArry valueForKey:@"UserWishlistCount"] intValue]!=0) {
//                             ICSingletonManager *globals = [ICSingletonManager sharedManager];
//                             globals.isFromMenuForWishList = true;
//                             
//                             MyWishlistViewController *buyCoupon =[self.storyboard instantiateViewControllerWithIdentifier:@"MyWishlistViewController"];
//                             [self.mm_drawerController setCenterViewController:buyCoupon withCloseAnimation:YES completion:nil];
//                         }
//                         else{
//                             [[ICSingletonManager sharedManager] showAlertViewWithMsg:@"No Wishlist Found" onController:self];
//                         }
//                         
//                         
//                     }
//                     else
//                     {
//                         globals.isFromMenu = true;
//                         globals.strWhichScreen = @"MyWishlist";
//                         LoginScreen *vcLogin = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
//                         [self.mm_drawerController setCenterViewController:vcLogin withCloseAnimation:YES completion:nil];
//                     }
//                 }
//                 else if ([sideMenuCell.lblOptions.text isEqualToString:@"Stays"])
//                 {
//                     LoginManager *login = [[LoginManager alloc]init];
//                     if ([[login isUserLoggedIn] count]>0)
//                     {
//                         if ([[globals.menuLoadArry valueForKey:@"UserPastStayCount"] intValue]!=0) {
//                             ICSingletonManager *globals = [ICSingletonManager sharedManager];
//                             globals.isFromMenu = true;
//                             
//                             CurrentStayScreen *buyCoupon =[self.storyboard instantiateViewControllerWithIdentifier:@"CurrentStayScreen"];
//                             [self.mm_drawerController setCenterViewController:buyCoupon withCloseAnimation:YES completion:nil];
//                         }
//                         else{
//                             [[ICSingletonManager sharedManager] showAlertViewWithMsg:@"No Current Stay Found" onController:self];
//                         }
//                         
//                     }
//                     else
//                     {
//                         globals.isFromMenu = true;
//                         globals.strWhichScreen = @"CurrentStayScreen";
//                         LoginScreen *vcLogin = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
//                         [self.mm_drawerController setCenterViewController:vcLogin withCloseAnimation:YES completion:nil];
//                     }
//                 }
//             }
//    
//        if ([sideMenuCell.lblOptions.text isEqualToString:@"Gift Your Vouchers"])
//         {
//             LoginManager *login = [[LoginManager alloc]init];
//             if ([[login isUserLoggedIn] count]>0)
//             {
//                 GiftVouchersViewController *giftVouchers =[self.storyboard instantiateViewControllerWithIdentifier:@"GiftVouchersViewController"];
//                 [self.mm_drawerController setCenterViewController:giftVouchers withCloseAnimation:YES completion:nil];
//             }
//             else
//             {
//                 globals.isFromMenu = true;
//                 globals.strWhichScreen = @"GiftVouchers";
//                 LoginScreen *vcLogin = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
//                 [self.mm_drawerController setCenterViewController:vcLogin withCloseAnimation:YES completion:nil];
//             }
//         }
//        if ([sideMenuCell.lblOptions.text isEqualToString:@"Personal Details"])
//         {
//             LoginManager *login = [[LoginManager alloc]init];
//             if ([[login isUserLoggedIn] count]>0)
//             {
//                 ICSingletonManager *globals = [ICSingletonManager sharedManager];
//                 globals.isFromMenu = true;
//                 
//                 ProfileScreen *buyCoupon =[self.storyboard instantiateViewControllerWithIdentifier:@"ProfileScreen"];
//                 [self.mm_drawerController setCenterViewController:buyCoupon withCloseAnimation:YES completion:nil];
//             }
//             else
//             {
//                 globals.isFromMenu = true;
//                 globals.strWhichScreen = @"ProfileScreen";
//                 LoginScreen *vcLogin = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
//                 [self.mm_drawerController setCenterViewController:vcLogin withCloseAnimation:YES completion:nil];
//             }
//         }
//        if ([sideMenuCell.lblOptions.text isEqualToString:@"Account Details"])
//         {
//             LoginManager *login = [[LoginManager alloc]init];
//             if ([[login isUserLoggedIn] count]>0)
//             {
//                 ICSingletonManager *globals = [ICSingletonManager sharedManager];
//                 globals.isFromMenu = true;
//                 
//                 AccountScreen *buyCoupon =[self.storyboard instantiateViewControllerWithIdentifier:@"AccountScreen"];
//                 [self.mm_drawerController setCenterViewController:buyCoupon withCloseAnimation:YES completion:nil];
//             }
//             else
//             {
//                 globals.isFromMenu = true;
//                 globals.strWhichScreen = @"AccountScreen";
//                 LoginScreen *vcLogin = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
//                 [self.mm_drawerController setCenterViewController:vcLogin withCloseAnimation:YES completion:nil];
//             }
//         }
         
         if ([sideMenuCell.lblOptions.text isEqualToString:@"FAQ"]) {
             ICSingletonManager *globals = [ICSingletonManager sharedManager];
             globals.isFromMenu = true;
             
             FaqScreen *faqScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"FaqScreen"];
             [self.mm_drawerController setCenterViewController:faqScreen withCloseAnimation:YES completion:nil];
         }
         if ([sideMenuCell.lblOptions.text isEqualToString:@"About Us"]) {
             AboutUsScreen *aboutUsScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutUsScreen"];
             [self.mm_drawerController setCenterViewController:aboutUsScreen withCloseAnimation:YES completion:nil];
         }
         if ([sideMenuCell.lblOptions.text isEqualToString:@"Contact Us"]) {
             ContactUsScreen *contactScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactUsScreen"];
             [self.mm_drawerController setCenterViewController:contactScreen withCloseAnimation:YES completion:nil];
             
         }
                 
                 if ([sideMenuCell.lblOptions.text isEqualToString:@"Last Minute Deals"]) {
                     
                     LastMinuteViewController *lastMinuteScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"LastMinuteViewController"];
                     [self.mm_drawerController setCenterViewController:lastMinuteScreen withCloseAnimation:YES completion:nil];
                 }

//         if (indexPath.row == 15) {
//             LoginManager *login = [[LoginManager alloc]init];
//             if ([[login isUserLoggedIn] count]>0)
//             {
//                 [self.btnLogout setHidden:YES];
//                 [self.tblViewSideMenuOptions reloadData];
//                 LoginManager *login = [[LoginManager alloc]init];
//                 [login removeUserModelDictionary];
//                 [self showingProfilePicFromStoredUserDefaultsData];
//                 [[ICSingletonManager sharedManager] showAlertViewWithMsg:@"Logout Successfully!" onController:self];
//                 HomeScreenController *homeScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeScreenController"];
//                 [self.mm_drawerController setCenterViewController:homeScreen withCloseAnimation:YES completion:nil];
//             }
//             else
//             {
//                 ICSingletonManager *globals = [ICSingletonManager sharedManager];
//                 globals.isFromMenu = true;
//                 LoginScreen *vcLogin = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
//                 [self.mm_drawerController setCenterViewController:vcLogin withCloseAnimation:YES completion:nil];
//             }
//         }

     }
//             }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    globals.isFromMenuForSearchRedeem = true;

    if (buttonIndex==1) {
        MapScreen *mapScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"MapScreen"];
        mapScreen.isByCurrentLocation=YES;
        mapScreen.isByCity = NO;
        [self.mm_drawerController setCenterViewController:mapScreen withCloseAnimation:YES completion:nil];
        globals.isFromBuyVoucherByCurrentLocation = true;
        globals.isFromBuyVoucherSearchByCity = false;
    }
    else  if (buttonIndex==2)
    {
        MapScreen *mapScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"MapScreen"];
        mapScreen.isByCity = YES;
        mapScreen.isByCurrentLocation = NO;
        [self.mm_drawerController setCenterViewController:mapScreen withCloseAnimation:YES completion:nil];
        globals.isFromBuyVoucherByCurrentLocation = false;
        globals.isFromBuyVoucherSearchByCity = true;
    }
    
}

#pragma mark - WEBSERVICEMETHOD IMPLEMETATION
- (void)startServiceToGeticanCash
{
    
   //  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    NSNumber *num = [dict valueForKey:@"UserId"];
    

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/Api/FAQApi/GetCancashAmount?userId=%d",kServerUrl,[num intValue]];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
      
        
        NSString *icansCAshPoint = [responseObject objectForKey:@"cancashpoint"];
          globals.userCancashAmountAvailable = icansCAshPoint;
        [self.arrOptionsInSideMenu removeObjectAtIndex:16];
        [self.arrOptionsInSideMenu insertObject:[NSString stringWithFormat:@"%@ (%@)",@"My icanCash", globals.userCancashAmountAvailable] atIndex:16];
        [self startServiceToGetCouponsDetails];
        
        globals.isFirstTimeMenuLoadWebService = @"YES";
         [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[ICSingletonManager sharedManager] showAlertViewWithMsg:error.localizedDescription onController:self];
        
    }];
    
    
}
- (void)startServiceToGetCouponsDetails
{
    
  //  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    NSNumber *num = [dict valueForKey:@"UserId"];
    
    NSDictionary *dictParams = @{@"userid":num};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    [manager GET:[NSString stringWithFormat:@"%@/api/BuyCoupens/GetUserDashboardDetail?",kServerUrl] parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
     globals.menuLoadArry = [responseObject mutableCopy];
        NSString *status = [responseObject valueForKey:@"status"];
        // NSString *msg = [responseObject valueForKey:@"errorMessage"];
        if ([status isEqualToString:@"SUCCESS"]) {
            
          

            NSNumber *numCouponCount = [responseObject valueForKey:@"UserCouponCount"];
            NSNumber *numPastStayCount = [responseObject valueForKey:@"UserPastStayCount"];
            NSNumber *numWhishlistCount = [responseObject valueForKey:@"UserWishlistCount"];
            
            [self.arrOptionsInSideMenu removeObjectAtIndex:9];
            [self.arrOptionsInSideMenu insertObject:[NSString stringWithFormat:@"My Vouchers (%@)",numCouponCount] atIndex:9];
        
            [self.arrOptionsInSideMenu removeObjectAtIndex:10];
            [self.arrOptionsInSideMenu insertObject:[NSString stringWithFormat:@"My Stays (%@)",numPastStayCount] atIndex:10];
          
            [self.arrOptionsInSideMenu removeObjectAtIndex:11];
            [self.arrOptionsInSideMenu insertObject:[NSString stringWithFormat:@"Wishlist (%@)",numWhishlistCount] atIndex:11];
           
            
            globals.wishlistCount = [NSString stringWithFormat:@"%@",numWhishlistCount];
            globals.myVoucherCount = [NSString stringWithFormat:@"%@",numCouponCount];
            globals.staysCount = [NSString stringWithFormat:@"%@",numPastStayCount];
            
            [self.tblViewSideMenuOptions reloadData];

        }
        
        NSLog(@"sucess");
  //      [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
    //    [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[ICSingletonManager sharedManager] showAlertViewWithMsg:error.localizedDescription onController:self];
        
    }];
    
    
}
- (void)startServiceToGetCouponsDetailsLastMinuteDeal
{
    
    //  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    
    
    [self.arrOptionsInSideMenu removeObjectAtIndex:9];
    [self.arrOptionsInSideMenu insertObject:[NSString stringWithFormat:@"My Vouchers (%@)",globals.myVoucherCount] atIndex:9];
    
    [self.arrOptionsInSideMenu removeObjectAtIndex:10];
    [self.arrOptionsInSideMenu insertObject:[NSString stringWithFormat:@"My Stays (%@)",globals.staysCount] atIndex:10];
    
    [self.arrOptionsInSideMenu removeObjectAtIndex:11];
    [self.arrOptionsInSideMenu insertObject:[NSString stringWithFormat:@"Wishlist (%@)",globals.wishlistCount] atIndex:11];
    
    
    
    [self.tblViewSideMenuOptions reloadData];
    
    
}




#pragma mark - Custom Action Methods

- (IBAction)faqsButtonTapped:(id)sender
{
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    globals.isFromMenu = true;

    FaqScreen *faqScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"FaqScreen"];
    [self.mm_drawerController setCenterViewController:faqScreen withCloseAnimation:YES completion:nil];
}

- (IBAction)aboutUsButtonTapped:(id)sender {
    AboutUsScreen *aboutUsScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutUsScreen"];
    [self.mm_drawerController setCenterViewController:aboutUsScreen withCloseAnimation:YES completion:nil];
}

- (IBAction)contactUsButtonTapped:(id)sender {
    ContactUsScreen *contactScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactUsScreen"];
    [self.mm_drawerController setCenterViewController:contactScreen withCloseAnimation:YES completion:nil];
}

- (IBAction)btnLogOutTapped:(id)sender
{
    LoginManager *login = [[LoginManager alloc]init];
    if ([[login isUserLoggedIn] count]>0)
    {
        [self.btnLogout setHidden:YES];
        [self.tblViewSideMenuOptions reloadData];
        LoginManager *login = [[LoginManager alloc]init];
        [login removeUserModelDictionary];
        [self showingProfilePicFromStoredUserDefaultsData];
        
        HomeScreenController *homeScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeScreenController"];
        [self.mm_drawerController setCenterViewController:homeScreen withCloseAnimation:YES completion:nil];
    }
    else
    {
        ICSingletonManager *globals = [ICSingletonManager sharedManager];
        globals.isFromMenu = true;
        LoginScreen *vcLogin = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
        [self.mm_drawerController setCenterViewController:vcLogin withCloseAnimation:YES completion:nil];
    }

}

- (IBAction)btnEditImageTapped:(id)sender
{
    UIImage *image = [UIImage imageNamed:@"ic_profile_user"];
    NSData *imageData = UIImagePNGRepresentation(image);
    NSData *profileImageData = UIImagePNGRepresentation(self.imgViewProfilePic.image);
    LoginManager *login = [[LoginManager alloc]init];
    if ([[login isUserLoggedIn] count]>0)
    {
        //[[ICSingletonManager sharedManager] showAlertViewWithMsg:@"Profile pic update coming soon" onController:self];
        
        UIAlertController *alertController;
        UIAlertAction *editAction;
        UIAlertAction *cancelAction;

        UIAlertAction *deleteAction;
        alertController = [UIAlertController alertControllerWithTitle:@"User Image" message:nil preferredStyle:UIAlertControllerStyleAlert];
        editAction = [UIAlertAction actionWithTitle:@"EDIT" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
        {
            // do destructive stuff here
            [self chooseProfilePicFromGallery];
        }];
        
        deleteAction = [UIAlertAction actionWithTitle:@"DELETE" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
        {
            // do something here
            [self deleteProfilePic];
        }];

        // note: you can control the order buttons are shown, unlike UIActionSheet
        cancelAction = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:editAction];
 
        if (![imageData isEqual:profileImageData]) {
            [alertController addAction:deleteAction];
        }

        [alertController addAction:cancelAction];

        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
//        ICSingletonManager *globals = [ICSingletonManager sharedManager];
//        globals.isFromMenu = true;
//        LoginScreen *vcLogin = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
//        [self.mm_drawerController setCenterViewController:vcLogin withCloseAnimation:YES completion:nil];
    }
}

- (void)deleteProfilePic
{
    [self startServiceToManipulateUserProfilePicFromImage:nil];
}

- (void)chooseProfilePicFromGallery
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    // Dismiss the image selection, hide the picker and
    NSLog(@"image=%@",image);
//    NSData *imageData = UIImagePNGRepresentation(image);
//    NSLog(@"Size of Image(bytes):%lu",(unsigned long)[imageData length]);
//    NSLog(@"SIZE OF IMAGE: %.2f Mb", (float)[imageData length]/8/1024/1024);
//    int size = [imageData length]/8;
//    size =  size/1024;
//    size = size/1024;
//    NSLog(@"Size of Image(Mega bytes):%lu",(unsigned long)size);
    //show the image view with the picked image
   // if (size < 3.0) {
        [self startServiceToManipulateUserProfilePicFromImage:image];
//    }
//    else{
//        [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Size of uploaded image should be less than 3 MB." onController:self];
//    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)startServiceToManipulateUserProfilePicFromImage:(UIImage *)img
{
    @try
    {
    
        [MBProgressHUD showHUDAddedTo:self.imgViewProfilePic animated:YES];
        LoginManager *loginManage = [[LoginManager alloc]init];
        NSDictionary *dict = [loginManage isUserLoggedIn];
        NSNumber *numUserId = [dict valueForKey:@"UserId"];
        NSString *imgString  = nil;
      
        if (img)
            imgString = [[ICSingletonManager sharedManager] encodeToBase64String:img];
        else
            imgString = @"";
        
        NSDictionary *dictParams = @{@"USER_ID":numUserId, @"ProfilePic":imgString};
        NSString *strDictPost = [dictParams jsonStringWithPrettyPrint:YES];

        NSString *strUrl =[NSString stringWithFormat:@"%@/api/UserProfileApi/ChangeUserProfilePicApi",kServerUrl];
        NSLog(@"%@",strUrl);
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                        initWithURL:[NSURL URLWithString:strUrl]
                                        cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                        timeoutInterval:120.0f];
        
        [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPMethod:@"POST"];
        NSString *postString = strDictPost;
        NSData * data = [postString dataUsingEncoding:NSUTF8StringEncoding];
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[data length]];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:data];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
        {
            if (!connectionError)
            {
                
                
                NSDictionary *dictResp = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: nil];
                NSLog(@"response--%@",dictResp);
                        NSString *msg= [dictResp valueForKey:@"errorMessage"];
                        NSString *status = [dictResp valueForKey:@"status"];
                        if (![status isEqualToString:@"FAIL"])
                        {
                            [self.imgViewProfilePic setImage:nil];
                            [self.imgViewProfilePic setImage:img];
                            
                            [self savingProfilePicInLocalWithImage:img];
                        }
                
                        [[ICSingletonManager sharedManager]showAlertViewWithMsg:msg onController:self];
                        [MBProgressHUD hideHUDForView:self.imgViewProfilePic animated:YES];

                [MBProgressHUD hideHUDForView:self.view animated:YES];
            } else
            {
                NSLog(@"error--%@",connectionError);
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
        }];
        
    //    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    //    
    //    
    //    
    //    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
    //                     forHTTPHeaderField:@"Content-Type"];
    //    
    //    NSString *str =[NSString stringWithFormat:@"%@/api/UserProfileApi/ChangeUserProfilePicApi",kServerUrl];
    //    NSLog(@"%@",str);
    //    NSLog(@"%@" ,strParam);
    //    [manager POST:[NSString stringWithFormat:@"%@/api/UserProfileApi/ChangeUserProfilePicApi",kServerUrl] parameters:strParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //        NSLog(@"responseObject=%@",responseObject);
    //        NSLog(@"sucess");
    //        NSString *msg= [responseObject valueForKey:@"errorMessage"];
    //        NSString *status = [responseObject valueForKey:@"status"];
    //        if (![status isEqualToString:@"FAIL"]) {
    //            [self.imgViewProfilePic setImage:nil];
    //            [self.imgViewProfilePic setImage:img];
    //        }
    //        
    //        [[ICSingletonManager sharedManager]showAlertViewWithMsg:msg onController:self];
    //        
    //        [MBProgressHUD hideHUDForView:self.imgViewProfilePic animated:YES];
    //        
    //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //        NSLog(@"failure");
    //        [MBProgressHUD hideHUDForView:self.imgViewProfilePic animated:YES];
    //        [[ICSingletonManager sharedManager] showAlertViewWithMsg:error.localizedDescription onController:self];
    //
    //    }];
            
    }
    @catch (NSException *exception)
    {
        NSLog(@"excepton====%@",exception);
    }
}


- (void)savingProfilePicInLocalWithImage:(UIImage *)img
{
    LoginManager *loginManage = [[LoginManager alloc]init];
    
    NSDictionary *dictionaryPrev = [loginManage isUserLoggedIn ];
    NSMutableDictionary *tempDict = [dictionaryPrev mutableCopy];
    
    if (!img){
       if ([[dictionaryPrev objectForKey:@"Gender"] isEqualToString:@"M"]) {
           [self.imgViewProfilePic setImage:[UIImage imageNamed:@"man"]];
        }else{
              //  [self.imgViewProfilePic setImage:[UIImage imageNamed:@"woman"]];
            
             [self.imgViewProfilePic setImage:[UIImage imageNamed:@"man"]];
                }
    }
    
    
    
    
    [tempDict removeObjectForKey:@"ProfilePic"];
    [tempDict setValue:[[ICSingletonManager sharedManager] encodeToBase64String:img] forKey:@"ProfilePic"];
    
    //Removing previous dictionary and saving new dictionary to local userdefaults
    [loginManage loginUserWithUserDataDictionary:[tempDict copy]];
    NSDictionary *dictionaryNew = [loginManage isUserLoggedIn ];
    NSLog(@"%@",dictionaryNew);
    
    [self showingProfilePicFromStoredUserDefaultsData];

}

@end
