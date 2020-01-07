//
//  LastMinuteViewController.m
//  ICanStay
//
//  Created by Planet on 6/7/17.
//  Copyright © 2017 verticallogics. All rights reserved.
//

#import "LastMinuteViewController.h"
#import "SideMenuController.h"
#import "HomeScreenController.h"
#import "NotificationScreen.h"
#import "CityIpadCollectionViewCell.h"
#import "LastMinuteDealDetailViewController.h"
#import "LastMinutePaymentSuccessPopUpView.h"


@interface LastMinuteViewController ()<UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource>
{
    UIView               *txtFldview;
    UICollectionView     *_collectionView;
    UITableView          *cityNameTableView;
    NSMutableDictionary  *cityNameTableSelectArr;
      BOOL               isFilter;
    
      int                manageAlertTblAddress;
       int               selectCellCityNameTable;
      NSMutableArray     *tempStateDetailArr;
    NSMutableArray       *tempThemeDetailArr;
    NSString             *searchTextString;
    int                  reloadCollectionViewWhenTblViewCitySelect;
    
 
}
@property (nonatomic, strong) UIView         *topWhiteBaseView;
@property (nonatomic, strong) UIButton       *backButton;
@property (nonatomic, strong) UIButton       *notificationButton;
@property (nonatomic, strong) UIImageView    *logoIconImgView;
@property (nonatomic, strong) UITextField    *cityTxtFld;
@property (strong,nonatomic)  NSMutableArray *arrayCityList,*filteredCityList;
@property(weak, nonatomic)          LastMinutePaymentSuccessPopUpView  *_paymentView;

@end

