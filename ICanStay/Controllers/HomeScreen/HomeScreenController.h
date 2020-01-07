//
//  HomeScreenController.h
//  ICanStay
//
//  Created by Namit Aggarwal on 23/02/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KIImagePager.h"

@interface HomeScreenController : UIViewController<KIImagePagerDelegate, KIImagePagerDataSource>
{
    NSArray * imageArray;
}

- (IBAction)buyButtonTapped:(id)sender;
- (IBAction)redeemButtonTapped:(id)sender;
- (IBAction)citiesButtonTapped:(id)sender;
- (IBAction)faqsButtonTapped:(id)sender;
- (IBAction)notificationButtonTapped:(id)sender;
- (void)checkVersionUpdate;
@end
