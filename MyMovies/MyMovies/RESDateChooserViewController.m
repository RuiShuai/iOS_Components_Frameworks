//
//  RESDateChooserViewController.m
//  MyMovies
//
//  Created by taotao on 14/12/25.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESDateChooserViewController.h"

@interface RESDateChooserViewController ()

@end

@implementation RESDateChooserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set selectedDate
    self.dateFormatter = [[NSDateFormatter alloc]init];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    [self.datePicker setDate:self.selectedDate];
    NSString *dateText = [self.dateFormatter stringFromDate:self.selectedDate];
    [self.chooserValueLabel setText:dateText];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)datePickerValueChanged:(id)sender
{
    NSDate *selDate = [self.datePicker date];
    NSString *newDate = [self.dateFormatter stringFromDate:selDate];
    [self.chooserValueLabel setText:newDate];
}

- (IBAction)saveButtonTouched:(id)sender
{
    //传递selectedDate参数
    [self.delegate chooserSelectedDate:[self.datePicker date]];
    //show segue关闭视图
    [self.navigationController popViewControllerAnimated:YES];
}

@end
