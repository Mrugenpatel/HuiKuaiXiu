//
//  HKXMineShoppingCartViewController.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/8/24.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXMineShoppingCartViewController.h"
#import "CommonMethod.h"

#import "HKXMineShoppingGoodsDetailViewController.h"//订单详情界面

#import "HKXHttpRequestManager.h"
#import "HKXMineShoppingCartListModelDataModels.h"//购物车列表
#import "HKXMineShoppingCartUpdateCartNumberModelDataModels.h"//更新购物车商品数量

#import "UIImageView+WebCache.h"

@interface HKXMineShoppingCartViewController ()<UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout>
{
    UICollectionView * _shoppingCartCollectionView;//购物车
    UIView           * _totalPriceView;//总价view
}


@property (nonatomic , strong) NSMutableArray * allGoodsStautsArray;//所有商品数组
@property (nonatomic , strong) NSMutableArray * allStoreStatusArray;//所有商铺数组
@property (nonatomic , strong) NSMutableArray * storeBtnArray;//商铺选中按钮数组
@property (nonatomic , strong) NSMutableArray * goodsBtnArray;//商品选中按钮数组
@property (nonatomic , strong) NSMutableArray * selectedGoodsArray;//选中商品数组
@property (nonatomic , strong) NSMutableArray * stepperArray;//数量加减器数组

@end

@implementation HKXMineShoppingCartViewController

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self configData];
}
#pragma mark - CreateUI
- (void)createUI
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"000000");
    
    UICollectionViewFlowLayout * flowLayOut = [[UICollectionViewFlowLayout alloc] init];
    flowLayOut.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _shoppingCartCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0 , ScreenWidth, ScreenHeight  - 50 * myDelegate.autoSizeScaleY) collectionViewLayout:flowLayOut];
    _shoppingCartCollectionView.backgroundColor = [UIColor whiteColor];
    _shoppingCartCollectionView.delegate = self;
    _shoppingCartCollectionView.dataSource = self;
    _shoppingCartCollectionView.contentInset = UIEdgeInsetsMake(7 * myDelegate.autoSizeScaleY, 0, 0, 0);
    [self.view addSubview:_shoppingCartCollectionView];
    
    [_shoppingCartCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [_shoppingCartCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    _totalPriceView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_shoppingCartCollectionView.frame) + 1 * myDelegate.autoSizeScaleY, ScreenWidth, 49 * myDelegate.autoSizeScaleY)];
    _totalPriceView.layer.borderColor = [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1].CGColor;
    _totalPriceView.layer.borderWidth = 1;
    _totalPriceView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_totalPriceView];
    
    UIButton * selectAllBtn = [[UIButton alloc] initWithFrame:CGRectMake(10 * myDelegate.autoSizeScaleX, 19 * myDelegate.autoSizeScaleY, 12 * myDelegate.autoSizeScaleX, 12 * myDelegate.autoSizeScaleX)];
    selectAllBtn.tag = 40000;
    [selectAllBtn addTarget:self action:@selector(selectAllGoodsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [selectAllBtn setImage:[UIImage imageNamed:@"复选框-未选中"] forState:UIControlStateNormal];
    [selectAllBtn setImage:[UIImage imageNamed:@"复选框_已选择"] forState:UIControlStateSelected];
    selectAllBtn.selected = NO;
    [_totalPriceView addSubview:selectAllBtn];
    
    UILabel * allSelectLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(selectAllBtn.frame) + 10 * myDelegate.autoSizeScaleX, 19 * myDelegate.autoSizeScaleY, [CommonMethod getLabelLengthWithString:@"全选" WithFont:14 * myDelegate.autoSizeScaleX], 14 * myDelegate.autoSizeScaleX)];
    allSelectLabel.text = @"全选";
    allSelectLabel.font = [UIFont systemFontOfSize:14 * myDelegate.autoSizeScaleX];
    allSelectLabel.textColor = [CommonMethod getUsualColorWithString:@"#333333"];
    [_totalPriceView addSubview:allSelectLabel];
    
    NSString * totalPrice = [NSString stringWithFormat:@"合计：¥%.1f",1220.0];
    UILabel * totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(allSelectLabel.frame) + 91 * myDelegate.autoSizeScaleX, 8 * myDelegate.autoSizeScaleY, [CommonMethod getLabelLengthWithString:totalPrice WithFont:15 * myDelegate.autoSizeScaleX], 15 * myDelegate.autoSizeScaleX)];
    totalPriceLabel.textColor = [CommonMethod getUsualColorWithString:@"#333333"];
    totalPriceLabel.text = totalPrice;
    totalPriceLabel.font = [UIFont systemFontOfSize:15 * myDelegate.autoSizeScaleX];
    [_totalPriceView addSubview:totalPriceLabel];
    
    UILabel * transportFeiLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(allSelectLabel.frame) + 91 * myDelegate.autoSizeScaleX, CGRectGetMaxY(totalPriceLabel.frame) + 9 * myDelegate.autoSizeScaleY, [CommonMethod getLabelLengthWithString:@"不含运费" WithFont:13 * myDelegate.autoSizeScaleX], 13 * myDelegate.autoSizeScaleX)];
    transportFeiLabel.text = @"不含运费";
    transportFeiLabel.font = [UIFont systemFontOfSize:13 * myDelegate.autoSizeScaleX];
    transportFeiLabel.textColor = [CommonMethod getUsualColorWithString:@"#666666"];
    [_totalPriceView addSubview:transportFeiLabel];
    
    UIButton * submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(280 * myDelegate.autoSizeScaleX, 0, ScreenWidth - 280 * myDelegate.autoSizeScaleX, 50 * myDelegate.autoSizeScaleY);
    submitBtn.backgroundColor = [CommonMethod getUsualColorWithString:@"#ffa304"];
    [submitBtn setTitle:@"结算" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_totalPriceView addSubview:submitBtn];
}
#pragma mark - ConfigData
- (void)configData
{
    long userId = [[NSUserDefaults standardUserDefaults] doubleForKey:@"userDataId"];
    [HKXHttpRequestManager sendRequestWithUserId:[NSString stringWithFormat:@"%ld",userId] ToGetAllMineShoppingCartListResult:^(id data) {
        HKXMineShoppingCartListModel * model = data;
        if (model.success)
        {
            for (int i = 0; i < model.data.count; i++ )
            {
                HKXMineShoppingCartListData * storeModel = model.data[i];
                [self.allStoreStatusArray addObject:storeModel];
                
                NSMutableArray * storeArray = [NSMutableArray array];
                for (HKXMineShoppingCartListShopcartList * goodsModel in storeModel.shopcartList)
                {
                    [storeArray addObject:goodsModel];
                }
                [self.allGoodsStautsArray addObject:storeArray];
                
                NSMutableArray * eachGoodsBtnArray = [NSMutableArray array];
                [self.goodsBtnArray addObject:eachGoodsBtnArray];
                
                NSMutableArray * eachStepperArray = [NSMutableArray array];
                [self.stepperArray addObject:eachStepperArray];
            }
            [_shoppingCartCollectionView reloadData];
        }
        else
        {
            [self showHint:model.message];
        }
    }];
    
}
#pragma mark - Action

