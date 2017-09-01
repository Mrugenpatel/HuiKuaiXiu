//
//  CustomDropDownBtn.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/7/3.
//  Copyright © 2017年 Lee. All rights reserved.
//
#define KRowHeight 30.0f
#define KMaxShowLine 3
#define KFont [UIFont systemFontOfSize:13.0f]
#define KBackColor [UIColor whiteColor]

#import "CustomDropDownBtn.h"
#import "CommonMethod.h"

@interface CustomDropDownBtn ()<UITableViewDelegate , UITableViewDataSource>

@property (nonatomic , strong) UIWindow * cover;
@property (nonatomic , strong) UITableView * tableView;
@property (nonatomic , weak) UIView * view;
@property (nonatomic , weak) UIButton * button;
@property (nonatomic , copy , readwrite) NSString * selectedTitle;
@property (nonatomic , assign , readwrite) NSInteger selectedRow;

@end

@implementation CustomDropDownBtn

static NSString * cellId = @"cell";
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setup];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setup];
    }
    return self;
}
- (void)setup
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIButton * dropDownBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dropDownBtn.frame = self.bounds;
    [dropDownBtn addTarget:self action:@selector(butnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.button = dropDownBtn;
    [self addSubview:dropDownBtn];
    
    UIImageView * dropDownBtnImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"下拉菜单"]];
    dropDownBtnImage.frame = CGRectMake(43 * myDelegate.autoSizeScaleX,( dropDownBtn.frame.size.height - 9 * myDelegate.autoSizeScaleY ) / 2, 15 * myDelegate.autoSizeScaleX, 9 * myDelegate.autoSizeScaleY);
    [dropDownBtn addSubview:dropDownBtnImage];
    
    _tableView = [[UITableView alloc] init];
    _tableView.rowHeight = KRowHeight;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.layer.borderWidth = 1.0f;
    _tableView.layer.borderColor = [[CommonMethod getUsualColorWithString:@"#a0a0a0"] CGColor];
    _tableView.layer.cornerRadius = 1;
    _tableView.clipsToBounds = YES;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    self.showPlaceholder = YES;
}

- (void)butnClick:(UIButton *)btn
{
    [self createControl];
    [self endEditing];
}
- (void)createControl
{
    //遮盖window
    _cover = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _cover.windowLevel = UIWindowLevelAlert;
    _cover.hidden = NO;
    
    //window视图
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_cover addSubview:view];
    self.view = view;
    
    //遮盖视图
    UIView *backview = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    backview.backgroundColor = [UIColor colorWithRed:(0)/255.0 green:(0)/255.0 blue:(0)/255.0 alpha:0.0f];
    [backview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Tap:)]];
    [self.view addSubview:backview];
    
    //坐标转换
    CGRect frame = [self.superview convertRect:self.frame toView:self.view];
    
    //显示选项按钮
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, self.frame.size.width, self.frame.size.height)];
    [button addTarget:self action:@selector(btnOnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    
    
    
    //设置tableviewFrame
    NSInteger rowCount = KMaxShowLine;
    CGFloat tabelViewY = CGRectGetMaxY(frame);
    if (_array.count <= rowCount) {
        _tableView.frame = CGRectMake(frame.origin.x, tabelViewY, frame.size.width, _array.count * KRowHeight);
    }else {
        _tableView.frame = CGRectMake(frame.origin.x, tabelViewY, frame.size.width, rowCount * KRowHeight);
    }
    
    [self.view addSubview:_tableView];
}
- (void)endEditing
{
    [[[self findViewController] view] endEditing:YES];
}

- (UIViewController *)findViewController
{
    id target = self;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return target;
}
- (void)setShowPlaceholder:(BOOL)showPlaceholder
{
    _showPlaceholder = showPlaceholder;
    
    [self setInfo];
}
- (void)setInfo
{
    if (!_showPlaceholder && _array.count > 0) {
        [_button setSelected:YES];
        _selectedTitle = _array[0];
        [_button setTitle:_selectedTitle forState:UIControlStateNormal];
    }
    
    [_tableView reloadData];
}
- (void)btnOnClick
{
    [self dismissOptionAlert];
}

- (void)Tap:(UITapGestureRecognizer *)recognizer
{
    [self dismissOptionAlert];
}

- (void)dismissOptionAlert
{
    
    
    if (self.view.frame.origin.y == 0) {
        [self removeCover];
    }
}

- (void)removeCover
{
    
    _cover.hidden = YES;
    _cover = nil;
}

#pragma mark - UISearchBarDelegate


#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = _array[indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.font = KFont;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    
//    UILabel * reTextLabel = [cell viewWithTag:30000];
//    [reTextLabel removeFromSuperview];
//    NSLog(@"==%f",cell.frame.size.height);
//    UILabel * textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width , 30.0f)];
//    if (indexPath.row == 0)
//    {
//        textLabel.backgroundColor = [UIColor redColor];
//    }
//    else if (indexPath.row == 1)
//    {
//        textLabel.backgroundColor = [UIColor yellowColor];
//    }
//    else
//    {
//        textLabel.backgroundColor = [UIColor purpleColor];
//    }
//        
//    textLabel.tag = 30000;
//    textLabel.text = _array[indexPath.row];
//    textLabel.font = KFont;
//    textLabel.textAlignment = NSTextAlignmentCenter;
//    [cell addSubview:textLabel];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [CommonMethod getUsualColorWithString:@"#fabe76"];
    cell.textLabel.textColor = [UIColor whiteColor];
    _selectedRow = indexPath.row;
    [_button setSelected:YES];
    self.selectedTitle = _array[_selectedRow];
    [self dismissOptionAlert];
    
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectedOptionInCustomDropDownBtn:)]) {
        [_delegate didSelectedOptionInCustomDropDownBtn:self];
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textColor = [UIColor blackColor];
}

@end
