//
//  SearchStayScreen.m
//  ICanStay
//
//  Created by Namit Aggarwal on 26/02/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import "SearchStayScreen.h"
#import "SearchStayResult.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "CityList.h"
#import "CityData.h"
#import "PickerView.h"
#import "CityZoneList.h"
#import "CityZone.h"


@interface SearchStayScreen ()<UITextFieldDelegate,PickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *viewBottom;
- (IBAction)btnMenuTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *submitBtn;

- (IBAction)btnSubmitTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtCityName;

@property (weak, nonatomic) IBOutlet UITextField *txtAreaName;

@property (weak, nonatomic) IBOutlet UITextField *txtSearchFor;

@property (weak, nonatomic) IBOutlet UITextField *txtNumRooms;
@property (weak, nonatomic) IBOutlet UITextField *txtFamilyBook;


@property (nonatomic)CityList *cityList;
@property (nonatomic)CityZoneList *cityZoneList;
@property (nonatomic) PickerView *picker;
@property (nonatomic,strong)NSMutableArray *arrPickerViewData;
//@property (nonatomic,retain)NSArray *arrCityList;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation SearchStayScreen

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.submitBtn.layer.cornerRadius = 10;
//    self.submitBtn.clipsToBounds = YES;
    // Do any additional setup after loading the view.
     DLog(@"DEBUG-VC");
    [[ICSingletonManager sharedManager]addBottomMenuToViewController:self onView:self.viewBottom];
    
    [self startServiceToGetCityNames];
    
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"Search Your Stay"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}


#pragma mark - WebServiceImplementation Mathods
-(void)startServiceToGetCityNames{

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
  
    
    
    NSDictionary *dictParams = @{@"IsHotelMappedCity":@"true"};
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    
    [manager GET:[NSString stringWithFormat:@"%@/api/SearchHotelApi/GetAllCity??",kServerUrl] parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        // NSString *msg = [responseObject valueForKey:@"errorMessage"];
            self.cityList = [CityList instanceFromCityData:responseObject];
            
            NSLog(@"%@",self.cityList);
        
            
        NSLog(@"sucess");
        
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];


}




- (void)startServiceToGetZonesWithId:(NSNumber *)cityId{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    NSDictionary *dictParams = @{@"Cityid":cityId};
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    
    [manager GET:[NSString stringWithFormat:@"%@/api/SearchHotelApi/GetAreaByCity?",kServerUrl] parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        NSArray *arrZones =  (NSArray*)responseObject;
        if (arrZones.count>0) {
            self.cityZoneList = [CityZoneList instanceFromCityZoneList:responseObject];
            [self addingPickerViewfromArray:self.cityZoneList.arrZoneList withIsCityData:NO];
        }
        [self.txtAreaName becomeFirstResponder];
        NSLog(@"sucess");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnMenuTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSubmitTapped:(id)sender {
    SearchStayResult *vcSearchResult = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchStayResult"];
    [self.navigationController pushViewController:vcSearchResult animated:YES];
}


#pragma mark - UITextFieldDelegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField          // became first responder
{
    if (textField == self.txtCityName) {
        [self addingPickerViewfromArray:self.cityList.arrCities withIsCityData:YES];
    }
    else if (textField == self.txtSearchFor){
        [self.datePicker setHidden:NO];
        [self.datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    }
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)addingPickerViewfromArray:(NSArray *)arr withIsCityData:(BOOL)isCityData{
    if (!self.picker)
        self.picker = [[PickerView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-244, [UIScreen mainScreen].bounds.size.width, 244)];
   self.picker.backgroundColor = [UIColor whiteColor];
    self.picker.m_delegate = self;
    self.picker.isCityData = isCityData;
    [self.picker addingDataInArrForPickerViewFromArray:arr];
    [self.picker createPickerView];
    [self.view addSubview:self.picker];
    
}

#pragma mark - PickerViewDelegate Methods
-(void)gettingUserSelectedEvents:(id)obj{
    if ([self.txtCityName isFirstResponder]) {
        CityData *cityData = (CityData *)obj;
        [self.txtCityName setText:cityData.strCityName];
        [self startServiceToGetZonesWithId:cityData.cityId];

    }
    else if ([self.txtAreaName isFirstResponder])
    {
        CityZone *cityZone = (CityZone *)obj;
        [self.txtAreaName setText:cityZone.zoneName];
    }
    [self.picker removeFromSuperview];
    
    
}

- (void)datePickerChanged:(UIDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:datePicker.date];
    self.txtSearchFor.text = strDate;
}
@end
