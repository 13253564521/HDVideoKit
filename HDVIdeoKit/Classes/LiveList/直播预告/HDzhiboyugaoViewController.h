//
//  HDzhiboyugaoViewController.h
//  HDVideoKitDemok
//
//  Created by ^-^ on 2020/10/28.
//

#import <UIKit/UIKit.h>
#import "HDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class HDzhiboModel;
@protocol HDzhiboyugaoViewControllerdelegate <NSObject>

-(void)currentModelremove:(HDzhiboModel*)model;

-(void)daoshijianzhibo:(HDzhiboModel *)moedl;//主播
-(void)daoshiguanzhong:(HDzhiboModel *)moedl;//观众
@end

@interface HDzhiboyugaoViewController : HDBaseViewController
@property(nonatomic,strong) HDzhiboModel *model;
@property(nonatomic,weak) id<HDzhiboyugaoViewControllerdelegate> delegate;

@end

NS_ASSUME_NONNULL_END
