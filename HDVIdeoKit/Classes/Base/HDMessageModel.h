//
//  HDMessageModel.h
//  HDVideoKit
//
//  Created by ^-^ on 2020/9/22.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HDMessagePinglunDicModel;
NS_ASSUME_NONNULL_BEGIN

@interface HDMessageModel : NSObject
@property(nonatomic , strong)NSString *createTime;
@property(nonatomic , strong)NSString *nickName;
@property(nonatomic , strong)NSNumber *state;
@property(nonatomic , strong)NSString *targetUserUuid;
@property(nonatomic , strong)NSString *avatar;
@property(nonatomic , assign)int target;//类型

@property(nonatomic , assign)BOOL isguangfangtongzhi;//是否是官方通知
@property(nonatomic , strong)NSDictionary *targetInfo;//

@end



@interface HDMessagePinglunModel : NSObject
@property(nonatomic , strong)NSString *createTime;
@property(nonatomic , strong)NSString *fromUserUuid;//对方用户uuid
@property(nonatomic , strong)NSNumber *dataID;
@property(nonatomic , strong)NSString *content;//仅当target为3时返回评论内容
@property(nonatomic , strong)NSString *avatar;

@property(nonatomic , strong)NSString *nickName;//对方用户昵称
@property(nonatomic , strong)NSString *state;
@property(nonatomic , strong)NSString *target;//类型
@property(nonatomic , assign)NSInteger targetExt;
@property(nonatomic , strong)NSDictionary *targetInfo;//仅当target为3时返回视频信息
@end

@interface HDMessagePinglunDicModel : NSObject
@property(nonatomic , strong)NSString *coverUrl;
@property(nonatomic , strong)NSString *title;

@end
NS_ASSUME_NONNULL_END
