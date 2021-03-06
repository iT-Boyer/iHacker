//
//  WKWebViewController.m
//  JinheAPP
//
//  Created by boyer on 2022/1/21.
//

#import "WKWebViewController.h"

@implementation WKWebViewController
{
    WKWebView * _webView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    [self createView];
}

-(void)createView
{
    //创建网页配置对象
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    //初始化
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(40, 120, UIScreen.mainScreen.bounds.size.width - 80, UIScreen.mainScreen.bounds.size.height - 180) configuration:config];
    _webView.scrollView.backgroundColor = [UIColor clearColor];
    _webView.scrollView.scrollEnabled = false;
    _webView.opaque = false;
    NSString *html = @"<div style=\"width: 100%; height: auto;word-wrap:break-word; word-break:break-all;overflow: hidden; \"><p>老版本承诺书！</p></div>";
    NSString *html3 = [self setHtmlStringWithContent:html];
    [_webView loadHTMLString:html3 baseURL:nil];
    
    [self.view addSubview:_webView];
}

// 配置blog h5数据
- (NSString *)setHtmlStringWithContent:(NSString *)content{
    
    const NSString *htmlHead = @"<!DOCTYPE html><html><head><meta http-equiv='Content-Type' content='text/html; charset=utf-8' /><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\" />";
    
    const NSString *htmlBlogContentStart = [NSString stringWithFormat:@"</head><body>"];
    
    const NSString *htmlBlogContentEnd = @"</body></html>";
    

    NSString *html = [NSString stringWithFormat:@"%@%@%@%@",htmlHead,htmlBlogContentStart,content,htmlBlogContentEnd];
    
    return html;
}

//-(void)webViewDidFinishLoad:(UIWebView *)webView
//{
////    [_webView evaluateJavaScript:@"document.body.style.backgroundColor=\"#1E1E1E\"" completionHandler:nil];
//    _webView.scrollView.backgroundColor = [UIColor clearColor];
//}

@end
