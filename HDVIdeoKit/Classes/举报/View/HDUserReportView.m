//
//  HDUserReportView.m
//  HDVideoKitDemok
//
//  Created by liugaosheng on 2021/7/18.
//  Copyright © 2021 刘高升. All rights reserved.
//

#import "HDUserReportView.h"
#import "Macro.h"
#import "HDReportCollectionViewCell.h"

static NSString *identifier = @"reportCell";
@interface HDUserReportView ()<UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
/** baseScroller */
@property(nonatomic,strong) UIScrollView *baseScrolleView;
/** 内容视图 */
@property(nonatomic,strong) UIView  *contentView;

/** 举报理由 (必选) */
@property(nonatomic,strong) UILabel *reportingtitleLabel;

/** 举报描述 (必填) */
@property(nonatomic,strong) UILabel *reportingEditLabel;
/** 截图上传 (选填) */
@property(nonatomic,strong) UILabel *screenshotLabel;


/** 内容违规 */
@property(nonatomic,strong) UILabel *contenttypeLabel;

/** 色情低俗 */
@property(nonatomic,strong) UIButton *vulgarButton;
/** 政治敏感 */
@property(nonatomic,strong) UIButton *politicalButton;
/** 违法犯罪 */
@property(nonatomic,strong) UIButton *illegalButton;
/** 发布垃圾广告*/
@property(nonatomic,strong) UIButton *advertisingButton;

/** 账号违规 */
@property(nonatomic,strong) UILabel *accounttypeLabel;
/** 冒充官方账号*/
@property(nonatomic,strong) UIButton *impersonateButton;
/** 头像、昵称违规 */
@property(nonatomic,strong) UIButton *avatarButton;


/** 其他违规 */
@property(nonatomic,strong) UILabel *othertypeLabel;
/** 侮辱谩骂 */
@property(nonatomic,strong) UIButton *insultButton;

/**线 */
@property(nonatomic,strong) UIView *lineView;

/** textView */
@property(nonatomic,strong) UITextView *textView;

/** placeHolder */
@property(nonatomic,strong) UILabel  *placeHolder;
/** counLabelr */
@property(nonatomic,strong) UILabel  *textCountLabel;

/**线 */
@property(nonatomic,strong) UIView *lineView1;

/** 添加专辑封面按钮 */
@property(nonatomic,strong) UIButton  *addCoverButton;

/** 添加图片collectionview */
@property(nonatomic,strong) UICollectionView *collectionView;

/**底部是图容器*/
@property(nonatomic,strong) UIView *bottomView;

/** 提交按钮 */
@property(nonatomic,strong) UIButton *submitButton;

/** 提示文字 */
@property(nonatomic,strong) UILabel  *hintLabel;

/** 举报数组 */
@property(nonatomic,strong) NSMutableArray  *dataArray;

@end

