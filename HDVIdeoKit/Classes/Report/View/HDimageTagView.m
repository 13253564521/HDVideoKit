//
//  HDimageTagView.m
//  HDVideoKit
//
//  Created by ^-^ on 2020/9/12.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import "HDimageTagView.h"
#import "Macro.h"
@interface HDimageTagView()
@property (nonatomic,strong)UIImageView *imaegView;
@property (nonatomic,strong)UIImageView *backimaegView;

@end
@implementation HDimageTagView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = UkeColorHex(0x999999);
        
        self.backimaegView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        self.backimaegView.contentMode = UIViewContentModeScaleAspectFill;
        self.backimaegView.clipsToBounds = YES;
        [self addSubview:self.backimaegView];
        
        self.imaegView = [[UIImageView alloc]init];
        self.imaegView.image = [UIImage imageNamed:HDBundleImage(@"currency/img_none")];
        [self addSubview:self.imaegView];
        [self.imaegView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(25, 25));
            make.left.mas_equalTo(17);
            make.top.mas_equalTo(10);
        }];
        
        self.disButton = [[UIButton alloc]init];
        [self.disButton setImage:[UIImage imageNamed:HDBundleImage(@"currency/btn_x")] forState:0];
        [self.disButton addTarget:self action:@selector(buttondid) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.disButton];
        [self.disButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(22, 22));
            make.left.mas_equalTo(60 - 22);
            make.top.mas_equalTo(0);
        }];
        
        self.textlabel = [[UILabel alloc]init];
        self.textlabel.font = [UIFont systemFontOfSize:12];
        self.textlabel.textColor = UkeColorHex(0xEDEDED);
        [self addSubview:self.textlabel];
        [self.textlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.bottom.mas_equalTo(self);
        }];
        
    }
    return self;
}

-(void)buttondid{
    if ([self.delegate respondsToSelector:@selector(viewdismm:)]) {
        [self.delegate viewdismm:self.currentTag];
    }
}

- (void)setViewtag:(int)viewtag {
    _viewtag = viewtag;
    self.textlabel.text = [NSString stringWithFormat:@"%d/4",viewtag];
    NSLog(@"%@",self.textlabel.text);
    [self.textlabel sizeToFit];
    
    if (viewtag == 0) {
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick)]];
    }
}

- (void)setImag:(UIImage *)imag {
    _imag = imag;
    self.backimaegView.image = imag;
    self.disButton.hidden = NO;
    self.textlabel.hidden = YES;
    self.imaegView.hidden = YES;
}

-(void)tapGestureClick {
    if ([self.delegate respondsToSelector:@selector(pushImageController)]) {
        [self.delegate pushImageController];
    }
}

@end
