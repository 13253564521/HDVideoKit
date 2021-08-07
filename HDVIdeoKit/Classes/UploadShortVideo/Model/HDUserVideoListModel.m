//
//  HDUserVideoListModel.m
//  HDVideoKit
//
//  Created by ^-^ on 2020/9/17.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import "HDUserVideoListModel.h"
#import "Macro.h"
#import "NSDate+MJ.h"
@implementation HDUserVideoListModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"lastId":@"id"};
}

-(NSInteger)cellHeight {
    
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    
    CGFloat cellW = (kScreenWidth - 20 - 20 -5) / 2;
//    CGSize rect = [self.title boundingRectWithSize:CGSizeMake(cellW-10 -15, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
    CGSize rect = [self.title boundingRectWithSize:CGSizeMake(cellW-10 -15, 40) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
    
    return 220 + 10 +rect.height + 10 + 40;
}

@end
