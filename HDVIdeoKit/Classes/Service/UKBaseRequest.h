//
//  UKBaseRequest.h
//  ZMUke
//
//  Created by liqian on 2018/11/5.
//  Copyright © 2018 zmlearn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSInteger {
    UKRequestMethodGET = 0,
    UKRequestMethodPOST = 1,
    UKRequestMethodDELETE = 2,
    UKRequestMethodPUT = 3
} UKRequestMethod;

@interface UKBaseRequest : NSObject

//! 请求方式
@property (nonatomic, assign) UKRequestMethod requestMethod;

//! 请求地址：可以是一个完整地址，或是一个相对路径地址
@property (nonatomic, copy) NSString *requestURL;

//! 请求参数
@property (nonatomic, strong, nullable) id parameters;

//! 超时时间，默认10s
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

@property (nonatomic, nullable, copy) void(^successBlock) (id response);
@property (nonatomic, nullable, copy) void(^failureBlock) (NSError *error);
@property (nonatomic, nullable, copy) void(^progressBlock) (NSProgress *progress);

//! 请求完成后可获取的值
@property (nonatomic, strong) NSURLSessionTask *sessionTask;
@property (nonatomic, strong, readonly) NSURLRequest *currentRequest;
//! 是否正在请求
@property (nonatomic, assign) BOOL isRequesting;

//! 开始请求
- (void)startRequestWithSuccess:(nullable void(^)(id response))successHandler
                       progress:(nullable void(^)(NSProgress *progress))progressBlock
                        failure:(nullable void(^)(NSError *error))failureHandler;

- (NSString *)requestDescription;

//! 取消当前请求
- (void)cancelCurrentRequest;

//! 清掉block引用
- (void)clearBlock;

@end

NS_ASSUME_NONNULL_END
