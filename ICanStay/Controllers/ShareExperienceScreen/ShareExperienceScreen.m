//
//  ShareExperienceScreen.m
//  
//
//  Created by Vertical Logics on 23/05/16.
//
//

#import "ShareExperienceScreen.h"
#import "AFNetworking.h"
#import "MBProgressHud.h"
#import "HCSStarRatingView.h"
#import "FeedbackScreen.h"
#import "LoginManager.h"
#import "NSDictionary+JsonString.h"
#import <QuartzCore/QuartzCore.h>

//#import <QBImagePickerController/QBImagePickerController.h>

#import "QBImagePickerController.h"

#define kTextViewPlaceholderText @"Enter your feedback"

@interface ShareExperienceScreen ()<QBImagePickerControllerDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblHotelName;

@property (weak, nonatomic) IBOutlet UILabel *lblHotelAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblDatoOfStay;
@property (strong, nonatomic) IBOutlet UIButton *chooesImgBtn;

@property (weak, nonatomic) IBOutlet UILabel *lblBookingDate;
@property (strong, nonatomic) IBOutlet UIButton *submitBtn;

@property (weak, nonatomic) IBOutlet UIButton *btnChooseTapped;

@property (weak, nonatomic) IBOutlet UITextView *txtViewFeedBack;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmitTapped;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *ratingView;
- (IBAction)btnBackTapped:(id)sender;
@property (nonatomic)FeedbackScreen *feedBackData;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constrainstHeightUploadImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constrainstHeightScrolViewContainingImages;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constrainstHeightUploadImageLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constrainstHeightChooseImageBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constrainstWidthImage1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constrainstWidthImage2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constrainstWidthImage3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constrainstWidthImage4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constrainstWidthImage5;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constrainstHeightSubmitButton;
- (IBAction)btnSubmitTapped:(id)sender;
- (IBAction)btnChooseImagesTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imgView1;
@property (weak, nonatomic) IBOutlet UIImageView *imgView2;
@property (weak, nonatomic) IBOutlet UIImageView *imgView3;
@property (weak, nonatomic) IBOutlet UIImageView *imgView4;
@property (weak, nonatomic) IBOutlet UIImageView *imgView5;
@property (nonatomic,copy)NSString *strImageView1;
@property (nonatomic,copy)NSString *strImageView2;
@property (nonatomic,copy)NSString *strImageView3;
@property (nonatomic,copy)NSString *strImageView4;
@property (nonatomic,copy)NSString *strImageView5;

@property (weak, nonatomic) IBOutlet UILabel *lblHeader;



@end

@implementation ShareExperienceScreen

- (void)viewDidLoad {
//    self.chooesImgBtn.layer.cornerRadius = 10;
//    self.chooesImgBtn.clipsToBounds = YES;
//    
//    self.submitBtn.layer.cornerRadius = 10;
//    self.submitBtn.clipsToBounds = YES;
    
    [super viewDidLoad];
     DLog(@"DEBUG-VC");
    // Do any additional setup after loading the view.
    [self.lblHotelName setText:[self.dictionaryCoupon valueForKey:@"HOTEL_NAME"]];
    [self.lblHotelAddress setText:[self.dictionaryCoupon valueForKey:@"ADDRESS"]];
    [self.lblDatoOfStay setText:[self.dictionaryCoupon valueForKey:@"StayDate"]];
    NSString *str = [self.dictionaryCoupon valueForKey:@"BookedOn"];//BookingDate
    if (str.length==0) {
        [self.lblBookingDate setText:[self.dictionaryCoupon valueForKey:@"BookingDate"]];
    }
    else
        [self.lblBookingDate setText:str];
    
    if (self.ifFromfeedBack) {
        
        [self.constrainstHeightUploadImageView setConstant:0];
        [self.constrainstHeightSubmitButton setConstant:0];

        [self.ratingView setUserInteractionEnabled:NO];
        [self.txtViewFeedBack setUserInteractionEnabled:NO];
        [self startServiceToGetFeedBackData];
    }
    else {
        [self.lblHeader setText:@"Share your Experience"];
        self.txtViewFeedBack.text = @"Enter your feedback";
        self.txtViewFeedBack.textColor = [UIColor lightGrayColor];
        self.txtViewFeedBack.delegate = self;
        [self.constrainstHeightScrolViewContainingImages setConstant:0];

    }
}


