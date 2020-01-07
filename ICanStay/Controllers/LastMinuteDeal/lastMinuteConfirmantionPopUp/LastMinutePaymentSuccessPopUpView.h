//
//  LastMinutePaymentSuccessPopUpView.h
//  ICanStay
//
//  Created by Planet on 7/31/17.
//  Copyright © 2017 verticallogics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LastMinutePaymentSuccessPopUpView : UIView
@property (nonatomic,strong)  UIButton       *fbShare;
@property (nonatomic,strong)  UIButton       *cancelPaymentBtn;
@property (nonatomic, strong) UIButton       *twitterShare;

//Access single payment view object
+ (LastMinutePaymentSuccessPopUpView *)lastMinutePaymentSuccessPopUpView:(NSDictionary *)successPaymentDict;

// Mathod to show the Payment view
-(void) showPaymentView;
//Mathod to hide the Payment view
-(void) hidePaymentViewWithCompletion:(void (^ __nullable)(BOOL finished))completion;
@end
