//
//  HDCustomMyPickerView.m
//  HDVideoKitDemok
//
//  Created by liugaosheng on 2021/7/18.
//  Copyright © 2021 刘高升. All rights reserved.
//

#import "HDCustomMyPickerView.h"
#import "Macro.h"

#define BG_COLOR_RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define SCREEN_WIGHT  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface HDCustomMyPickerView()
<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UILabel *_titleLabel;
    UIView *_lineView;
}
// pickerview  创建
@property (nonatomic ,strong)UIView *toolsView;
@property (nonatomic ,strong)UIView *pikerContentView;
@property (nonatomic ,strong)UIPickerView *picerView;

@property (nonatomic ,strong)NSArray *componentArray;
@property (nonatomic ,strong)NSArray *titleArray;

///标题容器
@property (nonatomic ,strong)UIView *titleView;
@property (nonatomic ,strong)UILabel *componenttitleLabel;
@property (nonatomic ,strong)UILabel *datatitleLabel;
@end

@implementation HDCustomMyPickerView

/*!
 *  初始化选择器
 *
 *  @param ComponentDataArray 第一区 显示的数据
 *  @param titleDataArray     第二区 显示的数据
 *  @param componenttitle     第一区 标题
 *   @param dataArraytitle     第二区 标题
 *  @return 返回自己
 */
- (instancetype)initWithComponentDataArray:(NSArray *)ComponentDataArray titleDataArray:(NSArray *)titleDataArray componenttitle:(NSString *)componenttitle dataArraytitle:(NSString *)dataArraytitle
{
    self = [super init];
    if (self)
    {
        self.componentArray = ComponentDataArray;
        self.titleArray = titleDataArray;
        self.frame = CGRectMake(0, 0, SCREEN_WIGHT, SCREEN_HEIGHT);
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        }];
        CGFloat pikerH = 290;
        CGFloat titleViewH = 52;
        CGFloat contentH;
        if (componenttitle.length > 0 || dataArraytitle.length > 0 ) {
            contentH = 404;
        }else{
            contentH = 352;
        }
        
        _toolsView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - contentH, SCREEN_WIGHT, 62)];
        CGFloat radius = 15; // 圆角大小
        UIRectCorner corner = UIRectCornerTopLeft|UIRectCornerTopRight; // 圆角位置，全部位置
        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:_toolsView.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _toolsView.bounds;
        maskLayer.path = path.CGPath;
        _toolsView.layer.mask = maskLayer;
        [self addSubview:_toolsView];
        //添加渐变色
        CAGradientLayer *gradientLayer = [self getGradientLayerWithBounds:_toolsView.bounds colorsArray:[NSArray arrayWithObjects:(id)[RGBA(249, 249, 249, 1) CGColor], (id)[RGBA(222, 225, 231, 1) CGColor], nil]];
        [_toolsView.layer insertSublayer:gradientLayer atIndex:0];
        ///lieView
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, _toolsView.frame.size.height - 1 , _toolsView.frame.size.width, 1)];
        _lineView.backgroundColor =  RGBA(57, 60, 67, 0.08);
        [_toolsView addSubview:_lineView];
 
        // 右边确定按钮
        UIButton *rightSureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        rightSureBtn.frame = CGRectMake(SCREEN_WIGHT - 54, 0, 44, 44);
        [rightSureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [rightSureBtn addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_toolsView addSubview:rightSureBtn];
        
        // 中间显示  label
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(54, 0, SCREEN_WIGHT - 108, 44)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"选择类型";
        titleLabel.textColor = RGBA(57, 60, 67, 1);
        titleLabel.font = [UIFont systemFontOfSize:16];
        [_toolsView addSubview:titleLabel];
        _titleLabel = titleLabel;
        
        // 左边取消按钮
        UIButton *leftCancleButton = [UIButton buttonWithType:UIButtonTypeSystem];
        leftCancleButton.frame = CGRectMake(10, 0, 44, 44);
        [leftCancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [leftCancleButton setTitleColor:RGBA(57, 60, 67, 0.76) forState:UIControlStateNormal];
        [leftCancleButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_toolsView addSubview:leftCancleButton];
        
        ///判断是否显示标题
        if (componenttitle.length > 0 || dataArraytitle.length > 0 ) {
            self.titleView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - titleViewH - pikerH, self.frame.size.width, titleViewH)];
            [self addSubview:self.titleView];
            
            self.componenttitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, self.titleView.frame.size.width * 0.5 - 16 - 8, self.titleView.frame.size.height)];
            self.componenttitleLabel.textAlignment = NSTextAlignmentCenter;
            self.componenttitleLabel.font = [UIFont systemFontOfSize:14];
            self.componenttitleLabel.textColor = RGBA(57, 60, 67, 1);
            self.componenttitleLabel.text = componenttitle;
            [self.titleView addSubview:self.componenttitleLabel];
            
            self.datatitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.componenttitleLabel.frame) + 16, 0, self.componenttitleLabel.frame.size.width, self.titleView.frame.size.height)];
            self.datatitleLabel.textAlignment = NSTextAlignmentCenter;
            self.datatitleLabel.font = [UIFont systemFontOfSize:14];
            self.datatitleLabel.textColor = RGBA(57, 60, 67, 1);
            self.datatitleLabel.text = dataArraytitle;
            [self.titleView addSubview:self.datatitleLabel];
            
            CAGradientLayer *titlegradientLayer = [self getGradientLayerWithBounds:self.titleView.bounds colorsArray:[NSArray arrayWithObjects:(id)[RGBA(249, 249, 249, 1) CGColor], (id)[RGBA(222, 225, 231, 1) CGColor], nil]];
            [self.titleView.layer insertSublayer:titlegradientLayer atIndex:0];
        }
        
        
        _pikerContentView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - pikerH, SCREEN_WIGHT, pikerH)];
        [self addSubview:_pikerContentView];
        CAGradientLayer *pikergradientLayer = [self getGradientLayerWithBounds:_pikerContentView.bounds colorsArray:[NSArray arrayWithObjects:(id)[RGBA(249, 249, 249, 1) CGColor], (id)[RGBA(222, 225, 231, 1) CGColor], nil]];
        [_pikerContentView.layer insertSublayer:pikergradientLayer atIndex:0];
        
        _picerView = [[UIPickerView alloc] initWithFrame:_pikerContentView.bounds];
        _picerView.dataSource = self;
        _picerView.delegate = self;
        [_picerView selectRow:0 inComponent:0 animated:YES];
        [_pikerContentView addSubview:_picerView];

        
    }
    return self;
}


