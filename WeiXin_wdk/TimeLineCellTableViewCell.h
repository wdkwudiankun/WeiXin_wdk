//
//  TimeLineCellTableViewCell.h
//  WeiXin_wdk
//
//  Created by KUN on 2017/6/20.
//  Copyright © 2017年 WuDiankun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TimeLineCellDelegate <NSObject>

-(void)didClickLikeButtonInCell:(UITableViewCell *)cell;
-(void)didClickCommentButtonInCell:(UITableViewCell *)cell;

@end

typedef void (^moreBtnBlock)(NSIndexPath *indexPath);

@class TimeLineModel;
@interface TimeLineCellTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) TimeLineModel *model;
@property (nonatomic, weak) id<TimeLineCellDelegate> delegate;

@property (nonatomic, copy) void (^moreButtonClickedBlock)(NSIndexPath *indexPath);
@property (nonatomic, copy) void (^didClickCommentLabelBlock)(NSString *commentId,CGRect rectIndWindow, NSIndexPath *indexPath);
@property (nonatomic, copy) moreBtnBlock block;
@end
