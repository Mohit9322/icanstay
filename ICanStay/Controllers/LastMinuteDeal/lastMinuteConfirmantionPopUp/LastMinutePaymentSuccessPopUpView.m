//
//  LastMinutePaymentSuccessPopUpView.m
//  ICanStay
//
//  Created by Planet on 7/31/17.
//  Copyright © 2017 verticallogics. All rights reserved.
//

#import "LastMinutePaymentSuccessPopUpView.h"

#define showViewRectIpad CGRectMake(50, ([[UIScreen mainScreen] bounds].size.height - 400)/2, [[UIScreen mainScreen] bounds].size.width - 100, 400)
#define showViewRectPhone CGRectMake(15, 200, [[UIScreen mainScreen] bounds].size.width - 30, 300)
#define hideViewRect CGRectMake(-[[UIScreen mainScreen] bounds].size.width, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)

#define kTagHideView 1020
#define kTagShowView 1021

@interface LastMinutePaymentSuccessPopUpView ()
{
NSDictionary *confirmPaymentJsonDict;
}
@end
@implementation LastMinutePaymentSuccessPopUpView
static LastMinutePaymentSuccessPopUpView  *_PaymentView;



+ (LastMinutePaymentSuccessPopUpView *)lastMinutePaymentSuccessPopUpView:(NSDictionary *)successPaymentDict {
    if (_PaymentView == nil) {
           DLog(@"DEBUG-VC");
    
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
             _PaymentView = [[LastMinutePaymentSuccessPopUpView alloc] initWithFrame:showViewRectIpad successPaymentDict:successPaymentDict];
            
        }else{
             _PaymentView = [[LastMinutePaymentSuccessPopUpView alloc] initWithFrame:showViewRectPhone successPaymentDict:successPaymentDict];
        }
        
       
    }
    
    return _PaymentView;
}

- (id)initWithFrame:(CGRect)frame successPaymentDict:(NSDictionary *)successPaymentDict   {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor greenColor];
        confirmPaymentJsonDict = successPaymentDict;
        [self designPopUp];
        
  }
      return self;
}

-(void)designPopUp
{
    UIView *baseView = [[UIView alloc]init];
    baseView.backgroundColor = [UIColor whiteColor];
    [self addSubview:baseView];
    
    UIView *blueHeaderView = [[UIView alloc]init];
    blueHeaderView.backgroundColor =  [ICSingletonManager colorFromHexString:@"#001d3d"];
    [baseView addSubview:blueHeaderView];
    
    UIImageView *icsLogoImgView = [[UIImageView alloc]init];
    icsLogoImgView.image = [UIImage imageNamed:@"whiteIcsLogo"];
    [blueHeaderView addSubview:icsLogoImgView];
    
    UILabel *confirmLbl = [[UILabel alloc]init];
    confirmLbl.text = @"Confirmation";
    confirmLbl.textColor = [ICSingletonManager colorFromHexString:@"#bd9854"];
    confirmLbl.textAlignment = NSTextAlignmentCenter;
   
    [blueHeaderView addSubview:confirmLbl];
    
    self.cancelPaymentBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.cancelPaymentBtn setTitle:@"X" forState:UIControlStateNormal];
    [self.cancelPaymentBtn addTarget:self action:@selector(cancelPaymentBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.cancelPaymentBtn.backgroundColor =  [ICSingletonManager colorFromHexString:@"#bd9854"];
    self.cancelPaymentBtn.layer.masksToBounds = YES;
    self.cancelPaymentBtn.layer.cornerRadius = 15.0;
    [blueHeaderView addSubview:self.cancelPaymentBtn];
    
    UILabel *congratsLbl = [[UILabel alloc]init];
    congratsLbl.text = [NSString stringWithFormat:@"Congratulations! Room Booked successfully in %@ - %@. Payment Transaction ID is %@. Please check Your Email for Details.", [confirmPaymentJsonDict objectForKey:@"CityName"],[confirmPaymentJsonDict objectForKey:@"HotelName"],[confirmPaymentJsonDict objectForKey:@"TransactionId"] ];
    congratsLbl.lineBreakMode = NSLineBreakByWordWrapping;
    
    [baseView addSubview:congratsLbl];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        baseView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        blueHeaderView.frame = CGRectMake(10, 10, baseView.frame.size.width - 20, 100);
        icsLogoImgView.frame = CGRectMake(20, 20, 150, 50);
        confirmLbl.frame = CGRectMake((blueHeaderView.frame.size.width - 150 )/2, blueHeaderView.frame.size.height *0.25, 150, 30);
         confirmLbl.font = [UIFont systemFontOfSize:24];
         self.cancelPaymentBtn.frame = CGRectMake(blueHeaderView.frame.size.width - 35, 5, 30, 30);
        congratsLbl.frame = CGRectMake(10,blueHeaderView.frame.size.height + blueHeaderView.frame.origin.y + 10 ,baseView.frame.size.width - 20 , 100);
        congratsLbl.numberOfLines = 3;
        congratsLbl.font = [UIFont systemFontOfSize:21];
        
    }else{
        baseView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        blueHeaderView.frame = CGRectMake(10, 10, baseView.frame.size.width - 20, 70);
        icsLogoImgView.frame = CGRectMake(10, 15, 70, 30);
        confirmLbl.frame = CGRectMake((blueHeaderView.frame.size.width - 120 )/2, blueHeaderView.frame.size.height *0.25, 120, 30);
         confirmLbl.font = [UIFont systemFontOfSize:18];
        self.cancelPaymentBtn.frame = CGRectMake(blueHeaderView.frame.size.width - 35, 5, 30, 30);
        congratsLbl.frame = CGRectMake(10,blueHeaderView.frame.size.height + blueHeaderView.frame.origin.y + 10 ,baseView.frame.size.width - 20 , 150);
        congratsLbl.numberOfLines = 6;
        congratsLbl.font = [UIFont systemFontOfSize:18];
    }
    
  
}

-(void)cancelPaymentBtnPressed:(id)sender
{
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations: ^{
       // self.frame = hideViewRect;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    self.tag = kTagHideView;
}
#pragma mark - Show and Hide payment View.
// Mathod to show the Payment view
-(void) showPaymentView    {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations: ^{
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
              self.frame = showViewRectIpad;
        }else{
             self.frame = showViewRectPhone;
        }
      
    }completion:^(BOOL finished) {
//        [_PaymentView getPaymentDetails];
    }];
    self.tag = kTagShowView;
}

//Mathod to hide the Payment view
-(void) hidePaymentViewWithCompletion:(void (^ __nullable)(BOOL finished))completion   {
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations: ^{
        self.frame = hideViewRect;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    self.tag = kTagHideView;
}

@end
