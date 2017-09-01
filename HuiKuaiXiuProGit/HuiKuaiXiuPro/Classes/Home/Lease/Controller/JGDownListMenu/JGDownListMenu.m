//
//  JGDownListMenu.m
//  JGDownListMenu
//
//  Created by 郭军 on 2017/3/18.
//  Copyright © 2017年 ZJNY. All rights reserved.
//

#import "JGDownListMenu.h"
#import "JGDownListMenuCell.h"
#import "CommonMethod.h"
#import "HKXOwnerMoreInfoViewController.h"
/**
 *  主屏的宽
 */
#define DEF_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

/**
 *  主屏的高
 */
#define DEF_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height


@interface JGDownListMenu () <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSArray *arr;
@property(nonatomic,assign)CGFloat rowHeight;   // 行高
@property(nonatomic,strong)UIButton *button;    //从Controller传过来的控制器
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIImageView *arrow;
@property(nonatomic,assign)NSInteger index;    //记录选中行

@end

static NSString * const JGDownListMenuCellId = @"JGDownListMenuCellId";

@implementation JGDownListMenu

- (id)initWithFrame:(CGRect)listFrame ListDataSource:(NSArray *)array rowHeight:(CGFloat)rowHeight view:(UIView *)v {
    if (self = [super initWithFrame:listFrame]) {
        
        self.arr = array;
        self.rowHeight = rowHeight;
        self.button = (UIButton *)v;
        
    }
    return self;
}


-(UIView *)bgView
{
    if (!_bgView)
    {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT)];
        _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    }
    return _bgView;
}
-(UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth - 90, 10, 90, 90) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.layer.borderWidth = 1;
        _tableView.layer.borderColor = [[UIColor lightGrayColor] CGColor];//设置列表边框
        [_tableView registerClass:[JGDownListMenuCell class] forCellReuseIdentifier:JGDownListMenuCellId];
    }
    return _tableView;
}
-(NSArray *)arr
{
    if (!_arr)
    {
        _arr = [[NSArray alloc] init];
    }
    return _arr;
}
-(UIImageView *)arrow
{
    if (!_arrow)
    {
        //        _arrow = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - 35, 10, 20, 20)];
        //        _arrow.image = [UIImage imageNamed:@"ico_make"];
    }
    return _arrow;
}
/**
 *   显示下拉列表
 */
-(void)showList
{
    [self.tableView reloadData];
    [UIView animateWithDuration:0.25f animations:^{
        self.bgView.alpha = 1;
        
        self.tableView.frame = CGRectMake(0, 0, self.frame.size.width, CGRectGetHeight(self.frame));
    }];
    [self addSubview:self.tableView];
}
/**
 *  隐藏
 */
-(void)hiddenList
{
    [UIView animateWithDuration:0.25f animations:^{
        self.bgView.alpha = 0;
        //self.tableView.frame = CGRectZero;
        
        self.tableView.frame = CGRectMake(self.button.frame.origin.x, 0, 0, 0);
    } completion:^(BOOL finished) {
        
        [_bgView removeFromSuperview];
        
    }];
    if ([self.mark isEqualToString:@"租赁"]) {
        
        
    }else{
        
        [self removeFromSuperview];
    }
    
}

#pragma mark - UITableViewDelegateAndUITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    JGDownListMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:JGDownListMenuCellId forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([self.arr[0] isKindOfClass:[NSString class]]) {
        
        cell.titleLbl.text = self.arr[indexPath.row];
        
    }else{
        
        cell.titleLbl.text = self.arr[indexPath.row][@"brandType"];
        
    }
    if ([self.mark isEqualToString:@"商城列表"]) {
        
        UIView *view = [[UIView alloc]init];
        view.backgroundColor=[CommonMethod getUsualColorWithString:@"#ffa304"];
        cell.selectedBackgroundView=view;
    }
    
    if ([self.mark isEqualToString:@"保修"]) {
        if (indexPath.row == self.arr.count - 1) {
            
            cell.titleLbl.textColor = [UIColor orangeColor];
        }else{
            
            cell.titleLbl.textColor = [UIColor blackColor];
        }
        
    }
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
#pragma mark ----------------UITableView  表的选中方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.mark isEqualToString:@"商城列表"]) {
        
        
    }else{
        
        [self hiddenList];
    }
    
    self.index = indexPath.row;
    if ([self.delegate respondsToSelector:@selector(dropDownListParame:)])
    {
        if ([self.arr[indexPath.row] isKindOfClass:[NSString class]]&&[self.arr[indexPath.row] isEqualToString:@"发布出租"]) {
            
            [self.delegate dropDownListParame:@"发布出租"];
        }else if([self.arr[indexPath.row] isKindOfClass:[NSString class]]&&[self.arr[indexPath.row] isEqualToString:@"发布求租"]){
            
            
            [self.delegate dropDownListParame:@"发布求租"];
        }else if([self.mark isEqualToString:@"接单列表"]){
            
            [self.delegate dropDownListParame:self.arr[indexPath.row]];
        }else{
            
            NSLog(@"设备或地址点击");
            [self.delegate dropDownListParame:[NSString stringWithFormat:@"%ld",self.index]];
        }
        
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (UIViewController *)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}



@end
