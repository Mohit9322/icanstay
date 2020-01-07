//
//  MapScreen.m
//  ICanStay
//
//  Created by Vertical Logics on 08/03/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import "MapScreen.h"
@import CoreLocation;
#import <GoogleMaps/GoogleMaps.h>
//#import "GMSPlacesClient.h"
#import <math.h>
#import <MapKit/MapKit.h>
#import "MBProgressHUD.h"
#import <AFNetworking.h>
#import "TGPDiscreteSlider.h"
#import "TGPCamelLabels.h"
#import "LoginManager.h"
#import "RedeemCouponCell.h"

#import "CouponList.h"
#import "CurrentStayScreen.h"
#import "NSDictionary+JsonString.h"
#import <QuartzCore/QuartzCore.h>
#import "LoginScreen.h"
#import "BuyCouponViewController.h"
#import <CCMPopup/CCMPopupTransitioning.h>
#import "NewCouponData.h"
#import <MoEngage.h>
#import "SideMenuController.h"
#import "HomeScreenController.h"


#define kTagCellCouponCode          1287
#define kTagCellStartAndEndDate     1289
#define kTagCellCheckboxBtn         1288
@interface MapScreen()<CLLocationManagerDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,TGPControlsTicksProtocol,GMSMapViewDelegate,RedeemCouponCellDelegate,CLLocationManagerDelegate, MOInAppDelegate>
{
    CLLocationManager *locationManager;
    CLGeocoder    *geocoder;
    CLPlacemark *placemark;
    GMSCircle *circ;
       CLLocationCoordinate2D curCoordinate;
    CGFloat curZoom;
    CGFloat radius;
    BOOL isByCitySearch;
    int isSliderMapChange;
    UIViewController *redeemVoucherListVc;
    UITableView *redeemVoucherListTblView;
    int          sliderVaue;
    UISlider    *slider;
    int         tempSliderValue;
    int         manageAlertTblAddress;
    NSMutableArray      *redeemListDatasource;
    int              bycityCircleManageFirstTime;
    NSMutableArray   *currentByLocationRoomCountArr;
    
}
@property (weak, nonatomic) IBOutlet UIButton *reedeemBtn;
@property (weak, nonatomic) IBOutlet UIView *viewContainerSlider;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *TxtVwTrailing;
@property (strong, nonatomic) IBOutlet UITableView *areaTblVw;
- (IBAction)areaDropDpwnClk:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *AreaVw;
@property (strong, nonatomic) IBOutlet UILabel *areaLbl;
@property (strong, nonatomic) IBOutlet UIButton *areaDropBtn;
@property (strong, nonatomic) IBOutlet UILabel *distInKmLbl;
@property (strong, nonatomic) IBOutlet UIImageView *icsLogoImgView;

@property (weak, nonatomic) IBOutlet UIView *viewMap;
@property (nonatomic) GMSMapView* mapView;

@property (weak, nonatomic) IBOutlet UITextField *txtEnterAddress;
@property (weak, nonatomic) IBOutlet UITableView *tblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblRoomsAvailable;
- (IBAction)segmentedControlTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *dayTblVw;
@property (strong, nonatomic) IBOutlet UITableView *searchforTblVw;
@property (strong, nonatomic) IBOutlet UIButton *searchforBtn;
- (IBAction)searchforBtnClk:(id)sender;



@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

//SLIDER IMPLEMENT CONTROLS
@property (weak, nonatomic) IBOutlet TGPDiscreteSlider *slider;
@property (strong, nonatomic) IBOutlet TGPCamelLabels *camelLabels;

@property (weak, nonatomic) IBOutlet TGPCamelLabels *camelLabelsForRoom;

@property (weak, nonatomic) IBOutlet TGPDiscreteSlider *sliderForRooms;

- (IBAction)btnCacelTapped:(id)sender;

@property (nonatomic)NSMutableArray *arrPlaceApiAddresses;
@property (nonatomic)NSMutableArray *autocompAdressArray;
@property (nonatomic)NSMutableArray *areaArray;
@property (nonatomic)NSMutableArray *searchForArray;
@property (nonatomic)NSMutableArray *dayArray;
@property (weak, nonatomic) IBOutlet UIView *viewBottom;

@property double currentLatitude;
@property double currentLongitude;

- (IBAction)btnMenuTapped:(id)sender;

@property (nonatomic)NSMutableArray *arrHotels;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingSpaceToSliderRoom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingSpaceToCameLabelRoom;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *equalWidthToSliderEoom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *equalWidthToCamelLabelRoom;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthOfSlider;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthOfCamelLabel;

@property (weak, nonatomic) IBOutlet UILabel *lblNoOfRooms;
- (IBAction)btnDateTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnBookNow;

@property NSInteger numOfRequiredRooms;
@property (nonatomic,copy)NSString *strFamilyStay;
@property (nonatomic, copy) NSString *ZoneId;
@property (nonatomic, copy) NSString *CityId;

@property (weak, nonatomic) IBOutlet UIView *viewDatePicker;

- (IBAction)pickerValueChanged:(id)sender;

- (IBAction)btnCancelTapped:(id)sender;
- (IBAction)btnDoneTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnBookingDate;

- (IBAction)btnRedeemTapped:(id)sender;




@property (weak, nonatomic) IBOutlet UITableView *tblRedeemCoupons;
@property (weak, nonatomic) IBOutlet UIView *viewRedeemCoupon;
@property (weak, nonatomic) IBOutlet UIView *viewBlackPopUp;
- (IBAction)btnCancelreddemViewTapped:(id)sender;

@property (nonatomic) CouponList *couponList;

@property (nonatomic)NSMutableArray *arrCouponId;

@property BOOL isFirstTimeLocationFetched;

//*************************
- (IBAction)btnCancelTappedInViewBuyCoupon:(id)sender;

- (IBAction)btnBuyNowTappedForCoupons:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewBuyCoupons;
@property (weak, nonatomic) IBOutlet UILabel *lblBuyCouponText;
//*************************

@property BOOL txtFldClear;

@end

@implementation MapScreen
@synthesize isByCurrentLocation;
- (void)viewDidLoad {
    
    redeemListDatasource = [[NSMutableArray alloc]init];
     [super viewDidLoad];
     DLog(@"DEBUG-VC");
    isSliderMapChange = 0;
   
    [[MoEngage sharedInstance]handleInAppMessage];
    [MoEngage sharedInstance].delegate = self;
    [[MoEngage sharedInstance] dontShowInAppInViewController:self];
//    [[self.AreaVw layer] setBorderWidth:2.0f];
//    [[self.AreaVw layer] setBorderColor:[UIColor lightGrayColor].CGColor];

    // Do any additional setup after loading the view.
    self.arrPlaceApiAddresses = [[NSMutableArray alloc]init];
    self.autocompAdressArray= [[NSMutableArray alloc]init];
    self.areaArray=[[NSMutableArray alloc]init];
    self.searchForArray=[[NSMutableArray alloc]init];
    self.dayArray=[[NSMutableArray alloc]init];
    
    self.arrHotels = [[NSMutableArray alloc]init];
    self.isFirstTimeLocationFetched = YES;
 //   [self addDiscreteSlider];
 //   [self addDiscreteSliderForRooms];
    
//    [self.btnBookingDate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    self.btnBookingDate.layer.borderWidth=0.5f;
//    self.btnBookingDate.layer.borderColor=[[UIColor lightGrayColor] CGColor];
//    self.btnBookingDate.layer.cornerRadius = 2;
//    self.btnBookingDate.layer.masksToBounds = YES;
    self.lblRoomsAvailable.layer.borderColor = [UIColor redColor].CGColor;
    self.lblRoomsAvailable.layer.borderWidth = 5.0;
    
    if (isByCurrentLocation) {
        [self.lblRoomsAvailable setHidden:NO];
        _slider.hidden = YES;
        sliderVaue = 0;
        currentByLocationRoomCountArr = [[NSMutableArray alloc]init];
        _txtEnterAddress.placeholder = @"Enter your location";
       
        _camelLabels.hidden = YES;
        _camelLabelsForRoom.hidden = YES;
        _sliderForRooms.hidden = YES;
        [self.btnBookingDate setTitle:@"Today" forState:UIControlStateNormal];
         [self addSliderToViewSliderContainer];
        
        
    }
    else
    {
        [self.lblRoomsAvailable setHidden:YES];
        _txtEnterAddress.placeholder = @"Enter Your City";
    }
    
  //  [self.btnBookingDate setTitle:[self gettingFormattedDateFromDate:[NSDate date]] forState:UIControlStateNormal];
    self.strFamilyStay = @"N";
    [self.datePicker setMinimumDate:[NSDate date]];
    
    NSDateComponents *dateComponents = [NSDateComponents new];
    dateComponents.year = 1;
    NSDate *endDate = [[NSCalendar currentCalendar]dateByAddingComponents:dateComponents
                                                                   toDate: [NSDate date]
                                                                  options:0];
    [self.datePicker setMaximumDate:endDate];

    
    // Enabling Family Stay On
    [self.equalWidthToCamelLabelRoom setConstant:[UIScreen mainScreen].bounds.size.width/2];
    [self.equalWidthToSliderEoom setConstant:[UIScreen mainScreen].bounds.size.width/2];
    [self.sliderForRooms setHidden:YES];
    [self.camelLabelsForRoom setHidden:YES];
    [self.lblNoOfRooms setHidden:YES];
    
    self.numOfRequiredRooms = 1;
    
    [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:@"ZoneId"];
    [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:@"CityId"];
    
    _txtFldClear = false;
    
    _areaTblVw.scrollEnabled = NO;
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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
   
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    if ([[[UIDevice currentDevice] systemVersion] integerValue]<7.0) {
        return UIInterfaceOrientationLandscapeRight|UIInterfaceOrientationLandscapeLeft;
    }else{
        return UIInterfaceOrientationPortrait;
    }
}
-(BOOL) shouldAutorotate {
    
    return NO;
}
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    
    if ([[[UIDevice currentDevice] systemVersion] integerValue]<7.0) {
        return UIInterfaceOrientationLandscapeRight|UIInterfaceOrientationLandscapeLeft;
        return YES;
    }else{
        return UIInterfaceOrientationPortrait;
    }
    
    return NO;
}
-(void)addSliderToViewSliderContainer
{
    
    // sliderAction will respond to the updated slider value
    slider = [[UISlider alloc] initWithFrame:CGRectMake(20, 20, self.view.frame.size.width - 40, 20)];
    slider.minimumValue = 2.0;
    slider.maximumValue = 20.0;
    slider.continuous = NO;
    
    
    // Initial value
    slider.value = 2.0;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTapped:)];
    [slider addGestureRecognizer:tapGestureRecognizer];
    
    [slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    [self.viewContainerSlider addSubview:slider];
    
    
    int numberOfTicks = 11;
    
    CGFloat labelSpacing = slider.frame.size.width/(numberOfTicks -1);
    CGFloat xPosition = slider.frame.origin.x;
 //   CGFloat labelWidth = 20;
    CGFloat yPosition = CGRectGetMinY(slider.frame)-20;
    
    for (int i=1;i<numberOfTicks;i++){
        CGRect labelFrame = CGRectMake(xPosition, (yPosition), labelSpacing, 20);
        
        UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
        //    label.backgroundColor = [UIColor redColor];
    //    label.adjustsFontSizeToFitWidth = YES;
       label.text = [NSString stringWithFormat:@"%i",i*2];
//        if (i > 4) {
//            label.font = [UIFont systemFontOfSize:14];
//        }
        label.font = [UIFont systemFontOfSize:14];
        [self.viewContainerSlider addSubview:label];
  //0      label.backgroundColor = [UIColor redColor];
        label.textAlignment = NSTextAlignmentCenter;
        
        xPosition += labelSpacing;
        
    }
    
    NSLog(@"Slider.Value is:-%f ,sliderValue is :-%d, templSliderValue is:- %d",slider.value , sliderVaue, tempSliderValue);

}

- (void)sliderTapped:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint  pointTaped = [gestureRecognizer locationInView:gestureRecognizer.view];
     float widthOfSlider = slider.frame.size.width;
    float newValue = ((pointTaped.x ) * slider.maximumValue) / widthOfSlider;
    
    tempSliderValue = (int)roundf (newValue);
        sliderVaue = (int)roundf ((tempSliderValue -1)/2);
    NSLog(@"Slider.Value is:-%f ,sliderValue is :-%d, templSliderValue is:- %d",slider.value , sliderVaue, tempSliderValue);
    [slider setValue:tempSliderValue];
     [self sliderValueChanged];
   }
- (void)sliderAction:(id)sender{
    UISlider *MYslider = (UISlider *)sender;
    tempSliderValue = (int)roundf(MYslider.value);
    
    sliderVaue = (int)roundf ((tempSliderValue -1)/2);
    NSLog(@"Slider.Value is:-%f ,sliderValue is :-%d, templSliderValue is:- %d",slider.value , sliderVaue, tempSliderValue);
    [slider setValue:tempSliderValue];
    [self sliderValueChanged];
    
    
}

