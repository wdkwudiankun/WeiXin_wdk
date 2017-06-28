//
//  TimeLineHeaderView.m
//  WeiXin_wdk
//
//  Created by KUN on 2017/6/20.
//  Copyright © 2017年 WuDiankun. All rights reserved.
//

#import "TimeLineHeaderView.h"
#import "UIView+SDAutoLayout.h"

@implementation TimeLineHeaderView
{

    UIImageView *_backgroundImgView;
    UIImageView *_iconView;
    UILabel * _nameLabel;
    
}
-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        [self setUpView];
    }
    return self;
}

-(void)setUpView{

    _backgroundImgView = [UIImageView new];
    _backgroundImgView.image = [UIImage imageNamed:@"pbg.jpg"];
    [self addSubview:_backgroundImgView];
    
    _iconView = [UIImageView new];
    _iconView.image = [UIImage imageNamed:@"picon.jpg"];
    _iconView.layer.borderColor = [UIColor whiteColor].CGColor;
    _iconView.layer.borderWidth = 3;
    [self addSubview:_iconView];
    
    _nameLabel = [UILabel new];
    _nameLabel.text = @"Diankun";
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.textAlignment = NSTextAlignmentRight;
    _nameLabel.font = [UIFont boldSystemFontOfSize:15];
    [self addSubview:_nameLabel];
    
    //autolayout
    _backgroundImgView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(-60, 0, 40, 0));
    
    _iconView.sd_layout.widthIs(70).heightIs(70).rightSpaceToView(self, 15).bottomSpaceToView(self, 20);
    
    _nameLabel.sd_layout.rightSpaceToView(_iconView, 20).bottomSpaceToView(_iconView, -35).heightIs(20);
    _nameLabel.tag = 1999;
    [_nameLabel setSingleLineAutoResizeWithMaxWidth:200];//设置单行文本在宽度限定的时候字体大小自适应
}

@end
