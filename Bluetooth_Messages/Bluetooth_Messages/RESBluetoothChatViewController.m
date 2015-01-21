//
//  RESBluetoothChatViewController.m
//  Bluetooth_Messages
//
//  Created by taotao on 15/1/16.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESBluetoothChatViewController.h"
#import "RESAppDelegate.h"

#define kMessageTag 101
#define kBackgroundTag 102

@interface RESBluetoothChatViewController ()
{
    NSMutableArray *chatObjectArray;
}
@property (nonatomic,strong) RESAppDelegate *appDelegate;
-(void)didReceiveDataWithNotification:(NSNotification *)notification;

@end

@implementation RESBluetoothChatViewController

#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _appDelegate = (RESAppDelegate *)[[UIApplication sharedApplication] delegate];
    _txtMessage.delegate = self;
    
    chatObjectArray = [[NSMutableArray alloc]init];
   
    //add MCDidReceiveDataNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveDataWithNotification:) name:@"MCDidReceiveDataNotification" object:nil];
    
    
}

//receive data
-(void)didReceiveDataWithNotification:(NSNotification *)notification
{
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString *peerDisplayName = peerID.displayName;
    
    NSData *receivedData = [[notification userInfo] objectForKey:@"data"];
    NSString *receivedText = [[NSString alloc]initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    //封装接受信息，以字典方式存入chatObjectArray
    NSDictionary *receiveDict = [[NSDictionary alloc]initWithObjectsAndKeys:receivedText,@"message",peerDisplayName,@"receiver",nil];
    [chatObjectArray addObject:receiveDict];
    
    [self.chatTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    //[_tvChat performSelectorOnMainThread:@selector(setText:) withObject:[_tvChat.text stringByAppendingString:[NSString stringWithFormat:@"%@ wrote:\n%@\n\n",peerDisplayName,receivedText]] waitUntilDone:NO];
}

-(void)sendMyMessage:(id)sender
{
    //封装发送信息，以字典方式存入chatObjectArray
    NSDictionary *messageDict = [[NSDictionary alloc]initWithObjectsAndKeys:[_txtMessage text],@"message",@"myself",@"sender", nil];
    
    [chatObjectArray addObject:messageDict];
    NSLog(@"%@",chatObjectArray);
    
    NSData *dataToSend = [_txtMessage.text dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *allPeers = _appDelegate.mcManager.session.connectedPeers;
    NSError *error;
    [_appDelegate.mcManager.session sendData:dataToSend toPeers:allPeers withMode:MCSessionSendDataReliable error:&error];
    
    if (error) {
        NSLog(@"An error occured: %@",[error localizedDescription]);
    }
    
    //[_tvChat setText:[_tvChat.text stringByAppendingString:[NSString stringWithFormat:@"I wrote:\n%@\n\n",_txtMessage.text]]];
    [_txtMessage setText:@""];
    [_txtMessage resignFirstResponder];
    
    [self.sendButton setEnabled:NO];
    [self.chatTable reloadData];
    
    //scroll to the last row
    NSIndexPath* indexPathForLastRow = [NSIndexPath indexPathForRow:[chatObjectArray count]-1 inSection:0];
    [self.chatTable scrollToRowAtIndexPath:indexPathForLastRow atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
#pragma mark Table view data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [chatObjectArray count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UIImageView *msgBackground = nil;
    UILabel *msgText = nil;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        msgBackground = [[UIImageView alloc]init];
        msgBackground.backgroundColor = [UIColor clearColor];
        msgBackground.tag = kMessageTag;
        [cell.contentView addSubview:msgBackground];
        
        msgText = [[UILabel alloc]init];
        msgText.backgroundColor = [UIColor clearColor];
        msgText.tag = kBackgroundTag;
        msgText.numberOfLines = 0;
        msgText.lineBreakMode = NSLineBreakByCharWrapping;
        msgText.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:msgText];
    }
    else{
        msgBackground = (UIImageView *)[cell.contentView viewWithTag:kMessageTag];
        msgText = (UILabel *)[cell.contentView viewWithTag:kBackgroundTag];
    }
    
    //get message
    NSString *message = [[chatObjectArray objectAtIndex:indexPath.row] objectForKey:@"message"];
    
    CGSize size = [message sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(180, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    //
    //NSDictionary *attrs = @{@"NSStringDrawingUsesFontLeading":@1,@"NSStringDrawingTruncatesLastVisibleLine":@5,@"NSStringDrawingUsesLineFragmentOrigin":@0,@"NSStringDrawingUsesDeviceMetrics":@3};
    //CGSize size  = [message sizeWithAttributes:attrs];
    /*
    NSStringDrawingTruncatesLastVisibleLine = 1 << 5, // Truncates and adds the ellipsis character to the last visible line if the text doesn't fit into the bounds specified. Ignored if NSStringDrawingUsesLineFragmentOrigin is not also set.
    NSStringDrawingUsesLineFragmentOrigin = 1 << 0, // The specified origin is the line fragment origin, not the base line origin
    NSStringDrawingUsesFontLeading = 1 << 1, // Uses the font leading for calculating line heights
    NSStringDrawingUsesDeviceMetrics = 1 << 3, // Uses image glyph bounds instead of typographic bounds
    */
    
    UIImage *bubbleImage;
    
    //green chat bubble on right side of screen
    if ([[[chatObjectArray objectAtIndex:indexPath.row] objectForKey:@"sender"] isEqualToString:@"myself"]) {
        msgBackground.frame = CGRectMake(tableView.frame.size.width-size.width-34.0f, 1.0f, size.width+34.0f, size.height+12.0f);
        
        bubbleImage = [[UIImage imageNamed:@"ChatBubbleGreen.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:13];
        
        msgText.frame = CGRectMake(tableView.frame.size.width-size.width-22.0f, 5.0f, size.width+5.0f, size.height);
        msgBackground.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        msgText.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        
    }
    
    //gray chat bubble on left side of screen
    else{
        msgBackground.frame = CGRectMake(0.0f, 1.0f, size.width+34.0f, size.height+12.0f);
        bubbleImage = [[UIImage imageNamed:@"ChatBubbleGray.png"] stretchableImageWithLeftCapWidth:23 topCapHeight:15];
        msgText.frame = CGRectMake(22.0f, 5.0f, size.width+5.0f, size.height);
        msgBackground.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        msgText.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        
    }
    
    msgBackground.image = bubbleImage;
    msgText.text = message;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *message = [[chatObjectArray objectAtIndex:indexPath.row] objectForKey:@"message"];
    CGSize size = [message sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(180, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
    //NSDictionary *attrs = @{@"NSStringDrawingUsesFontLeading":@1,@"NSStringDrawingTruncatesLastVisibleLine":@5,@"NSStringDrawingUsesLineFragmentOrigin":@0,@"NSStringDrawingUsesDeviceMetrics":@3};
    //CGSize size  = [message sizeWithAttributes:attrs];
    
    
    return size.height + 17.0f;
}



#pragma mark - textField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendMyMessage:self];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger textLength = [textField.text length] + [string length] - range.length;
    [self.sendButton setEnabled:(textLength > 0)];
    return YES;
}

#pragma mark -
- (IBAction)sendMessageTouched:(id)sender
{
    [self sendMyMessage:sender];
}



@end
