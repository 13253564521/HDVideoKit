//
//  HDServicesManager.h
//  HDVideoKit
//
//  Created by ^-^ on 2020/9/18.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UKBaseRequest.h"
#import "HDVideoModel.h"
#import "HDUserVideoListModel.h"
#import "HDzhiboModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HDServicesManager : NSObject

+ (void)getlistfaxinCouponDataWithResultage:(int)page size:(int)size lastVideoUuid:(NSString *)lastVideoUuid block:(nullable void(^)(BOOL isSuccess, NSMutableArray * _Nullable arr, NSString * _Nullable alertString))block;

/// 发现列表
+ (void)getfaxianCouponDataWithResultage:(int)page size:(int)size block:(nullable void(^)(BOOL isSuccess, NSMutableArray * _Nullable arr, NSString * _Nullable alertString))block;

/// 关注用户的未观看视频
+ (void)getfollowvideosCouponDataWithResultage:(int)page size:(int)size block:(nullable void(^)(BOOL isSuccess, NSMutableArray * _Nullable arr, NSString * _Nullable alertString))block;

/// 置顶视频
+ (void)getzhidingCouponDataWithResultage:(int)page size:(int)size block:(nullable void(^)(BOOL isSuccess, NSMutableArray * _Nullable arr, NSString * _Nullable alertString))block;

/// 未关注用户的未观看视频
+ (void)getstrangerCouponDataWithResultageblock:(nullable void(^)(BOOL isSuccess, NSMutableArray * _Nullable arr, NSString * _Nullable alertString))block;

///举报
+ (void)getjubaoCouponDataWithResultage:(BOOL)isVideo dic:(NSDictionary *)dic block:(nullable void(^)(BOOL isSuccess, NSMutableArray * _Nullable arr, NSString * _Nullable alertString))block;

///搜索
+ (UKBaseRequest *)getsousuoCouponDataWithResul:(NSDictionary *)dic block:(nullable void(^)(BOOL isSuccess, NSMutableArray * _Nullable arr, NSString * _Nullable alertString))block;


///评论
+ (void)getpinglunCouponDataWithResul:(NSString *)url :(NSDictionary *)dic block:(nullable void(^)(BOOL isSuccess, NSDictionary * _Nullable dic, NSString * _Nullable alertString))block;


///查询一级评论
+ (void)getchaxunpinglun1CouponDataWithResuldic:(NSString *)url dic:(NSDictionary *)dic block:(nullable void(^)(BOOL isSuccess, NSMutableArray * _Nullable arr ,int allPinCount, int currentPinCount, NSString * _Nullable alertString))block;

///查询2级评论
+ (void)getchaxunpinglun2CouponDataWithResuldic:(NSString *)url dic:(NSDictionary *)dic block:(void (^)(BOOL, NSMutableArray * _Nullable, int, NSString * _Nullable))block;

///同意协议
+ (void)getxieyilun1CouponDataWithResulblock:(nullable void(^)(BOOL isSuccess, NSMutableArray * _Nullable arr, NSString * _Nullable alertString))block;


///视频点赞
+ (void)getdianzanCouponDataWithResulblock:(NSString *)videouuid black:(nullable void(^)(BOOL isSuccess, NSString * _Nullable alertString))block;

///取消点赞
+ (void)getquxiaodianzanCouponDataWithResulblock:(NSString *)videouuid black:(nullable void(^)(BOOL isSuccess, NSString * _Nullable alertString))block;


///用户关注
+ (void)getuserguanzhuCouponDataWithResulblock:(NSString *)userID black:(nullable void(^)(BOOL isSuccess, NSString * _Nullable alertString))block;

///取消关注
+ (void)getuserquxiaoguanzhuCouponDataWithResulblock:(NSString *)userID black:(nullable void(^)(BOOL isSuccess, NSString * _Nullable alertString))block;


