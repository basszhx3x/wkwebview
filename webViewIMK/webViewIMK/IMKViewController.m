//
//  IMKViewController.m
//  webViewIMK
//
//  Created by baron on 16/9/19.
//  Copyright © 2016年 baron. All rights reserved.
//

#import "IMKViewController.h"
#import <WebKit/WebKit.h>

@interface IMKViewController ()<WKUIDelegate,WKScriptMessageHandler,WKNavigationDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollerView;
@property (strong, nonatomic)WKWebView* myWebView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (assign, nonatomic)BOOL    isResize;


@end

@implementation IMKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString* urlString = @"http://wepclass.cjatech.com/CP/V/course--list";
    NSURL* url = [NSURL URLWithString:urlString];
    //  NSURLRequest* request = [NSURLRequest requestWithURL:url];
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = [[WKUserContentController alloc] init];
    
    [self createWkWebViewWithConfig:config url:url];
    // 注入JS对象Native，
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.isResize = YES;
    self.progressView.progressTintColor = [UIColor greenColor];
    self.progressView.trackTintColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)createWkWebViewWithConfig:(WKWebViewConfiguration *)config url:(NSURL *)url {
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    if (self.myWebView) {
        [self.myWebView removeObserver:self forKeyPath:@"estimatedProgress"];
        [self.myWebView removeFromSuperview];
    }
    
    self.myWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) configuration:config];
  //  self.myWebView.scrollView.scrollsToTop = YES;
    self.myWebView.scrollView.delaysContentTouches = NO;
    self.myWebView.scrollView.canCancelContentTouches = NO;
    self.myWebView.UIDelegate = self;
    
    self.myWebView.contentMode = UIViewContentModeScaleAspectFill;
    self.myWebView.navigationDelegate = self;
    [self.myWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    NSLog(@"%@",[self.myWebView loadRequest:request]); // [self.myWebView loadRequest:request];
    
   // [self.view insertSubview:self.myWebView belowSubview:self.progressView];
  //  self.myWebView.scrollView.scrollEnabled = NO;
    [self.view insertSubview:self.myWebView belowSubview:self.progressView];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        //  NSLog(@"%0.2f",self.myWebView.estimatedProgress);
        self.progressView.hidden = self.myWebView.estimatedProgress == 1;
        [self.progressView setProgress:self.myWebView.estimatedProgress animated:YES];
    }
}

//设置样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

//设置是否隐藏
- (BOOL)prefersStatusBarHidden {
    //    [super prefersStatusBarHidden];
    return NO;
}

//设置隐藏动画
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.myWebView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20);
    self.myWebView.scrollView.scrollsToTop = YES;
//    
//    if (self.isResize) {
//        return;
//    }
//    __weak __typeof(&*self) weakSelf = self;
//
//    self.isResize = YES;
//    NSString* jsString = @"document.body.offsetHeight";
//
//    [self.myWebView evaluateJavaScript:jsString completionHandler:^(id _Nullable string, NSError * _Nullable error) {
//        
//        NSLog(@"%@",string);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            weakSelf.myWebView.frame = CGRectMake(0, 20, self.view.frame.size.width, [string doubleValue]);
//            
//            weakSelf.isResize = NO;
//            
//        });
//    }];

    //    NSString* jsString = @"document.body.offsetHeight";
    
}
-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}


- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    //    if ([message.name isEqualToString:@"Native"]) {
}


- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.myWebView.scrollView.scrollsToTop = YES;
    
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.progressView setProgress:0.0 animated:YES];
   // NSString* jsString = @"document.body.offsetHeight";

  //  [self.myWebView.scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    NSUInteger code = ((NSHTTPURLResponse *)navigationResponse.response).statusCode;
    
    if (code == 404) {
        decisionHandler(WKNavigationResponsePolicyCancel);
        return;
    }
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
