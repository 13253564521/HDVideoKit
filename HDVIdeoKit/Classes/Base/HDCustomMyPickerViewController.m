//
//  HDCustomMyPickerViewController.m
//  HDVideoKitDemok
//
//  Created by liugaosheng on 2021/7/18.
//  Copyright © 2021 刘高升. All rights reserved.
//

#import "HDCustomMyPickerViewController.h"
#import "HDCustomMyPickerView.h"
#import "Macro.h"

@interface HDCustomMyPickerViewController ()
{
    NSString *_title;
    NSString *_componenttitle;
    NSString *_dataArraytitle;
    NSArray  *_leftArray;
    NSArray  *_rightArray;
    
}
@end

@implementation HDCustomMyPickerViewController
- (instancetype)initWithTitle:(NSString *)title leftDataArray:(NSArray *)leftArray rightData:(NSArray *)rightArray componenttitle:(NSString *)componenttitle dataArraytitle:(NSString *)dataArraytitle {
    _title = title;
    _leftArray = leftArray;
    _rightArray = rightArray;
    _componenttitle = componenttitle;
    _dataArraytitle = dataArraytitle;
    return [self init];
}
- (instancetype)init
{
    if (self = [super init])
    {
        
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        HDCustomMyPickerView *view = [[HDCustomMyPickerView alloc] initWithComponentDataArray:_leftArray titleDataArray:_rightArray componenttitle:_componenttitle dataArraytitle:_dataArraytitle];
        view.title = _title;
        [self.view addSubview:view];
        
        @WeakObj(self);
        view.getPickerValue = ^(NSString * _Nonnull compoentString, NSString * _Nonnull titileString) {
            !selfWeak ? : selfWeak.getPickerValue(compoentString,titileString);
        };

    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self dismissViewControllerAnimated:self completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
