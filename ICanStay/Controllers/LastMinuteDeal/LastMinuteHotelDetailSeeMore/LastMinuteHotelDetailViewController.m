//
//  LastMinuteHotelDetailViewController.m
//  ICanStay
//
//  Created by Planet on 6/16/17.
//  Copyright © 2017 verticallogics. All rights reserved.
//

#import "LastMinuteHotelDetailViewController.h"
#import "NotificationScreen.h"
#import "HomeScreenController.h"
#import "SideMenuController.h"
#import "KIImagePager.h"
#import "AppDelegate.h"
#import "CollectionViewCell.h"
#import <GoogleMaps/GoogleMaps.h>
#import "BuyCouponViewController.h"
#import "lastMinuteDealBookNowController.h"

@interface LastMinuteHotelDetailViewController ()<KIImagePagerDelegate, KIImagePagerDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    UILabel                *cityName;
    UIView                 *datePickerBaseView;
    UIPickerView           *pickerView;
    NSString               *selectedCategory;
    NSMutableDictionary    *inventoryAvailableDatePicker;
    NSString               *isFromdateSelect;
    int                    selectCellCityNameTable;
    UIView                 *selectDatebaseView;
    NSMutableArray         *arr_amenties;
    GMSCircle              *circ;
    GMSMapView             *mapView;
    int                    managecheckOutCheckInPickerDate;
    int                    manageRoomAndDatePicker;
    NSMutableArray         *checkInPickerDateArr;
    NSMutableArray         *checkOutPickerDateArr;
    UITextView            *hotelDetailTxtView;
    
    UIView                *checkOutBaseView;
    UIView                *baseView1;
    UILabel               *acceptLabel;
    UIButton              *bookNowBtn;
    UILabel               *actualPriceLbl;
    UILabel               *offerPriceLbl;
    UIView                *baseView;
    UIWebView             *webView;
    UIView                *narrowAcualPriceLineView;
    UIView                *narrrowLineView1;
    UIView                *narrrowLineView2;
    UILabel               *totalAmountLbl;
    UIImageView           *rightClickImgView ;
    UILabel               *soldOutLbl;
    UIButton              *baseBookNowBtn;
    NSString              *bookNowBtnTitleStr;
    UIView                *bestRateGaurentedBaseView;
     UIView                *howDoWeGetDealBaseView;
    UIView                 *HowDoWeGetView;
    UIView                 *bsetRateView;
    UIView                 *dealNarrowView;
    UILabel                *DealLbl;
    UIView                 *checkInOutRoomHeadingBaseView;
    UILabel                *checkInheadingLbl;
    UILabel                *checkOutHeadingLbl;
    UILabel                *roomHeadingLbl;
    int totalPriceAmount;

}
@property (nonatomic, strong) UIScrollView   *baseScrollView;
@property (nonatomic, strong) UIView         *topWhiteBaseView;
@property (nonatomic, strong) UIButton       *backButton;
@property (nonatomic, strong) UIButton       *notificationButton;
@property (nonatomic, strong) UIImageView    *logoIconImgView;
@property (nonatomic, strong) NSMutableDictionary *hotelDetailDict1;
@property (nonatomic, strong) NSMutableArray        *imgArray;
@property (nonatomic, strong) KIImagePager      *imagePager;
@property (nonatomic, strong) UITextField    *selectDateTxtFld;
@property (nonatomic, strong) NSMutableArray  *soldOutHotelArr;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView          *checkOutAndRoomBaseView;
@property (nonatomic, strong) UITextField    *checkOutTxtField;
@property (nonatomic, strong) UITextField    *checkNumberOfRooms;
@property (nonatomic, strong) UIButton       *donebtn;
@property (nonatomic, strong) NSArray        *roomTableViewArr;
@property (nonatomic, strong) UIView         *acceptBookNowBtnBaseView;
@property NSString                           *numberOfrooms;
@property NSString                           *checkOutDate;
@property (nonatomic, strong) UIView         *midDateBookNowBtnBaseView;

@end

@implementation LastMinuteHotelDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
       DLog(@"DEBUG-VC");
    _soldOutHotelArr = [[NSMutableArray alloc]init];
    AppDelegate *delegate =   (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.fromPageScrollController  = @"NO";
    
    managecheckOutCheckInPickerDate = 0;
    manageRoomAndDatePicker = 0;
     selectCellCityNameTable = 0;
    
    self.roomTableViewArr = [[NSArray alloc]initWithObjects:@"Select Rooms",@"1",@"2",@"3",@"4", nil];
       
    CGRect screenRect = [[UIScreen mainScreen] bounds];

     _imgArray        = [[NSMutableArray alloc]init];
    
    self.topWhiteBaseView = [[UIView alloc]init];
    self.topWhiteBaseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topWhiteBaseView];
    
    self.notificationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
   
    [self.notificationButton setBackgroundImage:[UIImage imageNamed:@"notification1"] forState:UIControlStateNormal];
    [self.notificationButton addTarget:self action:@selector(notificationButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
 //   [self.topWhiteBaseView addSubview:self.notificationButton];
    
    self.logoIconImgView = [[UIImageView alloc]init];
    self.logoIconImgView.image = [UIImage imageNamed:@"topBanner"];
    [self.topWhiteBaseView addSubview:self.logoIconImgView];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
   
    [self.backButton setBackgroundImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.topWhiteBaseView addSubview:self.backButton];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.topWhiteBaseView.frame = CGRectMake(0, 0,screenRect.size.width , 64);
         self.notificationButton.frame = CGRectMake(self.topWhiteBaseView.frame.size.width - 40 - 10, 20, 24, 24);
        self.logoIconImgView.frame =CGRectMake((self.topWhiteBaseView.frame.size.width - 150)/2, 15, 150, 34);
         self.backButton.frame = CGRectMake(20, 22, 30, 20);
    }else{
        self.topWhiteBaseView.frame = CGRectMake(0, 0,screenRect.size.width , 50);
        self.notificationButton.frame = CGRectMake(self.topWhiteBaseView.frame.size.width - 40 - 10, 12, 24, 24);
        self.logoIconImgView.frame = CGRectMake((self.topWhiteBaseView.frame.size.width - 120)/2, 10, 120, 30);
        self.backButton.frame = CGRectMake(20, 15, 30, 20);

    }
    
    _baseScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.topWhiteBaseView.frame.size.height + self.topWhiteBaseView.frame.origin.y , screenRect.size.width, (screenRect.size.height - (self.topWhiteBaseView.frame.size.height + self.topWhiteBaseView.frame.origin.y)))];
    [self.view addSubview:_baseScrollView];
    [self setUpDesignScrollView];
    
    
}

-(void)setUpDesignScrollView
{
    
    UIImageView *baseImageView = [[UIImageView alloc]init];
    baseImageView.image = [UIImage imageNamed:@"PackageBaseImg"];
    [self.baseScrollView addSubview:baseImageView];
    
  
    UILabel *luxHotel = [[UILabel alloc]init];
    luxHotel.text = self.hotelTitle;
    luxHotel.textAlignment = NSTextAlignmentCenter;
    luxHotel.textColor =  [ICSingletonManager colorFromHexString:@"#bd9854"];
    [baseImageView addSubview:luxHotel];
    
    cityName = [[UILabel alloc]initWithFrame:CGRectMake(0, luxHotel.frame.size.height + luxHotel.frame.origin.y, self.baseScrollView.frame.size.width - 20, 30)];
    cityName.textAlignment = NSTextAlignmentCenter;
    cityName.text = self.cityName;
    cityName.font = [UIFont systemFontOfSize:24];
    cityName.textColor =  [ICSingletonManager colorFromHexString:@"#bd9854"];
  //  [baseImageView addSubview:cityName];
 
    /************ BestRate Guarntee ************************/
    bestRateGaurentedBaseView = [[UIView alloc]init];
    bestRateGaurentedBaseView.backgroundColor = [UIColor clearColor];
    [self.baseScrollView addSubview:bestRateGaurentedBaseView];
    
    UIImageView *rightSelectImgView = [[UIImageView alloc]init];
    rightSelectImgView.image = [UIImage imageNamed:@"checkbox_selected"];
    [bestRateGaurentedBaseView addSubview:rightSelectImgView];
    
    UILabel *bestRateLbl = [[UILabel alloc]init];
    bestRateLbl.text = @"Best Rate Guarantee";
    bestRateLbl.textColor = [ICSingletonManager colorFromHexString:@"#bd9854"];
    [bestRateGaurentedBaseView addSubview:bestRateLbl];
   
    UIView *bestRateGuarnteeNarrowView = [[UIView alloc]init];
    bestRateGuarnteeNarrowView.backgroundColor = [ICSingletonManager colorFromHexString:@"#bd9854"];
  //  [bestRateGaurentedBaseView addSubview:bestRateGuarnteeNarrowView];
    
    UITapGestureRecognizer *bestRateTapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(bestRateTapGestureTapped:)];
    bestRateTapGesture.numberOfTapsRequired = 1;
    [bestRateGaurentedBaseView addGestureRecognizer:bestRateTapGesture];
 
     /************ BestRate Guarntee ************************/
    
    _imagePager  = [[KIImagePager alloc]init];
    _imagePager.pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
    _imagePager.pageControl.pageIndicatorTintColor = [UIColor blackColor];
    _imagePager.slideshowTimeInterval = 4.0f;
    _imagePager.slideshowShouldCallScrollToDelegate = YES;
    _imagePager.delegate = self;
    _imagePager.dataSource = self;
  
    [self.baseScrollView addSubview:_imagePager];
    
    if (IS_IPAD) {
        baseImageView.frame = CGRectMake(10, 0, self.view.frame.size.width - 20, 50);
         luxHotel.frame = CGRectMake(0, 5, baseImageView.frame.size.width, 30);
        bestRateGaurentedBaseView.frame =  CGRectMake(self.baseScrollView.frame.size.width-10-185,baseImageView.frame.origin.y + baseImageView.frame.size.height +5 , 185, 30);
        rightSelectImgView.frame = CGRectMake(0, 5, 20, 20);
        bestRateLbl.frame = CGRectMake(23, 0, 185 - 25, 25);
        bestRateGuarnteeNarrowView.frame = CGRectMake(0, 26, 185, 2);
        
        _imagePager.frame = CGRectMake(20,baseImageView.frame.origin.y + baseImageView.frame.size.height +40 ,self.baseScrollView.frame.size.width - 40,400);
        luxHotel.font = [UIFont systemFontOfSize:24];

    }else{
        baseImageView.frame = CGRectMake(10, 0, self.view.frame.size.width - 20, 40);
//        luxHotel.lineBreakMode = NSLineBreakByWordWrapping;
//        luxHotel.numberOfLines = 1;
        luxHotel.textAlignment = NSTextAlignmentCenter;
        luxHotel.font = [UIFont systemFontOfSize:18];
        luxHotel.frame = CGRectMake(0, 5, baseImageView.frame.size.width, 30);
        
        bestRateGaurentedBaseView.frame =  CGRectMake(self.baseScrollView.frame.size.width-10-185,baseImageView.frame.origin.y + baseImageView.frame.size.height +5 , 185, 30);
        rightSelectImgView.frame = CGRectMake(0, 5, 20, 20);
        bestRateLbl.frame = CGRectMake(23, 0, 185 - 25, 25);
        bestRateGuarnteeNarrowView.frame = CGRectMake(0, 26, 185, 2);
        
         _imagePager.frame = CGRectMake(10,baseImageView.frame.origin.y + baseImageView.frame.size.height +40 ,self.baseScrollView.frame.size.width - 20,200);
    }
    
   NSString *str =   [ICSingletonManager getStringValue:[self.hotelDetailDict objectForKey:@"HotelBulletContent"]];
    
//    NSString *htmlStr = [ICSingletonManager getStringValue:[NSString stringWithFormat:@"<html><head><style>@import url('https://fonts.googleapis.com/css?family=Josefin+Sans');ul{list-style:none;padding: 1px 0px 0px 0px; }ul li {background-image: url(http://www.icanstay.com/Content/Home/images/rev-slider/dot.png);  background-repeat: no-repeat; background-position: 0 0px; padding: 0px 10px 12px 18px; background-size: 13px;font-size: 16px; color:#bd9854; line-height: 17px; font-family:Josefin Sans, Verdana, Segoe, sans-serif;}</style></head><body >%@</body></html>",str]];
    
         NSString *htmlStr = [ICSingletonManager getStringValue:[NSString stringWithFormat:@"<html><head><style>@import url('https://fonts.googleapis.com/css?family=Gotham');ul{list-style:none;padding: 1px 0px 0px 0px; }ul li {background-image: url(http://www.icanstay.com/Content/Home/images/rev-slider/dot.png);  background-repeat: no-repeat; background-position: 0 0px; padding: 0px 10px 12px 18px; background-size: 13px;font-size: 16px; color:#808080; line-height: 17px; font-family:Josefin Sans, Verdana, Segoe, sans-serif;}</style></head><body bgcolor=\"#ffffff\" >%@</body></html>",str]];
    
