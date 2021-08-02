//
//  HDServicesManager.m
//  HDVideoKit
//
//  Created by ^-^ on 2020/9/18.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import "HDServicesManager.h"
#import "UKNetworkHelper.h"
#import "HDNativeNetWorking.h"
#import "UKRequestURLPath.h"
#import "HDUserVideoListModel.h"
#import "LHDAFNetworking.h"
#import "Macro.h"
#import "HDUkeInfoCenter.h"
#import "HDCommentCellModel.h"
#import "HDMessageModel.h"
#import "HDDealerModel.h"
#import "HDCityBuyCarModel.h"

@interface HDServicesManager ()
//@property (nonatomic, readwrite, strong) LHDAFHTTPSessionManager *manager;

@end


@implementation HDServicesManager


+ (void)getlistfaxinCouponDataWithResultage:(int)page size:(int)size lastVideoUuid:(NSString *)lastVideoUuid block:(void (^)(BOOL, NSMutableArray * _Nullable, NSString * _Nullable))block {
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"page"] = @(page);
    dic[@"size"] = @(size);
    dic[@"lastVideoUuid"] = lastVideoUuid;
    
    [UKNetworkHelper GET:UKURL_GET_APP_UPDATE_newalbums parameters:dic success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
        
        NSNumber *code = response[@"code"];
        if ([[code stringValue] isEqualToString:@"0"]) {
            NSMutableArray *arr = [HDUserVideoListModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
            NSLog(@"%d--%@--%lu",page,lastVideoUuid,(unsigned long)arr.count);
            return block(YES, arr, nil);
         }
        return block(NO, nil, nil);
        } failure:^(UKBaseRequest * _Nonnull request, id  _Nonnull error) {
            return block(NO, nil, nil);
    }];
}

+ (void)getfaxianCouponDataWithResultage:(int)page size:(int)size block:(void (^)(BOOL, NSMutableArray * _Nullable, NSString * _Nullable))block {
    
    NSMutableArray *dataArr = [NSMutableArray array];
    
    [HDServicesManager getzhidingCouponDataWithResultage:page size:size block:^(BOOL isSuccess, NSMutableArray * _Nullable arr, NSString * _Nullable alertString) {
        if (arr.count > 0) {
            [dataArr addObjectsFromArray:arr];
        }
        
        [HDServicesManager getfollowvideosCouponDataWithResultage:page size:size block:^(BOOL isSuccess, NSMutableArray * _Nullable arr, NSString * _Nullable alertString) {
            if (arr.count > 0) {
                [dataArr addObjectsFromArray:arr];
            }
            
            [HDServicesManager getstrangerCouponDataWithResultageblock:^(BOOL isSuccess, NSMutableArray * _Nullable arr, NSString * _Nullable alertString) {
                if (arr.count > 0) {
                    [dataArr addObjectsFromArray:arr];
                }
                
                if (dataArr.count > 0) {
                    block(YES,dataArr,nil);
                }else {
                    block(NO,nil,@"失败");
                }
            }];
        }];
    }];
}

+ (void)getfollowvideosCouponDataWithResultage:(int)page size:(int)size block:(void (^)(BOOL, NSMutableArray * _Nullable, NSString * _Nullable))block {
    
    NSDictionary *dic = @{@"page":@(page),@"size":@(size)};
    NSMutableArray *dataArr = [NSMutableArray array];
    [UKNetworkHelper GET:UKURL_GET_APP_UPDATE_weiguankanVideo parameters:dic success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
        NSNumber *code = response[@"code"];
       if ([[code stringValue] isEqualToString:@"0"]) {
           NSMutableArray *arr = [HDUserVideoListModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
           [dataArr addObjectsFromArray:arr];
       }
        block(YES, dataArr, nil);
    } failure:^(UKBaseRequest * _Nonnull request, id _Nonnull error) {
         block(NO, nil, nil);
    }];
}

+ (void)getzhidingCouponDataWithResultage:(int)page size:(int)size block:(void (^)(BOOL, NSMutableArray * _Nullable, NSString * _Nullable))block {
    
    NSDictionary *dic = @{@"page":@(page),@"size":@(size)};
    NSMutableArray *dataArr = [NSMutableArray array];
    [UKNetworkHelper GET:UKURL_GET_APP_UPDATE_dingzhishipin parameters:dic success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
        NSNumber *code = response[@"code"];
       if ([[code stringValue] isEqualToString:@"0"]) {
           NSMutableArray *arr = [HDUserVideoListModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
           [dataArr addObjectsFromArray:arr];
       }
        block(YES, dataArr, nil);
    } failure:^(UKBaseRequest * _Nonnull request, id _Nonnull error) {
         block(NO, nil, nil);
    }];
}

+ (void)getstrangerCouponDataWithResultageblock:(void (^)(BOOL, NSMutableArray * _Nullable, NSString * _Nullable))block {
    NSMutableArray *dataArr = [NSMutableArray array];

    [UKNetworkHelper GET:UKURL_GET_APP_UPDATE_stranger parameters:nil success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
          NSNumber *code = response[@"code"];
         if ([[code stringValue] isEqualToString:@"0"]) {
             NSMutableArray *arr = [HDUserVideoListModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
             [dataArr addObjectsFromArray:arr];
         }
        block(YES, dataArr, nil);
      } failure:^(UKBaseRequest * _Nonnull request, id _Nonnull error) {
           block(NO, nil, nil);
      }];
}

