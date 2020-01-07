//
//  RegistrationScreen.m
//  ICanStay
//
//  Created by Namit Aggarwal on 29/02/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import "RegistrationScreen.h"
#import "AFNetworking.h"
#import "UITextField+EmptyText.h"
#import "NSString+Validation.h"
#import "NSDictionary+JsonString.h"
#import "MBProgressHud.h"
#import "LoginManager.h"
#import "ChangePasswordScreen.h"
#import <QuartzCore/QuartzCore.h>
#import "HomeScreenController.h"
#import "SideMenuController.h"
#import "AppDelegate.h"
#import "CanStayConstant.h"
#import <MoEngage.h>
#import "GradientButton.h"
#import <CoreLocation/CoreLocation.h>

#define ACCEPTABLE_CHARACTERS @"0123456789"
@interface RegistrationScreen ()<UITextFieldDelegate, UITableViewDelegate,UITableViewDataSource, CLLocationManagerDelegate>
{
     UITableView          *cityNameTableView;
    NSString             *searchTextString;
    int                manageAlertTblAddress;
    int               selectCellCityNameTable;
      BOOL               isFilter;
     NSMutableDictionary   *cityNameTableSelectArr;
    int cityId;
    UIView *cityTableBaseView;
    UILabel *WhstayLbl;
    UIButton *cityTableCloseBtn;
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    
}
@property (strong, nonatomic) IBOutlet UIView *selectCittyBaseView;
@property (strong, nonatomic) IBOutlet UIView *RefferalBaseView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollContentViewConstraints;
@property (strong, nonatomic) UITextField *refferalCodeTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (strong, nonatomic) IBOutlet UIButton *regBtn;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmailId;
@property (weak, nonatomic) IBOutlet UITextField *txtMobileNum;
@property (weak, nonatomic) IBOutlet UIView *viewBottom;
@property (nonatomic, strong) UIButton *fbSignUpBtn;
@property (nonatomic, strong) UIButton *gmailSignUpBtn;
@property (nonatomic,copy)NSString *strGender;
@property (nonatomic,strong)NSDictionary *dictFromServer;
@property (nonatomic, strong) UITextField    *cityTxtFld;

- (IBAction)btnSubmitTapped:(id)sender;
- (IBAction)btnExistingUserLoginTapped:(id)sender;
- (IBAction)btnBackTapped:(id)sender;
- (IBAction)btnRadioMaleTapped:(id)sender;
- (IBAction)btnRadioFemaleTapped:(id)sender;
- (IBAction)btnTermsConditionTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIButton *btnTermsCondition;
@property (weak, nonatomic) IBOutlet UIButton *btnRadioMale;
@property (weak, nonatomic) IBOutlet UIButton *btnRadioFemale;

@property (weak, nonatomic) IBOutlet UIView *blackTransparentView;
@property (weak, nonatomic) IBOutlet UIView *termAndConditionView;
@property (weak, nonatomic) IBOutlet UITextView *termAndConditionTextView;
@property (strong,nonatomic) NSMutableArray *arrayCityList;
- (IBAction)btnDisagreeTapped:(id)sender;
- (IBAction)btnAgreeTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *ReferralBaseView;

@property BOOL isTermsConditionAccepted;
@property BOOL isSendMeOffer;
@property BOOL isGetaCall;
@property NSString *IsOfferandNewsletter;
@property NSString *IsGetCall;
@property (strong, nonatomic) IBOutlet UIImageView *Img_SendMeOffer;
@property (strong, nonatomic) IBOutlet UIView *RegisterNowBaseView;
@property (strong, nonatomic) IBOutlet UIImageView *img_GetaCall;
@property (strong,nonatomic) NSMutableArray *filteredCityList;
@end

@implementation RegistrationScreen

- (void)viewDidLoad {
    [super viewDidLoad];
     DLog(@"DEBUG-VC");
    self.arrayCityList = [[NSMutableArray alloc]init];
    self.filteredCityList = [[NSMutableArray alloc]init];
    cityNameTableSelectArr = [[NSMutableDictionary alloc]init];
       isFilter = NO;
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Register Screen"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    globals.isFirstTimeFromPageScrollController = false;
    // Do any additional setup after loading the view.
    _isSendMeOffer = YES;
    _isGetaCall = YES;
    _IsOfferandNewsletter = @"1";
    _IsGetCall = @"1";
    UITapGestureRecognizer *singleTapOwner = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(imageOwnerTapped:)];
    singleTapOwner.numberOfTapsRequired = 1;
