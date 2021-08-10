//
//  HDUserVideoListModel.h
//  HDVideoKit
//
//  Created by ^-^ on 2020/9/17.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface HDUserVideoListModel : NSObject

@property (nonatomic, strong) NSNumber *block;//下次请求参数掉调用
@property (nonatomic, strong) NSNumber *lastId;//下次请求参数掉调用

@property (nonatomic, copy) NSString *address;//地址
@property (nonatomic, copy) NSString *carKind;//车系
@property (nonatomic, copy) NSString *carModel;//车型
@property (nonatomic, copy) NSString *coverUrl;//封面图片地址
@property (nonatomic, copy) NSString *createTime;//
@property (nonatomic, strong) NSNumber *likeCount;//被点赞数
@property (nonatomic, copy) NSString *nickName;//
@property (nonatomic, copy) NSString *title;//视频标题
@property (nonatomic, copy) NSString *userUuid;//用户uuid
@property (nonatomic, copy) NSString *uuid;//视频uuid
@property (nonatomic, copy) NSString *videoUrl;//视频播放地址
@property (nonatomic, copy) NSString *avatar;//头像
@property (nonatomic, assign) BOOL isLiked;//是否已点赞
@property (nonatomic, assign) NSInteger postCmt;//是否允许评论
@property (nonatomic, assign) NSInteger showCmt;//是否展示评论
@property (nonatomic, copy) NSString *publishTime;//发布时间(秒)
@property (nonatomic, copy)NSString *commentCount;
@property (nonatomic, copy)NSString *playCount;

/**
 1: 启用/正常/审核通过
 2: 审核中
 3: 禁用
 4: 审核未通过
 5: 已删除
 6: 未同意协议
 7: 单方关注
 8: 互粉
 9: 下线
 10: 禁止发布
 */
@property (nonatomic, strong) NSNumber *state;//
@property (nonatomic, assign) NSInteger cellHeight;
@end

NS_ASSUME_NONNULL_END
