//
//  MCManager.h
//  Bluetooth_Messages
//
//  Created by taotao on 15/1/20.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>


@interface MCManager : NSObject<MCSessionDelegate>

@property (nonatomic,strong) MCPeerID *peerID;
@property (nonatomic,strong) MCSession *session;
@property (nonatomic,strong) MCBrowserViewController *browser;
@property (nonatomic,strong) MCAdvertiserAssistant *advertiser;

- (void)setupPeerAndSessionWithDisplayName:(NSString *)displayName;
- (void)setupMCBrowser;
- (void)advertiseSelf:(BOOL)shouldAdvertise;//宣告自己

@end