+ (void)getjubaoCouponDataWithResultage:(BOOL)isVideo dic:(NSDictionary *)dic block:(void (^)(BOOL, NSMutableArray * _Nullable, NSString * _Nullable))block {
    NSString * str = @"";
    if (isVideo == YES) {
        str = UKURL_GET_APP_UPDATE_jubaoVideo;
    }else {
        str = UKURL_GET_APP_UPDATE_jubaoUser;
    }
    
    [UKNetworkHelper POST:str parameters:dic success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
        NSNumber *code = response[@"code"];
        if ([[code stringValue] isEqualToString:@"0"]) {
          return  block(YES, nil, nil);

        }
       return block(NO, nil, @"失败");

    } failure:^(UKBaseRequest * _Nonnull request, id _Nonnull error) {
        
        NSNumber *code = error[@"code"];
        if ([[code stringValue] isEqualToString:@"4000208"]) {
            block(NO, nil, error[@"message"]);
        }else{
            block(NO, nil, error[@"message"]);
        }
        
    }];
}

+ (UKBaseRequest *)getsousuoCouponDataWithResul:(NSDictionary *)dic block:(void (^)(BOOL, NSMutableArray * _Nullable, NSString * _Nullable))block {
    return [UKNetworkHelper GET:UKURL_GET_APP_UPDATE_sosuo parameters:dic success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
        NSNumber *code = response[@"code"];
        if ([[code stringValue] isEqualToString:@"0"]) {
            NSMutableArray *arr = [HDUserVideoListModel mj_objectArrayWithKeyValuesArray:response[@"data"]];

          return  block(YES, arr, nil);
        }
       return block(NO, nil, nil);

    } failure:^(UKBaseRequest * _Nonnull request, id _Nonnull error) {
         return   block(NO, nil, nil);
    }];
}

+ (void)getpinglunCouponDataWithResul:(NSString *)url :(NSDictionary *)dic block:(void (^)(BOOL, NSDictionary * _Nullable, NSString * _Nullable))block {
    
    [UKNetworkHelper POST:url parameters:dic success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
        NSNumber *code = response[@"code"];
        if ([[code stringValue] isEqualToString:@"0"]) {
            return block(YES, response[@"data"][@"id"], nil);
        }
        return block(NO, nil, nil);
    } failure:^(UKBaseRequest * _Nonnull request, id  _Nonnull error) {
        NSLog(@"%@",error[@"message"]);
       return block(NO, nil, nil);
    }];
}

+ (void)getchaxunpinglun1CouponDataWithResuldic:(NSString *)url dic:(NSDictionary *)dic block:(nullable void(^)(BOOL isSuccess, NSMutableArray * _Nullable arr ,int allPinCount, int currentPinCount , NSString * _Nullable alertString))block {
    
    [UKNetworkHelper GET:url parameters:dic success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
        NSNumber *code = response[@"code"];
        if ([[code stringValue] isEqualToString:@"0"]) {
            NSMutableArray *arr = [HDCommentCellModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"items"]];
            NSNumber *count = response[@"data"][@"count"];
            int allpinglunCount = [count intValue];
            for (HDCommentCellModel *model in arr) {
                allpinglunCount += [model.replyCount intValue];
            }
            
            return block(YES, arr, allpinglunCount ,[count intValue],nil);
        }
        return block(NO, nil , 0 , 0,nil);
    } failure:^(UKBaseRequest * _Nonnull request, id  _Nonnull error) {
       return block(NO, nil, 0 , 0,nil);

    }];
}

+ (void)getchaxunpinglun2CouponDataWithResuldic:(NSString *)url dic:(NSDictionary *)dic block:(void (^)(BOOL, NSMutableArray * _Nullable, int, NSString * _Nullable))block {
    [UKNetworkHelper GET:url parameters:dic success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
        NSNumber *code = response[@"code"];
        if ([[code stringValue] isEqualToString:@"0"]) {
    
            if (![response[@"data"] isKindOfClass:[NSDictionary class]]) {
                return block(NO,nil , 0, nil);
            }
            
            NSMutableArray *arr = [HDCommentCellModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"items"]];
            NSNumber *count = response[@"data"][@"count"];
            return block(YES, arr, [count intValue],nil);

        }
        return block(NO, nil,0, nil);

    } failure:^(UKBaseRequest * _Nonnull request, id  _Nonnull error) {
        return block(NO, nil, 0,nil);

    }];
}

+ (void)getxieyilun1CouponDataWithResulblock:(void (^)(BOOL, NSMutableArray * _Nullable, NSString * _Nullable))block {
    
    [UKNetworkHelper POST:UKURL_GET_APP_UPDATE_tongyixieyi parameters:nil success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
        
    } failure:^(UKBaseRequest * _Nonnull request, id  _Nonnull error) {
        
    }];
}

