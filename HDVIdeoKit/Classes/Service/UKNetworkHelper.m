//
//  UKNetworkHelper.m
//  ZMUke
//
//  Created by liqian on 2018/11/2.
//  Copyright © 2018 zmlearn. All rights reserved.
//

#import "UKNetworkHelper.h"
#import "UKRequestAgent.h"
#import <AdSupport/AdSupport.h>
#import "Macro.h"
#import "HDUkeInfoCenter.h"

@implementation UKNetworkHelper

+ (UKBaseRequest *)GET:(NSString *)url parameters:(nullable id)parameters success:(nullable UKSuccessBlock)successHandler failure:(nullable UKFailureBlock)failureHandler {
    return [self requestWithMethod:UKRequestMethodGET URL:url withToken:NO parameters:parameters signWhiteList:nil progress:nil success:successHandler failure:failureHandler];
}

+ (UKBaseRequest *)DELETE:(NSString *)url parameters:(id)parameters success:(UKSuccessBlock)successHandler failure:(UKFailureBlock)failureHandler {
    return [self requestWithMethod:UKRequestMethodDELETE URL:url withToken:NO parameters:parameters signWhiteList:nil progress:nil success:successHandler failure:failureHandler];
}
+ (UKBaseRequest *)POST:(NSString *)url parameters:(nullable id)parameters success:(nullable UKSuccessBlock)successHandler failure:(nullable UKFailureBlock)failureHandler {
    return [self requestWithMethod:UKRequestMethodPOST URL:url withToken:NO parameters:parameters signWhiteList:nil progress:nil success:successHandler failure:failureHandler];
}

+ (UKBaseRequest *)PUT:(NSString *)url parameters:(id)parameters success:(UKSuccessBlock)successHandler failure:(UKFailureBlock)failureHandler {
    return [self requestWithMethod:UKRequestMethodPUT URL:url withToken:NO parameters:parameters signWhiteList:nil progress:nil success:successHandler failure:failureHandler];
}
+ (UKBaseRequest *)POSTWithToken:(NSString *)url
           parameters:(nullable id)parameters
              success:(nullable UKSuccessBlock)successHandler
              failure:(nullable UKFailureBlock)failureHandler {
    return [self requestWithMethod:UKRequestMethodPOST URL:url withToken:YES parameters:parameters signWhiteList:nil progress:nil success:successHandler failure:failureHandler];
}

+ (UKBaseRequest *)requestWithMethod:(UKRequestMethod)method
                                 URL:(NSString *)url
                           withToken:(BOOL)withToken
                          parameters:(nullable id)parameters
                       signWhiteList:(nullable NSArray<NSString *> *)whiteList
                            progress:(nullable UKProgressBlock)progressHandler
                             success:(nullable UKSuccessBlock)successHandler
                             failure:(nullable UKFailureBlock)failureHandler {
    
    return [self requestWithMethod:method URL:url withToken:withToken parameters:parameters signWhiteList:whiteList timeout:0 progress:progressHandler success:successHandler failure:failureHandler];
}

+ (UKBaseRequest *)requestWithMethod:(UKRequestMethod)method
                                 URL:(NSString *)url
                           withToken:(BOOL)withToken
                          parameters:(nullable id)parameters
                       signWhiteList:(nullable NSArray<NSString *> *)whiteList
                             timeout:(NSTimeInterval)timeout
                            progress:(nullable UKProgressBlock)progressHandler
                             success:(nullable UKSuccessBlock)successHandler
                             failure:(nullable UKFailureBlock)failureHandler {
    if (url == nil || url.length <= 0) {
        return nil;
    }
    NSString *URL = url;
    if ([URL hasPrefix:@"/"]) {
        URL = [URL substringFromIndex:1];
    }
    
    if (withToken) {
        HDUkeInfoCenterModel *model = [HDUkeInfoCenter sharedCenter].userModel;
        if (model.token.length > 0) {
            URL = [NSString stringWithFormat:@"%@?access_token=%@", URL, model.token];
        }
    }
    
    
    UKBaseRequest *request = [[UKBaseRequest alloc] init];
    request.requestMethod = method;
    request.requestURL = URL;
    request.parameters = parameters;
    if (0 != timeout) {
        request.timeoutInterval = timeout;
    }
    [self _startRequestWith:request progress:progressHandler success:successHandler  failure:failureHandler];
    return request;
}
/**
 无BaseUrl
 get 方式请求
 */
