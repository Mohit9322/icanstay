//
//  CitiesViewController.m
//  ICanStay
//
//  Created by Harish on 12/11/16.
//  Copyright © 2016 verticallogics. All rights reserved.
//

#import "CitiesViewController.h"
#import "MBProgressHud.h"
#import "AFNetworking.h"
#import "NSDictionary+JsonString.h"
#import "LoginManager.h"
#import "CitiesTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "CitiesDetailsViewController.h"
#import "NotificationScreen.h"
#import "DashboardScreen.h"
#import "HomeScreenController.h"
#import "SideMenuController.h"
#import "CityIpadCollectionViewCell.h"
#import "CityDetailsViewController.h"

@interface CitiesViewController ()<UISearchResultsUpdating, UISearchBarDelegate, UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UITableView           *cityNameTableView;
     int                  manageAlertTblAddress;
    NSMutableDictionary   *cityNameTableSelectArr;
    int                   selectCellCityNameTable;
    UICollectionView     *_collectionView;
    int                   reloadCollectionViewWhenTblViewCitySelect;
}
@property (weak, nonatomic) IBOutlet UIView *blueLuxBaseView;
@property (strong, nonatomic) IBOutlet UIImageView *icsLogoImgView;

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults; // Filtered search results
@property (weak, nonatomic) IBOutlet UILabel *headingTitle;
@property (weak, nonatomic) IBOutlet UILabel *headingText;

@end

@implementation CitiesViewController
@synthesize arrayCityList,filteredCityList;

- (void)viewDidLoad {
    [super viewDidLoad];
     DLog(@"DEBUG-VC");
    reloadCollectionViewWhenTblViewCitySelect = 0;
    
    cityNameTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.searchTextField.frame.origin.y + self.searchTextField.frame.size.height, self.view.frame.size.width, self.view.frame.size.height * 0.30)];
    cityNameTableView.delegate = self;
    cityNameTableView.dataSource = self;
    cityNameTableView.hidden = YES;
    selectCellCityNameTable = 0;
    // Do any additional setup after loading the view.
    if (arrayCityList == nil) {
        arrayCityList = [[NSMutableArray alloc] init];
    }
    self.searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    cityNameTableSelectArr = [[NSMutableDictionary alloc]init];
    // Create a mutable array to contain products for the search results table.