-(void)sliderValueChanged
{
   
    radius= (sliderVaue +1)*2000;
     NSLog(@"Slider.Value is:-%f ,sliderValue is :-%d, templSliderValue is:- %d",slider.value , sliderVaue, tempSliderValue);
    [self setRadius:radius withCoordinate:self.mapView.camera.target InMapView:self.mapView];
    CLLocationCoordinate2D tempCoordE;
    tempCoordE.latitude = self.currentLatitude;
    tempCoordE.longitude = self.currentLongitude;
    
    self.mapView.camera=[GMSCameraPosition cameraWithTarget:tempCoordE zoom:curZoom];
    circ.radius=radius;
    //    [self addMarkerInLocationWithCoordinateLatitude:tempCoordE.latitude andLongitude:tempCoordE.longitude];
    //    [self addCircleToCordinateLatitude:tempCoordE.latitude andLongitude:tempCoordE.longitude withRadius:radius];
    //
    [self startServiceToGetHotelsListFromLocationfromLat:[NSNumber numberWithDouble:tempCoordE.latitude] andLongitude:[NSNumber numberWithDouble:tempCoordE.longitude]];
    //    [self CurrentLocationApiOnSliderValueChange];
 //   [self checkNumberOfRommsAvailableOrNot];

}




#pragma mark iOS 6 Orientation Support


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
  

   
    [self.areaTblVw setHidden: YES];
    [self.dayTblVw setHidden:YES];
    [self.searchforTblVw setHidden:YES];
    [self.btnBookNow setHidden:YES];
    [self.lblRoomsAvailable setHidden: YES];
    
    if (isByCurrentLocation)
    {
        [self.viewBottom setHidden:NO];
    //    self.viewBottom.frame = CGRectMake(self.viewBottom.frame.origin.x, self.viewBottom.frame.origin.y + 20, self.viewBottom.frame.size.width, self.viewBottom.frame.size.height);
        self.viewBottom.backgroundColor = [UIColor clearColor];
    //    [self.slider setHidden:NO];
     //   [self.camelLabels setHidden:NO];
         [self.distInKmLbl setHidden:NO];
        [self.btnBookNow setHidden:YES];
        [self.lblRoomsAvailable setHidden:NO];
        [slider setValue:2.0];
        sliderVaue = 0;
    }
    else
    {
        bycityCircleManageFirstTime = 1;
        [self.viewBottom setHidden:YES];
        [self.slider setHidden:YES];
        [self.camelLabels setHidden:YES];
        [self.distInKmLbl setHidden:YES];
        manageAlertTblAddress = 0;
    }

   
    
    if (IS_IPAD) {
        
        [self.txtEnterAddress setFont:[UIFont fontWithName:@"JosefinSans-BoldItalic" size:24]];
        self.btnBookingDate.titleLabel.font =[UIFont fontWithName:@"JosefinSans-BoldItalic" size:18];
        self.searchforBtn.titleLabel.font =[UIFont fontWithName:@"JosefinSans-BoldItalic" size:18];
    }
    else
    {
        [self.txtEnterAddress setFont:[UIFont fontWithName:@"JosefinSans-BoldItalic" size:18]];
        self.btnBookingDate.titleLabel.font =[UIFont fontWithName:@"JosefinSans-BoldItalic" size:15];
        self.searchforBtn.titleLabel.font =[UIFont fontWithName:@"JosefinSans-BoldItalic" size:15];
        
        
    }

    [self initializeCorLocationInstance];
    
    self.view.userInteractionEnabled = YES;
    if (isByCurrentLocation) {
        [self.lblRoomsAvailable setHidden:NO];
        [self.viewContainerSlider setHidden:NO];
    }
    else
    {
        [self.lblRoomsAvailable setHidden:YES];
        [self.viewContainerSlider setHidden:YES];
    }
    _tblRedeemCoupons.frame = CGRectMake(self.view.frame.size.width*0.15, _tblRedeemCoupons.frame.origin.y, self.view.frame.size.width *0.7, _tblRedeemCoupons.frame.size.height *0.6);
    _reedeemBtn.frame = CGRectMake((_viewRedeemCoupon.frame.size.width - _reedeemBtn.frame.size.width )/2,_reedeemBtn.frame.origin.y , _reedeemBtn.frame.size.width, _reedeemBtn.frame.size.height);
   
    ICSingletonManager *globals = [ICSingletonManager sharedManager];

    if (globals.isFromBuyVocherToMapScreen) {
        _btnBookNow.hidden = YES;
        self.viewBuyCoupons.hidden = YES;
        self.txtEnterAddress.text = @"";
        self.AreaVw.hidden = YES;
        globals.isFromBuyVocherToMapScreen = false;
    }
    
    if ([self.isFromPurchasedVooucherScreen isEqualToString:@"YES"]) {
        self.isFromPurchasedVooucherScreen = @"NO";
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                                 message:self.alertMasgFromPurchasedVoucher
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            
        }];
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
    }

}
-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event //here enable the touch
{
    [self.tblAddress setHidden:YES];
    [self.areaTblVw setHidden:YES];
    [self.searchforTblVw setHidden:YES];
    [self.dayTblVw setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UISlider Implementing Methods

- (void)addDiscreteSliderForRooms
{
    self.camelLabelsForRoom.names     = @[@"2",@"3",@"4"];
    self.sliderForRooms.ticksListener = self.camelLabelsForRoom;
    self.sliderForRooms.minimumValue  = 0;
    self.sliderForRooms.tickCount     = 3;
    [self.sliderForRooms addTarget:self action:@selector(discreteRoomSliderValueChanged:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)discreteRoomSliderValueChanged:(TGPDiscreteSlider *)sender {
     [self.camelLabelsForRoom setValue:sender.value];
     int tag=sender.value+2;
     self.numOfRequiredRooms = tag;
}

- (void)addDiscreteSlider
{
    self.camelLabels.names = @[@"2",@"4",@"6",@"8",@"10",@"12",@"14",@"16",@"18",@"20"];
    self.camelLabels.downFontColor = [UIColor blueColor];
    self.slider.ticksListener =self.camelLabels;
    self.slider.minimumValue = 0;
    self.slider.tickCount =10;
   
    [self.slider addTarget:self action:@selector(discreteSliderValueChanged:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)discreteSliderValueChanged:(TGPDiscreteSlider *)sender
{
    [self.camelLabels setValue:sender.value];
  //  sliderValue =sender.value+1;
   // radius= sliderValue*2000;
    [self setRadius:radius withCoordinate:self.mapView.camera.target InMapView:self.mapView];
     CLLocationCoordinate2D tempCoordE;
    tempCoordE.latitude = self.currentLatitude;
    tempCoordE.longitude = self.currentLongitude;
    
    self.mapView.camera=[GMSCameraPosition cameraWithTarget:tempCoordE zoom:curZoom];
    circ.radius=radius;
//    [self addMarkerInLocationWithCoordinateLatitude:tempCoordE.latitude andLongitude:tempCoordE.longitude];
//    [self addCircleToCordinateLatitude:tempCoordE.latitude andLongitude:tempCoordE.longitude withRadius:radius];
//    
    [self startServiceToGetHotelsListFromLocationfromLat:[NSNumber numberWithDouble:tempCoordE.latitude] andLongitude:[NSNumber numberWithDouble:tempCoordE.longitude]];
//    [self CurrentLocationApiOnSliderValueChange];
    
    
}


- (void)tgpTicksDistanceChanged:(CGFloat)ticksDistance sender:(id)sender{
//    NSLog(@"ticksDistance%f",ticksDistance);
    NSLog(@"sender%@",sender);
}

- (void)tgpValueChanged:(unsigned int)value{
    NSLog(@"value%i",value);
}



-(void)ZoominOutMap:(CGFloat)level withCircleRadius:(int)radius
{
    GMSCameraPosition* camera = [GMSCameraPosition cameraWithLatitude:self.currentLatitude
                                                            longitude:self.currentLongitude
                                                                 zoom:level];
    self.mapView.camera = camera;
    
    

    NSNumber *numHotels = [self.arrHotels objectAtIndex:self.camelLabels.value];
    NSLog(@"%@",numHotels);
    if ([numHotels intValue] != 0 ) {
        [self.lblRoomsAvailable setText:@"Rooms are available"];
        circ.fillColor = [UIColor colorWithRed:0 green:1.0 blue:0 alpha:0.07];
        circ.strokeColor = [UIColor greenColor];
    }
    else{
        [self.lblRoomsAvailable setText:@"Rooms are not available"];
        circ.fillColor = [UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.07];
        circ.strokeColor = [UIColor redColor];
    }



}



#pragma mark - Class Function
-(void)setRadius:(CGFloat)rad withCoordinate:(CLLocationCoordinate2D)city InMapView:(GMSMapView*)mapView
{
    CLLocationCoordinate2D range=[self translateCoordinate:city withLat:rad*2 andLong:rad*2];
    GMSCoordinateBounds *bounds=[[GMSCoordinateBounds alloc]initWithCoordinate:city coordinate:range];
    
    GMSCameraUpdate *update=[GMSCameraUpdate fitBounds:bounds withPadding:10];
    [mapView moveCamera:update];
    CGFloat zoom=mapView.camera.zoom;
    curZoom=zoom;
}


-(CLLocationCoordinate2D)translateCoordinate:(CLLocationCoordinate2D)coordinate withLat:(CGFloat)metersLat andLong:(CGFloat)metersLag
{


    MKCoordinateRegion tempRegion=MKCoordinateRegionMakeWithDistance(coordinate, metersLat, metersLag);
    MKCoordinateSpan tempSpan=tempRegion.span;
    CLLocationCoordinate2D tempCoord;
    tempCoord.latitude = coordinate.latitude + tempSpan.latitudeDelta;
    tempCoord.longitude = coordinate.longitude + tempSpan.longitudeDelta;
    if (self.isByCurrentLocation) {
   //     curCoordinate.latitude = tempCoord.latitude;
    //    curCoordinate.longitude = tempCoord.longitude;
    }else if (self.isByCity)
    {
       // curCoordinate.latitude = tempCoord.latitude;
       // curCoordinate.longitude = tempCoord.longitude;
    }
   
    return tempCoord;
}

#pragma Mark - CLLocationManager Delegate Methods
- (void)initializeCorLocationInstance
{
    curZoom=14.386331558227539;
    if (IS_IPHONE_5) {
        curZoom = 13.324380149841309;
    }
    else if (IS_IPHONE_6){
        //curZoom=14.386331558227539;
        curZoom= 13.377236175537109;
    }
    else if (IS_IPHONE_6_PLUS)
    {
     // curZoom=  14.556772232055664;
        curZoom = 13.57612495422363;
    }
    else if (IS_IPAD){
          curZoom = 14.419;
    }
    
   
  
     radius = 2000;
    //initializing CoreLocation Manager object
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if (IS_OS_8_OR_LATER)[locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
    

    
    curCoordinate.latitude = self.currentLatitude;
    curCoordinate.longitude = self.currentLongitude;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithTarget:CLLocationCoordinate2DMake(curCoordinate.latitude, curCoordinate.latitude) zoom: curZoom];
    
    self.mapView= [GMSMapView mapWithFrame:self.viewMap.bounds camera:camera];
    self.mapView.camera = camera;
    self.mapView.delegate=self;
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.myLocationButton = YES;
    [self.viewMap addSubview:self.mapView];
   
}



//- (void)focusMapToShowAllMarkersWithMArker:(GMSMarker *)marker
//{
//    
//    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] init];
//    
//    //for (GMSMarker *marker in <An array of your markers>)
//        bounds = [bounds includingCoordinate:marker.position];
//    
//    [self.mapView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withPadding:100.0f]];
//    
//    
//}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //    NSLog(@"didFailWithError: %@", error);
    //    UIAlertView *errorAlert = [[UIAlertView alloc]
    //                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //    [errorAlert show];
    //
    [locationManager stopUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
   // NSString *strlatitude =nil;
    //NSString *strlongitude = nil;
   [locationManager stopUpdatingLocation];
  
//    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    
//        if (self.isFirstTimeLocationFetched)
//    {
//        self.isFirstTimeLocationFetched = false;
//
    if (self.isByCity) {
        
        NSLog(@"didUpdateToLocation: %@", newLocation);
        CLLocation *currentLocation = newLocation;
        
        if (currentLocation != nil)
        {
            self.currentLatitude = newLocation.coordinate.latitude;
            self.currentLongitude = newLocation.coordinate.longitude;
            
            if (isByCurrentLocation)
            {
                [self addMarkerInLocationWithCoordinateLatitude:self.currentLatitude andLongitude:self.currentLongitude];
                [self addCircleToCordinateLatitude:self.currentLatitude andLongitude:self.currentLongitude withRadius:radius];
                
                [self startServiceToGetHotelsListFromLocationfromLat:[NSNumber numberWithDouble:self.currentLatitude] andLongitude:[NSNumber numberWithDouble:self.currentLongitude]];
            }else{
                
                if (bycityCircleManageFirstTime == 1) {
                    [self addCircleToCordinateLatitude:self.currentLatitude andLongitude:self.currentLongitude withRadius:radius];
                    bycityCircleManageFirstTime = 0;
                }
                
            }
            [self.mapView animateToLocation:newLocation.coordinate];
            
            [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
                NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
                if (error == nil && [placemarks count] > 0) {
                    placemark = [placemarks lastObject];
                    
                    NSString *namePlacemark = placemark.name;
                    NSDictionary *addressDict = placemark.addressDictionary;
                    
                    NSString *countryCode = placemark.ISOcountryCode;
                    NSString *country = placemark.country;
                    NSString *postalCode = placemark.postalCode;
                    NSString *adminArea = placemark.administrativeArea;
                    NSString *adminSubArea = placemark.subAdministrativeArea;
                    NSString *locality = placemark.locality;
                    NSString *subLocality  = placemark.subLocality;
                    NSString *troughFare = placemark.thoroughfare;
                    NSString *subThroughFare =placemark.subThoroughfare;
                    CLRegion *region = placemark.region;
                    NSTimeZone *timeZone = placemark.timeZone;
                    
                    
                    NSMutableString *addresstext = [NSMutableString string];
                    
                    
                    if (placemark.subThoroughfare) {
                        
                        [addresstext appendString:placemark.subThoroughfare];
                    }
                    
                    if (placemark.thoroughfare) {
                        if (addresstext.length) {
                            [addresstext appendString:@", "];
                        }
                        [addresstext appendString:placemark.thoroughfare];
                    }
                    if (placemark.subLocality) {
                        if (addresstext.length) {
                            [addresstext appendString:@", "];
                        }
                        [addresstext appendString:placemark.subLocality];
                    }
                    if (placemark.postalCode) {
                        if (addresstext.length) {
                            [addresstext appendString:@", "];
                        }
                        [addresstext appendString:placemark.postalCode];
                    }
                    if (placemark.locality) {
                        if (addresstext.length) {
                            [addresstext appendString:@", "];
                        }
                        [addresstext appendString:placemark.locality];
                    }
                    
                    if (placemark.subAdministrativeArea) {
                        if (addresstext.length) {
                            [addresstext appendString:@", "];
                        }
                        [addresstext appendString:placemark.subAdministrativeArea];
                    }
                    
                    
                    if (placemark.country) {
                        
                        if (addresstext.length) {
                            [addresstext appendString:@", "];
                        }
                        [addresstext appendString:placemark.country];
                    }
                    
                    
                    
                    
                    
                    
                    
                    
                    if (isByCurrentLocation) {
                        if(!((addresstext==NULL)||[addresstext isEqualToString:@"null"]||[addresstext isEqualToString:@"Null"]||(addresstext==nil)||(addresstext==Nil)||[addresstext isEqualToString:@"<null>"]))
                        {
                            [self.txtEnterAddress setText:addresstext];
                        }
                        
                    }else{
                       // self.txtEnterAddress.placeholder = @"Enter City";
                    }
                    
                    
                    
                    
                } else {
                    NSLog(@"%@", error.debugDescription);
                }
            } ];
        }
}else if (self.isByCurrentLocation){
        if (self.isFirstTimeLocationFetched)
               {
                    self.isFirstTimeLocationFetched = false;
                   NSLog(@"didUpdateToLocation: %@", newLocation);
                   CLLocation *currentLocation = newLocation;
                   
                   if (currentLocation != nil)
                   {
                       self.currentLatitude = newLocation.coordinate.latitude;
                       self.currentLongitude = newLocation.coordinate.longitude;
                       
                       if (isByCurrentLocation)
                       {
                           [self addMarkerInLocationWithCoordinateLatitude:self.currentLatitude andLongitude:self.currentLongitude];
                           [self addCircleToCordinateLatitude:self.currentLatitude andLongitude:self.currentLongitude withRadius:radius];
                           
                           [self startServiceToGetHotelsListFromLocationfromLat:[NSNumber numberWithDouble:self.currentLatitude] andLongitude:[NSNumber numberWithDouble:self.currentLongitude]];
                       }else{
                           [self addCircleToCordinateLatitude:self.currentLatitude andLongitude:self.currentLongitude withRadius:radius];
                       }
                       [self.mapView animateToLocation:newLocation.coordinate];
                       
                       [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
                           NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
                           if (error == nil && [placemarks count] > 0) {
                               placemark = [placemarks lastObject];
                               
                               NSString *namePlacemark = placemark.name;
                               NSDictionary *addressDict = placemark.addressDictionary;
                               
                               NSString *countryCode = placemark.ISOcountryCode;
                               NSString *country = placemark.country;
                               NSString *postalCode = placemark.postalCode;
                               NSString *adminArea = placemark.administrativeArea;
                               NSString *adminSubArea = placemark.subAdministrativeArea;
                               NSString *locality = placemark.locality;
                               NSString *subLocality  = placemark.subLocality;
                               NSString *troughFare = placemark.thoroughfare;
                               NSString *subThroughFare =placemark.subThoroughfare;
                               CLRegion *region = placemark.region;
                               NSTimeZone *timeZone = placemark.timeZone;
                               
                               
                               NSMutableString *addresstext = [NSMutableString string];
                               
                               
                               if (placemark.subThoroughfare) {
                                   
                                   [addresstext appendString:placemark.subThoroughfare];
                               }
                               
                               if (placemark.thoroughfare) {
                                   if (addresstext.length) {
                                       [addresstext appendString:@", "];
                                   }
                                   [addresstext appendString:placemark.thoroughfare];
                               }
                               if (placemark.subLocality) {
                                   if (addresstext.length) {
                                       [addresstext appendString:@", "];
                                   }
                                   [addresstext appendString:placemark.subLocality];
                               }
                               if (placemark.postalCode) {
                                   if (addresstext.length) {
                                       [addresstext appendString:@", "];
                                   }
                                   [addresstext appendString:placemark.postalCode];
                               }
                               if (placemark.locality) {
                                   if (addresstext.length) {
                                       [addresstext appendString:@", "];
                                   }
                                   [addresstext appendString:placemark.locality];
                               }
                               
                               if (placemark.subAdministrativeArea) {
                                   if (addresstext.length) {
                                       [addresstext appendString:@", "];
                                   }
                                   [addresstext appendString:placemark.subAdministrativeArea];
                               }
                               
                               
                               if (placemark.country) {
                                   
                                   if (addresstext.length) {
                                       [addresstext appendString:@", "];
                                   }
                                   [addresstext appendString:placemark.country];
                               }
                               
                               
                               
                               
                               
                               
                               
                               
                               if (isByCurrentLocation) {
                                   if(!((addresstext==NULL)||[addresstext isEqualToString:@"null"]||[addresstext isEqualToString:@"Null"]||(addresstext==nil)||(addresstext==Nil)||[addresstext isEqualToString:@"<null>"]))
                                   {
                                       [self.txtEnterAddress setText:addresstext];
                                   }
                                   
                               }else{
                                   self.txtEnterAddress.placeholder = @"Enter City";
                               }
                               
                               
                               
                               
                           } else {
                               NSLog(@"%@", error.debugDescription);
                           }
                       } ];
                   }

               }else if (!self.isFirstTimeLocationFetched){
                    NSLog(@"didUpdateToLocation: %@", newLocation);
                   CLLocation *currentLocation = newLocation;
                   
                   if (currentLocation != nil)
                   {
                       self.currentLatitude = newLocation.coordinate.latitude;
                       self.currentLongitude = newLocation.coordinate.longitude;
                       
                       if (isByCurrentLocation)
                       {
                           [self addMarkerInLocationWithCoordinateLatitude:self.currentLatitude andLongitude:self.currentLongitude];
                           [self addCircleToCordinateLatitude:self.currentLatitude andLongitude:self.currentLongitude withRadius:radius];
                           
                           [self startServiceToGetHotelsListFromLocationfromLat:[NSNumber numberWithDouble:self.currentLatitude] andLongitude:[NSNumber numberWithDouble:self.currentLongitude]];
                       }else{
                           [self addCircleToCordinateLatitude:self.currentLatitude andLongitude:self.currentLongitude withRadius:radius];
                       }
                       [self.mapView animateToLocation:newLocation.coordinate];
                       
                       [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
                           NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
                           if (error == nil && [placemarks count] > 0) {
                               placemark = [placemarks lastObject];
                               
                               
                               
                               NSMutableString *addresstext = [NSMutableString string];
                               
                               
                               if (placemark.subThoroughfare) {
                                   
                                   [addresstext appendString:placemark.subThoroughfare];
                               }
                               
                               if (placemark.thoroughfare) {
                                   if (addresstext.length) {
                                       [addresstext appendString:@", "];
                                   }
                                   [addresstext appendString:placemark.thoroughfare];
                               }
                               if (placemark.subLocality) {
                                   if (addresstext.length) {
                                       [addresstext appendString:@", "];
                                   }
                                   [addresstext appendString:placemark.subLocality];
                               }
                               if (placemark.postalCode) {
                                   if (addresstext.length) {
                                       [addresstext appendString:@", "];
                                   }
                                   [addresstext appendString:placemark.postalCode];
                               }
                               if (placemark.locality) {
                                   if (addresstext.length) {
                                       [addresstext appendString:@", "];
                                   }
                                   [addresstext appendString:placemark.locality];
                               }
                               
                               if (placemark.subAdministrativeArea) {
                                   if (addresstext.length) {
                                       [addresstext appendString:@", "];
                                   }
                                   [addresstext appendString:placemark.subAdministrativeArea];
                               }
                               
                               
                               if (placemark.country) {
                                   
                                   if (addresstext.length) {
                                       [addresstext appendString:@", "];
                                   }
                                   [addresstext appendString:placemark.country];
                               }
                               
                               
                               
                               
                               
                               
                               
                               
                               if (isByCurrentLocation) {
                                   if(!((addresstext==NULL)||[addresstext isEqualToString:@"null"]||[addresstext isEqualToString:@"Null"]||(addresstext==nil)||(addresstext==Nil)||[addresstext isEqualToString:@"<null>"]))
                                   {
                                       [self.txtEnterAddress setText:addresstext];
                                   }
                                   
                               }else{
                                   self.txtEnterAddress.placeholder = @"Enter City";
                               }
                               
                               
                               
                               
                           } else {
                               NSLog(@"%@", error.debugDescription);
                           }
                       } ];
                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                   }
               }

    }
       }

#pragma mark - Add Marker in Google Map
- (GMSMarker *)addMarkerInLocationWithCoordinateLatitude:(double )lat andLongitude:(double)longitude{
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(lat, longitude);
    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    marker.map = self.mapView;
    
    return marker;
}

#pragma mark -----------------------------------------REMOVE GMSMARKER-----------------------------------------
- (void)removeMarkerFromLocation{
    [self.mapView clear];
}

#pragma mark - Add Circle to Map
- (void)addCircleToCordinateLatitude:(double)lat andLongitude:(double)longitude withRadius:(int)rad
{
    //    geoFenceCircle = [[GMSCircle alloc] init];
    //    geoFenceCircle.radius = radius; // Meters
    //    geoFenceCircle.position = _mapView.camera.target; // Some CLLocationCoordinate2D position
    //    geoFenceCircle.fillColor = [UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.07];
    //    geoFenceCircle.strokeWidth = 3;
    //    geoFenceCircle.strokeColor = [UIColor redColor];
    //    geoFenceCircle.map = _mapView;

    CLLocationCoordinate2D circleCenter = CLLocationCoordinate2DMake(lat, longitude);
    circ = [GMSCircle circleWithPosition:circleCenter
                                             radius:rad];
    circ.fillColor = [UIColor colorWithRed:0 green:1.0 blue:0 alpha:0.07];
    circ.strokeColor = [UIColor greenColor];

    circ.map = self.mapView;
}



#pragma mark - WEBSERVICE IMPLENTATION METHOD

- (void)startServiceToGetHotelsListFromLocationfromLat:(NSNumber *)lat andLongitude:(NSNumber *)longitude
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *strDate =@"";
    NSString *str = [self.btnBookingDate titleForState:UIControlStateNormal];
    
    //    NSString *str=self.btnBookingDate.titleLabel.text;
    if ([str isEqualToString:@"Today"])
    {
        NSDate *todayDate = [NSDate date]; // get today date
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date..
        [dateFormatter setDateFormat:@"dd MMM yyyy"]; //Here we can set the format which we need
        strDate = [dateFormatter stringFromDate:todayDate];// here convert date in
        NSLog(@"Today formatted date is %@",strDate);
    }
    else if ([str isEqualToString:@"Tommorow"]) {
        
        NSDate *todayDate = [NSDate date]; // get today date
        int daysToAdd = 1;
        NSDate *tommorowDate= [todayDate dateByAddingTimeInterval:60*60*24*daysToAdd];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date..
        [dateFormatter setDateFormat:@"dd MMM yyyy"]; //Here we can set the format which we need
        strDate = [dateFormatter stringFromDate:tommorowDate];// here convert date in
        NSLog(@"Today formatted date is %@",strDate);
        
    }
    else if ([str isEqualToString:@"Day After"]) {
        NSDate *todayDate = [NSDate date]; // get today date
        int daysToAdd = 2;
        NSDate *dayAfetrDate= [todayDate dateByAddingTimeInterval:60*60*24*daysToAdd];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date..
        [dateFormatter setDateFormat:@"dd MMM yyyy"]; //Here we can set the format which we need
        strDate = [dateFormatter stringFromDate:dayAfetrDate];// here convert date in
        NSLog(@"Today formatted date is %@",strDate);
        
    }

   
    
    NSDictionary *dictParams = @{@"latitude":lat ,@"longitude":longitude,@"searchdate":strDate};
    NSLog(@"%@", dictParams);
    //longitude
    //latitude
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
   
     [manager GET:[NSString stringWithFormat:@"%@/api/SearchHotelApi/GetHotelList?",kServerUrl] parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
         NSLog(@"responseObject=%@",responseObject);
         NSArray *responseArr = responseObject;
         currentByLocationRoomCountArr = [NSMutableArray arrayWithArray:responseArr];
         NSLog(@"Slider.Value is:-%f ,sliderValue is :-%d, templSliderValue is:- %d",slider.value , sliderVaue, tempSliderValue);
         if (![[NSString stringWithFormat:@"%@",[responseArr objectAtIndex:sliderVaue] ] isEqualToString:@"0"]) {
             [self.lblRoomsAvailable setText:@"Rooms are available"];
             circ.fillColor = [UIColor colorWithRed:0 green:1.0 blue:0 alpha:0.07];
             circ.strokeColor = [UIColor greenColor];
             [self.lblRoomsAvailable setHidden:NO];
             [self.btnBookNow setHidden:NO];
             self.lblRoomsAvailable.layer.borderColor = [UIColor greenColor].CGColor;
         } else if ([[NSString stringWithFormat:@"%@",[responseArr objectAtIndex:sliderVaue ] ] isEqualToString:@"0"]){
              [self.lblRoomsAvailable setHidden:NO];
             [self.lblRoomsAvailable setText:@"Rooms are not available"];
             circ.fillColor = [UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.07];
             circ.strokeColor = [UIColor redColor];
             [self.btnBookNow setHidden:YES];
             self.lblRoomsAvailable.layer.borderColor = [UIColor redColor].CGColor;

         }
         
         [self checkNumberOfRommsAvailableOrNot];

         
         [self.arrHotels removeAllObjects];
         
         //comment it
        // [self.arrHotels addObjectsFromArray:[[NSArray alloc]initWithObjects:@"0",@"1",@"3",@"4",@"3",@"2",@"0",@"1",@"3",@"14", nil]];
         
         //Real code
        [self.arrHotels addObjectsFromArray:responseObject];
         
       // NSString *status = [responseObject valueForKey:@"status"];
        // NSString *msg = [responseObject valueForKey:@"errorMessage"];
        
        NSLog(@"sucess");
         
         
        // [[ICSingletonManager sharedManager]showAlertViewWithMsg:msg onController:self];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        [[ICSingletonManager sharedManager] showAlertViewWithMsg:error.localizedDescription onController:self];

        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

//http://www.icanstay.com/SearchHotel/GetHotelSearchResultMobile?cityid=1&zoneid=21&date=03%20Sep%202016&rooms=1&familyStay=N

- (BOOL)startServiceToGetHotelSearchResultMobileByCityFromLocationfromLat
{

    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
   // NSString *strDate = [[ICSingletonManager sharedManager] gettingDateStringToBeSendInPastStayApiFromStrDate:self.btnBookingDate.titleLabel.text];
    
    NSString *strDate =@"";
    NSString *str = [self.btnBookingDate titleForState:UIControlStateNormal];

//    NSString *str=self.btnBookingDate.titleLabel.text;
    if ([str isEqualToString:@"Today"])
    {
        NSDate *todayDate = [NSDate date]; // get today date
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date..
        [dateFormatter setDateFormat:@"dd MMM yyyy"]; //Here we can set the format which we need
        strDate = [dateFormatter stringFromDate:todayDate];// here convert date in
        NSLog(@"Today formatted date is %@",strDate);
    }
    else if ([str isEqualToString:@"Tommorow"]) {
        
        NSDate *todayDate = [NSDate date]; // get today date
        int daysToAdd = 1;
        NSDate *tommorowDate= [todayDate dateByAddingTimeInterval:60*60*24*daysToAdd];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date..
        [dateFormatter setDateFormat:@"dd MMM yyyy"]; //Here we can set the format which we need
        strDate = [dateFormatter stringFromDate:tommorowDate];// here convert date in
        NSLog(@"Today formatted date is %@",strDate);
        
    }
    else if ([str isEqualToString:@"Day After"]) {
        NSDate *todayDate = [NSDate date]; // get today date
        int daysToAdd = 2;
        NSDate *dayAfetrDate= [todayDate dateByAddingTimeInterval:60*60*24*daysToAdd];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date..
        [dateFormatter setDateFormat:@"dd MMM yyyy"]; //Here we can set the format which we need
        strDate = [dateFormatter stringFromDate:dayAfetrDate];// here convert date in
        NSLog(@"Today formatted date is %@",strDate);
        
    }

    NSString *familyStay=self.strFamilyStay;
    NSString * ZoneId=[[NSUserDefaults standardUserDefaults]valueForKey:@"ZoneId"];
    NSString * CityId=[[NSUserDefaults standardUserDefaults]valueForKey:@"CityId"];
    NSString *rooms = [self.searchforBtn titleForState:UIControlStateNormal];

//    NSString *rooms = self.searchforBtn.titleLabel.text;
   
    NSDictionary *dictParams = @{@"cityid":CityId ,@"zoneid":ZoneId,@"date":strDate,@"rooms":rooms,@"familyStay":familyStay};
    NSLog(@"%@",dictParams);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
   
    
    [manager GET:[NSString stringWithFormat:@"%@/SearchHotel/GetHotelSearchResultMobile?",kServerUrl ] parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
//        [responseObject valueForKey:@"CITY_NAME"];
//        [responseObject valueForKey:@"HOTELCOUNT"];
//        [responseObject valueForKey:@"ROOMCOUNT"];
//        [responseObject valueForKey:@"ZONE_NAME"];
        
        if ([[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"ROOMCOUNT"]] isEqualToString:@"<null>"])
        {
            self.lblRoomsAvailable.hidden = NO;
            [self.lblRoomsAvailable setText:@"Rooms are not available"];
            circ.fillColor = [UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.07];
            circ.strokeColor = [UIColor redColor];
            [self.btnBookNow setHidden:YES];
            self.lblRoomsAvailable.layer.borderColor = [UIColor redColor].CGColor;
        }
        else
        {
            if ([[responseObject valueForKey:@"ROOMCOUNT"] integerValue]>0)
            {
                self.lblRoomsAvailable.hidden = NO;
                [self.lblRoomsAvailable setText:@"Rooms are available"];
                circ.fillColor = [UIColor colorWithRed:0 green:1.0 blue:0 alpha:0.07];
                circ.strokeColor = [UIColor greenColor];
                [self.btnBookNow setHidden:NO];
                self.lblRoomsAvailable.layer.borderColor = [UIColor greenColor].CGColor;
            }
            else
            {
                self.lblRoomsAvailable.hidden = NO;
                [self.lblRoomsAvailable setText:@"Rooms are not available"];
                circ.fillColor = [UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.07];
                circ.strokeColor = [UIColor redColor];
                [self.btnBookNow setHidden:YES];
                self.lblRoomsAvailable.layer.borderColor = [UIColor redColor].CGColor;
            }
        }
    
         NSLog(@"sucess");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[ICSingletonManager sharedManager] showAlertViewWithMsg:@"Failed to get voucher list" onController:self];
        
        
    }];
    
    return NO;
}



#pragma mark -
#pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{

//    if (textField == self.txtStreetAddress) {
//        [self.view scrollToY:-self.txtStreetAddress.frame.origin.y+64];
//    }
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.txtEnterAddress) {
       // [self.view scrollToY:0];
        [self.tblAddress setHidden:YES];
//        [self.txtEnterAddress setText:@""];
        
        if (textField.text.length == 0) {
        }
    }
    }

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{   // return NO to not change text
        if (textField.text.length == 1 && [string isEqualToString:@""]) {
        [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:@"ZoneId"];
        self.txtEnterAddress.text = @"";
        [self.tblAddress setHidden:YES];
        return NO;
    }
    
    if (textField == self.txtEnterAddress) {
        [self implementingGooglePlaceAutocompleteWithSearchText:textField.text];
        [self.tblAddress setHidden:NO];
        
    }
    return YES;
}
-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (self.isByCity) {
        self.txtEnterAddress.text = @"";
        self.AreaVw.hidden = YES;
        _txtFldClear = true;
        _btnBookNow.hidden = YES;
        _lblRoomsAvailable.hidden = YES;
        bycityCircleManageFirstTime = 1;
        [self.btnBookingDate setTitle:@"Today" forState:UIControlStateNormal];
        [self.searchforBtn setTitle:@"1" forState:UIControlStateNormal];

        [self initializeCorLocationInstance];
    }else if (isByCurrentLocation){
         self.txtEnterAddress.text = @"";
         [slider setValue:2.0];
        self.btnBookNow.hidden = YES;
        self.lblRoomsAvailable.hidden = YES;
        [self.btnBookingDate setTitle:@"Today" forState:UIControlStateNormal];
        [self.searchforBtn setTitle:@"1" forState:UIControlStateNormal];

        
    }
    
    
    return NO;
}

