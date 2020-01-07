//
//  SideMenuController.h
//  ICanStay
//
//  Created by Namit Aggarwal on 23/02/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideMenuController : UIViewController

- (IBAction)faqsButtonTapped:(id)sender;
- (IBAction)aboutUsButtonTapped:(id)sender;
- (IBAction)contactUsButtonTapped:(id)sender;
- (void)startServiceToGetCouponsDetails;
- (void)startServiceToGetCouponsDetailsLastMinuteDeal;

@end
