//
//  RESFriendChooserViewController.h
//  MyMovies
//
//  Created by taotao on 14/12/25.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RESFriendManagedObject;

@protocol RESFriendChooserDelegate <NSObject>
-(void)chooserSelectedFriend:(RESFriendManagedObject *)friendMO;
@end

@interface RESFriendChooserViewController : UITableViewController

@property (weak,nonatomic) RESFriendManagedObject *selectedFriend;
@property (weak,nonatomic) id<RESFriendChooserDelegate> delegate;

@end