/**
 结算选中商品

 @param btn 结算按钮
 */
- (void)submitBtnClick:(UIButton *)btn
{
    
    HKXMineShoppingGoodsDetailViewController * detailVC = [[HKXMineShoppingGoodsDetailViewController alloc] init];
    detailVC.navigationItem.title = @"确认订单";
    [self.navigationController pushViewController:detailVC animated:YES];
}
/**
 点击全选按钮选中购物车中所有商品

 @param btn 全选按钮
 */
- (void)selectAllGoodsBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    NSLog(@"选中所有商品");
    if (btn.selected == YES)
    {
//        改变商铺按钮选中状态
        for (HKXMineShoppingCartListData * storeData in self.allStoreStatusArray)
        {
            storeData.isSelected = YES;
        }
//        改变商品选中状态
        for (NSMutableArray * arr in self.allGoodsStautsArray)
        {
            for (HKXMineShoppingCartListShopcartList * goodsModel in arr)
            {
                goodsModel.isSelected = YES;
            }
        }
    }
    else
    {
        //        改变商铺按钮选中状态
        for (HKXMineShoppingCartListData * storeData in self.allStoreStatusArray)
        {
            storeData.isSelected = NO;
        }
        //        改变商品选中状态
        for (NSMutableArray * arr in self.allGoodsStautsArray)
        {
            for (HKXMineShoppingCartListShopcartList * goodsModel in arr)
            {
                goodsModel.isSelected = NO;
            }
        }
    }
    [_shoppingCartCollectionView reloadData];
}

/**
 选中该店铺所有商品或者删除所有商品

 @param btn btn
 */
- (void)selectThisStoreAllGoodsBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.tag == 80000)
    {
        NSLog(@"选中该店铺所有商品");
        if (btn.selected == YES)
        {
            NSInteger index = [self.storeBtnArray indexOfObject:btn];
            NSMutableArray * goodsStatusArray = self.allGoodsStautsArray[index];
            
            for (HKXMineShoppingCartListShopcartList * goodsModel in goodsStatusArray)
            {
                goodsModel.isSelected = YES;
            }
        }
        else
        {
            NSInteger index = [self.storeBtnArray indexOfObject:btn];
            NSMutableArray * goodsStatusArray = self.allGoodsStautsArray[index];
            
            for (HKXMineShoppingCartListShopcartList * goodsModel in goodsStatusArray)
            {
                goodsModel.isSelected = NO;
            }
        }
        
    }
    if (btn.tag == 80002)
    {
        NSLog(@"删除该店铺所有商品");
    }
    [_shoppingCartCollectionView reloadData];
}

/**
 点击按钮选中该商品

 @param btn btn
 */
- (void)selectGoodsBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    HKXMineShoppingCartListData * storeData = self.allStoreStatusArray[btn.tag - 50000];
    
    for (HKXMineShoppingCartListShopcartList * goodsModel in self.allGoodsStautsArray[btn.tag - 50000])
    {
        if ([self.selectedGoodsArray containsObject:goodsModel] == YES)
        {
            storeData.isSelected = YES;
        }
    }
    [_shoppingCartCollectionView reloadData];
}

/**
 数量选择器

 @param stepper 数量选择器
 */
- (void)stepperAction:(UIStepper *)stepper
{
    NSLog(@"----%ld",(long)stepper.value);
    NSMutableArray * eachStepperArray = self.stepperArray[stepper.tag - 70005];
    NSInteger index = [eachStepperArray indexOfObject:stepper];
    NSMutableArray * eachGoodsArray = self.allGoodsStautsArray[stepper.tag - 70005];
    HKXMineShoppingCartListShopcartList * goodsModel = eachGoodsArray[index];
    [HKXHttpRequestManager sendRequestWithCartId:[NSString stringWithFormat:@"%ld",(long)goodsModel.carid] WithBuyNumber:[NSString stringWithFormat:@"%ld",(long)stepper.value] ToGetUpdateShoppingCartNumberResult:^(id data) {
        HKXMineShoppingCartUpdateCartNumberModel * model = data;
        if (model.success)
        {
            [eachGoodsArray replaceObjectAtIndex:index withObject:model];
            NSLog(@"%@",model);
        }
    }];
    [_shoppingCartCollectionView reloadData];
}
#pragma mark - Private Method
#pragma mark - Delegate & Data Source
#pragma mark UICollectionViewDelegateFlowLayout
//设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return CGSizeMake(ScreenWidth, 125 * myDelegate.autoSizeScaleY);
}
//设置整个区的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
//设置每一行之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.1;
}
//设置没一列的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.1;
}
//设置区头大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return CGSizeMake(ScreenWidth, 30 * myDelegate.autoSizeScaleY);
}
#pragma mark UICollectionViewDataSource
//返回collectionView的区个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.allStoreStatusArray.count;
}
//返回collectionView的item的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSMutableArray * goodsArray = self.allGoodsStautsArray[section];
    
    return goodsArray.count;
}
//设置区头（区脚）
- (UICollectionReusableView* )collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        //在这设置区头
        UICollectionReusableView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        
//        防重用
        UIButton * reSelectBtn = [headerView viewWithTag:80000];
        [reSelectBtn removeFromSuperview];
        UIButton * reDeleteBtn = [headerView viewWithTag:80002];
        [reDeleteBtn removeFromSuperview];
        UILabel * reStoreNameLabel = [headerView viewWithTag:80001];
        [reStoreNameLabel removeFromSuperview];
        
        headerView.backgroundColor = [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1];
        
        HKXMineShoppingCartListData * headerModel = self.allStoreStatusArray[indexPath.section];
        
        
        UIButton * storeSelectBtn = [[UIButton alloc] initWithFrame:CGRectMake(10 * myDelegate.autoSizeScaleX, 9 * myDelegate.autoSizeScaleY, 12 * myDelegate.autoSizeScaleX, 12 * myDelegate.autoSizeScaleX)];
        
        storeSelectBtn.tag = 80000;
        [storeSelectBtn addTarget:self action:@selector(selectThisStoreAllGoodsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [storeSelectBtn setImage:[UIImage imageNamed:@"复选框-未选中"] forState:UIControlStateNormal];
        [storeSelectBtn setImage:[UIImage imageNamed:@"复选框_已选择"] forState:UIControlStateSelected];
        storeSelectBtn.selected = headerModel.isSelected;
        [self.storeBtnArray insertObject:storeSelectBtn atIndex:indexPath.section];
        [headerView addSubview:storeSelectBtn];
        
        UILabel * storeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(storeSelectBtn.frame) + 10 * myDelegate.autoSizeScaleX, 9 * myDelegate.autoSizeScaleY, [CommonMethod getLabelLengthWithString:headerModel.companyname WithFont:14 * myDelegate.autoSizeScaleX], 14 * myDelegate.autoSizeScaleX)];
        storeNameLabel.text = headerModel.companyname;
        storeNameLabel.font = [UIFont systemFontOfSize:14 * myDelegate.autoSizeScaleX];
        storeNameLabel.tag = 80001;
        [headerView addSubview:storeNameLabel];
        
        UIButton * deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.tag = 80002;
        deleteBtn.frame = CGRectMake(320 * myDelegate.autoSizeScaleX, 5 * myDelegate.autoSizeScaleY, 52 * myDelegate.autoSizeScaleX, 20 * myDelegate.autoSizeScaleY);
        [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(selectThisStoreAllGoodsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:deleteBtn];
        
        return headerView;
    }else if([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        //在这设置区脚
        return nil;
    }else
    {
        return nil;
    }
}

