//
//  HDCusTomSlelectView.m
//  HDVideoKit
//
//  Created by liugaosheng on 2020/9/5.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import "HDCusTomSlelectView.h"
#import "Macro.h"
@interface HDCusTomSlelectView ()
@property(nonatomic , strong)NSArray *namesarray;
@property(nonatomic , strong)NSMutableArray *buttonArray;
@end
@implementation HDCusTomSlelectView
+ (instancetype)initializeWithNames:(NSArray<NSString *> *)names {
    HDCusTomSlelectView *cusTomView = [[self alloc]init];
    cusTomView.namesarray = names;
    [cusTomView initSubViews];
    
    return cusTomView;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)initSubViews {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.shadowOpacity = 1;
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowRadius = 4;
    self.layer.cornerRadius = 4;
    self.buttonArray  = [NSMutableArray array];
    
    for (NSInteger i = 0; i < self.namesarray.count; i ++ ) {
        UIButton *sender = [self fastCreateButtonWithName:self.namesarray[i]];
        sender.tag = 101010 + i;
        [sender addTarget:self action:@selector(senderSelect:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sender];
        [self.buttonArray addObject:sender];
        if (i == 0) {//默认选中第一个
            sender.selected = YES;
            if ([self.delegate respondsToSelector:@selector(hd_CusTomSlelectViewDidSlectItemIndex:)]) {
                [self.delegate hd_CusTomSlelectViewDidSlectItemIndex:0];
            }
        }
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat buttonW = (CGFloat)(self.frame.size.width - (self.buttonArray.count - 1) )/self.buttonArray.count ;
    CGFloat lineH = 25;
    CGFloat lineW = 1;
    for (NSInteger i = 0 ; i < self.buttonArray.count; i++) {
        UIButton *sender = self.buttonArray[i];
        sender.frame = CGRectMake(i * buttonW , 0, buttonW, self.frame.size.height);
        if (i > 0 && i < self.buttonArray.count) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(buttonW * i, (self.frame.size.height - lineH) * 0.5, lineW, lineH)];
            line.backgroundColor = RGBA(204, 204, 204, 1);
            [self addSubview:line];
            
        }
    }
}

- (UIButton *)fastCreateButtonWithName:(NSString *)name {
    UIButton *sender = [UIButton buttonWithType:UIButtonTypeCustom];
    sender.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [sender setTitle:name forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sender setTitleColor:RGBA(116, 156, 255, 1) forState:UIControlStateSelected];
    return sender;
}


- (void)senderSelect:(UIButton *)sender {
    sender.selected = !sender.selected;
    NSInteger tag = sender.tag - 101010;
    for (UIButton *obj in self.buttonArray) {
        if (obj.tag - 101010 != tag) {
            obj.selected = NO;
        }else{
            obj.selected = YES;
        }
    }
    if ([self.delegate respondsToSelector:@selector(hd_CusTomSlelectViewDidSlectItemIndex:)]) {
        [self.delegate hd_CusTomSlelectViewDidSlectItemIndex:tag];
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
