//
//  HDUkeInfoCenter.h
//  HDVideoKit
//
//  Created by ^-^ on 2020/9/14.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDUniversalHeader.h"

@class HDUkeInfoCenterModel,HDUkeConfigurationModel;
NS_ASSUME_NONNULL_BEGIN

@interface HDUkeInfoCenter : NSObject
@property (nonatomic, strong) HDUkeInfoCenterModel *userModel;
@property (nonatomic, strong) HDUkeConfigurationModel *configurationModel;

+ (HDUkeInfoCenter *)sharedCenter;

@end


@interface HDUkeInfoCenterModel : NSObject
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *phone;//手机号
@property (nonatomic, copy) NSString *nickName;//昵称
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *userInfoDTO;
@property (nonatomic, strong) NSNumber *state;

@property (nonatomic, copy) NSString *videoLength;//视频拍摄长度  返回是字符串 有可能有多个 用.分开
@property (nonatomic, assign) BOOL  isNetWorktixing;
@property (nonatomic, assign) int  liveVideo;//是否有直播权限
@property (nonatomic, copy) NSString *liveVideoDevice;//直播设备: 1硬件, 2手机
@property (nonatomic, assign) int  xiangceindex;


@end

@interface HDUserCenterProfileModel  : NSObject
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, assign) NSInteger carSource;
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, assign) NSInteger fanCount;
@property (nonatomic, assign) NSInteger followCount;
@property (nonatomic, assign) NSInteger identityStatus;
@property (nonatomic, assign) NSInteger lastLoginTime;
@property (nonatomic, assign) NSInteger likeCount;
@property (nonatomic, assign) NSInteger liveVideo;
@property (nonatomic, copy) NSString *liveVideoDevice;;
@property (nonatomic, assign) NSInteger momentCount;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *registerTime;
@property (nonatomic, strong) NSNumber *state;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, assign) NSInteger videoCount;
@property (nonatomic, copy) NSString *videoLength;

@end


@interface HDUkeConfigurationModel : NSObject
#warning 后期这些接口地址需要壳工程配置正式环境的地址    分享地址后面要加？ 避免拼接有问题
//分享的URL（测试接口：http://test.setech.ltd/fe/app/single/index.html?）
@property (nonatomic, strong) NSString *shareURL;
//接口地址 （测试接口：https://jiefang-api.huidi-data.com/mobile）
@property (nonatomic, strong) NSString *HTTPURL;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *token1;//经销商token

/**
 新增 POI 检索接口
 */
///https://iov-ec.fawjiefang.com.cn/app/api/faw/driver/inverse?lat=39.60304&lon=113.785895&road=1
@property (nonatomic, strong) NSString *poi_keyWordUrl;
@property (nonatomic, strong) NSString *poi_URL;

@property (nonatomic, assign) HDNetEnvironmentType HTTPType;
@property (nonatomic, assign) int dentityStatus;//用户是否实名认证 0：否 1：是
@property (nonatomic, assign) int carSource;//切换接口地址 1 青岛。2长春

@end
NS_ASSUME_NONNULL_END
