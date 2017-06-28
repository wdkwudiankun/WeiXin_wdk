//
//  TimeLineCellTableViewCell.m
//  WeiXin_wdk
//
//  Created by KUN on 2017/6/20.
//  Copyright © 2017年 WuDiankun. All rights reserved.
//

#import "TimeLineCellTableViewCell.h"
#import "TimeLineCellCommentView.h"
#import "PhotoContainerView.h"
#import "TimeLineCellOperationMenu.h"
#import "TimeLineModel.h"
#import "UIView+SDAutoLayout.h"

#define kSDTimeLineCellOperationButtonClickedNotification @"SDTimeLineCellOperationButtonClickedNotification"

CGFloat maxContentLabelHeight = 0;
const CGFloat contentLabelFontSize = 14;

@implementation TimeLineCellTableViewCell

{
    UIImageView *_iconView;
    UILabel *_nameLable;
    UILabel *_contentLabel;
    
    UILabel *_timeLabel;
    UIButton *_moreButton;
    UIButton *_operationButton;
    
    TimeLineCellCommentView *_commentView;
    PhotoContainerView *_picContainerView;
    TimeLineCellOperationMenu *_operationMenu;
  
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
    
}

-(void)setUpView{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveOperationButtonClickedNotification:) name:kSDTimeLineCellOperationButtonClickedNotification object:nil];

    _iconView = [UIImageView new];
    _nameLable = [UILabel new];
    _nameLable.font = [UIFont systemFontOfSize:14];
    _nameLable.textColor = [UIColor colorWithRed:(54 / 255.0) green:(71 / 255.0) blue:(121 / 255.0) alpha:0.9];
    
    _contentLabel = [UILabel new];
    _contentLabel.font = [UIFont systemFontOfSize:contentLabelFontSize];
    _contentLabel.numberOfLines = 0;
    if (maxContentLabelHeight == 0) {
        maxContentLabelHeight = _contentLabel.font.lineHeight * 3;
    }
    
    _moreButton = [UIButton new];
    [_moreButton setTitle:@"全文" forState:UIControlStateNormal];
    [_moreButton setTitleColor:[UIColor colorWithRed:(137 / 255.0) green:(166 / 255.0) blue:(202 / 255.0) alpha:1.0] forState:UIControlStateNormal];
    [_moreButton addTarget:self action:@selector(moreButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _moreButton.titleLabel.font = [UIFont systemFontOfSize:contentLabelFontSize];
    
    _operationButton = [UIButton new];
    [_operationButton setImage:[UIImage imageNamed:@"AlbumOperateMore"] forState:UIControlStateNormal];
    [_operationButton addTarget:self action:@selector(operationButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    _picContainerView = [[PhotoContainerView alloc] init];
    _commentView = [[TimeLineCellCommentView alloc] init];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    
    _operationMenu = [[TimeLineCellOperationMenu alloc] init];
    
    __weak typeof (self) weakSelf = self;
    [_operationMenu setLikeButtonClickedOperation:^{
        if ([weakSelf.delegate respondsToSelector:@selector(didClickLikeButtonInCell: )]) {
            [weakSelf.delegate didClickLikeButtonInCell:weakSelf];
        }
    }];
    [_operationMenu setCommentButtonClickedOperation:^{
        if ([weakSelf.delegate respondsToSelector:@selector(didClickCommentButtonInCell:)]) {
            [weakSelf.delegate didClickCommentButtonInCell:weakSelf];
        }
    }];
    
    NSArray *views = @[_iconView, _nameLable, _contentLabel, _moreButton, _picContainerView, _timeLabel, _operationButton, _operationMenu, _commentView];
    [self.contentView sd_addSubviews:views];//添加一组view
    
    UIView *contentView = self.contentView;
    CGFloat margin = 10;
    _iconView.sd_layout.leftSpaceToView(contentView, margin).topSpaceToView(contentView, margin + 5).widthIs(40).heightIs(40);
    
    _nameLable.sd_layout.leftSpaceToView(_iconView, margin).topEqualToView(_iconView).heightIs(18);
    [_nameLable setSingleLineAutoResizeWithMaxWidth:200];//设置单行文本宽度自适应
    
    _contentLabel.sd_layout.leftEqualToView(_nameLable).topSpaceToView(_nameLable, margin).rightSpaceToView(contentView, margin).autoHeightRatio(0);
    
    _moreButton.sd_layout.leftEqualToView(_contentLabel).topSpaceToView(_contentLabel, 1).widthIs(30);//高度在setmoel里设置
    _picContainerView.sd_layout.leftEqualToView(_contentLabel);//已经在内部实现宽度和高度自适应所以不需要再设置宽度高度，top值是具体有无图片在setModel方法中设置
    _timeLabel.sd_layout.leftEqualToView(_contentLabel).topSpaceToView(_picContainerView, margin).heightIs(15);
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    _operationButton.sd_layout.rightSpaceToView(contentView, margin).centerYEqualToView(_timeLabel).heightIs(25).widthIs(25);
    
    _commentView.sd_layout.leftEqualToView(_contentLabel).rightSpaceToView(self.contentView, margin).topSpaceToView(_timeLabel, margin);//内部已实现高度
    
    _operationMenu.sd_layout.rightSpaceToView(_operationButton, 0).heightIs(35).centerYEqualToView(_operationButton).widthIs(0);
    
    
}

-(void)setModel:(TimeLineModel *)model{

    _model = model;
    [_commentView setupWithLikeItemsArray:model.likeItemsArray commentItemsArray:model.commentItemsArray];
    
    _iconView.image = [UIImage imageNamed:model.iconName];
    _nameLable.text = model.name;
    _contentLabel.text = model.msgContent;
    _picContainerView.picPathStringsArray = model.picNameArray;//图片地址 数组
    
   
    if (model.shouldShowMoreButton) {
        _moreButton.hidden = NO;
        _moreButton.sd_layout.heightIs(20);
        if (model.isOpening) {
            //需要展开
            _contentLabel.sd_layout.maxHeightIs(MAXFLOAT);
            [_moreButton setTitle:@"收起" forState:UIControlStateNormal];
        }else{
        
            _contentLabel.sd_layout.maxHeightIs(maxContentLabelHeight);
            [_moreButton setTitle:@"全文" forState:UIControlStateNormal];
        }
    }else{
    
        _moreButton.sd_layout.heightIs(0);
        _moreButton.hidden = YES;
        
    }
    
    CGFloat picContainTopMargin = 0;
    if (model.picNameArray.count) {
        picContainTopMargin = 10;
        
    }
    _picContainerView.sd_layout.topSpaceToView(_moreButton, picContainTopMargin);
    
    UIView *bottomView;
    if (!model.commentItemsArray.count && !model.likeItemsArray.count) {
        bottomView = _timeLabel;
    }else{
    
        bottomView = _commentView;
    }
    
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:15];
    _timeLabel.text = @"1小时前";
    _timeLabel.textColor = [UIColor lightGrayColor];
    
}

-(void)setFrame:(CGRect)frame{

    [super setFrame:frame];
    if (_operationMenu.isShowing) {
        _operationMenu.show = NO;
    }
}


-(void)operationButtonClicked{

    _operationMenu.show = !_operationMenu.isShowing;

}

//点击 “更多”btn
-(void)moreButtonClicked{

    if (self.moreButtonClickedBlock) {
        self.moreButtonClickedBlock(self.indexPath);
    }
}

-(void)receiveOperationButtonClickedNotification:(NSNotification *)notification{

    UIButton *btn = [notification object];
    if (btn != _operationButton && _operationMenu.isShowing) {
        //
        _operationMenu.show = NO;
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [super touchesBegan:touches withEvent:event];
    if (_operationMenu.isShowing) {
        _operationMenu.show = NO;
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
