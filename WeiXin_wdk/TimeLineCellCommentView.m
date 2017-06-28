//
//  TimeLineCellCommentView.m
//  WeiXin_wdk
//
//  Created by KUN on 2017/6/22.
//  Copyright © 2017年 WuDiankun. All rights reserved.
//

#import "TimeLineCellCommentView.h"
#import "MLLinkLabel.h"
#import "UIView+SDAutoLayout.h"
#import "TimeLineModel.h"


@interface TimeLineCellCommentView()<MLLinkLabelDelegate>

@property (nonatomic, strong) NSArray *likeItemsArray;
@property (nonatomic, strong) NSArray *commentItemsArray;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIView *likeLableBottomLine;
@property (nonatomic, strong) NSMutableArray *commentLabelsArray;

@property (nonatomic, strong) MLLinkLabel *likeLabel;

@end

@implementation TimeLineCellCommentView

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{

    _bgImageView = [UIImageView new];
//    UIImage *bgImage = [[[UIImage imageNamed:@"LikeCmtBg"] stretchableImageWithLeftCapWidth:40 topCapHeight:30] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    
    //stretchableImageWithLeftCapWidth: 这个函数是UIImage的一个实例函数，它的功能是创建一个内容可拉伸，而边角不拉伸的图片，需要两个参数，第一个是左边不拉伸区域的宽度，第二个参数是上面不拉伸的高度。
    UIImage *bgImage = [[UIImage imageNamed:@"LikeCmtBg"] stretchableImageWithLeftCapWidth:40 topCapHeight:30];
    _bgImageView.image = bgImage;
    _bgImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:_bgImageView];
    
    _likeLabel = [MLLinkLabel new];
    _likeLabel.font = [UIFont systemFontOfSize:13];
    _likeLabel.isAttributedContent = YES;
    _likeLabel.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:92/255.0 green:140/255.0 blue:193/255.0 alpha:1.0]};
    [self addSubview: _likeLabel];
    
    _likeLableBottomLine = [UIView new];
//    _likeLableBottomLine.backgroundColor = [UIColor colorWithRed:210 green:210 blue:210 alpha:1.0];
    
    _likeLableBottomLine.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:223/255.0 alpha:0.7];
    [self addSubview:_likeLableBottomLine];
    
    _bgImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    
}

-(NSMutableArray *)commentLabelsArray{

    if (!_commentLabelsArray) {
        _commentLabelsArray = [[NSMutableArray alloc] init];
        
    }
    return _commentLabelsArray;
}

-(void)setCommentItemsArray:(NSArray *)commentItemsArray{

    _commentItemsArray = commentItemsArray;
    
    long originalLabelCount = self.commentLabelsArray.count;
    
    long needToAddCount = commentItemsArray.count > originalLabelCount ? (commentItemsArray.count - originalLabelCount) : 0;
    
//    long needToAddCount = commentItemsArray.count ; // new add

    
    for (int i = 0 ; i < needToAddCount ; i ++) {
        MLLinkLabel *label = [MLLinkLabel new];
        label.linkTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:92/255.0 green:140/255.0 blue:193/255.0 alpha:1.0]};
        label.delegate = self;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:13];
        [self addSubview:label];
        [self.commentLabelsArray addObject:label];
        
    }
    for (int i = 0 ; i < commentItemsArray.count ; i ++) {
        TimeLineCellCommentItemModel *model = commentItemsArray[i];
        MLLinkLabel *label = self.commentLabelsArray[i];
        if (!model.attributedContent) {
            model.attributedContent = [self generateAttributedStringWithCommentItemModel:model];
        }
        label.attributedText = model.attributedContent;
    }
    
}

-(void)setLikeItemsArray:(NSArray *)likeItemsArray{

    _likeItemsArray = likeItemsArray;
    NSTextAttachment *attach = [NSTextAttachment new];
    attach.image = [UIImage imageNamed:@"Like"];
    attach.bounds = CGRectMake(0, -3, 16, 16);
    NSAttributedString *likeIcon = [NSAttributedString attributedStringWithAttachment:attach];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:likeIcon];
    
    for (int i = 0; i < likeItemsArray.count;  i ++) {
        TimeLineCellLikeItemModel *model = likeItemsArray[i];
        if (i > 0) {
            [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@", "]];
            
        }
        if (!model.attributedContent) {
            model.attributedContent = [self generateAttributedStringWithLikeItemModel:model];
        }
        
        [attributedText appendAttributedString:model.attributedContent];
    }
    
    _likeLabel.attributedText = [attributedText copy];
}


