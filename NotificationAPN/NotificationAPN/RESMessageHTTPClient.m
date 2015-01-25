//
//  RESAPNHTTPClient.m
//  NotificationAPN
//
//  Created by taotao on 15/1/25.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESMessageHTTPClient.h"

static NSString *const kMessageboardServerURLString = @"";
static NSString *const kMessageboardServerAPIKey = @"";

@implementation RESMessageHTTPClient

#pragma mark - overhead
+(RESMessageHTTPClient *)sharedMessageHTTPClient
{
    static RESMessageHTTPClient *_sharedMessageHTTPClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        _sharedMessageHTTPClient = [[self alloc]initWithBaseURL:[NSURL URLWithString:kMessageboardServerURLString]];
    });
    return _sharedMessageHTTPClient;
}

-(instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    return self;
}

-(void)pushMessage:(NSDictionary *)message withHTTPMethod:(NSString *)method
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"num_of_days"]=@(number);
    parameters[@"q"]=message;
    parameters[@"format"]=@"json";
    
    [self POST:@"" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
    }];
    
    
}

@end
