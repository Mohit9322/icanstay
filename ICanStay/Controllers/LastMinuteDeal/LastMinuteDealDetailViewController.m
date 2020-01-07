//
//  LastMinuteDealDetailViewController.m
//  ICanStay
//
//  Created by Planet on 6/14/17.
//  Copyright © 2017 verticallogics. All rights reserved.
//

#import "LastMinuteDealDetailViewController.h"
#import "NotificationScreen.h"
#import "SideMenuController.h"
#import "HomeScreenController.h"
#import "DashboardScreen.h"
#import "LastMinuteHotelDetailViewController.h"
#import "lastMinuteDealBookNowController.h"
#import "seeMoreBtn.h"
#import "BookNowBtn.h"
#import "GradientButton.h"
#import "BaseView.h"
#import "IphoneSoldInTableViewCell.h"


#define kTagCellCountryCheckboxBtn  1288
#define kTagCellBookNowBtn          1287
@interface LastMinuteDealDetailViewController ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>
{
     UIView               *txtFldview;
    NSString             *searchTextString;
     UITableView          *cityNameTableView;
      BOOL                 isFilter;
    int                  manageAlertTblAddress;
    NSMutableDictionary      *cityNameTableSelectArr;
     int                   selectCellCityNameTable;
   
    NSString               *selectedCategory;
    int                    managecheckOutCheckInPickerDate;
    int                    manageRoomAndDatePicker;
    UIView                 *checkInBaseView;
    NSString               *dayAfterTomorrow;
    NSString               *dayAfterFourthDate;
    NSString               *tomorrowDate;
    NSString               *todayDate;
}
@property (nonatomic, strong) UIView         *topWhiteBaseView;
@property (nonatomic, strong) UIButton       *backButton;
@property (nonatomic, strong) UIButton       *notificationButton;
@property (nonatomic, strong) UIImageView    *logoIconImgView;
@property (nonatomic, strong) UITableView    *hotelListTableView;
@property (nonatomic, strong) NSMutableArray *hotelListArr;
@property (nonatomic, strong) UITextField    *cityTxtFld;

@property (strong,nonatomic)  NSMutableArray *filteredCityList;
@property (nonatomic, strong) NSMutableArray  *soldOutHotelArr;
@property (weak, nonatomic)  UIImageView     *hotelImage;
@property (weak, nonatomic)  UILabel         *HotelNameLbl;

@property (nonatomic,strong) UIView          *checkOutAndRoomBaseView;

@property (nonatomic, strong) UITextField    *checkNumberOfRooms;
@property (nonatomic,strong)  NSArray *roomTableViewArr;
@property NSString *numberOfrooms;
@property NSString *checkInDate;
@property NSString *checkOutDate;
@property NSString *manageSeeMoreBtnStr;

@property (nonatomic, strong) UITableView    *roomTableView;
@property (nonatomic, strong) UIButton       *oneNightBtn;
@property (nonatomic, strong) UIButton       *twoNightBtn;
@property (nonatomic, strong) UIButton       *threeNightBtn;
@property (nonatomic, strong) NSString       *daySelected;
@property (nonatomic, strong) NSString       *checkInStr;
@property  (nonatomic,strong) NSString       *roomSelected;
@property (nonatomic, strong) UIView         *oneNightNarrowView;
@property (nonatomic, strong) UIView         *twoNightNarrowView;
@property (nonatomic, strong) UIView         *threeNightNarrowView;
@property (nonatomic, strong) GradientButton *todayBtn;
@property (nonatomic, strong) GradientButton *tomorrowBtn;
@property (nonatomic, strong) GradientButton *dayAfterBtn;
@property (nonatomic, strong) UIView         *headerBaseView;

@end

@implementation LastMinuteDealDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
       DLog(@"DEBUG-VC");
    _roomSelected = @"NO";
    
    self.manageSeeMoreBtnStr = @"YES";
    
    _daySelected = [NSString stringWithFormat:@"10"];
    DLog(@"DEBUG-VC");
    _hotelListArr = [[NSMutableArray alloc]init];
    cityNameTableSelectArr = [[NSMutableDictionary alloc]init];
  
    managecheckOutCheckInPickerDate = 0;
    manageRoomAndDatePicker = 0;
    self.roomTableViewArr = [[NSArray alloc]initWithObjects:@"1 Room",@"2 Rooms",@"3 Rooms",@"4 Rooms", nil];
    DLog(@"DEBUG-VC");
    _soldOutHotelArr = [[NSMutableArray alloc]init];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    isFilter = NO;
    /***************************** TopHeaderBackIcsLogo View ********************/
    self.topWhiteBaseView = [[UIView alloc]init];
    self.topWhiteBaseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topWhiteBaseView];
    
    self.notificationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.notificationButton setBackgroundImage:[UIImage imageNamed:@"notification1"] forState:UIControlStateNormal];
    [self.notificationButton addTarget:self action:@selector(notificationButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
  //  [self.topWhiteBaseView addSubview:self.notificationButton];
    
    self.logoIconImgView = [[UIImageView alloc]init];
    self.logoIconImgView.image = [UIImage imageNamed:@"topBanner"];
     self.logoIconImgView.userInteractionEnabled = YES;
    [self.topWhiteBaseView addSubview:self.logoIconImgView];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.topWhiteBaseView addGestureRecognizer:singleFingerTap];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.backButton setBackgroundImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.topWhiteBaseView addSubview:self.backButton];
    
    /***************************** TopHeaderBackIcsLogo View ************************/
    
    selectCellCityNameTable = 0;
    _headerBaseView = [[UIView alloc]init];
    [self.view addSubview:_headerBaseView];
    

    UIImageView *baseImageView = [[UIImageView alloc]init];
    baseImageView.image = [UIImage imageNamed:@"PackageBaseImg"];
    baseImageView.hidden = YES;
    [_headerBaseView addSubview:baseImageView];
    
    
    UILabel *luxlbl = [[UILabel alloc]init];
    luxlbl.text = [NSString stringWithFormat: @"Last Minute Hidden Deal for Luxury Hotel Stay in %@", self.cityName];
    luxlbl.textAlignment = NSTextAlignmentCenter;
    luxlbl.textColor = [ICSingletonManager colorFromHexString:@"#bd9854"];
    luxlbl.backgroundColor = [UIColor clearColor];
    [baseImageView addSubview:luxlbl];
    
    
    UILabel *midlbl = [[UILabel alloc]init];
    midlbl.textColor = [UIColor whiteColor];
    midlbl.text = @"Pay Only Rs 2,999 (Incl GST), Save upto 50% or more.";
    midlbl.textAlignment = NSTextAlignmentCenter;
    midlbl.backgroundColor = [UIColor clearColor];
    [baseImageView addSubview:midlbl];
    
    UILabel *lowerLbl = [[UILabel alloc]init];
    lowerLbl.textColor = [UIColor whiteColor];
    lowerLbl.text = @"Offer Open for 3 Days Only, Book Now!";
    lowerLbl.textAlignment = NSTextAlignmentCenter;
    lowerLbl.backgroundColor = [UIColor clearColor];
    
    [baseImageView addSubview:lowerLbl];
    
    
    txtFldview = [[UIView alloc]init];
    txtFldview.userInteractionEnabled = YES;
    [_headerBaseView addSubview:txtFldview];
    
    self.cityTxtFld = [[UITextField alloc]init];
    self.cityTxtFld.delegate = self;
    self.cityTxtFld.font = [UIFont systemFontOfSize:24];
    self.cityTxtFld.textColor = [UIColor grayColor];
    self.cityTxtFld.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.cityTxtFld.text = self.cityName;
    UIColor *color = [UIColor grayColor];
    self.cityTxtFld.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter City" attributes:@{NSForegroundColorAttributeName: color}];
    [txtFldview addSubview:self.cityTxtFld];
    
    UIView *narrowGoldLineview = [[UIView alloc]init];
    narrowGoldLineview.backgroundColor = [ICSingletonManager colorFromHexString:@"#BD9854"];
    [txtFldview addSubview:narrowGoldLineview];
    
    [self.cityTxtFld addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UIView *roomBaseView = [[UIView alloc]init];
    roomBaseView.userInteractionEnabled = YES;
    [txtFldview addSubview:roomBaseView];
    
    self.checkNumberOfRooms = [[UITextField alloc]init];
    self.checkNumberOfRooms.delegate = self;
    
    self.checkNumberOfRooms.textColor = [UIColor grayColor];
    self.checkNumberOfRooms.userInteractionEnabled = NO;
    [self.checkNumberOfRooms resignFirstResponder];
    [roomBaseView addSubview:self.checkNumberOfRooms];
    
    self.checkNumberOfRooms.font = [UIFont systemFontOfSize:24];
    
    self.checkNumberOfRooms.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Room(s)" attributes:@{NSForegroundColorAttributeName: color}];
    
    
    UIView *narrowGoldLineview3 = [[UIView alloc]init];
    narrowGoldLineview3.backgroundColor = [ICSingletonManager colorFromHexString:@"#BD9854"];
    [roomBaseView addSubview:narrowGoldLineview3];
    
    [self.checkNumberOfRooms addTarget:self action:@selector(selectRoomTxtFldTapped:) forControlEvents:UIControlEventEditingChanged];
    
    UITapGestureRecognizer *tapRoomTxtField = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectRoomTxtFldTapped:)];
    tapRoomTxtField.numberOfTapsRequired = 1;
    
    [roomBaseView addGestureRecognizer:tapRoomTxtField];
    
    /******************* check out And number of rooms *******************/
    
    cityNameTableView = [[UITableView alloc]init];
    cityNameTableView.delegate = self;
    cityNameTableView.dataSource = self;
    cityNameTableView.hidden = YES;
    
    
    _roomTableView = [[UITableView alloc]init];
    _roomTableView.delegate = self;
    _roomTableView.dataSource = self;
    _roomTableView.hidden = YES;
    
    
    checkInBaseView = [[UIView alloc]init];
    checkInBaseView.backgroundColor = [UIColor colorWithRed:0.9294 green:0.9294 blue:0.9294 alpha:1.0];
    [_headerBaseView addSubview:checkInBaseView];
    