+ (void)getdianzanCouponDataWithResulblock:(NSString *)videouuid black:(void (^)(BOOL, NSString * _Nullable))block {
    
    [UKNetworkHelper POST:[NSString stringWithFormat:@"%@%@",UKURL_GET_APP_UPDATE_shipindianza,videouuid] parameters:nil success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
           NSNumber *code = response[@"code"];
           if ([[code stringValue] isEqualToString:@"0"]) {
               return block(YES, nil);
            }
       } failure:^(UKBaseRequest * _Nonnull request, id  _Nonnull error) {
           
           NSNumber *code = error[@"code"];
           if ([code intValue] == 4000202) {
               return block(NO,@"不能点赞自己的视频");
           }else{
               return block(NO,error[@"message"]);
           }
           
       }];
}


+ (void)getquxiaodianzanCouponDataWithResulblock:(NSString *)videouuid black:(void (^)(BOOL, NSString * _Nullable))block {
    
    [UKNetworkHelper DELETE:[NSString stringWithFormat:@"%@%@",UKURL_GET_APP_UPDATE_shipindianza,videouuid] parameters:nil success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
        NSNumber *code = response[@"code"];
        if ([[code stringValue] isEqualToString:@"0"]) {
            return block(YES, nil);
         }
        return block(NO, nil);
    } failure:^(UKBaseRequest * _Nonnull request, id  _Nonnull error) {
         return block(NO, nil);
    }];
}

+ (void)getuserguanzhuCouponDataWithResulblock:(NSString *)userID black:(void (^)(BOOL, NSString * _Nullable))block{
    [UKNetworkHelper POST:[NSString stringWithFormat:@"%@%@",UKURL_GET_APP_UPDATE_userguanzhu,userID] parameters:nil success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
              NSNumber *code = response[@"code"];
              if ([[code stringValue] isEqualToString:@"0"]) {
                    return block(YES, nil);
               }
          } failure:^(UKBaseRequest * _Nonnull request, id  _Nonnull error) {
              NSLog(@"%@",error);
          }];
}

+ (void)getuserquxiaoguanzhuCouponDataWithResulblock:(NSString *)userID black:(void (^)(BOOL, NSString * _Nullable))block {
    [UKNetworkHelper DELETE:[NSString stringWithFormat:@"%@%@",UKURL_GET_APP_UPDATE_suserquxiao,userID] parameters:nil success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
           NSNumber *code = response[@"code"];
           if ([[code stringValue] isEqualToString:@"0"]) {
                 return block(YES, nil);

            }
       } failure:^(UKBaseRequest * _Nonnull request, id  _Nonnull error) {
           
    }];
}

+ (void)getusertouaxiangCouponDataWithResulblock:(NSString *)userID black:(void (^)(BOOL, NSString * _Nullable))block
{
    
    [UKNetworkHelper GET:[NSString stringWithFormat:@"%@%@",UKURL_GET_APP_UPDATE_usertouxiang,userID] parameters:@{@"target":@"none"} success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
        NSNumber *code = response[@"code"];
        if ([[code stringValue] isEqualToString:@"0"]) {
            return block(YES, nil);

        }
    } failure:^(UKBaseRequest * _Nonnull request, id  _Nonnull error) {
        
    }];
}

+ (void)getshanchushipinCouponDataWithResulblock:(NSString *)userID black:(void (^)(BOOL, NSString * _Nullable))block {
    [UKNetworkHelper DELETE:[NSString stringWithFormat:@"%@%@",UKURL_GET_APP_UPDATE_shanchuship,userID] parameters:nil success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
              NSNumber *code = response[@"code"];
              if ([[code stringValue] isEqualToString:@"0"]) {
                    return block(YES, nil);
               }
            return block(NO, nil);
          } failure:^(UKBaseRequest * _Nonnull request, id  _Nonnull error) {
              return block(NO, nil);
       }];
}



+ (UKBaseRequest *)getuserfenxiCouponDataWithResulblock:(int)page size:(int)size isindex:(NSInteger)index block:(void (^)(BOOL, NSMutableArray * _Nullable, NSString * _Nullable))block {
    
    if (index == 0) {
        return [UKNetworkHelper GET:UKURL_GET_APP_UPDATE_userfenxi parameters:@{@"page":@(page),@"size":@(size)} success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
            NSNumber *code = response[@"code"];
            if ([[code stringValue] isEqualToString:@"0"]) {
               NSMutableArray *arr= [HDMessageModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
                return block(YES,arr,nil);
            }
            return block(NO,nil,nil);

        } failure:^(UKBaseRequest * _Nonnull request, id  _Nonnull error) {
            return block(NO,nil,nil);

        }];
    }else {
        return [UKNetworkHelper GET:UKURL_GET_APP_UPDATE_userfmessages parameters:@{@"page":@(page),@"size":@(size),@"target":@"3"} success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
            NSNumber *code = response[@"code"];
            if ([[code stringValue] isEqualToString:@"0"]) {

               NSArray *arr1= [HDMessagePinglunModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
                NSMutableArray *arr = [NSMutableArray array];
                for (HDMessagePinglunModel *model in arr1) {
                    if ([model.target isEqualToString:@"3"]) {
                        [arr addObject:model];
                    }
                }
                
                return block(YES,arr,nil);
            }
            return block(NO,nil,nil);

        } failure:^(UKBaseRequest * _Nonnull request, id  _Nonnull error) {
            return block(NO,nil,nil);

        }];
    }
}