#pragma mark - GOOGLE PLACE API

- (void)implementingGooglePlaceAutocompleteWithSearchText:(NSString *)strText
{
    if(isByCurrentLocation)
    {
    GMSPlacesClient *client = [GMSPlacesClient sharedClient];
    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
    filter.country = @"IN";
    filter.type = kGMSPlacesAutocompleteTypeFilterNoFilter;
    
    [client autocompleteQuery:strText bounds:nil filter:filter callback:^(NSArray *results, NSError *error) {
        [self.arrPlaceApiAddresses removeAllObjects];
        
        if (error != nil) {
            NSLog(@"Autocomplete error %@", [error localizedDescription]);
            return;
        }
        
        for (GMSAutocompletePrediction* result in results) {
            NSLog(@"Result '%@' with placeID %@", result.attributedFullText.string, result.placeID);
            [self.arrPlaceApiAddresses addObject:result];
        }
        NSLog(@"CAN TABLEVIEW RELOAD");
         if ([self.arrPlaceApiAddresses count]>0) {
        [self.tblAddress reloadData];
        
         }
    }];
    }
    else
    {
    [self autoCompleteText:strText];
    }
}



- (void)autoCompleteText:(NSString *)strText{
    
    NSDictionary *dictParams = @{@"term":strText};
    NSString *strParams = [dictParams jsonStringWithPrettyPrint:YES];
    
    
    NSString *strUrl =[NSString stringWithFormat:@"%@/ManageWishlist/Autocomplete", kServerUrl];
    NSLog(@"%@",strUrl);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL URLWithString:strUrl]
                                    cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                    timeoutInterval:120.0f];
    
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    NSString *postString = strParams;
    NSData * data = [postString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[data length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:data];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            NSLog(@"response--%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            
            [self.autocompAdressArray removeAllObjects];
            
            self.autocompAdressArray = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: nil];
            
            
            
            
            if ([self.autocompAdressArray count] == 0 && manageAlertTblAddress == 0) {
            
                
              [self.txtEnterAddress resignFirstResponder];
                self.tblAddress.hidden = YES;
              
                
                manageAlertTblAddress = 1;
                self.txtEnterAddress.text = @"";
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"Sorry, No result found."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                
                
            }else if ([self.autocompAdressArray count] > 0){
                 [self.tblAddress reloadData];
                manageAlertTblAddress = 0;
            }
           
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } else{
            NSLog(@"error--%@",connectionError);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];

}