//    NSString *webViewHeight = [self.hotelDetailDict objectForKey:@"HotelBulletContent"];
    
    NSAttributedString *attributedText = [self getHTMLAttributedString:htmlStr];
    CGSize size = CGSizeMake(self.baseScrollView.frame.size.width - 20, CGFLOAT_MAX);
    CGRect paragraphRect =     [attributedText boundingRectWithSize:size
                                                            options:(NSStringDrawingUsesLineFragmentOrigin)
                                                            context:nil];
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(10, _imagePager.frame.origin.y + _imagePager.frame.size.height + 10,self.baseScrollView.frame.size.width - 20 , paragraphRect.size.height + 30)]; //Change self.view.bounds to a smaller CGRect if you don't want it to take up the whole screen
    
    
     [webView loadHTMLString:[NSString stringWithFormat:@"%@", htmlStr ]baseURL:nil];
 //   webView.tintColor = [ICSingletonManager colorFromHexString:@"#bd9854"];
    webView.scrollView.scrollEnabled = NO;
    webView.backgroundColor = [UIColor whiteColor];
    [self.baseScrollView addSubview:webView];
    
    /************ How Do We Get Deal ************************/
    howDoWeGetDealBaseView = [[UIView alloc]init];
    howDoWeGetDealBaseView.backgroundColor = [UIColor clearColor];
  
   
    DealLbl = [[UILabel alloc]init];
    DealLbl.text = @"How do we get such a great deal?";
    DealLbl.textColor = [ICSingletonManager colorFromHexString:@"#bd9854"];
    [howDoWeGetDealBaseView addSubview:DealLbl];
    
    dealNarrowView = [[UIView alloc]init];
    dealNarrowView.backgroundColor = [ICSingletonManager colorFromHexString:@"#bd9854"];
    [howDoWeGetDealBaseView addSubview:dealNarrowView];
    
    UITapGestureRecognizer *dealTapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(dealTapGestureTapped:)];
    dealTapGesture.numberOfTapsRequired = 1;
    [howDoWeGetDealBaseView addGestureRecognizer:dealTapGesture];
  
     /************ How Do We Get Deal ************************/
    
    
    /******************* Check In check out And number of rooms *******************/
    self.midDateBookNowBtnBaseView = [[UIView alloc]init];
   
    checkInOutRoomHeadingBaseView = [[UIView alloc]init];
    [self.midDateBookNowBtnBaseView addSubview:checkInOutRoomHeadingBaseView];
    
    checkInheadingLbl = [[UILabel alloc]init];
    checkInheadingLbl.textAlignment = NSTextAlignmentLeft;
    checkInheadingLbl.text = @"Check In";
    [checkInOutRoomHeadingBaseView addSubview:checkInheadingLbl];
    
    checkOutHeadingLbl = [[UILabel alloc]init];
    checkOutHeadingLbl.textAlignment = NSTextAlignmentCenter;
    checkOutHeadingLbl.text = @"Check Out";
    [checkInOutRoomHeadingBaseView addSubview:checkOutHeadingLbl];
    
    roomHeadingLbl = [[UILabel alloc]init];
    roomHeadingLbl.textAlignment = NSTextAlignmentCenter;
    roomHeadingLbl.text = @"Rooms";
    [checkInOutRoomHeadingBaseView addSubview:roomHeadingLbl];
    
    baseView = [[UIView alloc]init];
   
    baseView.userInteractionEnabled = YES;
    
    self.selectDateTxtFld = [[UITextField alloc]init];
    self.selectDateTxtFld.delegate = self;
    self.selectDateTxtFld.textColor = [UIColor blackColor];
    self.selectDateTxtFld.userInteractionEnabled = NO;
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
    NSDate *date = [dateFormatter dateFromString:self.checkInDate];
    [dateFormatter setDateFormat:@"dd, MMM"];
    
    self.selectDateTxtFld.text = [dateFormatter stringFromDate:date];
    [self.selectDateTxtFld resignFirstResponder];
    
    self.selectDateTxtFld.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Select Date" attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
   
    UIImageView *checkInCalenderImgView = [[UIImageView alloc]init];
    [checkInCalenderImgView setUserInteractionEnabled:YES];
    checkInCalenderImgView.image = [UIImage imageNamed:@"calenderImg"];
    
    
    UIView *narrowGoldLineview1 = [[UIView alloc]init];
    narrowGoldLineview1.backgroundColor = [ICSingletonManager colorFromHexString:@"#BD9854"];
  
    
    
    UITapGestureRecognizer *tapSelectTxtField = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectDateTxtFldTapped:)];
    tapSelectTxtField.numberOfTapsRequired = 1;
   
    
    
    self.checkOutAndRoomBaseView = [[UIView alloc]init];
   
    
    checkOutBaseView = [[UIView alloc]init];
    
    self.checkOutTxtField = [[UITextField alloc]init];
    self.checkOutTxtField.delegate = self;
    self.checkOutTxtField.userInteractionEnabled = NO;
    
    NSDateFormatter *dateFormatterCheckOut = [[NSDateFormatter alloc] init];
    [dateFormatterCheckOut setDateFormat:@"dd-MMM-yyyy"];
   
    NSDate *dateCheckOut = [dateFormatterCheckOut dateFromString:self.checkoutDate];
    [dateFormatterCheckOut setDateFormat:@"dd, MMM"];
     NSString *checkOutDateStr = [dateFormatterCheckOut stringFromDate:dateCheckOut];
  
    self.checkOutTxtField.text = checkOutDateStr;
    
    self.checkOutTxtField.textColor = [UIColor blackColor];
    
    UIImageView *checkOutCalenderImgView = [[UIImageView alloc]init];
    [checkOutCalenderImgView setUserInteractionEnabled:YES];
    checkOutCalenderImgView.image = [UIImage imageNamed:@"calenderImg"];
    
   
    
    
    UIView *narrowGoldLineview2 = [[UIView alloc]init];
    narrowGoldLineview2.backgroundColor = [ICSingletonManager colorFromHexString:@"#BD9854"];
    
    
    
    UITapGestureRecognizer *tapcheckOutTxtField = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectcheckOutTxtFldTapped:)];
    tapcheckOutTxtField.numberOfTapsRequired = 1;
   
    
    
    
    baseView1 = [[UIView alloc]init];
    baseView1.backgroundColor = [UIColor clearColor];
    baseView1.userInteractionEnabled = YES;
  
    
    self.checkNumberOfRooms = [[UITextField alloc]init];
    self.checkNumberOfRooms.delegate = self;
    self.checkNumberOfRooms.textColor = [UIColor blackColor];
    self.checkNumberOfRooms.userInteractionEnabled = NO;
    self.checkNumberOfRooms.text = self.noOfRomms;
    [self.checkNumberOfRooms resignFirstResponder];
    
    
    self.checkNumberOfRooms.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Rooms" attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
    
    
    UIView *narrowGoldLineview3 = [[UIView alloc]init];
    narrowGoldLineview3.backgroundColor = [ICSingletonManager colorFromHexString:@"#BD9854"];
   
    
    
    UITapGestureRecognizer *tapRoomTxtField = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectRoomTxtFldTapped:)];
    tapRoomTxtField.numberOfTapsRequired = 1;
   
    
    /******************* Check In check out And number of rooms *******************/

    
    self.acceptBookNowBtnBaseView = [[UIView alloc]init];
    self.acceptBookNowBtnBaseView.backgroundColor = [UIColor clearColor];
   
    
    rightClickImgView = [[UIImageView alloc]init];
    rightClickImgView.image = [UIImage imageNamed:@"RightClick"];
    
    acceptLabel = [[UILabel alloc]init];
    acceptLabel.text = @"I accept it is hidden deal of luxury hotel and hotel name will be revealed only after payment.";
    acceptLabel.textAlignment = NSTextAlignmentLeft;
    acceptLabel.font =   [UIFont fontWithName:@"JosefinSans-Light" size:18];
    acceptLabel.textColor = [UIColor grayColor];
    
    totalAmountLbl = [[UILabel alloc]init];
    totalAmountLbl.font =   [UIFont fontWithName:@"JosefinSans-Light" size:18];
    totalAmountLbl.textColor = [UIColor grayColor];
    
    
    soldOutLbl = [[UILabel alloc]init];
    soldOutLbl.text = @"Sorry! Sold Out";
    soldOutLbl.textColor = [UIColor blackColor];
    
    
    bookNowBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [bookNowBtn setTitle:@"Book Now" forState:UIControlStateNormal];
    [bookNowBtn setBackgroundColor:[ICSingletonManager colorFromHexString:@"#bd9854"]];
    [bookNowBtn setTintColor:[UIColor whiteColor]];
    bookNowBtn.layer.cornerRadius = 5.0;
    [bookNowBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
 //   [bookNowBtn addTarget:self action:@selector(bookNowBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
   
    
    actualPriceLbl = [[UILabel alloc]init];
    actualPriceLbl.textColor = [UIColor blackColor];
    actualPriceLbl.textAlignment = NSTextAlignmentLeft;
    [actualPriceLbl setTag:4];
    actualPriceLbl.numberOfLines = 1;
    actualPriceLbl.lineBreakMode = NSLineBreakByWordWrapping;
    NSString *strOfferPrice = [NSString stringWithFormat:@"%@ per night", self.actualPrice];
    NSUInteger length = [strOfferPrice length];
    int LengthStr = (int)length;
    NSMutableAttributedString *text =[[NSMutableAttributedString alloc] initWithString:strOfferPrice];
    
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0,6 )];
    [text addAttribute:NSFontAttributeName
                  value:[UIFont systemFontOfSize:24.0]
                  range:NSMakeRange(6, 6)];
    [text addAttribute:NSFontAttributeName
                 value:[UIFont systemFontOfSize:20.0]
                 range:NSMakeRange(12, 9)];
    
    actualPriceLbl.attributedText = text;
   
    
    narrowAcualPriceLineView = [[UILabel alloc]init];
    narrowAcualPriceLineView.backgroundColor = [UIColor grayColor];
    [narrowAcualPriceLineView setTag:6];
   
    
    offerPriceLbl = [[UILabel alloc]init];
    offerPriceLbl.textColor = [UIColor colorWithRed:0.1373 green:0.5686 blue:0.1373 alpha:1.0];
    offerPriceLbl.textAlignment = NSTextAlignmentLeft;
    [offerPriceLbl setTag:5];
    offerPriceLbl.numberOfLines = 1;
    offerPriceLbl.lineBreakMode = NSLineBreakByWordWrapping;
  //  offerPriceLbl.attributedText = text;
   
    _checkNumberOfRooms.text = self.noOfRomms;
    selectedCategory = self.checkInDate ;
    self.checkOutDate =  self.checkoutDate;
    self.numberOfrooms =  _checkNumberOfRooms.text;
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"dd-MMM-yyyy"];
    NSDate *startDate = [f dateFromString:selectedCategory];
    NSDate *endDate = [f dateFromString:self.checkOutDate];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:0];
    
    NSLog(@"%ld", [components day]);
    
    int numberOfDaysBwchekInAndOut =  (int)[components day];
    int offerPriceHotel = [self.offerPriceHotelRoom intValue];
    
    
    baseBookNowBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [baseBookNowBtn setBackgroundColor:[ICSingletonManager colorFromHexString:@"#bd9854"]];
    [baseBookNowBtn setTintColor:[UIColor blackColor]];
    [baseBookNowBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [baseBookNowBtn addTarget:self action:@selector(bookNowBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:baseBookNowBtn];
    
    self.manageSeeMoreHideObjects = @"NO";
    
    if (IS_IPAD) {
        
        self.selectDateTxtFld.font = [UIFont systemFontOfSize:20];
        self.checkOutTxtField.font = [UIFont systemFontOfSize:20];
        self.checkNumberOfRooms.font = [UIFont systemFontOfSize:20];
        
        [self.baseScrollView addSubview:self.midDateBookNowBtnBaseView];
        [self.midDateBookNowBtnBaseView addSubview:baseView];
        [baseView addSubview:self.selectDateTxtFld];
        [baseView addSubview:narrowGoldLineview1];
        [baseView addGestureRecognizer:tapSelectTxtField];
        [baseView addSubview:checkInCalenderImgView];
        
        [self.midDateBookNowBtnBaseView addSubview:self.checkOutAndRoomBaseView];
        
        [self.midDateBookNowBtnBaseView addSubview:checkOutBaseView];
        [checkOutBaseView addSubview:self.checkOutTxtField];
        [checkOutBaseView addSubview:narrowGoldLineview2];
        [checkOutBaseView addGestureRecognizer:tapcheckOutTxtField];
        [checkOutBaseView addSubview:checkOutCalenderImgView];
        
        [self.midDateBookNowBtnBaseView addSubview:baseView1];
        [baseView1 addSubview:self.checkNumberOfRooms];
        [baseView1 addSubview:narrowGoldLineview3];
        [baseView1 addGestureRecognizer:tapRoomTxtField];
        
        
        [self.midDateBookNowBtnBaseView addSubview:self.acceptBookNowBtnBaseView];
        
        [self.acceptBookNowBtnBaseView addSubview:rightClickImgView];
        [self.acceptBookNowBtnBaseView addSubview:acceptLabel];
        
        [self.acceptBookNowBtnBaseView addSubview:totalAmountLbl];
        [self.acceptBookNowBtnBaseView addSubview:bookNowBtn];
        [self.acceptBookNowBtnBaseView addSubview:actualPriceLbl];
        [self.acceptBookNowBtnBaseView addSubview:narrowAcualPriceLineView];
        [self.acceptBookNowBtnBaseView addSubview:offerPriceLbl];
        [self.acceptBookNowBtnBaseView addSubview:howDoWeGetDealBaseView];
        
        self.midDateBookNowBtnBaseView.frame = CGRectMake(5, webView.frame.size.height + webView.frame.origin.y +10,self.view.frame.size.width-10 , 250);
        
        checkInOutRoomHeadingBaseView.frame = CGRectMake(0, 0, self.midDateBookNowBtnBaseView.frame.size.width,20 );
        checkInheadingLbl.frame = CGRectMake(0, 0,self.midDateBookNowBtnBaseView.frame.size.width *0.25 , 20);
        checkOutHeadingLbl.frame = CGRectMake(checkInheadingLbl.frame.origin.x + checkInheadingLbl.frame.size.width, 0,self.midDateBookNowBtnBaseView.frame.size.width *0.25 , 20);
        roomHeadingLbl.frame = CGRectMake(checkOutHeadingLbl.frame.origin.x + checkOutHeadingLbl.frame.size.width, 0,90 , 20);
        checkInheadingLbl.textAlignment = NSTextAlignmentCenter;
       
        baseView.frame = CGRectMake(0, 40,self.midDateBookNowBtnBaseView.frame.size.width *0.25 , 50);
        self.selectDateTxtFld.frame = CGRectMake(0, 0, baseView.frame.size.width, 25);
        narrowGoldLineview1.frame = CGRectMake(0, self.selectDateTxtFld.frame.size.height + self.selectDateTxtFld.frame.origin.y + 10,baseView.frame.size.width, 2);
        checkInCalenderImgView.frame = CGRectMake(baseView.frame.size.width- 32, -3, 30, 30);
        
        
        checkOutBaseView.frame = CGRectMake(baseView.frame.origin.x + baseView.frame.size.width + 10, 40, self.midDateBookNowBtnBaseView.frame.size.width *0.25, 50);
        self.checkOutTxtField.frame =  CGRectMake(0, 0, checkOutBaseView.frame.size.width, 25);
        narrowGoldLineview2.frame = CGRectMake(0, self.checkOutTxtField.frame.size.height + self.checkOutTxtField.frame.origin.y + 10, checkOutBaseView.frame.size.width, 2);
        checkOutCalenderImgView.frame = CGRectMake(checkOutBaseView.frame.size.width - 32, -3, 30, 30);
        
        
        baseView1.frame = CGRectMake( checkOutBaseView.frame.origin.x + checkOutBaseView.frame.size.width + 10, 40 ,90 , 50);
        self.checkNumberOfRooms.frame = CGRectMake(0, 0, baseView1.frame.size.width, 25);
        narrowGoldLineview3.frame = CGRectMake(0, self.checkNumberOfRooms.frame.size.height + self.checkNumberOfRooms.frame.origin.y + 10,baseView1.frame.size.width, 2);
        
        
        
        
        self.acceptBookNowBtnBaseView.frame = CGRectMake(0,checkOutBaseView.frame.origin.y + checkOutBaseView.frame.size.height + 10, self.midDateBookNowBtnBaseView.frame.size.width , 130);
        
        howDoWeGetDealBaseView.frame =  CGRectMake(0,5 , 270, 30);
        DealLbl.frame = CGRectMake(0, 0, 270, 25);
        dealNarrowView.frame = CGRectMake(0, 26, 270, 2);
        
        
        
        actualPriceLbl.frame = CGRectMake(0, howDoWeGetDealBaseView.frame.size.height + howDoWeGetDealBaseView.frame.origin.y +5, self.acceptBookNowBtnBaseView.frame.size.width, 30);
        narrowAcualPriceLineView.frame = CGRectMake(20,actualPriceLbl.frame.origin.y + 18, 40,1 );
        
        rightClickImgView.frame = CGRectMake(0, actualPriceLbl.frame.size.height + actualPriceLbl.frame.origin.y +5, 20, 20);
        acceptLabel.frame = CGRectMake(20, actualPriceLbl.frame.size.height + actualPriceLbl.frame.origin.y +5, self.acceptBookNowBtnBaseView.frame.size.width -20, 40);
        acceptLabel.lineBreakMode = NSLineBreakByWordWrapping;
        acceptLabel.numberOfLines = 2;
        
        
    }else{
        
        self.selectDateTxtFld.font = [UIFont systemFontOfSize:17];
        self.checkOutTxtField.font = [UIFont systemFontOfSize:17];
        self.checkNumberOfRooms.font = [UIFont systemFontOfSize:17];
        
        [self.baseScrollView addSubview:self.midDateBookNowBtnBaseView];
        [self.midDateBookNowBtnBaseView addSubview:baseView];
        [baseView addSubview:self.selectDateTxtFld];
        [baseView addSubview:narrowGoldLineview1];
        [baseView addGestureRecognizer:tapSelectTxtField];
        [baseView addSubview:checkInCalenderImgView];
        
        [self.midDateBookNowBtnBaseView addSubview:self.checkOutAndRoomBaseView];
    
        [self.midDateBookNowBtnBaseView addSubview:checkOutBaseView];
        [checkOutBaseView addSubview:self.checkOutTxtField];
        [checkOutBaseView addSubview:narrowGoldLineview2];
        [checkOutBaseView addGestureRecognizer:tapcheckOutTxtField];
        [checkOutBaseView addSubview:checkOutCalenderImgView];
        
        [self.midDateBookNowBtnBaseView addSubview:baseView1];
        [baseView1 addSubview:self.checkNumberOfRooms];
        [baseView1 addSubview:narrowGoldLineview3];
        [baseView1 addGestureRecognizer:tapRoomTxtField];
        
        
        [self.midDateBookNowBtnBaseView addSubview:self.acceptBookNowBtnBaseView];
        
        [self.acceptBookNowBtnBaseView addSubview:rightClickImgView];
        [self.acceptBookNowBtnBaseView addSubview:acceptLabel];
        
        [self.acceptBookNowBtnBaseView addSubview:totalAmountLbl];
        [self.acceptBookNowBtnBaseView addSubview:bookNowBtn];
        [self.acceptBookNowBtnBaseView addSubview:actualPriceLbl];
        [self.acceptBookNowBtnBaseView addSubview:narrowAcualPriceLineView];
        [self.acceptBookNowBtnBaseView addSubview:offerPriceLbl];
         [self.acceptBookNowBtnBaseView addSubview:howDoWeGetDealBaseView];
        
        self.midDateBookNowBtnBaseView.frame = CGRectMake(5, webView.frame.size.height + webView.frame.origin.y +10,self.view.frame.size.width-10 , 250);
        
        checkInOutRoomHeadingBaseView.frame = CGRectMake(0, 0, self.midDateBookNowBtnBaseView.frame.size.width,20 );
        checkInheadingLbl.frame = CGRectMake(0, 0,self.midDateBookNowBtnBaseView.frame.size.width *0.33 , 20);
        checkOutHeadingLbl.frame = CGRectMake(checkInheadingLbl.frame.origin.x + checkInheadingLbl.frame.size.width, 0,self.midDateBookNowBtnBaseView.frame.size.width *0.33 , 20);
        roomHeadingLbl.frame = CGRectMake(checkOutHeadingLbl.frame.origin.x + checkOutHeadingLbl.frame.size.width, 0,self.midDateBookNowBtnBaseView.frame.size.width - (checkOutHeadingLbl.frame.origin.x + checkOutHeadingLbl.frame.size.width + 10) , 20);
        
        baseView.frame = CGRectMake(0, 40,self.midDateBookNowBtnBaseView.frame.size.width *0.33 , 50);
        self.selectDateTxtFld.frame = CGRectMake(0, 0, baseView.frame.size.width, 25);
        narrowGoldLineview1.frame = CGRectMake(0, self.selectDateTxtFld.frame.size.height + self.selectDateTxtFld.frame.origin.y + 10,baseView.frame.size.width, 2);
        checkInCalenderImgView.frame = CGRectMake(baseView.frame.size.width- 22, -3, 20, 20);
        
       
//        self.checkOutAndRoomBaseView.frame = CGRectMake(10, baseView.frame.origin.y + baseView.frame.size.height ,self.view.frame.size.width - 20 , 0);
//        self.checkOutAndRoomBaseView.backgroundColor = [UIColor clearColor];
        
        
        checkOutBaseView.frame = CGRectMake(baseView.frame.origin.x + baseView.frame.size.width + 10, 40, self.midDateBookNowBtnBaseView.frame.size.width *0.33, 50);
        self.checkOutTxtField.frame =  CGRectMake(0, 0, checkOutBaseView.frame.size.width, 25);
        narrowGoldLineview2.frame = CGRectMake(0, self.checkOutTxtField.frame.size.height + self.checkOutTxtField.frame.origin.y + 10, checkOutBaseView.frame.size.width, 2);
       checkOutCalenderImgView.frame = CGRectMake(checkOutBaseView.frame.size.width - 22, -3, 20, 20);
        
    
        baseView1.frame = CGRectMake( checkOutBaseView.frame.origin.x + checkOutBaseView.frame.size.width + 10, 40 ,self.midDateBookNowBtnBaseView.frame.size.width - (checkOutBaseView.frame.origin.x + checkOutBaseView.frame.size.width + 10)  , 50);
        self.checkNumberOfRooms.frame = CGRectMake(0, 0, baseView1.frame.size.width, 25);
        narrowGoldLineview3.frame = CGRectMake(0, self.checkNumberOfRooms.frame.size.height + self.checkNumberOfRooms.frame.origin.y + 10,baseView1.frame.size.width, 2);
        
       
        
        
        self.acceptBookNowBtnBaseView.frame = CGRectMake(0,checkOutBaseView.frame.origin.y + checkOutBaseView.frame.size.height + 10, self.midDateBookNowBtnBaseView.frame.size.width , 130);
        
        howDoWeGetDealBaseView.frame =  CGRectMake(0,5 , 270, 30);
        DealLbl.frame = CGRectMake(0, 0, 270, 25);
        dealNarrowView.frame = CGRectMake(0, 26, 270, 2);
       
       
//        totalAmountLbl.frame = CGRectMake(0, acceptLabel.frame.size.height + acceptLabel.frame.origin.y + 5, self.acceptBookNowBtnBaseView.frame.size.width -20, 25);
//        bookNowBtn.frame = CGRectMake(0, totalAmountLbl.frame.size.height + totalAmountLbl.frame.origin.y +5, 200, 40);
//         soldOutLbl.frame = CGRectMake(0, totalAmountLbl.frame.size.height + totalAmountLbl.frame.origin.y +5, 200, 40);
     
        
        actualPriceLbl.frame = CGRectMake(0, howDoWeGetDealBaseView.frame.size.height + howDoWeGetDealBaseView.frame.origin.y +5, self.acceptBookNowBtnBaseView.frame.size.width, 30);
         narrowAcualPriceLineView.frame = CGRectMake(20,actualPriceLbl.frame.origin.y + 18, 40,1 );
        
        rightClickImgView.frame = CGRectMake(0, actualPriceLbl.frame.size.height + actualPriceLbl.frame.origin.y +5, 20, 20);
        acceptLabel.frame = CGRectMake(20, actualPriceLbl.frame.size.height + actualPriceLbl.frame.origin.y +5, self.acceptBookNowBtnBaseView.frame.size.width -20, 40);
        acceptLabel.lineBreakMode = NSLineBreakByWordWrapping;
        acceptLabel.numberOfLines = 2;
        
     //   offerPriceLbl.frame = CGRectMake(20,actualPriceLbl.frame.size.height + actualPriceLbl.frame.origin.y , 500, 30);
       
    }
  
    
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self.manageSeeMoreHideObjects isEqualToString:@"YES"]) {
        
        /***************** Directly come to Seemore ****************/
        baseView1.hidden = YES;
        checkOutBaseView.hidden = YES;
        acceptLabel.hidden = YES;
        bookNowBtn.hidden = YES;
        soldOutLbl.hidden = YES;
        totalAmountLbl.hidden = YES;
        rightClickImgView.hidden = YES;
        actualPriceLbl.hidden = YES;
        offerPriceLbl.hidden = YES;
        narrowAcualPriceLineView.hidden = YES;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            self.midDateBookNowBtnBaseView.frame = CGRectMake(20, webView.frame.size.height + webView.frame.origin.y +30,webView.frame.size.width , 50);
            
            
//            actualPriceLbl.frame = CGRectMake(20, baseView.frame.size.height + baseView.frame.origin.y +5, 500, 30);
//            offerPriceLbl.frame = CGRectMake(20,actualPriceLbl.frame.size.height + actualPriceLbl.frame.origin.y , 500, 30);
//            narrowAcualPriceLineView.frame = CGRectMake(120,actualPriceLbl.frame.origin.y + 15, 50,1 );
        }else{
            self.midDateBookNowBtnBaseView.frame = CGRectMake(20, webView.frame.size.height + webView.frame.origin.y +30,webView.frame.size.width , 50);
            
//            
//            actualPriceLbl.frame = CGRectMake(10, baseView.frame.size.height + baseView.frame.origin.y +5, 500, 30);
//            offerPriceLbl.frame = CGRectMake(10,actualPriceLbl.frame.size.height + actualPriceLbl.frame.origin.y , 500, 30);
//            narrowAcualPriceLineView.frame = CGRectMake(110,actualPriceLbl.frame.origin.y + 15, 50,1 );
        }
       
      /***************** Directly come to Seemore ****************/
        
    }else{
        
        
        baseView1.hidden = NO;
        checkOutBaseView.hidden = NO;
        acceptLabel.hidden = NO;
        bookNowBtn.hidden = NO;
        totalAmountLbl.hidden = NO;
        rightClickImgView.hidden = NO;
        if ([self.soldOutHotel isEqualToString:@"YES"]) {
             /***************** Room Inventory Not Available Not Directly ****************/
            soldOutLbl.hidden = YES;
            bookNowBtn.hidden = YES;
            acceptLabel.hidden = YES;
            rightClickImgView.hidden = YES;
            totalAmountLbl.hidden = YES;
            actualPriceLbl.hidden = YES;
            offerPriceLbl.hidden = YES;
            narrowAcualPriceLineView.hidden = YES;
            
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
             
                self.midDateBookNowBtnBaseView.frame = CGRectMake(5, webView.frame.size.height + webView.frame.origin.y +0,self.view.frame.size.width-10 , 130);
                
                self.acceptBookNowBtnBaseView.frame = CGRectMake(0,checkOutBaseView.frame.origin.y + checkOutBaseView.frame.size.height , self.midDateBookNowBtnBaseView.frame.size.width , 30);
                
                howDoWeGetDealBaseView.frame =  CGRectMake(0,0 , 270, 30);
                DealLbl.frame = CGRectMake(0, 0, 270, 25);
                dealNarrowView.frame = CGRectMake(0, 26, 270, 2);
                
                actualPriceLbl.frame = CGRectMake(0, howDoWeGetDealBaseView.frame.size.height + howDoWeGetDealBaseView.frame.origin.y +5, self.acceptBookNowBtnBaseView.frame.size.width, 30);
                narrowAcualPriceLineView.frame = CGRectMake(20,actualPriceLbl.frame.origin.y + 18, 40,1 );
                
                rightClickImgView.frame = CGRectMake(0, actualPriceLbl.frame.size.height + actualPriceLbl.frame.origin.y +5, 20, 20);
                acceptLabel.frame = CGRectMake(20, actualPriceLbl.frame.size.height + actualPriceLbl.frame.origin.y +5, self.acceptBookNowBtnBaseView.frame.size.width -20, 40);
                acceptLabel.lineBreakMode = NSLineBreakByWordWrapping;
                acceptLabel.numberOfLines = 2;
                
                CGRect screenRect = [[UIScreen mainScreen] bounds];
                _baseScrollView.frame =  CGRectMake(0, self.topWhiteBaseView.frame.size.height + self.topWhiteBaseView.frame.origin.y , screenRect.size.width, (screenRect.size.height - (self.topWhiteBaseView.frame.size.height + self.topWhiteBaseView.frame.origin.y +50)));
                
                bookNowBtnTitleStr = [NSString stringWithFormat:@"Sorry! Sold Out"];
                [baseBookNowBtn setTitle:bookNowBtnTitleStr forState:UIControlStateNormal];
                baseBookNowBtn.frame = CGRectMake(0, _baseScrollView.frame.origin.y + _baseScrollView.frame.size.height, self.view.frame.size.width, 50);
                
              
//                actualPriceLbl.frame = CGRectMake(20, self.acceptBookNowBtnBaseView.frame.size.height + self.acceptBookNowBtnBaseView.frame.origin.y +5, 500, 30);
//                
//                offerPriceLbl.frame = CGRectMake(20,actualPriceLbl.frame.size.height + actualPriceLbl.frame.origin.y , 500, 30);
//                narrowAcualPriceLineView.frame = CGRectMake(120,actualPriceLbl.frame.origin.y + 15, 50,1 );
            }else{
                
                
                self.midDateBookNowBtnBaseView.frame = CGRectMake(5, webView.frame.size.height + webView.frame.origin.y +10,self.view.frame.size.width-10 , 130);
                
                self.acceptBookNowBtnBaseView.frame = CGRectMake(0,checkOutBaseView.frame.origin.y + checkOutBaseView.frame.size.height , self.midDateBookNowBtnBaseView.frame.size.width , 40);
                
                howDoWeGetDealBaseView.frame =  CGRectMake(0,0 , 270, 30);
                DealLbl.frame = CGRectMake(0, 0, 270, 25);
                dealNarrowView.frame = CGRectMake(0, 26, 270, 2);
                
                actualPriceLbl.frame = CGRectMake(0, howDoWeGetDealBaseView.frame.size.height + howDoWeGetDealBaseView.frame.origin.y +5, self.acceptBookNowBtnBaseView.frame.size.width, 30);
                narrowAcualPriceLineView.frame = CGRectMake(20,actualPriceLbl.frame.origin.y + 18, 40,1 );
                
                rightClickImgView.frame = CGRectMake(0, actualPriceLbl.frame.size.height + actualPriceLbl.frame.origin.y +5, 20, 20);
                acceptLabel.frame = CGRectMake(20, actualPriceLbl.frame.size.height + actualPriceLbl.frame.origin.y +5, self.acceptBookNowBtnBaseView.frame.size.width -20, 40);
                acceptLabel.lineBreakMode = NSLineBreakByWordWrapping;
                acceptLabel.numberOfLines = 2;
                
                CGRect screenRect = [[UIScreen mainScreen] bounds];
                _baseScrollView.frame =  CGRectMake(0, self.topWhiteBaseView.frame.size.height + self.topWhiteBaseView.frame.origin.y , screenRect.size.width, (screenRect.size.height - (self.topWhiteBaseView.frame.size.height + self.topWhiteBaseView.frame.origin.y +50)));
             
                bookNowBtnTitleStr = [NSString stringWithFormat:@"Sorry! Sold Out"];
                [baseBookNowBtn setTitle:bookNowBtnTitleStr forState:UIControlStateNormal];
                baseBookNowBtn.frame = CGRectMake(0, _baseScrollView.frame.origin.y + _baseScrollView.frame.size.height, self.view.frame.size.width, 50);
                
             
                
               
            }
             /***************** Room Inventory Not Available Not Directly ****************/
        }else{
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                
                self.midDateBookNowBtnBaseView.frame = CGRectMake(5, webView.frame.size.height + webView.frame.origin.y +0,self.view.frame.size.width-10 , 210);
                
                self.acceptBookNowBtnBaseView.frame = CGRectMake(0,checkOutBaseView.frame.origin.y + checkOutBaseView.frame.size.height, self.midDateBookNowBtnBaseView.frame.size.width , 110);
                
                howDoWeGetDealBaseView.frame =  CGRectMake(0,0 , 270, 30);
                DealLbl.frame = CGRectMake(0, 0, 270, 25);
                dealNarrowView.frame = CGRectMake(0, 26, 270, 2);
                
                
                
                actualPriceLbl.frame = CGRectMake(0, howDoWeGetDealBaseView.frame.size.height + howDoWeGetDealBaseView.frame.origin.y +5, self.acceptBookNowBtnBaseView.frame.size.width, 30);
                narrowAcualPriceLineView.frame = CGRectMake(20,actualPriceLbl.frame.origin.y + 18, 40,1 );
                
                rightClickImgView.frame = CGRectMake(0, actualPriceLbl.frame.size.height + actualPriceLbl.frame.origin.y +5, 20, 20);
                acceptLabel.frame = CGRectMake(20, actualPriceLbl.frame.size.height + actualPriceLbl.frame.origin.y +5, self.acceptBookNowBtnBaseView.frame.size.width -20, 20);
                acceptLabel.lineBreakMode = NSLineBreakByWordWrapping;
                acceptLabel.numberOfLines = 1;
                
            }else{
               
                self.midDateBookNowBtnBaseView.frame = CGRectMake(5, webView.frame.size.height + webView.frame.origin.y +10,self.view.frame.size.width-10 , 230);
                
                self.acceptBookNowBtnBaseView.frame = CGRectMake(0,checkOutBaseView.frame.origin.y + checkOutBaseView.frame.size.height, self.midDateBookNowBtnBaseView.frame.size.width , 130);
                
                howDoWeGetDealBaseView.frame =  CGRectMake(0,0 , 270, 30);
                DealLbl.frame = CGRectMake(0, 0, 270, 25);
                dealNarrowView.frame = CGRectMake(0, 26, 270, 2);
                
             
            
                actualPriceLbl.frame = CGRectMake(0, howDoWeGetDealBaseView.frame.size.height + howDoWeGetDealBaseView.frame.origin.y +5, self.acceptBookNowBtnBaseView.frame.size.width, 30);
                narrowAcualPriceLineView.frame = CGRectMake(20,actualPriceLbl.frame.origin.y + 18, 40,1 );
                
                rightClickImgView.frame = CGRectMake(0, actualPriceLbl.frame.size.height + actualPriceLbl.frame.origin.y +5, 20, 20);
                acceptLabel.frame = CGRectMake(20, actualPriceLbl.frame.size.height + actualPriceLbl.frame.origin.y +5, self.acceptBookNowBtnBaseView.frame.size.width -20, 40);
                acceptLabel.lineBreakMode = NSLineBreakByWordWrapping;
                acceptLabel.numberOfLines = 2;
            }
            /***************** Room Inventory Available Not Directly ****************/
            soldOutLbl.hidden = YES;
            bookNowBtn.hidden = YES;
            acceptLabel.hidden = NO;
            offerPriceLbl.hidden = YES;
            rightClickImgView.hidden = NO;
            totalAmountLbl.hidden = YES;
            
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            _baseScrollView.frame =  CGRectMake(0, self.topWhiteBaseView.frame.size.height + self.topWhiteBaseView.frame.origin.y , screenRect.size.width, (screenRect.size.height - (self.topWhiteBaseView.frame.size.height + self.topWhiteBaseView.frame.origin.y +50)));
          
            baseBookNowBtn.frame = CGRectMake(0, _baseScrollView.frame.origin.y + _baseScrollView.frame.size.height, self.view.frame.size.width, 50);
           
           
            int totalAmount = [self.noOfRomms intValue] * offerPriceHotel *numberOfDaysBwchekInAndOut;
            totalAmountLbl.text = [NSString stringWithFormat:@"₹%d(Incl. GST)",totalAmount ];
            bookNowBtnTitleStr = [NSString stringWithFormat:@"₹%d (Incl. GST)  BOOK NOW",totalAmount];
            [baseBookNowBtn setTitle:bookNowBtnTitleStr forState:UIControlStateNormal];
            
             /***************** Room Inventory Available Not Directly ****************/
        }
     
        
    }

    [self getHotelDetail];
    
    
   
    [self designBestRateGuarntee];
    [self designHowWeGetASuchADeal];
