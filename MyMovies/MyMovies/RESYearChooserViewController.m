//
//  RESYearChooserViewController.m
//  MyMovies
//
//  Created by taotao on 14/12/25.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESYearChooserViewController.h"

typedef enum {
    RESYearChooserComponentCentury = 0,
    RESYearChooserComponentDecade = 1,
    RESYearChooserComponentYear = 2
} RESYearChooserComponentType;

@interface RESYearChooserViewController ()

@end

@implementation RESYearChooserViewController


#pragma mark - view life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.pickerView.delegate = self;
    //self.pickerView.dataSource = self;
    
    //init data
    self.yearThousands = @[@"18",@"19",@"20"];
    self.yearTens = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    
    //2014(20,1,4)century,decade,year
    NSString *selCentury = [self.selectedYear substringToIndex:2];
    NSRange decadeRange = NSMakeRange(2, 1);
    NSString *selDecade = [self.selectedYear substringWithRange:decadeRange];
    NSString *selYear = [self.selectedYear substringFromIndex:3];
    
    /*
    NSLog(@"selCentury:%@,selDecade:%@,selYear:%@",selCentury,selDecade,selYear);
    NSLog(@"yearThousands:%d,yearTens:%d,yearOnes:%d",[self.yearThousands count],[self.yearTens count],[self.yearOnes count]);
    NSLog(@"index:%d,%d,%d",[self.yearThousands indexOfObject:selCentury],[self.yearTens indexOfObject:selDecade],[self.yearTens indexOfObject:selYear]);
    */
    
    //set current year to pickerView's begin state
    [self.chooserValueLabel setText:self.selectedYear];
    
    [self.pickerView selectRow:[self.yearThousands indexOfObject:selCentury]
                   inComponent:RESYearChooserComponentCentury
                      animated:NO];
    [self.pickerView selectRow:[self.yearTens indexOfObject:selDecade]
                   inComponent:RESYearChooserComponentDecade
                      animated:NO];
    [self.pickerView selectRow:[self.yearTens indexOfObject:selYear]
                   inComponent:RESYearChooserComponentYear
                      animated:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


- (IBAction)saveButtonTouched:(id)sender
{
    NSString *selYear = [self.chooserValueLabel text];
    
    //传递selectedYear参数
    [self.delegate chooserSelectedYear:selYear];
    //show segue
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - pickerView data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //2014(20,1,4)
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSUInteger numRows = 0;
    switch (component) {
        case RESYearChooserComponentCentury:
            numRows = [self.yearThousands count];
            break;
        case RESYearChooserComponentDecade:
            numRows = [self.yearTens count];
            break;
        case RESYearChooserComponentYear:
            numRows = [self.yearTens count];
            break;
        default:
            break;
    }
    return numRows;
}




#pragma mark - pickerView delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = @"";
    if (component == 0) {
        title = [self.yearThousands objectAtIndex:row];
    } else {
        title = [self.yearTens objectAtIndex:row];
    }
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //获取当前pickView选择值
    NSString *selThousands = [self.yearThousands objectAtIndex:[pickerView selectedRowInComponent:RESYearChooserComponentCentury]];
    NSString *selTens = [self.yearTens objectAtIndex:[pickerView selectedRowInComponent:RESYearChooserComponentDecade]];
    NSString *selOnes = [self.yearTens objectAtIndex:[pickerView selectedRowInComponent:RESYearChooserComponentYear]];
    
    //拼装
    NSString *yearString = [NSString stringWithFormat:@"%@%@%@",selThousands,selTens,selOnes];
    [self.chooserValueLabel setText:yearString];
    
}



@end
