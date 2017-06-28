//
//  TimeLineTableViewController.m
//  WeiXin_wdk
//
//  Created by KUN on 2017/6/19.
//  Copyright © 2017年 WuDiankun. All rights reserved.
//

#import "TimeLineTableViewController.h"
#import "TimeLineModel.h"
#import "TimeLineHeaderView.h"
#import "TimeLineCellTableViewCell.h"

#import "UIView+SDAutoLayout.h"
#import "UITableView+SDAutoTableViewCellHeight.h"


@interface TimeLineTableViewController () <TimeLineCellDelegate , UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, assign) BOOL isReplayingComment;
@property (nonatomic, strong) NSIndexPath *currentEditingIndexPath;
@property (nonatomic, copy) NSString *commentToUser;

@end

@implementation TimeLineTableViewController

{
    CGFloat _lastScrollViewOffsetY;
    CGFloat _totalKeybordHeight;

}

-(NSMutableArray *)dataArray{

    if ( !_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeTop;
    
//    [self.dataArray addObject:[self arrayModelWithCout:16]];
    [self.dataArray addObjectsFromArray:[self arrayModelWithCout:16]];
    
    
    TimeLineHeaderView *headerView = [TimeLineHeaderView new];
    headerView.frame = CGRectMake(0, 0, 0, 260);
    self.tableView.tableHeaderView = headerView;
    
    [self.tableView registerClass:[TimeLineCellTableViewCell class] forCellReuseIdentifier:@"TimeLineCellTableViewCell"];
    
    [self setupTextField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];

}

-(void)setupTextField{
    
    _textField = [UITextField new];
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.delegate = self;
    _textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _textField.layer.borderWidth = 1;
    _textField.frame = CGRectMake(0, DeviceHeight, self.view.width, 40);
    
    _textField.backgroundColor = [UIColor whiteColor];
    
    [[UIApplication sharedApplication].keyWindow addSubview:_textField];
    [_textField becomeFirstResponder];
    [_textField resignFirstResponder];
    

}

- (NSArray *)arrayModelWithCout:(NSInteger )count{

    NSArray *iconImageNamesArray = @[@"icon0.jpg",
                                     @"icon1.jpg",
                                     @"icon2.jpg",
                                     @"icon3.jpg",
                                     @"icon4.jpg",
                                     ];
    
    NSArray *namesArray = @[@"人民警察",
                            @"阿里马云",
                            @"浦东IT",
                            @"陆毅",
                            @"Adele",
                            @"林心如",
                            @"专业跑腿1330930",
                            @"吃货一枚"];
    
    NSArray *textArray = @[@"“十一”前几天在家上网，一好久不联系的大学同学，突然间qq、微信都在线了，还给我发了个祝福短信。第一反应就是这货要结婚了，果断编了个理由回他，“哥们，我‘十一’订婚，你来不来参加我的订婚宴啊？”果不其然，他回：“不好意思，我‘十一’结婚，看样子你也来不了了。”～省了500大洋。",
                           @"微信demo学习交流，https://github.com/wdkwudiankun/WeiXin_wdk",
                           @"谁做爱护动物的公益我都没意见,你就算了吧",
                           @"男朋友说：你刚买的洗面奶是生姜味的啊？ 妹子听后，觉得蠢男友连青柠和生姜都分不清，又想起男朋友不喜欢吃生姜，又想起为他做菜好些都没放姜，又想起自己不爱吃青椒但男友每次都不记得，又想起男朋友上次居然记得前女友不喜欢吃豆芽…… 妹子说你自己一个人过吧然后收拾东西要走。 男友：？？？",
                           @"地铁里这个男生一直在玩游戏。当一位轮椅乘客进来的时候，他很自然地搭了手，拉住晃动的轮椅，又把一只脚卡在轮子下，把轮椅固定住，整个动作一气呵成。几个站过去了，一直没放手。"
                           ];
    
    NSArray *commentsArray = @[@"38",
                               @"如果是我，我就……",
                               @"一起学习",
                               @"有意思",
                               @"你瞅啥？",
                               @"瞅你咋地？？？！！！",
                               @"善良不需要更多理由，谢谢你，美丽的人。",
                               @"笑死我谁赔",
                               @"人艰不拆",
                               @"咯咯哒",
                               @"呵呵~~~~~~~~",
                               @"我勒个去，啥世道啊",
                               @"真有意思啊你💢💢💢"];
    
    NSArray *picImageNamesArray = @[ @"pic10.jpg",
                                     @"pic11.jpg",
                                     @"pic12.jpg",
                                     @"pic13.jpg",
                                     @"pic14.jpg",
                                     @"pic5.jpg",
                                     @"pic6.jpg",
                                     @"pic7.jpg",
                                     @"pic9.jpg"
                                     ];
    
    NSMutableArray *resArr = [NSMutableArray new];
    for (int i = 0; i < count; i ++) {
        int iconRandomIndex = arc4random_uniform(5);
        int nameRandomIndex = arc4random_uniform(5);
        int contentRandomIndex = arc4random_uniform(5);
        
        TimeLineModel *model = [TimeLineModel new];
        model.iconName = iconImageNamesArray[iconRandomIndex];
        model.name = namesArray[nameRandomIndex];
        model.msgContent = textArray[contentRandomIndex];
        
        
        //模拟图片
        int randomPic = arc4random_uniform(6);
        NSMutableArray *picArray = [NSMutableArray new];
        for (int i = 0 ; i < randomPic; i ++) {
            int randomIndex = arc4random_uniform(9);
            [picArray addObject:picImageNamesArray[randomIndex]];
            
        }
        if (picArray) {
            model.picNameArray = [picArray copy];
        }
        
        //模拟随机评论
        int commentRandom = arc4random_uniform(3);
        NSMutableArray *tempComments = [NSMutableArray new];
        for (int i = 0 ; i < commentRandom; i ++) {
            TimeLineCellCommentItemModel *commentItemModel = [TimeLineCellCommentItemModel new];
            int index = arc4random_uniform((int) namesArray.count);
            commentItemModel.firstUserName = namesArray[index];
            commentItemModel.firstUserId = @"432";
            if (arc4random_uniform(10) < 5) {
                commentItemModel.secondUserName = namesArray [arc4random_uniform((int) namesArray.count)];
                commentItemModel.secondUserId = @"543";
            }
            commentItemModel.commentString = commentsArray[arc4random_uniform((int)commentsArray.count)];
            [tempComments addObject:commentItemModel];
            
        }
        model.commentItemsArray = [tempComments copy];
        
        //模拟随机点赞
        int likeRandom = arc4random_uniform(3);
        NSMutableArray *tempLikes = [NSMutableArray new];
        for (int i = 0; i < likeRandom; i++) {
            TimeLineCellLikeItemModel *model = [TimeLineCellLikeItemModel new];
            int index = arc4random_uniform((int)namesArray.count);
            model.userName = namesArray[index];
            model.userId = namesArray[index];
            [tempLikes addObject:model];
        }
        model.likeItemsArray = [tempLikes copy];
        
        
        
        [resArr addObject:model];
        
    }
    
    return [resArr copy];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TimeLineCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeLineCellTableViewCell"];
    cell.indexPath = indexPath;
    __weak typeof (self) weakSelf = self;
    if (!cell.moreButtonClickedBlock) {
        [cell setMoreButtonClickedBlock:^(NSIndexPath *indexPath){
            //
            TimeLineModel *model = weakSelf.dataArray[indexPath.row];
            model.isOpening = !model.isOpening;
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
        
        [cell setDidClickCommentLabelBlock:^(NSString *commentId,CGRect rectIndWindow, NSIndexPath *indexPath){
            weakSelf.textField.placeholder = [NSString stringWithFormat:@"  回复 : %@",commentId];
            weakSelf.currentEditingIndexPath = indexPath;
            [weakSelf.textField becomeFirstResponder];
            weakSelf.isReplayingComment = YES;
            weakSelf.commentToUser = commentId;
            [weakSelf adjustTableViewToFitKeyboardWithRect:rectIndWindow];
            
        }];
        cell.delegate = self;
    }
    
    //实现cell的缓存，tableview滑动更加顺畅
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    cell.model = self.dataArray[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    id model = self.dataArray[indexPath.row];
    
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[TimeLineCellTableViewCell class] contentViewWidth:DeviceWidth];
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    [_textField resignFirstResponder];
    _textField.placeholder = nil;
}

#pragma mark - timelinecellDelegate

//点赞
-(void)didClickLikeButtonInCell:(UITableViewCell *)cell{

    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    TimeLineModel *model = self.dataArray[index.row];
    NSMutableArray *temp = [NSMutableArray arrayWithArray:model.likeItemsArray];
    
    if (!model.isLiked) {
        TimeLineCellLikeItemModel *likeModel = [TimeLineCellLikeItemModel new];
        likeModel.userName = @"Diankun";
        likeModel.userId = @"fheohf";
        [temp addObject:likeModel];
        model.liked = YES;
        
    }else{
    
        TimeLineCellLikeItemModel *tempLikeModel = nil;
        for (TimeLineCellLikeItemModel *likeModel in model.likeItemsArray) {
            if ([likeModel.userId isEqualToString:@"fheohf"]) {
                tempLikeModel = likeModel;
                break;
            }
        }
        
        [temp removeObject:tempLikeModel];
        model.liked = NO;
    }
    
    model.likeItemsArray = [temp copy];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //
        [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
    });
    
}

//评论
-(void)didClickCommentButtonInCell:(UITableViewCell *)cell{

    [_textField becomeFirstResponder];
    _currentEditingIndexPath = [self.tableView indexPathForCell:cell];
    [self adjustTableViewToFitKeyboard];
    
}

-(void)adjustTableViewToFitKeyboard{

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_currentEditingIndexPath];
    CGRect rect = [cell.superview convertRect:cell.frame toView:window];
    [self adjustTableViewToFitKeyboardWithRect:rect];
    
}

-(void)adjustTableViewToFitKeyboardWithRect:(CGRect)rect{
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    CGFloat delta = CGRectGetMaxY(rect) - (window.bounds.size.height - _totalKeybordHeight);
    CGPoint offset = self.tableView.contentOffset;
    offset.y += delta;
    if (offset.y < 0) {
        offset.y = 0;
    }
    [self.tableView setContentOffset:offset animated:YES];
    
}


#pragma mark - textfieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    if (textField.text.length) {
        [textField resignFirstResponder];
        
        TimeLineModel  *model = self.dataArray[_currentEditingIndexPath.row];
        NSMutableArray *temp = [NSMutableArray new];
        [temp addObjectsFromArray:model.commentItemsArray];
        
        TimeLineCellCommentItemModel *commentItemModel = [TimeLineCellCommentItemModel new];
        if (self.isReplayingComment) {
            commentItemModel.firstUserName = @"Diankun";
            commentItemModel.firstUserId = @"Diankun";
            commentItemModel.secondUserName = self.commentToUser;
            commentItemModel.secondUserId = self.commentToUser;
            commentItemModel.commentString = textField.text;
            self.isReplayingComment = NO;
        }else{
        
            commentItemModel.firstUserName = @"Diankun";
            commentItemModel.commentString = textField.text;
            commentItemModel.firstUserId = @"Diankun";
        }
        [temp addObject:commentItemModel];
        model.commentItemsArray = [temp copy];
        [self.tableView reloadRowsAtIndexPaths:@[_currentEditingIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        _textField.text = @"";
        _textField.placeholder = @"";
        
        return YES;
    }
    
    return NO;
}


-(void)keyboardNotification:(NSNotification *)notification{

    NSDictionary *dict = notification.userInfo;
    CGRect rect = [dict[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    CGRect textFieldRect = CGRectMake(0, rect.origin.y - 40, rect.size.width, 40);
    if (rect.origin.y == DeviceHeight) {
        textFieldRect = rect;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        _textField.frame = textFieldRect;
    }];
    
    CGFloat h = rect.size.height + 40;
    if (_totalKeybordHeight != h) {
        _totalKeybordHeight = h;
        [self adjustTableViewToFitKeyboard];
    }
}














/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