+ (void)getVideoXiaqCouponDataWithResulblock:(NSString *)VideoID black:(void (^)(BOOL, HDUserVideoListModel * _Nullable, NSString * _Nullable))block {
    
    
    [UKNetworkHelper GET:[NSString stringWithFormat:@"%@%@",UKURL_GET_APP_UPDATE_videoxiangqing,VideoID] parameters:nil success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
        NSNumber *code = response[@"code"];
        if ([[code stringValue] isEqualToString:@"0"]) {
            HDUserVideoListModel *model= [HDUserVideoListModel mj_objectWithKeyValues:response[@"data"]];
            return block(YES,model,nil);
        }
            return block(NO,nil,nil);
        } failure:^(UKBaseRequest * _Nonnull request, id  _Nonnull error) {
            
            return block(NO,nil,error[@"message"]);
    }];
 
}

+ (UKBaseRequest *)getuserguanzhu1CouponDataWithResulblock:(int)page size:(int)size block:(void (^)(BOOL, NSMutableArray * _Nullable, NSString * _Nullable))block {
    
    return [UKNetworkHelper GET:UKURL_GET_APP_UPDATE_yonghuguanzhu parameters:@{@"page":@(page),@"size":@(size)} success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
        NSNumber *code = response[@"code"];
        if ([[code stringValue] isEqualToString:@"0"]) {
            NSMutableArray *arr= [HDMessageModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
            return block(YES,arr,nil);
        }
        return block(NO,nil,nil);
        } failure:^(UKBaseRequest * _Nonnull request, id  _Nonnull error) {
            NSString *transString = [NSString stringWithString:[error[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSLog(@"%@",transString);

            return block(NO,nil,nil);
        }];
}


+ (void)getfenxiang1CouponDataWithResuluuid:(NSString *)uuid block:(void (^)(BOOL, NSDictionary * _Nullable, NSString * _Nullable))block {
    /*
     description
     data =     {
         address = "";
         avatar = "http://qgdu0n267.hd-bkt.clouddn.com/avatar/202cb962ac59075b964b07152d234b70-1601357351.png";
         commentCount = 8;
         coverUrl = "http://qgdu0n267.hd-bkt.clouddn.com/202cb962ac59075b964b07152d234b70/20092300/S7kvX/9fd25fb960e949d180ce8a2d7c2d7175.jpg";
         createTime = 1600793352;
         isLiked = 0;
         likeCount = 1;
         nickName = 123456;
         playCount = 50;
         state = 1;
         title = "\U6211\U8ba9\U6211\U670b\U53cb";
         userUuid = 202cb962ac59075b964b07152d234b70;
         uuid = 1c3e7c01e6634fca932ad668c25c036e;
         videoUrl = "http://qgdu0n267.hd-bkt.clouddn.com/202cb962ac59075b964b07152d234b70/Hh8qv7/4988a421ded6453a98b26256ca202058.mp4";
     };
     **/
    [UKNetworkHelper GET:[NSString stringWithFormat:@"/share/videos/%@",uuid] parameters:nil success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
        NSNumber *code = response[@"code"];
        if ([[code stringValue] isEqualToString:@"0"]) {
            
            return block(YES,response[@"data"],nil);
        }
        return block(NO,nil,nil);
        } failure:^(UKBaseRequest * _Nonnull request, id  _Nonnull error) {
            return block(NO,nil,nil);
    }];
}

+ (UKBaseRequest *)getdianzaiVideoCouponDataWithResulblock:(int)page size:(int)size block:(void (^)(BOOL, NSMutableArray * _Nullable, NSString * _Nullable))block {
    return [UKNetworkHelper GET:UKURL_GET_APP_UPDATE_likevideos parameters:@{@"page":@(page),@"size":@(size)} success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
        
        NSNumber *code = response[@"code"];
        if ([[code stringValue] isEqualToString:@"0"]) {
            NSMutableArray *arr = [HDUserVideoListModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
            return block(YES,arr,nil);
        }
        return block(NO,nil,nil);
        } failure:^(UKBaseRequest * _Nonnull request, id  _Nonnull error) {

            return block(NO,nil,nil);
        }];
}

+ (void)getgenxinvideoCouponDataWithResuluuid:(NSString *)uuid block:(void (^)(BOOL, NSDictionary * _Nullable, NSString * _Nullable))block {
    [UKNetworkHelper POST:[NSString stringWithFormat:@"%@%@/play",UKURL_GET_APP_UPDATE_genxinbofangci,uuid] parameters:nil success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
        NSNumber *code = response[@"code"];
        if ([[code stringValue] isEqualToString:@"0"]) {
            NSLog(@"刷新数据成功");
        }
        } failure:^(UKBaseRequest * _Nonnull request, id  _Nonnull error) {
            
    }];
}

+ (void)getuserVideoFenxiangCouponDataWithResuluuid:(NSString *)uuid block:(void (^)(BOOL, NSDictionary * _Nullable, NSString * _Nullable))block {
    [UKNetworkHelper POST:[NSString stringWithFormat:@"%@%@",UKURL_GET_APP_UPDATE_userVideoFenxiang,uuid] parameters:nil success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
        NSNumber *code = response[@"code"];
        if ([[code stringValue] isEqualToString:@"0"]) {
            NSLog(@"刷新数据成功");
        }
        } failure:^(UKBaseRequest * _Nonnull request, id  _Nonnull error) {
            
    }];
}

