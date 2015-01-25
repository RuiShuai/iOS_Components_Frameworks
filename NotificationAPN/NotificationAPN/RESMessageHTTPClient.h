//
//  RESAPNHTTPClient.h
//  NotificationAPN
//
//  Created by taotao on 15/1/25.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@protocol RESMessageHTTPClientDelegate;

@interface RESMessageHTTPClient : AFHTTPSessionManager

@property(weak,nonatomic) id<RESMessageHTTPClientDelegate> delegate;

+(RESMessageHTTPClient *)sharedMessageHTTPClient;
-(instancetype)initWithBaseURL:(NSURL *)url;
-(void)pushMessage:(NSDictionary *)message withHTTPMethod:(NSString *)method;

@end

//protocol
@protocol RESMessageHTTPClientDelegate <NSObject>
-(void)messageHTTPClient:(RESMessageHTTPClient *)client didUpdateWithMessage:(id)message;
-(void)messageHTTPClient:(RESMessageHTTPClient *)client didFailWithError:(NSError *)error;
@end