- (void)implementMultipleImagePicker{
    QBImagePickerController *imagePickerController = [QBImagePickerController new];
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.maximumNumberOfSelection = 5;
    imagePickerController.showsNumberOfSelectedAssets = YES;
    imagePickerController.assetCollectionSubtypes = @[@(PHAssetCollectionSubtypeSmartAlbumUserLibrary), // Camera Roll
                                                      ];
   // imagePickerController.showsNumberOfSelectedAssets = YES;
    [self presentViewController:imagePickerController animated:YES completion:NULL];

}

#pragma mark- QBImagePickerController Methods
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets {
    [self.imgView5 setImage:nil];
    [self.constrainstWidthImage5 setConstant:0];
    [self.imgView4 setImage:nil];
    [self.constrainstWidthImage4 setConstant:0];
    [self.imgView3 setImage:nil];
    [self.constrainstWidthImage3 setConstant:0];
    [self.imgView2 setImage:nil];
    [self.constrainstWidthImage2 setConstant:0];
    [self.imgView1 setImage:nil];
    [self.constrainstWidthImage1 setConstant:0];
    
    if (assets.count >0) {
        
        [self.constrainstHeightScrolViewContainingImages setConstant:120];
    for (int i =0 ; i < assets.count; i++) {
        PHAsset *asset = [assets objectAtIndex:i];
        
        
   // for (PHAsset *asset in assets) {
        // Do something with the asset
      
        // get photo info from this asset
        PHImageRequestOptions * imageRequestOptions = [[PHImageRequestOptions alloc] init];
        imageRequestOptions.synchronous = YES;
        [[PHImageManager defaultManager]
         requestImageDataForAsset:asset
         options:imageRequestOptions
         resultHandler:^(NSData *imageData, NSString *dataUTI,
                         UIImageOrientation orientation,
                         NSDictionary *info)
         {
             
             
             
             
             NSLog(@"info = %@", info);
             if ([info objectForKey:@"PHImageFileURLKey"]) {
                 // path looks like this -
                 // file:///var/mobile/Media/DCIM/###APPLE/IMG_####
                 NSURL *path = [info objectForKey:@"PHImageFileURLKey"];
                 NSLog(@"%@",path);

                 

//                 NSLog(@"%@",PATH_MAX);
             
             }
  
                 
             UIImage *img = [UIImage imageWithData:imageData];
             if (i == 0) {
                 [self.imgView1 setImage:img];
                 self.strImageView1= [asset valueForKey:@"filename"];

                 [self.constrainstWidthImage1 setConstant:120];
             }
             else if (i == 1)
             {
                 [self.imgView2 setImage:img];
                  [self.constrainstWidthImage2 setConstant:120];
                 self.strImageView2= [asset valueForKey:@"filename"];

             }
             else if (i== 2){
                 [self.imgView3 setImage:img];
                  [self.constrainstWidthImage3 setConstant:120];
                 self.strImageView3= [asset valueForKey:@"filename"];

             }
             else if (i == 3){
                 [self.imgView4 setImage:img];
                  [self.constrainstWidthImage4 setConstant:120];
                 self.strImageView4= [asset valueForKey:@"filename"];

             }
             else if (i == 4){
                 [self.imgView5 setImage:img];
                  [self.constrainstWidthImage5 setConstant:120];
                 self.strImageView5= [asset valueForKey:@"filename"];

             }
            
          //   NSLog(@"%@",img);
            // UIImageView *imgv =nil;
             
             

         }];
        
    }
    }
    else
    {
        [self.constrainstHeightScrolViewContainingImages setConstant:0];
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    NSLog(@"Canceled.");
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)startServiceToGetFeedBackData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *strBookType =[self.dictionaryCoupon valueForKey:@"RedeemType"];
    NSDictionary *dictParams=nil;
    if (strBookType.length) {
        dictParams = @{@"couponCode":[self.dictionaryCoupon valueForKey:@"CouponCode"],
        @"BookingId":[self.dictionaryCoupon valueForKey:@"BookingId"],
         @"BookingType":strBookType};
    }
    else
        dictParams = @{@"couponCode":[self.dictionaryCoupon valueForKey:@"CouponCode"],
                       @"BookingId":[self.dictionaryCoupon valueForKey:@"BookingId"],
                       @"BookingType":@"ROOM"};




    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    
    [manager GET:[NSString stringWithFormat:@"%@/api/DynamicContentApi/GetCouponTestimonial?",kServerUrl] parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        self.feedBackData = [FeedbackScreen instanceFromDictionary:(NSDictionary *)responseObject];
        
        if ((!self.feedBackData.strTestImage1.length) && (!self.feedBackData.strTestImage2.length) && (!self.feedBackData.strTestImage3.length) && (!self.feedBackData.strTestImage4.length) && (!self.feedBackData.strTestImage5.length)) {
            
            [self.constrainstHeightScrolViewContainingImages setConstant:0];
            
        }
        else{
            [self.constrainstHeightScrolViewContainingImages setConstant:120];
            
            if (!self.feedBackData.strTestImage1.length) {
                [self.constrainstWidthImage1 setConstant:0];
            }
            else
                [self.imgView1 setImage:[[ICSingletonManager sharedManager] imageFromBase64EncodedString:self.feedBackData.strTestImage1]];
            if (!self.feedBackData.strTestImage2.length) {
                [self.constrainstWidthImage2 setConstant:0];
            }
            else
                [self.imgView2 setImage:[[ICSingletonManager sharedManager] imageFromBase64EncodedString:self.feedBackData.strTestImage2]];
            
            if (!self.feedBackData.strTestImage3.length) {
                [self.constrainstWidthImage3 setConstant:0];
            }
            else
                [self.imgView3 setImage:[[ICSingletonManager sharedManager] imageFromBase64EncodedString:self.feedBackData.strTestImage3]];
            
            if (!self.feedBackData.strTestImage4.length) {
                [self.constrainstWidthImage4 setConstant:0];
            }
            else
                [self.imgView4 setImage:[[ICSingletonManager sharedManager] imageFromBase64EncodedString:self.feedBackData.strTestImage4]];
            
            
            if (!self.feedBackData.strTestImage5.length) {
                [self.constrainstWidthImage5 setConstant:0];
            }
            else
                [self.imgView5 setImage:[[ICSingletonManager sharedManager] imageFromBase64EncodedString:self.feedBackData.strTestImage5]];
        }
        
        [self.txtViewFeedBack setText:self.feedBackData.strTestimonialDesc];
        self.ratingView.value = [self.feedBackData.numRating intValue];
        NSLog(@"sucess");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        

        [self.constrainstHeightUploadImageView setConstant:0];
        [self.constrainstHeightSubmitButton setConstant:0];
       
        if (!self.feedBackData.strTestImage1.length && !self.feedBackData.strTestImage2.length && !self.feedBackData.strTestImage3.length && !self.feedBackData.strTestImage4.length && !self.feedBackData.strTestImage5.length) {
            
             [self.constrainstHeightScrolViewContainingImages setConstant:0];
            
        }
        else{
            if (!self.feedBackData.strTestImage1.length) {
                [self.constrainstWidthImage1 setConstant:0];
            }
            if (!self.feedBackData.strTestImage2.length) {
                [self.constrainstWidthImage2 setConstant:0];
            }
            if (!self.feedBackData.strTestImage3.length) {
                [self.constrainstWidthImage3 setConstant:0];
            }
            if (!self.feedBackData.strTestImage4.length) {
                [self.constrainstWidthImage4 setConstant:0];
            }
            if (!self.feedBackData.strTestImage5.length) {
                [self.constrainstWidthImage5 setConstant:0];
            }
        }

        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[ICSingletonManager sharedManager] showAlertViewWithMsg:error.localizedDescription onController:self];
    }];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnBackTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)btnSubmitTapped:(id)sender {
    [self startServiceToSubmitReview];
    
}