//    self.searchResults = [NSMutableArray arrayWithCapacity:[self.arrayCityList count]];
//    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
//    
//    self.searchController.searchResultsUpdater = self;
//    
//    self.searchController.dimsBackgroundDuringPresentation = NO;
//    self.searchController.hidesNavigationBarDuringPresentation = NO;
//    self.searchController.searchBar.placeholder = @"Enter City";
//    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, SCREEN_WIDTH-10, 44.0);
//    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
//    self.searchController.searchBar.backgroundColor = [UIColor clearColor];
//    
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.searchController.searchBar.frame.origin.x, 45, SCREEN_WIDTH-10, 2)];
//    label.backgroundColor = [ICSingletonManager colorFromHexString:@"#BD9854"];
//    label.text = @"";
//    [label setFont:[UIFont fontWithName:@"JosefinSans-Light" size:26]];
//
//    UIView *hView = [[UIView alloc] initWithFrame: CGRectMake ( 0, 0, SCREEN_WIDTH-10, 55)];
//    [hView addSubview:self.searchController.searchBar];
//    [hView addSubview:label];
//
//    self.cityTableView.tableHeaderView = hView;
    
    //set the selector to the text field in order to change its value when edited
    
    
    [self.searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        _blueLuxBaseView.hidden = YES;
        
        UIImageView *baseImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, _blueLuxBaseView.frame.origin.y , self.view.frame.size.width - 20, 100)];
        baseImageView.image = [UIImage imageNamed:@"PackageBaseImg"];
        [self.view addSubview:baseImageView];
        
        
        UILabel *luxlbl = [[UILabel alloc]initWithFrame:CGRectMake(100, 20, baseImageView.frame.size.width -200, 40)];
        luxlbl.text = @"Luxury Hotels";
        luxlbl.textAlignment = NSTextAlignmentCenter;
        luxlbl.textColor = [UIColor whiteColor];
        luxlbl.font = [UIFont systemFontOfSize:32];
        [baseImageView addSubview:luxlbl];
        
        
        UILabel *midlbl = [[UILabel alloc]initWithFrame:CGRectMake(10, luxlbl.frame.size.height + luxlbl.frame.origin.y -5, baseImageView.frame.size.width - 20 , 25)];
        midlbl.text  = @"Available in these cities for Rs. 2999 (Incl. GST) only";
        midlbl.textColor = [UIColor whiteColor];
        midlbl.textAlignment = NSTextAlignmentCenter;
        midlbl.font = [UIFont systemFontOfSize:22];
        [baseImageView addSubview:midlbl];
        
     }
    
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
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        NSDictionary *CitylistDictionary;
        NSLog(@"%ld",(long)indexPath.item);
        if (isFilter)
        {
            
            CitylistDictionary = cityNameTableSelectArr;
        }
        else
        {
            CitylistDictionary = [self.arrayCityList objectAtIndex:indexPath.item];
        }
        CityIpadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CityIpadCollectionViewCell" forIndexPath:indexPath];
        NSString *imageUrl = [NSString stringWithFormat:@"http://www.icanstay.com/www/images/cities/%@",[CitylistDictionary objectForKey:@"CityImage"]];
        
        [cell.cityImageView setImageWithURL:[NSURL URLWithString:[self getURLFromString:imageUrl]] placeholderImage:[UIImage imageNamed:@"photo_frame"]];
        
        
        
        
        cell.cityNameLbl.text = [ICSingletonManager getStringValue:[CitylistDictionary objectForKey:@"CITY_NAME"]];
        cell.cityNameLbl.textColor = [UIColor whiteColor];
        //    cell.frame = CGRectMake(0, 0,self.view.frame.size.width/2-5 , 300);
        cell.cityImageView.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height - 30);
        cell.cityNameLbl.frame = CGRectMake(0, cell.cityImageView.frame.size.height, cell.cityImageView.frame.size.width, 30);
        cell.exporePackages.frame = CGRectMake(cell.cityImageView.frame.size.width - 150, cell.cityNameLbl.frame.size.height + cell.cityNameLbl.frame.origin.y,150 , 30);
        cell.exporePackages.text = @"Explore Packages";
        cell.exporePackages.textColor = [UIColor whiteColor];
        cell.exporePackages.hidden = YES;
        cell.cityNameLbl.backgroundColor =  [self colorWithHexString:@"001d3d"];
        cell.backgroundColor = [self colorWithHexString:@"001d3d"];
        cell.exporePackages.backgroundColor = [self colorWithHexString:@"001d3d"];
        
    
        
        return cell;
    }else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        NSDictionary *CitylistDictionary;
        NSLog(@"%ld",(long)indexPath.item);
        if (isFilter)
        {
            
            CitylistDictionary = cityNameTableSelectArr;
        }
        else
        {
            CitylistDictionary = [self.arrayCityList objectAtIndex:indexPath.item];
        }
        CityIpadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CityIpadCollectionViewCell" forIndexPath:indexPath];
      
        
        NSString *imageUrl = [NSString stringWithFormat:@"http://www.icanstay.com/www/images/cities/%@",[CitylistDictionary objectForKey:@"CityImage"]];
        
        [cell.cityImageView setImageWithURL:[NSURL URLWithString:[self getURLFromString:imageUrl]] placeholderImage:[UIImage imageNamed:@"photo_frame"]];
        
        NSString *stateAndCityNameStr = [NSString stringWithFormat:@"%@",[ICSingletonManager getStringValue:[CitylistDictionary objectForKey:@"CITY_NAME"]]];
        
        if ([stateAndCityNameStr containsString:@"Greater Noida"]) {
            stateAndCityNameStr =[[stateAndCityNameStr componentsSeparatedByString:@" "] objectAtIndex:0];
            stateAndCityNameStr = @"Noida";
        } else {
            NSLog(@"string does not contain bla");
        }
        
        if ([stateAndCityNameStr containsString:@"NCR Delhi"]) {
            stateAndCityNameStr =[[stateAndCityNameStr componentsSeparatedByString:@" "] objectAtIndex:0];
            if ([stateAndCityNameStr containsString:@"Greater"]) {
                stateAndCityNameStr =[[stateAndCityNameStr componentsSeparatedByString:@" "] objectAtIndex:0];
                stateAndCityNameStr = @"Noida";
            }
        } else {
            NSLog(@"string does not contain bla");
        }
        
        
        
        cell.cityNameLbl.text = stateAndCityNameStr;
        
        cell.cityNameLbl.textColor = [UIColor whiteColor];
        //    cell.frame = CGRectMake(0, 0,self.view.frame.size.width/2-5 , 300);
        cell.cityImageView.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height - 20);
        cell.cityNameLbl.frame = CGRectMake(0, cell.cityImageView.frame.size.height, cell.cityImageView.frame.size.width, 20);
        cell.exporePackages.frame = CGRectMake(cell.cityImageView.frame.size.width - 150, cell.cityNameLbl.frame.size.height + cell.cityNameLbl.frame.origin.y,150 , 30);
        cell.exporePackages.hidden = YES;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
        }else{
            cell.cityNameLbl.font = [UIFont systemFontOfSize:15];
            if ([stateAndCityNameStr containsString:@"Mahabaleshwar"]) {
                stateAndCityNameStr =[[stateAndCityNameStr componentsSeparatedByString:@" "] objectAtIndex:0];
                stateAndCityNameStr = @"Mahabaleshwar";
                cell.cityNameLbl.font = [UIFont systemFontOfSize:13];
            }
        }
        cell.exporePackages.text = @"Explore Packages";
        cell.exporePackages.textColor = [UIColor whiteColor];
        cell.exporePackages.hidden = YES;
        cell.cityNameLbl.backgroundColor =  [self colorWithHexString:@"001d3d"];
        cell.backgroundColor = [self colorWithHexString:@"001d3d"];
        cell.exporePackages.backgroundColor = [self colorWithHexString:@"001d3d"];
        
        
        
      
        
        return cell;
    }
    
    return nil;

   }

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath

