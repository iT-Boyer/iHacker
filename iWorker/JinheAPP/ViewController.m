//
//  ViewController.m
//  JinheAPP
//
//  Created by boyer on 2021/12/29.
//

#import "ViewController.h"
#import "WKWebViewController.h"
@interface ViewController ()

@end

@implementation ViewController

-(void)createView
{
    UIButton *wkBtn = [[UIButton alloc] initWithFrame:CGRectMake(120, 200, 120, 20)];
    [wkBtn setTitle:@"wk控件" forState:UIControlStateNormal];
    [wkBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [wkBtn addTarget:self action:@selector(goWk) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:wkBtn];
}

-(void)goWk
{
    WKWebViewController *wkVC = [[WKWebViewController alloc] init];
    [self.navigationController pushViewController:wkVC animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"demo 样例";
    [self createView];
}

+(void)classmethod
{
    NSLog(@"我是类方法");
}



@end