+ (void)getxiaoxishuCouponDataWithResuluuid:(NSString *)target state:(NSString *)state block:(void (^)(BOOL, NSDictionary * _Nullable, NSString * _Nullable))block {
    [UKNetworkHelper GET:UKURL_GET_APP_UPDATE_userxiaoxinumd parameters:@{@"target":target,@"state":state} success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
        
        NSNumber *code = response[@"code"];
        if ([[code stringValue] isEqualToString:@"0"]) {
            return block(YES,response[@"data"],nil);
        }
        return block(NO,nil,nil);
        } failure:^(UKBaseRequest * _Nonnull request, id  _Nonnull error) {
            return block(NO,nil,nil);
    }];
}

+ (void)getmessagesstateDataWithResuluuid:(NSString *)messagesid block:(void (^)(BOOL, NSDictionary * _Nullable, NSString * _Nullable))block {
    
    [UKNetworkHelper PUT:[NSString stringWithFormat:@"%@%@/read",UKURL_GET_APP_UPDATE_messagesstate,messagesid]
              parameters:nil
                 success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
        NSNumber *code = response[@"code"];
        if ([[code stringValue] isEqualToString:@"0"]) {
            return block(YES,nil,nil);
        }
        return block(NO,nil,nil);

        } failure:^(UKBaseRequest * _Nonnull request, id  _Nonnull error) {
            return block(NO,nil,nil);

    }];
}

+ (void)getchuangjianvideosDataWithResul:(NSDictionary *)dic block:(void (^)(BOOL, NSDictionary * _Nullable, NSString * _Nullable))block {
    NSLog(@"%@",dic);
    [UKNetworkHelper POST:UKURL_GET_APP_UPDATE_chuangjianVideo parameters:dic success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
        
        NSNumber *code = response[@"code"];
        if ([[code stringValue] isEqualToString:@"0"]) {
            return block(YES,response[@"data"],nil);
        }
        
        return block(NO,nil,response[@"message"]);
    } failure:^(UKBaseRequest * _Nonnull request, id  _Nonnull error) {
        NSLog(@"%@",error[@"message"]);
        return block(NO,nil,error[@"message"]);

    }];
}

+ (void)getdeosddDataWithResul:(NSString *)uuid block:(void (^)(BOOL, HDzhiboModel * _Nullable, NSString * _Nullable))block {
    [UKNetworkHelper GET:[NSString stringWithFormat:@"%@%@",UKURL_GET_APP_UPDATE_zhiboxiangqing,uuid] parameters:nil success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
           
        NSNumber *code = response[@"code"];
        if ([[code stringValue] isEqualToString:@"0"]) {
            HDzhiboModel *model = [HDzhiboModel mj_objectWithKeyValues:response[@"data"]];
            return block(YES,model,nil);
        }
        
        return block(NO,nil,nil);
    } failure:^(UKBaseRequest * _Nonnull request, id  _Nonnull error) {
        NSLog(@"%@",error[@"message"]);
        return block(NO,nil,error[@"message"]);
    }];
}

+ (UKBaseRequest *)getzhibolistWithResullastId:(NSString *)lastId block:(void (^)(BOOL, NSArray * _Nullable, NSString * _Nullable))block {
    
    return [UKNetworkHelper GET:UKURL_GET_APP_UPDATE_zhiboxianglist parameters:@{@"size":@"20",@"page":lastId} success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
        NSNumber *code = response[@"code"];
        if ([[code stringValue] isEqualToString:@"0"]) {
            return block(YES,response[@"data"],nil);
        }
        
        return block(NO,nil,nil);
    } failure:^(UKBaseRequest * _Nonnull request, id  _Nonnull error) {
        return block(NO,nil,nil);
    }];
}

+ (void)getdeosdddafDataWithResul:(NSString *)uuid block:(void (^)(BOOL, HDzhiboModel * _Nullable, NSString * _Nullable))block {
    NSString *url =  [NSString stringWithFormat:@"%@%@",UKURL_GET_APP_UPDATE_zhiboxiangqinga,uuid];
     [UKNetworkHelper GET:url parameters:nil success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
        
        NSNumber *code = response[@"code"];
        if ([[code stringValue] isEqualToString:@"0"]) {
            HDzhiboModel *model = [HDzhiboModel mj_objectWithKeyValues:response[@"data"]];
            return block(YES,model,nil);
        }
        
        return block(NO,nil,nil);
    } failure:^(UKBaseRequest * _Nonnull request, id  _Nonnull error) {
        return block(NO,nil,nil);
    }];
}