///头像
+ (void)getusertouaxiangCouponDataWithResulblock:(NSString *)userID black:(nullable void(^)(BOOL isSuccess, NSString * _Nullable alertString))block;

/// 删除视频
+ (void)getshanchushipinCouponDataWithResulblock:(NSString *)userID black:(nullable void(^)(BOOL isSuccess, NSString * _Nullable alertString))block;

/// 获取粉丝列表
+ (UKBaseRequest *)getuserfenxiCouponDataWithResulblock:(int)page size:(int)size isindex:(NSInteger)index block:(nullable void(^)(BOOL isSuccess, NSMutableArray * _Nullable arr, NSString * _Nullable alertString))block;

///视频详情
+ (void)getVideoXiaqCouponDataWithResulblock:(NSString *)VideoID black:(nullable void(^)(BOOL isSuccess,HDUserVideoListModel * _Nullable cellModel, NSString * _Nullable alertString))block;


/// 获取关注用户列表
+ (UKBaseRequest *)getuserguanzhu1CouponDataWithResulblock:(int)page size:(int)size block:(nullable void(^)(BOOL isSuccess, NSMutableArray * _Nullable arr, NSString * _Nullable alertString))block;

/// 分享
+ (void)getfenxiang1CouponDataWithResuluuid:(NSString *)uuid block:(nullable void(^)(BOOL isSuccess, NSDictionary * _Nullable dic, NSString * _Nullable alertString))block;


///  获取点赞视频
+ (UKBaseRequest *)getdianzaiVideoCouponDataWithResulblock:(int)page size:(int)size block:(nullable void(^)(BOOL isSuccess, NSMutableArray * _Nullable arr, NSString * _Nullable alertString))block;


/// 更新播放次数
+ (void)getgenxinvideoCouponDataWithResuluuid:(NSString *)uuid block:(nullable void(^)(BOOL isSuccess, NSDictionary * _Nullable dic, NSString * _Nullable alertString))block;

/// 分享视频计数
+ (void)getuserVideoFenxiangCouponDataWithResuluuid:(NSString *)uuid block:(nullable void(^)(BOOL isSuccess, NSDictionary * _Nullable dic, NSString * _Nullable alertString))block;


/// 查询消息数量
+ (void)getxiaoxishuCouponDataWithResuluuid:(NSString *)target state:(NSString *)state block:(nullable void(^)(BOOL isSuccess, NSDictionary * _Nullable dic, NSString * _Nullable alertString))block;


/// 更新消息为已读取状态
+ (void)getmessagesstateDataWithResuluuid:(NSString *)messagesid block:(nullable void(^)(BOOL isSuccess, NSDictionary * _Nullable dic, NSString * _Nullable alertString))block;

/// 创建直播
+ (void)getchuangjianvideosDataWithResul:(NSDictionary *)dic block:(nullable void(^)(BOOL isSuccess, NSDictionary * _Nullable dic, NSString * _Nullable alertString))block;

///获取直播详情
+ (void)getdeosddDataWithResul:(NSString *)uuid block:(nullable void(^)(BOOL isSuccess, HDzhiboModel * _Nullable dic, NSString * _Nullable alertString))block;

///直播列表
+ (UKBaseRequest *)getzhibolistWithResullastId:(NSString *)lastId block:(nullable void(^)(BOOL isSuccess, NSArray * _Nullable arr, NSString * _Nullable alertString))block;

///直播详情
+ (void)getdeosdddafDataWithResul:(NSString *)uuid block:(nullable void(^)(BOOL isSuccess, HDzhiboModel * _Nullable dic, NSString * _Nullable alertString))block;

///主播关闭直播
+ (void)getvideoloseDataWithResul:(NSString *)uuid block:(nullable void(^)(BOOL isSuccess, HDzhiboModel * _Nullable dic, NSString * _Nullable alertString))block;

///直播视频点赞
+ (void)getzhibodianzanDataWithResul:(NSString *)uuid block:(nullable void(^)(BOOL isSuccess, HDzhiboModel * _Nullable dic, NSString * _Nullable alertString))block;