//    UILabel *checkInLbl = [[UILabel alloc]init];
//    checkInLbl.text = @"Check In";
//    checkInLbl.textColor = [UIColor grayColor];
//    checkInLbl.textAlignment = NSTextAlignmentCenter;
//    [checkInBaseView addSubview:checkInLbl];
    
    
    _todayBtn = [[GradientButton alloc]init];
    [_todayBtn setTitle:@"TODAY" forState:UIControlStateNormal];
    [_todayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_todayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    _todayBtn.layer.cornerRadius = 5.0;
    _todayBtn.tag = 10;
    [_todayBtn useRedDeleteStyle];
    [_todayBtn addTarget:self action:@selector(todayBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [checkInBaseView addSubview:_todayBtn];
    
    
    _tomorrowBtn = [[GradientButton alloc]init];
    [_tomorrowBtn setTitle:@"TOMORROW" forState:UIControlStateNormal];
    [_tomorrowBtn setTintColor:[UIColor blackColor]];
    [_tomorrowBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_tomorrowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    _tomorrowBtn.layer.cornerRadius = 5.0;
    _tomorrowBtn.tag = 20;
    [_tomorrowBtn useRedDeleteStyle];
    
    [_tomorrowBtn addTarget:self action:@selector(tomorrowBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [checkInBaseView addSubview:_tomorrowBtn];
    
   
    _dayAfterBtn = [[GradientButton alloc]init];
    [_dayAfterBtn setTitle:@"DAY AFTER" forState:UIControlStateNormal];
    [_dayAfterBtn setTintColor:[UIColor blackColor]];
    [_dayAfterBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_dayAfterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    _dayAfterBtn.layer.cornerRadius = 5.0;
    _dayAfterBtn.tag = 30;
    [_dayAfterBtn useRedDeleteStyle];
    
    [_dayAfterBtn addTarget:self action:@selector(dayAfterBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [checkInBaseView addSubview:_dayAfterBtn];
    
    [_todayBtn setSelected:YES];
    [_tomorrowBtn setSelected:NO];
    [_dayAfterBtn setSelected:NO];
    
    _oneNightBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_oneNightBtn addTarget:self action:@selector(oneNightBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_oneNightBtn setTitle:@"1 NIGHT" forState:UIControlStateNormal];
    [_oneNightBtn setTitleColor:[ICSingletonManager colorFromHexString:@"#bd9854"] forState:UIControlStateNormal];
    _oneNightBtn.backgroundColor = [UIColor clearColor];
    [checkInBaseView addSubview:_oneNightBtn];
    
    _twoNightBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_twoNightBtn addTarget:self action:@selector(twoNightBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_twoNightBtn setTitle:@"2 NIGHTS" forState:UIControlStateNormal];
    [_twoNightBtn setTitleColor:[ICSingletonManager colorFromHexString:@"#bd9854"] forState:UIControlStateNormal];
    _twoNightBtn.backgroundColor = [UIColor clearColor];
    [checkInBaseView addSubview:_twoNightBtn];
    
    
    _threeNightBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_threeNightBtn addTarget:self action:@selector(threeNightBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_threeNightBtn setTitle:@"3 NIGHTS" forState:UIControlStateNormal];
    [_threeNightBtn setTitleColor:[ICSingletonManager colorFromHexString:@"#bd9854"] forState:UIControlStateNormal];
    _threeNightBtn.backgroundColor = [UIColor clearColor];
    [checkInBaseView addSubview:_threeNightBtn];
    
    _oneNightNarrowView = [[UIView alloc]init];
    _oneNightNarrowView.backgroundColor = [ICSingletonManager colorFromHexString:@"#001d3d"];
    [checkInBaseView addSubview:_oneNightNarrowView];
    
    _twoNightNarrowView = [[UIView alloc]init];
    _twoNightNarrowView.backgroundColor = [ICSingletonManager colorFromHexString:@"#001d3d"];
    [checkInBaseView addSubview:_twoNightNarrowView];
    
    _threeNightNarrowView = [[UIView alloc]init];
    _threeNightNarrowView.backgroundColor = [ICSingletonManager colorFromHexString:@"#001d3d"];
    [checkInBaseView addSubview:_threeNightNarrowView];
    
    if (IS_IPAD) {
        
        
        self.topWhiteBaseView.frame = CGRectMake(0, 0,screenRect.size.width , 64);
        self.notificationButton.frame = CGRectMake(self.topWhiteBaseView.frame.size.width - 40 - 10, 20, 24, 24);
        self.logoIconImgView.frame = CGRectMake((self.topWhiteBaseView.frame.size.width - 150)/2, 15, 150, 34);
        self.backButton.frame = CGRectMake(20, 22, 30, 20);
       
        baseImageView.frame =  CGRectMake(10, 0, self.view.frame.size.width - 20 , 0);
        luxlbl.frame = CGRectMake(0, 10, self.view.frame.size.width , 40);
        luxlbl.font = [UIFont systemFontOfSize:24];
        midlbl.frame = CGRectMake(0, luxlbl.frame.size.height + luxlbl.frame.origin.y , self.view.frame.size.width , 25);
        midlbl.font = [UIFont systemFontOfSize:18];
        lowerLbl.frame =    CGRectMake(0, midlbl.frame.size.height + midlbl.frame.origin.y , self.view.frame.size.width , 25);
        lowerLbl.font = [UIFont systemFontOfSize:18];
        
        txtFldview.frame = CGRectMake(20, baseImageView.frame.size.height + baseImageView.frame.origin.y +25 ,self.view.frame.size.width - 40 , 40);
       
        self.cityTxtFld.frame =  CGRectMake(0, 0, txtFldview.frame.size.width *0.6, 25);
        
        narrowGoldLineview.frame = CGRectMake(0, self.cityTxtFld.frame.size.height + self.cityTxtFld.frame.origin.y + 10, txtFldview.frame.size.width *0.6 , 2);
        
        roomBaseView.frame = CGRectMake(txtFldview.frame.size.width *0.7, 0, txtFldview.frame.size.width *0.20, 25);
        self.checkNumberOfRooms.frame = CGRectMake(0, 0, txtFldview.frame.size.width *0.20, 25);
        
        _roomTableView.frame = CGRectMake(txtFldview.frame.size.width *0.7 + 20, txtFldview.frame.size.height + txtFldview.frame.origin.y + self.topWhiteBaseView.frame.size.height, txtFldview.frame.size.width *0.20 , 160);
        narrowGoldLineview3.frame = CGRectMake(0, 35, txtFldview.frame.size.width *0.20, 2);
        
        checkInBaseView.frame = CGRectMake(0, txtFldview.frame.size.height + txtFldview.frame.origin.y, self.view.frame.size.width -20,95);
         _headerBaseView.frame = CGRectMake(10, self.topWhiteBaseView.frame.origin.y + self.topWhiteBaseView.frame.size.height + 10, self.view.frame.size.width - 20, checkInBaseView.frame.size.height + checkInBaseView.frame.origin.y);
        
        _todayBtn.frame = CGRectMake(20,5 ,(checkInBaseView.frame.size.width - 80)/3 , 40);
        _tomorrowBtn.frame = CGRectMake(_todayBtn.frame.size.width + _todayBtn.frame.origin.x + 20,5 ,(checkInBaseView.frame.size.width - 80)/3 , 40);
        _dayAfterBtn.frame = CGRectMake(_tomorrowBtn.frame.size.width + _tomorrowBtn.frame.origin.x + 20, 5 ,(checkInBaseView.frame.size.width - 80)/3 , 40);
        
        _oneNightBtn.frame = CGRectMake(20,_todayBtn.frame.origin.y + _todayBtn.frame.size.height +5 ,(checkInBaseView.frame.size.width - 80)/3 , 30);
        
        _oneNightNarrowView.frame = CGRectMake(20,_oneNightBtn.frame.origin.y + _oneNightBtn.frame.size.height +5 ,(checkInBaseView.frame.size.width - 80)/3 , 2);
        
        _twoNightBtn.frame = CGRectMake(_todayBtn.frame.size.width + _todayBtn.frame.origin.x + 20,_todayBtn.frame.origin.y + _todayBtn.frame.size.height +5 ,(checkInBaseView.frame.size.width - 80)/3 , 30);
        
        
        _twoNightNarrowView.frame = CGRectMake(_todayBtn.frame.size.width + _todayBtn.frame.origin.x + 20,_oneNightBtn.frame.origin.y + _oneNightBtn.frame.size.height +5 ,(checkInBaseView.frame.size.width - 80)/3 , 2);
        
        _threeNightBtn.frame = CGRectMake(_tomorrowBtn.frame.size.width + _tomorrowBtn.frame.origin.x + 20,_todayBtn.frame.origin.y + _todayBtn.frame.size.height +5 ,(checkInBaseView.frame.size.width - 80)/3 , 30);
        _threeNightNarrowView.frame = CGRectMake(_tomorrowBtn.frame.size.width + _tomorrowBtn.frame.origin.x + 20,_oneNightBtn.frame.origin.y + _oneNightBtn.frame.size.height +5 ,(checkInBaseView.frame.size.width - 80)/3 , 2);
        
        cityNameTableView.frame = CGRectMake(20, txtFldview.frame.origin.y +txtFldview.frame.size.height + self.topWhiteBaseView.frame.size.height , narrowGoldLineview.frame.size.width, self.view.frame.size.height * 0.30);
        [_dayAfterBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
        [_tomorrowBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
        [_todayBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
        
    }else{
        self.topWhiteBaseView.frame = CGRectMake(0, 0,screenRect.size.width , 50);
        self.notificationButton.frame = CGRectMake(self.topWhiteBaseView.frame.size.width - 40 - 10, 12, 24, 24);
        self.logoIconImgView.frame = CGRectMake((self.topWhiteBaseView.frame.size.width - 120)/2, 10, 120, 30);
        self.backButton.frame = CGRectMake(20, 15, 30, 20);
        
         baseImageView.frame =  CGRectMake(10, 0, self.view.frame.size.width - 20 , 0);
        luxlbl.frame = CGRectMake(10, 3, baseImageView.frame.size.width -20 , 35);
        luxlbl.numberOfLines = 2;
        luxlbl.lineBreakMode = NSLineBreakByWordWrapping;
        luxlbl.font = [UIFont systemFontOfSize:14];
        luxlbl.textAlignment = NSTextAlignmentCenter;
        midlbl.frame = CGRectMake(10, luxlbl.frame.size.height + luxlbl.frame.origin.y , baseImageView.frame.size.width -20 , 35);
        midlbl.numberOfLines = 2;
        midlbl.lineBreakMode = NSLineBreakByWordWrapping;
        midlbl.font = [UIFont systemFontOfSize:13];
        midlbl.textAlignment = NSTextAlignmentCenter;
        lowerLbl.frame =    CGRectMake(0, midlbl.frame.size.height + midlbl.frame.origin.y , baseImageView.frame.size.width , 25);
        lowerLbl.font = [UIFont systemFontOfSize:13];
        
        txtFldview.frame = CGRectMake(5, baseImageView.frame.size.height + baseImageView.frame.origin.y +10 ,self.view.frame.size.width - 10 , 40);
        self.cityTxtFld.frame =  CGRectMake(0, 0, txtFldview.frame.size.width *0.55, 25);
        narrowGoldLineview.frame = CGRectMake(0, self.cityTxtFld.frame.size.height + self.cityTxtFld.frame.origin.y + 10, txtFldview.frame.size.width *0.55 , 2);
        
        roomBaseView.frame = CGRectMake(txtFldview.frame.size.width *0.6, 0, txtFldview.frame.size.width *0.38, txtFldview.frame.size.height);
        self.checkNumberOfRooms.frame = CGRectMake(0, 0, txtFldview.frame.size.width *0.38, 25);
        narrowGoldLineview3.frame = CGRectMake(0, 35, txtFldview.frame.size.width *0.38, 2);
      
        _roomTableView.frame = CGRectMake(txtFldview.frame.size.width *0.6 +5, txtFldview.frame.size.height + txtFldview.frame.origin.y + self.topWhiteBaseView.frame.size.height, txtFldview.frame.size.width *0.38 , 160);
        
        checkInBaseView.frame = CGRectMake(0, txtFldview.frame.size.height + txtFldview.frame.origin.y, self.view.frame.size.width -20,95);
         _headerBaseView.frame = CGRectMake(10, self.topWhiteBaseView.frame.origin.y + self.topWhiteBaseView.frame.size.height + 10, self.view.frame.size.width - 20, checkInBaseView.frame.size.height + checkInBaseView.frame.origin.y);
       
        _todayBtn.frame = CGRectMake(10,5 ,(checkInBaseView.frame.size.width - 40)/3 , 40);
        _tomorrowBtn.frame = CGRectMake(_todayBtn.frame.size.width + _todayBtn.frame.origin.x + 10, 5 ,(checkInBaseView.frame.size.width - 40)/3 , 40);
        _dayAfterBtn.frame = CGRectMake(_tomorrowBtn.frame.size.width + _tomorrowBtn.frame.origin.x + 10, 5 ,(checkInBaseView.frame.size.width - 40)/3 , 40);
        
        _oneNightBtn.frame = CGRectMake(10,_todayBtn.frame.origin.y + _todayBtn.frame.size.height +5 ,(checkInBaseView.frame.size.width - 40)/3 , 30);
        _twoNightBtn.frame = CGRectMake(_todayBtn.frame.size.width + _todayBtn.frame.origin.x + 10,_todayBtn.frame.origin.y + _todayBtn.frame.size.height +5 ,(checkInBaseView.frame.size.width - 40)/3 , 30);
        _threeNightBtn.frame = CGRectMake(_tomorrowBtn.frame.size.width + _tomorrowBtn.frame.origin.x + 10,_todayBtn.frame.origin.y + _todayBtn.frame.size.height +5 ,(checkInBaseView.frame.size.width - 40)/3 , 30);
        
        _oneNightNarrowView.frame = CGRectMake(20,_oneNightBtn.frame.origin.y + _oneNightBtn.frame.size.height +5 ,(checkInBaseView.frame.size.width - 80)/3 , 2);
        _twoNightNarrowView.frame = CGRectMake(_todayBtn.frame.size.width + _todayBtn.frame.origin.x + 20,_oneNightBtn.frame.origin.y + _oneNightBtn.frame.size.height +5 ,(checkInBaseView.frame.size.width - 80)/3 , 2);
        _threeNightNarrowView.frame = CGRectMake(_tomorrowBtn.frame.size.width + _tomorrowBtn.frame.origin.x + 20,_oneNightBtn.frame.origin.y + _oneNightBtn.frame.size.height +5 ,(checkInBaseView.frame.size.width - 80)/3 , 2);
        
        cityNameTableView.frame = CGRectMake(5, txtFldview.frame.origin.y +txtFldview.frame.size.height + self.topWhiteBaseView.frame.size.height , narrowGoldLineview.frame.size.width,200);
        
        [_dayAfterBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_tomorrowBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_todayBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        
    }
    
    _oneNightNarrowView.hidden = NO;
    _twoNightNarrowView.hidden = YES;
    _threeNightNarrowView.hidden = YES;
    
    [self getHotelList];
    
  
    self.view.backgroundColor = [UIColor whiteColor];
    
   
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
-(void)checkHotelAvailableSoldOutORNot
{
    
    
    //    datePickerBaseView.hidden = YES;
    NSLog(@"%@",selectedCategory);
  //  self.selectDateTxtFld.text = selectedCategory;
    //    self.checkOutTxtField.text = self.checkOutDate
    
    self.manageSeeMoreBtnStr = @"NO";
    
       if (selectCellCityNameTable == 0) {
           selectCellCityNameTable = 1;
       }else{
             [MBProgressHUD showHUDAddedTo:self.view animated:YES];
       }
  
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    NSString *urlStr = [NSString stringWithFormat: @"%@/Api/FAQApi/HotelsByCityPartial?cityId=%@&searchDate=%@&endDate=%@&noOfRooms=%@",kServerUrl,self.cityceo, self.checkInStr,self.checkOutDate, self.numberOfrooms];
    
    [manager POST:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [_soldOutHotelArr removeAllObjects];
        
        NSArray *soldInArr;
        NSArray *soldOutArr;
        if ([kServerUrl isEqualToString:@"http://staging.icanstay.com"]) {
            soldInArr = [responseObject objectForKey:@"LastminutebindNew"];
            soldOutArr= [responseObject objectForKey:@"LastSoldMinute"];
            
        }else if ([kServerUrl isEqualToString:@"http://www.icanstay.com"])
        {
            soldInArr = [responseObject objectForKey:@"StaginLastminutebindNew"];
            soldOutArr= [responseObject objectForKey:@"StaginLastSoldMinute"];
            
        }
        if (manageRoomAndDatePicker == 0) {
            //            checkOutBaseView.hidden = NO;
            //            baseView1.hidden = NO;
            //            checkOutLbl.hidden = NO;
            //            roomLbl.hidden = NO;
            
        }
        manageRoomAndDatePicker = 0;
        managecheckOutCheckInPickerDate = 0;
        //       [_donebtn setEnabled:NO];
        for (id dict in soldInArr) {
            [_soldOutHotelArr addObject:dict];
        }
        for (id dict in soldOutArr) {
            [_soldOutHotelArr addObject:dict];
        }
        
        NSLog(@"responseObject=%@",responseObject);
        
        //        if (IS_IPAD) {
        //            _hotelListTableView.frame = CGRectMake(0, txtFldview.frame.origin.y + txtFldview.frame.size.height+txtFldview.frame.size.height + 30 , self.view.frame.size.width, self.view.frame.size.height - (self.topWhiteBaseView.frame.origin.y + self.topWhiteBaseView.frame.size.height + 130 +txtFldview.frame.size.height + 20 + 70 ));
        //        }else{
        //            _hotelListTableView.frame =    CGRectMake(0, baseView1.frame.origin.y + baseView1.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - (baseView1.frame.origin.y +baseView1.frame.size.height +15));
        //        }
        
       [self.hotelListTableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
      
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:error.localizedDescription onController:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    
    
    
}
-(void)oneNightBtnPressed:(id)sender
{
     selectCellCityNameTable = 1;
    _roomSelected = @"YES";
    if ([_roomSelected isEqualToString:@"NO"]) {
        
               _oneNightNarrowView.hidden = NO;
        _twoNightNarrowView.hidden = YES;
        _threeNightNarrowView.hidden = YES;
        
        
        if ([self.checkInStr isEqualToString:todayDate]) {
            self.checkOutDate = tomorrowDate;
        }else if ([self.checkInStr isEqualToString:tomorrowDate]){
            self.checkOutDate = dayAfterTomorrow;
        }else if ([self.checkInStr isEqualToString:dayAfterTomorrow]){
            self.checkOutDate = dayAfterFourthDate;
        }
        

    //    [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please Select No. Of Rooms" onController:self];
    }else{
    _oneNightNarrowView.hidden = NO;
    _twoNightNarrowView.hidden = YES;
    _threeNightNarrowView.hidden = YES;
    
    if ([self.checkInStr isEqualToString:todayDate]) {
        self.checkOutDate = tomorrowDate;
    }else if ([self.checkInStr isEqualToString:tomorrowDate]){
        self.checkOutDate = dayAfterTomorrow;
    }else if ([self.checkInStr isEqualToString:dayAfterTomorrow]){
        self.checkOutDate = dayAfterFourthDate;
    }
    [self checkHotelAvailableSoldOutORNot];
    }
}
-(void)twoNightBtnPressed:(id)sender
{
    selectCellCityNameTable = 1;
     _roomSelected = @"YES";
    if ([_roomSelected isEqualToString:@"NO"]) {
        _oneNightNarrowView.hidden = YES;
        _twoNightNarrowView.hidden = NO;
        _threeNightNarrowView.hidden = YES;
        
        if ([self.checkInStr isEqualToString:todayDate]) {
            self.checkOutDate = dayAfterTomorrow;
        }else if ([self.checkInStr isEqualToString:tomorrowDate]){
            self.checkOutDate = dayAfterFourthDate;
        }

        [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please Select No. Of Rooms" onController:self];
    }else{
    
        
    _oneNightNarrowView.hidden = YES;
    _twoNightNarrowView.hidden = NO;
    _threeNightNarrowView.hidden = YES;
    
    if ([self.checkInStr isEqualToString:todayDate]) {
        self.checkOutDate = dayAfterTomorrow;
    }else if ([self.checkInStr isEqualToString:tomorrowDate]){
        self.checkOutDate = dayAfterFourthDate;
    }
[self checkHotelAvailableSoldOutORNot];
    }
}
-(void)threeNightBtnPressed:(id)sender
{   selectCellCityNameTable = 1;
     _roomSelected = @"YES";
    if ([_roomSelected isEqualToString:@"NO"]) {
        _oneNightNarrowView.hidden = YES;
        _twoNightNarrowView.hidden = YES;
        _threeNightNarrowView.hidden = NO;
        
        if ([self.checkInStr isEqualToString:todayDate]) {
            self.checkOutDate = dayAfterFourthDate;
        }

        [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please Select No. Of Rooms" onController:self];
    }else{
    _oneNightNarrowView.hidden = YES;
    _twoNightNarrowView.hidden = YES;
    _threeNightNarrowView.hidden = NO;
    
    if ([self.checkInStr isEqualToString:todayDate]) {
        self.checkOutDate = dayAfterFourthDate;
    }
[self checkHotelAvailableSoldOutORNot];
    }
}

-(void)todayBtnTapped:(id)todayBtn
{
    selectCellCityNameTable = 1;
    __weak GradientButton *btn = todayBtn;
      _roomSelected = @"YES";
    if ([_roomSelected isEqualToString:@"NO"]) {


        
        _twoNightBtn.hidden = NO;
        _threeNightBtn.hidden = NO;
        _oneNightNarrowView.hidden = NO;
        _twoNightNarrowView.hidden = YES;
        _threeNightNarrowView.hidden = YES;
  //      [_todayBtn setBackgroundColor:[ICSingletonManager colorFromHexString:@"#bd9854"]];
        _todayBtn.tintColor = [UIColor whiteColor];
    //    [_dayAfterBtn setBackgroundColor:[ICSingletonManager colorFromHexString:@"#ffef9e"]];
        _dayAfterBtn.tintColor = [UIColor blackColor];
    //    [_tomorrowBtn setBackgroundColor:[ICSingletonManager colorFromHexString:@"#ffef9e"]];
        _tomorrowBtn.tintColor = [UIColor blackColor];
        _daySelected = [NSString stringWithFormat:@"%ld", (long)btn.tag];
        self.checkInStr = todayDate;
        self.checkOutDate = tomorrowDate;
    //    [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please Select No. Of Rooms" onController:self];
    }else{
        _roomSelected = @"YES";
        _twoNightBtn.hidden = NO;
        _threeNightBtn.hidden = NO;
        _oneNightNarrowView.hidden = NO;
        _twoNightNarrowView.hidden = YES;
        _threeNightNarrowView.hidden = YES;
        [todayBtn setSelected:YES];
        [_tomorrowBtn setSelected:NO];
        [_dayAfterBtn setSelected:NO];
    //    [_todayBtn setBackgroundColor:[ICSingletonManager colorFromHexString:@"#bd9854"]];
        _todayBtn.tintColor = [UIColor whiteColor];
  //      [_dayAfterBtn setBackgroundColor:[ICSingletonManager colorFromHexString:@"#ffef9e"]];
        _dayAfterBtn.tintColor = [UIColor blackColor];
  //      [_tomorrowBtn setBackgroundColor:[ICSingletonManager colorFromHexString:@"#ffef9e"]];
        _tomorrowBtn.tintColor = [UIColor blackColor];
        _daySelected = [NSString stringWithFormat:@"%ld", (long)btn.tag];
        self.checkInStr = todayDate;
        self.checkOutDate = tomorrowDate;
        NSLog(@"%@", _daySelected);
        
        [self checkHotelAvailableSoldOutORNot];
        
    }
    
}

-(void)tomorrowBtnTapped:(UIButton *)tomorrowBtn
{
    
     selectCellCityNameTable = 1;
      _roomSelected = @"YES";
    if ([_roomSelected isEqualToString:@"NO"]) {
        
        _twoNightBtn.hidden = NO;
        _threeNightBtn.hidden = YES;
        _oneNightNarrowView.hidden = NO;
        _twoNightNarrowView.hidden = YES;
        _threeNightNarrowView.hidden = YES;
        
   //     [_todayBtn setBackgroundColor:[ICSingletonManager colorFromHexString:@"#ffef9e"]];
        _todayBtn.tintColor = [UIColor blackColor];
   //     [_dayAfterBtn setBackgroundColor:[ICSingletonManager colorFromHexString:@"#ffef9e"]];
        _dayAfterBtn.tintColor = [UIColor blackColor];
   //     [_tomorrowBtn setBackgroundColor:[ICSingletonManager colorFromHexString:@"#bd9854"]];
        _tomorrowBtn.tintColor = [UIColor whiteColor];
        
        
        _daySelected = [NSString stringWithFormat:@"%ld", (long)tomorrowBtn.tag];
        self.checkInStr = tomorrowDate;
        self.checkOutDate = dayAfterTomorrow;
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please Select No. Of Rooms" onController:self];
    }else{
        _roomSelected = @"YES";
        _twoNightBtn.hidden = NO;
        _threeNightBtn.hidden = YES;
        _oneNightNarrowView.hidden = NO;
        _twoNightNarrowView.hidden = YES;
        _threeNightNarrowView.hidden = YES;
        [_tomorrowBtn setSelected:YES];
        [_todayBtn setSelected:NO];
        [_dayAfterBtn setSelected:NO];
        
 //       [_todayBtn setBackgroundColor:[ICSingletonManager colorFromHexString:@"#ffef9e"]];
        _todayBtn.tintColor = [UIColor blackColor];
  //      [_dayAfterBtn setBackgroundColor:[ICSingletonManager colorFromHexString:@"#ffef9e"]];
        _dayAfterBtn.tintColor = [UIColor blackColor];
//        [_tomorrowBtn setBackgroundColor:[ICSingletonManager colorFromHexString:@"#bd9854"]];
        _tomorrowBtn.tintColor = [UIColor whiteColor];
      

        _daySelected = [NSString stringWithFormat:@"%ld", (long)tomorrowBtn.tag];
        self.checkInStr = tomorrowDate;
         self.checkOutDate = dayAfterTomorrow;
        NSLog(@"%@", _daySelected);
        [self checkHotelAvailableSoldOutORNot];
    }
    
}

-(void)dayAfterBtnTapped:(UIButton *)dayAfterBtn
{
     selectCellCityNameTable = 1;
      _roomSelected = @"YES";
    if ([_roomSelected isEqualToString:@"NO"]) {
        _twoNightBtn.hidden = YES;
        _threeNightBtn.hidden = YES;
        _oneNightNarrowView.hidden = NO;
        _twoNightNarrowView.hidden = YES;
        _threeNightNarrowView.hidden = YES;
//        [_todayBtn setBackgroundColor:[ICSingletonManager colorFromHexString:@"#ffef9e"]];
        _todayBtn.tintColor = [UIColor blackColor];
//        [_dayAfterBtn setBackgroundColor:[ICSingletonManager colorFromHexString:@"#bd9854"]];
        _dayAfterBtn.tintColor = [UIColor whiteColor];
//        [_tomorrowBtn setBackgroundColor:[ICSingletonManager colorFromHexString:@"#ffef9e"]];
        _tomorrowBtn.tintColor = [UIColor blackColor];
        _daySelected = [NSString stringWithFormat:@"%ld", (long)dayAfterBtn.tag];
        self.checkInStr = dayAfterTomorrow;
        self.checkOutDate = dayAfterFourthDate;
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please Select No. Of Rooms" onController:self];
    }else{
        _roomSelected = @"YES";
        _twoNightBtn.hidden = YES;
        _threeNightBtn.hidden = YES;
        _oneNightNarrowView.hidden = NO;
        _twoNightNarrowView.hidden = YES;
        _threeNightNarrowView.hidden = YES;
        [_tomorrowBtn setSelected:NO];
        [_todayBtn setSelected:NO];
        [_dayAfterBtn setSelected:YES];
 //       [_todayBtn setBackgroundColor:[ICSingletonManager colorFromHexString:@"#ffef9e"]];
        _todayBtn.tintColor = [UIColor blackColor];
//        [_dayAfterBtn setBackgroundColor:[ICSingletonManager colorFromHexString:@"#bd9854"]];
        _dayAfterBtn.tintColor = [UIColor whiteColor];
//        [_tomorrowBtn setBackgroundColor:[ICSingletonManager colorFromHexString:@"#ffef9e"]];
        _tomorrowBtn.tintColor = [UIColor blackColor];
        
      
        _daySelected = [NSString stringWithFormat:@"%ld", (long)dayAfterBtn.tag];
        self.checkInStr = dayAfterTomorrow;
        self.checkOutDate = dayAfterFourthDate;
        NSLog(@"%@", _daySelected);
        
        [self checkHotelAvailableSoldOutORNot];
    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _hotelListTableView) {
        
        NSString *inventoryStr = [NSString stringWithFormat:@"%@",[[_soldOutHotelArr objectAtIndex:indexPath.row] objectForKey:@"inventory"]];
        NSDictionary * CitylistDictionary = [[NSDictionary alloc]init];
        CitylistDictionary = [self.soldOutHotelArr objectAtIndex:indexPath.row];
        
        NSString *htmlStr = [ICSingletonManager getStringValue:[NSString stringWithFormat:@"<html><head><style>@import url('https://fonts.googleapis.com/css?family=Gotham');ul{list-style:none;padding: 1px 0px 0px 0px; }ul li {background-image: url(http://www.icanstay.com/Content/Home/images/rev-slider/dot.png);  background-repeat: no-repeat; background-position: 0 0px; padding: 0px 10px 12px 18px; background-size: 13px;font-size: 16px; color:#808080; line-height: 17px; font-family:Josefin Sans, Verdana, Segoe, sans-serif;}</style></head><body bgcolor=\"#ffffff\" >%@</body></html>",[CitylistDictionary objectForKey:@"HotelBulletContent"]]];
        
        NSAttributedString *attributedText = [self getHTMLAttributedString:htmlStr];
        
        
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                
                CGSize size = CGSizeMake(self.hotelListTableView.frame.size.width - 20 -10, CGFLOAT_MAX);
                CGRect paragraphRect =     [attributedText boundingRectWithSize:size
                                                                        options:(NSStringDrawingUsesLineFragmentOrigin)
                                                                        context:nil];
                
                if ([inventoryStr isEqualToString:@"0"]) {
                    return 360 + paragraphRect.size.height;
                }else{
                    return 395 + paragraphRect.size.height;
                }
            }else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
              
                CGSize size = CGSizeMake(self.hotelListTableView.frame.size.width - 300 -20 - 20, CGFLOAT_MAX);
                CGRect paragraphRect =     [attributedText boundingRectWithSize:size
                                                                        options:(NSStringDrawingUsesLineFragmentOrigin)
                                                                        context:nil];
                
                if ([inventoryStr isEqualToString:@"0"]) {
                    return 110 + paragraphRect.size.height +20 + 10;
                }else{
                    return 145 + paragraphRect.size.height + 20 + 10;
                }
                
               
            
        }
       
    }else if (tableView == cityNameTableView ){
        return 60;
    }else if (tableView == _roomTableView){
        return 40;
    }
   
    return 0;
}
// number of row in the section, I assume there is only 1 row
- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    if (theTableView == self.hotelListTableView) {
        
       
            return self.soldOutHotelArr.count;
     
    }else if (theTableView == cityNameTableView){
        return self.filteredCityList.count;
    }else if (theTableView == _roomTableView){
        return 4;
    }
    return 0;
}

// the cell will be returned to the tableView
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (theTableView ==  self.hotelListTableView) {
        
       
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            NSString *inventoryStr = [NSString stringWithFormat:@"%@",[[_soldOutHotelArr objectAtIndex:indexPath.row] objectForKey:@"inventory"]];
            NSDictionary * CitylistDictionary = [[NSDictionary alloc]init];
            CitylistDictionary = [self.soldOutHotelArr objectAtIndex:indexPath.row];
            
            NSString *htmlStr = [ICSingletonManager getStringValue:[NSString stringWithFormat:@"<html><head><style>@import url('https://fonts.googleapis.com/css?family=Gotham');ul{list-style:none;padding: 1px 0px 0px 0px; }ul li {background-image: url(http://www.icanstay.com/Content/Home/images/rev-slider/dot.png);  background-repeat: no-repeat; background-position: 0 0px; padding: 0px 10px 12px 18px; background-size: 13px;font-size: 16px; color:#808080; line-height: 17px; font-family:Josefin Sans, Verdana, Segoe, sans-serif;}</style></head><body bgcolor=\"#ffffff\" >%@</body></html>",[CitylistDictionary objectForKey:@"HotelBulletContent"]]];
            
            NSAttributedString *attributedText = [self getHTMLAttributedString:htmlStr];
            
            
            CGSize size = CGSizeMake(self.hotelListTableView.frame.size.width - 300 - 20 - 20, CGFLOAT_MAX);
            CGRect paragraphRect =     [attributedText boundingRectWithSize:size
                                                                    options:(NSStringDrawingUsesLineFragmentOrigin)
                                                                    context:nil];
            
            if ([inventoryStr isEqualToString:@"0"]) {
                
                static NSString *CellIdentifier1      = @"SoldOutCell";
                IphoneSoldInTableViewCell *cell           = [[IphoneSoldInTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                                             reuseIdentifier:CellIdentifier1];
                
                
                [[cell contentView] setFrame:[cell bounds]];
                [[cell contentView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
                cell.frame = CGRectMake(0, 0, self.hotelListTableView.frame.size.width, 110 + paragraphRect.size.height + 20 + 10);
                cell.baseView.frame = CGRectMake(10, 10, cell.frame.size.width - 20, 90 + paragraphRect.size.height + 20 +10);
                cell.hotelImageView.frame = CGRectMake(0, 0, 300 ,60 + paragraphRect.size.height);
                cell.hotelNameLbl.frame = CGRectMake(cell.hotelImageView.frame.size.width, 10, cell.baseView.frame.size.width - cell.hotelImageView.frame.size.width , 20);
                cell.hotelDetailwebView.frame = CGRectMake(cell.hotelImageView.frame.size.width +5,cell.hotelNameLbl.frame.origin.y + cell.hotelNameLbl.frame.size.height + 5 ,self.hotelListTableView.frame.size.width - 300 - 20 - 20 , paragraphRect.size.height + 20);
          
                cell.actualAndOfferPriceLbl.frame = CGRectMake(10, cell.hotelDetailwebView.frame.origin.y + cell.hotelDetailwebView.frame.size.height + 15, cell.baseView.frame.size.width - 20, 20);
                cell.actualAndOfferPriceLbl.textAlignment = NSTextAlignmentLeft;
                cell.narrowLinePriceBaseView.frame = CGRectMake(0,cell.actualAndOfferPriceLbl.frame.origin.y +9,42 , 2);
                cell.narrowLinePriceBaseView.hidden = YES;
                cell.actualAndOfferPriceLbl.hidden= YES;
             
                cell.seeMoreButton.frame = CGRectMake((cell.baseView.frame.size.width - 460)/3, cell.hotelDetailwebView.frame.origin.y + cell.hotelDetailwebView.frame.size.height + 15, 230, 40);
                cell.bookNowButon.frame = CGRectMake(((cell.baseView.frame.size.width - 460)/3)*2 +230 , cell.hotelDetailwebView.frame.origin.y + cell.hotelDetailwebView.frame.size.height + 15, 230, 40);
                cell.bookNowButon.hidden = YES;
                cell.soldOutImgView.frame = CGRectMake(((cell.baseView.frame.size.width - 460)/3)*2 +230 , cell.hotelDetailwebView.frame.origin.y + cell.hotelDetailwebView.frame.size.height + 15, 230, 40);
                cell.soldOutImgView.hidden = NO;
                
                cell.seeMoreButton.tag = kTagCellCountryCheckboxBtn;
                [cell.seeMoreButton addTarget:self action:@selector(seeMoreBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.bookNowButon.tag = kTagCellBookNowBtn;
                [cell.bookNowButon addTarget:self action:@selector(bookNowBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
                
                NSString *urlForImgRemovingSpace =[self getURLFromString:[CitylistDictionary objectForKey:@"img1"]];
                [cell.hotelImageView setImageWithURL:[NSURL URLWithString:urlForImgRemovingSpace] placeholderImage:nil];
                [cell.hotelNameLbl setText:[CitylistDictionary objectForKey:@"HotelName"]];
                cell.narrowLinePriceBaseView.hidden = YES;
                NSString *htmlStr = [ICSingletonManager getStringValue:[NSString stringWithFormat:@"<html><head><style>@import url('https://fonts.googleapis.com/css?family=Gotham');ul{list-style:none;padding: 1px 0px 0px 0px; }ul li {background-image: url(http://www.icanstay.com/Content/Home/images/rev-slider/dot.png);  background-repeat: no-repeat; background-position: 0 0px; padding: 0px 10px 12px 18px; background-size: 13px;font-size: 16px; color:#808080; line-height: 17px; font-family:Josefin Sans, Verdana, Segoe, sans-serif;}</style></head><body bgcolor=\"#ffffff\" >%@</body></html>",[CitylistDictionary objectForKey:@"HotelBulletContent"]]];
                
                [cell.hotelDetailwebView loadHTMLString:[NSString stringWithFormat:@"%@", htmlStr ]baseURL:nil];
                NSString *actualPrice =  [NSString stringWithFormat:@"₹%@",[CitylistDictionary objectForKey:@"ICS_Price"]];
                NSString *offerPrice = [NSString stringWithFormat:@"%@",[CitylistDictionary objectForKey:@"ICS_offer_Price"]];
                NSString *priceLblStr = [NSString stringWithFormat:@"%@ %@ per night", actualPrice, offerPrice];
                cell.actualAndOfferPriceLbl.text = priceLblStr;
                cell.soldOutImgView.image = [UIImage imageNamed:@"soldOutImage"];
                
                cell.seeMoreButton.hotelIdStr = [NSString stringWithFormat:@"%@", [CitylistDictionary  objectForKey:@"HOTEL_ID"]];
                cell.bookNowButon.hotelIdStr = [NSString stringWithFormat:@"%@", [CitylistDictionary  objectForKey:@"HOTEL_ID"]];
                cell.bookNowButon.hotelOfferPrice = [NSString stringWithFormat:@"%@", [CitylistDictionary  objectForKey:@"ICS_offer_Price"]];
                cell.bookNowButon.cityCeo = [NSString stringWithFormat:@"%@", [CitylistDictionary  objectForKey:@"City_alt_Name"]];
                cell.bookNowButon.cityID = [NSString stringWithFormat:@"%@", [CitylistDictionary  objectForKey:@"CITY_ID"]];
                
                cell.baseView.hotelIdStr = [NSString stringWithFormat:@"%@", [CitylistDictionary  objectForKey:@"HOTEL_ID"]];
                UITapGestureRecognizer *cellGesture =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)]; // this is the current problem like a lot of people out there...
                cellGesture.numberOfTapsRequired = 1;
                
                [cell.baseView addGestureRecognizer:cellGesture];
                
                return cell;
            }else{
                static NSString *CellIdentifier2      = @"SolInCell";
                IphoneSoldInTableViewCell *cell           = [[IphoneSoldInTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                                             reuseIdentifier:CellIdentifier2];
                
                [[cell contentView] setFrame:[cell bounds]];
                [[cell contentView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
                
                
                cell.frame = CGRectMake(0, 0, self.hotelListTableView.frame.size.width, 145 + paragraphRect.size.height + 20 + 10);
                cell.baseView.frame = CGRectMake(10, 10, cell.frame.size.width - 20, 125 + paragraphRect.size.height + 20 + 10);
                cell.hotelImageView.frame = CGRectMake(0, 0, 300 , paragraphRect.size.height + 60);
                cell.hotelNameLbl.frame = CGRectMake(cell.hotelImageView.frame.size.width + 10, 10, cell.baseView.frame.size.width - cell.hotelImageView.frame.size.width - 10 , 20);
                cell.hotelDetailwebView.frame = CGRectMake(cell.hotelImageView.frame.size.width + 5,cell.hotelNameLbl.frame.origin.y + cell.hotelNameLbl.frame.size.height + 5 ,self.hotelListTableView.frame.size.width - 300 - 20 - 20 , paragraphRect.size.height + 20);
                
                cell.actualAndOfferPriceLbl.frame = CGRectMake(cell.hotelImageView.frame.size.width +10, cell.hotelDetailwebView.frame.origin.y + cell.hotelDetailwebView.frame.size.height + 15, cell.baseView.frame.size.width - cell.hotelImageView.frame.size.width + 10, 25);
                cell.actualAndOfferPriceLbl.textAlignment = NSTextAlignmentLeft;
                cell.narrowLinePriceBaseView.frame = CGRectMake(cell.hotelImageView.frame.size.width +10 ,cell.actualAndOfferPriceLbl.frame.origin.y +13,50 , 2);
                cell.narrowLinePriceBaseView.hidden = NO;
                cell.actualAndOfferPriceLbl.hidden= NO;
                
                cell.seeMoreButton.frame = CGRectMake((cell.baseView.frame.size.width - 460)/3, cell.actualAndOfferPriceLbl.frame.origin.y + cell.actualAndOfferPriceLbl.frame.size.height + 5, 230, 40);
                cell.bookNowButon.frame = CGRectMake(((cell.baseView.frame.size.width - 460)/3)*2 +260 , cell.actualAndOfferPriceLbl.frame.origin.y + cell.actualAndOfferPriceLbl.frame.size.height + 5, 230, 40);
                cell.bookNowButon.hidden = NO;
                cell.soldOutImgView.frame = CGRectMake(((cell.baseView.frame.size.width - 460)/3)*2 +230 , cell.actualAndOfferPriceLbl.frame.origin.y + cell.actualAndOfferPriceLbl.frame.size.height + 5, 230, 40);
                 cell.soldOutImgView.hidden =YES;
                
                
                cell.seeMoreButton.tag = kTagCellCountryCheckboxBtn;
                [cell.seeMoreButton addTarget:self action:@selector(seeMoreBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.bookNowButon.tag = kTagCellBookNowBtn;
                [cell.bookNowButon addTarget:self action:@selector(bookNowBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
                
                
                NSString *urlForImgRemovingSpace =[self getURLFromString:[CitylistDictionary objectForKey:@"img1"]];
                [cell.hotelImageView setImageWithURL:[NSURL URLWithString:urlForImgRemovingSpace] placeholderImage:nil];
                [cell.hotelNameLbl setText:[CitylistDictionary objectForKey:@"HotelName"]];
                cell.narrowLinePriceBaseView.hidden = NO;
                NSString *htmlStr = [ICSingletonManager getStringValue:[NSString stringWithFormat:@"<html><head><style>@import url('https://fonts.googleapis.com/css?family=Gotham');ul{list-style:none;padding: 1px 0px 0px 0px; }ul li {background-image: url(http://www.icanstay.com/Content/Home/images/rev-slider/dot.png);  background-repeat: no-repeat; background-position: 0 0px; padding: 0px 10px 12px 18px; background-size: 13px;font-size: 16px; color:#808080; line-height: 17px; font-family:Josefin Sans, Verdana, Segoe, sans-serif;}</style></head><body bgcolor=\"#ffffff\" >%@</body></html>",[CitylistDictionary objectForKey:@"HotelBulletContent"]]];
                
                [cell.hotelDetailwebView loadHTMLString:[NSString stringWithFormat:@"%@", htmlStr ]baseURL:nil];
                NSString *actualPrice =  [NSString stringWithFormat:@"₹%@",[CitylistDictionary objectForKey:@"ICS_Price"]];
                NSString *offerPrice = [NSString stringWithFormat:@"%@",[CitylistDictionary objectForKey:@"ICS_offer_Price"]];
                NSString *priceLblStr = [NSString stringWithFormat:@"%@ ₹%@ per night", actualPrice, offerPrice];
                
                
                
                NSMutableAttributedString *text =[[NSMutableAttributedString alloc] initWithString:priceLblStr];
                
                [text addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0,6 )];
                [text addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:24.0]
                             range:NSMakeRange(6, 6)];
                [text addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:18.0]
                             range:NSMakeRange(12, 9)];
                
                
                
                cell.actualAndOfferPriceLbl.attributedText = text;
                cell.soldOutImgView.image = [UIImage imageNamed:@"soldOutImage"];
                cell.seeMoreButton.hotelIdStr = [NSString stringWithFormat:@"%@", [CitylistDictionary  objectForKey:@"HOTEL_ID"]];
                cell.bookNowButon.hotelIdStr = [NSString stringWithFormat:@"%@", [CitylistDictionary  objectForKey:@"HOTEL_ID"]];
                cell.bookNowButon.hotelOfferPrice = [NSString stringWithFormat:@"%@", [CitylistDictionary  objectForKey:@"ICS_offer_Price"]];
                
                cell.bookNowButon.cityCeo = [NSString stringWithFormat:@"%@", [CitylistDictionary  objectForKey:@"City_alt_Name"]];
                cell.bookNowButon.cityID = [NSString stringWithFormat:@"%@", [CitylistDictionary  objectForKey:@"CITY_ID"]];
                cell.baseView.hotelIdStr = [NSString stringWithFormat:@"%@", [CitylistDictionary  objectForKey:@"HOTEL_ID"]];
                UITapGestureRecognizer *cellGesture =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)]; // this is the current problem like a lot of people out there...
                cellGesture.numberOfTapsRequired = 1;
                
                [cell.baseView addGestureRecognizer:cellGesture];
                return cell;
            }
            
        }else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
         
            NSString *inventoryStr = [NSString stringWithFormat:@"%@",[[_soldOutHotelArr objectAtIndex:indexPath.row] objectForKey:@"inventory"]];
            NSDictionary * CitylistDictionary = [[NSDictionary alloc]init];
            CitylistDictionary = [self.soldOutHotelArr objectAtIndex:indexPath.row];
            
            NSString *htmlStr = [ICSingletonManager getStringValue:[NSString stringWithFormat:@"<html><head><style>@import url('https://fonts.googleapis.com/css?family=Gotham');ul{list-style:none;padding: 1px 0px 0px 0px; }ul li {background-image: url(http://www.icanstay.com/Content/Home/images/rev-slider/dot.png);  background-repeat: no-repeat; background-position: 0 0px; padding: 0px 10px 12px 18px; background-size: 13px;font-size: 16px; color:#808080; line-height: 17px; font-family:Josefin Sans, Verdana, Segoe, sans-serif;}</style></head><body bgcolor=\"#ffffff\" >%@</body></html>",[CitylistDictionary objectForKey:@"HotelBulletContent"]]];
            
            NSAttributedString *attributedText = [self getHTMLAttributedString:htmlStr];
            
                CGSize size = CGSizeMake(self.hotelListTableView.frame.size.width - 20 -10, CGFLOAT_MAX);
                CGRect paragraphRect =     [attributedText boundingRectWithSize:size
                                                                        options:(NSStringDrawingUsesLineFragmentOrigin)
                                                                        context:nil];
                    
                    if ([inventoryStr isEqualToString:@"0"]) {
                        
                        static NSString *CellIdentifier1      = @"SoldOutCell";
                        IphoneSoldInTableViewCell *cell           = [[IphoneSoldInTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                                                     reuseIdentifier:CellIdentifier1];
                      

                            [[cell contentView] setFrame:[cell bounds]];
                            [[cell contentView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
                            cell.frame = CGRectMake(0, 0, self.hotelListTableView.frame.size.width, 360 + paragraphRect.size.height);
                            cell.baseView.frame = CGRectMake(10, 10, cell.frame.size.width - 20, 360 + paragraphRect.size.height - 20);
                            cell.hotelImageView.frame = CGRectMake(0, 0, cell.baseView.frame.size.width , 200);
                            cell.hotelNameLbl.frame = CGRectMake(10, cell.hotelImageView.frame.origin.y + cell.hotelImageView.frame.size.height + 10, cell.baseView.frame.size.width - 20, 20);
                            cell.hotelDetailwebView.frame = CGRectMake(5,cell.hotelNameLbl.frame.origin.y + cell.hotelNameLbl.frame.size.height + 10 ,self.hotelListTableView.frame.size.width - 20 -10 , paragraphRect.size.height + 20);
                            cell.actualAndOfferPriceLbl.frame = CGRectMake(10, cell.hotelDetailwebView.frame.origin.y + cell.hotelDetailwebView.frame.size.height + 10, cell.baseView.frame.size.width - 20, 20);
                            cell.actualAndOfferPriceLbl.textAlignment = NSTextAlignmentLeft;
                             cell.narrowLinePriceBaseView.frame = CGRectMake(18,cell.actualAndOfferPriceLbl.frame.origin.y +9,42 , 2);
                            cell.narrowLinePriceBaseView.hidden = YES;
                           cell.actualAndOfferPriceLbl.hidden= YES;
                            cell.seeMoreButton.frame = CGRectMake((cell.baseView.frame.size.width - 260)/3, cell.hotelDetailwebView.frame.origin.y + cell.hotelDetailwebView.frame.size.height + 10, 130, 40);
                             cell.bookNowButon.frame = CGRectMake(((cell.baseView.frame.size.width - 260)/3)*2 +130 , cell.hotelDetailwebView.frame.origin.y + cell.hotelDetailwebView.frame.size.height + 10, 130, 40);
                            cell.bookNowButon.hidden = YES;
                            cell.soldOutImgView.frame = CGRectMake(((cell.baseView.frame.size.width - 260)/3)*2 +130 , cell.hotelDetailwebView.frame.origin.y + cell.hotelDetailwebView.frame.size.height + 10, 130, 40);
                            cell.soldOutImgView.hidden = NO;
                            
                            cell.seeMoreButton.tag = kTagCellCountryCheckboxBtn;
                            [cell.seeMoreButton addTarget:self action:@selector(seeMoreBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
                            
                            cell.bookNowButon.tag = kTagCellBookNowBtn;
                            [cell.bookNowButon addTarget:self action:@selector(bookNowBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
                     
                        NSString *urlForImgRemovingSpace =[self getURLFromString:[CitylistDictionary objectForKey:@"img1"]];
                        [cell.hotelImageView setImageWithURL:[NSURL URLWithString:urlForImgRemovingSpace] placeholderImage:nil];
                        [cell.hotelNameLbl setText:[CitylistDictionary objectForKey:@"HotelName"]];
                          cell.narrowLinePriceBaseView.hidden = YES;
                        NSString *htmlStr = [ICSingletonManager getStringValue:[NSString stringWithFormat:@"<html><head><style>@import url('https://fonts.googleapis.com/css?family=Gotham');ul{list-style:none;padding: 1px 0px 0px 0px; }ul li {background-image: url(http://www.icanstay.com/Content/Home/images/rev-slider/dot.png);  background-repeat: no-repeat; background-position: 0 0px; padding: 0px 10px 12px 18px; background-size: 13px;font-size: 16px; color:#808080; line-height: 17px; font-family:Josefin Sans, Verdana, Segoe, sans-serif;}</style></head><body bgcolor=\"#ffffff\" >%@</body></html>",[CitylistDictionary objectForKey:@"HotelBulletContent"]]];
                        
                        [cell.hotelDetailwebView loadHTMLString:[NSString stringWithFormat:@"%@", htmlStr ]baseURL:nil];
                        NSString *actualPrice =  [NSString stringWithFormat:@"₹%@",[CitylistDictionary objectForKey:@"ICS_Price"]];
                        NSString *offerPrice = [NSString stringWithFormat:@"%@",[CitylistDictionary objectForKey:@"ICS_offer_Price"]];
                        NSString *priceLblStr = [NSString stringWithFormat:@"%@ %@ per night", actualPrice, offerPrice];
                        cell.actualAndOfferPriceLbl.text = priceLblStr;
                        cell.soldOutImgView.image = [UIImage imageNamed:@"soldOutImage"];
                        
                        cell.seeMoreButton.hotelIdStr = [NSString stringWithFormat:@"%@", [CitylistDictionary  objectForKey:@"HOTEL_ID"]];
                        cell.bookNowButon.hotelIdStr = [NSString stringWithFormat:@"%@", [CitylistDictionary  objectForKey:@"HOTEL_ID"]];
                        cell.bookNowButon.hotelOfferPrice = [NSString stringWithFormat:@"%@", [CitylistDictionary  objectForKey:@"ICS_offer_Price"]];
                        cell.bookNowButon.cityCeo = [NSString stringWithFormat:@"%@", [CitylistDictionary  objectForKey:@"City_alt_Name"]];
                        cell.bookNowButon.cityID = [NSString stringWithFormat:@"%@", [CitylistDictionary  objectForKey:@"CITY_ID"]];
                        
                        cell.baseView.hotelIdStr = [NSString stringWithFormat:@"%@", [CitylistDictionary  objectForKey:@"HOTEL_ID"]];
                        UITapGestureRecognizer *cellGesture =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)]; // this is the current problem like a lot of people out there...
                        cellGesture.numberOfTapsRequired = 1;
                        
                        [cell.baseView addGestureRecognizer:cellGesture];
                        
                        return cell;
                    }else{
                        static NSString *CellIdentifier2      = @"SolInCell";
                        IphoneSoldInTableViewCell *cell           = [[IphoneSoldInTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                                                     reuseIdentifier:CellIdentifier2];
                    
                            [[cell contentView] setFrame:[cell bounds]];
                            [[cell contentView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
                            cell.frame = CGRectMake(0, 0, self.hotelListTableView.frame.size.width, 395 + paragraphRect.size.height);
                            cell.baseView.frame = CGRectMake(10, 10, cell.frame.size.width - 20, 390 + paragraphRect.size.height - 20);
                            cell.hotelImageView.frame = CGRectMake(0, 0, cell.baseView.frame.size.width , 200);
                            cell.hotelNameLbl.frame = CGRectMake(10, cell.hotelImageView.frame.origin.y + cell.hotelImageView.frame.size.height + 10, cell.baseView.frame.size.width - 20, 20);
                            cell.hotelDetailwebView.frame = CGRectMake(5,cell.hotelNameLbl.frame.origin.y + cell.hotelNameLbl.frame.size.height + 10 ,self.hotelListTableView.frame.size.width - 20 -10 , paragraphRect.size.height + 20);
                             cell.actualAndOfferPriceLbl.frame = CGRectMake(10, cell.hotelDetailwebView.frame.origin.y + cell.hotelDetailwebView.frame.size.height + 10, cell.baseView.frame.size.width - 20, 25);
                            cell.actualAndOfferPriceLbl.textAlignment = NSTextAlignmentLeft;
                            cell.actualAndOfferPriceLbl.hidden= NO;
                            cell.narrowLinePriceBaseView.frame = CGRectMake(0,cell.actualAndOfferPriceLbl.frame.origin.y +14,50 , 2);
                            cell.narrowLinePriceBaseView.hidden = NO;
                            cell.seeMoreButton.frame = CGRectMake((cell.baseView.frame.size.width - 260)/3, cell.actualAndOfferPriceLbl.frame.origin.y + cell.actualAndOfferPriceLbl.frame.size.height + 10, 130, 40);
                            cell.bookNowButon.frame = CGRectMake(((cell.baseView.frame.size.width - 260)/3)*2 +130 , cell.actualAndOfferPriceLbl.frame.origin.y + cell.actualAndOfferPriceLbl.frame.size.height + 10, 130, 40);
                            cell.bookNowButon.hidden = NO;
                            cell.soldOutImgView.frame = CGRectMake(((cell.baseView.frame.size.width - 260)/3)*2 +130 , cell.actualAndOfferPriceLbl.frame.origin.y + cell.actualAndOfferPriceLbl.frame.size.height + 10, 130, 40);
                            cell.soldOutImgView.hidden =YES;
                            
                            cell.seeMoreButton.tag = kTagCellCountryCheckboxBtn;
                            [cell.seeMoreButton addTarget:self action:@selector(seeMoreBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
                            
                            cell.bookNowButon.tag = kTagCellBookNowBtn;
                            [cell.bookNowButon addTarget:self action:@selector(bookNowBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
                        
                        
                        NSString *urlForImgRemovingSpace =[self getURLFromString:[CitylistDictionary objectForKey:@"img1"]];
                        [cell.hotelImageView setImageWithURL:[NSURL URLWithString:urlForImgRemovingSpace] placeholderImage:nil];
                        [cell.hotelNameLbl setText:[CitylistDictionary objectForKey:@"HotelName"]];
                          cell.narrowLinePriceBaseView.hidden = NO;
                        NSString *htmlStr = [ICSingletonManager getStringValue:[NSString stringWithFormat:@"<html><head><style>@import url('https://fonts.googleapis.com/css?family=Gotham');ul{list-style:none;padding: 1px 0px 0px 0px; }ul li {background-image: url(http://www.icanstay.com/Content/Home/images/rev-slider/dot.png);  background-repeat: no-repeat; background-position: 0 0px; padding: 0px 10px 12px 18px; background-size: 13px;font-size: 16px; color:#808080; line-height: 17px; font-family:Josefin Sans, Verdana, Segoe, sans-serif;}</style></head><body bgcolor=\"#ffffff\" >%@</body></html>",[CitylistDictionary objectForKey:@"HotelBulletContent"]]];
                        
                        [cell.hotelDetailwebView loadHTMLString:[NSString stringWithFormat:@"%@", htmlStr ]baseURL:nil];
                        NSString *actualPrice =  [NSString stringWithFormat:@"₹%@",[CitylistDictionary objectForKey:@"ICS_Price"]];
                        NSString *offerPrice = [NSString stringWithFormat:@"%@",[CitylistDictionary objectForKey:@"ICS_offer_Price"]];
                        NSString *priceLblStr = [NSString stringWithFormat:@"%@ ₹%@ per night", actualPrice, offerPrice];
                        
                      
                        
                        NSMutableAttributedString *text =[[NSMutableAttributedString alloc] initWithString:priceLblStr];
                        
                        [text addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0,6 )];
                        [text addAttribute:NSFontAttributeName
                                     value:[UIFont systemFontOfSize:24.0]
                                     range:NSMakeRange(6, 6)];
                        [text addAttribute:NSFontAttributeName
                                     value:[UIFont systemFontOfSize:18.0]
                                     range:NSMakeRange(12, 9)];
                        
                        
                        
                        cell.actualAndOfferPriceLbl.attributedText = text;
                        cell.soldOutImgView.image = [UIImage imageNamed:@"soldOutImage"];
                        cell.seeMoreButton.hotelIdStr = [NSString stringWithFormat:@"%@", [CitylistDictionary  objectForKey:@"HOTEL_ID"]];
                        cell.bookNowButon.hotelIdStr = [NSString stringWithFormat:@"%@", [CitylistDictionary  objectForKey:@"HOTEL_ID"]];
                        cell.bookNowButon.hotelOfferPrice = [NSString stringWithFormat:@"%@", [CitylistDictionary  objectForKey:@"ICS_offer_Price"]];
                        
                        cell.bookNowButon.cityCeo = [NSString stringWithFormat:@"%@", [CitylistDictionary  objectForKey:@"City_alt_Name"]];
                        cell.bookNowButon.cityID = [NSString stringWithFormat:@"%@", [CitylistDictionary  objectForKey:@"CITY_ID"]];
                        cell.baseView.hotelIdStr = [NSString stringWithFormat:@"%@", [CitylistDictionary  objectForKey:@"HOTEL_ID"]];
                        UITapGestureRecognizer *cellGesture =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)]; // this is the current problem like a lot of people out there...
                        cellGesture.numberOfTapsRequired = 1;
                        
                        [cell.baseView addGestureRecognizer:cellGesture];
                        return cell;
                    }
            
        }
    
    }else if (theTableView == cityNameTableView){
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
    }else if (theTableView == _roomTableView){
        static NSString *cellIdentifier = @"roomCell";
        
        
        UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:
                                 cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:
                    UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        [cell.textLabel setText:[_roomTableViewArr objectAtIndex:indexPath.row]];
        return cell;
    }
    return nil;
}

-(NSString *)getURLFromString:(NSString *)str{
    
    NSString *urlStr = [str stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    return urlStr;
}

-(NSAttributedString *) getHTMLAttributedString:(NSString *) string {
    NSError *errorFees=nil;
    NSString *sourceFees = [NSString stringWithFormat:
                            @"<span style=\"font-family: 'JosefinSans-Light';font-size: 18px\">%@</span>",string];
    NSMutableAttributedString* strFees = [[NSMutableAttributedString alloc] initWithData:[sourceFees dataUsingEncoding:NSUTF8StringEncoding]
                                                                                 options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                           NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]}
                                                                      documentAttributes:nil error:&errorFees];
    return strFees;
    
}
-(void)cellTapped:(UIGestureRecognizer *)gesture
{
    NSLog(@"CellTapped");
   __weak BaseView *view = gesture.view; //cast pointer to the derived class if needed
    
    NSString *hotelId = [NSString stringWithFormat:@"%@", view.hotelIdStr];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    NSString *url;
    if ([kServerUrl isEqualToString:@"http://staging.icanstay.com"]) {
        url =   [NSString stringWithFormat:@"%@/api/FAQApi/GetCityDetailsByCityIdApi?CityID=%@",kServerUrl,self.cityId];
    }else if ([kServerUrl isEqualToString:@"http://www.icanstay.com"])
    {
        
        url =   [NSString stringWithFormat:@"%@/api/FAQApi/GetCityDetailsByCityIdApiLastMinute?CityId=%@",kServerUrl,self.cityId];
        
    }
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        NSMutableDictionary   *arrayHotelList = [[NSMutableDictionary alloc]init];
        NSMutableDictionary   *availableAmenties = [[NSMutableDictionary alloc]init];
        
        if ([kServerUrl isEqualToString:@"http://staging.icanstay.com"]) {
            for (id dict in [responseObject objectForKey:@"OrderCityWiseHotels1"]) {
                if ([[NSString stringWithFormat:@"%@",[dict objectForKey:@"Hotel_Id"] ] isEqualToString:hotelId]) {
                    arrayHotelList = dict;
                }
            }
            
            for (id dict in [responseObject objectForKey:@"OrderCityAvailableAmenities"]) {
                if ([[NSString stringWithFormat:@"%@",[dict objectForKey:@"Hid"] ] isEqualToString:hotelId]) {
                    availableAmenties = dict;
                }
            }
        }else if ([kServerUrl isEqualToString:@"http://www.icanstay.com"])
        {
            for (id dict in [responseObject objectForKey:@"OrderCityWiseHotels1"]) {
                if ([[NSString stringWithFormat:@"%@",[dict objectForKey:@"Hotel_Id"] ] isEqualToString:hotelId]) {
                    arrayHotelList = dict;
                }
            }
            
            for (id dict in [responseObject objectForKey:@"OrderCityAvailableAmenities"]) {
                if ([[NSString stringWithFormat:@"%@",[dict objectForKey:@"Hid"] ] isEqualToString:hotelId]) {
                    availableAmenties = dict;
                }
            }
            
            
        }
        
        if ([[NSString stringWithFormat:@"%@",[arrayHotelList objectForKey:@"Hotel_Id"] ] isEqualToString:hotelId]) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            LastMinuteHotelDetailViewController  *lastMinuteDetails =[storyboard instantiateViewControllerWithIdentifier:@"LastMinuteHotelDetailViewController"];
            lastMinuteDetails.hotelDetailDict = arrayHotelList;
            lastMinuteDetails.amentieDetailsDict = availableAmenties;
            lastMinuteDetails.cityName = [arrayHotelList  objectForKey:@"City"];
            lastMinuteDetails.hotelId = [NSString stringWithFormat:@"%@",[arrayHotelList objectForKey:@"Hotel_Id"] ];
            
            lastMinuteDetails.cityId = [NSString stringWithFormat:@"%@",[arrayHotelList objectForKey:@"CityId"] ];
            
            for (id dict  in self.hotelListArr) {
                if ([[NSString stringWithFormat:@"%@", [dict objectForKey:@"HOTEL_ID"]] isEqualToString: hotelId]) {
                     lastMinuteDetails.actualPrice = [NSString stringWithFormat:@"₹%@  ₹%@",[dict objectForKey:@"ICS_Price"],[dict objectForKey:@"ICS_offer_Price"]];
                    lastMinuteDetails.offerPrice = [NSString stringWithFormat:@"%@",[dict objectForKey:@"ICS_offer_Price"]];
                    lastMinuteDetails.offerPriceHotelRoom = [dict objectForKey:@"ICS_offer_Price"];
                    lastMinuteDetails.hotelTitle = [dict objectForKey:@"HotelName"];
                    
                }
            }
            
            
            if ([_manageSeeMoreBtnStr isEqualToString:@"YES"]) {
                lastMinuteDetails.manageSeeMoreHideObjects = @"YES";
            }else{
                lastMinuteDetails.manageSeeMoreHideObjects = @"NO";
            }
            
            NSString *inventoryStr;
            NSDictionary * CitylistDictionary = [[NSDictionary alloc]init];
            if ([_soldOutHotelArr count] > 0) {
                
                for (id dict  in _soldOutHotelArr) {
                    if ([[NSString stringWithFormat:@"%@", [dict objectForKey:@"HOTEL_ID"]] isEqualToString: hotelId]) {
                        CitylistDictionary = dict;
                        inventoryStr = [NSString stringWithFormat:@"%@",[CitylistDictionary objectForKey:@"inventory"]];
                    }
                }
                
                
            }else{
                inventoryStr = @"0";
            }
            
            
            if ([inventoryStr isEqualToString:@"0"]) {
                lastMinuteDetails.soldOutHotel = @"YES";
            }else{
                lastMinuteDetails.soldOutHotel = @"NO";
            }
            
            lastMinuteDetails.checkInDate = self.checkInStr;
            lastMinuteDetails.checkoutDate = self.checkOutDate;
            lastMinuteDetails.noOfRomms = self.numberOfrooms;
            
            [self.navigationController pushViewController:lastMinuteDetails animated:YES];
            
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            
        }else{
            [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Hotel Id Not match" onController:self];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:error.localizedDescription onController:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    
}

-(void)seeMoreBtnTapped:(seeMoreBtn *)seeMoreBtnCell
{
  //  NSIndexPath *indexPath = [self getButtonIndexPath:sender];

    
    NSString *hotelId = seeMoreBtnCell.hotelIdStr;
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    NSString *url;
    if ([kServerUrl isEqualToString:@"http://staging.icanstay.com"]) {
      url =   [NSString stringWithFormat:@"%@/api/FAQApi/GetCityDetailsByCityIdApi?CityID=%@",kServerUrl,self.cityId];
    }else if ([kServerUrl isEqualToString:@"http://www.icanstay.com"])
    {

        url =   [NSString stringWithFormat:@"%@/api/FAQApi/GetCityDetailsByCityIdApiLastMinute?CityId=%@",kServerUrl,self.cityId];
        
    }
    
      [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
          NSMutableDictionary   *arrayHotelList = [[NSMutableDictionary alloc]init];
          NSMutableDictionary   *availableAmenties = [[NSMutableDictionary alloc]init];
          
          if ([kServerUrl isEqualToString:@"http://staging.icanstay.com"]) {
              for (id dict in [responseObject objectForKey:@"OrderCityWiseHotels1"]) {
                  if ([[NSString stringWithFormat:@"%@",[dict objectForKey:@"Hotel_Id"] ] isEqualToString:hotelId]) {
                      arrayHotelList = dict;
                  }
              }
              
              for (id dict in [responseObject objectForKey:@"OrderCityAvailableAmenities"]) {
                  if ([[NSString stringWithFormat:@"%@",[dict objectForKey:@"Hid"] ] isEqualToString:hotelId]) {
                      availableAmenties = dict;
                  }
              }
          }else if ([kServerUrl isEqualToString:@"http://www.icanstay.com"])
          {
              for (id dict in [responseObject objectForKey:@"OrderCityWiseHotels1"]) {
                  if ([[NSString stringWithFormat:@"%@",[dict objectForKey:@"Hotel_Id"] ] isEqualToString:hotelId]) {
                      arrayHotelList = dict;
                  }
              }
              
              for (id dict in [responseObject objectForKey:@"OrderCityAvailableAmenities"]) {
                  if ([[NSString stringWithFormat:@"%@",[dict objectForKey:@"Hid"] ] isEqualToString:hotelId]) {
                      availableAmenties = dict;
                  }
              }

              
          }
          
          if ([[NSString stringWithFormat:@"%@",[arrayHotelList objectForKey:@"Hotel_Id"] ] isEqualToString:hotelId]) {
              UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
              LastMinuteHotelDetailViewController  *lastMinuteDetails =[storyboard instantiateViewControllerWithIdentifier:@"LastMinuteHotelDetailViewController"];
              lastMinuteDetails.hotelDetailDict = arrayHotelList;
              lastMinuteDetails.amentieDetailsDict = availableAmenties;
              lastMinuteDetails.cityName = [arrayHotelList  objectForKey:@"City"];
              lastMinuteDetails.hotelId = [NSString stringWithFormat:@"%@",[arrayHotelList objectForKey:@"Hotel_Id"] ];
              
                lastMinuteDetails.cityId = [NSString stringWithFormat:@"%@",[arrayHotelList objectForKey:@"CityId"] ];
              
              for (id dict  in self.hotelListArr) {
                  if ([[NSString stringWithFormat:@"%@", [dict objectForKey:@"HOTEL_ID"]] isEqualToString: hotelId]) {
                      lastMinuteDetails.actualPrice = [NSString stringWithFormat:@"₹%@  ₹%@",[dict objectForKey:@"ICS_Price"],[dict objectForKey:@"ICS_offer_Price"]];
                      lastMinuteDetails.offerPrice = [NSString stringWithFormat:@"%@",[dict objectForKey:@"ICS_offer_Price"]];
                      lastMinuteDetails.offerPriceHotelRoom = [dict objectForKey:@"ICS_offer_Price"];
                        lastMinuteDetails.hotelTitle = [dict objectForKey:@"HotelName"];
                      
                  }
              }
             
              
              if ([_manageSeeMoreBtnStr isEqualToString:@"YES"]) {
                  lastMinuteDetails.manageSeeMoreHideObjects = @"YES";
                  
              }else{
                  lastMinuteDetails.manageSeeMoreHideObjects = @"NO";
                  lastMinuteDetails.checkInDate = self.checkInStr;
                  lastMinuteDetails.checkoutDate = self.checkOutDate;
                  lastMinuteDetails.noOfRomms = self.numberOfrooms;
              }
              
              NSString *inventoryStr;
              NSDictionary * CitylistDictionary = [[NSDictionary alloc]init];
              if ([_soldOutHotelArr count] > 0) {
                  
                   for (id dict  in _soldOutHotelArr) {
                        if ([[NSString stringWithFormat:@"%@", [dict objectForKey:@"HOTEL_ID"]] isEqualToString: hotelId]) {
                            CitylistDictionary = dict;
                            inventoryStr = [NSString stringWithFormat:@"%@",[CitylistDictionary objectForKey:@"inventory"]];
                        }
                   }
                  
                 
              }else{
                  inventoryStr = @"0";
              }
              
              
              if ([inventoryStr isEqualToString:@"0"]) {
                  lastMinuteDetails.soldOutHotel = @"YES";
              }else{
                  lastMinuteDetails.soldOutHotel = @"NO";
              }
              
              
            
              [self.navigationController pushViewController:lastMinuteDetails animated:YES];
              
              
              [MBProgressHUD hideHUDForView:self.view animated:YES];

              
          }else{
              [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Hotel Id Not match" onController:self];
              [MBProgressHUD hideHUDForView:self.view animated:YES];

          }
          
          
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:error.localizedDescription onController:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
     
}



-(void)bookNowBtnTapped:(BookNowBtn *)bookNowBtnCell
{
    
     NSString *hotelId    = bookNowBtnCell.hotelIdStr;
     NSString *offerPrice = bookNowBtnCell.hotelOfferPrice;
     NSString  *cityCeo   = bookNowBtnCell.cityCeo;
     NSString   *cityId   = bookNowBtnCell.cityID;
     ICSingletonManager *globals = [ICSingletonManager sharedManager];
   
    
   UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    lastMinuteDealBookNowController  *lastMinuteDetails =[storyboard instantiateViewControllerWithIdentifier:@"lastMinuteDealBookNowController"];
    lastMinuteDetails.checkInDate = self.checkInStr;
    lastMinuteDetails.checkoutDate = self.checkOutDate;
    lastMinuteDetails.noOfRomms = self.numberOfrooms;
    int totalAmount = [self.numberOfrooms intValue];
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"dd-MMM-yyyy"];
    NSDate *startDate = [f dateFromString:self.checkInStr];
    NSDate *endDate = [f dateFromString:self.checkOutDate];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:0];
    
    NSLog(@"%ld", [components day]);
    
    int numberOfDaysBwchekInAndOut = [components day];
    lastMinuteDetails.totalAmount = [NSString stringWithFormat:@"%d", totalAmount* [offerPrice intValue] *numberOfDaysBwchekInAndOut];
    lastMinuteDetails.cityId =  cityId;
    lastMinuteDetails.cityName = self.cityName;
    lastMinuteDetails.cityCeo = cityCeo;
    lastMinuteDetails.hotelId = hotelId;
    lastMinuteDetails.offerPrice = offerPrice;
    lastMinuteDetails.userCanCashAmountAvail = globals.userCancashAmountAvailable;
    [self.navigationController pushViewController:lastMinuteDetails animated:YES];
}

-(NSIndexPath *) getButtonIndexPath:(UIButton *) button
{
    CGRect buttonFrame = [button convertRect:button.bounds toView:self.hotelListTableView];
    return [self.hotelListTableView indexPathForRowAtPoint:buttonFrame.origin];
}
#pragma mark - UITableViewDelegate

// when user tap the row, what action you want to perform
- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (theTableView == _hotelListTableView) {
        
        
        UITableViewCell *cell = [theTableView cellForRowAtIndexPath:indexPath];
         NSString *hotelId = [NSString stringWithFormat:@"%ld", (long)cell.tag];

        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                         forHTTPHeaderField:@"Content-Type"];
        NSString *url;
        if ([kServerUrl isEqualToString:@"http://staging.icanstay.com"]) {
            url =   [NSString stringWithFormat:@"%@/api/FAQApi/GetCityDetailsByCityIdApi?CityID=%@",kServerUrl,self.cityId];
        }else if ([kServerUrl isEqualToString:@"http://www.icanstay.com"])
        {
            
            url =   [NSString stringWithFormat:@"%@/api/FAQApi/GetCityDetailsByCityIdApiLastMinute?CityId=%@",kServerUrl,self.cityId];
            
        }
        
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"responseObject=%@",responseObject);
            
            NSMutableDictionary   *arrayHotelList = [[NSMutableDictionary alloc]init];
            NSMutableDictionary   *availableAmenties = [[NSMutableDictionary alloc]init];
            
            if ([kServerUrl isEqualToString:@"http://staging.icanstay.com"]) {
                for (id dict in [responseObject objectForKey:@"OrderCityWiseHotels1"]) {
                    if ([[NSString stringWithFormat:@"%@",[dict objectForKey:@"Hotel_Id"] ] isEqualToString:hotelId]) {
                        arrayHotelList = dict;
                    }
                }
                
                for (id dict in [responseObject objectForKey:@"OrderCityAvailableAmenities"]) {
                    if ([[NSString stringWithFormat:@"%@",[dict objectForKey:@"Hid"] ] isEqualToString:hotelId]) {
                        availableAmenties = dict;
                    }
                }
            }else if ([kServerUrl isEqualToString:@"http://www.icanstay.com"])
            {
                for (id dict in [responseObject objectForKey:@"OrderCityWiseHotels1"]) {
                    if ([[NSString stringWithFormat:@"%@",[dict objectForKey:@"Hotel_Id"] ] isEqualToString:hotelId]) {
                        arrayHotelList = dict;
                    }
                }
                
                for (id dict in [responseObject objectForKey:@"OrderCityAvailableAmenities"]) {
                    if ([[NSString stringWithFormat:@"%@",[dict objectForKey:@"Hid"] ] isEqualToString:hotelId]) {
                        availableAmenties = dict;
                    }
                }
                
                
            }
            
            if ([[NSString stringWithFormat:@"%@",[arrayHotelList objectForKey:@"Hotel_Id"] ] isEqualToString:hotelId]) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                LastMinuteHotelDetailViewController  *lastMinuteDetails =[storyboard instantiateViewControllerWithIdentifier:@"LastMinuteHotelDetailViewController"];
                lastMinuteDetails.hotelDetailDict = arrayHotelList;
                lastMinuteDetails.amentieDetailsDict = availableAmenties;
                lastMinuteDetails.cityName = [arrayHotelList  objectForKey:@"City"];
                lastMinuteDetails.hotelId = [NSString stringWithFormat:@"%@",[arrayHotelList objectForKey:@"Hotel_Id"] ];
                
                lastMinuteDetails.cityId = [NSString stringWithFormat:@"%@",[arrayHotelList objectForKey:@"CityId"] ];
                
                for (id dict  in self.hotelListArr) {
                    if ([[NSString stringWithFormat:@"%@", [dict objectForKey:@"HOTEL_ID"]] isEqualToString: hotelId]) {
                        lastMinuteDetails.actualPrice = [NSString stringWithFormat:@"Actual Price  ₹%@",[dict objectForKey:@"ICS_Price"]];
                        lastMinuteDetails.offerPrice = [NSString stringWithFormat:@"Offer Price  ₹%@",[dict objectForKey:@"ICS_offer_Price"]];
                        lastMinuteDetails.offerPriceHotelRoom = [dict objectForKey:@"ICS_offer_Price"];
                        lastMinuteDetails.hotelTitle = [dict objectForKey:@"HotelName"];
                        
                    }
                }
                
                
                if ([_manageSeeMoreBtnStr isEqualToString:@"YES"]) {
                    lastMinuteDetails.manageSeeMoreHideObjects = @"YES";
                    
                }else{
                    lastMinuteDetails.manageSeeMoreHideObjects = @"NO";
                    lastMinuteDetails.checkInDate = self.checkInStr;
                    lastMinuteDetails.checkoutDate = self.checkOutDate;
                    lastMinuteDetails.noOfRomms = self.numberOfrooms;
                }
                
                NSString *inventoryStr;
                NSDictionary * CitylistDictionary = [[NSDictionary alloc]init];
                if ([_soldOutHotelArr count] > 0) {
                    
                    for (id dict  in _soldOutHotelArr) {
                        if ([[NSString stringWithFormat:@"%@", [dict objectForKey:@"HOTEL_ID"]] isEqualToString: hotelId]) {
                            CitylistDictionary = dict;
                            inventoryStr = [NSString stringWithFormat:@"%@",[CitylistDictionary objectForKey:@"inventory"]];
                        }
                    }
                    
                    
                }else{
                    inventoryStr = @"0";
                }
                
                
                if ([inventoryStr isEqualToString:@"0"]) {
                    lastMinuteDetails.soldOutHotel = @"YES";
                }else{
                    lastMinuteDetails.soldOutHotel = @"NO";
                }
                
                
                
                [self.navigationController pushViewController:lastMinuteDetails animated:YES];
                
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                
            }else{
                [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Hotel Id Not match" onController:self];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failure");
            
            [[ICSingletonManager sharedManager]showAlertViewWithMsg:error.localizedDescription onController:self];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        }];

        
    }else if (theTableView == cityNameTableView) {
        isFilter = YES;
        //     checkOutBaseView.hidden = YES;
   //     checkOutLbl.hidden = YES;
  //      roomLbl.hidden = YES;
     //   baseView1.hidden = YES;
        _roomSelected = @"YES";
        [_todayBtn setSelected:YES];
        [_tomorrowBtn setSelected:NO];
        [_dayAfterBtn setSelected:NO];
         _checkNumberOfRooms.text = [_roomTableViewArr objectAtIndex:0];
        _checkNumberOfRooms.text = [_roomTableViewArr objectAtIndex:0];
        NSString *roomstr = [_roomTableViewArr objectAtIndex:0];
        _numberOfrooms = [roomstr substringToIndex:1];
        cityNameTableSelectArr = [self.filteredCityList objectAtIndex:indexPath.row];
        self.cityTxtFld.text = [ICSingletonManager getStringValue:[cityNameTableSelectArr objectForKey:@"City"]];
         selectCellCityNameTable = 1;
       self.manageSeeMoreBtnStr = @"YES";
        
        self.cityceo = [ICSingletonManager getStringValue:[cityNameTableSelectArr objectForKey:@"Cityseo"]];
        self.cityId =  [cityNameTableSelectArr objectForKey:@"CityId"];
     
        [self getHotelList];
        cityNameTableView.hidden = YES;
        _roomTableView.hidden = YES;
        [self.cityTxtFld resignFirstResponder];
        
    }else if (theTableView == _roomTableView){
        
         selectCellCityNameTable = 1;
        _roomSelected = @"YES";
        [_todayBtn setSelected:YES];
        [_tomorrowBtn setSelected:NO];
        [_dayAfterBtn setSelected:NO];
        _checkNumberOfRooms.text = [_roomTableViewArr objectAtIndex:indexPath.row];
        NSString *roomstr = [_roomTableViewArr objectAtIndex:indexPath.row];
        _numberOfrooms = [roomstr substringToIndex:1];
     //   [_todayBtn setBackgroundColor:[UIColor colorWithRed:0.6406 green:0.4727 blue:0.0000 alpha:1.0]];
        _todayBtn.tintColor = [UIColor whiteColor];

        _roomTableView.hidden = YES;
        cityNameTableView.hidden = YES;
        [self checkHotelAvailableSoldOutORNot];
        
    }
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
-(void)textFieldDidChange:(UITextField*)textField
{
    searchTextString = textField.text;
    [self updateSearchArray];
}



-(void)selectRoomTxtFldTapped:(UIGestureRecognizer *)gestureReconizer
{
    
  
    _roomTableView.hidden = NO;
    
}


-(void)getHotelList
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    NSString *url = [NSString stringWithFormat: @"%@/Api/FAQApi/ShortContentofDestinationsApi?cityName=%@",kServerUrl, self.cityceo];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        if ([kServerUrl isEqualToString:@"http://staging.icanstay.com"]) {
             _hotelListArr = [responseObject objectForKey:@"LastSoldMinute"];
        }else if ([kServerUrl isEqualToString:@"http://www.icanstay.com"])
        {
            _hotelListArr = [responseObject objectForKey:@"StagingLastSoldMinute"];
            
        }
        
        if (selectCellCityNameTable == 0) {
            
      //      ParallaxHeaderView *headerView = [ParallaxHeaderView parallaxHeaderViewWithSubView:_headerBaseView];
           // headerView.headerTitleLabel.text = self.story[@"story"];
            
       //     [_hotelListTableView setTableHeaderView:headerView];
            _hotelListTableView = [[UITableView alloc]init];
            _hotelListTableView.delegate = self;
            _hotelListTableView.dataSource = self;
            _hotelListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            _hotelListTableView.allowsSelection = NO;
            
            if (IS_IPAD) {
                _hotelListTableView.frame = CGRectMake(0, (_headerBaseView.frame.size.height + _headerBaseView.frame.origin.y) , self.view.frame.size.width, self.view.frame.size.height - (_headerBaseView.frame.size.height + _headerBaseView.frame.origin.y));
            }else{
                _hotelListTableView.frame =    CGRectMake(0, (_headerBaseView.frame.size.height + _headerBaseView.frame.origin.y), self.view.frame.size.width, self.view.frame.size.height - (_headerBaseView.frame.size.height + _headerBaseView.frame.origin.y));
            }
            
            [self.view addSubview:_hotelListTableView];
            
            [self.view addSubview:cityNameTableView];
            
            
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"dd-MMM-yyyy";
            todayDate = [formatter stringFromDate:[NSDate date]];
            
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
            dateFormatter.dateFormat = @"dd-MMM-yyyy";
            NSDate *dateObjectForDecrement=[dateFormatter dateFromString:todayDate];
            
            NSDate *dateAfterDecrement=[dateObjectForDecrement addTimeInterval: + (24*60*60)];
            NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
            [dateformate setDateFormat:@"dd-MMM-yyyy"]; // Date formater
            tomorrowDate = [dateformate stringFromDate:dateAfterDecrement];
            
            NSDate *dateAfterDecrementTwoDays=[dateObjectForDecrement addTimeInterval: + (24*60*60 *2)];
            NSDateFormatter *dateformateT=[[NSDateFormatter alloc]init];
            [dateformateT setDateFormat:@"dd-MMM-yyyy"]; // Date formater
            dayAfterTomorrow = [dateformate stringFromDate:dateAfterDecrementTwoDays];
            
            NSDate *dateAfterDecrementThreeDays=[dateObjectForDecrement addTimeInterval: + (24*60*60 *3)];
            NSDateFormatter *dateformateT1=[[NSDateFormatter alloc]init];
            [dateformateT1 setDateFormat:@"dd-MMM-yyyy"]; // Date formater
            dayAfterFourthDate = [dateformate stringFromDate:dateAfterDecrementThreeDays];
            
            
            
            selectedCategory = todayDate;
            self.checkInStr = todayDate;
            self.checkOutDate = tomorrowDate;
            self.numberOfrooms = @"1";
            self.checkNumberOfRooms.text = [_roomTableViewArr objectAtIndex:0];
            [self.view addSubview:_roomTableView];
            _roomTableView.hidden = YES;
              _roomSelected = @"YES";
          
           [self checkHotelAvailableSoldOutORNot];
           
            
        }else if (selectCellCityNameTable == 1){
            
            if (IS_IPAD) {
                _hotelListTableView.frame = CGRectMake(0, (_headerBaseView.frame.size.height + _headerBaseView.frame.origin.y) , self.view.frame.size.width, self.view.frame.size.height - (_headerBaseView.frame.size.height + _headerBaseView.frame.origin.y));
                
            }else{
                _hotelListTableView.frame =    CGRectMake(0, (_headerBaseView.frame.size.height + _headerBaseView.frame.origin.y), self.view.frame.size.width, self.view.frame.size.height - (_headerBaseView.frame.size.height + _headerBaseView.frame.origin.y));
            }
            
           
            self.checkOutDate = tomorrowDate;
            self.checkInStr = todayDate;
            _roomSelected = @"NO";
            _oneNightNarrowView.hidden = NO;
            _twoNightNarrowView.hidden = YES;
            _threeNightNarrowView.hidden = YES;
            _oneNightBtn.hidden = NO;
            _twoNightBtn.hidden = NO;
            _threeNightBtn.hidden = NO;
             [MBProgressHUD hideHUDForView:self.view animated:YES];
               [self checkHotelAvailableSoldOutORNot];
             [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        
        
 
        
        
     
       
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:error.localizedDescription onController:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)backButtonTapped:(id)sender
{
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    if ([globals.isFromDeepLinkToPackageScreen isEqualToString:@"YES"]) {
        globals.isFromDeepLinkToPackageScreen = @"NO";
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
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}
- (void)pushToDashBoardScreenAfterLoggingIn
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    DashboardScreen *dashboardScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"DashboardScreen"];
    [self.mm_drawerController setCenterViewController:dashboardScreen withCloseAnimation:NO completion:nil];
}





@end