+ (void)getvideoloseDataWithResul:(NSString *)uuid block:(void (^)(BOOL, HDzhiboModel * _Nullable, NSString * _Nullable))block {
    NSString *url =  [NSString stringWithFormat:@"%@%@/close",UKURL_GET_APP_UPDATE_closezhiboVideo,uuid];
    
    [UKNetworkHelper PUT:url parameters:nil success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
        NSNumber *code = response[@"code"];
        if ([[code stringValue] isEqualToString:@"0"]) {
            return block(YES,nil,nil);
        }
        return block(NO,nil,nil);
    } failure:^(UKBaseRequest * _Nonnull request, id  _Nonnull error) {
        if ([error isKindOfClass:[NSError class]]) {
            NSError *er = (NSError *)error;
            return block(NO,nil, er.localizedDescription);
        }else {
            return block(NO,nil,error[@"message"]);
        }

    }];

}

+ (void)getzhibodianzanDataWithResul:(NSString *)uuid block:(void (^)(BOOL, HDzhiboModel * _Nullable, NSString * _Nullable))block {
    NSString *url =  [NSString stringWithFormat:@"%@%@",UKURL_GET_APP_UPDATE_zhibodianzan,uuid];

    [UKNetworkHelper POST:url parameters:nil success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
        NSNumber *code = response[@"code"];
        if ([[code stringValue] isEqualToString:@"0"]) {
            return block(YES,nil,nil);
        }
        return block(NO,nil,nil);
    } failure:^(UKBaseRequest * _Nonnull request, id  _Nonnull error) {
        return block(NO,nil,error[@"message"]);
    }];
}

+ (void)getzhiboquxiaoDataWithResul:(NSString *)uuid block:(void (^)(BOOL, HDzhiboModel * _Nullable, NSString * _Nullable))block {
    
    NSString *url =  [NSString stringWithFormat:@"%@%@",UKURL_GET_APP_UPDATE_zhibodianzan,uuid];
    [UKNetworkHelper DELETE:url parameters:nil success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
        NSNumber *code = response[@"code"];
        if ([[code stringValue] isEqualToString:@"0"]) {
            return block(YES,nil,nil);
        }
        return block(NO,nil,nil);
    } failure:^(UKBaseRequest * _Nonnull request, id  _Nonnull error) {
        return block(NO,nil,error[@"message"]);
    }];
}

+ (void)getzhibopinlunDataWithResul:(NSString *)uuid content:(NSString *)content block:(void (^)(BOOL, NSString * _Nullable))block {
    NSString *url =  [NSString stringWithFormat:@"%@%@/playing-comments",UKURL_GET_APP_UPDATE_zhibopinlun,uuid];

    [UKNetworkHelper POST:url parameters:@{@"content":content} success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
        NSNumber *code = response[@"code"];
        if ([[code stringValue] isEqualToString:@"0"]) {
            NSLog(@"发布评论成功");
            return block(YES,nil);
        }
        return block(NO,nil);
    } failure:^(UKBaseRequest * _Nonnull request, id  _Nonnull error) {
        
        NSLog(@"评论1111%@",error[@"message"]);
        
        return block(NO,error[@"message"]);
    }];
}


+ (void)getzhibopunxunchaxuDataWithResul:(NSString *)uuid lastIndex:(NSString *)lastIndex block:(void (^)(BOOL, NSArray * _Nullable, NSString * _Nullable))block {
    NSString *url =  [NSString stringWithFormat:@"%@%@/playing-comments",UKURL_GET_APP_UPDATE_zhibopinlunchaxun,uuid];
    if (!lastIndex || [lastIndex isEqualToString:@""]) {
        lastIndex = @"0";
    }
    
    [UKNetworkHelper GET:url parameters:@{@"size":@"20",@"lastId":lastIndex} success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
        NSNumber *code = response[@"code"];
        if ([[code stringValue] isEqualToString:@"0"]) {
           
            return block(YES,response[@"data"],nil);
        }
        
        return block(NO,nil,nil);
    } failure:^(UKBaseRequest * _Nonnull request, id  _Nonnull error) {
        return block(NO,nil,nil);
    }];
}

+ (void)getmezhibolistDataWithResul:(NSString *)uuid lastIndex:(NSString *)lastIndex block:(void (^)(BOOL, NSArray * _Nullable, NSString * _Nullable))block {
    if (!lastIndex || [lastIndex isEqualToString:@""]) {
        lastIndex = @"0";
    }
    [UKNetworkHelper GET:UKURL_GET_APP_UPDATE_mezhibolist parameters:@{@"size":@"20",@"lastId":lastIndex} success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
        
        NSNumber *code = response[@"code"];
        if ([[code stringValue] isEqualToString:@"0"]) {
            
            return block(YES,nil,nil);
        }
        
        return block(NO,nil,nil);
    } failure:^(UKBaseRequest * _Nonnull request, id  _Nonnull error) {
        NSLog(@"%@",error[@"massage"]);
        return block(NO,nil,nil);
    }];
}

+ (void)getzhiboporladDataWithResulblock:(void (^)(BOOL, NSDictionary * _Nullable, NSString * _Nullable))block {
    [UKNetworkHelper GET:UKURL_GET_APP_UPDATE_userprofiled parameters:nil success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
        
        NSNumber *code = response[@"code"];
        if ([[code stringValue] isEqualToString:@"0"]) {
            
        }
        
        return block(NO,nil,nil);
    } failure:^(UKBaseRequest * _Nonnull request, id  _Nonnull error) {
        NSLog(@"%@",error[@"massage"]);
        return block(NO,nil,nil);
    }];
}


