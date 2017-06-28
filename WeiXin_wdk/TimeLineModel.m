//
//  TimeLineModel.m
//  WeiXin_wdk
//
//  Created by KUN on 2017/6/20.
//  Copyright © 2017年 WuDiankun. All rights reserved.
//

#import "TimeLineModel.h"
#import <UIKit/UIKit.h>


extern const CGFloat contentLabelFontSize;
extern CGFloat maxContentLabelHeight;
@implementation TimeLineModel{

    CGFloat _lastContentWidth;
}
@synthesize msgContent = _msgContent;
-(void)setMsgContent:(NSString *)msgContent{

    _msgContent = msgContent;
}

-(NSString *)msgContent{

    CGFloat contentW = DeviceWidth - 70;
    if (contentW !=  _lastContentWidth) {
        _lastContentWidth = contentW;
        CGRect textRect = [_msgContent boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:contentLabelFontSize]} context:nil];
        if (textRect.size.height > maxContentLabelHeight) {
            _shouldShowMoreButton = YES;
        }else{
        
            _shouldShowMoreButton = NO;
        }
    }
    return _msgContent;
}

-(void)setIsOpening:(BOOL)isOpening{

    if (!_shouldShowMoreButton) {
        _isOpening = NO;
    }else{
    
        _isOpening = isOpening;
    }
}

@end


@implementation TimeLineCellLikeItemModel

@end

@implementation TimeLineCellCommentItemModel

@end

