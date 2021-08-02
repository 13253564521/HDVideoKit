//
//  UKBaseRequest.m
//  ZMUke
//
//  Created by liqian on 2018/11/5.
//  Copyright © 2018 zmlearn. All rights reserved.
//

#import "UKBaseRequest.h"
#import "UKRequestAgent.h"
#import "Macro.h"
@interface UKBaseRequest ()

@end

@implementation UKBaseRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        self.timeoutInterval = 10;
    }
    return self;
}

- (void)startRequestWithSuccess:(void(^)(id response))successHandler
                       progress:(void(^)(NSProgress *progress))progressBlock
                        failure:(void(^)(NSError *error))failureHandler {
    self.successBlock = successHandler;
    self.progressBlock = progressBlock;
    self.failureBlock = failureHandler;
    [[UKRequestAgent sharedAgent] addRequest:self];
}

- (NSURLRequest *)currentRequest {
    return self.sessionTask.currentRequest;
}

- (BOOL)isRequesting {
    return self.sessionTask.state == NSURLSessionTaskStateRunning;
}

- (void)cancelCurrentRequest {
    [self.sessionTask cancel];
}

- (NSString *)requestDescription {
    NSString *url = self.currentRequest.URL.absoluteString ?: @"";
    
    NSString *parameters = [self.parameters mj_JSONString]?: @"";
    return [NSString stringWithFormat:@"\n URL: %@ \nParameters: %@", url, parameters];
}

- (void)clearBlock {
    
    self.successBlock = nil;
    self.progressBlock = nil;
    self.failureBlock = nil;
}

- (void)dealloc {
    
    if (_sessionTask) {
        [_sessionTask cancel];
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p>{ URL: %@ } \n { method: %@ } \n { arguments: %@ } \n {JSONarguments: %@}", NSStringFromClass([self class]), self, self.currentRequest.URL, self.currentRequest.HTTPMethod, self.parameters, [self.parameters mj_JSONString]];
}

@end
