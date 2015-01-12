//
//  RESPassTemplateViewController.m
//  PassKit
//
//  Created by taotao on 15/1/10.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESPassTemplateViewController.h"

@interface RESPassTemplateViewController ()

@end

@implementation RESPassTemplateViewController


#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.passLibrary = [[PKPassLibrary alloc] init];
    [self refreshPassStatusView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark - pass actions
- (IBAction)addPassTouched:(id)sender
{
    //get pass from bundle
    NSString *passPath = [[NSBundle mainBundle]pathForResource:self.passFileName ofType:@"pkpass"];
    NSData *passData = [NSData dataWithContentsOfFile:passPath];
    NSError *passError = nil;
    PKPass *newPass = [[PKPass alloc]initWithData:passData error:&passError];
    
    if (!passError && ![self.passLibrary containsPass:newPass]) {
        
        PKAddPassesViewController *newPassVC = [[PKAddPassesViewController alloc]initWithPass:newPass];
        
        [newPassVC setDelegate:self];
        [self presentViewController:newPassVC
                           animated:YES
                         completion:^{}];
        
    }else{
        NSString *passUpdateMessage = @"";
        if (passError) {
            passUpdateMessage = [NSString stringWithFormat:@"Pass Error: %@",[passError localizedDescription]];
        }else{
            passUpdateMessage = [NSString stringWithFormat:@"Your %@ has already been added.",self.passTypeName];
        }
        
        //alert
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pass Not Added" message:passUpdateMessage delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
        
    }
}

- (IBAction)updatePassTouched:(id)sender
{
    NSString *passName = [NSString stringWithFormat:@"%@-Update",self.passFileName];
    NSString *passPath = [[NSBundle mainBundle] pathForResource:passName ofType:@"pkpass"];
    NSData *passData = [NSData dataWithContentsOfFile:passPath];
    NSError *passError = nil;
    PKPass *updatePass = [[PKPass alloc]initWithData:passData error:&passError];
    
    if (!passError && [self.passLibrary containsPass:updatePass]) {
        BOOL updated = [self.passLibrary replacePassWithPass:updatePass];
        NSString *passUpdateMessage = @"";
        NSString *passAlertTitle = @"";
        if (updated) {
            passUpdateMessage = [NSString stringWithFormat:@"Your %@ has been updated.",self.passTypeName];
            passAlertTitle = @"Pass Updated.";
        }else{
            passUpdateMessage = [NSString stringWithFormat:@"Your %@ could not be updated.",self.passTypeName];
            passAlertTitle = @"Pass Not Updated.";
        }
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:passAlertTitle message:passUpdateMessage delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
        [alert show];
    }
}

- (IBAction)showPassTouched:(id)sender
{
    PKPass *currentBoardingPass = [self.passLibrary passWithPassTypeIdentifier:self.passIdentifier serialNumber:self.passSerialNum];
    
    if (currentBoardingPass) {
        [[UIApplication sharedApplication] openURL:[currentBoardingPass passURL]];
    }
}

- (IBAction)deletePassTouched:(id)sender
{
    PKPass *currentBoardingPass = [self.passLibrary passWithPassTypeIdentifier:self.passIdentifier serialNumber:self.passSerialNum];
    if (currentBoardingPass) {
        [self.passLibrary removePass:currentBoardingPass];
        [self refreshPassStatusView];
        NSString *passUpdateMessage = [NSString stringWithFormat:@"Your %@ has been removed.",self.passTypeName];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pass Removed" message:passUpdateMessage delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
        [alert show];
    }
}

#pragma mark - PKAddPassesViewController delegate
-(void)addPassesViewControllerDidFinish:(PKAddPassesViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self refreshPassStatusView];
    }];
}

- (void)refreshPassStatusView
{
    if (![PKPassLibrary isPassLibraryAvailable]) {
        [self.passInBookLabel setText:@"Pass Library not available"];
        
        [self.numPassesLabel setText:@""];
        [self.addButton setHidden:YES];
        [self.updateButton setHidden:YES];
        [self.showButton setHidden:YES];
        [self.deleteButton setHidden:YES];
        return;
    }
    
    NSArray *passes = [self.passLibrary passes];
    NSLog(@"passes count:%d",[passes count]);
    
    NSString *numPassesString = [NSString stringWithFormat:@"There are %d passes in Passbook.",[passes count]];
    
    [self.numPassesLabel setText:numPassesString];
    
    PKPass *currentBoardingPass =
    [self.passLibrary passWithPassTypeIdentifier:self.passIdentifier serialNumber:self.passSerialNum];
    NSLog(@"passIdentifier:%@,passSerialNum:%@",self.passIdentifier,self.passSerialNum);
    
    if (currentBoardingPass) {
        [self.passInBookLabel setText:[NSString stringWithFormat:@"%@ is in Passbook",self.passTypeName]];
        [self.updateButton setHidden:NO];
        [self.showButton setHidden:NO];
        [self.deleteButton setHidden:NO];
    }else{
        [self.passInBookLabel setText:[NSString stringWithFormat:@"%@ is not in Passbook",self.passTypeName]];
        [self.updateButton setHidden:YES];
        [self.showButton setHidden:YES];
        [self.deleteButton setHidden:YES];
    }
    
}

@end