//
//    self.midDateBookNowBtnBaseView.backgroundColor = [UIColor redColor];
//    self.acceptBookNowBtnBaseView.backgroundColor =  [UIColor greenColor];
//    self.checkOutAndRoomBaseView.backgroundColor = [UIColor grayColor];
//
}

-(void)designBestRateGuarntee
{
    
     CGRect screenRect = [[UIScreen mainScreen] bounds];
    bsetRateView = [[UIView alloc]init];
    bsetRateView.hidden = YES;
    [self.view addSubview:bsetRateView];

    UIView *HeaderBlueBaseView =[[UIView alloc]init];
    HeaderBlueBaseView.backgroundColor = [ICSingletonManager colorFromHexString:@"#BD9854"];
    [bsetRateView addSubview:HeaderBlueBaseView];
    
    UIImageView *logoImgView = [[UIImageView alloc]init];
    logoImgView.image = [UIImage imageNamed:@"topBanner"];
  //  [HeaderBlueBaseView addSubview:logoImgView];
    
    UIButton *crossBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [crossBtn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [crossBtn addTarget:self action:@selector(bestGuaranteeCrossTapped:) forControlEvents:UIControlEventTouchUpInside];
    [HeaderBlueBaseView addSubview:crossBtn];
    
    UITextView *BestRateTxtView = [[UITextView alloc]init];
    BestRateTxtView.textColor = [UIColor whiteColor];
    BestRateTxtView.backgroundColor =[ICSingletonManager colorFromHexString:@"#BD9854"];
    BestRateTxtView.font = [UIFont systemFontOfSize:20];
    BestRateTxtView.text = @"If found expensive? We'll refund double of the difference!";
    
    [bsetRateView addSubview:BestRateTxtView];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
       
        
        bsetRateView.frame = CGRectMake((screenRect.size.width - 300)/2, (screenRect.size.height - 200)/2, 300, 200);
        HeaderBlueBaseView.frame = CGRectMake(0, 0, 300, 50);
        logoImgView.frame = CGRectMake(10, 0, 130, 50);
        crossBtn.frame = CGRectMake(300 - 40, 10, 30, 30);
        
        BestRateTxtView.frame = CGRectMake(0, 50, 300, 150);
    }else{
        bsetRateView.frame = CGRectMake((screenRect.size.width - 300)/2, (screenRect.size.height - 200)/2, 300, 200);
        HeaderBlueBaseView.frame = CGRectMake(0, 0, 300, 50);
        logoImgView.frame = CGRectMake(10, 0, 130, 50);
        crossBtn.frame = CGRectMake(300 - 40, 10, 30, 30);
        
        BestRateTxtView.frame = CGRectMake(0, 50, 300, 150);
    }
    
}