#pragma Mark - UITableViewDelegate Methods
#pragma mark - UITableViewDelegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.tblRedeemCoupons) {
        return self.couponList.arrHotelList.count;
    }
    else if(tableView == self.areaTblVw)
    {
    return [self.areaArray count];
    }
    else if(tableView == self.searchforTblVw)
    {
        return self.searchForArray.count;
    }
    else if(tableView == self.dayTblVw)
    {
        return self.dayArray.count;
    }else if (tableView == redeemVoucherListTblView) {
         return self.couponList.arrHotelList.count;
    }
    
    if(isByCurrentLocation)
    {
        return [self.arrPlaceApiAddresses count];
    }
    else
    {
        return [self.autocompAdressArray count];
    }
}

-(void)CheckboxSelected:(UIActionButton *) countryCheckboxBtn  {
    
    __weak NewCouponData *data = [redeemListDatasource objectAtIndex:countryCheckboxBtn.indexPath.row];
     BOOL canProceed = [self checkIfCouponNumberExceedsPermittedNumberWithCouponId:data.couponId];
  
     if (canProceed) {
    if(data.isSelected == TRUE)  {
        [countryCheckboxBtn setBackgroundImage:[UIImage imageNamed:@"voucherListChkBox"] forState:UIControlStateNormal];
       
    } else if(data.isSelected == FALSE)    {
        [countryCheckboxBtn setBackgroundImage:[UIImage imageNamed:@"voucherChkBoxSelected"] forState:UIControlStateNormal];
       //     [self.arrCouponId addObject:data.couponId];
           }
    [data setSelected:(!data.isSelected)];
    
    data = nil;
     }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (tableView == redeemVoucherListTblView)
    {
        
        static NSString *cellIdentifier = @"cellID";
        
        UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle: UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
            UIImageView * _baseImageView = [[UIImageView alloc]init];
            _baseImageView.image = [UIImage imageNamed:@"NoVoucherPopupImage"];
            _baseImageView.userInteractionEnabled = YES;
            [cell.contentView addSubview:_baseImageView];
            
            UILabel * strCouponCode = [[UILabel alloc]init];
            strCouponCode.textAlignment = NSTextAlignmentCenter;
            strCouponCode.textColor = [UIColor whiteColor];
            strCouponCode.font = [UIFont systemFontOfSize:20];
            strCouponCode.tag = kTagCellCouponCode;
            
            [_baseImageView addSubview:strCouponCode];
            
            UIActionButton *selectCheckBox = [UIActionButton buttonWithType:UIButtonTypeRoundedRect];
            
            [selectCheckBox setBackgroundImage:[UIImage imageNamed:@"voucherListChkBox"] forState:UIControlStateNormal];
            [selectCheckBox setBackgroundImage:[UIImage imageNamed:@"voucherChkBoxSelected"] forState:(UIControlStateDisabled|UIControlStateHighlighted|UIControlStateSelected)];
            selectCheckBox.tag = kTagCellCheckboxBtn;
            [selectCheckBox setSelected:NO];
            [selectCheckBox addTarget:self action:@selector(CheckboxSelected:)
                     forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:selectCheckBox];
            
            UILabel *  _luxStayVoucher = [[UILabel alloc]init];
            _luxStayVoucher.textAlignment = NSTextAlignmentCenter;
            _luxStayVoucher.textColor = [UIColor whiteColor];
            _luxStayVoucher.font = [UIFont systemFontOfSize:20];
            _luxStayVoucher.text = @"Luxury Stay Voucher";
            [_baseImageView addSubview:_luxStayVoucher];
            
            UILabel *strCouponStartAndEndDate = [[UILabel alloc]init];
            strCouponStartAndEndDate.textAlignment = NSTextAlignmentCenter;
            strCouponStartAndEndDate.font = [UIFont systemFontOfSize:20];
            strCouponStartAndEndDate.textColor = [UIColor whiteColor];
            strCouponStartAndEndDate.tag = kTagCellStartAndEndDate;
            [_baseImageView addSubview: strCouponStartAndEndDate];
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                cell.frame = CGRectMake(0, 0, redeemVoucherListTblView.frame.size.width, 170);
                _baseImageView.frame =  CGRectMake(0, 20, cell.frame.size.width -10, cell.frame.size.height - 20);
                strCouponCode.frame = CGRectMake(45, 20, _baseImageView.frame.size.width-90,30);
                selectCheckBox.frame = CGRectMake(strCouponCode.frame.origin.x + strCouponCode.frame.size.width , 30, 30, 30);
                _luxStayVoucher.frame = CGRectMake(0, strCouponCode.frame.size.height + strCouponCode.frame.origin.y + 10, _baseImageView.frame.size.width , 30);
                strCouponStartAndEndDate.frame = CGRectMake(4,_luxStayVoucher.frame.size.height + _luxStayVoucher.frame.origin.y , _baseImageView.frame.size.width -8, 30);
                
                if (IS_IPHONE_5) {
                    strCouponStartAndEndDate.font = [UIFont systemFontOfSize:12];
                    strCouponCode.font = [UIFont systemFontOfSize:12];
                    _luxStayVoucher.font = [UIFont systemFontOfSize:12];
                }
                else if (IS_IPHONE_6){
                    strCouponStartAndEndDate.font = [UIFont systemFontOfSize:14];
                    strCouponCode.font = [UIFont systemFontOfSize:14];
                    _luxStayVoucher.font = [UIFont systemFontOfSize:14];

                }
                else if (IS_IPHONE_6_PLUS)
                {
                    strCouponStartAndEndDate.font = [UIFont systemFontOfSize:14];
                    strCouponCode.font = [UIFont systemFontOfSize:14];
                    _luxStayVoucher.font = [UIFont systemFontOfSize:14];

                }
               
            }else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                
                cell.frame = CGRectMake(0, 0, redeemVoucherListTblView.frame.size.width, 170);
                _baseImageView.frame =  CGRectMake(0, 20, cell.frame.size.width-40, cell.frame.size.height - 20);
                strCouponCode.frame = CGRectMake(45, 20, _baseImageView.frame.size.width-90,30);
                selectCheckBox.frame = CGRectMake(strCouponCode.frame.origin.x + strCouponCode.frame.size.width , 30, 30, 30);
                _luxStayVoucher.frame = CGRectMake(0, strCouponCode.frame.size.height + strCouponCode.frame.origin.y + 10, _baseImageView.frame.size.width , 30);
                strCouponStartAndEndDate.frame = CGRectMake(0,_luxStayVoucher.frame.size.height + _luxStayVoucher.frame.origin.y , _baseImageView.frame.size.width, 30);
            }
            
            
            
            
        }
        
        
       __weak   NewCouponData *data = [redeemListDatasource objectAtIndex:indexPath.row];
        
        __weak UILabel * strCouponCode = (UILabel *)[cell viewWithTag: kTagCellCouponCode];
        __weak UILabel * strCouponStartAndEndDate = (UILabel *)[cell viewWithTag:kTagCellStartAndEndDate];
        __weak UIActionButton * selectCheckBox   = (UIActionButton *)[cell viewWithTag:kTagCellCheckboxBtn];
        selectCheckBox.indexPath                = indexPath;
       
        
        if (strCouponCode) {
            strCouponCode.text = data.couponCode;
        }
    //    cell.m_delegate =self;
        
        if(strCouponStartAndEndDate)  {
            strCouponStartAndEndDate.text = [NSString stringWithFormat:@"VALID FROM %@ To %@",data.startDate, data.endDate];
        }
        if(selectCheckBox)  {
            if(data.isSelected == FALSE)  {
                [selectCheckBox setBackgroundImage:[UIImage imageNamed:@"voucherListChkBox"] forState:UIControlStateNormal];
            }
            else if(data.isSelected == TRUE)    {
                [selectCheckBox setBackgroundImage:[UIImage imageNamed:@"voucherChkBoxSelected"] forState:UIControlStateNormal];
                            }
        }

        
        return  cell;
    }
    else if(tableView == self.dayTblVw)
    {
       // UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"dayTblVw"];
        static NSString *MyIdentifier = @"dayTblVw";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:MyIdentifier];
        }
       
        [cell.textLabel setTextAlignment:NSTextAlignmentLeft];
        [cell.textLabel setText:[self.dayArray objectAtIndex:indexPath.row] ];
        return cell;
    }
    else if(tableView == self.searchforTblVw)
    {
        //UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"searchforTblVw"];
        static NSString *MyIdentifier = @"searchforTblVw";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        }

        [cell.textLabel setText:[self.searchForArray objectAtIndex:indexPath.row] ];
        return cell;
    }
    else if(tableView == self.areaTblVw)
    {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"areaCell"];
        [cell.textLabel setText:[[self.areaArray objectAtIndex:indexPath.row] valueForKey:@"Text"]];
        return cell;
    }
    else
    {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PlaceApiCell"];
        
        if (isByCurrentLocation) {
            GMSAutocompletePrediction *prediction = [self.arrPlaceApiAddresses objectAtIndex:indexPath.row];
            [cell.textLabel setText:prediction.attributedFullText.string];
        }
        else
        {
            [cell.textLabel setText:[[self.autocompAdressArray objectAtIndex:indexPath.row] valueForKey:@"Value"]];
        }
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [self.txtEnterAddress resignFirstResponder];
    if (tableView == self.tblAddress)
    {
        [self.tblAddress setHidden:YES];
        if (isByCurrentLocation)
        {
            GMSAutocompletePrediction *prediction = [self.arrPlaceApiAddresses objectAtIndex:indexPath.row];
            //[self.txtStreetAddress setText:prediction.attributedFullText.string];
            [self.tblAddress setHidden:YES];
            [self.txtEnterAddress resignFirstResponder];
            
            
            
            //Getting details from PlaceId
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            GMSPlacesClient *client = [GMSPlacesClient sharedClient];
            [client lookUpPlaceID:prediction.placeID callback:^(GMSPlace *place, NSError *error)
             {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                if (error != nil) {
                    NSLog(@"Place Details error %@", [error localizedDescription]);
                    return;
                }
                
                if (place != nil) {
                    NSLog(@"Place name %@", place.name);
                    [self.txtEnterAddress setText:place.formattedAddress];
                    NSNumber *latitude = @(place.coordinate.latitude);
                    NSNumber *longitude = @(place.coordinate.longitude);
                    self.currentLatitude =place.coordinate.latitude;
                    self.currentLongitude =place.coordinate.longitude;
                    curCoordinate.latitude = self.currentLatitude;
                    curCoordinate.longitude = self.currentLongitude;
                    
                    [self removeMarkerFromLocation];
                    NSLog(@"Slider.Value is:-%f ,sliderValue is :-%d, templSliderValue is:- %d",slider.value , sliderVaue, tempSliderValue);
                    slider.value = 2.0;
                    sliderVaue = 0;
                    tempSliderValue = 2;
                    radius= (sliderVaue +1)*2000;

                    [self setRadius:radius withCoordinate:curCoordinate InMapView:self.mapView];
                    self.mapView.camera=[GMSCameraPosition cameraWithTarget:curCoordinate
                                                                       zoom:curZoom];
                    [self addMarkerInLocationWithCoordinateLatitude:place.coordinate.latitude andLongitude:place.coordinate.longitude];
                    [self addCircleToCordinateLatitude:place.coordinate.latitude andLongitude:place.coordinate.longitude withRadius:radius];
                    [self startServiceToGetHotelsListFromLocationfromLat:latitude andLongitude:longitude];
                   
                    LoginManager *loginManage = [[LoginManager alloc]init];
                    NSDictionary *dict = [loginManage isUserLoggedIn];
                    
                    
                    /****************** Mo Engage *******************/
                    
                    NSMutableDictionary *purchaseDict = [NSMutableDictionary dictionaryWithDictionary:@{@"Mobile No.": [dict objectForKey:@"Phone1"],@"User name":[NSString stringWithFormat:@"%@ %@", [dict objectForKey:@"FirstName"],[dict objectForKey:@"LastName"]],@"City Name":place.name}];
                    
                    
                    [[MoEngage sharedInstance]trackEvent:@"App City Search IOS" andPayload:purchaseDict];
                     [[MoEngage sharedInstance] syncNow];
                    [MoEngage debug:LOG_ALL];
                    
                    /****************** Mo Engage *******************/
                    
                    // Track the Event for UserSuccessfulRegistrationMobile
                    
                    NSString *actionStr = [NSString  stringWithFormat:@"%@ %@ %@",[NSString stringWithFormat:@"%@ %@", [dict objectForKey:@"FirstName"],[dict objectForKey:@"LastName"]],[dict objectForKey:@"Phone1"],place.name];
                    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
                 
                    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"App City Search IOS"
                                                                          action:actionStr
                                                                           label:[NSString stringWithFormat:@"%@ %@", [dict objectForKey:@"FirstName"],[dict objectForKey:@"LastName"]]
                                                                           value:nil] build]];
                    
                    /****************** Google Analytics *******************/
                }
            }];
        }
        else
        {
             if (self.autocompAdressArray.count)
             {
                 [self.lblRoomsAvailable setHidden:NO];
                 
                 [self removeMarkerFromLocation];
                 [self getLocationFromAddressString:[[self.autocompAdressArray objectAtIndex:indexPath.row] valueForKey:@"Value"]];
                 radius = 10000;
                 [self setRadius:radius withCoordinate:curCoordinate InMapView:self.mapView];
                 
                 self.mapView.camera=[GMSCameraPosition cameraWithTarget:curCoordinate zoom:curZoom];
                 [self addMarkerInLocationWithCoordinateLatitude:curCoordinate.latitude andLongitude:curCoordinate.longitude];
                 [self addCircleToCordinateLatitude:curCoordinate.latitude andLongitude:curCoordinate.longitude withRadius:radius];
                 
                 [self.txtEnterAddress setText:[[self.autocompAdressArray objectAtIndex:indexPath.row] valueForKey:@"Value"]];
                 [[NSUserDefaults standardUserDefaults]setValue:[[self.autocompAdressArray objectAtIndex:indexPath.row] valueForKey:@"Key"] forKey:@"CityId"];
               
                [self.btnBookingDate setTitle:@"Today" forState:UIControlStateNormal];
                 [self.searchforBtn setTitle:@"1" forState:UIControlStateNormal];
                 
               

               
                 [self startServiceToGetZonesWithId:[[self.autocompAdressArray objectAtIndex:indexPath.row] valueForKey:@"Key"]];
                 
                 LoginManager *loginManage = [[LoginManager alloc]init];
                 NSDictionary *dict = [loginManage isUserLoggedIn];
                 
                 
                 /****************** Mo Engage *******************/
                 
                 NSMutableDictionary *purchaseDict = [NSMutableDictionary dictionaryWithDictionary:@{@"Mobile No.": [dict objectForKey:@"Phone1"],@"User name":[NSString stringWithFormat:@"%@ %@", [dict objectForKey:@"FirstName"],[dict objectForKey:@"LastName"]],@"City Name":[[self.autocompAdressArray objectAtIndex:indexPath.row] valueForKey:@"Value"]}];
                 
                 
                 [[MoEngage sharedInstance]trackEvent:@"App City Search IOS" andPayload:purchaseDict];
                  [[MoEngage sharedInstance] syncNow];
                 [MoEngage debug:LOG_ALL];
                 
                 /****************** Mo Engage *******************/
                 
                 /****************** Google Analytics *******************/
                 
                 // Track the Event for UserSuccessfulRegistrationMobile
                 
                 NSString *actionStr = [NSString  stringWithFormat:@"%@ %@ %@",[NSString stringWithFormat:@"%@ %@", [dict objectForKey:@"FirstName"],[dict objectForKey:@"LastName"]],[dict objectForKey:@"Phone1"],[[self.autocompAdressArray objectAtIndex:indexPath.row] valueForKey:@"Value"]];
                 id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
                 
                 [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"App City Search IOS"
                                                                       action:actionStr
                                                                        label:[NSString stringWithFormat:@"%@ %@", [dict objectForKey:@"FirstName"],[dict objectForKey:@"LastName"]]
                                                                        value:nil] build]];
                 
                 /****************** Google Analytics *******************/
             }
        }
    }
    else if(tableView == self.areaTblVw)
    {
        [self.areaTblVw setHidden:YES];

        [self.areaLbl setText:[[self.areaArray objectAtIndex:indexPath.row] valueForKey:@"Text"]];
        [[NSUserDefaults standardUserDefaults]setValue:[[self.areaArray objectAtIndex:indexPath.row] valueForKey:@"Value"] forKey:@"ZoneId"];
        [self startServiceToGetHotelSearchResultMobileByCityFromLocationfromLat];
           }
    else if(tableView == self.searchforTblVw)
    {
        
        [self.dayTblVw setHidden:YES];
        [self.searchforTblVw setHidden:YES];
        [self.searchforBtn setTitle:[self.searchForArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        
        self.numOfRequiredRooms = [[self.searchForArray objectAtIndex:indexPath.row] integerValue];
        
        
        if ([[self.searchForArray objectAtIndex:indexPath.row] isEqualToString:@"1"])
        {
            self.strFamilyStay = @"N";
        }
        else
        {
            self.strFamilyStay = @"Y";
        }
        
        if (isByCurrentLocation) {
            
        
            [self checkNumberOfRommsAvailableOrNot];
        }
        else
        {
            [self startServiceToGetHotelSearchResultMobileByCityFromLocationfromLat];
        }
  }
    else if(tableView == self.dayTblVw)
    {
        [self.dayTblVw setHidden:YES];
        [self.searchforTblVw setHidden:YES];
        [self.btnBookingDate setTitle:[self.dayArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        
  //      [self startServiceToGetHotelSearchResultMobileByCityFromLocationfromLat];


       if (isByCurrentLocation) {
     //      slider.value = 2.0;
     //      sliderVaue = 0;
          [self startServiceToGetHotelsListFromLocationfromLat:[NSNumber numberWithDouble:self.currentLatitude] andLongitude:[NSNumber numberWithDouble:self.currentLongitude]];
          
          
       }
       else
       {
           [self startServiceToGetHotelSearchResultMobileByCityFromLocationfromLat];
       }
    
    }
    
}

-(void)checkNumberOfRommsAvailableOrNot
{
    int totalRoomCount = 0;
    NSLog(@"Slider.Value is:-%f ,sliderValue is :-%d, templSliderValue is:- %d",slider.value , sliderVaue, tempSliderValue);
    for (int i = 0; i <=  sliderVaue; i++) {
        totalRoomCount +=  [[currentByLocationRoomCountArr objectAtIndex:i]integerValue];
    }
    int value =    tempSliderValue;
    if (totalRoomCount >=  (int)self.numOfRequiredRooms) {
        [self.lblRoomsAvailable setText:@"Rooms are available"];
        circ.fillColor = [UIColor colorWithRed:0 green:1.0 blue:0 alpha:0.07];
        circ.strokeColor = [UIColor greenColor];
        [self.lblRoomsAvailable setHidden:NO];
        [self.btnBookNow setHidden:NO];
         self.lblRoomsAvailable.layer.borderColor = [UIColor greenColor].CGColor;
     //   [currentByLocationRoomCountArr removeAllObjects];
        
    }else {
        [self.lblRoomsAvailable setHidden:NO];
        [self.lblRoomsAvailable setText:@"Rooms are not available"];
        circ.fillColor = [UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.07];
        circ.strokeColor = [UIColor redColor];
        [self.btnBookNow setHidden:YES];
        self.lblRoomsAvailable.layer.borderColor = [UIColor redColor].CGColor;
    //     [currentByLocationRoomCountArr removeAllObjects];
    }

}
-(CLLocationCoordinate2D) getLocationFromAddressString: (NSString*) addressStr
{
    double latitude = 0, longitude = 0;
     double latitudeSouthWest = 0, longitudeSouthWest = 0;
    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    
    CLLocationCoordinate2D center;
    center.latitude=latitude;
    center.longitude = longitude;
    self.currentLatitude=latitude;
    self.currentLongitude=longitude;

    curCoordinate.latitude=latitude;
    curCoordinate.longitude=longitude;
    NSLog(@"View Controller get Location Logitute : %f",center.latitude);
    NSLog(@"View Controller get Location Latitute : %f",center.longitude);
    return center;
    
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == redeemVoucherListTblView)
    {
        return 170;
    }
    return 50;
}

- (void)startServiceToGetZonesWithId:(NSNumber *)cityId
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
       NSString *strUrl =[NSString stringWithFormat:@"%@/SearchHotel/GetAreaByCity/%@",kServerUrl,cityId];
    NSLog(@"%@",strUrl);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL URLWithString:strUrl]
                                    cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                    timeoutInterval:120.0f];
    
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"GET"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            
           
           // [self.slider setHidden:NO];
          //  [self.camelLabels setHidden:NO];
            [self.viewBottom setHidden:NO];
          //  [self.distInKmLbl setHidden:NO];
            
            NSLog(@"response--%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            
            
            [self.areaArray removeAllObjects];
            
            
            
            self.areaArray = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: nil];
        
           // [[self.areaArray objectAtIndex:0] valueForKey:@"Text"]
             [MBProgressHUD hideHUDForView:self.view animated:YES];
            
             [self.AreaVw setHidden:YES];
            if (self.areaArray.count>0)
            {
                [self.AreaVw setHidden:NO];
                [self.TxtVwTrailing setConstant:105];
                NSDictionary *eventLocation = [NSDictionary dictionaryWithObjectsAndKeys:@"false",@"Selected",@"All",@"Text",@"0",@"Value", nil];
                [self.areaArray insertObject:eventLocation atIndex:0];
                 [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:@"ZoneId"];
                              [self.areaTblVw reloadData];
                [self.areaLbl setText:[[self.areaArray objectAtIndex:0] valueForKey:@"Text"]];

            }
            
            [self startServiceToGetHotelSearchResultMobileByCityFromLocationfromLat];
            
        }
        else
        {
            NSLog(@"error--%@",connectionError);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
}

- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position{
    NSLog(@"%@",position);
    [circ setPosition:position.target];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnCacelTapped:(id)sender
{
    [self.txtEnterAddress resignFirstResponder];
    [self.arrPlaceApiAddresses removeAllObjects];
    [self.tblAddress reloadData];
    [self.tblAddress setHidden:YES];
}

- (IBAction)btnMenuTapped:(id)sender
{
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    if ([globals.isFromDeepLinkToMapScreen isEqualToString:@"YES"]) {
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
        globals.isFromDeepLinkToMapScreen = @"NO";
    } else if (globals.isFromMenuForSearchRedeem)
    {
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)segmentedControlTapped:(id)sender {
    
    UISegmentedControl *segment = (UISegmentedControl *)sender;
    NSLog(@"selectedSegmentIndex=%ld",(long)segment.selectedSegmentIndex);
    if (segment.selectedSegmentIndex == 0) {
        
        self.numOfRequiredRooms = self.sliderForRooms.value+2;
        NSLog(@"%ld",(long)self.numOfRequiredRooms);
        
        [self.equalWidthToCamelLabelRoom setConstant:[UIScreen mainScreen].bounds.size.width/2];
        [self.equalWidthToSliderEoom setConstant:[UIScreen mainScreen].bounds.size.width/2];
        [self.sliderForRooms setHidden:NO];
        [self.camelLabelsForRoom setHidden:NO];
        [self.lblNoOfRooms setHidden:NO];
        self.strFamilyStay = @"Y";
        
        [self startServiceToGetHotelsListFromLocationfromLat:[NSNumber numberWithDouble:self.currentLatitude] andLongitude:[NSNumber numberWithDouble:self.currentLongitude]];
        [self discreteSliderValueChanged:self.slider];

    
//    [self.trailingSpaceToSliderRoom setActive:NO];
//    [self.equalWidthToSliderEoom setActive:NO];
//    [self.trailingSpaceToCameLabelRoom setActive:NO];
//    [self.equalWidthToCamelLabelRoom setActive:NO];
    
//    [self.widthOfSlider setActive:YES];
//    [self.widthOfSlider setConstant:[UIScreen mainScreen].bounds.size.width];
//    
//    [self.widthOfCamelLabel setActive:YES];
//    [self.widthOfCamelLabel setConstant:[UIScreen mainScreen].bounds.size.width];
//        
//        
        
    }
    else {
        
        [self.equalWidthToCamelLabelRoom setConstant:[UIScreen mainScreen].bounds.size.width];
        [self.equalWidthToSliderEoom setConstant:[UIScreen mainScreen].bounds.size.width];
        [self.sliderForRooms setHidden:YES];
        [self.camelLabelsForRoom setHidden:YES];
        [self.lblNoOfRooms setHidden:YES];
        self.numOfRequiredRooms = 1;
        self.strFamilyStay = @"N";

        
        
        
       
//        [self.trailingSpaceToSliderRoom setActive:YES];
//        [self.equalWidthToSliderEoom setActive:YES];
//        [self.trailingSpaceToCameLabelRoom setActive:YES];
//        [self.equalWidthToCamelLabelRoom setActive:YES];
//
//        
//        [self.sliderForRooms setHidden:NO];
//        [self.camelLabelsForRoom setHidden:NO];
//        [self.lblNoOfRooms setHidden:NO];
//        
//        [self.widthOfSlider setConstant:[UIScreen mainScreen].bounds.size.width/2-5];
//
//        [self.widthOfCamelLabel setConstant:[UIScreen mainScreen].bounds.size.width/2-5];
        
//

    }
    
}

//- (IBAction)btnDateTapped:(id)sender
//{
//     [self.viewDatePicker setHidden:NO];
//    
//    
//}

- (IBAction)pickerValueChanged:(id)sender {
    UIDatePicker *datePicker = (UIDatePicker *)sender;
    NSString *str = [self gettingFormattedDateFromDate:datePicker.date];
    [self.btnBookingDate setTitle:str forState:UIControlStateNormal];

}

- (NSString *)gettingFormattedDateFromDate:(NSDate *)date{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateStyle=NSDateFormatterMediumStyle;
    [dateFormat setDateFormat:@"dd MMM yyyy"];
    NSString *str=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:date]];
    return str;
}