//    singleTapOwner.cancelsTouchesInView = YES;
    [_blackTransparentView addGestureRecognizer:singleTapOwner];
    
    //Code for setting google button delegate
    [GIDSignIn sharedInstance].uiDelegate = self;
    //Code for NotificationCenter
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(googleButton:) name:@"googlesigninaction" object:nil];
    
    [self.btnTermsCondition setBackgroundImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
    [self.btnRadioMale setBackgroundImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
    [self.btnRadioFemale setBackgroundImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
   
    self.strGender = @"N";
    self.txtMobileNum.delegate = self;
    /// API Calling
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.scrollContentViewConstraints.constant = 750;
    }else{
        self.scrollContentViewConstraints.constant = 650;

    }
    
    UILabel *referTxtLbl = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, self.view.frame.size.width - 10, 20)];
    referTxtLbl.textColor = [UIColor blackColor];
  //  referTxtLbl.text = @"Register and get ₹500 icanCash in your";
    referTxtLbl.textAlignment = NSTextAlignmentCenter;
    referTxtLbl.font = [UIFont systemFontOfSize:18];
    [self.ReferralBaseView addSubview:referTxtLbl];
    
    UILabel *referTxtLbl2 = [[UILabel alloc]initWithFrame:CGRectMake(5, 18, self.view.frame.size.width - 10, 25)];
    referTxtLbl2.textColor = [UIColor blackColor];
  //  referTxtLbl2.text = @"account instantly.";
    referTxtLbl2.textAlignment = NSTextAlignmentCenter;
     referTxtLbl2.font = [UIFont systemFontOfSize:18];
    [self.ReferralBaseView addSubview:referTxtLbl2];
    
     self.fbSignUpBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.fbSignUpBtn.frame = CGRectMake(30, referTxtLbl2.frame.size.height + referTxtLbl2.frame.origin.y + 10, 120, 30);
    [self.fbSignUpBtn addTarget:self action:@selector(fbSignUpBtnpressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.fbSignUpBtn setBackgroundImage:[UIImage imageNamed:@"fbSignUp"] forState:UIControlStateNormal];
    [self.ReferralBaseView addSubview:self.fbSignUpBtn];
//    self.ReferralBaseView.backgroundColor = [UIColor redColor];
    
    self.gmailSignUpBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.gmailSignUpBtn.frame = CGRectMake(self.view.frame.size.width - 20 - 120, referTxtLbl2.frame.size.height + referTxtLbl2.frame.origin.y + 10, 120, 30);
    [self.gmailSignUpBtn addTarget:self action:@selector(gmailSignUpBtnpressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.gmailSignUpBtn setBackgroundImage:[UIImage imageNamed:@"gmailSignUp"] forState:UIControlStateNormal];
    [self.ReferralBaseView addSubview:self.gmailSignUpBtn];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        referTxtLbl.font = [UIFont systemFontOfSize:15];
        referTxtLbl.frame = CGRectMake(2, 5, self.view.frame.size.width - 20, 20);
        referTxtLbl2.frame = CGRectMake(2, 18, self.view.frame.size.width - 20, 20);
         referTxtLbl2.font = [UIFont systemFontOfSize:15];
      
         referTxtLbl.text = @"Register and get ₹1,000 icanCash in your";
          referTxtLbl2.text = @"account instantly.";
       self.fbSignUpBtn.frame = CGRectMake(20, referTxtLbl2.frame.size.height + referTxtLbl2.frame.origin.y + 10, (self.view.frame.size.width - 90)/2, 40);
         self.gmailSignUpBtn.frame = CGRectMake(self.fbSignUpBtn.frame.size.width + 20 + 30, referTxtLbl2.frame.size.height + referTxtLbl2.frame.origin.y + 10, (self.view.frame.size.width - 90)/2, 40);
    }
   
    NSString *str = @"REGISTER NOW";
    CGSize stringsize = [str sizeWithFont:[UIFont systemFontOfSize:18]];
    //or whatever font you're using
//    [button setFrame:CGRectMake(10,0,stringsize.width, stringsize.height)];
    
    GradientButton *registerNowBtn =  [[GradientButton alloc]init];
    registerNowBtn.frame = CGRectMake((self.view.frame.size.width - (stringsize.width + 20))/2,5,stringsize.width + 20,40);
    [registerNowBtn setTitle:@"REGISTER NOW" forState:UIControlStateNormal];
    [registerNowBtn useRedDeleteStyle];
    registerNowBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [registerNowBtn addTarget:self action:@selector(registerNowBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.RegisterNowBaseView addSubview:registerNowBtn];
    
     [self addCityTxtFldAndRefferalBaseView];
    
    [self getCityList];
    
    
    UITapGestureRecognizer *tapScrollView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScrollViewPressed:)];
    [self.scrollView addGestureRecognizer:tapScrollView];
    [self CurrentLocationIdentifier];
//    dispatch_sync(dispatch_get_main_queue(), ^{
//
//    });
    
}
-(void)CurrentLocationIdentifier
{
    //---- For getting current gps location
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [locationManager requestWhenInUseAuthorization];
    
    [locationManager startUpdatingLocation];
    
//    locationManager = [CLLocationManager new];
//    locationManager.delegate = self;
//    locationManager.distanceFilter = kCLDistanceFilterNone;
//    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    [locationManager startUpdatingLocation];
    //------
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    currentLocation = [locations objectAtIndex:0];
    [locationManager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSLog(@"\nCurrent Location Detected\n");
             NSLog(@"placemark %@",placemark);
             NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
             NSString *Address = [[NSString alloc]initWithString:locatedAt];
             NSString *Area = [[NSString alloc]initWithString:placemark.locality];
             NSString *Country = [[NSString alloc]initWithString:placemark.country];
             NSString *CountryArea = [NSString stringWithFormat:@"%@, %@", Area,Country];
             NSLog(@"%@",CountryArea);
             for (id dict in self.filteredCityList) {
                 if ([Area isEqualToString:[dict objectForKey:@"Text"]]) {
                      self.cityTxtFld.text =  Area;
                     cityId = [[dict objectForKey:@"Value"] intValue];
                 }
             }
            
         }
         else
         {
             NSLog(@"Geocode failed with error %@", error);
             NSLog(@"\nCurrent Location Not Detected\n");
             //return;
      //       CountryArea = NULL;
         }
         /*---- For more results
          placemark.region);
          placemark.country);
          placemark.locality);
          placemark.name);
          placemark.ocean);
          placemark.postalCode);
          placemark.subLocality);
          placemark.location);
          ------*/
     }];
}
-(void)registerNowBtnTapped:(id)sender
{
    [self startServiceToRegisterNewUser];
}
-(void)fbSignUpBtnpressed:(id)sender
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
    //    if ([FBSDKAccessToken currentAccessToken])
    //    {
    //NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
    
    [login logInWithReadPermissions:@[@"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
     {
         if (error)
         {
             //NSLog(@"Login process error");
         }
         else if (result.isCancelled)
         {
             //NSLog(@"User cancelled login");
         }
         else
         {
             //NSLog(@"Login Success");
             
             if ([result.grantedPermissions containsObject:@"email"])
             {
                 //NSLog(@"result is:%@",result);
                 [self fetchUserInformationOfFacebook];
             }
             else
             {
                 //[SVProgressHUD showErrorWithStatus:@"Facebook email permission error"];
             }
         }
     }];
}
-(void)gmailSignUpBtnpressed:(id)sender
{
     [[GIDSignIn sharedInstance] signIn];
}
-(void)tapScrollViewPressed:(UIGestureRecognizer *)tapGesture
{
    NSLog(@"Pressd");
  //  cityNameTableView.hidden = YES;
    cityTableBaseView.hidden = YES;
    [self.cityTxtFld resignFirstResponder];
    [self.txtFirstName resignFirstResponder];
    [self.txtLastName resignFirstResponder];
    [self.txtEmailId resignFirstResponder];
    [self.txtMobileNum resignFirstResponder];
    [self.refferalCodeTxtFld resignFirstResponder];
    self.scrollView.scrollEnabled = YES;
}
-(void)getCityList
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    //http://www.icanstay.com/Api/FAQApi/GetCityApi
    //    [manager GET:[NSString stringWithFormat:@"http://www.icanstay.com/Api/FAQApi/GetCityApi"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    [manager GET:[NSString stringWithFormat:@"%@/Home/GetCityAPI",kServerUrl] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        self.arrayCityList = responseObject;
      self.filteredCityList = self.arrayCityList;
        
         [self startServiceToGetCouponList];
        
         [self addPaddingToTextFields];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:error.localizedDescription onController:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}