-(void)designHowWeGetASuchADeal
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    HowDoWeGetView = [[UIView alloc]init];
    HowDoWeGetView.hidden = YES;
    [self.view addSubview:HowDoWeGetView];
    
    UIView *HeaderBlueBaseView =[[UIView alloc]init];
    HeaderBlueBaseView.backgroundColor =[ICSingletonManager colorFromHexString:@"#BD9854"];
    [HowDoWeGetView addSubview:HeaderBlueBaseView];
    
    UIImageView *logoImgView = [[UIImageView alloc]init];
    logoImgView.image = [UIImage imageNamed:@"topBanner"];
 //   [HeaderBlueBaseView addSubview:logoImgView];
    
    UIButton *crossBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [crossBtn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [crossBtn addTarget:self action:@selector(HowDoWeGetViewCrossTapped:) forControlEvents:UIControlEventTouchUpInside];
    [HeaderBlueBaseView addSubview:crossBtn];
    
    UITextView *BestRateTxtView = [[UITextView alloc]init];
    BestRateTxtView.textColor = [UIColor whiteColor];
    BestRateTxtView.backgroundColor =[ICSingletonManager colorFromHexString:@"#BD9854"];
    BestRateTxtView.text = @"Our team of experts from the hospitality industry have partnered with luxury hotels across India, with whom we have a mutually beneficial relationship. The fruit of this partnership is passed on to our customers.";
    BestRateTxtView.font = [UIFont systemFontOfSize:20];
    [HowDoWeGetView addSubview:BestRateTxtView];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        HowDoWeGetView.frame = CGRectMake((screenRect.size.width - 400)/2, (screenRect.size.height - 200)/2, 400, 300);
        HeaderBlueBaseView.frame = CGRectMake(0, 0, 300, 50);
        logoImgView.frame = CGRectMake(10, 0, 130, 50);
        crossBtn.frame = CGRectMake(300 - 40, 10, 30, 30);
        
        BestRateTxtView.frame = CGRectMake(0, 50, 300, 250);
    }else{
        HowDoWeGetView.frame = CGRectMake((screenRect.size.width - 300)/2, (screenRect.size.height - 200)/2, 300, 300);
        HeaderBlueBaseView.frame = CGRectMake(0, 0, 300, 50);
        logoImgView.frame = CGRectMake(10, 0, 130, 50);
        crossBtn.frame = CGRectMake(300 - 40, 10, 30, 30);
        
        BestRateTxtView.frame = CGRectMake(0, 50, 300, 250);
    }
}