- (IBAction)btnCancelTapped:(id)sender {
    [self.viewDatePicker setHidden:YES];
}

- (IBAction)btnDoneTapped:(id)sender {
    [self.viewDatePicker setHidden:YES];
}
- (IBAction)btnBookNowTapped:(id)sender {
   
    [self startServiceToGetCouponsList];
 
}


- (void)startServiceToGetCouponsList{
    
        LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    if (dict.count <= 0) {
       // [[ICSingletonManager sharedManager] showAlertViewWithMsg:@"Login first" onController:self];
        
       // [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(pushToDashBoardScreenAfterLoggingIn) name:kSwitchToDashBoardScreen object:nil];
        ICSingletonManager *globals = [ICSingletonManager sharedManager];
        globals.isFromMenu = false;

        LoginScreen *vcLogin = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
        [self.navigationController pushViewController:vcLogin animated:YES];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSNumber *num = [dict valueForKey:@"UserId"];
    
    NSString *strDate = [[ICSingletonManager sharedManager] gettingDateStringToBeSendInPastStayApiFromStrDate:self.btnBookingDate.titleLabel.text];

    
    NSDictionary *dictParams = @{@"userid":num,@"searchDate":strDate};
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    
    [manager GET:[NSString stringWithFormat:@"%@/api/SearchHotelApi/GetUserValidCouponsList?",kServerUrl] parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        self.couponList = [CouponList instanceFromArray:responseObject];
        
        for (NSDictionary *dict  in responseObject) {
           
           NSString *couponCode =  [dict valueForKey:@"CouponCode"];

            
            NSString *createdDate = [[ICSingletonManager sharedManager] returnFormatedStringDateFromString:[dict valueForKey:@"CreatedDate"]];
            
            NSString *expiryDate = [[ICSingletonManager sharedManager] returnFormatedStringDateFromString:[dict valueForKey:@"ExpiryDate"]];
            
            NewCouponData *data = [[NewCouponData alloc] initCouponData:couponCode startDate:createdDate endDate:expiryDate couponId:[NSString stringWithFormat:@"%@",[dict objectForKey:@"CouponDetailId"]] isSelected:NO];
            [redeemListDatasource addObject:data];

        }
        
        
        
        if (self.couponList.arrHotelList.count == 0){
            
            [self.areaTblVw setHidden: YES];
            [self.dayTblVw setHidden:YES];
            [self.searchforTblVw setHidden:YES];
            [self.btnBookNow setHidden:YES];
            [self.lblRoomsAvailable setHidden: YES];

            [self.viewBuyCoupons setHidden:NO];
            [self.lblBuyCouponText setText:@"  You don't have any valid Voucher(s).Please Buy Voucher(s) first"];
            self.lblBuyCouponText.numberOfLines = 2;
            self.lblBuyCouponText.lineBreakMode = NSLineBreakByWordWrapping;
            self.lblBuyCouponText.font = [UIFont systemFontOfSize:20];
            self.lblBuyCouponText.textAlignment = NSTextAlignmentLeft;
             [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        else if (self.couponList.arrHotelList.count <self.numOfRequiredRooms){
            
            [self.areaTblVw setHidden: YES];
            [self.dayTblVw setHidden:YES];
            [self.searchforTblVw setHidden:YES];
            [self.btnBookNow setHidden:YES];
            [self.lblRoomsAvailable setHidden: YES];

            [self.viewBuyCoupons setHidden:NO];
            [self.lblBuyCouponText setText:[NSString stringWithFormat:@"Minimum number of purchased Vouchers should be %li",(long)self.numOfRequiredRooms]];
             [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        else{
            
            
            self.txtEnterAddress.userInteractionEnabled = NO;
            self.btnBookingDate.userInteractionEnabled = NO;
            self.searchforBtn.userInteractionEnabled = NO;
            self.areaDropBtn.userInteractionEnabled = NO;
            [self.txtEnterAddress resignFirstResponder];
            
            redeemVoucherListVc = [[UIViewController alloc]init];
            redeemVoucherListVc.view.backgroundColor = [UIColor whiteColor];
            redeemVoucherListVc.view.layer.masksToBounds = YES;
            //  self.view.alpha = 0.7;
            
            
          
            //                [self.view addSubview:V2.view];
            //                [V2 didMoveToParentViewController:self];
            
            
            
//            CCMPopupTransitioning *popup = [CCMPopupTransitioning sharedInstance];
//            
//            popup.backgroundBlurRadius = 10;
//            popup.backgroundViewAlpha = 0.2;
//            popup.backgroundViewColor = [UIColor blackColor];
//            popup.presentedController = redeemVoucherListVc;
//            popup.dismissableByTouchingBackground = NO;
//            popup.presentingController = self;
            
            
            if (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad) {
                redeemVoucherListVc.view.frame = CGRectMake(50,((self.view.frame.size.height -  (self.view.frame.size.height * 0.65))/2) - 70, self.view.frame.size.width - 100, self.view.frame.size.height * 0.65);
                
        
            }else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
                redeemVoucherListVc.view.frame = CGRectMake(15, (self.view.frame.size.height - (self.view.frame.size.height * 0.9) )/2, self.view.frame.size.width - 30, self.view.frame.size.height * 0.9);
                
       
            }
            [self designRedeemListCouponPopup];
       
            
            [self.view addSubview:redeemVoucherListVc.view];
            [self addChildViewController:redeemVoucherListVc];


            [self.viewRedeemCoupon setHidden:YES];
             [MBProgressHUD hideHUDForView:self.view animated:YES];
           
            self.arrCouponId = [[NSMutableArray alloc]init];
            
           

          
           // [self.tblRedeemCoupons reloadData];
//            self.mapView.alpha = 0.5;
//            self.mapView.alpha = 0.5;
//            self.viewBottom.alpha = 0.5;
           
        }
        
        [self.viewBlackPopUp setHidden:NO];
        
        
        NSLog(@"sucess");
       
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[ICSingletonManager sharedManager] showAlertViewWithMsg:@"Failed to get voucher list" onController:self];
        
        
    }];
    
}

-(void)designRedeemListCouponPopup
{
    
    UIView *blueBaseView = [[UIView alloc]init];
    blueBaseView.backgroundColor = [self colorWithHexString:@"001d3d"];
    [redeemVoucherListVc.view addSubview:blueBaseView];
    
    UILabel *reedeemVoucherLbl = [[UILabel alloc]init];
    reedeemVoucherLbl.text = @"Redeem Voucher(s)";
    reedeemVoucherLbl.textColor = [UIColor whiteColor];
    reedeemVoucherLbl.font = [UIFont systemFontOfSize:18];
    [blueBaseView addSubview:reedeemVoucherLbl];
    
    UIButton *crossBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
   [crossBtn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
   // [crossBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [crossBtn addTarget:self action:@selector(crossBtnRedeemPopupListTapped:) forControlEvents:UIControlEventTouchUpInside];
    [blueBaseView addSubview:crossBtn];
    
    
    redeemVoucherListTblView  = [[UITableView alloc]init];
    redeemVoucherListTblView.delegate = self;
    redeemVoucherListTblView.dataSource = self;
    redeemVoucherListTblView.allowsSelection = NO;
    redeemVoucherListTblView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [redeemVoucherListVc.view addSubview:redeemVoucherListTblView];
    
    
    UIButton *redeemBtnVoucheListView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    redeemBtnVoucheListView.layer.cornerRadius = 5.0;
    [redeemBtnVoucheListView addTarget:self action:@selector(redeemBtnVoucherListViewTapped:) forControlEvents:UIControlEventTouchUpInside];
    [redeemBtnVoucheListView setTitle:@"Redeem" forState:UIControlStateNormal];
    [redeemBtnVoucheListView setBackgroundColor:[self colorWithHexString:@"bd9854"]];
    [redeemBtnVoucheListView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [redeemVoucherListVc.view addSubview:redeemBtnVoucheListView];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        blueBaseView.frame = CGRectMake(0, 0, redeemVoucherListVc.view.frame.size.width, 40);
        reedeemVoucherLbl.frame = CGRectMake(40, 0,  redeemVoucherListVc.view.frame.size.width / 2, 40);
        crossBtn.frame = CGRectMake(blueBaseView.frame.size.width - 40,5 , 30, 30);
        redeemVoucherListTblView.frame = CGRectMake(0, blueBaseView.frame.origin.y + blueBaseView.frame.size.height+10,redeemVoucherListVc.view.frame.size.width ,redeemVoucherListVc.view.frame.size.height - blueBaseView.frame.size.height - 60 -20);
        redeemBtnVoucheListView.frame  = CGRectMake((redeemVoucherListVc.view.frame.size.width - 120) /2, redeemVoucherListTblView.frame.size.height + redeemVoucherListTblView.frame.origin.y +20,120,40);
        
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        blueBaseView.frame = CGRectMake(0, 0, redeemVoucherListVc.view.frame.size.width, 40);
        reedeemVoucherLbl.frame = CGRectMake(10, 0,  redeemVoucherListVc.view.frame.size.width -50, 40);
        crossBtn.frame = CGRectMake(blueBaseView.frame.size.width - 40,5 , 30, 30);
        redeemVoucherListTblView.frame = CGRectMake(0, blueBaseView.frame.origin.y + blueBaseView.frame.size.height+10,redeemVoucherListVc.view.frame.size.width ,redeemVoucherListVc.view.frame.size.height - blueBaseView.frame.size.height - 60 -10);
         redeemBtnVoucheListView.frame  = CGRectMake((redeemVoucherListVc.view.frame.size.width - 120) /2, redeemVoucherListTblView.frame.size.height + redeemVoucherListTblView.frame.origin.y +10,120,40);
        
    }
    
    
    
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

-(void)redeemBtnVoucherListViewTapped:(id)sender
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
     [MBProgressHUD showHUDAddedTo:redeemVoucherListVc.view animated:YES];
    BOOL canProceed = [self checkWhetherMinimumQtyOfCouponsSelected];
    if (!canProceed)
        return;
    
    int hotelDistance = (self.slider.value+1)*2;
    NSString *strDate = [[ICSingletonManager sharedManager] gettingDateStringToBeSendInPastStayApiFromStrDate:self.btnBookingDate.titleLabel.text];
    
    
    
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormat dateFromString:strDate];
    
    // Convert date object to desired output format
    [dateFormat setDateFormat:@"dd MMM yyyy"];
    strDate = [dateFormat stringFromDate:date];
    
    NSString *couponList = @"";
    NSString *familyList = @"";
    if ([self.arrCouponId count] > 1) {
        for (NSNumber *obj in self.arrCouponId)
        {
            couponList =  [couponList stringByAppendingString:[NSString stringWithFormat:@"%@,",obj]];
            familyList = [familyList stringByAppendingString:@"0,"];
        }
    }else if ([self.arrCouponId count] == 1)
    {
        couponList = [self.arrCouponId objectAtIndex:0];
        familyList = @"0";
    }
    
   
   
    NSString *strParams;
    NSString *strn;
    if (isByCurrentLocation)
    {
        strParams = [NSString stringWithFormat:@"longitude=%@&latitude=%@&hotelDistance=%i&searchdate=%@&CouponList=%@&familyList=%@,&rooms=%i&familyStay=%@&bookingMode=A",[NSNumber numberWithDouble:self.currentLongitude],[NSNumber numberWithDouble:self.currentLatitude],hotelDistance,strDate,couponList,familyList,self.numOfRequiredRooms,_strFamilyStay];
        
        strn = [NSString stringWithFormat:@"%@/api/SearchHotelApi/SearchedHotelBookingMobile?%@",kServerUrl,strParams];
    }else{
        _ZoneId=[[NSUserDefaults standardUserDefaults]valueForKey:@"ZoneId"];
        _CityId=[[NSUserDefaults standardUserDefaults]valueForKey:@"CityId"];
        
        strParams = [NSString stringWithFormat:@"cityid=%@&zoneid=%@&hotelDistance=%i&searchdate=%@&CouponList=%@&familyList=%@,&rooms=%i&familyStay=%@&bookingMode=A",_CityId,_ZoneId,hotelDistance,strDate,couponList,familyList,self.numOfRequiredRooms,self.strFamilyStay];
        
        strn = [NSString stringWithFormat:@"%@/api/SearchHotelApi/SearchedHotelBooking?%@",kServerUrl,strParams];
    }
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    
    
    NSString *encoded = [strn stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@", encoded);
    
    [manager POST:encoded parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"responseObject=%@",responseObject);
        NSLog(@"sucess");
        //     NSString *msg= [responseObject valueForKey:@"errorMessage"];
        
        [self.viewBlackPopUp setHidden:YES];
        [self.viewRedeemCoupon setHidden:YES];
        
        NSString *msg = [responseObject objectForKey:@"errorMessage"];
        // [[ICSingletonManager sharedManager]showAlertViewWithMsg:msg onController:self];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            LoginManager *login = [[LoginManager alloc]init];
            if ([[login isUserLoggedIn] count]>0)
            {
                SideMenuController *vcSideMenu = [[SideMenuController alloc]init];
                [vcSideMenu startServiceToGetCouponsDetails];
            }
        });
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
         [MBProgressHUD hideHUDForView:redeemVoucherListVc.view animated:YES];
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:[NSString stringWithFormat:msg,(unsigned long)[self.arrCouponId count]]
                                     message:nil
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        
        
        UIAlertAction* okButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       [self alertOkBtnTapped];
                                   }];
        
        
        
        
        [alert addAction:okButton];
         [self.arrCouponId removeAllObjects];
        [redeemVoucherListVc presentViewController:alert animated:YES completion:nil];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        [self.viewBlackPopUp setHidden:YES];
        [self.viewRedeemCoupon setHidden:YES];
