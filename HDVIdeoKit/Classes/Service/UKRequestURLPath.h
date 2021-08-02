//
//  UKRequestURLPath.h
//  ZMUke
//
//  Created by liqian on 2018/11/2.
//  Copyright © 2018 zmlearn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UKRequestURLPath : NSObject
@end

FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_newalbums;
//合集 标签
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_albums;
//发布页面话题 标签
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_tags;

//合辑视频列表
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_hejiliebiao;

//登陆
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_passportlogin;

//用户信息
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_usercenterprofile;
//话题
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_huati;

//发布视频
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_fabushipin;

//创建视频
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_changjianshi;

//我的视频列表
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_usercentervideos;

//获取喜欢的视频列表
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_likevideos;

//更新昵称
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_gengxinname;

//用户关注
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_yonghuguanzhu;

//取消关注
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_yonghuquxioa;

//置顶视频列表
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_dingzhishipin;

//关注用户的未观看视频
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_weiguankanVideo;

//未关注用户的未观看视频
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_stranger;

// 举报视频
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_jubaoVideo;

//举报用户
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_jubaoUser;

//搜索用户
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_sosuo;

//发布评论
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_pinglun;


//查询一级评论
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_chaxunpinglun1;

//查询二级评论
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_chaxunpinglun2;


//同意协议
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_tongyixieyi;

//视频点赞
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_shipindianza;

//取消点赞
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_shipinquxiao;

//用户关注
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_userguanzhu;

//取消关注
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_suserquxiao;

//获取头像地址
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_usertouxiang;


//删除视频
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_shanchuship;

//获取粉丝列表
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_userfenxi;

//查询消息列表
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_userfmessages;

//视频详情
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_videoxiangqing;

//更新播放次数
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_genxinbofangci;

//分享视频计数
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_userVideoFenxiang;

//查询消息数量
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_userxiaoxinumd;

//更新消息为已读取状态
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_messagesstate;


//创建直播
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_chuangjianVideo;

//获取直播详情
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_zhiboxiangqing;

//直播列表
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_zhiboxianglist;

//直播详情
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_zhiboxiangqinga;

//主播关闭直播
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_closezhiboVideo;

//直播视频点赞
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_zhibodianzan;

//直播中的评论发布评论
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_zhibopinlun;

//直播中的评论查询评论
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_zhibopinlunchaxun;

//我的直播列表
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_mezhibolist;

//查询增加直播相关信息
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_userprofiled;

//提交直播表单
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_zhibobiaodan;

//板块列表
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_Plates;
//圈子列表
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_Circles;
///直播抽奖ID （活动id）
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_LiveActiviId;

///查询当前用户 与 视频用户关系
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_UserRelationShip;

///关注与取消关注
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_PayOrClearAttention;
///获取省份信息 -----购车地址
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_QueryAreaList;

///获取短视频列表
FOUNDATION_EXPORT NSString * const UKURL_GET_APP_UPDATE_ShortVideos;
NS_ASSUME_NONNULL_END