-(void)bestGuaranteeCrossTapped:(id)sender
{
    _baseScrollView.userInteractionEnabled = YES;
    bsetRateView.hidden = YES;
}
-(void)HowDoWeGetViewCrossTapped:(id)sender
{
    _baseScrollView.userInteractionEnabled = YES;
    HowDoWeGetView.hidden = YES;
}
-(void)dealTapGestureTapped:(id)sender
{
    _baseScrollView.userInteractionEnabled = NO;
    HowDoWeGetView.hidden = NO;
}
- (void)bestRateTapGestureTapped:(UITapGestureRecognizer *)recognizer
{
    _baseScrollView.userInteractionEnabled = NO;
    bsetRateView.hidden = NO;
}

-(void)bookNowBtnTapped:(id)sender
{
    
    __weak UIButton *bookNowBtn = sender;
    NSString *BtnTitleStr = bookNowBtn.titleLabel.text;
    if ([BtnTitleStr isEqualToString:@"Sorry! Sold Out"]) {
        
    }else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        lastMinuteDealBookNowController  *lastMinuteDetails =[storyboard instantiateViewControllerWithIdentifier:@"lastMinuteDealBookNowController"];
        lastMinuteDetails.checkInDate = selectedCategory;
        lastMinuteDetails.checkoutDate = self.checkOutDate;
        lastMinuteDetails.noOfRomms = self.numberOfrooms;
        int totalAmount = [self.numberOfrooms intValue];
        NSDateFormatter *f = [[NSDateFormatter alloc] init];
        [f setDateFormat:@"dd-MMM-yyyy"];
        NSDate *startDate = [f dateFromString:selectedCategory];
        NSDate *endDate = [f dateFromString:self.checkOutDate];
        
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                            fromDate:startDate
                                                              toDate:endDate
                                                             options:0];
        
        NSLog(@"%ld", [components day]);
        
        int numberOfDaysBwchekInAndOut = [components day];
        lastMinuteDetails.totalAmount = [NSString stringWithFormat:@"%d", totalAmount* [self.offerPriceHotelRoom intValue] *numberOfDaysBwchekInAndOut];
        lastMinuteDetails.cityId   =   self.cityId;
        lastMinuteDetails.cityName =   self.cityName;
        lastMinuteDetails.hotelId =    self.hotelId;
        
        [self.navigationController pushViewController:lastMinuteDetails animated:YES];
    }
    
}
-(void)selectDateTxtFldTapped:(UIGestureRecognizer *)gestureReconizer
{
    [_selectDateTxtFld resignFirstResponder];
   
    managecheckOutCheckInPickerDate = 0;
    manageRoomAndDatePicker = 0;
     [pickerView selectRow:0 inComponent:0 animated:NO];
    [pickerView reloadAllComponents];
    datePickerBaseView.hidden = NO;
   }
-(void)selectcheckOutTxtFldTapped:(UIGestureRecognizer *)gestureReconizer
{
    [_checkOutTxtField resignFirstResponder];
    
    managecheckOutCheckInPickerDate = 1;
    manageRoomAndDatePicker = 0;
     [pickerView selectRow:0 inComponent:0 animated:NO];
    [pickerView reloadAllComponents];
    datePickerBaseView.hidden = NO;
}