//        [self.tblRedeemCoupons reloadData];
        [self.arrCouponId removeAllObjects];
         [MBProgressHUD hideHUDForView:redeemVoucherListVc.view animated:YES];
       // [[ICSingletonManager sharedManager] showAlertViewWithMsg:error.localizedDescription onController:self];
        
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
         [[ICSingletonManager sharedManager] showAlertViewWithMsg:error.localizedDescription onController:redeemVoucherListVc];
       

    }];
}


-(void)CurrentLocationApiOnSliderValueChange
{
    
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        int hotelDistance = (self.slider.value+1)*2;
        NSString *strDate = [[ICSingletonManager sharedManager] gettingDateStringToBeSendInPastStayApiFromStrDate:self.btnBookingDate.titleLabel.text];
        
    BOOL canProceed = [self checkWhetherMinimumQtyOfCouponsSelected];
    if (!canProceed)
        return;
    
        // Convert string to date object
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [dateFormat dateFromString:strDate];
        
        // Convert date object to desired output format
        [dateFormat setDateFormat:@"dd MMM yyyy"];
        strDate = [dateFormat stringFromDate:date];
        
        NSString *couponList = @"";
        for (NSNumber *obj in self.arrCouponId)
        {
            couponList =  [couponList stringByAppendingString:[NSString stringWithFormat:@"%@,",obj]];
        }
        
        NSString *strParams;
        NSString *strn;
        if (isByCurrentLocation)
        {
            strParams = [NSString stringWithFormat:@"longitude=%@&latitude=%@&hotelDistance=%i&searchdate=%@&CouponList=%@&familyList=0,&rooms=%i&familyStay=%@&bookingMode=A",[NSNumber numberWithDouble:self.currentLongitude],[NSNumber numberWithDouble:self.currentLatitude],hotelDistance,strDate,couponList,self.numOfRequiredRooms,self.strFamilyStay];
            
            strn = [NSString stringWithFormat:@"%@/api/SearchHotelApi/SearchedHotelBookingMobile?%@",kServerUrl,strParams];
        }else{
            _ZoneId=[[NSUserDefaults standardUserDefaults]valueForKey:@"ZoneId"];
            _CityId=[[NSUserDefaults standardUserDefaults]valueForKey:@"CityId"];
            
            strParams = [NSString stringWithFormat:@"cityid=%@&zoneid=%@&hotelDistance=%i&searchdate=%@&CouponList=%@&familyList=0,&rooms=%i&familyStay=%@&bookingMode=A",_CityId,_ZoneId,hotelDistance,strDate,couponList,self.numOfRequiredRooms,self.strFamilyStay];
            
            strn = [NSString stringWithFormat:@"%@/api/SearchHotelApi/SearchedHotelBooking?%@",kServerUrl,strParams];
        }
    
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                         forHTTPHeaderField:@"Content-Type"];
        
        
        
        NSString *encoded = [strn stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [manager POST:encoded parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"responseObject=%@",responseObject);
            NSLog(@"sucess");
            //     NSString *msg= [responseObject valueForKey:@"errorMessage"];
            
            [self.viewBlackPopUp setHidden:YES];
            [self.viewRedeemCoupon setHidden:YES];
            
            
            [self.arrCouponId removeAllObjects];

            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failure");
            [self.viewBlackPopUp setHidden:YES];
            [self.viewRedeemCoupon setHidden:YES];
            //        [self.tblRedeemCoupons reloadData];
            [self.arrCouponId removeAllObjects];
            [MBProgressHUD hideHUDForView:redeemVoucherListVc.view animated:YES];
            // [[ICSingletonManager sharedManager] showAlertViewWithMsg:error.localizedDescription onController:self];
            
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [[ICSingletonManager sharedManager] showAlertViewWithMsg:error.localizedDescription onController:redeemVoucherListVc];
            
            
        }];
    
}
-(void)alertOkBtnTapped
{
    
    
     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    CurrentStayScreen *buyCoupon =[storyboard instantiateViewControllerWithIdentifier:@"CurrentStayScreen"];

    SideMenuController *vcSideMenu =     [storyboard instantiateViewControllerWithIdentifier:@"SideMenuController"];
    
    MMDrawerController *drawerController = [[MMDrawerController alloc]initWithCenterViewController:buyCoupon
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
-(void)crossBtnRedeemPopupListTapped:(id)sender
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];

 //   self.txtEnterAddress.text =  @"";
  //  self.AreaVw.hidden = YES;
//    self.btnBookNow.hidden = YES;
//    self.lblRoomsAvailable.hidden = YES;
//    [self.areaTblVw setHidden: YES];
  //  [self.dayTblVw setHidden:YES];
  //  [self.searchforTblVw setHidden:YES];
    //[self.btnBookNow setHidden:YES];
   // [self.lblRoomsAvailable setHidden: YES];
    
    
    [redeemVoucherListVc.view removeFromSuperview];
    redeemVoucherListTblView = nil;
    redeemVoucherListVc = nil;
    [redeemListDatasource removeAllObjects];
    self.txtEnterAddress.userInteractionEnabled = YES;
    self.searchforBtn.userInteractionEnabled = YES;
    self.btnBookingDate.userInteractionEnabled = YES;
    self.areaDropBtn.userInteractionEnabled = YES;
 
}

