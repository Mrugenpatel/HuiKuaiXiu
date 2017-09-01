//
//  HKXHomePageViewController.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/6/29.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXHomePageViewController.h"
#import "CommonMethod.h"
#import "HKXOrderReceivingViewController.h"
@interface HKXHomePageViewController ()<UIScrollViewDelegate , UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout>
{
    UIScrollView     * _bottomBigScrollView;//底层上下滑动视图
    UIScrollView     * _landscapeTopScrollView;//上层横向滑动视图
    UISearchBar      * _searchBar;//上层搜索栏
    UIPageControl    * _pageControl;
    NSTimer          * _timer;
    
    
    int                _speed;
    int                _page;
}
@property (nonatomic , strong) NSMutableArray * scrollNewArray;//滑动视图数组
@property (nonatomic , strong) NSMutableArray * collectionZonesArray;//特惠专区&推荐专区数组

@end

@implementation HKXHomePageViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoNotification:) name:@"userInfoNotification" object:nil];
    [self createUI];
}

-(void)userInfoNotification:(NSNotification*)notification{
    
    NSDictionary *dict = [notification userInfo];
    NSString *type=[dict valueForKey:@"repair"];
    if ([type isEqualToString:@"103"]) {
        
        [self.tabBarController setSelectedIndex:2];
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self configData];

}
#pragma mark - CreateUI
- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
//    changeStatusBarColor
    UIView * statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    statusBarView.backgroundColor = [CommonMethod getUsualColorWithString:@"#ffa304"];
    [self.view addSubview:statusBarView];
    
    [self createBottomBigScrollView];
}
- (void)createBottomBigScrollView
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _bottomBigScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, ScreenHeight - 49.5 - 20)];
    _bottomBigScrollView.backgroundColor = [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1];
    _bottomBigScrollView.contentSize = CGSizeMake(ScreenWidth, (388 + 280 + 948) / 2 * myDelegate.autoSizeScaleY);
    
    _bottomBigScrollView.pagingEnabled = NO;
    _bottomBigScrollView.bounces = NO;
    _bottomBigScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_bottomBigScrollView];
    
    [self createLandscapeTopScrollView];
    [self createRegisterButtonsAndRecommendZones];
}

/**
 布局上层滑动视图
 */
- (void)createLandscapeTopScrollView
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _landscapeTopScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 374 / 2 * myDelegate.autoSizeScaleY)];
    _landscapeTopScrollView.backgroundColor = [UIColor whiteColor];
    _landscapeTopScrollView.contentSize = CGSizeMake(ScreenWidth * 4, 374 / 2 * myDelegate.autoSizeScaleY);
    
    _landscapeTopScrollView.pagingEnabled = YES;
    _landscapeTopScrollView.bounces = NO;
    _landscapeTopScrollView.showsHorizontalScrollIndicator = NO;
    _landscapeTopScrollView.delegate = self;
    [_bottomBigScrollView addSubview:_landscapeTopScrollView];
    
    for (int i = 0; i < 4; i ++)
    {
        UIImageView * demoImage = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth * i, 0, ScreenWidth, 374 / 2 * myDelegate.autoSizeScaleY)];
        demoImage.image = [UIImage imageNamed:@"滑动视图示例"];
        
        [self.scrollNewArray addObject:demoImage];
        demoImage.userInteractionEnabled = YES;
        
        [_landscapeTopScrollView addSubview:demoImage];
    }
    
//    添加定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
//    添加pageControl
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.center = CGPointMake(ScreenWidth / 2,  170);
    _pageControl.bounds = CGRectMake(0, 0, 100, 80);
    _pageControl.numberOfPages = self.scrollNewArray.count;
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [_pageControl addTarget:self action:@selector(changeImageSlide) forControlEvents:UIControlEventValueChanged];
    [_bottomBigScrollView addSubview:_pageControl];
}

/**
 布局注册按钮群和特惠专区以及推荐专区
 */