-(void)selectRoomTxtFldTapped:(UIGestureRecognizer *)gestureReconizer
{
    [self.checkNumberOfRooms resignFirstResponder];
      manageRoomAndDatePicker = 1;
     [pickerView selectRow:0 inComponent:0 animated:NO];
    [pickerView reloadAllComponents];
    datePickerBaseView.hidden = NO;
    
}
-(void)InventoryAvailableForColorPickerDate
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    NSString *urlStr;
    if ([kServerUrl isEqualToString:@"http://www.icanstay.com"]) {
        urlStr =  [NSString stringWithFormat: @"%@/Api/FAQApi/LastMinuteHotelCalenderRoomAvaibilityJsonResult?hotelId=%@",kServerUrl,self.hotelId];
    }else{
        urlStr =  [NSString stringWithFormat: @"%@/Api/FAQApi/LastMinuteCalenderRoomAvaibilityJsonResult?cityId=%@",kServerUrl,self.cityId];
    }
   
    
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        NSDictionary *tempDict = responseObject;
        inventoryAvailableDatePicker = [tempDict mutableCopy];
        
         if (selectCellCityNameTable == 0) {
           [_imagePager reloadData];
             
        datePickerBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 200, self.view.frame.size.width, 200)];
        
        UIButton *cancelbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        cancelbtn.frame = CGRectMake(20, 10, 70, 30);
        [cancelbtn setTitle:@"Cancel" forState:UIControlStateNormal];
        [cancelbtn addTarget:self action:@selector(DatePickerCancelBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        cancelbtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        cancelbtn.titleLabel.font = [UIFont systemFontOfSize:17];
        cancelbtn.tintColor = [UIColor blackColor];
        [datePickerBaseView addSubview:cancelbtn];
        
             _donebtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
             _donebtn.frame = CGRectMake(datePickerBaseView.frame.size.width - 170, 10, 150, 30);
             [_donebtn setTitle:@"Done" forState:UIControlStateNormal];
             [_donebtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
             [_donebtn setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
             
             [_donebtn addTarget:self action:@selector(DatePickerDoneBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
             _donebtn.titleLabel.textAlignment = NSTextAlignmentCenter;
             _donebtn.titleLabel.font = [UIFont systemFontOfSize:17];
             _donebtn.tintColor = [UIColor blackColor];
             [_donebtn setEnabled:NO];
        [datePickerBaseView addSubview:_donebtn];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"dd-MMM-yyyy";
        NSString *todayDate = [formatter stringFromDate:[NSDate date]];
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        dateFormatter.dateFormat = @"dd-MMM-yyyy";
        NSDate *dateObjectForDecrement=[dateFormatter dateFromString:todayDate];
        
        NSDate *dateAfterDecrement=[dateObjectForDecrement addTimeInterval: + (24*60*60)];
        NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
        [dateformate setDateFormat:@"dd-MMM-yyyy"]; // Date formater
        NSString *tomorrowDate = [dateformate stringFromDate:dateAfterDecrement];
        
        NSDate *dateAfterDecrementTwoDays=[dateObjectForDecrement addTimeInterval: + (24*60*60 *2)];
        NSDateFormatter *dateformateT=[[NSDateFormatter alloc]init];
        [dateformateT setDateFormat:@"dd-MMM-yyyy"]; // Date formater
        NSString *dayAfterTomorrow = [dateformate stringFromDate:dateAfterDecrementTwoDays];
        
             
             NSDate *dateAfterDecrementThreeDays=[dateObjectForDecrement addTimeInterval: + (24*60*60 *3)];
             NSDateFormatter *dateformateT1=[[NSDateFormatter alloc]init];
             [dateformateT1 setDateFormat:@"dd-MMM-yyyy"]; // Date formater
             NSString *dayAfterFourthDate = [dateformate stringFromDate:dateAfterDecrementThreeDays];
             
             
             checkInPickerDateArr = [[NSMutableArray alloc] initWithObjects:@"Select Date",todayDate, tomorrowDate, dayAfterTomorrow, nil];
             
             checkOutPickerDateArr = [[NSMutableArray alloc] initWithObjects: @"Select Date", tomorrowDate, dayAfterTomorrow, dayAfterFourthDate, nil];

//             self.checkOutDate = [checkInPickerDateArr objectAtIndex:1];
//             self.numberOfrooms = [_roomTableViewArr objectAtIndex:0];

        
        pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 150)];
        
             [pickerView setDataSource: self];
             [pickerView setDelegate: self];
             pickerView.showsSelectionIndicator = YES;
             pickerView.backgroundColor = [UIColor whiteColor];
             [pickerView setValue:[UIColor redColor] forKey:@"textColor"];
             [datePickerBaseView addSubview:pickerView];
        
        datePickerBaseView.backgroundColor = [UIColor grayColor];
        datePickerBaseView.hidden = YES;
        [self.view addSubview:datePickerBaseView];
        [self BottomView];
             
         }else{
             [pickerView reloadAllComponents];
         }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:error.localizedDescription onController:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    
}

-(void)BottomView
{
    hotelDetailTxtView = [[UITextView alloc]init];
    CGFloat heightTxtView ;
    if (IS_IPAD) {
         heightTxtView = [self getLabelHeight:self.baseScrollView.frame.size.width - 40 font:[UIFont fontWithName:@"JosefinSans-Light" size:22] string:[self.hotelDetailDict objectForKey:@"HotelContent"]];
            }else{
          heightTxtView = [self getLabelHeight:self.baseScrollView.frame.size.width - 20 font:[UIFont fontWithName:@"JosefinSans-Light" size:18] string:[self.hotelDetailDict objectForKey:@"HotelContent"]];
        
    }
   
    
    hotelDetailTxtView.frame = CGRectMake(20, self.midDateBookNowBtnBaseView.frame.origin.y + self.midDateBookNowBtnBaseView.frame.size.height + 0 ,self.baseScrollView.frame.size.width - 20   , heightTxtView+ 25);
   
    hotelDetailTxtView.scrollEnabled = NO;
    hotelDetailTxtView.userInteractionEnabled = NO;
    hotelDetailTxtView.backgroundColor = [UIColor clearColor];
       hotelDetailTxtView.textColor = [UIColor grayColor];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
     
      
      
        hotelDetailTxtView.frame = CGRectMake(10, _midDateBookNowBtnBaseView.frame.origin.y + _midDateBookNowBtnBaseView.frame.size.height  ,self.baseScrollView.frame.size.width - 20   , heightTxtView +20);
         hotelDetailTxtView.font = [UIFont fontWithName:@"JosefinSans-Light" size:17];
       
        narrrowLineView1 = [[UIView alloc]initWithFrame:CGRectMake(10, hotelDetailTxtView.frame.size.height + hotelDetailTxtView.frame.origin.y  ,self.baseScrollView.frame.size.width - 20, 3)];
        narrrowLineView1.backgroundColor = [ICSingletonManager colorFromHexString:@"#bd9854"];
        [self.baseScrollView addSubview:narrrowLineView1];
        
        narrrowLineView2 = [[UIView alloc]initWithFrame:CGRectMake(10, narrrowLineView1.frame.size.height + narrrowLineView1.frame.origin.y +200 ,self.baseScrollView.frame.size.width - 20, 3)];
        narrrowLineView2.backgroundColor = [ICSingletonManager colorFromHexString:@"#bd9854"];
        [self.baseScrollView addSubview:narrrowLineView2];
    }else{
        
//         howDoWeGetDealBaseView.frame =  CGRectMake(40,self.midDateBookNowBtnBaseView.frame.origin.y + self.midDateBookNowBtnBaseView.frame.size.height +10 , 270, 30);
//        DealLbl.frame = CGRectMake(0, 0, 270, 25);
//        dealNarrowView.frame = CGRectMake(0, 26, 270, 2);
        hotelDetailTxtView.frame = CGRectMake(20, self.midDateBookNowBtnBaseView.frame.origin.y + self.midDateBookNowBtnBaseView.frame.size.height + 20  ,self.baseScrollView.frame.size.width - 40   , heightTxtView+ 25);
        hotelDetailTxtView.font = [UIFont fontWithName:@"JosefinSans-Light" size:22];
        narrrowLineView1 = [[UIView alloc]initWithFrame:CGRectMake(20, hotelDetailTxtView.frame.size.height + hotelDetailTxtView.frame.origin.y +10 ,self.baseScrollView.frame.size.width - 40, 3)];
        narrrowLineView1.backgroundColor = [ICSingletonManager colorFromHexString:@"#bd9854"];
        [self.baseScrollView addSubview:narrrowLineView1];
        
        narrrowLineView2 = [[UIView alloc]initWithFrame:CGRectMake(20, hotelDetailTxtView.frame.size.height + hotelDetailTxtView.frame.origin.y +220 ,self.baseScrollView.frame.size.width - 40, 3)];
        narrrowLineView2.backgroundColor = [ICSingletonManager colorFromHexString:@"#bd9854"];
        [self.baseScrollView addSubview:narrrowLineView2];

    }
  hotelDetailTxtView.text = [self.hotelDetailDict objectForKey:@"HotelContent"];
   
    [self.baseScrollView addSubview:hotelDetailTxtView];
    
    
    
    arr_amenties = [[NSMutableArray alloc]init];
    NSArray *arr_Name = @[@"Parking",@"Fitness Center",@"Free Wifi",@"Airport Shuttle",@"No Smoking",@"Spa",@"Facilities for Disabled Guests",@"Swimming Pool"];
    NSArray *arr_Icon = @[@"parking",@"fitnesscenetr",@"free-wifi",@"airportshuttle",@"nosmoking",@"spa",@"disabild",@"swimingpool"];
    NSString * Aminity = [_amentieDetailsDict valueForKey:@"Aminity"];
    NSArray * amenitiestype = [Aminity componentsSeparatedByString:@","];
    
    NSInteger num = amenitiestype.count;
    if (num % 2){
        // odd
        num++;
    }
    num = num/2;
    NSInteger height = 55*num;
//    clcv_Height.constant= height-10;
    
    for (int i = 0; i<amenitiestype.count; i++) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        NSString *str_name = [arr_Name objectAtIndex:[[amenitiestype objectAtIndex:i] intValue]-1];
        [dict setValue:str_name forKey:@"name"];
        NSString *str_icon = [arr_Icon objectAtIndex:[[amenitiestype objectAtIndex:i] intValue]-1];
        [dict setValue:str_icon forKey:@"icon"];
        [arr_amenties addObject:dict];
    }

    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(20,narrrowLineView1.frame.origin.y + 10,self.baseScrollView.frame.size.width - 40,190) collectionViewLayout:layout];
    
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    self.collectionView.scrollEnabled = NO;
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    
    [self.baseScrollView addSubview:_collectionView];
    
    UIButton *buyVoucherBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buyVoucherBtn.frame = CGRectMake(20, narrrowLineView2.frame.origin.y + narrrowLineView2.frame.size.height +10, self.baseScrollView.frame.size.width - 40, 50);
    [buyVoucherBtn setTitle:@"Buy Luxury Stay Voucher for Rs. 2,999 (Incl. Taxes)" forState:UIControlStateNormal];
    [buyVoucherBtn setBackgroundColor:[ICSingletonManager colorFromHexString:@"#bd9854"]];
    [buyVoucherBtn addTarget:self action:@selector(buyVoucherBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    if (IS_IPAD) {
        buyVoucherBtn.titleLabel.font = [UIFont fontWithName:@"JosefinSans-Bold" size:23];
       _collectionView.frame = CGRectMake(20,narrrowLineView1.frame.origin.y + 10,self.baseScrollView.frame.size.width - 40,190);
    }else{
        buyVoucherBtn.titleLabel.font = [UIFont fontWithName:@"JosefinSans-Bold" size:14];
        _collectionView.frame = CGRectMake(5,narrrowLineView1.frame.origin.y + 10,self.baseScrollView.frame.size.width - 10,190);
    }
    
    buyVoucherBtn.layer.masksToBounds = YES;
    buyVoucherBtn.layer.cornerRadius = 5.0;
    buyVoucherBtn.titleLabel.textColor = [UIColor whiteColor];
    [buyVoucherBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.baseScrollView addSubview:buyVoucherBtn];
    
    
    
    
    float lat = [[self.hotelDetailDict objectForKey:@"LATITUDE"] floatValue];
    float longitude = [[self.hotelDetailDict objectForKey:@"LONGITUDE"] floatValue];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat
                                                            longitude:longitude
                                                                 zoom:15];
    
    mapView = [GMSMapView mapWithFrame:CGRectMake(20, _collectionView.frame.size.height + _collectionView.frame.origin.y + 20, self.baseScrollView.frame.size.width - 40, 400) camera:camera];
    mapView.myLocationEnabled = YES;
//    mapView.userInteractionEnabled = NO;
    [self.baseScrollView addSubview:mapView];
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(lat, longitude);
    marker.map = mapView;
    
    
    // Creates a marker in the center of the map.
    [self addCircleToCordinateLatitude:lat andLongitude:longitude withRadius:400];

    
 self.baseScrollView.contentSize = CGSizeMake(self.baseScrollView.frame.size.width, mapView.frame.origin.y + mapView.frame.size.height + 50);

}

-(void)buyVoucherBtnPressed:(id)sender
{
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    globals.isFromMenuForBuyVoucher = false;
    BuyCouponViewController *buyCoupon =[self.storyboard instantiateViewControllerWithIdentifier:@"BuyCouponViewController"];
    [self.navigationController pushViewController:buyCoupon animated:YES];
}
- (CGFloat)getLabelHeight:(float)width font:(UIFont *)fontsize string:(NSString *)str
{
    CGSize constraint = CGSizeMake(width, CGFLOAT_MAX);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [str boundingRectWithSize:constraint
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:fontsize}
                                                  context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size.height;
}

- (void)addCircleToCordinateLatitude:(double)lat andLongitude:(double)longitude withRadius:(int)rad
{
    CLLocationCoordinate2D circleCenter = CLLocationCoordinate2DMake(lat, longitude);
    circ = [GMSCircle circleWithPosition:circleCenter
                                  radius:rad];
    circ.fillColor = [UIColor  colorWithRed:0.8196 green:0.8784 blue:0.9137 alpha:1.0];
    circ.strokeColor = [ICSingletonManager colorFromHexString:@"#1E90FF"];
    
    circ.map = mapView;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return arr_amenties.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    UIImageView *amentiesImgView = [[UIImageView alloc]init];
    amentiesImgView.image = [UIImage imageNamed:[[arr_amenties objectAtIndex:indexPath.row] valueForKey:@"icon"]];
    [cell.contentView addSubview: amentiesImgView];
    
    UILabel *amentiesLbl = [[UILabel alloc]init];
    amentiesLbl.text = [[arr_amenties objectAtIndex:indexPath.row]valueForKey:@"name"];
    amentiesLbl.textAlignment = NSTextAlignmentLeft;
    amentiesLbl.textColor = [UIColor grayColor];
    amentiesLbl.font = [UIFont fontWithName:@"JosefinSans-Light" size:22];
    [cell.contentView addSubview:amentiesLbl];
    
    
    if (IS_IPAD) {
        amentiesImgView.frame = CGRectMake(10, 0,40 ,40 );
        amentiesLbl.frame = CGRectMake(55, 5,cell.frame.size.width - 40 , 30);
         amentiesLbl.font = [UIFont fontWithName:@"JosefinSans-Light" size:22];
    }else{
        amentiesImgView.frame = CGRectMake(5, 0,25 ,25 );
        amentiesLbl.frame = CGRectMake(35, 1,cell.frame.size.width - 5 , 30);
         amentiesLbl.font = [UIFont fontWithName:@"JosefinSans-Light" size:16];
    }
    
  
    return cell;
    
    }
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(collectionView.frame.size.width/2-10, 40);
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

#pragma mark - KIImagePager DataSource
- (NSArray *) arrayWithImages:(KIImagePager*)pager
{
    return  self.imgArray;
}

