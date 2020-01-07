//
//  PickerView.m
//  ICanStay
//
//  Created by Vertical Logics on 04/03/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import "PickerView.h"
#import "CityData.h"
#import "CityZone.h"

@interface PickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic) UIPickerView *pickerView;
@end

@implementation PickerView


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


#pragma mark - UIPickerViewCreation Method

- (void)createPickerView{
    if (!self.pickerView) {
    
   self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, [UIScreen mainScreen].bounds.size.width, 220)];
    self.pickerView.showsSelectionIndicator = YES;
    self.pickerView.hidden = NO;
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self addSubview:self.pickerView];
    
    [self addDoneButtonToPickerView];
    }
   // self.pickerView.backgroundColor=[UIColor greenColor];
    [self.pickerView reloadAllComponents];
}


- (void)addingDataInArrForPickerViewFromArray:(NSArray *)arr{
    
    [self.arrPickerData removeAllObjects];
    self.arrPickerData = [arr mutableCopy];
}

#pragma mark -UIPickerViewDelegate Methods


//Columns in picker views

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView; {
    return 1;
}
//Rows in each Column

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component; {
    return self.arrPickerData.count;
}


// these methods return either a plain NSString, a NSAttributedString, or a view (e.g UILabel) to display the row for the component.
-(NSString*) pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (self.isCityData) {
        CityData *cityData = [self.arrPickerData objectAtIndex:row];
        return cityData.strCityName;
    }
    else{
        CityZone *cityZone = [self.arrPickerData objectAtIndex:row];
        return cityZone.zoneName;
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
{
    //Write the required logic here that should happen after you select a row in Picker View.
}
- (void)addDoneButtonToPickerView{
    
    
    UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,44)];
    [toolBar setBarStyle:UIBarStyleBlackOpaque];
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(changeDateFromLabel)];
    toolBar.items = @[barButtonDone];
    barButtonDone.tintColor=[UIColor blackColor];
    [self addSubview:toolBar];
    
}


- (void)changeDateFromLabel{
    if ([self.m_delegate respondsToSelector:@selector(gettingUserSelectedEvents:)]) {
        NSInteger row = [self.pickerView selectedRowInComponent:0];
        id obj = [self.arrPickerData objectAtIndex:row];
        [self.m_delegate gettingUserSelectedEvents:obj];

    }
    
    [self removeFromSuperview];

}
@end
