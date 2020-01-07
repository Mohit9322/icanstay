//
//  BuyCouponNewViewController.m
//  ICanStay
//
//  Created by Planet on 12/19/17.
//  Copyright © 2017 verticallogics. All rights reserved.
//

#import "BuyCouponNewViewController.h"

@interface BuyCouponNewViewController ()
{
    UILabel *validTillLbl;
    UILabel *validFromLbl;
    UILabel *luxuryLbl;
    UILabel *amountLbl;
    int roomCount;
}
@property (nonatomic, strong) UIView  *topBlueHeaderBaseView;
@property (nonatomic, strong) UIScrollView *baseScrollView;
@property (nonatomic, strong) UIView      *couponBaseView;
@property (nonatomic,strong)NSDictionary *dictFromServer;
@property (nonatomic, strong) UIView *numberVoucherBaseView;
@property (nonatomic, strong)  UITextField  *CouponTxtFld;
@end

@implementation BuyCouponNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.topBlueHeaderBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    self.topBlueHeaderBaseView.backgroundColor = [ICSingletonManager colorFromHexString:@"#001d3d"];
    [self.view addSubview:self.topBlueHeaderBaseView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backBtn.frame = CGRectMake(10,30 , 30, 20);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"backIconNew"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.topBlueHeaderBaseView addSubview:backBtn];
    
    UILabel *buyVoycherLbl = [[UILabel alloc]initWithFrame:CGRectMake(40, 20, self.view.frame.size.width - 80, 40)];
    buyVoycherLbl.text = @"Buy Voucher(s)";
    buyVoycherLbl.textColor = [UIColor whiteColor];
    buyVoycherLbl.textAlignment = NSTextAlignmentCenter;
    buyVoycherLbl.font = [UIFont boldSystemFontOfSize:20];
    [self.topBlueHeaderBaseView addSubview:buyVoycherLbl];
    
    
    self.baseScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.topBlueHeaderBaseView.frame.size.height + self.topBlueHeaderBaseView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height -
                                                                        (self.topBlueHeaderBaseView.frame.size.height + self.topBlueHeaderBaseView.frame.origin.y))];
    self.baseScrollView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.baseScrollView];
    
     [self createCouponBaseView];
    [self CreateNumberOfVoucherBaseView];
    [self startServiceToGetCouponList];
   
    
}
-(void)CreateNumberOfVoucherBaseView
{
    self.numberVoucherBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, self.couponBaseView.frame.size.height + self.couponBaseView.frame.origin.y, self.view.frame.size.width, 45)];
    self.numberVoucherBaseView.userInteractionEnabled = YES;
    self.numberVoucherBaseView.backgroundColor = [UIColor whiteColor];
    [self.baseScrollView addSubview:self.numberVoucherBaseView];
    
    UILabel *numberOfVoucherLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 170 , 25)];
    numberOfVoucherLbl.text = @"No. OF VOUCHER(S)";
    numberOfVoucherLbl.textColor = [ICSingletonManager colorFromHexString:@"#bd9854"];
    numberOfVoucherLbl.textAlignment = NSTextAlignmentCenter;
    numberOfVoucherLbl.font = [UIFont systemFontOfSize:18];
    numberOfVoucherLbl.backgroundColor = [UIColor clearColor];
    [self.numberVoucherBaseView addSubview:numberOfVoucherLbl];
    
    UIButton *minusVoucherBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    minusVoucherBtn.frame = CGRectMake(numberOfVoucherLbl.frame.origin.x + numberOfVoucherLbl.frame.size.width +10, 10, 25, 25);
    [minusVoucherBtn setBackgroundImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
    [minusVoucherBtn addTarget:self action:@selector(decreaseVoucherCount:) forControlEvents:UIControlEventTouchUpInside];
    [self.numberVoucherBaseView addSubview:minusVoucherBtn];
    
    self.CouponTxtFld = [[UITextField alloc]initWithFrame:CGRectMake(minusVoucherBtn.frame.origin.x + minusVoucherBtn.frame.size.width + 10, 10, 40, 25)];
    self.CouponTxtFld.text = @"1";
    roomCount  = 1;
    self.CouponTxtFld.userInteractionEnabled = NO;
    self.CouponTxtFld.textAlignment = NSTextAlignmentCenter;
    [self.numberVoucherBaseView addSubview:self.CouponTxtFld];
    
    UIButton *plusVoucherBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    plusVoucherBtn.frame = CGRectMake( self.CouponTxtFld.frame.origin.x +  self.CouponTxtFld.frame.size.width + 10, 10, 25, 25);
    [plusVoucherBtn setBackgroundImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
    [plusVoucherBtn addTarget:self action:@selector(IncreaseVoucherCount:) forControlEvents:UIControlEventTouchUpInside];
    [self.numberVoucherBaseView addSubview:plusVoucherBtn];
    
    
}
-(void)IncreaseVoucherCount:(id)sender
{
    if (roomCount != 10 ) {
        roomCount++;
        NSNumberFormatter *numberFormat = [[NSNumberFormatter alloc] init];
        numberFormat.usesGroupingSeparator = YES;
        numberFormat.groupingSeparator = @",";
        numberFormat.groupingSize = 3;
        
//        _selectCouponCount.text = [NSString stringWithFormat:@"%d",roomCount];
//        int amountPaid = 2999*roomCount - cancashAmountAvailable;
//        NSString * amountformat = [numberFormat stringFromNumber: [NSNumber numberWithInt:amountPaid]];
//        NSString * amountformat1 = [numberFormat stringFromNumber: [NSNumber numberWithInt:2999*roomCount]];
//        totalAmountPriceLbl.text = [NSString stringWithFormat:@"₹%@", amountformat1];
//        payPriceLbl.text = [NSString stringWithFormat:@"₹%@", amountformat];
//        [self.buyVoucherBtn setTitle:[NSString stringWithFormat:@"PAY NOW |₹%@",amountformat] forState:UIControlStateNormal];
    }
}
-(void)decreaseVoucherCount:(id)sender
{
    if (roomCount != 1 ) {
        roomCount--;
        
        NSNumberFormatter *numberFormat = [[NSNumberFormatter alloc] init];
        numberFormat.usesGroupingSeparator = YES;
        numberFormat.groupingSeparator = @",";
        numberFormat.groupingSize = 3;
        
        
//        _selectCouponCount.text = [NSString stringWithFormat:@"%d",roomCount];
//        int amountPaid = 2999*roomCount - cancashAmountAvailable;
//        NSString * amountformat = [numberFormat stringFromNumber: [NSNumber numberWithInt:amountPaid]];
//        NSString * amountformat1 = [numberFormat stringFromNumber: [NSNumber numberWithInt:2999*roomCount]];
//        totalAmountPriceLbl.text = [NSString stringWithFormat:@"₹%@", amountformat1];
//        payPriceLbl.text = [NSString stringWithFormat:@"₹%@", amountformat];
//        [self.buyVoucherBtn setTitle:[NSString stringWithFormat:@"PAY NOW |₹%@",amountformat] forState:UIControlStateNormal];
    }
}
-(void)createCouponBaseView
{
    self.couponBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.baseScrollView.frame.size.width, 185)];
    self.couponBaseView.backgroundColor = [ICSingletonManager colorFromHexString:@"#bd9854"];
    [self.baseScrollView addSubview:self.couponBaseView];
    
    UIImageView *couponBaseImgView = [[UIImageView alloc]initWithFrame:CGRectMake(30,10 , self.couponBaseView.frame.size.width - 60, self.couponBaseView.frame.size.height - 20)];
    couponBaseImgView.image = [UIImage imageNamed:@"voucher"];
    [self.couponBaseView addSubview:couponBaseImgView];
    
    
    amountLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, couponBaseImgView.frame.size.width , 40)];
  //  amountLbl.text = @"₹2,999/-";
    amountLbl.textColor = [UIColor whiteColor];
    amountLbl.textAlignment = NSTextAlignmentCenter;
    amountLbl.font = [UIFont boldSystemFontOfSize:30];
    [couponBaseImgView addSubview:amountLbl];
    
    luxuryLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, amountLbl.frame.size.height + amountLbl.frame.origin.y, couponBaseImgView.frame.size.width , 25)];
 //   luxuryLbl.text = @"LUXURY STAY VOUCHER";
    luxuryLbl.textColor = [UIColor whiteColor];
    luxuryLbl.textAlignment = NSTextAlignmentCenter;
    luxuryLbl.font = [UIFont systemFontOfSize:18];
    [couponBaseImgView addSubview:luxuryLbl];
    
    validFromLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, luxuryLbl.frame.size.height + luxuryLbl.frame.origin.y, couponBaseImgView.frame.size.width , 20)];
 //   validFromLbl.text = @"Valid From 19 Dec 2017";
    validFromLbl.textColor = [UIColor whiteColor];
    validFromLbl.textAlignment = NSTextAlignmentCenter;
    validFromLbl.font = [UIFont systemFontOfSize:14];
    [couponBaseImgView addSubview:validFromLbl];
    
    validTillLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, validFromLbl.frame.size.height + validFromLbl.frame.origin.y, couponBaseImgView.frame.size.width , 20)];
 //   validTillLbl.text = @"Valid Till 18 Nov 2018";
    validTillLbl.textColor = [UIColor whiteColor];
    validTillLbl.textAlignment = NSTextAlignmentCenter;
    validTillLbl.font = [UIFont systemFontOfSize:14];
    [couponBaseImgView addSubview:validTillLbl];
    
}

