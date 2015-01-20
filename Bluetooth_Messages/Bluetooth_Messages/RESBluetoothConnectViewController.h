//
//  RESBluetoothConnectViewController.h
//  Bluetooth_Messages
//
//  Created by taotao on 15/1/16.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>


@interface RESBluetoothConnectViewController : UIViewController<MCBrowserViewControllerDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *txtDisplayName;
@property (strong, nonatomic) IBOutlet UISwitch *swVisible;
@property (strong, nonatomic) IBOutlet UITableView *tblConnectedDevices;
@property (strong, nonatomic) IBOutlet UIButton *btnDisconnect;


@property (nonatomic,strong) MCBrowserViewController *browserViewController;

- (IBAction)browseForDevices:(id)sender;
- (IBAction)toggleVisibility:(id)sender;
- (IBAction)disconnect:(id)sender;


- (IBAction)chatTouched:(id)sender;


@end
