//
//  MyCouponViewController.h
//  ICanStay
//
//  Created by Christina Masih on 22/03/16.
//  Copyright © 2016 verticallogics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCouponViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property NSString *str_CoupenCount;

//outlets
@property (weak, nonatomic) IBOutlet UIView *viewBottom;
@property (strong, nonatomic) IBOutlet UILabel *lbl_VoucherCount;
@property (strong, nonatomic) IBOutlet UIView *view_CoupenDetails;
@property (weak, nonatomic) IBOutlet UICollectionView *myCouponCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *redeemedCouponTableView;

@property (strong,nonatomic) NSArray *arrayCouponList,*arrayRedeemedCouponList,*arrGiftedCouponList;
@property (weak, nonatomic) IBOutlet UILabel *couponTitleMessage;
- (IBAction)backButtonTap:(id)sender;
- (IBAction)redeemedCouponTap:(id)sender;
- (IBAction)notificationButtonTapped:(id)sender;

@end