#pragma mark Google
-(void)addCityTxtFldAndRefferalBaseView
{
    UILabel *stayLbl = [[UILabel alloc]init];
    stayLbl.text = @"Your City";
    stayLbl.textColor = [ICSingletonManager colorFromHexString:@"#9C6F2F"];
     [self.selectCittyBaseView addSubview:stayLbl];
    
    UIView *paddingViewCity = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 60)];
    self.cityTxtFld = [[UITextField alloc]init];
    self.cityTxtFld.delegate = self;
    self.cityTxtFld.leftView = paddingViewCity;
    self.cityTxtFld.leftViewMode = UITextFieldViewModeAlways;
    self.cityTxtFld.font = [UIFont systemFontOfSize:20];
    self.cityTxtFld.textColor = [UIColor blackColor];
    UIColor *color = [ICSingletonManager colorFromHexString:@"#9C6F2F"];
    self.cityTxtFld.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Select City" attributes:@{NSForegroundColorAttributeName: color}];
   // self.cityTxtFld.userInteractionEnabled = YES;
    self.cityTxtFld.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.selectCittyBaseView addSubview:self.cityTxtFld];
    
    UIView *narrowGoldLineview = [[UIView alloc]init];
    narrowGoldLineview.backgroundColor = [ICSingletonManager colorFromHexString:@"#9C6F2F"];
    [self.selectCittyBaseView addSubview:narrowGoldLineview];
    
    UIImageView *dropDownImg = [[UIImageView alloc]init];
    dropDownImg.image = [UIImage imageNamed:@"dropdownFill"];
    [self.selectCittyBaseView addSubview:dropDownImg];
    
    cityTableBaseView = [[UIView alloc]init];
    cityTableBaseView.backgroundColor = [ICSingletonManager colorFromHexString:@"#001d3d"];
    cityTableBaseView.hidden = YES;
    [self.view addSubview:cityTableBaseView];
    
    WhstayLbl = [[UILabel alloc]init];
    WhstayLbl.text = @"Where do you Stay?";
    WhstayLbl.textColor = [ICSingletonManager colorFromHexString:@"#bd9854"];
    WhstayLbl.font = [UIFont boldSystemFontOfSize:20];
    [cityTableBaseView addSubview:WhstayLbl];
    
    cityTableCloseBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
 //   [cityTableCloseBtn setTitle:@"X" forState:UIControlStateNormal];
 //   [cityTableCloseBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:30]];
    [cityTableCloseBtn addTarget:self action:@selector(cityTableCloseBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
  //  cityTableCloseBtn.titleLabel.textColor = [ICSingletonManager colorFromHexString:@"#bd9854"];
    [cityTableCloseBtn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [cityTableBaseView addSubview:cityTableCloseBtn];
    
    cityNameTableView = [[UITableView alloc]init];
    cityNameTableView.delegate = self;
    cityNameTableView.dataSource = self;
  //  cityNameTableView.hidden = YES;
    cityNameTableView.backgroundColor = [ICSingletonManager colorFromHexString:@"#bd9854"];
    cityNameTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [cityTableBaseView addSubview:cityNameTableView];
    
    [self.cityTxtFld addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UITapGestureRecognizer *selectcityTapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectcityGestureTapped:)];
    self.selectCittyBaseView.userInteractionEnabled = YES;
    selectcityTapped.numberOfTapsRequired = 1;
    self.selectCittyBaseView.layer.masksToBounds = YES;
    [self.selectCittyBaseView addGestureRecognizer:selectcityTapped];
    
    self.refferalCodeTxtFld = [[UITextField alloc]init];
    self.refferalCodeTxtFld.layer.cornerRadius = 5.0;
    self.refferalCodeTxtFld.layer.borderColor = [UIColor grayColor].CGColor;
    self.refferalCodeTxtFld.layer.borderWidth = 0.24;
     self.refferalCodeTxtFld.delegate = self;
    self.refferalCodeTxtFld.keyboardType = UIKeyboardTypeDefault;
   
   
     UIView *paddingViewReferal = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 60)];
    self.refferalCodeTxtFld.leftView = paddingViewReferal;
     self.refferalCodeTxtFld.leftViewMode = UITextFieldViewModeAlways;
      self.refferalCodeTxtFld.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Referral Code, if any" attributes:@{NSForegroundColorAttributeName: color}];
    self.refferalCodeTxtFld.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.RefferalBaseView addSubview:self.refferalCodeTxtFld];
    
    
    
    if (IS_IPAD) {
        stayLbl.frame = CGRectMake(5, 5,200, 20);
        
        self.cityTxtFld.frame = CGRectMake(0, stayLbl.frame.size.height + stayLbl.frame.origin.y, self.view.frame.size.width - 2*(self.selectCittyBaseView.frame.origin.x +10), 30);
        narrowGoldLineview.frame = CGRectMake(0, self.cityTxtFld.frame.size.height + self.cityTxtFld.frame.origin.y + 10, self.view.frame.size.width - 2*(self.selectCittyBaseView.frame.origin.x +10), 1);
        cityNameTableView.frame =  CGRectMake(self.selectCittyBaseView.frame.origin.x +10, self.selectCittyBaseView.frame.origin.y + self.selectCittyBaseView.frame.size.height +120,self.view.frame.size.width - 2*(self.selectCittyBaseView.frame.origin.x +10) , 0);
        dropDownImg.frame = CGRectMake(cityNameTableView.frame.size.width - 50,stayLbl.frame.size.height + stayLbl.frame.origin.y , 30, 30);
      self.refferalCodeTxtFld.frame = CGRectMake(0, 0, self.view.frame.size.width - 2*(self.RefferalBaseView.frame.origin.x +10), 45);
        
    }else{
          stayLbl.frame = CGRectMake(5, 5,200, 20);
        self.cityTxtFld.frame = CGRectMake(0, stayLbl.frame.size.height + stayLbl.frame.origin.y, self.selectCittyBaseView.frame.size.width, 30);
        narrowGoldLineview.frame = CGRectMake(0, self.cityTxtFld.frame.size.height + self.cityTxtFld.frame.origin.y + 10, self.selectCittyBaseView.frame.size.width, 2);
        cityNameTableView.frame =  CGRectMake(self.selectCittyBaseView.frame.origin.x +10,self.selectCittyBaseView.frame.origin.y + self.selectCittyBaseView.frame.size.height + 100  ,self.selectCittyBaseView.frame.size.width,0 );
        dropDownImg.frame = CGRectMake(cityNameTableView.frame.size.width - 80,stayLbl.frame.size.height + stayLbl.frame.origin.y , 30, 30);
     self.refferalCodeTxtFld.frame = CGRectMake(0, 0, self.view.frame.size.width - 60, 30);
         self.refferalCodeTxtFld.font = [UIFont systemFontOfSize:16];

    }

}