@implementation HDUserReportView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    UIColor *mainColor = RGBA(57 , 60, 67, 1);
    UIColor *color_76 = RGBA(57 , 60, 67, 0.76);
    
    self.backgroundColor = RGBA(225, 228, 233, 1);
    
    self.baseScrolleView = [[ UIScrollView alloc]init];
    self.baseScrolleView.scrollEnabled = YES;
    [self addSubview:self.baseScrolleView];
    [self.baseScrolleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.contentView = [[UIView alloc]init];
    self.contentView.backgroundColor = RGBA(225, 228, 233, 1);
    [self.baseScrolleView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.baseScrolleView);
        make.width.equalTo(self.baseScrolleView);
    }];
    

    ///举报理由
    self.reportingtitleLabel = [[UILabel alloc]init];
    self.reportingtitleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.reportingtitleLabel.textColor = mainColor;
    self.reportingtitleLabel.text = @"举报理由 (必选)";
    [self.contentView addSubview:self.reportingtitleLabel];
    [self.reportingtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
        make.top.equalTo(self.contentView.mas_top).offset(12);
    }];
    
    ///内容违规
    self.contenttypeLabel = [[UILabel alloc]init];
    self.contenttypeLabel.font = [UIFont boldSystemFontOfSize:14];
    self.contenttypeLabel.textColor = color_76;
    self.contenttypeLabel.text = @"内容违规";
    [self.contentView addSubview:self.contenttypeLabel];
    [self.contenttypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.width.mas_equalTo(60);
        make.top.equalTo(self.reportingtitleLabel.mas_bottom).offset(20);
    }];
    
    ///色情低俗
    self.vulgarButton = [self createCheckButtonWithTitle:@"色情低俗" action:@selector(vulgarButtonClick:)];
    [self.contentView addSubview:self.vulgarButton];
    [self.vulgarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contenttypeLabel.mas_right).offset(52);
        make.width.mas_equalTo(160);
        make.centerY.equalTo(self.contenttypeLabel.mas_centerY);
    }];
    
    ///政治敏感
    self.politicalButton = [self createCheckButtonWithTitle:@"政治敏感" action:@selector(politicalButtonClick:)];
    [self.contentView addSubview:self.politicalButton];
    [self.politicalButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.vulgarButton.mas_left);
        make.width.mas_equalTo(160);
        make.top.equalTo(self.vulgarButton.mas_bottom).offset(16);
    }];
    
    ///违法犯罪
    self.illegalButton = [self createCheckButtonWithTitle:@"违法犯罪" action:@selector(illegalButtonClick:)];
    [self.contentView addSubview:self.illegalButton];
    [self.illegalButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.vulgarButton.mas_left);
        make.width.mas_equalTo(160);
        make.top.equalTo(self.politicalButton.mas_bottom).offset(16);
    }];
    
    ///发布垃圾广告
    self.advertisingButton = [self createCheckButtonWithTitle:@"发布垃圾广告" action:@selector(advertisingButtonClick:)];
    [self.contentView addSubview:self.advertisingButton];
    [self.advertisingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.vulgarButton.mas_left);
        make.width.mas_equalTo(160);
        make.top.equalTo(self.illegalButton.mas_bottom).offset(16);
    }];
    

    
    ///账号违规
    self.accounttypeLabel = [[UILabel alloc]init];
    self.accounttypeLabel.font = [UIFont boldSystemFontOfSize:14];
    self.accounttypeLabel.textColor = color_76;
    self.accounttypeLabel.text = @"账号违规";
    [self.contentView addSubview:self.accounttypeLabel];
    [self.accounttypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.width.mas_equalTo(60);
        make.top.equalTo(self.advertisingButton.mas_bottom).offset(24);
    }];
    
    ///冒充官方账号
    self.impersonateButton = [self createCheckButtonWithTitle:@"冒充官方账号" action:@selector(impersonateButtonClick:)];
    [self.contentView addSubview:self.impersonateButton];
    [self.impersonateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.accounttypeLabel.mas_right).offset(52);
        make.width.mas_equalTo(160);
        make.centerY.equalTo(self.accounttypeLabel.mas_centerY);
    }];
    
    ///头像、昵称违规
    self.avatarButton = [self createCheckButtonWithTitle:@"头像、昵称违规" action:@selector(avatarButtonClick:)];
    [self.contentView addSubview:self.avatarButton];
    [self.avatarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.vulgarButton.mas_left);
        make.width.mas_equalTo(160);
        make.top.equalTo(self.impersonateButton.mas_bottom).offset(16);
    }];
    
    ///其他违规
    self.othertypeLabel = [[UILabel alloc]init];
    self.othertypeLabel.font = [UIFont boldSystemFontOfSize:14];
    self.othertypeLabel.textColor = color_76;
    self.othertypeLabel.text = @"其他";
    [self.contentView addSubview:self.othertypeLabel];
    [self.othertypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.width.mas_equalTo(60);
        make.top.equalTo(self.avatarButton.mas_bottom).offset(24);
    }];
    
    
    ///侮辱谩骂
    self.insultButton = [self createCheckButtonWithTitle:@"侮辱谩骂" action:@selector(insultButtonClick:)];
    [self.contentView addSubview:self.insultButton];
    [self.insultButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.accounttypeLabel.mas_right).offset(52);
        make.width.mas_equalTo(160);
        make.centerY.equalTo(self.othertypeLabel.mas_centerY);
    }];
    
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor =  RGBA(57, 60, 67, 0.08);
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
        make.bottom.equalTo(self.insultButton.mas_bottom).offset(20);
        make.height.mas_equalTo(1);
    }];
    
    ///举报描述 (必填)
    self.reportingEditLabel = [[UILabel alloc]init];
    self.reportingEditLabel.font = [UIFont boldSystemFontOfSize:16];
    self.reportingEditLabel.textColor = mainColor;
    self.reportingEditLabel.text = @"举报描述 (必填)";
    [self.contentView addSubview:self.reportingEditLabel];
    [self.reportingEditLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
        make.top.equalTo(self.lineView.mas_bottom).offset(20);
    }];
    


    self.textView = [[UITextView alloc]init];
    self.textView.textColor = [UIColor clearColor];
    self.textView.textAlignment = NSTextAlignmentLeft;
    self.textView.font = [UIFont systemFontOfSize:14];
    self.textView.backgroundColor = RGBA(225, 228, 233, 1);
    self.textView.delegate = self;
    [self.contentView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.top.equalTo(self.reportingEditLabel.mas_bottom).offset(20);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
        make.height.mas_equalTo(134);
    }];
    
    [self.textView addSubview:self.placeHolder];
    [self.placeHolder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.textView);
        make.top.equalTo(self.textView.mas_top).offset(8);
    }];
    
    self.textCountLabel = [[UILabel alloc]init];
    self.textCountLabel.text = @"0/200";
    self.textCountLabel.font = [UIFont systemFontOfSize:12];
    self.textCountLabel.textAlignment = NSTextAlignmentRight;
    self.textCountLabel.textColor = RGBA(57, 60, 67, 0.32);
    [self.contentView addSubview:self.textCountLabel];
    [self.textCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.textView.mas_right);
        make.bottom.equalTo(self.textView.mas_bottom);
        make.height.mas_equalTo(17);

    }];
    
    self.lineView1 = [[UIView alloc]init];
    self.lineView1.backgroundColor =  RGBA(57, 60, 67, 0.08);
    [self.contentView addSubview:self.lineView1];
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
        make.top.equalTo(self.textView.mas_bottom).offset(3);
        make.height.mas_equalTo(1);
    }];
    
    ///截图上传
    self.reportingEditLabel = [[UILabel alloc]init];
    self.reportingEditLabel.font = [UIFont boldSystemFontOfSize:16];
    self.reportingEditLabel.textColor = mainColor;
    self.reportingEditLabel.text = @"截图上传 (选填)";
    [self.contentView addSubview:self.reportingEditLabel];
    [self.reportingEditLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
        make.top.equalTo(self.lineView1.mas_bottom).offset(20);
    }];
    
