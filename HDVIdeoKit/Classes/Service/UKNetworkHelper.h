//
//  UKNetworkHelper.h
//  ZMUke
//
//  Created by liqian on 2018/11/2.
//  Copyright © 2018 zmlearn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UKBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^UKSuccessBlock) (UKBaseRequest *request, id response);
typedef void(^UKFailureBlock) (UKBaseRequest *request, id error);
typedef void(^UKProgressBlock) (NSProgress *progress);

typedef void(^NetworkCallBack)(BOOL isSuccess, NSString *alertString);

@interface UKNetworkHelper : NSObject

+ (UKBaseRequest *)GET:(NSString *)url
    parameters:(nullable id)parameters
    success:(nullable UKSuccessBlock)successHandler
    failure:(nullable UKFailureBlock)failureHandler;

+ (UKBaseRequest *)POST:(NSString *)url
  parameters:(nullable id)parameters
     success:(nullable UKSuccessBlock)successHandler
     failure:(nullable UKFailureBlock)failureHandler;

+ (UKBaseRequest *)DELETE:(NSString *)url
               parameters:(nullable id)parameters
                  success:(nullable UKSuccessBlock)successHandler
                  failure:(nullable UKFailureBlock)failureHandler;

+ (UKBaseRequest *)PUT:(NSString *)url
               parameters:(nullable id)parameters
                  success:(nullable UKSuccessBlock)successHandler
                  failure:(nullable UKFailureBlock)failureHandler;

/* POST请求URL里面需要拼接Token
 * 拼接后格式为 https://xxxx?access_token=xxxx
 */
+ (UKBaseRequest *)POSTWithToken:(NSString *)url
           parameters:(nullable id)parameters
              success:(nullable UKSuccessBlock)successHandler
              failure:(nullable UKFailureBlock)failureHandler;

/**
@param method 请求方式
@param withToken 在地址后面是否拼接token
@param parameters 参数
@param whiteList 参数签名白名单，在数组中添加参数的key即可不参与sign签名
*/
+ (UKBaseRequest *)requestWithMethod:(UKRequestMethod)method
                                 URL:(NSString *)url
                           withToken:(BOOL)withToken
                          parameters:(nullable id)parameters
                       signWhiteList:(nullable NSArray<NSString *> *)whiteList
                            progress:(nullable UKProgressBlock)progressBlock
                             success:(nullable UKSuccessBlock)successHandler
                             failure:(nullable UKFailureBlock)failureHandler;

+ (UKBaseRequest *)requestWithMethod:(UKRequestMethod)method
                                 URL:(NSString *)url
                           withToken:(BOOL)withToken
                          parameters:(nullable id)parameters
                       signWhiteList:(nullable NSArray<NSString *> *)whiteList
                             timeout:(NSTimeInterval)timeout
                            progress:(nullable UKProgressBlock)progressHandler
                             success:(nullable UKSuccessBlock)successHandler
                             failure:(nullable UKFailureBlock)failureHandler;

/*!
 @abstract 基于请求url和参数, 生成一个NSMutableURLRequest对象,用于极验验证第一步和第二步修改request
 @Note 极验第一步和第二步校验,要求回调一个NSMutableURLRequest对象, 该对象需要包含优课已有的公共参数,以及sign、白名单等逻辑
 */
+ (NSMutableURLRequest *)requestWithMethod:(UKRequestMethod)method
                                       url:(NSString *)url
                                parameters:(nullable id)parameters;

// 拼接公共参数
+ (nullable id)spliceWithGloableArguments:(nullable id)parameters
                             signWhiteList:(nullable NSArray *)whiteList;

/**
 无BaseUrl
 get 方式请求
 */
+ (UKBaseRequest *)NomalGET:(NSString *)url
    parameters:(nullable id)parameters
    success:(nullable UKSuccessBlock)successHandler
    failure:(nullable UKFailureBlock)failureHandler;

#ifdef Uke_Test

/**
@param method 请求方式
@param withToken 在地址后面是否拼接token
@param parameters 参数
@param forceParam 固定参数
@param whiteList 参数签名白名单，在数组中添加参数的key即可不参与sign签名
*/
+ (UKBaseRequest *)requestWithMethod:(UKRequestMethod)method
                                 URL:(NSString *)url
                           withToken:(BOOL)withToken
                          parameters:(nullable id)parameters
                          forceParam:(nullable id)forceParam
                       signWhiteList:(nullable NSArray<NSString *> *)whiteList
                            progress:(nullable UKProgressBlock)progressHandler
                             success:(nullable UKSuccessBlock)successHandler
                             failure:(nullable UKFailureBlock)failureHandler;

#endif

@end

NS_ASSUME_NONNULL_END
