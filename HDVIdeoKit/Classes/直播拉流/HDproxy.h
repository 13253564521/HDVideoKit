//
//  HDproxy.h
//  HDVideoKitDemok
//
//  Created by ^-^ on 2020/12/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDproxy : NSProxy
//通过创建对象
- (instancetype)initWithObjc:(id)object;

//通过类方法创建创建
+ (instancetype)proxyWithObjc:(id)object;
@end

NS_ASSUME_NONNULL_END
