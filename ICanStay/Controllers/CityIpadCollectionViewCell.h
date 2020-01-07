//
//  CityIpadCollectionViewCell.h
//  ICanStay
//
//  Created by Planet on 5/24/17.
//  Copyright © 2017 verticallogics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityIpadCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cityImageView;

@property (weak, nonatomic) IBOutlet UILabel *cityNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *exporePackages;

@end
