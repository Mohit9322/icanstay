//
//  CurrentStayScreen.h
//  ICanStay
//
//  Created by Vertical Logics on 10/03/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrentStayScreen : UIViewController

@property BOOL isPastStayScreen;

@property BOOL comingFromMapScreen;

@property (nonatomic, strong) NSDictionary *confirmPaymentJsonDict;

@end