///直播视频取消点赞
+ (void)getzhiboquxiaoDataWithResul:(NSString *)uuid block:(nullable void(^)(BOOL isSuccess, HDzhiboModel * _Nullable dic, NSString * _Nullable alertString))block;

//直播中的评论发布评论
+ (void)getzhibopinlunDataWithResul:(NSString *)uuid content:(NSString *)content block:(nullable void(^)(BOOL isSuccess, NSString * _Nullable alertString))block;

//直播中的评论查询评论
+ (void)getzhibopunxunchaxuDataWithResul:(NSString *)uuid lastIndex:(NSString *)lastIndex block:(nullable void(^)(BOOL isSuccess,NSArray * _Nullable arr ,NSString * _Nullable alertString))block;

//我的直播列表
+ (void)getmezhibolistDataWithResul:(nullable NSString *)uuid lastIndex:(NSString *)lastIndex block:(nullable void(^)(BOOL isSuccess,NSArray * _Nullable arr ,NSString * _Nullable alertString))block;

//查询增加直播相关信息
+ (void)getzhiboporladDataWithResulblock:(nullable void(^)(BOOL isSuccess,NSDictionary * _Nullable dic ,NSString * _Nullable alertString))block;

//经销商查询接口
+ (void)getjingxiaoshangDataWithResulprovinceId:(NSString *)provinceId block:(void (^)(BOOL isSuccess, NSArray *dataArray, NSString *alertStr))block;


//提交直播表单
+ (void)getzhibodiaodanDataWithResulprovinceId:(NSString *)uuid dic:(NSDictionary *)dic block:(nullable void(^)(BOOL isSuccess,NSDictionary * _Nullable dic ,NSString * _Nullable alertString))block;

//根据经纬度，关键字，获取地点信息
+ (void)getLocationPOIWithlat:(CGFloat)lat lon:(CGFloat)lon  successHandler:(nullable void(^)(NSDictionary * _Nullable dic ))successHandler failedHandler:(void(^)(NSString *error))failedHandler;

//根据城市，关键字，获取POI列表
+ (void)getLocationPOIWithCity:(NSString *)city poiKeyword:(NSString *)poiKeyword  successHandler:(nullable void(^)(NSDictionary * _Nullable dic ))successHandler failedHandler:(void(^)(NSString *error))failedHandler;

//板块详情
+ (void)getPlatesDatablock:(nullable void(^)(BOOL isSuccess,NSDictionary * _Nullable dic ,NSString * _Nullable alertString))block;
//圈子详情
+ (void)getCirclesDatablock:(nullable void(^)(BOOL isSuccess,NSDictionary * _Nullable dic ,NSString * _Nullable alertString))block;

//////查询当前用户 与 视频用户关系
+ (void)getUserRelationShipWithPublisherId:(NSString *)publisherId userId:(NSString *)userId block:(nullable void(^)(BOOL isSuccess,NSString * _Nullable judge ,NSString * _Nullable alertString))block;

//////关注、取关 当前用户 与 视频用户关系
+ (void)getPayOrClearAttentionWithPublisherId:(NSString *)publisherId userId:(NSString *)userId  flag:(NSString *)flag block:(nullable void(^)(BOOL isSuccess,NSDictionary * _Nullable dataDic ,NSString * _Nullable alertString))block;

//////获取购车地点省份和省内子级信息 查省传空 查市传省id
+ (void)getWhereToBuyCarWithProvinceCode:(NSString *)provinceCode block:(void (^)(BOOL isSuccess, NSArray *dataArray, NSString *alertStr))block;
//短视频列表
+ (void)getShortVideoLisrDataWithBlockId:(NSNumber *)blockId lastId:(NSNumber *)lastId block:(nullable void(^)(BOOL isSuccess,NSArray * _Nullable arr ,NSString * _Nullable alertString))block ;

@end

NS_ASSUME_NONNULL_END
