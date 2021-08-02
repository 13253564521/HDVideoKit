//
//  HDwbViewController.m
//  HDVideoKit
//
//  Created by ^-^ on 2020/9/21.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import "HDwbViewController.h"
#import "Macro.h"
#import <WebKit/WebKit.h>
@interface HDwbViewController ()<WKNavigationDelegate>
@property(nonatomic,strong) WKWebView *webView;
@property(nonatomic,strong)UIProgressView*progressView;

@end

@implementation HDwbViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    self.webView.navigationDelegate=self;
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];

    NSString *bundlePath = [NSBundle mainBundle].bundlePath;
    NSString *filtersPath = [bundlePath stringByAppendingString:@"/HDVideoKitResources.bundle"];
    NSString *jsonPath = [filtersPath stringByAppendingString:@"/sijiproto.docx"];
    
    NSURL *url = [NSURL fileURLWithPath:jsonPath];
    [self.webView loadFileURL:url allowingReadAccessToURL:url];

    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self.view addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.height.mas_equalTo(2);
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ( [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        self.progressView.alpha = 1.0f;
        [self.progressView setProgress:newprogress animated:YES];
        if (newprogress >= 1.0f) {
            [UIView animateWithDuration:0.3f
                                  delay:0.3f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 self.progressView.alpha = 0.0f;
                             }
                             completion:^(BOOL finished) {
                                 [self.progressView setProgress:0 animated:NO];
                             }];
        }
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] init];
//        _progressView.frame = CGRectMake(0, NAV_HEIGHT, [UIScreen mainScreen].bounds.size.width, 2);
    }
    return _progressView;
}

- (void)dealloc {//最后别忘了销毁KVO监听
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress" context:nil];
    [self.webView removeFromSuperview];
    self.webView=nil;
    self.webView.navigationDelegate=nil;
    
}


@end
