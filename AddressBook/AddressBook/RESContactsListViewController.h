//
//  RESContactsListViewController.h
//  AddressBook
//
//  Created by taotao on 15/1/12.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>


@interface RESContactsListViewController : UITableViewController<ABNewPersonViewControllerDelegate,ABPersonViewControllerDelegate,ABPeoplePickerNavigationControllerDelegate>

@property (nonatomic,assign) ABAddressBookRef addressBook;
@property (nonatomic,strong) NSArray *addressBookEntryArray;
@property (nonatomic,assign) BOOL showingAddress;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *toggleButton;



- (IBAction)addNewPerson:(id)sender;
- (IBAction)toggleAddress:(id)sender;
- (BOOL)programmaticallyCreatePerson;

@end