-(void)cityTableCloseBtnPressed:(id)sender
{
    cityTableBaseView.hidden = YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.cityTxtFld) {
        cityTableBaseView.hidden = NO;
   //     [self.cityTxtFld resignFirstResponder];
        [self.txtFirstName resignFirstResponder];
        [self.txtLastName resignFirstResponder];
        [self.txtEmailId resignFirstResponder];
        [self.txtMobileNum resignFirstResponder];
        [self.refferalCodeTxtFld resignFirstResponder];
        self.scrollView.scrollEnabled = NO;
        
    }
    return YES;
}
- (void) selectcityGestureTapped: (UIGestureRecognizer *) gesture {
   
    cityTableBaseView.hidden = NO;
//    [UIView animateWithDuration:0.9 animations:^{
//
//        if (IS_IPAD) {
//            cityNameTableView.frame =  CGRectMake(self.selectCittyBaseView.frame.origin.x +10, self.selectCittyBaseView.frame.origin.y + self.selectCittyBaseView.frame.size.height +70,self.view.frame.size.width - 2*(self.selectCittyBaseView.frame.origin.x +10) , 350);
//        }else{
//            cityNameTableView.frame =  CGRectMake(self.selectCittyBaseView.frame.origin.x +10,self.selectCittyBaseView.frame.origin.y + self.selectCittyBaseView.frame.size.height +70  ,self.selectCittyBaseView.frame.size.width,300 );
//        }
//    } completion:^(BOOL finished) {
//
//    }];
}
-(void)textFieldDidChange:(UITextField*)textField
{
   
    
  
      searchTextString = textField.text;
       [self updateSearchArray];
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

// number of row in the section, I assume there is only 1 row
- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.filteredCityList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 0) {
//      return 40;
//    }else{
//        return 25;
//    }
    return 25;
    
}

// the cell will be returned to the tableView
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"cellID";
    NSDictionary *CitylistDictionary;
    NSString *text;
//    if (indexPath.row == 0) {
//        text = @"Where do you Stay?";
//    }else{
        CitylistDictionary = [self.filteredCityList objectAtIndex:indexPath.row ];
      text   = [ICSingletonManager getStringValue:[CitylistDictionary objectForKey:@"Text"]];
  //  }
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:
                             UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc]initWithStyle:
//                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//    }
//
    cell.backgroundColor = [ICSingletonManager colorFromHexString:@"#bd9854"];
    [cell.textLabel setText:text];
//    if (indexPath.row == 0) {
//        cell.textLabel.textColor = [ICSingletonManager colorFromHexString:@"#bd9854"];
//    }
    return cell;
    
}

#pragma mark - UITableViewDelegate

// when user tap the row, what action you want to perform
- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (theTableView == cityNameTableView) {
        isFilter = YES;
        NSString *text;
//        if (indexPath.row == 0) {
//            text = @"Where do you Stay?";
//        }else{
            cityNameTableSelectArr = [self.filteredCityList objectAtIndex:indexPath.row];
            text   = [ICSingletonManager getStringValue:[cityNameTableSelectArr objectForKey:@"Text"]];
              cityId = [[cityNameTableSelectArr objectForKey:@"Value"] intValue];
   //     }
     
        selectCellCityNameTable = 1;
        self.cityTxtFld.text = text;
        
        cityTableBaseView.hidden = YES;
        self.scrollView.scrollEnabled = YES;

        [self.cityTxtFld resignFirstResponder];
    }
}

-(void)updateSearchArray
{
    if (searchTextString.length != 0)
    {
        isFilter = YES;
        NSPredicate *titlePredicate = [NSPredicate predicateWithFormat:@"Text contains[c] %@ ", searchTextString];
        
        self.filteredCityList = [NSMutableArray arrayWithArray:[self.arrayCityList filteredArrayUsingPredicate:titlePredicate]];
        NSLog(@"searchResult %@",self.filteredCityList);
        cityTableBaseView.hidden = NO;
        
        if ([self.filteredCityList count] == 0  && manageAlertTblAddress == 0) {
            
            cityTableBaseView.hidden = YES;

            manageAlertTblAddress = 1;
            self.cityTxtFld.text = @"";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Sorry, No result found."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }else{
            manageAlertTblAddress = 0;
            isFilter = NO;
                      
        }
    }else{
        isFilter=NO;
        self.filteredCityList = self.arrayCityList;
    }
    
    [cityNameTableView reloadData];
}

