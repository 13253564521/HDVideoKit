//
//  UKRequestAgent.h
//  ZMUke
//
//  Created by liqian on 2018/12/6.
//  Copyright © 2018 zmlearn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LHDAFNetworking.h"


NS_ASSUME_NONNULL_BEGIN

@class UKBaseRequest;
@interface UKRequestAgent : NSObject

@property (nonatomic, readonly, strong) LHDAFHTTPSessionManager *manager;

+ (UKRequestAgent *)sharedAgent;

- (void)addRequest:(UKBaseRequest *)request;

- (void)resetManager;
@end

NS_ASSUME_NONNULL_END
