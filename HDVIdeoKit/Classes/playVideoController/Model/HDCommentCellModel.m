//
//  HDCommentCellModel.m
//  HDVideoKit
//
//  Created by ^-^ on 2020/9/15.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import "HDCommentCellModel.h"
#import "Macro.h"
#import "NSDate+MJ.h"

@implementation HDCommentCellModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {

    return @{@"pinglunID": @"id",@"pinstate":@"state"};

}

+(NSDictionary *)objectClassInArray{
  
    return @{@"children":[HDCommentCellModel class]};
}

-(CGFloat)CellHeight {

    CGFloat cellH = 0;

    NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    CGSize rect = [self.content boundingRectWithSize:CGSizeMake(kScreenWidth - 20 - 32 - 10 - 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
    cellH = 10 + 32 + rect.height + 15 + 20 + 20;
    return cellH;
}

- (CGFloat)CellTableViewHeight {
    CGFloat tabviewH = 0;
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    if (_children.count == 0 ) {
        return 0;
    }else if (_children.count > 0 && _children.count < 2) { //只有小于两条评论
        for (HDCommentCellModel *model in _children) {
            CGSize rect = [model.content boundingRectWithSize:CGSizeMake(kScreenWidth - 88 - 16, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
            tabviewH = tabviewH + 16 + 28 + 8 + rect.height + 10 + 22 + 16;
        }
        return [_replyCount integerValue] >= 2 ? tabviewH + 36 : tabviewH;

    }else {///根据数据显示     大于一条评论
        for (NSInteger i= 0 ; i < 1; i++) {
            HDCommentCellModel *model = _children[i];
            CGSize rect = [model.content boundingRectWithSize:CGSizeMake(kScreenWidth - 88 - 16, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
            tabviewH = tabviewH + 16 + 28 + 8 + rect.height + 10 + 22 + 16;
        }
        return tabviewH + 36;//整体高度 + footerView高度 20 + 16 
    }
   
    return 0;
}

@end

@implementation HDSeedCellModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {

    return @{@"pinglunID": @"id",@"pinstate":@"state"};

}

-(CGFloat)CellSeedHeight {
    CGFloat cellH = 0;
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    CGSize rect = [self.content boundingRectWithSize:CGSizeMake(kScreenWidth - 20 - 32 - 10 - 10 - 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
    
    cellH = rect.height + 25 + 30 + 10;
    return cellH;
}
@end

