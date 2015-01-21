//
//  RESBluetoothConnectViewController.m
//  Bluetooth_Messages
//
//  Created by taotao on 15/1/16.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESBluetoothConnectViewController.h"
#import "RESAppDelegate.h"

@interface RESBluetoothConnectViewController ()

@property (nonatomic,strong) RESAppDelegate *appDelegate;
@property (nonatomic,strong) NSMutableArray *arrConnectedDevices;
-(void) peerDidChangeStateWithNotification:(NSNotification *)notification;

@end


@implementation RESBluetoothConnectViewController

#pragma mark - view life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //mcManager init
    _appDelegate = (RESAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[_appDelegate mcManager] setupPeerAndSessionWithDisplayName:[[UIDevice currentDevice] name]];
    [[_appDelegate mcManager] advertiseSelf:_swVisible.isOn];
   
    //textField
    [_txtDisplayName setDelegate:self];
    
    //add notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(peerDidChangeStateWithNotification:) name:@"MCDidChangeStateNotification" object:nil];
    
    //tableView
    _arrConnectedDevices = [[NSMutableArray alloc]init];
    [_tblConnectedDevices setDelegate:self];
    [_tblConnectedDevices setDataSource:self];
}


#pragma mark - state notification
-(void) peerDidChangeStateWithNotification:(NSNotification *)notification
{
    //peerID state
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString *peerDisplayName = peerID.displayName;
    MCSessionState state = [[[notification userInfo] objectForKey:@"state"] intValue];
    
    if (state != MCSessionStateConnecting) {
        
        if (state == MCSessionStateConnected) {
            [_arrConnectedDevices addObject:peerDisplayName];
        }else if (state==MCSessionStateNotConnected){
            if ([_arrConnectedDevices count]>0) {
                int indexOfPeer = (int)[_arrConnectedDevices indexOfObject:peerDisplayName];
                [_arrConnectedDevices removeObjectAtIndex:indexOfPeer];
            }
        }
        
        [_tblConnectedDevices reloadData];
        
        //button state
        BOOL peersExist = ([[_appDelegate.mcManager.session connectedPeers] count] == 0);
        [_btnDisconnect setEnabled:!peersExist];
        
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - browser,connect peers
- (IBAction)browseForDevices:(id)sender
{
    [[_appDelegate mcManager] setupMCBrowser];
    [[[_appDelegate mcManager] browser] setDelegate:self];
    [self presentViewController:[[_appDelegate mcManager] browser] animated:YES completion:nil];
    
}


- (IBAction)toggleVisibility:(id)sender
{
    [_appDelegate.mcManager advertiseSelf:_swVisible.isOn];
}

- (IBAction)disconnect:(id)sender
{
    [_appDelegate.mcManager.session disconnect];
    
    _txtDisplayName.enabled = YES;
    
    [_arrConnectedDevices removeAllObjects];
    [_tblConnectedDevices reloadData];
}

- (IBAction)beginChatAction:(id)sender {
}

- (IBAction)fileSharingAction:(id)sender {
}


#pragma mark - MCBrowserViewController delegate

-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    
    //Todo:
    
    [_appDelegate.mcManager.browser dismissViewControllerAnimated:YES completion:nil];
    
    
}

-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    [_appDelegate.mcManager.browser dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TextField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_txtDisplayName resignFirstResponder];
    
    //prepare param
    _appDelegate.mcManager.peerID = nil;
    _appDelegate.mcManager.session = nil;
    _appDelegate.mcManager.browser = nil;
    
    if ([_swVisible isOn]) {
        [_appDelegate.mcManager.advertiser stop];
    }
    _appDelegate.mcManager.advertiser = nil;
    
    //init mcManager
    [_appDelegate.mcManager setupPeerAndSessionWithDisplayName:_txtDisplayName.text];
    [_appDelegate.mcManager setupMCBrowser];
    [_appDelegate.mcManager advertiseSelf:_swVisible.isOn];
    
    return YES;
}


#pragma mark - UITableView dataSource,delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrConnectedDevices count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [_arrConnectedDevices objectAtIndex:indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    
    
}



@end
