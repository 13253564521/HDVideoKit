//
//  HDactivityRulesView.m
//  HDVideoKitDemok
//
//  Created by ^-^ on 2020/12/2.
//

#import "HDactivityRulesView.h"
#import "Macro.h"

@interface HDactivityRulesView ()
@property (strong, nonatomic) UIScrollView *scrollView;


@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *contentLabel;

@property (strong, nonatomic) UILabel *nameLabel1;
@property (strong, nonatomic) UILabel *contentLabel1;

//contentLabel
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIView *contentView1;

@end

@implementation HDactivityRulesView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 6;
        
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.text = @"";
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.centerX.mas_equalTo(0);
            make.width.mas_equalTo(180);
        }];
        
        UIButton *button = [[UIButton alloc]init];
        [button setImage:[UIImage imageNamed:HDBundleImage(@"video/btn_x")] forState:0];
        [button addTarget:self action:@selector(buttondis) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(self.titleLabel);
        }];
        
        self.scrollView = [[UIScrollView alloc]init];
        self.scrollView.backgroundColor = [UIColor whiteColor];
        self.scrollView.contentSize = CGSizeMake(285, 1000);
        [self addSubview:self.scrollView];
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(20);
            make.right.left.bottom.mas_equalTo(0);
        }];
        
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.text = @"活动规则";
        self.nameLabel.textColor = [UIColor blackColor];
        self.nameLabel.font = [UIFont systemFontOfSize:14];
        [self.scrollView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(20);
        }];
        
        
        self.contentView = [[UIView alloc]init];
        self.contentView.backgroundColor = UkeColorHex(0xEDEDED);
        [self.scrollView addSubview:self.contentView];
        
        self.contentLabel = [[UILabel alloc]init];
        self.contentLabel.textColor = [UIColor blackColor];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.font = [UIFont systemFontOfSize:12];
        self.contentLabel.backgroundColor = UkeColorHex(0xEDEDED);
        [self.contentView addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
//            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(10);
        }];
        
        self.nameLabel1 = [[UILabel alloc]init];
        self.nameLabel1.text = @"奖品说明";
        self.nameLabel1.textColor = [UIColor blackColor];
        self.nameLabel1.font = [UIFont systemFontOfSize:14];
        [self.scrollView addSubview:self.nameLabel1];
        [self.nameLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(self.contentView.mas_bottom).offset(10);
        }];
        
        self.contentView1 = [[UIView alloc]init];
        self.contentView1.backgroundColor = UkeColorHex(0xEDEDED);
        [self.scrollView addSubview:self.contentView1];
        
        self.contentLabel1 = [[UILabel alloc]init];
        self.contentLabel1.numberOfLines = 0;
        self.contentLabel1.textColor = [UIColor blackColor];
        self.contentLabel1.font = [UIFont systemFontOfSize:12];
        self.contentLabel1.backgroundColor = UkeColorHex(0xEDEDED);
        [self.contentView1 addSubview:self.contentLabel1];
        [self.contentLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);

//            make.left.mas_equalTo(self.nameLabel);
//            make.width.mas_equalTo(self.scrollView.mas_width).offset(-20);
//            make.top.mas_equalTo(self.nameLabel1.mas_bottom).offset(10);
        }];
    }
    return self;
}

-(void)setDic:(NSDictionary *)dic {
    _dic = dic;
    
    if ([dic[@"name"] isKindOfClass:[NSString class]]) {
        self.titleLabel.text = dic[@"name"];
    }
    
    if ([dic[@"rule"] isKindOfClass:[NSString class]]) {
//        self.contentLabel.text = @"222";
        self.contentLabel.text = dic[@"rule"];
    }
    
    if ([dic[@"description"] isKindOfClass:[NSString class]]) {
//        self.contentLabel1.text = @"222";
        self.contentLabel1.text = dic[@"description"];
    }
    

    
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    CGSize rect = [self.contentLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
    if (rect.height < 150) {
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameLabel);
            make.width.mas_equalTo(self.scrollView.mas_width).offset(-20);
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(10);
            make.height.mas_equalTo(150);
        }];
    }else {
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameLabel);
            make.width.mas_equalTo(self.scrollView.mas_width).offset(-20);
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(10);
            make.bottom.mas_equalTo(self.contentLabel);
        }];
    }

    NSDictionary *attrs1 = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    CGSize rect1 = [self.contentLabel1.text boundingRectWithSize:CGSizeMake(kScreenWidth - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs1 context:nil].size;
    if (rect1.height < 150) {
        [self.contentView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameLabel);
            make.width.mas_equalTo(self.scrollView.mas_width).offset(-20);
            make.top.mas_equalTo(self.nameLabel1.mas_bottom).offset(10);
            make.height.mas_equalTo(150);
        }];
    }else {
        [self.contentView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameLabel);
            make.width.mas_equalTo(self.scrollView.mas_width).offset(-20);
            make.top.mas_equalTo(self.nameLabel1.mas_bottom).offset(10);
            make.bottom.mas_equalTo(self.contentLabel1);
        }];
    }
    
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        self.scrollView.contentSize = CGSizeMake(285, CGRectGetMaxY(self.contentView1.frame));
    });
}

-(void)buttondis {
    [self removeFromSuperview];
}
@end