- (IBAction)googleButtonTap:(id)sender
{
    [[GIDSignIn sharedInstance] signIn];
}
-(void)googleButton:(NSNotification*)notification
{
    //loginCheck = GOOGLE;
    //[self startServiceToRegisterNewUser];
    [self getSocialData:nil type:@"Google"];
}

#pragma mark Facebook
- (IBAction)facebookButtonTap:(id)sender
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
//    if ([FBSDKAccessToken currentAccessToken])
//    {
        //NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
       
        [login logInWithReadPermissions:@[@"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
         {
             if (error)
             {
                 //NSLog(@"Login process error");
             }
             else if (result.isCancelled)
             {
                 //NSLog(@"User cancelled login");
             }
             else
             {
                 //NSLog(@"Login Success");
                 
                 if ([result.grantedPermissions containsObject:@"email"])
                 {
                     //NSLog(@"result is:%@",result);
                     [self fetchUserInformationOfFacebook];
                 }
                 else
                 {
                     //[SVProgressHUD showErrorWithStatus:@"Facebook email permission error"];
                 }
             }
         }];
//    }

}
#pragma mark - Custom Methods

-(void)fetchUserInformationOfFacebook
{
    if ([FBSDKAccessToken currentAccessToken])
    {
        //NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, email, gender, first_name, last_name, picture.width(300).height(300)"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error)
             {
                 //NSLog(@"results:%@",result);
                 facebookDict = result;
                 
                 [self getSocialData:result type:@"FB"];
                 NSString *email = [result objectForKey:@"email"];
                 
                 if (email.length >0 )
                 {
                     //Start you app Todo
                 }
                 else
                 {
                     //NSLog(@"Facebook email is not verified");
                 }
             }
             else
             {
                 //NSLog(@"Error %@",error);
             }
         }];
    }
}

- (void)getSocialData:(NSDictionary *) socialDict type:(NSString *)type
{
    if ([type isEqualToString:@"FB"])
    {
        self.txtEmailId.text = [ICSingletonManager getStringValue:[socialDict objectForKey:@"email"]];
        self.txtFirstName.text = [ICSingletonManager getStringValue:[socialDict objectForKey:@"first_name"]];;
        self.txtLastName.text = [ICSingletonManager getStringValue:[socialDict objectForKey:@"last_name"]];;
        
        NSString * strGender = [ICSingletonManager getStringValue:[socialDict objectForKey:@"gender"]];
        if ([strGender isEqualToString:@"male"])
        {
            [self.btnRadioMale setBackgroundImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
            [self.btnRadioFemale setBackgroundImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
            self.strGender = @"M";
        }else
        {
            [self.btnRadioMale setBackgroundImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
            [self.btnRadioFemale setBackgroundImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
            self.strGender = @"F";
        }

    }else{
    
        AppDelegate *appDelegate= APPDELEGATE;
        self.txtEmailId.text = [ICSingletonManager getStringValue:appDelegate.Google_email];
        NSString * strName = [ICSingletonManager getStringValue:appDelegate.Google_name];
        NSArray * arr = [strName componentsSeparatedByString:@" "];
        NSLog(@"Array values are : %@",arr);
        self.txtFirstName.text = [arr objectAtIndex:0];
        self.txtLastName.text = [arr objectAtIndex:1];
        
//        NSString * strGender = [ICSingletonManager getStringValue:[socialDict objectForKey:@"gender"]];
//        if ([strGender isEqualToString:@"Male"])
//        {
//            [self.btnRadioMale setBackgroundImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
//            [self.btnRadioFemale setBackgroundImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
//            self.strGender = @"M";
//        }else
//        {
//            [self.btnRadioMale setBackgroundImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
//            [self.btnRadioFemale setBackgroundImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
//            self.strGender = @"F";
//        }
    }

}

- (void)addPaddingToTextFields{
    [self.txtEmailId addPaddingToTextField];
    [self.txtFirstName addPaddingToTextField];
    [self.txtLastName addPaddingToTextField];
    [self.txtMobileNum addPaddingToTextField];
 //   [self.refferalCodeTxtFld addPaddingToTextField];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/// API Caliing for the Terms&Condition
- (void)startServiceToGetCouponList
{
      AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    [manager GET:[NSString stringWithFormat:@"%@/api/CouponApi/GetBuyCouponDetailMobile?",kServerUrl] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        self.dictFromServer = (NSDictionary *)responseObject;
        [self settingCouponInfoFromServer:self.dictFromServer];
        
        NSLog(@"sucess");
        [cityNameTableView reloadData];
        if (IS_IPAD) {
            cityNameTableView.frame =  CGRectMake(self.selectCittyBaseView.frame.origin.x +10, self.selectCittyBaseView.frame.origin.y + self.selectCittyBaseView.frame.size.height +70,self.view.frame.size.width - 2*(self.selectCittyBaseView.frame.origin.x +10) , 350);
        }else{
            cityTableBaseView.frame =  CGRectMake(10 ,25  ,self.view.frame.size.width - 20,270 );
            WhstayLbl.frame =  CGRectMake(10,5  ,cityTableBaseView.frame.size.width - 70,30);
            cityTableCloseBtn.frame = CGRectMake(WhstayLbl.frame.size.width + WhstayLbl.frame.origin.x, 5, 30, 30);
            cityNameTableView.frame =  CGRectMake(0,40 ,cityTableBaseView.frame.size.width,230);
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[ICSingletonManager sharedManager] showAlertViewWithMsg:error.localizedDescription onController:self];
        
    }];
}

- (void)settingCouponInfoFromServer:(NSDictionary *)dict
{
     NSString *stringTermsCondition =[dict valueForKey:@"RegTerms"];
    
    //    stringTermsCondition= [[ICSingletonManager sharedManager]removeNullObjectFromString:stringTermsCondition];
    //    stringTermsCondition = [[ICSingletonManager sharedManager] stringByStrippingHTMLFromString:stringTermsCondition];
    
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[[stringTermsCondition stringByReplacingOccurrencesOfString:@"Coupon" withString:@"Voucher"] dataUsingEncoding:NSUTF8StringEncoding]
                                                                   options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                             NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                        documentAttributes:nil error:nil];
    NSLog(@"attrStr======%@",attrStr);
    
    [self.termAndConditionTextView setAttributedText:attrStr];
}

#pragma mark - Validating UITextField
- (BOOL)validateFirstNameAndLastName
{
    BOOL ifFirstNameLastNameValidated =YES;
    
    BOOL ifFirstNameEmpty = [self.txtFirstName detectIfTextfieldIsEmpty:self.txtFirstName.text];
    if (ifFirstNameEmpty)
    {
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:kEnterValidFirstName onController:self];
        ifFirstNameLastNameValidated = NO;
    }
    else if (self.txtFirstName.text.length<2)
    {
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"First name should be minimum Two cahracters" onController:self];
        ifFirstNameLastNameValidated = NO;
    }
    else
    {
        BOOL ifLastNameEmpty = [self.txtLastName detectIfTextfieldIsEmpty:self.txtLastName.text];
        if (ifLastNameEmpty)
        {
            [[ICSingletonManager sharedManager]showAlertViewWithMsg:kEnterValidLastName onController:self];
            ifFirstNameLastNameValidated = NO;
        }
        else if (self.txtLastName.text.length<2)
        {
            [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Last name should be minimum Two cahracters" onController:self];
            ifFirstNameLastNameValidated = NO;
        }
        else
        {
            NSInteger combOfFirstSecond=self.txtLastName.text.length+self.txtFirstName.text.length;
            
            if (combOfFirstSecond<5) {
                [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"First name, Second name combination should be minimum Five characters" onController:self];
                ifFirstNameLastNameValidated = NO;
            }
        }
    }
    return ifFirstNameLastNameValidated;

}

-(BOOL)validateEmailAddress{
    
    BOOL ifValidEmail = [self.txtEmailId.text isValidEmail];
    if (!ifValidEmail)
        [[ICSingletonManager sharedManager] showAlertViewWithMsg:kEnterValidEmailAddress onController:self];
    
    return  ifValidEmail;
}

- (BOOL)validatePhoneNumber
{
    BOOL ifValidPhoneNumber = [self.txtMobileNum.text isValidatePhone];
    if (!ifValidPhoneNumber)
    {
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:kEnterValidPhoneNumber onController:self];
    }
    return ifValidPhoneNumber;
}


- (BOOL)validateTermsCondition{
    if (self.isTermsConditionAccepted) {
//        image = [UIImage imageNamed:@"checkbox_selected"];
        return YES;
    }
    else
    {
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:kAcceptTermsCondition onController:self];
        return NO;
    }

}
#pragma mark -------------------------------------------
- (void)startServiceToRegisterNewUser{
    if (![self validateFirstNameAndLastName]) {
        return;
    }
    else if (![self validateEmailAddress]) {
        return;
    }
    else if (![self validatePhoneNumber]) {
        return;
    }else if ([_cityTxtFld.text isEqualToString: @""])
    {
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please Enter City Name" onController:self];
    }else if ([_cityTxtFld.text isEqualToString: @"Where do you Stay?"])
    {
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please Enter City Name" onController:self];
    } else
    {
        
        /****************** Google Analytics *******************/
        
        // Track the Event for UserSuccessfulRegistrationMobile
        
        NSString *actionStr = [NSString  stringWithFormat:@"%@ %@ %@",[NSString stringWithFormat:@"%@ %@",self.txtFirstName.text, self.txtLastName.text],self.txtMobileNum.text,self.txtEmailId.text];
        id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"App Tried Register IOS"
                                                              action:actionStr
                                                               label:self.txtMobileNum.text
                                                               value:nil] build]];
        
        /****************** Google Analytics *******************/
        
          /****************** Mo Engage *******************/
        NSMutableDictionary *purchaseDict = [NSMutableDictionary dictionaryWithDictionary:@{@"Mobile No":self.txtMobileNum.text,@"Email":self.txtEmailId.text, @"Name": [NSString stringWithFormat:@"%@ %@",self.txtFirstName.text, self.txtLastName.text]}];
        [MoEngage debug:LOG_ALL];
        
        [[MoEngage sharedInstance]trackEvent:@"App Tried Register IOS" andPayload:purchaseDict];
         [[MoEngage sharedInstance] syncNow];
        
          /****************** Mo Engage *******************/
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        ICSingletonManager *globals = [ICSingletonManager sharedManager];
       
