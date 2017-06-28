//
//  DKTabBarController.m
//  WeiXin_wdk
//
//  Created by KUN on 2017/6/16.
//  Copyright © 2017年 WuDiankun. All rights reserved.
//

#import "DKTabBarController.h"
#import "MainViewController.h"

#define rootClassString @"rootVCClassString"
#define titleKey   @"title"
#define imgKey     @"imageName"
#define selImgKey  @"selectedImageName"

@interface DKTabBarController ()

@end

@implementation DKTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *childItem = @[@{rootClassString: @"MainViewController",
                             titleKey: @"朋友圈",
                             imgKey : @"tabbar_discover",
                             selImgKey: @"tabbar_discoverHL"}];
    
    [childItem enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *Vc = [NSClassFromString(obj[rootClassString]) new];
        Vc.title = obj[titleKey];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:Vc];
        UITabBarItem *item = Nav.tabBarItem;
        item.title = obj[titleKey];
        item.image = [UIImage imageNamed:obj[imgKey]];
        item.selectedImage = [[UIImage imageNamed:obj[selImgKey]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} forState:UIControlStateSelected];
        [self addChildViewController:Nav];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