- (void)startServiceToGetCouponList {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    
    [manager GET:[NSString stringWithFormat:@"%@/api/CouponApi/GetBuyCouponDetailMobile?",kServerUrl] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        self.dictFromServer = (NSDictionary *)responseObject;
        [self settingCouponInfoFromServer:self.dictFromServer];
        
        NSLog(@"sucess");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[ICSingletonManager sharedManager] showAlertViewWithMsg:error.localizedDescription onController:self];
        
    }];
}

- (void)settingCouponInfoFromServer:(NSDictionary *)dict
{
 //   if (isTermforReg == NO) {
        NSString *str_price = [NSString stringWithFormat:@"%@",[dict valueForKey:@"CouponPrice"]];
        NSMutableString *mu = [NSMutableString stringWithString:str_price];
        
        if (mu.length>3) {
            [mu insertString:@"," atIndex:mu.length-3];
        }
        
        
        [luxuryLbl setText:[dict valueForKey:@"CouponText"]];
        [amountLbl setText:[NSString stringWithFormat:@"₹%@/-",mu]];
//
//        NSString *stringTermsCondition = nil;
//        if (self.ifFromGiftedCoupon) {
//            stringTermsCondition = [dict valueForKey:@"GiftCouponTerms"];
//            [self.lblGiftCouponText setText:[dict valueForKey:@"GiftCouponFooterTerms"]];
//        }
//        else
//            stringTermsCondition =[dict valueForKey:@"BuyCouponTerms"];
//
//        //    stringTermsCondition= [[ICSingletonManager sharedManager]removeNullObjectFromString:stringTermsCondition];
//        //    stringTermsCondition = [[ICSingletonManager sharedManager] stringByStrippingHTMLFromString:stringTermsCondition];
//
//        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[[stringTermsCondition stringByReplacingOccurrencesOfString:@"Coupon" withString:@"Voucher"] dataUsingEncoding:NSUTF8StringEncoding]
//                                                                       options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
//                                                                                 NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
//                                                            documentAttributes:nil error:nil];
//        NSLog(@"attrStr======%@",attrStr);
        
//        [self.txtView setAttributedText:attrStr];
        
        NSString *strValidFrom =[dict valueForKey:@"CouponValidFrom"];
        strValidFrom= [strValidFrom substringToIndex: MIN(19, strValidFrom.length)];
        NSString *strValidTo = [dict valueForKey:@"CouponValidTill"];
        strValidTo = [strValidTo substringToIndex:MIN(19, strValidTo.length)];
        
        strValidFrom = [[ICSingletonManager sharedManager] returnFormatedStringDateFromString:strValidFrom];
        strValidTo = [[ICSingletonManager sharedManager] returnFormatedStringDateFromString:strValidTo];
        
        [validFromLbl setText:[NSString stringWithFormat:@"Valid From %@",strValidFrom]];
        [validTillLbl setText:[NSString stringWithFormat:@"Valid Till %@",strValidTo]];
//    }
//    else{
//        NSString *stringTermsCondition =[dict valueForKey:@"RegTerms"];
//
//        //    stringTermsCondition= [[ICSingletonManager sharedManager]removeNullObjectFromString:stringTermsCondition];
//        //    stringTermsCondition = [[ICSingletonManager sharedManager] stringByStrippingHTMLFromString:stringTermsCondition];
//
//        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[[stringTermsCondition stringByReplacingOccurrencesOfString:@"Coupon" withString:@"Voucher"] dataUsingEncoding:NSUTF8StringEncoding]
//                                                                       options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
//                                                                                 NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
//                                                            documentAttributes:nil error:nil];
//        NSLog(@"attrStr======%@",attrStr);
//
//        [self.txtView setAttributedText:attrStr];
  //  }
    
    
    //[[ICSingletonManager sharedManager]gettingNewlyFormattedDateStringFromString:[dict valueForKey:@"CouponValidFrom"]];
    //  NSLog(@"%@",str);
    
}

-(void)backBtnPressed:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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

@end
