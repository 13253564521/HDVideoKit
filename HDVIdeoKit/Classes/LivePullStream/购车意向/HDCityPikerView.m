//
//  HDCityPikerView.m
//  HDVideoKitDemok
//
//  Created by liugaosheng on 2021/7/18.
//  Copyright © 2021 刘高升. All rights reserved.
//

#import "HDCityPikerView.h"
#import "Macro.h"
#import "HDCityBuyCarModel.h"

#define BG_COLOR_RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define SCREEN_WIGHT  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface HDCityPikerView()
<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UILabel *_titleLabel;
    NSInteger _didSelectedRow;
    UIView *_lineView;
}
// pickerview  创建
@property (nonatomic ,strong)UIView *toolsView;
@property (nonatomic ,strong)UIPickerView *picerView;





@property (strong, nonatomic) HDCityBuyCarModel *code1;
@property (strong, nonatomic) HDCityBuyCarModel *code2;

@end

@implementation HDCityPikerView

/*!
 *  初始化选择器
 *
 *  @param title 标题

 *  @return 返回自己
 */
- (instancetype)initHDCityPikerViewWithtitle:(NSString *)title
{
    self = [super init];
    if (self)
    {
        
        self.frame = CGRectMake(0, 0, SCREEN_WIGHT, SCREEN_HEIGHT);
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        }];
        CGFloat pikerH = 290;
        CGFloat contentH = 352;

        
        _toolsView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - contentH, SCREEN_WIGHT, 62)];
        _toolsView.backgroundColor = [UIColor whiteColor];
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
        titleLabel.text = @"购车地点";
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
        
        
        _picerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - pikerH, SCREEN_WIGHT, pikerH)];
        _picerView.dataSource = self;
        _picerView.delegate = self;
        [_picerView selectRow:0 inComponent:0 animated:YES];
        [self addSubview:_picerView];
        CAGradientLayer *pikergradientLayer = [self getGradientLayerWithBounds:_picerView.bounds colorsArray:[NSArray arrayWithObjects:(id)[RGBA(249, 249, 249, 1) CGColor], (id)[RGBA(222, 225, 231, 1) CGColor], nil]];
        [_picerView.layer insertSublayer:pikergradientLayer atIndex:0];
        
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
        self.getPickerValue(self.code1,self.code2);
    }
    
    [self thisWayIsDissmisssSelf];
}
#pragma mark -
#pragma mark - 赋值
- (void)setDataValue
{
    if (self.code1 == nil)
    {
        HDCityBuyCarModel *prmodel = self.provinceArray[0];
        self.code1 = prmodel;

        if (self.cityArray.count > 0) {
            HDCityBuyCarModel *cityModel = self.cityArray[0];
            self.code2 = cityModel;

        }
        
    }
}

#pragma mark -
#pragma mark -  数据源方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.provinceArray.count;
    } else if (component == 1) {
        return self.cityArray.count;
    }
    return 0;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{

    if (component == 0) {
        HDCityBuyCarModel *model = self.provinceArray[row];
        return model.name;
    } else if (component == 1) {
        HDCityBuyCarModel *model = self.cityArray[row];
        return model.name;
    }
    return @"";
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
      
      //当前选中的颜色
      UILabel *select = (UILabel*)[pickerView viewForRow:row forComponent:0];
      if (select) {
          select.adjustsFontSizeToFitWidth = YES;

          [select setTextAlignment:NSTextAlignmentCenter];

          [select setBackgroundColor:[UIColor clearColor]];
         
          [select setFont:[UIFont boldSystemFontOfSize:16]];
          
          select.textColor = RGBA(0, 61, 227, 1);
      }
    //当前选中的颜色
    UILabel *select1 = (UILabel*)[pickerView viewForRow:row forComponent:1];
    if (select1) {
        select1.adjustsFontSizeToFitWidth = YES;

        [select1 setTextAlignment:NSTextAlignmentCenter];

        [select1 setBackgroundColor:[UIColor clearColor]];
       
        [select1 setFont:[UIFont boldSystemFontOfSize:16]];
        
        select1.textColor = RGBA(0, 61, 227, 1);
    }
      

    return normal;

}


#pragma mark -
#pragma mark -  代理方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    UILabel *piketLabel =  (UILabel *)[pickerView viewForRow:row forComponent:component];

    piketLabel.textColor = RGBA(0, 61, 227, 1);
    
    if (component == 0) {
        HDCityBuyCarModel *prmodel = self.provinceArray[row];
        !self.provinceChangeBlock ? : self.provinceChangeBlock(prmodel);
        
    }
    
    if (component == 0) {
        HDCityBuyCarModel *prmodel = self.provinceArray[row];
        self.code1 = prmodel;

        if (self.cityArray.count > 0) {
            HDCityBuyCarModel *cityModel = self.cityArray[0];
            self.code2 = cityModel;

        }
        
       
    }else if (component == 1) {
        HDCityBuyCarModel *cityModel = self.cityArray[row];
        self.code2 = cityModel;
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
    __weak typeof(UIPickerView *)blockPickerViwe = _picerView;
    [UIView animateWithDuration:0.3 animations:^{
        blockView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIGHT, 62);
        blockPickerViwe.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIGHT, 290);
    }completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}


-(void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
    
}

- (void)setProvinceArray:(NSArray *)provinceArray {
    _provinceArray = provinceArray;
    [self.picerView reloadAllComponents];
    ///强制选中第一行
    [self pickerView:self.picerView didSelectRow:0 inComponent:0];
}

- (void)setCityArray:(NSArray *)cityArray {
    _cityArray = cityArray;
    [self.picerView reloadComponent:1];
    [self.picerView selectRow:0 inComponent:1 animated:NO];
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