NSDictionary *dictParams = @{@"Gender":[NSString stringWithFormat:@"%@",self.strGender],
                             @"FirstName":[NSString stringWithFormat:@"%@",self.txtFirstName.text],
                             @"LastName":[NSString stringWithFormat:@"%@",self.txtLastName.text],
                             @"Phone1":[NSString stringWithFormat:@"%@",self.txtMobileNum.text],
                             @"Email":[NSString stringWithFormat:@"%@",self.txtEmailId.text],
                             @"IsOfferandNewsletter":[NSString stringWithFormat:@"%@",_IsOfferandNewsletter],
                             @"IsGetCall":[NSString stringWithFormat:@"%@",_IsGetCall],
                             @"IsPreReg":globals.flagStatusSale,
                             @"Resident_cityID":[NSNumber numberWithInt:cityId],
                             @"RefralCode":[NSString stringWithFormat:@"%@",self.refferalCodeTxtFld.text]};
        
        globals.referralCode = self.refferalCodeTxtFld.text;
        NSString *strParam = [dictParams jsonStringWithPrettyPrint:YES];
        NSString *strUrl =[NSString stringWithFormat:@"%@/api/Registrationapi/MobileRegister",kServerUrl];
        NSLog(@"%@",strUrl);
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                        initWithURL:[NSURL URLWithString:strUrl]
                                        cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                        timeoutInterval:120.0f];
        
        [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPMethod:@"POST"];
        NSString *postString = strParam;
        NSData * data = [postString dataUsingEncoding:NSUTF8StringEncoding];
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[data length]];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:data];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
         {
             if (!connectionError)
             {
                 NSLog(@"response--%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                 NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: nil];
               
                 NSString *status = [responseObject valueForKey:@"status"];
                 NSString *msg = [responseObject valueForKey:@"errorMessage"];
                 if ([status isEqualToString:@"SUCCESS"])
                 {
                     ICSingletonManager *globals = [ICSingletonManager sharedManager];
                     globals.FirstTimeAppLoginOrRegister = @"YES";
                     globals.userReferralCode =   [responseObject valueForKey:@"referralCode"];
                     NSDictionary  *dictUserModel = [responseObject valueForKey:@"userModel"];
                     if ([[responseObject valueForKey:@"userModel"] isEqual:[NSNull null]])
                     {
                         [[ICSingletonManager sharedManager] showAlertViewWithMsg:msg onController:self];
                     }
                     else
                     {
                         
                         
                         NSMutableDictionary *dictCleanedUserModel= [self cleanDictionary:[dictUserModel mutableCopy]];
                         dictUserModel = [dictCleanedUserModel copy];
                         
                         /// Google
                         LoginManager *loginManage = [[LoginManager alloc]init];
                         [loginManage loginUserWithUserDataDictionary:dictUserModel ];
                         
                         NSDictionary *dict = [loginManage isUserLoggedIn];
                         NSLog(@"%@",dict);
                         NSString *userName = [NSString stringWithFormat:@"%@ %@", [dict objectForKey:@"FirstName"], [dict objectForKey:@"LastName"]];
                         
                         // For sending deviceToken to srever for push notification
                         [self postDataToPushNotification];
                         
                        // For getting coupen detail
                         [self startServiceToGetCouponsDetails];
                         
                         /****************** Mo Engage *******************/
                         ICSingletonManager *globals = [ICSingletonManager sharedManager];
                         
                         NSData *strDeviceToken = [globals.StrDeviceToken dataUsingEncoding:NSUTF8StringEncoding];
                       
                         [[MoEngage sharedInstance]registerForPush:strDeviceToken];
                         [MoEngage debug:LOG_ALL];
                         
                         
                         NSMutableDictionary *purchaseDict = [NSMutableDictionary dictionaryWithDictionary:@{@"Mobile No": [dict objectForKey:@"Phone1"],@"Email":[dict objectForKey:@"Email"], @"Name": userName}];
                        
                         
                         [[MoEngage sharedInstance]trackEvent:@"App  Register IOS" andPayload:purchaseDict];
                          [[MoEngage sharedInstance] syncNow];
                          [MoEngage debug:LOG_ALL];

                         /****************** Mo Engage *******************/
                         
                         /****************** Google Analytics *******************/
                         
                         
                         NSString *actionStr = [NSString  stringWithFormat:@"%@ %@ %@",userName,[dict objectForKey:@"Phone1"],[dict objectForKey:@"Email"]];
                         id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
                         [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"App  Register IOS"
                                                                               action:actionStr
                                                                                label:self.txtMobileNum.text
                                                                                value:nil] build]];
                         
                         /****************** Google Analytics *******************/

                         
                     }
                 }else if ([status isEqualToString:@"Fail"])
                 {
                    
                     
                     [[ICSingletonManager sharedManager] showAlertViewWithMsg:@"Your Referal Code Is Incorrect" onController:self];
                 }
                
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
             }
             else
             {
                 NSLog(@"error--%@",connectionError);
                 [[ICSingletonManager sharedManager] showAlertViewWithMsg:connectionError.localizedDescription onController:self];
                
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
             }
         }];
    }
}