@implementation LastMinuteViewController
@synthesize _paymentView;
- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    isFilter = NO;
    reloadCollectionViewWhenTblViewCitySelect = 0;
      DLog(@"DEBUG-VC");
    
    
    
      cityNameTableSelectArr = [[NSMutableDictionary alloc]init];
    
    self.topWhiteBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,screenRect.size.width , 64)];
    self.topWhiteBaseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topWhiteBaseView];
    
    self.notificationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.notificationButton.frame = CGRectMake(self.topWhiteBaseView.frame.size.width - 40 - 10, 20, 24, 24);
    [self.notificationButton setBackgroundImage:[UIImage imageNamed:@"notification1"] forState:UIControlStateNormal];
    [self.notificationButton addTarget:self action:@selector(notificationButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//    [self.topWhiteBaseView addSubview:self.notificationButton];
    
    

    
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
    
    
    UIImageView *baseImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, self.topWhiteBaseView.frame.origin.y + self.topWhiteBaseView.frame.size.height, self.view.frame.size.width - 20, 120)];
    baseImageView.image = [UIImage imageNamed:@"PackageBaseImg"];
    [self.view addSubview:baseImageView];
    
    UILabel *luxlbl = [[UILabel alloc]init];
    luxlbl.text     = @"Last Minute Luxury Hotel Deals";
    luxlbl.textAlignment = NSTextAlignmentCenter;
    luxlbl.textColor = [ICSingletonManager colorFromHexString:@"#bd9854"];
   
    luxlbl.backgroundColor = [UIColor clearColor];
    [baseImageView addSubview:luxlbl];
    
    
    UILabel *midlbl = [[UILabel alloc]init];
    midlbl.text = @"Luxury Stay starting ₹2,999 (Incl. GST)";
       midlbl.textColor = [UIColor whiteColor];
    midlbl.textAlignment = NSTextAlignmentCenter;
    
    midlbl.backgroundColor = [UIColor clearColor];
    
    [baseImageView addSubview:midlbl];
  
    UILabel *lowerLbl = [[UILabel alloc]init ];
    lowerLbl.text = @"Select City and Book now";
    lowerLbl.textColor = [UIColor whiteColor];
    lowerLbl.textAlignment = NSTextAlignmentCenter;
    lowerLbl.backgroundColor = [UIColor clearColor];
    [baseImageView addSubview:lowerLbl];
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        luxlbl.frame = CGRectMake(0,  10, self.view.frame.size.width , 40);
        luxlbl.font = [UIFont systemFontOfSize:24];
        midlbl.frame = CGRectMake(0, luxlbl.frame.size.height + luxlbl.frame.origin.y -5, self.view.frame.size.width , 25);
        midlbl.font = [UIFont systemFontOfSize:18];
        lowerLbl.frame = CGRectMake(0, midlbl.frame.size.height + midlbl.frame.origin.y -5, self.view.frame.size.width , 25);
         lowerLbl.font = [UIFont systemFontOfSize:18];
    }else{
        
        
        luxlbl.frame = CGRectMake(0, 0, baseImageView.frame.size.width , 27);
        luxlbl.font = [UIFont systemFontOfSize:20];
        midlbl.frame = CGRectMake(2, luxlbl.frame.size.height + luxlbl.frame.origin.y, baseImageView.frame.size.width -4 , 27);
        midlbl.font = [UIFont systemFontOfSize:16];
        
        lowerLbl.frame = CGRectMake(2, midlbl.frame.size.height + midlbl.frame.origin.y , baseImageView.frame.size.width -4 , 27);
        lowerLbl.font = [UIFont systemFontOfSize:16];
        baseImageView.frame = CGRectMake(5, self.topWhiteBaseView.frame.origin.y + self.topWhiteBaseView.frame.size.height, self.view.frame.size.width - 10, 81 );
           }
    
  //  self.view.backgroundColor = [ICSingletonManager colorFromHexString:@"#001d3d"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    txtFldview = [[UIView alloc]initWithFrame:CGRectMake(20, baseImageView.frame.size.height + baseImageView.frame.origin.y +10 ,self.view.frame.size.width - 40 , 40)];
    [self.view addSubview:txtFldview];
    
    self.cityTxtFld = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, txtFldview.frame.size.width, 30)];
    self.cityTxtFld.delegate = self;
    self.cityTxtFld.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.cityTxtFld.font = [UIFont systemFontOfSize:20];
    self.cityTxtFld.textColor = [UIColor blackColor];
    UIColor *color = [ICSingletonManager colorFromHexString:@"#BD9854"];
    self.cityTxtFld.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Select City" attributes:@{NSForegroundColorAttributeName: color}];
    [txtFldview addSubview:self.cityTxtFld];
    
  
    
    UIView *narrowGoldLineview = [[UIView alloc]initWithFrame:CGRectMake(0, self.cityTxtFld.frame.size.height + self.cityTxtFld.frame.origin.y + 5, txtFldview.frame.size.width, 2)];
    narrowGoldLineview.backgroundColor = [ICSingletonManager colorFromHexString:@"#BD9854"];
    [txtFldview addSubview:narrowGoldLineview];

    
    cityNameTableView = [[UITableView alloc]initWithFrame:CGRectMake(20, txtFldview.frame.origin.y +txtFldview.frame.size.height, txtFldview.frame.size.width, self.view.frame.size.height * 0.30)];
    cityNameTableView.delegate = self;
    cityNameTableView.dataSource = self;
    cityNameTableView.hidden = YES;
    
    [self.cityTxtFld addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    manageAlertTblAddress = 0;
    [self getStateList];

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
-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}
-(void)textFieldDidChange:(UITextField*)textField
{
    
    if (reloadCollectionViewWhenTblViewCitySelect == 1) {
        isFilter = NO;
        [_collectionView reloadData];
        reloadCollectionViewWhenTblViewCitySelect = 0;
        _cityTxtFld.text = @"";
        [_cityTxtFld resignFirstResponder];
        //  isFilter = YES;
    }else{
         searchTextString = textField.text;
        [self updateSearchArray];
    }
   
}

-(void)getStateList
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    //http://www.icanstay.com/Api/FAQApi/GetCityApi
    //    [manager GET:[NSString stringWithFormat:@"http://www.icanstay.com/Api/FAQApi/GetCityApi"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    [manager GET:[NSString stringWithFormat:@"%@/Api/FAQApi/GetLastMinuteDealCityApi", kServerUrl] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        tempStateDetailArr = responseObject;
        self.arrayCityList = tempStateDetailArr;
        
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(5, txtFldview.frame.origin.y + txtFldview.frame.size.height+5, self.view.frame.size.width - 10, self.view.frame.size.height - (txtFldview.frame.origin.y + txtFldview.frame.size.height + 10)) collectionViewLayout:layout];
        [_collectionView setDataSource:self];
        [_collectionView setDelegate:self];
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        [_collectionView registerNib:[UINib nibWithNibName:@"CityIpadCollectionViewCell" bundle:[NSBundle mainBundle]]
          forCellWithReuseIdentifier:@"CityIpadCollectionViewCell"];
        
       
        
        [self.view addSubview:_collectionView];
        [self.view addSubview:cityNameTableView];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        ICSingletonManager *globals = [ICSingletonManager sharedManager];
        if ([globals.isFromLastMinuteBookingPaymentSuccess isEqualToString:@"YES"]) {
            globals.isFromLastMinuteBookingPaymentSuccess = @"NO";
            _paymentView = [LastMinutePaymentSuccessPopUpView lastMinutePaymentSuccessPopUpView:self.confirmPaymentJsonDict];
           
            [self.view addSubview:_paymentView];
                   }

        if ([globals.isFromLastMinuteBookingPaymentFail isEqualToString:@"YES"]) {
            globals.isFromLastMinuteBookingPaymentFail = @"NO";
            [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"We Regret to inform you that the purchase was not successful." onController:self];
            
                    }

        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:error.localizedDescription onController:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}

