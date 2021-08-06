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
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"uuid":@"id"};
}
@end


@implementation HDUserCenterProfileModel



@end


@implementation HDUkeConfigurationModel

- (void)setHTTPType:(HDNetEnvironmentType)HTTPType {
    _HTTPType = HTTPType;
     
    
    [self setnewwork:HTTPType carSource:[HDUkeInfoCenter sharedCenter].configurationModel.carSource];
}

-(void)setnewwork:(HDNetEnvironmentType)HTTPType carSource:(int)carSource {
    if (HTTPType == HDNetEnvironmentType_Test) {
        [HDUkeInfoCenter sharedCenter].configurationModel.shareURL = @"http://sy.aerozhonghuan.com:81/test/yiqi/web/share/index.html?";
        [HDUkeInfoCenter sharedCenter].configurationModel.HTTPURL  = @"http://sy.smartlink-tech.com.cn:81/dspfawapi/mobile";//新测试地址
        

    }
    else if (HTTPType == HDNetEnvironmentType_Uat) {
        [HDUkeInfoCenter sharedCenter].configurationModel.shareURL = @"http://sy.aerozhonghuan.com:81/test/yiqi/web/share/index.html?";
        [HDUkeInfoCenter sharedCenter].configurationModel.HTTPURL  = @"http://sy.smartlink-tech.com.cn:81/dspfawapi/mobile";//新测试地址
        

    }
    else if (HTTPType == HDNetEnvironmentType_Releases) {
        
        [HDUkeInfoCenter sharedCenter].configurationModel.shareURL = @"http://sy.aerozhonghuan.com:81/test/yiqi/web/share/index.html?";
        [HDUkeInfoCenter sharedCenter].configurationModel.HTTPURL  = @"http://sy.smartlink-tech.com.cn:81/dspfawapi/mobile";//新测试地址
        
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
    if ([HDUkeInfoCenter sharedCenter].configurationModel.HTTPType == HDNetEnvironmentType_Uat){
        return @"https://uat-iov-ec.fawjiefang.com.cn/app/api/faw/driver/suggest/tips";
    }else if ([HDUkeInfoCenter sharedCenter].configurationModel.HTTPType == HDNetEnvironmentType_Releases) {
        return @"https://iov-ec.fawjiefang.com.cn/app/api/faw/driver/suggest/tips";
    }
    return @"https://uat-iov-ec.fawjiefang.com.cn/app/api/faw/driver/suggest/tips";
}


@end