//    CGFloat margin = 5;
    UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
    flowLayOut.itemSize = CGSizeMake(111, 111);
    flowLayOut.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayOut];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.alwaysBounceHorizontal = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerClass:[HDReportCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
        make.top.equalTo(self.reportingEditLabel.mas_bottom).offset(20);
        make.height.mas_equalTo(111);
    }];
    
    
    ///底部视图
    self.bottomView = [[UIView alloc]init];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(130);
        make.top.equalTo(self.collectionView.mas_bottom).offset(24);
    }];
    
    ///提交按钮
    self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.submitButton setBackgroundColor:RGBA(0, 61, 227, 1)];
    [self.submitButton setTitle:@"提交" forState:UIControlStateNormal];
    self.submitButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.submitButton.layer.cornerRadius = 24;
    self.submitButton.layer.shadowColor = RGBA(0, 61, 227, 0.8).CGColor;
    self.submitButton.layer.shadowOffset = CGSizeMake(0,10);
    self.submitButton.layer.shadowOpacity = 1;
    self.submitButton.layer.shadowRadius = 10;
    [self.submitButton addTarget:self action:@selector(submitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.submitButton];

    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView.mas_top).offset(15);
        make.left.equalTo(self.bottomView.mas_left).offset(16);
        make.right.equalTo(self.bottomView.mas_right).offset(-16);
        make.height.mas_equalTo(46);
    }];
    
    self.hintLabel = [[UILabel alloc]init];
    self.hintLabel.text = @"如您的举报成功会在第一时间反馈处理结果，请尽量完善您的举报描述、上传证据图片，无需重复举报，感谢您的配合。";
    self.hintLabel.numberOfLines = 2;
    self.hintLabel.font = [UIFont systemFontOfSize:12];
    self.hintLabel.textAlignment = NSTextAlignmentLeft;
    self.hintLabel.textColor = RGBA(57, 60, 67, 0.32);
    [self.bottomView addSubview:self.hintLabel];
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView.mas_left).offset(16);
        make.right.equalTo(self.bottomView.mas_right).offset(-16);
        make.top.equalTo(self.submitButton.mas_bottom).offset(19);

    }];
     
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomView.mas_bottom);
        
    }];
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
}
#pragma mark - buttonclick
- (void)vulgarButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.dataArray addObject:@"色情低俗"];
    }else{
        [self.dataArray removeObject:@"色情低俗"];
    }
}

- (void)politicalButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.dataArray addObject:@"政治敏感"];
    }else{
        [self.dataArray removeObject:@"政治敏感"];
    }
}

- (void)illegalButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.dataArray addObject:@"违法犯罪"];
    }else{
        [self.dataArray removeObject:@"违法犯罪"];
    }
}
- (void)advertisingButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.dataArray addObject:@"发布垃圾广告"];
    }else{
        [self.dataArray removeObject:@"发布垃圾广告"];
    }
}

- (void)impersonateButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.dataArray addObject:@"冒充官方账号"];
    }else{
        [self.dataArray removeObject:@"冒充官方账号"];
    }
}

- (void)avatarButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.dataArray addObject:@"头像、昵称违规"];
    }else{
        [self.dataArray removeObject:@"头像、昵称违规"];
    }
}

