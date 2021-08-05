//
//  HDAttentionViewController.h
//  HDVideoKit
//
//  Created by LiuGaoSheng on 2020/8/31.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//关注

#import "HDBaseViewController.h"

#import "HDUserVideoListModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HDAttentionViewControllerdelegate <NSObject>

-(void)userdeleteVideo;
-(void)setupmodel;
@end

@interface HDAttentionViewController : HDBaseViewController
@property(nonatomic , strong)NSMutableArray<HDUserVideoListModel *> *dataArr;
@property(nonatomic , weak)id<HDAttentionViewControllerdelegate> delegate;
@property (nonatomic, assign) NSInteger currentIndex;

@end

NS_ASSUME_NONNULL_END