{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        NSDictionary *CitylistDictionary;
        if (isFilter == NO) {
            CitylistDictionary = [self.arrayCityList objectAtIndex:indexPath.item];
        }else if (isFilter == YES)
        {
            
            CitylistDictionary = cityNameTableSelectArr;
        }
        CityDetailsViewController *cityDetails = [self.storyboard instantiateViewControllerWithIdentifier:@"CityDetailsViewController"];
        cityDetails.cityNameStr = [ICSingletonManager getStringValue:[CitylistDictionary objectForKey:@"CITY_NAME"]];
        cityDetails.cityDescriptionStr = [ICSingletonManager getStringValue:[CitylistDictionary objectForKey:@"CityCotent"]];
        cityDetails.cityId = [CitylistDictionary objectForKey:@"CITY_ID"];
        [self.navigationController pushViewController:cityDetails animated:YES];
//        NSDictionary *CitylistDictionary;
//        if (isFilter == NO) {
//            CitylistDictionary = [self.arrayCityList objectAtIndex:indexPath.item];
//        }else if (isFilter == YES)
//        {
//
//            CitylistDictionary = cityNameTableSelectArr;
//        }
//
//        //NSLog(@"selected %d row", indexPath.row);
//        CitiesDetailsViewController  *citiesDetails =[self.storyboard instantiateViewControllerWithIdentifier:@"CitiesDetailsViewController"];
//        citiesDetails.cityNameStr = [ICSingletonManager getStringValue:[CitylistDictionary objectForKey:@"CITY_NAME"]];
//        citiesDetails.cityDescriptionStr = [ICSingletonManager getStringValue:[CitylistDictionary objectForKey:@"CityCotent"]];
//        citiesDetails.cityId = [CitylistDictionary objectForKey:@"CITY_ID"];
//
//        [self.navigationController pushViewController:citiesDetails animated:YES];
    }else{
        NSDictionary *CitylistDictionary;
        if (isFilter == NO) {
            CitylistDictionary = [self.arrayCityList objectAtIndex:indexPath.item];
        }else if (isFilter == YES)
        {
            
            CitylistDictionary = cityNameTableSelectArr;
        }
        CityDetailsViewController *cityDetails = [self.storyboard instantiateViewControllerWithIdentifier:@"CityDetailsViewController"];
        cityDetails.cityNameStr = [ICSingletonManager getStringValue:[CitylistDictionary objectForKey:@"CITY_NAME"]];
        cityDetails.cityDescriptionStr = [ICSingletonManager getStringValue:[CitylistDictionary objectForKey:@"CityCotent"]];
        cityDetails.cityId = [CitylistDictionary objectForKey:@"CITY_ID"];
        [self.navigationController pushViewController:cityDetails animated:YES];
        
    }
    
   
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
         return CGSizeMake((self.view.frame.size.width - 20)/3-10, 200);
    }else{
        return CGSizeMake((self.view.frame.size.width - 10)/3-8, 120);
    }
   
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:true];
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"Cities"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [self getCityList];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:true];
    if (IS_IPAD) {
        [self.headingText setFont:[UIFont fontWithName:@"JosefinSans-Light" size:29]];
        [self.headingTitle setFont:[UIFont fontWithName:@"JosefinSans" size:29]];
    }
    else
    {
        [self.headingText setFont:[UIFont fontWithName:@"JosefinSans-Light" size:26]];
        [self.headingTitle setFont:[UIFont fontWithName:@"JosefinSans" size:26]];
    }
    self.headingTitle.text = @"Luxury Hotels";
    self.headingText.text = [NSString stringWithFormat:@"Available in these Cities for\nRs 2,999 (Incl. GST) only"];
    manageAlertTblAddress = 0;
    cityNameTableView.hidden = YES;
    self.searchTextField.text = @"";
    [self.searchTextField resignFirstResponder];
    isFilter = NO;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.cityTableView reloadData];
        
    }else if (UI_USER_INTERFACE_IDIOM() ==  UIUserInterfaceIdiomPad){
        [_collectionView reloadData];
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

#pragma mark - Api Calling Methods


//service to get City List
-(void)getCityList
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    //http://www.icanstay.com/Api/FAQApi/GetCityApi
//    [manager GET:[NSString stringWithFormat:@"http://www.icanstay.com/Api/FAQApi/GetCityApi"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

    [manager GET:[NSString stringWithFormat:@"%@/Api/FAQApi/GetCityApi", kServerUrl] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        self.arrayCityList = responseObject;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
           // [self.cityTableView reloadData];
            
            UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
            _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(5, self.searchTextField.frame.origin.y + self.searchTextField.frame.size.height+10, self.view.frame.size.width - 10, self.view.frame.size.height - (self.searchTextField.frame.origin.y + self.searchTextField.frame.size.height + 10)) collectionViewLayout:layout];
            [_collectionView setDataSource:self];
            [_collectionView setDelegate:self];
            _collectionView.backgroundColor = [UIColor whiteColor];
            
            [_collectionView registerNib:[UINib nibWithNibName:@"CityIpadCollectionViewCell" bundle:[NSBundle mainBundle]]
              forCellWithReuseIdentifier:@"CityIpadCollectionViewCell"];
            
            self.cityTableView.hidden = YES;
            //    _collectionView.backgroundColor = [UIColor whiteColor];
            //            [_collectionView registerClass:[CityIpadCollectionViewCell class] forCellWithReuseIdentifier:@"CityIpadCollectionViewCell"];
            
            [self.view addSubview:_collectionView];
        }else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
            _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(10, self.searchTextField.frame.origin.y + self.searchTextField.frame.size.height+30, self.view.frame.size.width - 20, self.view.frame.size.height - (self.searchTextField.frame.origin.y + self.searchTextField.frame.size.height)) collectionViewLayout:layout];
            [_collectionView setDataSource:self];
            [_collectionView setDelegate:self];
            _collectionView.backgroundColor = [UIColor whiteColor];
           
            [_collectionView registerNib:[UINib nibWithNibName:@"CityIpadCollectionViewCell" bundle:[NSBundle mainBundle]]
                forCellWithReuseIdentifier:@"CityIpadCollectionViewCell"];
            
            self.cityTableView.hidden = YES;
        //    _collectionView.backgroundColor = [UIColor whiteColor];