- (void)insultButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.dataArray addObject:@"侮辱谩骂"];
    }else{
        [self.dataArray removeObject:@"侮辱谩骂"];
    }
}
- (void)submitButtonClick:(UIButton *)sender {
    if (self.textView.text.length <= 1) {
        return [SVProgressHUD showErrorWithStatus:@"举报描述请输入至少两个汉字"];
    }
    
    if (self.textView.text.length > 200) {
        return [SVProgressHUD showErrorWithStatus:@"最多输入200个字"];
    }
    
    if (self.dataArray.count == 0) {
        return [SVProgressHUD showErrorWithStatus:@"请选择举报理由"];
    }

    if ([self.delegate respondsToSelector:@selector(hd_UserReportViewDidClickSubmitWithReason:text:)]) {
        [self.delegate hd_UserReportViewDidClickSubmitWithReason:self.dataArray text:self.textView.text];
    }
    
}

#pragma mark - createButton
- (UIButton *)createCheckButtonWithTitle:(NSString *)title action:(SEL)action  {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:HDBundleImage(@"paishe/btn_radiobtn_unselected")] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:HDBundleImage(@"paishe/btn_radiobtn_selected")] forState:UIControlStateSelected];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateSelected];
    [button setTitleColor:RGBA(57, 60, 67, 1) forState:UIControlStateNormal];
    [button setTitleColor:RGBA(57, 60, 67, 1) forState:UIControlStateSelected];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左显示
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8);
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.placeHolder.alpha = 0;
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (!textView.text.length) {
        self.placeHolder.alpha = 1;
    }
}
- (void)textViewDidChange:(UITextView *)textView
{
    if (!textView.text.length) {
        self.placeHolder.alpha = 1;
    } else {
        self.placeHolder.alpha = 0;
    }
    
    if (textView.markedTextRange == nil ) {
        if ( textView.text.length >= 200) {
            textView.text = [textView.text substringToIndex:200];
        }
        self.textCountLabel.text = [NSString stringWithFormat:@"%ld/200",textView.text.length];
        
    }
}

- (BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    textView.textColor = RGBA(57, 60, 67, 1);
    textView.font = [UIFont systemFontOfSize:14];
    
    if ([text isEqualToString:@""] && range.length > 0) {
        // 删除字符肯定是安全的
        return YES;
    }
    return YES;
}
#pragma mark - 懒加载
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (UILabel *)placeHolder {
    if (!_placeHolder) {
        _placeHolder = [[UILabel alloc]init];
        _placeHolder.text = @"请输入举报内容";
        _placeHolder.numberOfLines = 0;
        _placeHolder.font = [UIFont systemFontOfSize:14];
        _placeHolder.textColor = RGBA(57, 60, 67, 0.32);
    }
    return _placeHolder;
}

#pragma mark collectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return (self.photosArray.count == 4) ? self.photosArray.count : self.photosArray.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HDReportCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if (indexPath.row == _photosArray.count) {
        cell.imagev.image = [UIImage imageNamed:HDBundleImage(@"paishe/icon_system_plus")];
        
        cell.deleteButton.hidden = YES;
        
    }else{
        cell.imagev.image = _photosArray[indexPath.row];
        cell.deleteButton.hidden = NO;
    }
    cell.deleteButton.tag = 100 + indexPath.row;
    [cell.deleteButton addTarget:self action:@selector(deletePhotos:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == _photosArray.count) {
        if ([self.delegate respondsToSelector:@selector(hd_UserReportViewDidClickAddImage)]) {
            [self.delegate hd_UserReportViewDidClickAddImage];
        }
    }
    
}



- (void)deletePhotos:(UIButton *)sender{
    [_photosArray removeObjectAtIndex:sender.tag - 100];
    [_assestArray removeObjectAtIndex:sender.tag - 100];
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag-100 inSection:0];
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [self->_collectionView reloadData];
        if (self.photosArray.count < 3) {
            [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView.mas_left).offset(16);
                make.right.equalTo(self.contentView.mas_right).offset(-16);
                make.top.equalTo(self.reportingEditLabel.mas_bottom).offset(20);
                make.height.mas_equalTo(111);
            }];
            [self layoutIfNeeded];
        }
    }];
    
}


- (void)setPhotosArray:(NSMutableArray *)photosArray {
    _photosArray = photosArray;
    [self.collectionView reloadData];
    ///当数组大于三张时更新布局
    if (photosArray.count > 2) {
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(16);
            make.right.equalTo(self.contentView.mas_right).offset(-16);
            make.top.equalTo(self.reportingEditLabel.mas_bottom).offset(20);
            make.height.mas_equalTo(111 * 2 + 10);
        }];
        [self layoutIfNeeded];
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
