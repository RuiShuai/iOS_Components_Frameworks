//
//  RUSViewController.h
//  Dynamics
//
//  Created by taotao on 14/12/20.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface RUSViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


@property (strong,nonatomic) IBOutlet UITableView *tableView;


@end
