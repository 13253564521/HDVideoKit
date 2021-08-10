//
//  HDuserVideolaliuController.h
//  HDVideoKitDemok
//
//  Created by ^-^ on 2020/11/1.
//

#import "HDBaseViewController.h"
#import "HDVideoProtocol.h"


NS_ASSUME_NONNULL_BEGIN

@class HDzhiboModel;
@protocol HDuserVideolaliuControllerdelegate <NSObject>
                      
-(void)userVideodianzan:(HDzhiboModel *)model;

@end

@interface HDuserVideolaliuController : HDBaseViewController
@property(nonatomic,strong) HDzhiboModel *model;
@property(nonatomic,weak) id<HDuserVideolaliuControllerdelegate> delegate;
/**
 通用协议 对外暴露
 */
@property(nonatomic , weak)id<HDVideoProtocol> hdprotocol;
@end

NS_ASSUME_NONNULL_END
