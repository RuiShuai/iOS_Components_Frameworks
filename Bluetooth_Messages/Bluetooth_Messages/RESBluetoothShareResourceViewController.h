//
//  RESBluetoothShareResourceViewController.h
//  Bluetooth_Messages
//
//  Created by taotao on 15/1/20.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RESBluetoothShareResourceViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>

@property (weak,nonatomic) IBOutlet UITableView *tblFiles;

@end