- (UIViewContentMode) contentModeForImage:(NSUInteger)image inPager:(KIImagePager *)pager
{
    return UIViewContentModeScaleToFill;
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

-(void)getHotelDetail
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    
    [manager GET:[NSString stringWithFormat: @"%@/api/FAQApi/GetHotelsImageIOSApi?hId=%@",kServerUrl,self.hotelId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
       
        NSMutableArray *hotelImgArr = responseObject;
        
        
        for (id dict in hotelImgArr) {
            
            [self.imgArray addObject:[dict objectForKey:@"CityImage"]];
            
        }
        
        [self  InventoryAvailableForColorPickerDate];
        
    //    [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:error.localizedDescription onController:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
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
- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    // Handle the selection
    
    
    if (row == 0) {
        [_donebtn setEnabled:NO];
    }else{
        [_donebtn setEnabled:YES];
    }
    
    
    if (manageRoomAndDatePicker  == 0) {
        
        
        if (managecheckOutCheckInPickerDate == 0) {
            NSLog(@"%@",[checkInPickerDateArr objectAtIndex:row]);
            selectedCategory = [checkInPickerDateArr objectAtIndex:row];
            selectedCategory  = [NSString stringWithFormat:@"%@",[checkInPickerDateArr objectAtIndex:row]];
            if ([selectedCategory isEqualToString:[checkInPickerDateArr objectAtIndex:0]]) {
                
                
            }
            if ([selectedCategory isEqualToString:[checkInPickerDateArr objectAtIndex:1]]) {
                
                self.checkOutDate = [checkOutPickerDateArr objectAtIndex:1];
                self.numberOfrooms = @"1";
                
            }
            if ([selectedCategory isEqualToString:[checkInPickerDateArr objectAtIndex:2]]) {
                self.checkOutDate = [checkOutPickerDateArr objectAtIndex:2];
                self.numberOfrooms = @"1";
            }
            if ([selectedCategory isEqualToString:[checkInPickerDateArr objectAtIndex:3]]) {
                self.checkOutDate = [checkOutPickerDateArr objectAtIndex:3];
                self.numberOfrooms = @"1";
            }
            
        }else if (managecheckOutCheckInPickerDate == 1)
        {
            self.checkOutDate = [checkOutPickerDateArr objectAtIndex:row];
            
            
            if ([selectedCategory isEqualToString:[checkInPickerDateArr objectAtIndex:1]]) {
                
                if (row == 1) {
                    self.checkOutDate =  [checkOutPickerDateArr objectAtIndex: row];
                }else if (row == 2){
                    self.checkOutDate =  [checkOutPickerDateArr objectAtIndex: row];
                }else if (row == 3){
                    self.checkOutDate =  [checkOutPickerDateArr objectAtIndex: row];
                }
                
            }
            if ([selectedCategory isEqualToString:[checkInPickerDateArr objectAtIndex:2]]) {
                if (row == 1) {
                    self.checkOutDate =  [checkOutPickerDateArr objectAtIndex: 2];
                }else if (row == 2){
                    self.checkOutDate =  [checkOutPickerDateArr objectAtIndex: 3];
                }
            }
            if ([selectedCategory isEqualToString:[checkInPickerDateArr objectAtIndex:3]]) {
                if (row == 1) {
                    self.checkOutDate =  [checkOutPickerDateArr objectAtIndex: 3];
                }
                
            }
            
        }
    }else if (manageRoomAndDatePicker == 1){
        
        self.numberOfrooms = [_roomTableViewArr objectAtIndex:row];
    }
    
    NSLog(@"checkInDate-%@, checkoutDate-%@, NumberOFRooms- %@",selectedCategory, self.checkOutDate, self.numberOfrooms );
    
}
// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (manageRoomAndDatePicker == 0) {
        
        
        if (managecheckOutCheckInPickerDate == 0) {
            return [checkInPickerDateArr count];
        }else if (managecheckOutCheckInPickerDate == 1)
        {
            if ([selectedCategory isEqualToString:[checkInPickerDateArr objectAtIndex:1]]) {
                return 4;
            }
            if ([selectedCategory isEqualToString:[checkInPickerDateArr objectAtIndex:2]]) {
                return 3;
            }
            if ([selectedCategory isEqualToString:[checkInPickerDateArr objectAtIndex:3]]) {
                return 2;
            }
            
            
        }
    }else if (manageRoomAndDatePicker == 1){
        return [_roomTableViewArr count];
    }
    return 0;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (manageRoomAndDatePicker == 0) {
        
        
        if (managecheckOutCheckInPickerDate == 0) {
            return [checkInPickerDateArr objectAtIndex: row];
        }else if (managecheckOutCheckInPickerDate == 1){
            
            if ([selectedCategory isEqualToString:[checkInPickerDateArr objectAtIndex:1]]) {
                
                if (row == 1) {
                    return [checkOutPickerDateArr objectAtIndex: row];
                }else if (row == 2){
                    return [checkOutPickerDateArr objectAtIndex: row];
                }else if (row == 3){
                    return [checkOutPickerDateArr objectAtIndex: row];
                }
                
            }
            if ([selectedCategory isEqualToString:[checkInPickerDateArr objectAtIndex:2]]) {
                if (row == 1) {
                    return [checkOutPickerDateArr objectAtIndex: 2];
                }else if (row == 2){
                    return [checkOutPickerDateArr objectAtIndex: 3];
                }
            }
            if ([selectedCategory isEqualToString:[checkInPickerDateArr objectAtIndex:3]]) {
                if (row == 1) {
                    return [checkOutPickerDateArr objectAtIndex: 2];
                }
                
            }
            
        }
    }else if (manageRoomAndDatePicker == 1){
        return [_roomTableViewArr objectAtIndex:row];
    }
    return 0;
    
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    
    return sectionWidth;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (manageRoomAndDatePicker == 0) {
        
        
        if (managecheckOutCheckInPickerDate == 0) {
            
            if (row == 0) {
                NSAttributedString *attString = [[NSAttributedString alloc] initWithString:[checkInPickerDateArr objectAtIndex:row] attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
                return attString;
                
            }else if (row == 1) {
                
                if ([[inventoryAvailableDatePicker objectForKey:@"RoomInventroy1"] isEqualToString:@"0"]) {
                    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:[checkInPickerDateArr objectAtIndex:row] attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
                    return attString;
                }else if (![[inventoryAvailableDatePicker objectForKey:@"RoomInventroy1"] isEqualToString:@"0"]){
                    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:[checkInPickerDateArr objectAtIndex:row] attributes:@{NSForegroundColorAttributeName:[UIColor greenColor]}];
                    return attString;
                }
                
                
            }else if (row == 2){
                
                if ([[inventoryAvailableDatePicker objectForKey:@"RoomInventroy2"] isEqualToString:@"0"]) {
                    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:[checkInPickerDateArr objectAtIndex:row] attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
                    return attString;
                }else if (![[inventoryAvailableDatePicker objectForKey:@"RoomInventroy2"] isEqualToString:@"0"]){
                    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:[checkInPickerDateArr objectAtIndex:row] attributes:@{NSForegroundColorAttributeName:[UIColor greenColor]}];
                    return attString;
                }
                
                
            }else{
                if ([[inventoryAvailableDatePicker objectForKey:@"RoomInventroy3"] isEqualToString:@"0"]) {
                    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:[checkInPickerDateArr objectAtIndex:row] attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
                    return attString;
                }else if (![[inventoryAvailableDatePicker objectForKey:@"RoomInventroy3"] isEqualToString:@"0"]){
                    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:[checkInPickerDateArr objectAtIndex:row] attributes:@{NSForegroundColorAttributeName:[UIColor greenColor]}];
                    return attString;
                }
            }
        }else if (managecheckOutCheckInPickerDate == 1){
            
            if ([selectedCategory isEqualToString:[checkInPickerDateArr objectAtIndex:1]]) {
                
                if (row == 0) {
                    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:[checkOutPickerDateArr objectAtIndex:row] attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
                    return attString;
                }else if (row == 1){
                    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:[checkOutPickerDateArr objectAtIndex:row] attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
                    return attString;
                    
                }else if (row == 2){
                    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:[checkOutPickerDateArr objectAtIndex:row] attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
                    return attString;
                }else if (row == 3){
                    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:[checkOutPickerDateArr objectAtIndex:row] attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
                    return attString;
                }
                
            }
            if ([selectedCategory isEqualToString:[checkInPickerDateArr objectAtIndex:2]]) {
                if (row == 0) {
                    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:[checkOutPickerDateArr objectAtIndex:row] attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
                    return attString;
                }else if (row == 1) {
                    
                    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:[checkOutPickerDateArr objectAtIndex:2] attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
                    return attString;
                    
                }else if (row == 2){
                    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:[checkOutPickerDateArr objectAtIndex:3] attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
                    return attString;
                }
            }
            if ([selectedCategory isEqualToString:[checkInPickerDateArr objectAtIndex:3]]) {
                if (row == 0) {
                    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:[checkOutPickerDateArr objectAtIndex:row] attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
                    return attString;
                }else if (row == 1) {
                    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:[checkOutPickerDateArr objectAtIndex:3] attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
                    return attString;
                }
                
            }
            
            
            
        }
    }else if (manageRoomAndDatePicker ==1){
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:[_roomTableViewArr objectAtIndex:row] attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
        return attString;
        
    }
    
    return nil;
    
}

-(void)DatePickerCancelBtnPressed:(id)sender
{
    [_donebtn setEnabled:NO];
    datePickerBaseView.hidden = YES;
}

-(void)DatePickerDoneBtnPressed:(id)sender
{
    
    
    datePickerBaseView.hidden = YES;
    NSLog(@"%@",selectedCategory);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
    NSDate *date = [dateFormatter dateFromString:selectedCategory];
    [dateFormatter setDateFormat:@"dd, MMM"];
    
    self.selectDateTxtFld.text = [dateFormatter stringFromDate:date];
    
    NSDateFormatter *dateFormatterCheckOut = [[NSDateFormatter alloc] init];
    [dateFormatterCheckOut setDateFormat:@"dd-MMM-yyyy"];
    NSDate *dateCheckOut = [dateFormatterCheckOut dateFromString:self.checkOutDate];
    [dateFormatter setDateFormat:@"dd, MMM"];
    
    self.checkOutTxtField.text = [dateFormatter stringFromDate:dateCheckOut];
    
    self.checkNumberOfRooms.text = self.numberOfrooms;
    
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"dd-MMM-yyyy"];
    NSDate *startDate = [f dateFromString:selectedCategory];
    NSDate *endDate = [f dateFromString:self.checkOutDate];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:0];
    
    NSLog(@"%ld", [components day]);
    
    int numberOfDaysBwchekInAndOut = (int)[components day];
    
    
    isFromdateSelect = @"YES";
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    NSString *url;
    if ([kServerUrl isEqualToString:@"http://staging.icanstay.com"]) {
        url =   [NSString stringWithFormat: @"%@/Api/FAQApi/HotelsByCityPartial?cityId=%@&searchDate=%@&endDate=%@&noOfRooms=%@",kServerUrl,self.cityId, selectedCategory,self.checkOutDate, self.numberOfrooms];
    }else if ([kServerUrl isEqualToString:@"http://www.icanstay.com"])
    {
        
        url =   [NSString stringWithFormat: @"%@/api/FAQApi/CheckHotelAvailbilityNew?hotelId=%@&sdate=%@&edate=%@&noOfRooms=%@",kServerUrl,self.hotelId, selectedCategory,self.checkOutDate, self.numberOfrooms];
        
    }
       [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
           
           
           manageRoomAndDatePicker = 0;
           managecheckOutCheckInPickerDate = 0;
           
           baseView1.hidden = NO;
           checkOutBaseView.hidden = NO;
           acceptLabel.hidden = NO;
           if ([self.soldOutHotel isEqualToString:@"YES"]) {
               soldOutLbl.hidden = NO;
               bookNowBtn.hidden = YES;
           }else{
               soldOutLbl.hidden = YES;
               bookNowBtn.hidden = NO;
           }
           totalAmountLbl.hidden = NO;
           rightClickImgView.hidden = NO;
           
           
           [_donebtn setEnabled:NO];
           int offerPriceHotel = [self.offerPriceHotelRoom intValue];
           totalAmountLbl.text = [NSString stringWithFormat:@"₹%d(Incl. GST)", numberOfDaysBwchekInAndOut*offerPriceHotel*[self.numberOfrooms integerValue]];

          totalPriceAmount = (int) numberOfDaysBwchekInAndOut *offerPriceHotel *[self.numberOfrooms integerValue];
           if ([kServerUrl isEqualToString:@"http://staging.icanstay.com"]) {
              
               if ([selectedCategory isEqualToString:[checkInPickerDateArr objectAtIndex:1]]) {
                   if ([[inventoryAvailableDatePicker objectForKey:@"RoomInventroy1"] isEqualToString:@"0"]) {
                       soldOutLbl.hidden = NO;
                       bookNowBtn.hidden = YES;
                       acceptLabel.hidden = YES;
                       totalAmountLbl.hidden = YES;
                       rightClickImgView.hidden = YES;
                       [self manageViewAfterCheckInSoldOut];
                       
                   }else{
                       soldOutLbl.hidden = YES;
                       bookNowBtn.hidden = NO;
                       acceptLabel.hidden = NO;
                       totalAmountLbl.hidden = NO;
                       rightClickImgView.hidden = NO;
                       [self manageViewAfterCheckInAvailable];
                       
                   }
               }else  if ([selectedCategory isEqualToString:[checkInPickerDateArr objectAtIndex:2]]) {
                   if ([[inventoryAvailableDatePicker objectForKey:@"RoomInventroy2"] isEqualToString:@"0"]) {
                       soldOutLbl.hidden = NO;
                       bookNowBtn.hidden = YES;
                       acceptLabel.hidden = YES;
                       totalAmountLbl.hidden = YES;
                       rightClickImgView.hidden = YES;
                       [self manageViewAfterCheckInSoldOut];
                       
                       
                   }else{
                       soldOutLbl.hidden = YES;
                       bookNowBtn.hidden = NO;
                       acceptLabel.hidden = NO;
                       totalAmountLbl.hidden = NO;
                       rightClickImgView.hidden = NO;
                       [self manageViewAfterCheckInAvailable];
                       
                   }
               }else  if ([selectedCategory isEqualToString:[checkInPickerDateArr objectAtIndex:3]]) {
                   if ([[inventoryAvailableDatePicker objectForKey:@"RoomInventroy3"] isEqualToString:@"0"]) {
                       soldOutLbl.hidden = NO;
                       bookNowBtn.hidden = YES;
                       acceptLabel.hidden = YES;
                       totalAmountLbl.hidden = YES;
                       rightClickImgView.hidden = YES;
                       [self manageViewAfterCheckInSoldOut];
                       
                   }else{
                       soldOutLbl.hidden = YES;
                       bookNowBtn.hidden = NO;
                       acceptLabel.hidden = NO;
                       totalAmountLbl.hidden = NO;
                       rightClickImgView.hidden = NO;
                       [self manageViewAfterCheckInAvailable];
                       
                   }
               }

           }else if ([kServerUrl isEqualToString:@"http://www.icanstay.com"])
           {
               
             NSString *inventoryStr = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Inventory"]];
               if ([inventoryStr isEqualToString:@"0"]) {
                   soldOutLbl.hidden = NO;
                   bookNowBtn.hidden = YES;
                   acceptLabel.hidden = YES;
                   totalAmountLbl.hidden = YES;
                   rightClickImgView.hidden = YES;
                   [self manageViewAfterCheckInSoldOut];
               }else if (![inventoryStr isEqualToString:@"0"]){
                   soldOutLbl.hidden = YES;
                   bookNowBtn.hidden = NO;
                   acceptLabel.hidden = NO;
                   totalAmountLbl.hidden = NO;
                   rightClickImgView.hidden = NO;
                   [self manageViewAfterCheckInAvailable];
                   
               }
               
               
           }
        
        
 //       [_soldOutHotelArr removeAllObjects];
//        NSArray *soldInArr;
//        NSArray *soldOutArr;
//        if ([kServerUrl isEqualToString:@"http://staging.icanstay.com"]) {
//            soldInArr = [responseObject objectForKey:@"LastminutebindNew"];
//            soldOutArr= [responseObject objectForKey:@"LastSoldMinute"];
//            
//        }else if ([kServerUrl isEqualToString:@"http://www.icanstay.com"])
//        {
//            soldInArr = [responseObject objectForKey:@"StaginLastminutebindNew"];
//            soldOutArr= [responseObject objectForKey:@"StaginLastSoldMinute"];
//            
//        }
        
       //        for (id dict in soldInArr) {
//            [_soldOutHotelArr addObject:dict];
//        }
//        for (id dict in soldOutArr) {
//            [_soldOutHotelArr addObject:dict];
//        }
        
      
       
     
        
        NSLog(@"responseObject=%@",responseObject);
        
     //   [self.hotelListTableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:error.localizedDescription onController:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    
    
    
}