//设置每个item的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    static NSString* cellIdentifier = @"cell";
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSMutableArray * storeGoodsStatusArray = self.allGoodsStautsArray[indexPath.section];
    HKXMineShoppingCartListShopcartList * goodsModel = storeGoodsStatusArray[indexPath.row];
    if (goodsModel.isSelected == YES)
    {
        [self.selectedGoodsArray addObject:goodsModel];
    }
    
    NSMutableArray * eachStoreBtnArray = self.goodsBtnArray[indexPath.section];
    NSMutableArray * eachStepperArray = self.stepperArray[indexPath.section];
    
    for (int i = 50000; i < 50001 + indexPath.section; i ++)
    {
        UIButton * reSelectBtn = [cell viewWithTag:i];
        [reSelectBtn removeFromSuperview];
    }
    UIImageView * reGoodsImage = [cell viewWithTag:90001];
    [reGoodsImage removeFromSuperview];
    UILabel * reGoodsNameLabel = [cell viewWithTag:90002];
    [reGoodsNameLabel removeFromSuperview];
    UILabel * reGoodsTypeLabel = [cell viewWithTag:90003];
    [reGoodsTypeLabel removeFromSuperview];
    UILabel * rePriceLabel = [cell viewWithTag:90004];
    [rePriceLabel removeFromSuperview];
    for (int i = 70005; i < 70006 + indexPath.section; i ++)
    {
        UIStepper * reStepper = [cell viewWithTag:i];
        [reStepper removeFromSuperview];
    }
    
    UILabel * reGoodsNumLabel = [cell viewWithTag:90006];
    [reGoodsNumLabel removeFromSuperview];
    
    UIButton * selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(10 * myDelegate.autoSizeScaleX, 57 * myDelegate.autoSizeScaleY, 12 * myDelegate.autoSizeScaleX, 12 * myDelegate.autoSizeScaleX)];
    selectBtn.tag = 50000 + indexPath.section;
    [selectBtn addTarget:self action:@selector(selectGoodsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [selectBtn setImage:[UIImage imageNamed:@"复选框-未选中"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"复选框_已选择"] forState:UIControlStateSelected];
    selectBtn.selected = goodsModel.isSelected;
    [eachStoreBtnArray insertObject:selectBtn atIndex:indexPath.row];
    [cell addSubview:selectBtn];
    
    UIImageView * goodsImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(selectBtn.frame) + 8 *myDelegate.autoSizeScaleX, 10 * myDelegate.autoSizeScaleY, 102 * myDelegate.autoSizeScaleX, 95 * myDelegate.autoSizeScaleY)];
    goodsImg.tag = 90001;
