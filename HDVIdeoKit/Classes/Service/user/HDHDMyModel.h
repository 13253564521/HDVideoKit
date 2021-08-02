//
//  HDHDMyModel.h
//  HDVideoKit
//
//  Created by ^-^ on 2020/9/14.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDHDMyModel : NSObject
@property (nonatomic, strong) NSString *avatar;//头像
@property (nonatomic, strong) NSString *commentCount;//评论数
@property (nonatomic, strong) NSString *fanCount;//我的粉丝人数
@property (nonatomic, strong) NSString *followCount;//我关注的人数
@property (nonatomic, strong) NSString *lastLoginTime;//最近登录时间(秒)
@property (nonatomic, strong) NSString *likeCount;//点赞(喜欢)视频数
@property (nonatomic, strong) NSString *nickName;//名字
@property (nonatomic, strong) NSString *registerTime;//注册时间(秒)
@property (nonatomic, strong) NSString *uuid;//用户ID
@property (nonatomic, strong) NSString *videoCount;//上传视频数
@property (nonatomic, strong) NSString *videoLength;//视频拍摄长度
@property (nonatomic, strong) NSString *username;//手机号

@property (nonatomic, strong) NSNumber *state;//7: 单方关注8: 互粉9: 下线

@end

NS_ASSUME_NONNULL_END