- (void)createRegisterButtonsAndRecommendZones
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
//    注册按钮群
    NSArray * registerButtonTitleArray = [NSArray arrayWithObjects:@"机主加盟",@"服务维修加盟",@"供应商加盟", nil];
    UIView * registerBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_landscapeTopScrollView.frame) + 7 * myDelegate.autoSizeScaleY, ScreenWidth, 130 * myDelegate.autoSizeScaleY)];
    registerBottomView.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i < registerButtonTitleArray.count; i ++)
    {
        UIButton * registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        registerBtn.frame = CGRectMake(7 * myDelegate.autoSizeScaleX + (234 + 14) / 2 * i * myDelegate.autoSizeScaleX, 5 * myDelegate.autoSizeScaleY, 234 / 2 * myDelegate.autoSizeScaleX, 190 / 2 * myDelegate.autoSizeScaleY);
        [registerBtn setImage:[UIImage imageNamed:registerButtonTitleArray[i]] forState:UIControlStateNormal];
        [registerBottomView addSubview:registerBtn];
        
        UILabel * registerBtnTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(7 * myDelegate.autoSizeScaleX + (234 + 14) / 2 * i * myDelegate.autoSizeScaleX, CGRectGetMaxY(registerBtn.frame) + 9 * myDelegate.autoSizeScaleY, 234 / 2 * myDelegate.autoSizeScaleX, 12 * myDelegate.autoSizeScaleX )];
        registerBtnTitleLabel.textAlignment = NSTextAlignmentCenter;
        registerBtnTitleLabel.font = [UIFont systemFontOfSize:12 * myDelegate.autoSizeScaleX];
        registerBtnTitleLabel.text = registerButtonTitleArray[i];
        [registerBottomView addSubview:registerBtnTitleLabel];
    }
    [_bottomBigScrollView addSubview:registerBottomView];
    
//    特惠专区&推荐专区
    NSArray * collectionTitleArray = [NSArray arrayWithObjects:@"特惠专区",@"推荐专区", nil];
    
    UICollectionViewFlowLayout * flowLayOut = [[UICollectionViewFlowLayout alloc] init];
    for (int i = 0; i < collectionTitleArray.count; i ++)
    {
        UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(registerBottomView.frame) + 10 * myDelegate.autoSizeScaleY + i * (60 + 400 + 14) * myDelegate.autoSizeScaleY / 2, ScreenWidth, (60 + 400) / 2 * myDelegate.autoSizeScaleY) collectionViewLayout:flowLayOut];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [_bottomBigScrollView addSubview:collectionView];
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        
        [self.collectionZonesArray addObject:collectionView];
    }
}

#pragma mark - ConfigData
- (void)configData
{
    _speed = 1;
    _page  = 0;
    

}
#pragma mark - Action
/**
 定时器
 */
- (void)onTimer
{
    _pageControl.currentPage = _pageControl.currentPage + _speed;
    [_landscapeTopScrollView setContentOffset:CGPointMake(_pageControl.currentPage * ScreenWidth, 0) animated:YES];
    if (_pageControl.currentPage == 0)
    {
        _speed = 1;
    }
    else if (_pageControl.currentPage == self.scrollNewArray.count - 1)
    {
        _speed = -1;
    }
}

/**
 滑动视图滑动
 */
- (void)changeImageSlide
{
    [_landscapeTopScrollView setContentOffset:CGPointMake(ScreenWidth * _pageControl.currentPage, 0) animated:YES];
}
#pragma mark - Private Method


#pragma mark - Delegate & Data Source

/**
 UIScrollViewDelegate

 @param scrollView _landscapeTopScrollView
 */
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _landscapeTopScrollView)
    {
        _pageControl.currentPage =_landscapeTopScrollView.contentOffset.x / ScreenWidth;
        if (_pageControl.currentPage == 0)
        {
            _speed = 1;
        }
        else if(_pageControl.currentPage == self.scrollNewArray.count - 1)
        {
            _speed = -1;
        }
    }
}

/**
 将要开始拖拽时销毁定时器

 @param scrollView _landscapeTopScrollView
 */
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (_timer != nil  && scrollView == _landscapeTopScrollView)
    {
        [_timer invalidate];
        _timer=nil;
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_timer == nil && scrollView == _landscapeTopScrollView)
    {
        _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}