-(void)updateSearchArray
{
    if (searchTextString.length != 0)
    {
        isFilter = YES;
        NSPredicate *titlePredicate = [NSPredicate predicateWithFormat:@"City contains[c] %@ ", searchTextString];
        
        _filteredCityList = [NSMutableArray arrayWithArray:[_arrayCityList filteredArrayUsingPredicate:titlePredicate]];
        NSLog(@"searchResult %@",_filteredCityList);
        cityNameTableView.hidden = NO;
        
        if ([_filteredCityList count] == 0  && manageAlertTblAddress == 0) {
            
            cityNameTableView.hidden = YES;
            
            
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
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                //                [self.cityTableView reloadData];
            }else{
                
            }
            
        }
    }else{
        isFilter=NO;
        _filteredCityList = self.arrayCityList;
    }
    
    [cityNameTableView reloadData];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (isFilter)
    {
        return 1;
    }else
        return ([self.arrayCityList count]);
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *CitylistDictionary;
    NSLog(@"%ld",(long)indexPath.row);
    if (isFilter)
    {
        
        CitylistDictionary = cityNameTableSelectArr;
    }
    else
    {
        CitylistDictionary = [self.arrayCityList objectAtIndex:indexPath.row];
    }
    CityIpadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CityIpadCollectionViewCell" forIndexPath:indexPath];
    NSString *imageUrl = [NSString stringWithFormat:@"http://www.icanstay.com/www/images/cities/%@",[CitylistDictionary objectForKey:@"CityImage"]];
    
    [cell.cityImageView setImageWithURL:[NSURL URLWithString:[self getURLFromString:[CitylistDictionary objectForKey:@"cityImages"]]] placeholderImage:[UIImage imageNamed:@"photo_frame"]];
    
    
    NSString *stateAndCityNameStr = [NSString stringWithFormat:@"%@",[ICSingletonManager getStringValue:[CitylistDictionary objectForKey:@"City"]]];
   
    if ([stateAndCityNameStr containsString:@"Greater Noida"]) {
        stateAndCityNameStr =[[stateAndCityNameStr componentsSeparatedByString:@" "] objectAtIndex:0];
        stateAndCityNameStr = @"Noida";
    }
    
    if ([stateAndCityNameStr containsString:@"NCR Delhi"]) {
        stateAndCityNameStr =[[stateAndCityNameStr componentsSeparatedByString:@" "] objectAtIndex:0];
        if ([stateAndCityNameStr containsString:@"Greater"]) {
            stateAndCityNameStr =[[stateAndCityNameStr componentsSeparatedByString:@" "] objectAtIndex:0];
            stateAndCityNameStr = @"Noida";
        }
    }
  
    cell.cityNameLbl.text = stateAndCityNameStr;
    cell.cityNameLbl.textColor = [UIColor whiteColor];
   
    //    cell.frame = CGRectMake(0, 0,self.view.frame.size.width/2-5 , 300);
    cell.cityImageView.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height - 30);
    cell.cityNameLbl.frame = CGRectMake(0, cell.cityImageView.frame.size.height , cell.cityImageView.frame.size.width, 30);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
    }else{
        cell.cityNameLbl.font = [UIFont systemFontOfSize:15];
        if ([stateAndCityNameStr containsString:@"Mahabaleshwar"]) {
            stateAndCityNameStr =[[stateAndCityNameStr componentsSeparatedByString:@" "] objectAtIndex:0];
            stateAndCityNameStr = @"Mahabaleshwar";
            cell.cityNameLbl.font = [UIFont systemFontOfSize:13];
        }
    }
    cell.exporePackages.frame = CGRectMake(cell.cityImageView.frame.size.width - 150, cell.cityNameLbl.frame.size.height + cell.cityNameLbl.frame.origin.y,150 , 30);
    cell.exporePackages.text = @"Explore Hotel";
    cell.exporePackages.hidden = YES;
    cell.exporePackages.textColor = [UIColor whiteColor];
    cell.cityNameLbl.backgroundColor =  [ICSingletonManager colorFromHexString:@"#001d3d"];
    cell.backgroundColor = [ICSingletonManager colorFromHexString:@"#001d3d"];
    cell.exporePackages.backgroundColor = [ICSingletonManager colorFromHexString:@"#001d3d"];
    
    
    
    //        UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    //        UIImageView *baseImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height - 30)];
    //        [baseImgView setImageWithURL:[NSURL URLWithString:[CitylistDictionary objectForKey:@"CityImage"]] placeholderImage:[UIImage imageNamed:@"photo_frame"]];
    //        [cell addSubview:baseImgView];
    //
    //    UILabel *cityNameLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, baseImgView.frame.size.height, baseImgView.frame.size.width, 30)];
    //    cityNameLbl.textColor = [UIColor whiteColor];
    //    cityNameLbl.text = [ICSingletonManager getStringValue:[CitylistDictionary objectForKey:@"CITY_NAME"]];
    //    cityNameLbl.textAlignment = NSTextAlignmentCenter;
    //       [cell addSubview:cityNameLbl];
    //
    //            [cell setTag:indexPath.row];
    
    return cell;
    
    
}
-(NSString *)getURLFromString:(NSString *)str{
    
    NSString *urlStr = [str stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    return urlStr;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1; // This is the minimum inter item spacing, can be more
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath

{
    
    NSDictionary *CitylistDictionary;
    if (isFilter == NO) {
        CitylistDictionary = [self.arrayCityList objectAtIndex:indexPath.row];
    }else if (isFilter == YES)
    {
        
        CitylistDictionary = cityNameTableSelectArr;
    }
    
    
    NSLog(@"%@", CitylistDictionary);
    //NSLog(@"selected %d row", indexPath.row);
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    LastMinuteDealDetailViewController  *lastMinuteDetails =[storyboard instantiateViewControllerWithIdentifier:@"LastMinuteDealDetailViewController"];
          lastMinuteDetails.cityName = [CitylistDictionary objectForKey:@"City"];
    lastMinuteDetails.cityceo = [CitylistDictionary objectForKey:@"Cityseo"];
    lastMinuteDetails.cityId  =[NSString stringWithFormat:@"%@", [CitylistDictionary objectForKey:@"CityId"]];
    lastMinuteDetails.arrayCityList = self.arrayCityList;
          
    [self.navigationController pushViewController:lastMinuteDetails animated:YES];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return CGSizeMake(self.view.frame.size.width/3-10, 200);
    }else{
        return CGSizeMake(_collectionView.frame.size.width/3-6, 120);
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
    return 60;
    
}

// the cell will be returned to the tableView
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"cellID";
    NSDictionary *CitylistDictionary;
    CitylistDictionary = [self.filteredCityList objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:
                             cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [cell.textLabel setText:[ICSingletonManager getStringValue:[CitylistDictionary objectForKey:@"City"]]];
    return cell;
    
}

#pragma mark - UITableViewDelegate

// when user tap the row, what action you want to perform
- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (theTableView == cityNameTableView) {
        isFilter = YES;
        reloadCollectionViewWhenTblViewCitySelect = 1;
        cityNameTableSelectArr = [self.filteredCityList objectAtIndex:indexPath.row];
        selectCellCityNameTable = 1;
        self.cityTxtFld.text = [ICSingletonManager getStringValue:[cityNameTableSelectArr objectForKey:@"City"]];
        [_collectionView reloadData];
        
        cityNameTableView.hidden = YES;
        [self.cityTxtFld resignFirstResponder];
    }
}

-(void)backButtonTapped:(id)sender
{
    
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    
    
    if ([globals.isFromMenuLastMinuteDeal isEqualToString:@"YES"]) {
        globals.isFromMenuLastMinuteDeal = @"NO";
        [self.navigationController popViewControllerAnimated:YES];
    }else{
         [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }
    
        
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
        
        
        //        NotificationViewController *notification = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationViewController"];
        //        [self.navigationController pushViewController:notification animated:YES];
        
        
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