- (NSMutableDictionary *)cleanDictionary:(NSMutableDictionary *)dictionary {
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (obj == [NSNull null]) {
            [dictionary setObject:@"" forKey:key];
        } else if ([obj isKindOfClass:[NSDictionary class]]) {
            [self cleanDictionary:obj];
        }
    }];
    return  dictionary;
}
- (void)startServiceToGetCouponsDetails
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    NSNumber *num = [dict valueForKey:@"UserId"];
    
    NSDictionary *dictParams = @{@"userid":num};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    [manager GET:[NSString stringWithFormat:@"%@/api/BuyCoupens/GetUserDashboardDetail?",kServerUrl] parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        
        NSString *status = [responseObject valueForKey:@"status"];
        // NSString *msg = [responseObject valueForKey:@"errorMessage"];
        if ([status isEqualToString:@"SUCCESS"]) {
            
            int numCouponCount = [[responseObject valueForKey:@"UserCouponCount"] intValue];
            NSNumber *numPastStayCount = [responseObject valueForKey:@"UserPastStayCount"];
            NSNumber *numWhishlistCount = [responseObject valueForKey:@"UserWishlistCount"];
            
            ICSingletonManager *globals = [ICSingletonManager sharedManager];
            globals.validVoucher = numCouponCount;
            globals.isFromRegisteredNewUser = @"YES";
            [[NSUserDefaults standardUserDefaults] setInteger:numCouponCount forKey:@"validVoucher"];
            
            //// Send to the Home View /////
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            
            HomeScreenController *vcHomeScreen = [storyboard instantiateViewControllerWithIdentifier:@"HomeScreenController"];
            SideMenuController *vcSideMenu =     [storyboard instantiateViewControllerWithIdentifier:@"SideMenuController"];
            
            MMDrawerController *drawerController = [[MMDrawerController alloc]initWithCenterViewController:vcHomeScreen
                                                                                  leftDrawerViewController:vcSideMenu];
            [drawerController setRestorationIdentifier:@"MMDrawer"];
            //                         [drawerController setMaximumLeftDrawerWidth:[UIScreen mainScreen].bounds.size.width -[UIScreen mainScreen].bounds.size.width/2 ];
            [drawerController setMaximumLeftDrawerWidth:SCREEN_WIDTH*2/3];
            
            [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
            [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
            drawerController.shouldStretchDrawer = NO;
            
            UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:drawerController];
            [navController setNavigationBarHidden:YES];
            self.view.window.rootViewController = navController;
            
            
            
        }
        
        NSLog(@"sucess");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[ICSingletonManager sharedManager] showAlertViewWithMsg:error.localizedDescription onController:self];
        
    }];
    
    
}
#pragma mark - UITextFieldDelegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField{              // called when 'return' key pressed. return NO to ignore.
    
  
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length == 0 && [string isEqualToString:@" "]) {
        return NO;
    }
    if(textField == self.txtFirstName || textField == self.txtLastName)
    {
        
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"];
        for (int i = 0; i < [string length]; i++)
        {
            unichar c = [string characterAtIndex:i];
            if (![myCharSet characterIsMember:c])
            {
                return NO;
            }
        }
        
        return YES;
    }
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    if (textField == self.txtMobileNum ) {
        if (range.location == 10 || ![string isEqualToString:filtered])
            return NO;
        return YES;
    }
    if (textField == self.refferalCodeTxtFld) {
        NSRange lowercaseCharRange = [string rangeOfCharacterFromSet:[NSCharacterSet lowercaseLetterCharacterSet]];
        
        if (lowercaseCharRange.location != NSNotFound) {
            textField.text = [textField.text stringByReplacingCharactersInRange:range
                                                                     withString:[string uppercaseString]];
            return NO;
        }
        
        return YES;
    }
    
     return YES;
}


