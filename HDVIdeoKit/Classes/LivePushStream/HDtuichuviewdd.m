//
//  HDtuichuviewdd.m
//  HDVideoKitDemok
//
//  Created by ^-^ on 2020/11/23.
//

#import "HDtuichuviewdd.h"
#import "HDServicesManager.h"
#import "Macro.h"

@interface HDtuichuviewdd()
@property (weak, nonatomic) IBOutlet UIButton *closebtn;
@property (weak, nonatomic) IBOutlet UILabel *guankannumlabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *namelabel;
@property (weak, nonatomic) IBOutlet UIButton *foucsButton;

/** 是否关注标识 */
@property(nonatomic,copy) NSString *flag;
@end

@implementation HDtuichuviewdd


- (void)awakeFromNib {
    [super awakeFromNib];
    ///渐变色
    CAGradientLayer *pikergradientLayer = [self getGradientLayerWithBounds:self.bounds colorsArray:[NSArray arrayWithObjects:(id)[RGBA(249, 249, 249, 1) CGColor], (id)[RGBA(222, 225, 231, 1) CGColor], nil]];
    [self.layer insertSublayer:pikergradientLayer atIndex:0];
    self.imageV.userInteractionEnabled = YES;
    self.imageV.layer.cornerRadius = 48;
    self.imageV.layer.masksToBounds = YES;
    [self.foucsButton  setBackgroundImage:[UIImage imageNamed:HDBundleImage(@"paishe/icon_zhibo_xq_jieshu_guanzhu")] forState:UIControlStateNormal];
    [self.foucsButton  setBackgroundImage:[UIImage imageNamed:HDBundleImage(@"paishe/icon_zhibo_xq_jieshu_yiguanzhu")] forState:UIControlStateSelected];
    self.foucsButton.hidden = YES;
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userIconClick)];
    [self.imageV addGestureRecognizer:tapGes];

}

-(void)setModel:(HDzhiboModel *)model {
    _model = model;
    [self getUserRelationShipWithModel:model];
    
    self.guankannumlabel.text = [NSString stringWithFormat:@"%@",model.playCount];
    self.namelabel.text = model.nickName;
    [self.imageV yy_setImageWithURL:[NSURL URLWithString:model.avatar] placeholder: [UIImage imageNamed:HDBundleImage(@"currency/WechatIMG3175")]];
    [self.closebtn setImage:[UIImage imageNamed:HDBundleImage(@"video/btn_back")] forState:0];


}
//关注和取消关注
- (IBAction)foucsClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(foucsZhuboClickWithSender:UserID:publisherId:flag:)]) {
        [self.delegate foucsZhuboClickWithSender:sender UserID:self.model.userUuid publisherId:self.model.uuid flag:sender.isSelected ? @"1" : @"0"];
    }
}


- (IBAction)closeBen:(id)sender {
    if ([self.delegate respondsToSelector:@selector(closetuichaView)]) {
        [self.delegate closetuichaView];
    }
}


- (void)userIconClick {
    if ([self.delegate respondsToSelector:@selector(anchorUserIconDidClickWithuserID:)]) {
        [self.delegate anchorUserIconDidClickWithuserID:self.model.userUuid];
    }
}

- (void)showfoucsButton:(BOOL)show {
    self.foucsButton.hidden = !show;
}
- (void)settingFoucsButtonState:(BOOL)seleted {
    self.foucsButton.selected = seleted;
}
- (CAGradientLayer *)getGradientLayerWithBounds:(CGRect)bounds  colorsArray:(NSArray *)colorsArray {
    //添加渐变色
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = bounds;
    // 渐变色颜色数组,可多个
    gradientLayer.colors = colorsArray;//[NSArray arrayWithObjects:(id)[RGBA(249, 249, 249, 1) CGColor], (id)[RGBA(222, 225, 231, 1) CGColor], nil];
    // 渐变的开始点 (不同的起始点可以实现不同位置的渐变,如图)
    gradientLayer.startPoint = CGPointMake(0, 0.5f); //(0, 0)
    // 渐变的结束点
    gradientLayer.endPoint = CGPointMake(1, 0.5f); //(1, 1)
    
    return gradientLayer;
}

#pragma mark - 查询关系
- (void)getUserRelationShipWithModel:(HDzhiboModel *)model
{
    @WeakObj(self);
    [HDServicesManager getUserRelationShipWithPublisherId:model.uuid userId:model.userUuid block:^(BOOL isSuccess, NSString * _Nullable judge, NSString * _Nullable alertString) {
        if (isSuccess) {
            selfWeak.foucsButton.hidden = NO;
            selfWeak.flag = judge;
            if ([judge isEqualToString:@"0"]) {
                selfWeak.foucsButton.selected = NO;
            }else{
                selfWeak.foucsButton.selected = YES;
            }
            
        }else{
            selfWeak.foucsButton.hidden = YES;
        }
    }];
    
}
@end
