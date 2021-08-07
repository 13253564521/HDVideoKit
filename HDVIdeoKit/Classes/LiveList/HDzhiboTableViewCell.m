//
//  HDzhiboTableViewCell.m
//  HDVideoKitDemok
//
//  Created by ^-^ on 2020/10/28.
//

#import "HDzhiboTableViewCell.h"
#import "YYWebImage.h"
#import "Macro.h"

@interface HDzhiboTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *livetypeImgeView;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIImageView *backimage;
@property (weak, nonatomic) IBOutlet UILabel *contentlabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerimage;
@property (weak, nonatomic) IBOutlet UILabel *namelabel;
@property (weak, nonatomic) IBOutlet UIButton *zanButton;
@property (weak, nonatomic) IBOutlet UIView *backview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonW;

@end

@implementation HDzhiboTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    
    self.headerimage.layer.cornerRadius = 15;
    self.headerimage.layer.masksToBounds = YES;
    
    self.backimage.layer.cornerRadius = 4;
    self.backimage.layer.masksToBounds = YES;
    
    self.backview.layer.cornerRadius = 15;
    self.backview.layer.masksToBounds = YES;
    //添加渐变色
    CAGradientLayer *gradientLayer = [self getGradientLayerWithBounds:self.bounds colorsArray:[NSArray arrayWithObjects:(id)[RGBA(249, 249, 249, 1) CGColor], (id)[RGBA(222, 225, 231, 1) CGColor], nil]];
    [self.backview.layer insertSublayer:gradientLayer atIndex:0];
}

-(void)setModel:(HDzhiboListModel *)model {
    _model = model;
    [self.backimage yy_setImageWithURL:[NSURL URLWithString:model.coverUrl] placeholder: [UIImage imageNamed:HDBundleImage(@"currency/WechatIMG3175")]];
    [self.headerimage yy_setImageWithURL:[NSURL URLWithString:model.avatar] placeholder: [UIImage imageNamed:HDBundleImage(@"currency/WechatIMG3175")]];
    
    
    self.namelabel.text = model.nickName;
    self.contentlabel.text = model.title;
    
    if (model.isLiked == NO) {
        [self.zanButton setImage:[UIImage imageNamed:HDBundleImage(@"discover/icon_bicolor_zan")] forState:0];
    }else {
        [self.zanButton setImage:[UIImage imageNamed:HDBundleImage(@"discover/icon_hot")] forState:0];
    }
    
    NSString *lick = [NSString stringWithFormat:@"  %@",[self stringToInt:[model.likeCount stringValue]]];

    if ([model.likeCount intValue] < 10000 && [model.likeCount intValue] >= 1000) {
        self.buttonW.constant = 60;
    }else if ([model.likeCount intValue] >= 10000 && [model.likeCount intValue] < 1000000) {
        self.buttonW.constant = 60;
    }else if([model.likeCount intValue] < 1000){
        self.buttonW.constant = 45;
    }

    [self.zanButton setTitle:lick forState:0];
    
    if ([model.state intValue] == 13) {
        self.livetypeImgeView.image = [UIImage imageNamed:HDBundleImage(@"paishe/icon_zhibo_yugao")];

        self.label2.text = [self time_timestampToString:model.beginTime];
        self.zanButton.hidden = YES;
    }else if ([model.state intValue] == 14) {
        self.livetypeImgeView.image = [UIImage imageNamed:HDBundleImage(@"paishe/icon_zhibo_zhibozhong")];
        self.label2.text = [NSString stringWithFormat:@"%@人观看",[self stringToInt:[NSString stringWithFormat:@"%d",model.playCount]]];
        self.zanButton.hidden = NO;
    }else if ([model.state intValue] == 15) {
        self.livetypeImgeView.image = [UIImage imageNamed:HDBundleImage(@"paishe/icon_zhibo_huikan")];
        self.label2.text = [NSString stringWithFormat:@"%@人观看",[self stringToInt:[NSString stringWithFormat:@"%d",model.playCount]]];
        self.zanButton.hidden = NO;
    }
    
}


- (NSString *)time_timestampToString:(NSInteger)timestamp{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
     [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString* string=[dateFormat stringFromDate:confromTimesp];
    return string;
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
@end
