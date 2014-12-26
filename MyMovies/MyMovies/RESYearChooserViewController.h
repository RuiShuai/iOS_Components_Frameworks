//
//  RESYearChooserViewController.h
//  MyMovies
//
//  Created by taotao on 14/12/25.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RESYearChooserDelegate <NSObject>
- (void)chooserSelectedYear:(NSString *)year;
@end


@interface RESYearChooserViewController : UITableViewController<UIPickerViewDataSource,UIPickerViewDelegate>

@property (strong,nonatomic) NSString *selectedYear;
@property (weak,nonatomic) id<RESYearChooserDelegate> delegate;

@property (strong, nonatomic) IBOutlet UILabel *chooserValueLabel;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;

@property (strong,nonatomic) NSArray *yearThousands;
@property (strong,nonatomic) NSArray *yearTens;
@property (strong,nonatomic) NSArray *yearOnes;


- (IBAction)saveButtonTouched:(id)sender;


@end
