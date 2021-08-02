//
//  HDNativeNetWorking.h
//  HDVideoKitDemok
//
//  Created by LiuGaoSheng on 2021/7/21.
//  Copyright © 2021 刘高升. All rights reserved.
//原生网络请求

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^SuccessBlock)(id responseObject);
typedef void (^FailureBlock)(NSString *error);


@interface HDNativeNetWorking : NSObject
//原生GET网络请求
+ (void)getWithURL:(NSString *)url Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)PostWithURL:(NSString *)url Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;
///携带请求头Token 进行请求
+ (void)PostWithHeaderToken:(NSString *)token url:(NSString *)url Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;
@end

NS_ASSUME_NONNULL_END