//            [_collectionView registerClass:[CityIpadCollectionViewCell class] forCellWithReuseIdentifier:@"CityIpadCollectionViewCell"];
            
            [self.view addSubview:_collectionView];
            
        }
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            cityNameTableView.frame =  CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 0.30);
            [_collectionView addSubview:cityNameTableView];
        }else{
            cityNameTableView.frame =  CGRectMake(0, 0, self.view.frame.size.width - 0, self.view.frame.size.height * 0.30);
            [_collectionView addSubview:cityNameTableView];
          //  [self.view addSubview:cityNameTableView];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:error.localizedDescription onController:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}
-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
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
    
    if (theTableView == cityNameTableView) {
         return filteredCityList.count;
    }else{
        if (isFilter)
        {
            return 1;
        }
        else
        {
            return self.arrayCityList.count;
        }
    }
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == cityNameTableView) {
        return 60;
    }else{
        if (IS_IPAD) {
            return 500;
        }
        else
            return 300;
    }
   
}

// the cell will be returned to the tableView
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (theTableView == cityNameTableView) {
        static NSString *cellIdentifier = @"cellID";
        NSDictionary *CitylistDictionary;
         CitylistDictionary = [self.filteredCityList objectAtIndex:indexPath.row];
        
        UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:
                                 cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:
                    UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        [cell.textLabel setText:[ICSingletonManager getStringValue:[CitylistDictionary objectForKey:@"CITY_NAME"]]];
        return cell;
    }else{
        static NSString *cellIdentifier = @"citylistCell";
        //Storing dictionary value from array at index
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
        
        CitiesTableViewCell *cell = (CitiesTableViewCell *)[theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[CitiesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        cell.cityName.text = [ICSingletonManager getStringValue:[CitylistDictionary objectForKey:@"CITY_NAME"]];
        cell.exploreHotels.hidden = YES;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //https://1573322668.rsc.cdn77.org/images/cities/
        
        //    NSString * userImage =@"https://1790472363.rsc.cdn77.org/images/cities/";
        //    userImage = [userImage stringByAppendingString:[ICSingletonManager getStringValue:[CitylistDictionary objectForKey:@"CityImage"]]];
        //userImage = [self getURLFromString:[userImage stringByAppendingString:[ICSingletonManager getStringValue:[userData objectForKey:kDriverProfileImage]]]];
        [cell.cityImage setImageWithURL:[NSURL URLWithString:[CitylistDictionary objectForKey:@"CityImage"]] placeholderImage:[UIImage imageNamed:@"photo_frame"]];
        //[cell.cityImage set];
        //cell.cityImage.image = [UIImage imageNamed:@"b1"];
        return cell;

    }
   }

#pragma mark - UITableViewDelegate

// when user tap the row, what action you want to perform
- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *CitylistDictionary;
    if (theTableView == cityNameTableView) {
        isFilter = YES;
        cityNameTableSelectArr = [self.filteredCityList objectAtIndex:indexPath.row];
        selectCellCityNameTable = 1;
        self.searchTextField.text = [ICSingletonManager getStringValue:[cityNameTableSelectArr objectForKey:@"CITY_NAME"]];
        [_collectionView reloadData];
        reloadCollectionViewWhenTblViewCitySelect = 1;
//        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
//             [self.cityTableView reloadData];
//        }else{
//            [_collectionView reloadData];
//             reloadCollectionViewWhenTblViewCitySelect = 1;
//        }
      
        cityNameTableView.hidden = YES;
        [self.searchTextField resignFirstResponder];
        
        
    }else{
        
        if (isFilter == NO) {
             CitylistDictionary = [self.arrayCityList objectAtIndex:indexPath.row];
        }else if (isFilter == YES)
        {
           
            CitylistDictionary = cityNameTableSelectArr;
        }
       
        //NSLog(@"selected %d row", indexPath.row);
        CitiesDetailsViewController  *citiesDetails =[self.storyboard instantiateViewControllerWithIdentifier:@"CitiesDetailsViewController"];
        citiesDetails.cityNameStr = [ICSingletonManager getStringValue:[CitylistDictionary objectForKey:@"CITY_NAME"]];
        citiesDetails.cityDescriptionStr = [ICSingletonManager getStringValue:[CitylistDictionary objectForKey:@"CityCotent"]];
        citiesDetails.cityId = [CitylistDictionary objectForKey:@"CITY_ID"];
        
        [self.navigationController pushViewController:citiesDetails animated:YES];
    }
    
}

