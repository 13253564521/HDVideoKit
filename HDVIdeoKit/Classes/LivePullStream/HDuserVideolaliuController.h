//
//  HDuserVideolaliuController.h
//  HDVideoKitDemok
//
//  Created by ^-^ on 2020/11/1.
//

#import "HDBaseViewController.h"

#import "HDzhiboModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HDuserVideolaliuControllerdelegate <NSObject>
                      
-(void)userVideodianzan:(HDzhiboModel *)model;

@end

@interface HDuserVideolaliuController : HDBaseViewController
@property(nonatomic,strong) HDzhiboModel *model;
@property(nonatomic,weak) id<HDuserVideolaliuControllerdelegate> delegate;

@end

NS_ASSUME_NONNULL_END