+ (UKBaseRequest *)NomalGET:(NSString *)url
    parameters:(nullable id)parameters
    success:(nullable UKSuccessBlock)successHandler
                    failure:(nullable UKFailureBlock)failureHandler {
    UKBaseRequest *request = [[UKBaseRequest alloc] init];
    request.requestMethod = UKRequestMethodGET;
    request.requestURL = url;
    request.parameters = parameters;
    
    @weakify(request);
    [request startRequestWithSuccess:^(id  _Nonnull response) {
        @strongify(request);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *validResponse = response;
            if (validResponse.allKeys.count == 0) {
                validResponse = [NSDictionary dictionary];
            }
            if (successHandler) {
                successHandler(request, validResponse);
            }
        });
    } progress:^(NSProgress * _Nonnull progress) {
        
    } failure:^(NSError * _Nonnull error) {
        @strongify(request);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([error.domain isEqualToString:AFURLResponseSerializationErrorDomain]) {
                          // 服务器错误  server error
                  id response = [NSJSONSerialization
                                 JSONObjectWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]
                                 options:0
                                 error:nil];
              
//                      errorBlock(response);
                failureHandler(request, response);
//                NSLog(@"response%@",response);
                          // response中包含服务端返回的内容
              } else if ([error.domain isEqualToString:NSCocoaErrorDomain]) {
                  // 服务器引发异常  server throw exception
                  NSLog(@"服务器引发异常");
                  failureHandler(request, error);
              } else if ([error.domain isEqualToString:NSURLErrorDomain]) {
                  // 网络错误  network error
                  NSLog(@"网络错误");
                  failureHandler(request, error);
              }
            
            
        });
    }];
    
    return request;
}
#pragma mark - Private.
+ (void)_startRequestWith:(UKBaseRequest *)request
                 progress:(UKProgressBlock)progressHandler
                  success:(UKSuccessBlock)successHandler
                  failure:(UKFailureBlock)failureHandler {
    
    @weakify(request);
    [request startRequestWithSuccess:^(id  _Nonnull response) {
        @strongify(request);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *validResponse = response;
            if (validResponse.allKeys.count == 0) {
                validResponse = [NSDictionary dictionary];
            }
            if (successHandler) {
                successHandler(request, validResponse);
            }
        });
    } progress:^(NSProgress * _Nonnull progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progressHandler) {
                progressHandler(progress);
            }
        });
    } failure:^(NSError * _Nonnull error) {
        @strongify(request);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([error.domain isEqualToString:AFURLResponseSerializationErrorDomain]) {
                          // 服务器错误  server error
                  id response = [NSJSONSerialization
                                 JSONObjectWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]
                                 options:0
                                 error:nil];
              
//                      errorBlock(response);
                failureHandler(request, response);
//                NSLog(@"response%@",response);
                          // response中包含服务端返回的内容
              } else if ([error.domain isEqualToString:NSCocoaErrorDomain]) {
                  // 服务器引发异常  server throw exception
                  NSLog(@"服务器引发异常");
                  failureHandler(request, error);
              } else if ([error.domain isEqualToString:NSURLErrorDomain]) {
                  // 网络错误  network error
                  NSLog(@"网络错误");
                  failureHandler(request, error);
              }
            
            
//            NSString *errorString = [self _parseRequestError:error];
//            if (errorString) {
//                NSMutableDictionary *userInfo = error.userInfo.mutableCopy;
//                userInfo[NSLocalizedDescriptionKey] = errorString;
//                NSError *newError = [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo.copy];
//                if (failureHandler) {
//                    failureHandler(request, newError);
//                }
//            }else {
//                if (failureHandler) {
//                    failureHandler(request, error);
//                }
//            }
            
        });
    }];
}

+ (nullable NSString *)_parseRequestError:(NSError *)error {
    NSString *errorString = nil;
    if ([error.domain isEqualToString:NSURLErrorDomain]){
        switch (error.code) {
            case NSURLErrorNotConnectedToInternet:
                errorString = @"(/ω＼)网络好像有问题";
                break;
                
            case NSURLErrorTimedOut:
                errorString = @"请求超时";
                break;
                
            case NSURLErrorCannotConnectToHost:
                errorString = @"无法连接到服务器";
                break;
                
            case NSURLErrorCancelled:
                errorString = @"";
                break;
                
            default:
                break;
        }
    }
    
    if (!errorString) {

        errorString = [NSString stringWithFormat:@"请求出错(Code=%zi)", error.code];
    }
    
    return errorString;
}

/*!
 @abstract 基于请求url和参数, 生成一个NSMutableURLRequest对象,用于极验验证第一步和第二步修改request
 @Note 极验第一步和第二步校验,要求回调一个NSMutableURLRequest对象, 该对象需要包含优课已有的公共参数,以及sign、白名单等逻辑
 */
+ (NSMutableURLRequest *)requestWithMethod:(UKRequestMethod)method
                                       url:(NSString *)url
                                parameters:(nullable id)parameters{
    
    NSString *URL = url;
        
    UKBaseRequest *request = [[UKBaseRequest alloc] init];
    request.requestURL = URL;
    request.parameters = parameters;
    
    AFHTTPRequestSerializer *requestSerializer;
    
    NSString *methodStr = @"";
    
    if (method == UKRequestMethodGET) {
        
        requestSerializer = [AFHTTPRequestSerializer serializer];
        methodStr = @"GET";
    }else if (method == UKRequestMethodPOST) {
        
        requestSerializer = [AFJSONRequestSerializer serializer];
        methodStr = @"POST";
    }
    
    requestSerializer.timeoutInterval = request.timeoutInterval;
//    [requestSerializer setValue:kAPI_Version forHTTPHeaderField:@"Api-Version"];
    
    NSURL *baseURL = [NSURL URLWithString:[HDUkeInfoCenter sharedCenter].configurationModel.HTTPURL];
    if ([[baseURL path] length] > 0 && ![[baseURL absoluteString] hasSuffix:@"/"]) {
        baseURL = [baseURL URLByAppendingPathComponent:@""];
    }
    
    NSMutableURLRequest *mutableRequest = [requestSerializer requestWithMethod:methodStr URLString:[[NSURL URLWithString:url relativeToURL:baseURL] absoluteString] parameters:parameters error:nil];
    return mutableRequest;
    
}





@end
