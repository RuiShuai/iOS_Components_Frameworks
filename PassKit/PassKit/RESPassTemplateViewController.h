//
//  RESPassTemplateViewController.h
//  PassKit
//
//  Created by taotao on 15/1/10.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PassKit/PassKit.h>


@interface RESPassTemplateViewController : UIViewController<PKAddPassesViewControllerDelegate>


@property (nonatomic ,retain) PKPassLibrary *passLibrary;
@property (nonatomic ,retain) NSString *passFileName;
@property (nonatomic ,retain) NSString *passTypeName;
@property (nonatomic ,retain) NSString *passIdentifier;
@property (nonatomic ,retain) NSString *passSerialNum;

@property (retain, nonatomic) IBOutlet UILabel *numPassesLabel;
@property (retain, nonatomic) IBOutlet UILabel *passInBookLabel;
@property (retain, nonatomic) IBOutlet UIButton *addButton;
@property (retain, nonatomic) IBOutlet UIButton *updateButton;
@property (strong, nonatomic) IBOutlet UIButton *showButton;
@property (retain, nonatomic) IBOutlet UIButton *deleteButton;

- (IBAction)addPassTouched:(id)sender;
- (IBAction)updatePassTouched:(id)sender;
- (IBAction)showPassTouched:(id)sender;
- (IBAction)deletePassTouched:(id)sender;

- (void)refreshPassStatusView;



@end