- (IBAction)btnChooseImagesTapped:(id)sender {
    
    [self implementMultipleImagePicker];
    
}

#pragma mark - UITextViewDelegate Methods
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if (self.txtViewFeedBack.textColor == [UIColor lightGrayColor]) {
        self.txtViewFeedBack.text = @"";
        self.txtViewFeedBack.textColor = [UIColor blackColor];
    }
    
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    if(self.txtViewFeedBack.text.length == 0){
        self.txtViewFeedBack.textColor = [UIColor lightGrayColor];
        self.txtViewFeedBack.text = kTextViewPlaceholderText;
        [self.txtViewFeedBack resignFirstResponder];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [self.txtViewFeedBack resignFirstResponder];
        if(self.txtViewFeedBack.text.length == 0){
            self.txtViewFeedBack.textColor = [UIColor lightGrayColor];
            self.txtViewFeedBack.text = kTextViewPlaceholderText;
            [self.txtViewFeedBack resignFirstResponder];
        }
        return NO;
    }
    
    return YES;
}

-(void)startServiceToSubmitReview{
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    
    NSNumber *num = [dict valueForKey:@"UserId"];
    NSString *mobNum = [dict valueForKey:@"UserName"];
    NSString *userName = [dict valueForKey:@"UserName"];
    NSString *testTimonialDesc = self.txtViewFeedBack.text;
    int rating = self.ratingView.value;
    NSString *couponCode =[self.dictionaryCoupon valueForKey:@"CouponCode"];
    
    mobNum = [[ICSingletonManager sharedManager]removeNullObjectFromString:mobNum];
    userName =[[ICSingletonManager sharedManager] removeNullObjectFromString:userName];
    testTimonialDesc = [[ICSingletonManager sharedManager] removeNullObjectFromString:testTimonialDesc];
    couponCode = [[ICSingletonManager sharedManager] removeNullObjectFromString:couponCode];
    
    NSMutableDictionary *dictPost=[[NSMutableDictionary alloc] init];
    [dictPost setValue:num forKey:@"USER_ID"];
    [dictPost setValue:mobNum forKey:@"MobileNo"];
    [dictPost setValue:userName forKey:@"UserName"];
    [dictPost setValue:couponCode forKey:@"CouponCode"];
    [dictPost setValue:testTimonialDesc forKey:@"TestimonialDesc"];
    [dictPost setValue:[self.dictionaryCoupon valueForKey:@"BookingId"] forKey:@"BookingId"],
    [dictPost setValue:[self.dictionaryCoupon valueForKey:@"RedeemType"] forKey:@"BookingType"],
    [dictPost setValue:[NSNumber numberWithInt:rating] forKey:@"Rating"];
    if (self.strImageView1.length) {
        [dictPost setValue:self.strImageView1 forKey:@"TestImageName1"];
        [dictPost setValue:[[ICSingletonManager sharedManager] encodeToBase64String:self.imgView1.image] forKey:@"TestImage1"]; ;

        //set Image1
    }
    if (self.strImageView2.length) {
        [dictPost setValue:self.strImageView2 forKey:@"TestImageName2"];
        [dictPost setValue:[[ICSingletonManager sharedManager] encodeToBase64String:self.imgView2.image] forKey:@"TestImage2"];
    }
    if (self.strImageView3.length) {
        [dictPost setValue:self.strImageView3 forKey:@"TestImageName3"];
        [dictPost setValue:[[ICSingletonManager sharedManager] encodeToBase64String:self.imgView3.image] forKey:@"TestImage3"];
    
    }
    if (self.strImageView4.length) {
        [dictPost setValue:self.strImageView4 forKey:@"TestImageName4"];
        [dictPost setValue:[[ICSingletonManager sharedManager] encodeToBase64String:self.imgView4.image] forKey:@"TestImage4"];
    
    }
    if (self.strImageView5.length) {
        [dictPost setValue:self.strImageView5 forKey:@"TestImageName5"];
        [dictPost setValue:[[ICSingletonManager sharedManager] encodeToBase64String:self.imgView5.image] forKey:@"TestImage5"];    }
    
    NSString *strDictPost = [dictPost jsonStringWithPrettyPrint:NO];
    
    NSString *strUrl =[NSString stringWithFormat:@"%@/api/DynamicContentApi/AddEditTestimonial",kServerUrl];
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
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            NSLog(@"response--%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            
            NSDictionary *dictResp = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: nil];
            NSString *status =[dictResp valueForKey:@"status"];
            if([status isEqualToString:@"SUCCESS"]){
             //   [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateFamilyDetail object:nil];
            }
            [[ICSingletonManager sharedManager]showAlertViewWithMsg:[dictResp valueForKey:@"errorMessage"] onController:self ];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //[self enterPlaceholderText];
            
            
        } else{
            NSLog(@"error--%@",connectionError);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];

}
@end