+ (void)getjingxiaoshangDataWithResulprovinceId:(NSString *)provinceId block:(void (^)(BOOL isSuccess, NSArray *dataArray, NSString *alertStr))block {
    
    NSString *url = @"https://sy.smartlink.com.cn:44300/test/faw/drv/api/commonmodule/gather/queryDealer";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"provinceCode"] = provinceId;
    params[@"sourceType"] = [NSString stringWithFormat:@"%d",[HDUkeInfoCenter sharedCenter].configurationModel.carSource];

    NSLog(@"%@",url);
    [UKNetworkHelper POST:url parameters:params success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
        NSLog(@"经销商:%@",response);
        NSNumber *code = response[@"code"];
        if ([code integerValue] == 200) {
            NSArray *dealerArray = [HDDealerModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
            block(YES,dealerArray,@"success");
        }else{
            block(NO,@[],@"failed");
        }
        
    } failure:^(UKBaseRequest * _Nonnull request, id  _Nonnull error) {
        NSLog(@"%@",error);
        return block(NO,nil,nil);
    }];

   


    
}

+ (void)getzhibodiaodanDataWithResulprovinceId:(NSString *)uuid dic:(NSDictionary *)dic block:(void (^)(BOOL, NSDictionary * _Nullable, NSString * _Nullable))block {
    NSString *url =  [NSString stringWithFormat:@"%@%@/form",UKURL_GET_APP_UPDATE_zhibobiaodan,uuid];

    [UKNetworkHelper POST:url parameters:dic success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
        NSNumber *code = response[@"code"];
        if ([[code stringValue] isEqualToString:@"0"]) {
            return block(YES,response,nil);
        }
        
        return block(NO,nil,nil);
    } failure:^(UKBaseRequest * _Nonnull request, id  _Nonnull error) {
        NSLog(@"%@",error[@"massage"]);
        return block(NO,nil,nil);
    }];
}


+ (void)getLocationPOIWithlat:(CGFloat)lat lon:(CGFloat)lon  successHandler:(nullable void(^)(NSDictionary * _Nullable dic ))successHandler failedHandler:(void(^)(NSString *error))failedHandler {
    
    ///先根据经纬度查找到POI关键字，然后再 获取POI数据
    NSString *baseURLStr = [HDUkeInfoCenter sharedCenter].configurationModel.poi_keyWordUrl;
    baseURLStr = [NSString stringWithFormat:@"%@?lat=%f&lon=%f&road=1",baseURLStr,lat,lon];
    
    [HDNativeNetWorking getWithURL:baseURLStr Params:@{} success:^(id  _Nonnull responseObject) {
        NSLog(@"responseObject:%@",responseObject);
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        successHandler(responseDic);

    } failure:^(NSString * _Nonnull error) {
        NSLog(@"error:%@",error);
        failedHandler(error);
    }];
    
}

//根据城市，关键字，获取POI列表
+ (void)getLocationPOIWithCity:(NSString *)city poiKeyword:(NSString *)poiKeyword  successHandler:(nullable void(^)(NSDictionary * _Nullable dic ))successHandler failedHandler:(void(^)(NSString *error))failedHandler{
    NSString *poi_BaseUrl = [HDUkeInfoCenter sharedCenter].configurationModel.poi_URL;
    poi_BaseUrl = [NSString stringWithFormat:@"%@?inGb=gbd&city=%@&keywords=%@&outGb=gbd",poi_BaseUrl,city,poiKeyword];
    
    [HDNativeNetWorking getWithURL:poi_BaseUrl Params:@{} success:^(id  _Nonnull responseObject) {
        NSLog(@"获取POI成功:%@",responseObject);
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        successHandler(responseDic);
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"获取POI失败:%@",error);
        failedHandler(error);
    }];

}

//板块详情
+ (void)getPlatesDatablock:(nullable void(^)(BOOL isSuccess,NSDictionary * _Nullable dic ,NSString * _Nullable alertString))block {
    [UKNetworkHelper GET:UKURL_GET_APP_UPDATE_Plates parameters:nil success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
        NSNumber *code = response[@"code"];
        if ([[code stringValue] isEqualToString:@"0"]) {
            
            return block(YES,(NSDictionary *)response,nil);
        }
        
        return block(NO,nil,nil);
    } failure:^(UKBaseRequest * _Nonnull request, id  _Nonnull error) {
        NSLog(@"%@",error[@"massage"]);
        return block(NO,nil,nil);
    }];
}

//圈子详情
+ (void)getCirclesDatablock:(nullable void(^)(BOOL isSuccess,NSDictionary * _Nullable dic ,NSString * _Nullable alertString))block {
    [UKNetworkHelper GET:UKURL_GET_APP_UPDATE_Circles parameters:nil success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
        NSNumber *code = response[@"code"];
        if ([[code stringValue] isEqualToString:@"0"]) {
            
            return block(YES,(NSDictionary *)response,nil);
        }
        
        return block(NO,nil,nil);
    } failure:^(UKBaseRequest * _Nonnull request, id  _Nonnull error) {
        NSLog(@"%@",error[@"massage"]);
        return block(NO,nil,nil);
    }];
}