-(void)manageViewAfterCheckInSoldOut
{
    
    bookNowBtnTitleStr = [NSString stringWithFormat:@"Sorry! Sold Out"];
    [baseBookNowBtn setTitle:bookNowBtnTitleStr forState:UIControlStateNormal];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.midDateBookNowBtnBaseView.frame = CGRectMake(5, webView.frame.size.height + webView.frame.origin.y +10,self.view.frame.size.width-10 , 130);
        
        self.acceptBookNowBtnBaseView.frame = CGRectMake(0,checkOutBaseView.frame.origin.y + checkOutBaseView.frame.size.height , self.midDateBookNowBtnBaseView.frame.size.width , 30);
        
        actualPriceLbl.hidden = YES;
        offerPriceLbl.hidden = YES;
        narrowAcualPriceLineView.hidden = YES;
        
        //        actualPriceLbl.frame = CGRectMake(10, self.acceptBookNowBtnBaseView.frame.size.height + self.acceptBookNowBtnBaseView.frame.origin.y +5, 500, 30);
        //        offerPriceLbl.frame = CGRectMake(10,actualPriceLbl.frame.size.height + actualPriceLbl.frame.origin.y , 500, 30);
        //        narrowAcualPriceLineView.frame = CGRectMake(120,actualPriceLbl.frame.origin.y + 15, 50,1 );
        
        CGFloat heightTxtView ;
        if (IS_IPAD) {
            heightTxtView = [self getLabelHeight:self.baseScrollView.frame.size.width - 40 font:[UIFont fontWithName:@"JosefinSans-Light" size:22] string:[self.hotelDetailDict objectForKey:@"HotelContent"]];
            hotelDetailTxtView.font = [UIFont fontWithName:@"JosefinSans-Light" size:22];
        }else{
            heightTxtView = [self getLabelHeight:self.baseScrollView.frame.size.width - 20 font:[UIFont fontWithName:@"JosefinSans-Light" size:18] string:[self.hotelDetailDict objectForKey:@"HotelContent"]];
            hotelDetailTxtView.font = [UIFont fontWithName:@"JosefinSans-Light" size:17];
        }
        
        
        hotelDetailTxtView.frame = CGRectMake(10, self.midDateBookNowBtnBaseView.frame.origin.y + self.midDateBookNowBtnBaseView.frame.size.height  ,self.baseScrollView.frame.size.width - 40    , heightTxtView + 20);
        hotelDetailTxtView.text = [self.hotelDetailDict objectForKey:@"HotelContent"];
        narrrowLineView1.frame = CGRectMake(20, hotelDetailTxtView.frame.size.height + hotelDetailTxtView.frame.origin.y +10 ,self.baseScrollView.frame.size.width - 40, 3);
        narrrowLineView2.frame = CGRectMake(20, hotelDetailTxtView.frame.size.height + hotelDetailTxtView.frame.origin.y +220 ,self.baseScrollView.frame.size.width - 40, 3);
      
        _collectionView.frame = CGRectMake(5,narrrowLineView1.frame.origin.y + 10,self.baseScrollView.frame.size.width - 10,190);
        
        mapView.frame = CGRectMake(20, _collectionView.frame.size.height + _collectionView.frame.origin.y + 20, self.baseScrollView.frame.size.width - 40, 400);
        
        self.baseScrollView.contentSize = CGSizeMake(self.baseScrollView.frame.size.width, mapView.frame.origin.y + mapView.frame.size.height + 50);
        
        
        
    }else{
        
        
        self.midDateBookNowBtnBaseView.frame = CGRectMake(5, webView.frame.size.height + webView.frame.origin.y +10,self.view.frame.size.width-10 , 130);
        
        self.acceptBookNowBtnBaseView.frame = CGRectMake(0,checkOutBaseView.frame.origin.y + checkOutBaseView.frame.size.height , self.midDateBookNowBtnBaseView.frame.size.width , 40);
        
        actualPriceLbl.hidden = YES;
        offerPriceLbl.hidden = YES;
        narrowAcualPriceLineView.hidden = YES;
       
//        actualPriceLbl.frame = CGRectMake(10, self.acceptBookNowBtnBaseView.frame.size.height + self.acceptBookNowBtnBaseView.frame.origin.y +5, 500, 30);
//        offerPriceLbl.frame = CGRectMake(10,actualPriceLbl.frame.size.height + actualPriceLbl.frame.origin.y , 500, 30);
//        narrowAcualPriceLineView.frame = CGRectMake(120,actualPriceLbl.frame.origin.y + 15, 50,1 );
        
        CGFloat heightTxtView ;
        if (IS_IPAD) {
            heightTxtView = [self getLabelHeight:self.baseScrollView.frame.size.width - 40 font:[UIFont fontWithName:@"JosefinSans-Light" size:22] string:[self.hotelDetailDict objectForKey:@"HotelContent"]];
            hotelDetailTxtView.font = [UIFont fontWithName:@"JosefinSans-Light" size:22];
        }else{
            heightTxtView = [self getLabelHeight:self.baseScrollView.frame.size.width - 20 font:[UIFont fontWithName:@"JosefinSans-Light" size:18] string:[self.hotelDetailDict objectForKey:@"HotelContent"]];
            hotelDetailTxtView.font = [UIFont fontWithName:@"JosefinSans-Light" size:17];
        }
        
    
        hotelDetailTxtView.frame = CGRectMake(10, self.midDateBookNowBtnBaseView.frame.origin.y + self.midDateBookNowBtnBaseView.frame.size.height  ,self.baseScrollView.frame.size.width - 20   , heightTxtView + 20);
        hotelDetailTxtView.text = [self.hotelDetailDict objectForKey:@"HotelContent"];
        narrrowLineView1.frame = CGRectMake(20, hotelDetailTxtView.frame.size.height + hotelDetailTxtView.frame.origin.y +10 ,self.baseScrollView.frame.size.width - 40, 3);
        narrrowLineView2.frame = CGRectMake(20, hotelDetailTxtView.frame.size.height + hotelDetailTxtView.frame.origin.y +220 ,self.baseScrollView.frame.size.width - 40, 3);
        _collectionView.frame = CGRectMake(5,narrrowLineView1.frame.origin.y + 10,self.baseScrollView.frame.size.width - 10,190);
        
        mapView.frame = CGRectMake(20, _collectionView.frame.size.height + _collectionView.frame.origin.y + 20, self.baseScrollView.frame.size.width - 40, 400);
      
        self.baseScrollView.contentSize = CGSizeMake(self.baseScrollView.frame.size.width, mapView.frame.origin.y + mapView.frame.size.height + 50);
    }

}

-(void)manageViewAfterCheckInAvailable
{
    bookNowBtnTitleStr = [NSString stringWithFormat:@"₹%d (Incl. GST)  BOOK NOW", totalPriceAmount];
    [baseBookNowBtn setTitle:bookNowBtnTitleStr forState:UIControlStateNormal];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        bookNowBtn.hidden = YES;
        offerPriceLbl.hidden = YES;
        actualPriceLbl.hidden = NO;
        narrowAcualPriceLineView.hidden = NO;
        totalAmountLbl.hidden = YES;
        [baseBookNowBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        
        self.midDateBookNowBtnBaseView.frame = CGRectMake(5, webView.frame.size.height + webView.frame.origin.y +10,self.view.frame.size.width-10 , 210);
        
        self.acceptBookNowBtnBaseView.frame = CGRectMake(0,checkOutBaseView.frame.origin.y + checkOutBaseView.frame.size.height, self.midDateBookNowBtnBaseView.frame.size.width , 110);
        
        
        CGFloat heightTxtView ;
        if (IS_IPAD) {
            heightTxtView = [self getLabelHeight:self.baseScrollView.frame.size.width - 40 font:[UIFont fontWithName:@"JosefinSans-Light" size:22] string:[self.hotelDetailDict objectForKey:@"HotelContent"]];
            hotelDetailTxtView.font = [UIFont fontWithName:@"JosefinSans-Light" size:22];
        }else{
            heightTxtView = [self getLabelHeight:self.baseScrollView.frame.size.width - 20 font:[UIFont fontWithName:@"JosefinSans-Light" size:18] string:[self.hotelDetailDict objectForKey:@"HotelContent"]];
            hotelDetailTxtView.font = [UIFont fontWithName:@"JosefinSans-Light" size:17];
        }
        
        
        hotelDetailTxtView.frame = CGRectMake(10, self.midDateBookNowBtnBaseView.frame.origin.y + self.midDateBookNowBtnBaseView.frame.size.height + 0 ,self.baseScrollView.frame.size.width - 40   , heightTxtView +20);
        hotelDetailTxtView.text = [self.hotelDetailDict objectForKey:@"HotelContent"];
        
        narrrowLineView1.frame = CGRectMake(10, hotelDetailTxtView.frame.size.height + hotelDetailTxtView.frame.origin.y +10 ,self.baseScrollView.frame.size.width - 30, 3);
        narrrowLineView2.frame = CGRectMake(20, hotelDetailTxtView.frame.size.height + hotelDetailTxtView.frame.origin.y +220 ,self.baseScrollView.frame.size.width - 30, 3);
        _collectionView.frame = CGRectMake(5,narrrowLineView1.frame.origin.y + 10,self.baseScrollView.frame.size.width - 10,190);
        
        mapView.frame = CGRectMake(20, _collectionView.frame.size.height + _collectionView.frame.origin.y + 20, self.baseScrollView.frame.size.width - 40, 400);
        self.baseScrollView.contentSize = CGSizeMake(self.baseScrollView.frame.size.width, mapView.frame.origin.y + mapView.frame.size.height + 50);

        
        
        
    }else{
        bookNowBtn.hidden = YES;
        offerPriceLbl.hidden = YES;
        actualPriceLbl.hidden = NO;
        narrowAcualPriceLineView.hidden = NO;
         totalAmountLbl.hidden = YES;
         [baseBookNowBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        
        self.midDateBookNowBtnBaseView.frame = CGRectMake(5, webView.frame.size.height + webView.frame.origin.y +10,self.view.frame.size.width-10 , 230);
        
        self.acceptBookNowBtnBaseView.frame = CGRectMake(0,checkOutBaseView.frame.origin.y + checkOutBaseView.frame.size.height, self.midDateBookNowBtnBaseView.frame.size.width , 130);
        

        CGFloat heightTxtView ;
        if (IS_IPAD) {
            heightTxtView = [self getLabelHeight:self.baseScrollView.frame.size.width - 40 font:[UIFont fontWithName:@"JosefinSans-Light" size:22] string:[self.hotelDetailDict objectForKey:@"HotelContent"]];
            hotelDetailTxtView.font = [UIFont fontWithName:@"JosefinSans-Light" size:22];
        }else{
          heightTxtView = [self getLabelHeight:self.baseScrollView.frame.size.width - 20 font:[UIFont fontWithName:@"JosefinSans-Light" size:18] string:[self.hotelDetailDict objectForKey:@"HotelContent"]];
            hotelDetailTxtView.font = [UIFont fontWithName:@"JosefinSans-Light" size:17];
        }
        

         hotelDetailTxtView.frame = CGRectMake(10, self.midDateBookNowBtnBaseView.frame.origin.y + self.midDateBookNowBtnBaseView.frame.size.height + 0 ,self.baseScrollView.frame.size.width - 20   , heightTxtView +20);
         hotelDetailTxtView.text = [self.hotelDetailDict objectForKey:@"HotelContent"];
        
        narrrowLineView1.frame = CGRectMake(10, hotelDetailTxtView.frame.size.height + hotelDetailTxtView.frame.origin.y +10 ,self.baseScrollView.frame.size.width - 30, 3);
        narrrowLineView2.frame = CGRectMake(20, hotelDetailTxtView.frame.size.height + hotelDetailTxtView.frame.origin.y +220 ,self.baseScrollView.frame.size.width - 30, 3);
        _collectionView.frame = CGRectMake(5,narrrowLineView1.frame.origin.y + 10,self.baseScrollView.frame.size.width - 10,190);
        
        mapView.frame = CGRectMake(20, _collectionView.frame.size.height + _collectionView.frame.origin.y + 20, self.baseScrollView.frame.size.width - 40, 400);
         self.baseScrollView.contentSize = CGSizeMake(self.baseScrollView.frame.size.width, mapView.frame.origin.y + mapView.frame.size.height + 50);
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
   
}



@end
