//
//  CurrentStayCell.h
//  ICanStay
//
//  Created by Vertical Logics on 10/03/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrentStayHotelData.h"
//@class CurrentStayHotelData;

@protocol CurrentStayCellDelegate <NSObject>
-(void)switchToShareExperienceScreenWithDictionary:(NSDictionary *)dict;


@end

@interface CurrentStayCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblHotelName;

@property (weak, nonatomic) IBOutlet UILabel *lblCityName;

@property (weak, nonatomic) IBOutlet UILabel *lblStateName;

@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblBooking;
@property (weak, nonatomic) IBOutlet UILabel *lblStayDate;

@property (weak, nonatomic) IBOutlet UIImageView *imgTesting;
@property (weak, nonatomic) IBOutlet UIButton *btnFeedBackReceived;

- (IBAction)btnFeedRecivedTapped:(id)sender;

-(void)settingHotelData:(CurrentStayHotelData *)currentStayData;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constrainstHeightFeedBackReceived;

@property (nonatomic) id<CurrentStayCellDelegate>m_delegate;

@property (nonatomic)NSDictionary *dictionary;



//- (void)downloadImageBackground;


@end