//给评论回复加 属性
-(NSMutableAttributedString *)generateAttributedStringWithCommentItemModel:(TimeLineCellCommentItemModel *)model{

    NSString *text = model.firstUserName;
    if (model.secondUserName.length) {
        text = [text stringByAppendingString:[NSString stringWithFormat:@"回复 %@",model.secondUserName
                                              ]];
    }
    text = [text stringByAppendingString:[NSString stringWithFormat:@": %@",model.commentString]];
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    [attString setAttributes:@{NSLinkAttributeName : model.firstUserName} range:[text rangeOfString:model.firstUserName]];
    
    if (model.secondUserName) {
        [attString setAttributes:@{NSLinkAttributeName : model.secondUserId} range:[text rangeOfString:model.secondUserName]];
    }
    
    return attString;

}

- (NSMutableAttributedString *)generateAttributedStringWithLikeItemModel:(TimeLineCellLikeItemModel *)model
{
    NSString *text = model.userName;
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    UIColor *highLightColor = [UIColor blueColor];
    [attString setAttributes:@{NSForegroundColorAttributeName : highLightColor, NSLinkAttributeName : model.userId} range:[text rangeOfString:model.userName]];
    
    return attString;
}

//mllinklabel delegate
-(void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel{

    NSLog(@"%@", link.linkValue);
}



#pragma mark - like comment
-(void)setupWithLikeItemsArray:(NSArray *)likeItemsArray commentItemsArray:(NSArray *)commentItemsArray{

    self.likeItemsArray = likeItemsArray;
    self.commentItemsArray = commentItemsArray;
    
    if (self.commentLabelsArray.count) {
        [self.commentLabelsArray enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL * _Nonnull stop) {
            //
            [label sd_clearAutoLayoutSettings];//清空之前的自动布局设置
            label.hidden = YES;
            
        }];
    }
    
    if (!commentItemsArray.count && !likeItemsArray.count) {
        self.fixedWidth = @(0);
        self.fixedHeight = @(0);//设置高度，宽度   固定不变
        return;
    }else{
    
        self.fixedHeight = nil;
        self.fixedWidth = nil;//取消 固定的高度，宽度约束
    }
    
    CGFloat margin = 5;
    UIView *lastTopView = nil;
    
    if (likeItemsArray.count) {
        //清空之前的布局 重新布局
        _likeLabel.sd_resetLayout.leftSpaceToView(self, margin).rightSpaceToView(self, margin).topSpaceToView(lastTopView, 10).autoHeightRatio(0);
        lastTopView = _likeLabel;
    }else{
    
        _likeLabel.attributedText = nil;
        _likeLabel.sd_resetLayout.heightIs(0);
    }
    
    //评论+赞
    if (self.commentItemsArray.count && self.likeItemsArray.count) {
        _likeLableBottomLine.sd_resetLayout.leftSpaceToView(self, 0).rightSpaceToView(self, 0).heightIs(0.5).topSpaceToView(lastTopView, 3);
        lastTopView = _likeLableBottomLine;
    }else{
    
        _likeLableBottomLine.sd_resetLayout.heightIs(0);
    }
    
    
    for (int i = 0 ; i < self.commentItemsArray.count; i ++) {
        UILabel *label = (UILabel *)self.commentLabelsArray[i];  // new add
        label.hidden = NO;
        CGFloat topmargin = (i == 0 && likeItemsArray.count == 0 ) ? 10:5;
        label.sd_layout.leftSpaceToView(self , 8).rightSpaceToView(self, 5).topSpaceToView(lastTopView, topmargin).autoHeightRatio(0);
        label.isAttributedContent = YES;
        lastTopView = label;
    }
    
    //设置cell的高度自适应
    [self setupAutoHeightWithBottomView:lastTopView bottomMargin:6];
    
}

-(void)setFrame:(CGRect)frame{

    [super setFrame:frame];
}




@end
