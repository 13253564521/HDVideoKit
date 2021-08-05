//
//  HDVideoConfigurationEntry.h
//  HDVideoKitDemok
//
//  Created by liugaosheng on 2021/8/4.
//  Copyright © 2021 刘高升. All rights reserved.
//程序入口配置相关

#import <Foundation/Foundation.h>
#import "HDUniversalHeader.h"

NS_ASSUME_NONNULL_BEGIN


@interface HDVideoConfigurationEntry : NSObject
/**
 *  程序配置入口
 *  @params   nickName ： 昵称
 *  @params   userName ： 用户名
 *  @params   token ： token
 *  @params   avatar ： 用户头像
 *  @params   HTTPType ：网络环境类型
 *  @params   carSource ：切换接口地址 1 青岛。2长春\
 *  @params   dentityStatus ：用户是否实名认证 0：否 1：是
 */
+ (void)configUserNickName:(NSString *)nickName userName:(NSString *)userName token:(NSString *)token avatar:(NSString *)avatar HTTPType:(HDNetEnvironmentType)HTTPType carSource:(int)carSource dentityStatus:(int)dentityStatus;
@end

NS_ASSUME_NONNULL_END
