//
//  TimeLineCellCommentView.h
//  WeiXin_wdk
//
//  Created by KUN on 2017/6/22.
//  Copyright © 2017年 WuDiankun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeLineCellCommentView : UIView

-(void)setupWithLikeItemsArray:(NSArray *)likeItemsArray commentItemsArray:(NSArray *)commentItemsArray;

@property (nonatomic, copy) void (^didClickCommentLabelBlock)(NSString *commentId, CGRect rectInWindow);

@end
