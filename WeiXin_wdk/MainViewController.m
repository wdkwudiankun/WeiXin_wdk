//
//  MainViewController.m
//  WeiXin_wdk
//
//  Created by KUN on 2017/6/21.
//  Copyright © 2017年 WuDiankun. All rights reserved.
//

#import "MainViewController.h"
#import "TimeLineTableViewController.h"

@interface MainViewController ()

@property (nonatomic, strong) UIButton *pushBtn;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pushBtn = [[UIButton alloc] initWithFrame:CGRectMake(60, 200, DeviceWidth - 120, 40)];
    [_pushBtn setTitle:@"进入朋友圈" forState:0];
    _pushBtn.backgroundColor = [UIColor lightGrayColor];
    [_pushBtn addTarget:self action:@selector(pushToTimeline) forControlEvents:UIControlEventTouchUpInside];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [self.view addSubview:_pushBtn];

}

-(void)pushToTimeline{

    TimeLineTableViewController *timelineVC = [[TimeLineTableViewController alloc] init];
    timelineVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:timelineVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
