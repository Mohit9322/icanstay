//
//  GiftedCouponCell.h
//  
//
//  Created by Vertical Logics on 06/05/16.
//
//

#import <UIKit/UIKit.h>



@interface GiftedCouponCell : UITableViewCell
-(void)settingAllValuesFromDict:(NSDictionary *)dict;

@property (weak, nonatomic) IBOutlet UILabel *lblCouponCodeValue;
@property (weak, nonatomic) IBOutlet UILabel *lblGiftedToValue;
@property (weak, nonatomic) IBOutlet UILabel *lblDayeOfStayValue;
@property (strong, nonatomic) IBOutlet UIButton *resendCredentialBtn;

- (IBAction)btnSendCredentialsTapped:(id)sender;
@end
