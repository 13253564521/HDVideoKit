//
//  HDzhiboModel.h
//  HDVideoKitDemok
//
//  Created by ^-^ on 2020/11/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDzhiboModel : NSObject
@property (nonatomic, strong) NSString *title;//直播标题
@property (nonatomic, strong) NSString *address;// 地址
@property (nonatomic, strong) NSString *tag;//话题
@property (nonatomic, assign) NSInteger beginTime;//开始时间(秒)
@property (nonatomic, strong) NSString *liveType;//1硬件直播, 2手机直播
@property (nonatomic, strong) NSString *publishUrl;//推流地址 (未验证)
@property (nonatomic, strong) NSString *playUrl;//播放地址 (未验证)
@property (nonatomic, strong) NSString *useForm;//1使用表单, 其它均为否
@property (nonatomic, strong) NSString *usePrizeDraw;//1使用抽奖功能, 其它均为否
@property (nonatomic, strong) NSString *prizeActivity;//活动id
@property (nonatomic, strong) NSString *coverUrl;//直播预告封面
@property (nonatomic, strong) NSString *state;//状态, 13直播预告,14直播中,15直播已结束,16直播暂停中,17直播被关闭
@property (nonatomic, strong) NSString *photoUrl;//介绍图片
@property (nonatomic, strong) NSString *onlineUserCount;//累计在线用户数
@property (nonatomic, strong) NSString *videoUrl;//直播结束后的播放地址
@property (nonatomic, strong) NSString *playCount;//总播放数
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *avatar;//
@property (nonatomic, strong) NSString *commentCount;//
@property (nonatomic, strong) NSString *coverUuid;//
@property (nonatomic, strong) NSNumber *isLiked;//1.以点赞 0枚点赞
@property (nonatomic, strong) NSNumber *likeCount;//
@property (nonatomic, strong) NSString *photoUuid;//
@property (nonatomic, strong) NSString *nickName;//
@property (nonatomic, strong) NSString *userUuid;//
@property (nonatomic, strong) NSString *prizeState;//1抽奖中, 其它均为否


@end

NS_ASSUME_NONNULL_END