- (IBAction)btnSubmitTapped:(id)sender
{
    [self startServiceToRegisterNewUser];
}

- (IBAction)btnExistingUserLoginTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)btnBackTapped:(id)sender {
    ICSingletonManager *globals = [ICSingletonManager sharedManager];

   
    if ([globals.registrationBackManage isEqualToString:@"YES"]) {
         [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }else if ([globals.registrationBackManage isEqualToString:@"NO"]){
         globals.registrationBackManage = @"YES";
          [self.navigationController  popViewControllerAnimated:YES];
    }
  
}

- (IBAction)btnRadioMaleTapped:(id)sender
{
    [self.btnRadioMale setBackgroundImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
    [self.btnRadioFemale setBackgroundImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
    self.strGender = @"M";
    
    
//    UIButton *btn = (UIButton *)sender;
//    UIImage *image = [btn backgroundImageForState:UIControlStateNormal];
//    
//    if ([image isEqual: [UIImage imageNamed:@"radio"]]) {
//        image = [UIImage imageNamed:@"radio_selected"];
//        [btn setBackgroundImage:image forState:UIControlStateNormal];
//        [self.btnRadioFemale setBackgroundImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
//    }
//    else{
//        image = [UIImage imageNamed:@"radio"];
//        [btn setBackgroundImage:image forState:UIControlStateNormal];
//         [self.btnRadioFemale setBackgroundImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
//        self.strGender = @"M";
//    }
}

- (IBAction)btnRadioFemaleTapped:(id)sender
{
    /// New code by Harry
    [self.btnRadioMale setBackgroundImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
    [self.btnRadioFemale setBackgroundImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
    self.strGender = @"F";
    
//    UIButton *btn = (UIButton *)sender;
//    UIImage *image = [btn backgroundImageForState:UIControlStateNormal];
//    
//    if ([image isEqual: [UIImage imageNamed:@"radio"]]) {
//        image = [UIImage imageNamed:@"radio_selected"];
//        [btn setBackgroundImage:image forState:UIControlStateNormal];
//        [self.btnRadioMale setBackgroundImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
//    }
//    else{
//        image = [UIImage imageNamed:@"radio"];
//        [btn setBackgroundImage:image forState:UIControlStateNormal];
//        [self.btnRadioMale setBackgroundImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
//        self.strGender = @"F";
//    }
}

- (IBAction)btnTermsConditionTapped:(id)sender
{
    [self.termAndConditionView setHidden:NO];
    [self.blackTransparentView setHidden:NO];

//    UIButton *btn = (UIButton *)sender;
//    UIImage *image = [btn backgroundImageForState:UIControlStateNormal];
//    
//    if ([image isEqual: [UIImage imageNamed:@"checkbox"]]) {
//        image = [UIImage imageNamed:@"checkbox_selected"];
//        [btn setBackgroundImage:image forState:UIControlStateNormal];
//    }
//    else{
//        image = [UIImage imageNamed:@"checkbox"];
//        [btn setBackgroundImage:image forState:UIControlStateNormal];
//    }
}
- (IBAction)btnSendmeOfferTapped:(id)sender {
    if (self.isSendMeOffer == NO) {
        self.isSendMeOffer = YES;
        _IsOfferandNewsletter = @"1";
        self.Img_SendMeOffer.image = [UIImage imageNamed:@"checkbox_selected"];
    }
    else{
        _IsOfferandNewsletter = @"0";
        self.isSendMeOffer = NO;
        self.Img_SendMeOffer.image = [UIImage imageNamed:@"checkbox"];
    }
}
-(void)imageOwnerTapped:(id)sender {
    [self.termAndConditionView setHidden:YES];
    [self.blackTransparentView setHidden:YES];
    
    [self.btnTermsCondition setBackgroundImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
    self.isTermsConditionAccepted = NO;
}
- (IBAction)doClickonCrossButtonTapped:(id)sender {
    [self.termAndConditionView setHidden:YES];
    [self.blackTransparentView setHidden:YES];
    
    [self.btnTermsCondition setBackgroundImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
    self.isTermsConditionAccepted = NO;
}

- (IBAction)btnGetaCallTapped:(id)sender {
        
    if (self.isGetaCall == NO) {
        self.isGetaCall = YES;
        _IsGetCall = @"1";
        self.img_GetaCall.image = [UIImage imageNamed:@"checkbox_selected"];
    }
    else{
        _IsGetCall = @"0";
        self.isGetaCall = NO;
        self.img_GetaCall.image = [UIImage imageNamed:@"checkbox"];
    }

}

-(void)postDataToPushNotification
{
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    NSLog(@"%@",dict);
    
    NSNumber *userId = [dict valueForKey:@"UserId"];
    
    AppDelegate *appDelegate= (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    //          http://www.icanstay.com/api/AppPush/PushIOSInsertUUID?UserId=1&UUID=xxx111
    
    NSString *strParams = [NSString stringWithFormat:@"UserId=%@&UUID=%@",userId,appDelegate.strDeviceToken];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    [manager GET:[NSString stringWithFormat:@"%@/api/AppPush/PushIOSInsertUUID?%@",kServerUrl,strParams] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[ICSingletonManager sharedManager] showAlertViewWithMsg:error.localizedDescription onController:self];
        
        
    }];
}

@end