#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return CGSizeMake(ScreenWidth / 2 , 100 * myDelegate.autoSizeScaleY);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    return CGSizeMake(ScreenWidth, 30 * myDelegate.autoSizeScaleY);
}
#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate * myDelagate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UICollectionReusableView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    NSArray * collectionTitleColorArray = [NSArray arrayWithObjects:@"#f8931d",@"#333333", nil];
    NSArray * collectionTitleArray = [NSArray arrayWithObjects:@"特惠专区",@"推荐专区", nil];
        
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, headerView.frame.size.width, headerView.frame.size.height)];
    
    if (collectionView == self.collectionZonesArray[0])
    {
        headerLabel.text = collectionTitleArray[0];
        headerLabel.textColor = [CommonMethod getUsualColorWithString:collectionTitleColorArray[0]];
    }
    else
    {
        headerLabel.text = collectionTitleArray[1];
        headerLabel.textColor = [CommonMethod getUsualColorWithString:collectionTitleColorArray[1]];
    }
    
    headerLabel.font = [UIFont boldSystemFontOfSize:15 * myDelagate.autoSizeScaleX];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:headerLabel];
    
    return headerView;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    static NSString * cellIdentifier = @"cell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.layer.borderColor = [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1].CGColor;
    cell.layer.borderWidth = 0.5;
    
    UILabel * reBrandLabel = [cell viewWithTag:589];
    [reBrandLabel removeFromSuperview];
    UILabel * reSpecLabel = [cell viewWithTag:588];
    [reSpecLabel removeFromSuperview];
    UILabel * rePriceLabel = [cell viewWithTag:587];
    [rePriceLabel removeFromSuperview];
    UIImageView * reDemoImage = [cell viewWithTag:586];
    [reDemoImage removeFromSuperview];
    
    float brandLabelWidth = cell.frame.size.width - 3 * myDelegate.autoSizeScaleX - 170 / 2 * myDelegate.autoSizeScaleX;
    UILabel * brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10 * myDelegate.autoSizeScaleY, brandLabelWidth, 11 * myDelegate.autoSizeScaleX)];
    brandLabel.tag = 589;
    brandLabel.textAlignment = NSTextAlignmentCenter;
    brandLabel.text = @"慧快修";
    brandLabel.font = [UIFont boldSystemFontOfSize:11 * myDelegate.autoSizeScaleX];
    [cell addSubview:brandLabel];
    
    UILabel * specLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(brandLabel.frame) + 2 * myDelegate.autoSizeScaleY, brandLabelWidth, 11 * myDelegate.autoSizeScaleY)];
    specLabel.tag = 588;
    specLabel.textAlignment = NSTextAlignmentCenter;
    specLabel.text = @"高性能发动机油";
    specLabel.font = [UIFont boldSystemFontOfSize:11 * myDelegate.autoSizeScaleX];
    [cell addSubview:specLabel];
    
    UILabel * priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(specLabel.frame) + 13 * myDelegate.autoSizeScaleY, brandLabelWidth, 12 * myDelegate.autoSizeScaleX)];
    priceLabel.tag = 587;
    priceLabel.textAlignment = NSTextAlignmentCenter;
    priceLabel.textColor = [CommonMethod getUsualColorWithString:@"#fc0101"];
    priceLabel.text = @"惊爆价 ¥55";
    priceLabel.font = [UIFont systemFontOfSize:12 * myDelegate.autoSizeScaleX];
    [cell addSubview:priceLabel];
    
    UIImageView * demoImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(brandLabel.frame), 3 * myDelegate.autoSizeScaleY, 170 / 2 * myDelegate.autoSizeScaleX, 188 / 2 * myDelegate.autoSizeScaleY)];
    demoImage.backgroundColor = [CommonMethod getUsualColorWithString:@"#ffa304"];
    demoImage.tag = 586;
    [cell addSubview:demoImage];
    
    return cell;
}
#pragma mark - Setters & Getters
- (NSMutableArray *)scrollNewArray
{
    if (!_scrollNewArray)
    {
        _scrollNewArray = [NSMutableArray array];
    }
    return _scrollNewArray;
}
- (NSMutableArray *)collectionZonesArray
{
    if (!_collectionZonesArray)
    {
        _collectionZonesArray = [NSMutableArray array];
    }
    return _collectionZonesArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
