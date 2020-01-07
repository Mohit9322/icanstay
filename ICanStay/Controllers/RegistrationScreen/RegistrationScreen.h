//
//  RegistrationScreen.h
//  ICanStay
//
//  Created by Namit Aggarwal on 29/02/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/SignIn.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface RegistrationScreen : UIViewController<GIDSignInUIDelegate>{
    NSDictionary *facebookDict;
}
// Google Sign In Button
@property(weak, nonatomic) IBOutlet GIDSignInButton *signInGoogle;
// Facebook Sign In Button
@property (strong, nonatomic) IBOutlet UIButton *facebookButton;

@end
