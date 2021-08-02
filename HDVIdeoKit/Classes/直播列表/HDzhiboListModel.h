//
//  HDzhiboListModel.h
//  HDVideoKitDemok
//
//  Created by ^-^ on 2020/11/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDzhiboListModel : NSObject
@property (nonatomic, strong) NSString *avatar;//
@property (nonatomic, assign) NSInteger beginTime;//
@property (nonatomic, strong) NSString *commentCount;//
@property (nonatomic, strong) NSString *coverUrl;//封面
@property (nonatomic, strong) NSString *description;//
@property (nonatomic, strong) NSString *videoID;//
@property (nonatomic, assign) BOOL isLiked;//
@property (nonatomic, strong) NSNumber *likeCount;//
@property (nonatomic, strong) NSString *nickName;//
@property (nonatomic, strong) NSString *photoUrl;//
@property (nonatomic, assign) int playCount;//总播放数
@property (nonatomic, strong) NSNumber *state;//状态, 13直播预告,14直播中,15直播已结束,16直播暂停中,17直播被关闭
@property (nonatomic, strong) NSString *title;//直播标题
@property (nonatomic, strong) NSString *userUuid;//
@property (nonatomic, strong) NSString *uuid;//
@property (nonatomic, strong) NSString *onlineUserCount;//累计在线用户数
@property (nonatomic, strong) NSString *videoUrl;//直播结束后的播放地址

@end

NS_ASSUME_NONNULL_END
