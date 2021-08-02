//
//  HDSecondaryCommentCell.m
//  HDVideoKitDemok
//
//  Created by liugaosheng on 2021/7/26.
//  Copyright © 2021 刘高升. All rights reserved.
//

#import "HDSecondaryCommentCell.h"
#import "Macro.h"
#import "HDServicesManager.h"
#import "YYWebImage.h"
#import "NSDate+MJ.h"
#import "UKRequestURLPath.h"
#import "HDCommentCellModel.h"

@interface HDSecondaryCommentCell()

@property (nonatomic, strong)UIImageView *headerImage;
@property (nonatomic, strong)UILabel *nameLable;
@property (nonatomic, strong)UILabel *connmLabel;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UIButton *zanBUtton;
@property (nonatomic, strong)UIButton *huifuBUtton;

@property(nonatomic , assign)BOOL isshuaxin;
@property(nonatomic , strong)UIView *xianView;

@property (nonatomic, assign) BOOL isNetWork;

@end
@implementation HDSecondaryCommentCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style
                     reuseIdentifier:reuseIdentifier]) {
        
        self.clipsToBounds = YES;
        self.isNetWork = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self initAddView];
    }
    return  self;
}
-(void)initAddView {
      self.backgroundColor = [UIColor clearColor];
      self.headerImage = [[UIImageView alloc]init];
      self.headerImage.layer.cornerRadius = 28 /2;
      self.headerImage.layer.masksToBounds = YES;
      [self.contentView addSubview:self.headerImage];
      [self.headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.mas_equalTo(self.contentView).offset(12);
          make.left.mas_equalTo(self.contentView).offset(16);
          make.height.width.mas_equalTo(28);
      }];
      
    self.zanBUtton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.zanBUtton setTitle:@"点赞" forState:0];
    [self.zanBUtton setTitle:@"已赞" forState:UIControlStateSelected];
    [self.zanBUtton setTitleColor:RGBA(50, 60, 67, 0.56) forState:0];
    [self.zanBUtton setTitleColor:RGBA(50, 60, 67, 0.56) forState:UIControlStateSelected];
    [self.zanBUtton setImage:[UIImage imageNamed:HDBundleImage(@"currency/icon_comment_zan")] forState:UIControlStateNormal];
    [self.zanBUtton setImage:[UIImage imageNamed:HDBundleImage(@"currency/icon_comment_yidianzan")] forState:UIControlStateSelected];
    
    self.zanBUtton.titleLabel.font = [UIFont systemFontOfSize:12];
//    [self.zanBUtton addTarget:self action:@selector(zandidBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.zanBUtton];
    [self.zanBUtton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-16);
        make.centerY.equalTo(self.headerImage.mas_centerY);
        make.height.mas_equalTo(28);
        make.width.mas_equalTo(60);
    }];
    self.zanBUtton.hidden = YES;
    
    
      self.nameLable = [[UILabel alloc]init];
      self.nameLable.font = [UIFont systemFontOfSize:12];
      self.nameLable.textColor = RGBA(57, 60, 67, 1);
      [self.contentView addSubview:self.nameLable];
      [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.equalTo(self.headerImage.mas_right).offset(8);
          make.centerY.equalTo(self.headerImage.mas_centerY);
          make.right.equalTo(self.zanBUtton.mas_left).offset(-8);
      }];
      
      self.connmLabel = [[UILabel alloc]init];
      self.connmLabel.font = [UIFont systemFontOfSize:14];
     self.connmLabel.textColor = RGBA(57, 60, 67, 1);
      self.connmLabel.numberOfLines = 0;
      [self.contentView addSubview:self.connmLabel];
      [self.connmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.equalTo(self.nameLable.mas_left);
          make.top.equalTo(self.headerImage.mas_bottom).offset(8);
          make.right.equalTo(self.contentView.mas_right).offset(-16);
      }];
      
      
     self.timeLabel = [[UILabel alloc]init];
     self.timeLabel.font = [UIFont systemFontOfSize:10];
     self.timeLabel.textColor = UkeColorHex(0x999999);
     [self.contentView addSubview:self.timeLabel];
     [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(self.nameLable.mas_left);
         make.top.equalTo(self.connmLabel.mas_bottom).offset(13);
     }];
      
      self.huifuBUtton = [[UIButton alloc]init];
      [self.huifuBUtton setBackgroundColor:RGBA(57, 60, 67, 0.12)];
      [self.huifuBUtton setTitle:@"回复" forState:0];
      [self.huifuBUtton setTitleColor: RGBA(57, 60, 67, 1) forState:0];
      self.huifuBUtton.titleLabel.font = [UIFont systemFontOfSize:12];
      self.huifuBUtton.layer.cornerRadius = 10;
      self.huifuBUtton.layer.masksToBounds = YES;
      [self.huifuBUtton addTarget:self action:@selector(huifudidBtn) forControlEvents:UIControlEventTouchUpInside];
      [self.contentView addSubview:self.huifuBUtton];
      [self.huifuBUtton mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.equalTo(self.timeLabel.mas_right).offset(12);
          make.centerY.equalTo(self.timeLabel.mas_centerY);
          make.width.mas_equalTo(40);
          make.height.mas_equalTo(22);
          
      }];
      
      self.xianView = [[UIView alloc]init];
      self.xianView.backgroundColor = UkeColorHex(0xEDEDED);
      [self.contentView addSubview:self.xianView];
      [self.xianView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.equalTo(self.huifuBUtton.mas_bottom).offset(16);
          make.left.equalTo(self.contentView.mas_left).offset(16);
          make.right.equalTo(self.contentView.mas_right).offset(-16);
          make.height.mas_equalTo(1);
          make.bottom.equalTo(self.contentView.mas_bottom);
      }];
    
}

-(void)huifudidBtn  {
    if ([self.delegate respondsToSelector:@selector(hd_secondaryCommentCellDidClickHuifuWithModel:lastPinglunId:)]) {
        [self.delegate hd_secondaryCommentCellDidClickHuifuWithModel:self.model lastPinglunId:self.pinglunID];
    }
}

-(void)setModel:(HDCommentCellModel *)model {
    _model = model;
    
    self.nameLable.text = model.nickName;
    self.connmLabel.text = model.content;

    
    NSDate *date = [[NSDate alloc]init];
    self.timeLabel.text = [date timeStringWithTimeInterval:[model.createTime stringValue]];
    [self.headerImage yy_setImageWithURL:[NSURL URLWithString:model.avatar] placeholder: [UIImage imageNamed:HDBundleImage(@"currency/WechatIMG3175")]];
}

- (void)awakeFromNib {

    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
