//
//  RESWeatherListViewController.h
//  WeatherAFN
//
//  Created by taotao on 15/1/24.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "RESWeatherHTTPClient.h"
#import "RESLocationManager.h"

@interface RESWeatherListViewController : UITableViewController<NSXMLParserDelegate,UIActionSheetDelegate,RESWeatherHTTPClientDelegate>


- (IBAction)clearTapped:(id)sender;
- (IBAction)jsonTapped:(id)sender;
- (IBAction)plistTapped:(id)sender;
- (IBAction)xmlTapped:(id)sender;
- (IBAction)clientTapped:(id)sender;
- (IBAction)apiTapped:(id)sender;

@end