#pragma mark -
#pragma mark -  左边按钮 方法  取消
- (void)leftButtonClick:(UIButton *)button
{
    [self thisWayIsDissmisssSelf];
}


#pragma mark -
#pragma mark -  右边按钮  方法
- (void)rightButtonClick:(UIButton *)button
{
    
    [self setDataValue];
    
    if (self.getPickerValue)
    {
        self.getPickerValue(self.componentString,self.titleString);
    }
    
    [self thisWayIsDissmisssSelf];
}
#pragma mark -
#pragma mark - 赋值
- (void)setDataValue
{
    if ([self.componentString isEqualToString:@""] || self.componentString == NULL)
    {
        if (self.componentArray.count > 0 ) {
            self.componentString = self.componentArray[0];
        }
        
    }
    if ([self.titleString isEqualToString:@""]||self.titleString == NULL)
    {
        if (self.titleArray.count > 0) {
            self.titleString = self.titleArray[0];
        }
       
    }
}

#pragma mark -
#pragma mark -  数据源方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.componentArray.count == 0 || self.titleArray.count == 0)
    {
        return 1;
    }
    else if (self.componentArray.count == 0 && self.titleArray.count == 0)
    {
        return 0;
    }
    else
    {
        return 2;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return self.componentArray.count;
    }
    else
    {
        return self.titleArray.count;
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{

    if (component == 0)
    {
        return self.componentArray[row];
    }
    else
    {
        return self.titleArray[row];
    }
}


//重写方法

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
 
    //普通状态的颜色
      UILabel *normal = (UILabel*)view;
      if (!normal){
          normal = [[UILabel alloc] init];
          normal.adjustsFontSizeToFitWidth = YES;

          [normal setTextAlignment:NSTextAlignmentCenter];

          [normal setBackgroundColor:[UIColor clearColor]];
         
          [normal setFont:[UIFont boldSystemFontOfSize:16]];
          
          normal.textColor = RGBA(57, 60, 67, 0.56);
      }
      normal.text = [self pickerView:pickerView titleForRow:row forComponent:component];
        if (self.componentArray.count > 0) {
            //当前选中的颜色
            UILabel *select = (UILabel*)[pickerView viewForRow:row forComponent:0];
            if (select) {
                select.adjustsFontSizeToFitWidth = YES;

                [select setTextAlignment:NSTextAlignmentCenter];

                [select setBackgroundColor:[UIColor clearColor]];
               
                [select setFont:[UIFont boldSystemFontOfSize:16]];
                
                select.textColor = RGBA(0, 61, 227, 1);
            }
        }

        if (self.self.titleArray.count >0) {
            //当前选中的颜色
            UILabel *select1 = (UILabel*)[pickerView viewForRow:row forComponent:1];
            if (select1) {
                select1.adjustsFontSizeToFitWidth = YES;

                [select1 setTextAlignment:NSTextAlignmentCenter];

                [select1 setBackgroundColor:[UIColor clearColor]];
               
                [select1 setFont:[UIFont boldSystemFontOfSize:16]];
                
                select1.textColor = RGBA(0, 61, 227, 1);
            }
        }

      

    return normal;

}


#pragma mark -
#pragma mark -  代理方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    UILabel *piketLabel =  (UILabel *)[pickerView viewForRow:row forComponent:component];
    piketLabel.textColor = RGBA(0, 61, 227, 1);
    
    
    if (component == 0)
    {
        if (self.componentArray.count > 0 ) {
            self.componentString = self.componentArray[row];
            self.valueString = self.componentArray[row];
        }

    }
    else
    {
        if (self.titleArray.count > 0) {
            self.titleString = self.titleArray[row];
        }
       
    }
    
}
#pragma mark -
#pragma mark - 屏幕点击事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self thisWayIsDissmisssSelf];
}


#pragma mark -
#pragma mark - 消失的方法
- (void)thisWayIsDissmisssSelf
{
    __weak typeof (self)weakSelf = self;
    __weak typeof(UIView *)blockView = _toolsView;
    __weak typeof(UIView *)blocktitleView = _titleView;
    __weak typeof(UIView *)blockPickerViwe = _pikerContentView;
    [UIView animateWithDuration:0.3 animations:^{
        blockView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIGHT, 62);
        blockPickerViwe.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIGHT, 290);
        blocktitleView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIGHT, 52);
    }completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}


-(void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
    
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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
