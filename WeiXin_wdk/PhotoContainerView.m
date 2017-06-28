//
//  PhotoContainerView.m
//  WeiXin_wdk
//
//  Created by KUN on 2017/6/22.
//  Copyright © 2017年 WuDiankun. All rights reserved.
//

#import "PhotoContainerView.h"
#import "UIView+SDAutoLayout.h"
#import "SDPhotoBrowser.h"

@interface PhotoContainerView() <SDPhotoBrowserDelegate>

@property (nonatomic, strong) NSArray *imageViewsArray;

@end

@implementation PhotoContainerView

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        [self setupViews];
        
    }
    return self;
}

-(void)setupViews{

    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < 9;  i ++) {
        UIImageView *imageView = [UIImageView new];
        [self addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImgView:)];
        [imageView addGestureRecognizer:tap];
        [temp addObject:imageView];
    }
    
    self.imageViewsArray = [temp copy];
}

//set 方法
-(void)setPicPathStringsArray:(NSArray *)picPathStringsArray{

    _picPathStringsArray = picPathStringsArray;
    for (long i = _picPathStringsArray.count; i < _imageViewsArray.count; i ++) {
        UIImageView *imageView = [self.imageViewsArray objectAtIndex:i];
        imageView.hidden = YES;
    }
    
    if (_picPathStringsArray.count == 0) {
        self.height = 0;
        self.fixedHeight = @(0);
        return;
    }
    
    CGFloat itemW = [self itemWidthPicArray:_picPathStringsArray];
    CGFloat itemH = 0;
    if (_picPathStringsArray.count == 1) {
        UIImage *image = [UIImage imageNamed:_picPathStringsArray.firstObject];
        if (image.size.width) {
            itemH = image.size.height / image.size.width * itemW;
        }
    }else{
    
        itemH = itemW;
    }
    
    //返回多少行
    long perRowItemCount = [self perRowItemCountForPicPathArray:_picPathStringsArray];
    CGFloat margin = 5;
    
    [_picPathStringsArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //
        long columnIndex = idx % perRowItemCount;
        long rowIndex = idx / perRowItemCount;
        UIImageView *imageView = [_imageViewsArray objectAtIndex:idx];
        imageView.hidden = NO;
        imageView.image = [UIImage imageNamed:obj];
        imageView.frame = CGRectMake(columnIndex * (itemW + margin), rowIndex *(itemH + margin), itemW, itemH);
    }];
    
    CGFloat w = perRowItemCount *itemH + (perRowItemCount - 1) * margin;
    int columnCount = ceilf(_picPathStringsArray.count * 1.0 / perRowItemCount);
    CGFloat h = columnCount * itemH + (columnCount - 1) *margin;
    self.width = w;
    self.height = h;
    
    self.fixedWidth = @(h);
    self.fixedWidth = @(w);
}


#pragma mark - 私有方法

//返回多少行，列
- (NSInteger )perRowItemCountForPicPathArray:(NSArray *)array{

    if (array.count <3) {
        return array.count;
        
    }else if (array.count <= 4){
    
        return 2;
    }else{
    
        return 3;
    }
}

-(CGFloat)itemWidthPicArray:(NSArray *)array{

    if (array.count == 1) {
        return 120;
    }else{
    
        CGFloat w = [UIScreen mainScreen].bounds.size.width > 320 ? 80:65 ;
        return w;
    }
}

-(void)tapImgView:(UITapGestureRecognizer *)tap{

    UIView *imgView = tap.view;
    SDPhotoBrowser *browse = [[SDPhotoBrowser alloc] init];
    browse.currentImageIndex = imgView.tag;
    browse.sourceImagesContainerView = self;
    browse.imageCount = _picPathStringsArray.count;
    browse.delegate = self;
    [browse show];
    
}


#pragma  mark --- sdphotoBrowserDelegate

-(UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{

    UIImageView *imagView = self.subviews[index];
    return imagView.image;
}

-(NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{

    NSString *imagename = self.picPathStringsArray[index];
    NSURL *imagUrl = [[NSBundle mainBundle] URLForResource:imagename withExtension:nil];
    return imagUrl;
}

@end
