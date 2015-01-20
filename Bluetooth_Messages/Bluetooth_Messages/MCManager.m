//
//  MCManager.m
//  Bluetooth_Messages
//
//  Created by taotao on 15/1/20.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "MCManager.h"


//1.必须是1 - 15字符。2.只能包含ASCII小写字母,数字和连字符。
#define kCustomServiceType @"chat-files"

@implementation MCManager

#pragma mark - MCManager initilaize
- (id)init
{
    self = [super init];
    if (self) {
        _peerID = nil;
        _session = nil;
        _browser = nil;
        _advertiser = nil;
    }
    return self;
}

- (void)setupPeerAndSessionWithDisplayName:(NSString *)displayName
{
    _peerID = [[MCPeerID alloc]initWithDisplayName:displayName];
    _session = [[MCSession alloc]initWithPeer:_peerID];
    _session.delegate = self;
}

- (void)setupMCBrowser
{
    _browser = [[MCBrowserViewController alloc]initWithServiceType:kCustomServiceType session:_session];
    
}

- (void)advertiseSelf:(BOOL)shouldAdvertise
{
    if (shouldAdvertise) {
        _advertiser = [[MCAdvertiserAssistant alloc]initWithServiceType:kCustomServiceType discoveryInfo:nil session:_session];
        [_advertiser start];
    }else{
        [_advertiser stop];
        _advertiser = nil;
    }
}

#pragma mark - MCSession delegate
-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    //post MCDidChangeStateNotification
    NSDictionary *dict = @{@"peerID":peerID,@"state":[NSNumber numberWithInt:state]};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidChangeStateNotification" object:nil userInfo:dict];
    
    
}

-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    //post MCDidReceiveDataNotification
    NSDictionary *dict = @{@"data":data,@"peerID":peerID};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidReceiveDataNotification" object:nil userInfo:dict];
    
}

-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
    //start receive resource
    
}

-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
    //end receive resource
    
}

-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    //receive stream
    
}



@end
