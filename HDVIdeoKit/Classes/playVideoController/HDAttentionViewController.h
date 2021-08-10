//
//  HDAttentionViewController.h
//  HDVideoKit
//
//  Created by LiuGaoSheng on 2020/8/31.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
// 短视频详情

#import "HDBaseViewController.h"
#import "HDVideoProtocol.h"


NS_ASSUME_NONNULL_BEGIN
@class HDUserVideoListModel;
@protocol HDAttentionViewControllerdelegate <NSObject>
-(void)userdeleteVideo;
-(void)setupmodel;
@end

@interface HDAttentionViewController : HDBaseViewController
/**
 必传
 数据源;
 */
@property(nonatomic , strong)NSMutableArray<HDUserVideoListModel *> *dataArr;
/**
 内部代理，可以不实现
 */
@property(nonatomic , weak)id<HDAttentionViewControllerdelegate> delegate;
/**
 
 通用协议 对外暴露
 */
@property (nonatomic , weak)id<HDVideoProtocol> hdprotocol;
/**
 必传
 选中cell位置
 */
@property (nonatomic, assign) NSInteger currentIndex;

@end

NS_ASSUME_NONNULL_END