//func sayHello(personName:String) -> String{
//    var greeting = "Hello" + personName + "!"
//    return greeting
//}
//
//println(sayHello ("Brain"))


#pragma mark - RedeemCouponDelegateMethod
-(BOOL)checkIfCouponNumberExceedsPermittedNumberWithCouponId:(NSString *)couponId
{
    
    if (![self.arrCouponId containsObject:couponId])
    {
        if (self.arrCouponId.count >= self.numOfRequiredRooms)
        {
            [[ICSingletonManager sharedManager] showAlertViewWithMsg:[NSString stringWithFormat:@"Maximum %d voucher can be selected",self.numOfRequiredRooms] onController:self];
            return NO;
        }
        else
        {
            [self.arrCouponId addObject:couponId];
            return YES;
        }
    }
    else
        [self.arrCouponId removeObject:couponId];
    
    return YES;
}

- (IBAction)btnRedeemTapped:(id)sender
{
    BOOL canProceed = [self checkWhetherMinimumQtyOfCouponsSelected];
    if (!canProceed)
        return;
    
    int hotelDistance = (self.slider.value+1)*2;
    NSString *strDate = [[ICSingletonManager sharedManager] gettingDateStringToBeSendInPastStayApiFromStrDate:self.btnBookingDate.titleLabel.text];
    
 
    
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormat dateFromString:strDate];
    
    // Convert date object to desired output format
    [dateFormat setDateFormat:@"dd MMM yyyy"];
    strDate = [dateFormat stringFromDate:date];
    
    NSString *couponList = @"";
    for (NSNumber *obj in self.arrCouponId)
    {
        couponList =  [couponList stringByAppendingString:[NSString stringWithFormat:@"%@,",obj]];
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *strParams;
    NSString *strn;
    if (isByCurrentLocation)
    {
             strParams = [NSString stringWithFormat:@"longitude=%@&latitude=%@&hotelDistance=%i&searchdate=%@&CouponList=%@&familyList=0,&rooms=%i&familyStay=%@&bookingMode=A",[NSNumber numberWithDouble:self.currentLongitude],[NSNumber numberWithDouble:self.currentLatitude],hotelDistance,strDate,couponList,self.numOfRequiredRooms,self.strFamilyStay];
        
        strn = [NSString stringWithFormat:@"%@/api/SearchHotelApi/SearchedHotelBookingMobile?%@",kServerUrl,strParams];
    }else{
        _ZoneId=[[NSUserDefaults standardUserDefaults]valueForKey:@"ZoneId"];
        _CityId=[[NSUserDefaults standardUserDefaults]valueForKey:@"CityId"];
        
        strParams = [NSString stringWithFormat:@"cityid=%@&zoneid=%@&hotelDistance=%i&searchdate=%@&CouponList=%@&familyList=0,&rooms=%i&familyStay=%@&bookingMode=A",_CityId,_ZoneId,hotelDistance,strDate,couponList,self.numOfRequiredRooms,self.strFamilyStay];
        
    strn = [NSString stringWithFormat:@"%@/api/SearchHotelApi/SearchedHotelBooking?%@",kServerUrl,strParams];
    }
    
   
    
     AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
     manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
     [manager.requestSerializer setValue:@"application/json; charset=utf-8"
     forHTTPHeaderField:@"Content-Type"];
    
   
    
     NSString *encoded = [strn stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     
     [manager POST:encoded parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
     
     NSLog(@"responseObject=%@",responseObject);
     NSLog(@"sucess");
//     NSString *msg= [responseObject valueForKey:@"errorMessage"];
         
         [self.tblRedeemCoupons reloadData];
         [self.viewBlackPopUp setHidden:YES];
         [self.viewRedeemCoupon setHidden:YES];
         [self.arrCouponId removeAllObjects];
         
         CurrentStayScreen *currentStayScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"CurrentStayScreen"];
         currentStayScreen.comingFromMapScreen = YES;
         [self.navigationController pushViewController:currentStayScreen animated:YES];
         
        // [[ICSingletonManager sharedManager]showAlertViewWithMsg:msg onController:self];
     
     [MBProgressHUD hideHUDForView:self.view animated:YES];
     
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     NSLog(@"failure");
         [self.viewBlackPopUp setHidden:YES];
         [self.viewRedeemCoupon setHidden:YES];
         [self.tblRedeemCoupons reloadData];
         [self.arrCouponId removeAllObjects];
         [[ICSingletonManager sharedManager] showAlertViewWithMsg:error.localizedDescription onController:self];


     [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
}

- (BOOL)checkWhetherMinimumQtyOfCouponsSelected
{
    if (self.arrCouponId.count == 0) {
         [MBProgressHUD hideHUDForView:redeemVoucherListVc.view animated:YES];
        [[ICSingletonManager sharedManager] showAlertViewWithMsg:@"Select voucher first" onController:self];
        return NO;
    }
    
    if (self.arrCouponId.count < self.numOfRequiredRooms) {
         [MBProgressHUD hideHUDForView:redeemVoucherListVc.view animated:YES];
        CGFloat requiredCoupon = self.numOfRequiredRooms - self.arrCouponId.count;
        [[ICSingletonManager sharedManager] showAlertViewWithMsg:[NSString stringWithFormat:@"Select %.f more voucher ",requiredCoupon] onController:self];
        return NO;
    }
    return YES;
}

- (IBAction)btnCancelreddemViewTapped:(id)sender {
    
    [self.viewBlackPopUp setHidden:YES];
    [self.viewRedeemCoupon setHidden:YES];
    self.mapView.alpha = 1.0;
    self.mapView.alpha = 1.0;
    self.viewBottom.alpha = 1.0;
    [self.arrCouponId removeAllObjects];
    
}
- (IBAction)btnCancelTappedInViewBuyCoupon:(id)sender {
    [self.viewBlackPopUp setHidden:YES];
    [self.viewBuyCoupons setHidden:YES];
}

- (IBAction)btnBuyNowTappedForCoupons:(id)sender {
    BuyCouponViewController *buyCoupon =[self.storyboard instantiateViewControllerWithIdentifier:@"BuyCouponViewController"];
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
      _btnBookNow.hidden = YES;
    self.viewBuyCoupons.hidden = YES;
    globals.isFromBuyVocherToMapScreen = true;
    
    buyCoupon.numberOfVoucherRequired = [ NSNumber numberWithInt:(self.numOfRequiredRooms - self.couponList.arrHotelList.count  )];

    [self.navigationController pushViewController:buyCoupon animated:YES];

}
- (IBAction)areaDropDpwnClk:(id)sender {
    if ([self.areaTblVw isHidden])
    {
        [self.areaTblVw setHidden:NO];
        [self.areaTblVw setDataSource:self];
        [self.areaTblVw setDelegate:self];
        [self.areaTblVw reloadData];
    }
    else
    {
        [self.areaTblVw setHidden:YES];
    }
}
- (IBAction)searchforBtnClk:(id)sender
{
    [self.dayTblVw setHidden:YES];
    self.searchForArray=[[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4", nil];

    if ([self.searchforTblVw isHidden])
    {
        [self.searchforTblVw setHidden:NO];
        [self.searchforTblVw setDataSource:self];
        [self.searchforTblVw setDelegate:self];
        [self.searchforTblVw reloadData];
    }
    else
    {
        [self.searchforTblVw setHidden:YES];
    }
}

- (IBAction)btnDateTapped:(id)sender
{
    self.dayArray=[[NSMutableArray alloc]initWithObjects:@"Today",@"Tommorow",@"Day After", nil];
    [self.searchforTblVw setHidden:YES];
    if ([self.dayTblVw isHidden])
    {
        [self.dayTblVw setHidden:NO];
        [self.dayTblVw setDataSource:self];
        [self.dayTblVw setDelegate:self];
        [self.dayTblVw reloadData];
    }
    else
    {
        [self.dayTblVw setHidden:YES];
    }
}

@end