#pragma mark -  UISearchBar Delegate

//- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
//{
//    NSPredicate *titlePredicate = [NSPredicate predicateWithFormat:@"CITY_NAME contains[c] %@ ", searchText];
//    
//    filteredCityList = [NSMutableArray arrayWithArray:[arrayCityList filteredArrayUsingPredicate:titlePredicate]];
//    NSLog(@"searchResult %@",filteredCityList);
//    
//}
//
//-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
//{
//    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
//    
//    return YES;
//}
#pragma mark - Search Methods

-(void)textFieldDidChange:(UITextField*)textField
{
    searchTextString = textField.text;
    
    if (reloadCollectionViewWhenTblViewCitySelect == 1) {
        isFilter = NO;
        [_collectionView reloadData];
        reloadCollectionViewWhenTblViewCitySelect = 0;
        _searchTextField.text = @"";
        [_searchTextField resignFirstResponder];
      //  isFilter = YES;
    }else{
         [self updateSearchArray];
    }
   
}
//update seach method where the textfield acts as seach bar
-(void)updateSearchArray
{
    if (searchTextString.length != 0)
    {
         isFilter = YES;
        NSPredicate *titlePredicate = [NSPredicate predicateWithFormat:@"CITY_NAME contains[c] %@ ", searchTextString];
        
        filteredCityList = [NSMutableArray arrayWithArray:[arrayCityList filteredArrayUsingPredicate:titlePredicate]];
        NSLog(@"searchResult %@",filteredCityList);
         cityNameTableView.hidden = NO;
        
        if ([filteredCityList count] == 0  && manageAlertTblAddress == 0) {
            
            cityNameTableView.hidden = YES;
            
            
            manageAlertTblAddress = 1;
            self.searchTextField.text = @"";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Sorry, No result found."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }else{
            manageAlertTblAddress = 0;
            isFilter = NO;
//            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
//                 [self.cityTableView reloadData];
//            }else{
//                
//            }
         
        }
    }else{
         isFilter=NO;
        filteredCityList = self.arrayCityList;
    }
    
    [cityNameTableView reloadData];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UISearchResultsUpdating

//-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
//    
//    NSString *searchString = [self.searchController.searchBar text];
//    if (![searchString isEqualToString:@""])
//    {
//        NSPredicate *titlePredicate = [NSPredicate predicateWithFormat:@"CITY_NAME contains[c] %@ ", searchString];
//        
//        filteredCityList = [NSMutableArray arrayWithArray:[arrayCityList filteredArrayUsingPredicate:titlePredicate]];
//        NSLog(@"searchResult %@",filteredCityList);
//        [self.cityTableView reloadData];
//    }else{
//        
//        filteredCityList = self.arrayCityList;
//        [self.cityTableView reloadData];
//    }
//}
//
//#pragma mark - UISearchBarDelegate
//
//// Workaround for bug: -updateSearchResultsForSearchController: is not called when scope buttons change
//- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
//{
//    [self updateSearchResultsForSearchController:self.searchController];
//}

-(NSString *)getURLFromString:(NSString *)str{
    
    NSString *urlStr = [str stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    return urlStr;
}

- (IBAction)btnMenuTapped:(id)sender {
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    
       if ([globals.isFromDeepLinkToViewhotelsScreen isEqualToString:@"YES"]) {
        globals.isFromDeepLinkToViewhotelsScreen = @"NO";
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
        
    }else if (globals.isFromMenu)
    {
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
