//
//  CitiesDetailsViewController.h
//  ICanStay
//
//  Created by Namit on 17/11/16.
//  Copyright © 2016 verticallogics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CitiesDetailsViewController : UIViewController

@property (strong, nonatomic) NSString *cityId;
@property (strong, nonatomic) NSString *cityNameStr;
@property (strong, nonatomic) NSString *cityDescriptionStr;
@property (strong,nonatomic) NSArray *arrayHotelList;
@property (strong,nonatomic) NSArray *availableAmenties;


@property (weak, nonatomic) IBOutlet UITableView *hotelTableView;
- (IBAction)backButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *cityName;

//Constraint
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *srHeight;



@end
