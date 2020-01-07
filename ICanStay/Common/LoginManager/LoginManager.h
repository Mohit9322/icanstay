//
//  LoginManager.h
//  ICanStay
//
//  Created by Namit Aggarwal on 29/02/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginManager : NSObject

- (NSDictionary *)isUserLoggedIn;
- (void)loginUserWithUserDataDictionary:(NSDictionary *)dictUserData;
- (BOOL)isFirstTimeLogin;
- (void)removeUserModelDictionary;
@end
