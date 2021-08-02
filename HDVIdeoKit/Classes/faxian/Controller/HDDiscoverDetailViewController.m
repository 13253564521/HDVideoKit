//
//  HDDiscoverDetailViewController.m
//  HDVideoKit
//
//  Created by liugaosheng on 2020/8/30.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import "HDDiscoverDetailViewController.h"
#import "HDSearchViewController.h"
#import "HDAttentionViewController.h"
#import "HDScrollView.h"
#import "Macro.h"

@interface HDDiscoverDetailViewController ()<UIScrollViewDelegate>
@property(nonatomic , strong)HDScrollView *mainScrolView;
@property(nonatomic , strong)NSArray *childVCs;
/** 搜索 */
@property(nonatomic , strong)HDSearchViewController *searchVc;
/** 关注 */
@property(nonatomic , strong) HDAttentionViewController *attentionVc;


@end

@implementation HDDiscoverDetailViewController
#pragma mark - 懒加载
- (HDScrollView *)mainScrolView {
    if (!_mainScrolView) {
        _mainScrolView = [HDScrollView new];
        _mainScrolView.pagingEnabled = YES;
        _mainScrolView.showsHorizontalScrollIndicator = NO;
        _mainScrolView.showsVerticalScrollIndicator = NO;
        _mainScrolView.bounces = NO; // 禁止边缘滑动
        _mainScrolView.delegate = self;
        if (@available(iOS 11.0, *)) {
            _mainScrolView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
    return _mainScrolView;
}

- (HDAttentionViewController *)attentionVc {
    if (!_attentionVc) {
        _attentionVc = [[HDAttentionViewController alloc]init];
        _attentionVc.view.frame = self.view.bounds;
    }
    return _attentionVc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initSubViews];
}

- (void)initSubViews {
    [self addChildViewController:self.attentionVc];
    [self.view addSubview:self.attentionVc.view];
    [self.attentionVc willMoveToParentViewController:self];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    self.gk_statusBarHidden = NO;
    
    // 右滑开始时暂停
    if (scrollView.contentOffset.x == kScreenWidth) {
//        [self.mainVC.playerVC.videoView pause];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 滑动结束，如果是播放页则恢复播放
    if (scrollView.contentOffset.x == kScreenWidth) {
//        self.gk_statusBarHidden = YES;
        
//        [self.mainVC.playerVC.videoView resume];
    }
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
