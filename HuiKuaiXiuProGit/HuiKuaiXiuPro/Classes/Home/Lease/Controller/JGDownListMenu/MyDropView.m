//
//  JGDownListMenu.m
//  JGDownListMenu
//
//  Created by 郭军 on 2017/3/18.
//  Copyright © 2017年 ZJNY. All rights reserved.
//

#import "MyDropView.h"
#import "JGDownListMenuCell.h"

/**
 *  主屏的宽
 */
#define DEF_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

/**
 *  主屏的高
 */
#define DEF_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height


@interface MyDropView () <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSArray *arr;
@property(nonatomic,assign)CGFloat rowHeight;   // 行高
@property(nonatomic,strong)UIButton *button;    //从Controller传过来的控制器
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIImageView *arrow;
@property(nonatomic,assign)NSInteger index;    //记录选中行

@end

static NSString * const JGDownListMenuCellId = @"JGDownListMenuCellId";

@implementation MyDropView

- (id)initWithFrame1:(CGRect)listFrame ListDataSource1:(NSArray *)array rowHeight1:(CGFloat)rowHeight view1:(UIView *)v{
    
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
-(void)showList1
{
    
    [self.tableView reloadData];
    [UIView animateWithDuration:0.25f animations:^{
        self.bgView.alpha = 1;
        self.tableView.frame = CGRectMake(0, 0,self.frame.size.width, self.arr.count * 40);
    }];
    [self addSubview:self.tableView];
}
/**
 *  隐藏
 */
-(void)hiddenList1
{
    [UIView animateWithDuration:0.25f animations:^{
        self.bgView.alpha = 0;
        //self.tableView.frame = CGRectZero;
        
        self.tableView.frame = CGRectMake(self.button.frame.origin.x, 0, 0, 0);
    } completion:^(BOOL finished) {
        [_bgView removeFromSuperview];
    }];
}

#pragma mark - UITableViewDelegateAndUITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    JGDownListMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:JGDownListMenuCellId forIndexPath:indexPath];
    if ([self.arr[0] isKindOfClass:[NSString class]]) {
        
        cell.titleLbl.text = self.arr[indexPath.row];
    }else{
        cell.titleLbl.text = self.arr[indexPath.row][@"brandType"];
        
    }
    
    //    if (self.index == indexPath.row)
    //    {
    //        if ([cell.titleLbl.text isEqualToString:self.button.titleLabel.text])
    //        {
    //            [cell addSubview:self.arrow];
    //        }
    //    }
    
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
#pragma mark ----------------UITableView  表的选中方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self hiddenList1];
    self.index = indexPath.row;
    if ([self.delegate respondsToSelector:@selector(dropDownListParame1:)])
    {
    [self.delegate dropDownListParame1:self.arr[indexPath.row]];

    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}


@end
