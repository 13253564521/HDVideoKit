//
//  HDUserReportViewController.h
//  HDVideoKit
//
//  Created by ^-^ on 2020/9/11.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import "HDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HDUserReportViewController : HDBaseViewController
@property(nonatomic, assign)BOOL isjubaoVideo;
@property(nonatomic, strong)NSString *UUID;
@property(nonatomic, assign)BOOL juboanetwo;//yes为视频举报接口 NO为用户举报接口

@end

NS_ASSUME_NONNULL_END
