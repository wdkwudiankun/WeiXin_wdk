//
//  TimeLineCellOperationMenu.h
//  WeiXin_wdk
//
//  Created by KUN on 2017/6/22.
//  Copyright © 2017年 WuDiankun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeLineCellOperationMenu : UIView

@property (nonatomic, assign, getter = isShowing) BOOL show;

@property (nonatomic, copy) void (^likeButtonClickedOperation)();
@property (nonatomic, copy) void (^commentButtonClickedOperation)();
@end