//////查询当前用户 与 视频用户关系
//////查询当前用户 与 视频用户关系
+ (void)getUserRelationShipWithPublisherId:(NSString *)publisherId userId:(NSString *)userId block:(nullable void(^)(BOOL isSuccess,NSString * _Nullable judge ,NSString * _Nullable alertString))block {
    NSString *urlStr = @"https://sy.smartlink.com.cn:44300/test/faw/drv/api";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"publisherId"] = publisherId;
    params[@"userId"] = @"A15600000001";//userId;
    urlStr = [NSString stringWithFormat:@"%@%@",urlStr,UKURL_GET_APP_UPDATE_UserRelationShip];
    [HDNativeNetWorking PostWithHeaderToken:[HDUkeInfoCenter sharedCenter].userModel.token url:urlStr Params:params success:^(id  _Nonnull responseObject) {
        NSDictionary *responseObjectDic = (NSDictionary *)responseObject;
        NSNumber *code = responseObjectDic[@"code"];
    
        if ([[code stringValue] isEqualToString:@"200"]) {
            NSLog(@"关系查询成功");
            NSString *judge = [NSString stringWithFormat:@"%@",responseObjectDic[@"data"][@"judge"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                block(YES,judge,@"关系查询成功");
            });
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                block(NO,nil,responseObjectDic[@"message"]);
            });
            
        }

    } failure:^(NSString * _Nonnull error) {
        NSLog(@"关系查询失败");
        dispatch_async(dispatch_get_main_queue(), ^{
            block(NO,nil,error);
        });
        
    }];

    
    
}

+ (void)getPayOrClearAttentionWithPublisherId:(NSString *)publisherId userId:(NSString *)userId  flag:(NSString *)flag block:(nullable void(^)(BOOL isSuccess,NSDictionary * _Nullable dataDic ,NSString * _Nullable alertString))block {
    NSString *urlStr = @"https://sy.smartlink.com.cn:44300/test/faw/drv/api";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"flag"] = flag;
    params[@"publisherId"] = publisherId;
//    params[@"userId"] = @"A15600000001";//userId;
    urlStr = [NSString stringWithFormat:@"%@%@",urlStr,UKURL_GET_APP_UPDATE_PayOrClearAttention];
    [HDNativeNetWorking PostWithHeaderToken:[HDUkeInfoCenter sharedCenter].userModel.token url:urlStr Params:params success:^(id  _Nonnull responseObject) {
        NSDictionary *responseObjectDic = (NSDictionary *)responseObject;
        NSNumber *code = responseObjectDic[@"code"];
    
        if ([[code stringValue] isEqualToString:@"200"]) {
            NSLog(@"关注、取消关注成功");
            block(YES,responseObjectDic,@"关注或取消关注成功");
        }else{
            
            block(NO,nil,responseObjectDic[@"message"]);
        }

    } failure:^(NSString * _Nonnull error) {
        NSLog(@"关注或取消关注失败");
        block(NO,nil,error);
    }];

    
}

+ (void)getWhereToBuyCarWithProvinceCode:(NSString *)provinceCode block:(void (^)(BOOL isSuccess, NSArray *dataArray, NSString *alertStr))block {
    NSString *url = @"https://sy.smartlink.com.cn:44300/test/faw/drv/api/";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = provinceCode;
    NSLog(@"%@",url);
    url = [NSString stringWithFormat:@"%@%@",url,UKURL_GET_APP_UPDATE_QueryAreaList];
    [UKNetworkHelper POST:url parameters:params success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
        NSLog(@"购车城市:%@",response);
        NSNumber *code = response[@"code"];
        if ([code integerValue] == 200) {
            NSArray *cityArray = [HDCityBuyCarModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
            block(YES,cityArray,@"success");
        }else{
            block(NO,@[],@"failed");
        }
        
    } failure:^(UKBaseRequest * _Nonnull request, id  _Nonnull error) {
        NSLog(@"%@",error);
        return block(NO,nil,nil);
    }];
}

//短视频列表
+ (void)getShortVideoLisrDataWithBlockId:(NSNumber *)blockId lastId:(NSNumber *)lastId block:(nullable void(^)(BOOL isSuccess,NSArray * _Nullable arr ,NSString * _Nullable alertString))block {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"block"] = blockId;
    params[@"lastId"] = lastId;
    params[@"size"] = @(20);
    [UKNetworkHelper GET:UKURL_GET_APP_UPDATE_ShortVideos parameters:params success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
        NSNumber *code = response[@"code"];
        if ([[code stringValue] isEqualToString:@"0"]) {
            NSMutableArray *arr = [HDUserVideoListModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"items"]];
            NSLog(@"blockId:%@--lastId:%@--arr.count:%lu",blockId,lastId,(unsigned long)arr.count);
            return block(YES, arr, nil);
         }
        return block(NO, nil, nil);
    } failure:^(UKBaseRequest * _Nonnull request, id  _Nonnull error) {
        return block(NO, nil, nil);
    }];
}
@end