//    goodsImg.image = [UIImage imageNamed:@"滑动视图示例"];
    [goodsImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kIMAGEURL,goodsModel.picture]] placeholderImage:[UIImage imageNamed:@"滑动视图示例"]];
    [cell addSubview:goodsImg];
    
    UILabel * goodsNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodsImg.frame) + 18 * myDelegate.autoSizeScaleX, 10 * myDelegate.autoSizeScaleY, [CommonMethod getLabelLengthWithString:@"哈威V30D140液压泵哈威" WithFont:16 * myDelegate.autoSizeScaleX ], 40 * myDelegate.autoSizeScaleY)];
    goodsNameLabel.numberOfLines = 2;
    goodsNameLabel.tag = 90002;
    goodsNameLabel.text = goodsModel.goodsname;
    goodsNameLabel.font = [UIFont systemFontOfSize:16 * myDelegate.autoSizeScaleX];
    [cell addSubview:goodsNameLabel];
    
    UILabel * goodsTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodsImg.frame) + 18 * myDelegate.autoSizeScaleX, CGRectGetMaxY(goodsNameLabel.frame) + 9 * myDelegate.autoSizeScaleY, [CommonMethod getLabelLengthWithString:@"哈威V30D140液压泵哈威" WithFont:16 * myDelegate.autoSizeScaleX ], 14 * myDelegate.autoSizeScaleX)];
    goodsTypeLabel.tag = 90003;
    goodsTypeLabel.text = goodsModel.model;
    goodsTypeLabel.textColor = [CommonMethod getUsualColorWithString:@"#666666"];
    goodsTypeLabel.font = [UIFont systemFontOfSize:14 * myDelegate.autoSizeScaleX];
    [cell addSubview:goodsTypeLabel];
    
    UILabel * priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodsImg.frame) + 18 * myDelegate.autoSizeScaleX, CGRectGetMaxY(goodsTypeLabel.frame) + 13 * myDelegate.autoSizeScaleY, 110 * myDelegate.autoSizeScaleX, 15 * myDelegate.autoSizeScaleX)];
    priceLabel.tag = 90004;
    priceLabel.textColor = [UIColor redColor];
    priceLabel.text = [NSString stringWithFormat:@"¥%.2f",goodsModel.totalprice];
    priceLabel.font = [UIFont systemFontOfSize:15 * myDelegate.autoSizeScaleX];
    [cell addSubview:priceLabel];
    
    UIStepper * stepper = [[UIStepper alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodsImg.frame) + 139 * myDelegate.autoSizeScaleX, 86 * myDelegate.autoSizeScaleY, 50 * myDelegate.autoSizeScaleX, 17 * myDelegate.autoSizeScaleY)];
    stepper.tag = 70005 + indexPath.section;
    stepper.value = 1;
    stepper.minimumValue = 1;
    stepper.maximumValue = 5;
    stepper.stepValue = 1;
    stepper.continuous = YES;
    stepper.wraps = YES;
    [eachStepperArray insertObject:stepper atIndex:indexPath.row];
    [stepper addTarget:self action:@selector(stepperAction:) forControlEvents:UIControlEventValueChanged];
    [cell addSubview:stepper];
    
    UILabel * goodsNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodsImg.frame) + 110 * myDelegate.autoSizeScaleX, CGRectGetMaxY(goodsTypeLabel.frame) + 13 * myDelegate.autoSizeScaleY, 110 * myDelegate.autoSizeScaleX, 15 * myDelegate.autoSizeScaleX)];
    goodsNumLabel.tag = 90006;
    goodsNumLabel.textColor = [UIColor blueColor];
    goodsNumLabel.text = [NSString stringWithFormat:@"X %d",goodsModel.buynumber];
    goodsNumLabel.font = [UIFont systemFontOfSize:15 * myDelegate.autoSizeScaleX];
    [cell addSubview:goodsNumLabel];
    
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld区 %ld个",indexPath.section,indexPath.row);
}
#pragma mark - Setters & Getters

- (NSMutableArray *)allGoodsStautsArray
{
    if (!_allGoodsStautsArray)
    {
        _allGoodsStautsArray = [NSMutableArray array];
    }
    return _allGoodsStautsArray;
}
- (NSMutableArray *)allStoreStatusArray
{
    if (!_allStoreStatusArray)
    {
        _allStoreStatusArray = [NSMutableArray array];
    }
    return _allStoreStatusArray;
}
- (NSMutableArray *)storeBtnArray
{
    if (!_storeBtnArray)
    {
        _storeBtnArray = [NSMutableArray array];
    }
    return _storeBtnArray;
}
- (NSMutableArray *)goodsBtnArray
{
    if (!_goodsBtnArray)
    {
        _goodsBtnArray = [NSMutableArray array];
    }
    return _goodsBtnArray;
}
- (NSMutableArray *)selectedGoodsArray
{
    if (!_selectedGoodsArray)
    {
        _selectedGoodsArray = [NSMutableArray array];
    }
    return _selectedGoodsArray;
}
- (NSMutableArray *)stepperArray
{
    if (_stepperArray)
    {
        _stepperArray = [NSMutableArray array];
    }
    return _stepperArray;
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
