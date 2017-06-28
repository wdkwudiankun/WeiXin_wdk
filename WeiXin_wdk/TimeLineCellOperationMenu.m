//
//  TimeLineCellOperationMenu.m
//  WeiXin_wdk
//
//  Created by KUN on 2017/6/22.
//  Copyright © 2017年 WuDiankun. All rights reserved.
//

#import "TimeLineCellOperationMenu.h"
#import "UIView+SDAutoLayout.h"

@implementation TimeLineCellOperationMenu

{

    UIButton *_likeButton;
    UIButton *_commentButton;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 5;
    
//    self.backgroundColor = [UIColor colorWithRed:69 green:75 blue:78 alpha:1];
    
    self.backgroundColor = [UIColor grayColor];
    
    _likeButton = [self creatButtonWithTitle:@"赞" image:[UIImage imageNamed:@"AlbumLike"] selImage:[UIImage imageNamed:@"AlbumLike"] target:self selector:@selector(likeButtonClicked)];
    _commentButton = [self creatButtonWithTitle:@"评论" image:[UIImage imageNamed:@"AlbumComment"] selImage:[UIImage imageNamed:@"AlbumComment"] target:self selector:@selector(commentButtonClicked)];
    
    UIView *centerLine = [UIView new];
    centerLine.backgroundColor = [UIColor grayColor];
    
    
    [self sd_addSubviews:@[_likeButton, _commentButton, centerLine]];
    
    CGFloat margin = 5;
    
    _likeButton.sd_layout
    .leftSpaceToView(self, margin)
    .topEqualToView(self)
    .bottomEqualToView(self)
    .widthIs(80);
    
    centerLine.sd_layout
    .leftSpaceToView(_likeButton, margin)
    .topSpaceToView(self, margin)
    .bottomSpaceToView(self, margin)
    .widthIs(1);
    
    _commentButton.sd_layout
    .leftSpaceToView(centerLine, margin)
    .topEqualToView(_likeButton)
    .bottomEqualToView(_likeButton)
    .widthRatioToView(_likeButton, 1);
    
}

- (void)likeButtonClicked
{
    if (self.likeButtonClickedOperation) {
        self.likeButtonClickedOperation();
    }
    self.show = NO;
}

- (void)commentButtonClicked
{
    if (self.commentButtonClickedOperation) {
        self.commentButtonClickedOperation();
    }
    self.show = NO;
}

- (UIButton *)creatButtonWithTitle:(NSString *)title image:(UIImage *)image selImage:(UIImage *)selImage target:(id)target selector:(SEL)sel
{
    UIButton *btn = [UIButton new];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:selImage forState:UIControlStateSelected];
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
    return btn;
}


- (void)setShow:(BOOL)show
{
    _show = show;
    
    [UIView animateWithDuration:0.2 animations:^{
        if (!show) {
            [self clearAutoWidthSettings];
            self.sd_layout
            .widthIs(0);
        } else {
            self.fixedWidth = nil;
            [self setupAutoWidthWithRightView:_commentButton rightMargin:5];
        }
        [self updateLayoutWithCellContentView:self.superview];
    }];
}


@end
