//
//  TimeLineModel.h
//  WeiXin_wdk
//
//  Created by KUN on 2017/6/20.
//  Copyright © 2017年 WuDiankun. All rights reserved.
//

#import <Foundation/Foundation.h>


@class TimeLineCellCommentItemModel, TimeLineCellLikeItemModel;

@interface TimeLineModel : NSObject

@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *msgContent;

@property (nonatomic, strong) NSArray *picNameArray;
@property (nonatomic, assign, getter=isLiked) BOOL liked;

@property (nonatomic, assign) BOOL isOpening;
@property (nonatomic, assign, readonly ) BOOL shouldShowMoreButton;

@property (nonatomic ,strong) NSArray <TimeLineCellLikeItemModel *> *likeItemsArray;

@property (nonatomic, strong) NSArray <TimeLineCellCommentItemModel *> *commentItemsArray;


@end


@interface TimeLineCellLikeItemModel : NSObject

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSAttributedString *attributedContent;


@end

@interface TimeLineCellCommentItemModel : NSObject

@property (nonatomic, copy) NSString *commentString;

@property (nonatomic, copy) NSString *firstUserName;
@property (nonatomic, copy) NSString *firstUserId;

@property (nonatomic, copy) NSString *secondUserName;
@property (nonatomic, copy) NSString *secondUserId;

@property (nonatomic, copy) NSAttributedString *attributedContent;

@end
