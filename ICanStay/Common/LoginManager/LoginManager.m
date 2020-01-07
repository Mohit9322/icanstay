//
//  LoginManager.m
//  ICanStay
//
//  Created by Namit Aggarwal on 29/02/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import "LoginManager.h"

@implementation LoginManager
- (NSDictionary *)isUserLoggedIn{
    
    NSDictionary * userModelDictionary =[[NSUserDefaults standardUserDefaults]objectForKey:KUserLogin];
    return userModelDictionary;
}

- (void)loginUserWithUserDataDictionary:(NSDictionary *)dictUserData
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:KUserLogin];
    [[NSUserDefaults standardUserDefaults] setObject:dictUserData forKey:KUserLogin];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (BOOL)isFirstTimeLogin{
    BOOL isFirstTimeLogin =YES;
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:KUserLogin];
    NSString *strLastTimeLogin = [dict valueForKey:@"LastLoginTime"];
    if (strLastTimeLogin.length)
        isFirstTimeLogin = NO;
    else
        isFirstTimeLogin = YES;
    
    return isFirstTimeLogin;
}


- (void)removeUserModelDictionary{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:KUserLogin];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
@end
