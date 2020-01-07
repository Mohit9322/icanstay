//
//  CurrentStayCell.m
//  ICanStay
//
//  Created by Vertical Logics on 10/03/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import "CurrentStayCell.h"

@implementation CurrentStayCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(void)settingHotelData:(CurrentStayHotelData *)currentStayData{
    
    //self.hotelData = currentStayData;
    if (currentStayData.strHotelName.length)
        [self.lblHotelName setText:currentStayData.strHotelName];
    if (currentStayData.strState.length)
        [self.lblStateName setText:currentStayData.strState];
    if (currentStayData.strAddress.length)
        [self.lblAddress setText:currentStayData.strAddress];
    if (currentStayData.strBookingDate.length)
        [self.lblBooking setText:currentStayData.strBookingDate];
    if (currentStayData.strStayDate.length) {
        [self.lblStayDate setText:currentStayData.strStayDate];
    }
    if (currentStayData.strCity.length)
        [self.lblCityName setText:currentStayData.strCity];

    if ([currentStayData.numFeedBackReceived isEqualToNumber:[NSNumber numberWithInt:0]]) {
        [self.btnFeedBackReceived setTitle:@"Share your Experience" forState:UIControlStateNormal];
    }
    else if (!currentStayData.numFeedBackReceived){
       // [self.btnFeedBackReceived setHidden:YES];
        [self.constrainstHeightFeedBackReceived setConstant:0];
    }
    else if ([currentStayData.numFeedBackReceived isEqualToNumber:[NSNumber numberWithInt:1]]){
        [self.btnFeedBackReceived setTitle:@"Feedback Received" forState:UIControlStateNormal];
    }
    
    //[self performSelectorInBackground:@selector(downloadImageBackground) withObject:nil];
    //[self downloadImageBackground];
    
    
//        [self.lblHotelName setText:@"Vertic"];
//        [self.lblBooking setText:@"Vertic"];
//        [self.lblCityName setText:@"Vertic"];

    
}


- (IBAction)btnFeedRecivedTapped:(id)sender {
    if ([self.m_delegate respondsToSelector:@selector(switchToShareExperienceScreenWithDictionary:)]) {
        [self.m_delegate  switchToShareExperienceScreenWithDictionary:self.dictionary];
    }
}


//- (void)downloadImageBackground{
//   // http://admin.getgarammasala.com//uploads/category/DAIRY
//    
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://admin.getgarammasala.com//uploads/category/DAIRY"]];
//    [self.imgTesting setImage:[UIImage imageWithData:data]];
//    //self
//}
@end
