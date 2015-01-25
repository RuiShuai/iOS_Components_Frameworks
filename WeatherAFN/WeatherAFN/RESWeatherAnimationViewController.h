//
//  RESWeatherAnimationViewController.h
//  WeatherAFN
//
//  Created by taotao on 15/1/24.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RESWeatherAnimationViewController : UIViewController

@property(nonatomic,strong) NSDictionary *weatherDictionary;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UILabel *temperatureLabel;

-(void)start:(NSString *)type;
-(void)stop;

-(IBAction)updateBackgroundImage:(id)sender;
-(IBAction)deleteBackgroundImage:(id)sender;

@end
