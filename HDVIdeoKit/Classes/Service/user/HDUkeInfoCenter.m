//
//  HDUkeInfoCenter.m
//  HDVideoKit
//
//  Created by ^-^ on 2020/9/14.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import "HDUkeInfoCenter.h"


@interface HDUkeInfoCenter ()

@end

@implementation HDUkeInfoCenter
+ (HDUkeInfoCenter *)sharedCenter {
    static HDUkeInfoCenter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HDUkeInfoCenter alloc] init];
    });
    return instance;
}

@end


@implementation HDUkeInfoCenterModel

@end


@implementation HDUkeConfigurationModel

- (void)setHTTPType:(HDActionType)HTTPType {
    _HTTPType = HTTPType;
     
    
    [self setnewwork:HTTPType carSource:[HDUkeInfoCenter sharedCenter].configurationModel.carSource];
}

-(void)setnewwork:(HDActionType)HTTPType carSource:(int)carSource {
    if ([HDUkeInfoCenter sharedCenter].configurationModel.HTTPType == HTTPtest) {
//        [HDUkeInfoCenter sharedCenter].configurationModel.shareURL = @"http://sy.aerozhonghuan.com:81/test/yiqi/web/share/index.html?";
//        [HDUkeInfoCenter sharedCenter].configurationModel.HTTPURL  = @"http://temp.huidi-data.com/dspapi-live/mobile";
        
        if ([HDUkeInfoCenter sharedCenter].configurationModel.carSource == 1) {
            [HDUkeInfoCenter sharedCenter].configurationModel.shareURL = @"http://sy.smartlink-tech.com.cn:81/dspqdfawshare/index.html?";
            [HDUkeInfoCenter sharedCenter].configurationModel.HTTPURL  = @"http://sy.smartlink-tech.com.cn:81/dspqdfawapi/mobile";
        }else {
            [HDUkeInfoCenter sharedCenter].configurationModel.shareURL = @"http://sy.smartlink-tech.com.cn:81/dspfawshare/index.html?";
            [HDUkeInfoCenter sharedCenter].configurationModel.HTTPURL  = @"http://sy.smartlink-tech.com.cn:81/dspfawapi/mobile";
        }

    }
    else if ([HDUkeInfoCenter sharedCenter].configurationModel.HTTPType == HTTPuat) {
        if ([HDUkeInfoCenter sharedCenter].configurationModel.carSource == 1) {
        
            [HDUkeInfoCenter sharedCenter].configurationModel.HTTPURL  = @"https://uat-iov-ec.fawjiefang.com.cn/dspqdfawapi/mobile";
            [HDUkeInfoCenter sharedCenter].configurationModel.shareURL = @"https://uat-iov-ec.fawjiefang.com.cn/dspqdfawshare/index.html?";
        
        }else {
            [HDUkeInfoCenter sharedCenter].configurationModel.HTTPURL  = @"https://uat-iov-ec.fawjiefang.com.cn/dspapi/mobile";
            [HDUkeInfoCenter sharedCenter].configurationModel.shareURL = @"https://uat-iov-ec.fawjiefang.com.cn/dspshare/index.html?";
        }

    }
    else if ([HDUkeInfoCenter sharedCenter].configurationModel.HTTPType == HTTPreleases) {
        
        if ([HDUkeInfoCenter sharedCenter].configurationModel.carSource == 1) {
            [HDUkeInfoCenter sharedCenter].configurationModel.HTTPURL  = @"https://jfvideo.fawjiefang.com.cn/dspqdfawapi/mobile";
            [HDUkeInfoCenter sharedCenter].configurationModel.shareURL = @"https://iov-ec.fawjiefang.com.cn/dspqdfawshare/index.html?";
        }else {
            [HDUkeInfoCenter sharedCenter].configurationModel.HTTPURL  = @"https://jfvideo.fawjiefang.com.cn/dspfawapi/mobile";
            [HDUkeInfoCenter sharedCenter].configurationModel.shareURL = @"https://iov-ec.fawjiefang.com.cn/dspfawshare/index.html?";
        }
    }
}


- (void)setCarSource:(int)carSource {
    _carSource = carSource;
    
    [self setnewwork:[HDUkeInfoCenter sharedCenter].configurationModel.HTTPType carSource:carSource];
}

- (NSString *)poi_keyWordUrl {
    ///示例： https://iov-ec.fawjiefang.com.cn/app/api/faw/driver/inverse?lat=39.60304&lon=113.785895&road=1
    return @"https://iov-ec.fawjiefang.com.cn/app/api/faw/driver/inverse";
}

- (NSString *)poi_URL {
    ////示例 https://uat-iov-ec.fawjiefang.com.cn/app/api/faw/driver/suggest/tips?inGb=gbd&city=沈阳&keywords=市府恒隆&outGb=gbd
    if ([HDUkeInfoCenter sharedCenter].configurationModel.HTTPType == HTTPuat){
        return @"https://uat-iov-ec.fawjiefang.com.cn/app/api/faw/driver/suggest/tips";
    }else if ([HDUkeInfoCenter sharedCenter].configurationModel.HTTPType == HTTPreleases) {
        return @"https://iov-ec.fawjiefang.com.cn/app/api/faw/driver/suggest/tips";
    }
    return @"https://uat-iov-ec.fawjiefang.com.cn/app/api/faw/driver/suggest/tips";
}

@end
