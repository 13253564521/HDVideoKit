//
//  UKRequestAgent.m
//  ZMUke
//
//  Created by liqian on 2018/12/6.
//  Copyright © 2018 zmlearn. All rights reserved.
//

#import "UKRequestAgent.h"
#import "UKBaseRequest.h"
#import "Macro.h"
#import "HDUkeInfoCenter.h"
@interface UKRequestAgent ()
@property (nonatomic, readwrite, strong) LHDAFHTTPSessionManager *manager;
@end

@implementation UKRequestAgent

- (void)addRequest:(UKBaseRequest *)request {
    
    NSURL *url = [NSURL URLWithString:[HDUkeInfoCenter sharedCenter].configurationModel.HTTPURL];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    _manager = [[LHDAFHTTPSessionManager alloc] initWithBaseURL:url sessionConfiguration:configuration];
    
    if (self.manager.requestSerializer.timeoutInterval != request.timeoutInterval) {
        self.manager.requestSerializer.timeoutInterval = request.timeoutInterval;
    }
    HDUkeInfoCenterModel *model = HDUkeInfoCenter.sharedCenter.userModel;
    if (model.token.length > 0) {
        AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        [requestSerializer setValue:model.token forHTTPHeaderField:@"Authorization"];
        _manager.requestSerializer = requestSerializer;

    }
    

    
    switch (request.requestMethod) {
        case UKRequestMethodGET: {

            NSURLSessionDataTask *dataTask;
            
            dataTask = [self.manager GET:request.requestURL parameters:request.parameters headers:nil progress:request.progressBlock success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                !request.successBlock ?: request.successBlock(responseObject);
                [request clearBlock];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                !request.failureBlock ?: request.failureBlock(error);
                [request clearBlock];
            }];
            request.sessionTask = dataTask;
        } break;
            
        case UKRequestMethodPOST: {

            NSURLSessionDataTask *dataTask;
            
            dataTask = [self.manager POST:request.requestURL parameters:request.parameters headers:nil progress:request.progressBlock success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                !request.successBlock ?: request.successBlock(responseObject);
                [request clearBlock];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                !request.failureBlock ?: request.failureBlock(error);
                [request clearBlock];
            }];
            request.sessionTask = dataTask;
        } break;
         
        case UKRequestMethodDELETE: {
            NSURLSessionDataTask *dataTask;
            
            dataTask = [self.manager DELETE:request.requestURL parameters:request.parameters headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                !request.successBlock ?: request.successBlock(responseObject);
                [request clearBlock];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                !request.failureBlock ?: request.failureBlock(error);
                [request clearBlock];
            }];
            request.sessionTask = dataTask;
        } break;
            
        case UKRequestMethodPUT: {
            NSURLSessionDataTask *dataTask;
            
            dataTask = [self.manager PUT:request.requestURL parameters:request.parameters headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                !request.successBlock ?: request.successBlock(responseObject);
                [request clearBlock];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                !request.failureBlock ?: request.failureBlock(error);
                [request clearBlock];
            }];
            request.sessionTask = dataTask;
        } break;
        default: {
            
        } break;
    }
}

+ (UKRequestAgent *)sharedAgent {
    static UKRequestAgent *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UKRequestAgent alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self resetManager];
    }
    return self;
}

- (void)resetManager {
    
    NSURL *url = [NSURL URLWithString:[HDUkeInfoCenter sharedCenter].configurationModel.HTTPURL];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    _manager = [[LHDAFHTTPSessionManager alloc] initWithBaseURL:url sessionConfiguration:configuration];
    
//    AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
//    [requestSerializer setValue:kAPI_Version forHTTPHeaderField:@"Api-Version"];

//    _manager.requestSerializer = requestSerializer;
    
   
}

@end
