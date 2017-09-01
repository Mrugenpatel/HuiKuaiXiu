//
//  HKXMineBuyingListViewController.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/8/25.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXMineBuyingListViewController.h"
#import "CommonMethod.h"

#import "HKXMineBuyingDetailViewController.h"//订单详情

@interface HKXMineBuyingListViewController ()<UICollectionViewDelegate , UICollectionViewDataSource>
{
    UICollectionView * _buyingCollectionView;//买入订单
}

@end

@implementation HKXMineBuyingListViewController
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
    
    UICollectionViewFlowLayout * flowLayOut = [[UICollectionViewFlowLayout alloc] init];
    flowLayOut.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _buyingCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0 , ScreenWidth, ScreenHeight  - 20 * myDelegate.autoSizeScaleY) collectionViewLayout:flowLayOut];
    _buyingCollectionView.backgroundColor = [UIColor whiteColor];
    _buyingCollectionView.delegate = self;
    _buyingCollectionView.dataSource = self;
    _buyingCollectionView.contentInset = UIEdgeInsetsMake(7 * myDelegate.autoSizeScaleY, 0, 0, 0);
    [self.view addSubview:_buyingCollectionView];
    
    [_buyingCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [_buyingCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    
}
#pragma mark - ConfigData
- (void)configData
{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    double uId = [defaults doubleForKey:@"userDataId"];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithDouble:uId],@"uId",@"1",@"pageNo",
                           @"8",@"pageSize",
                           nil];
    [self.view showActivity];
    [IWHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"userOrder/selectBuy.do"] params:dict success:^(id responseObject) {
        
        NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"请求成功%@",dicts);
        [self.view hideActivity];
        if ([dicts[@"success"] boolValue] == YES) {
            
            
            
            
        }else{
            
            [self showHint:dicts[@"message"]];
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"请求失败%@",error);
        [self.view hideActivity];
    
    }];

    
    
}
#pragma mark - Action
#pragma mark - Private Method
#pragma mark - Delegate & Data Source
#pragma mark UICollectionViewDelegateFlowLayout
//设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (indexPath.section % 3 == 0)
    {
        return CGSizeMake(ScreenWidth, 125 * myDelegate.autoSizeScaleY);
    }
    else
    {
        return CGSizeMake(ScreenWidth, 185 * myDelegate.autoSizeScaleY);
    }
}
//设置整个区的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
//设置每一行之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
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
    return 6;
}
//返回collectionView的item的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}
//设置区头（区脚）
- (UICollectionReusableView* )collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        //在这设置区头
        UICollectionReusableView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        
        //        防重用
        
        UIButton * reDeleteBtn = [headerView viewWithTag:80002];
        [reDeleteBtn removeFromSuperview];
        UILabel * reStoreNameLabel = [headerView viewWithTag:80001];
        [reStoreNameLabel removeFromSuperview];
        
        headerView.backgroundColor = [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1];
        
        
        
        UILabel * storeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(17 * myDelegate.autoSizeScaleX, 9 * myDelegate.autoSizeScaleY, [CommonMethod getLabelLengthWithString:@"凝碧液压店铺" WithFont:14 * myDelegate.autoSizeScaleX], 14 * myDelegate.autoSizeScaleX)];
        storeNameLabel.text = @"凝碧液压店铺";
        storeNameLabel.font = [UIFont systemFontOfSize:14 * myDelegate.autoSizeScaleX];
        storeNameLabel.tag = 80001;
        [headerView addSubview:storeNameLabel];
        
        UIButton * deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.tag = 80002;
        deleteBtn.frame = CGRectMake(250 * myDelegate.autoSizeScaleX, 5 * myDelegate.autoSizeScaleY, [CommonMethod getLabelLengthWithString:@"卖家待发货gdgfdgdg" WithFont:14 * myDelegate.autoSizeScaleX], 20 * myDelegate.autoSizeScaleY);
        if (indexPath.section % 3 == 0)
        {
            [deleteBtn setTitle:@"卖家待发货" forState:UIControlStateNormal];
        }
        else
        {
            [deleteBtn setTitle:@"卖家已发货" forState:UIControlStateNormal];
        }
        [deleteBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
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
    
    
    
    
    UIImageView * reGoodsImage = [cell viewWithTag:90001];
    [reGoodsImage removeFromSuperview];
    UILabel * reGoodsNameLabel = [cell viewWithTag:90002];
    [reGoodsNameLabel removeFromSuperview];
    UILabel * reGoodsTypeLabel = [cell viewWithTag:90003];
    [reGoodsTypeLabel removeFromSuperview];
    UILabel * rePriceLabel = [cell viewWithTag:90004];
    [rePriceLabel removeFromSuperview];
    UILabel * reGoodsNumLabel = [cell viewWithTag:90005];
    [reGoodsNumLabel removeFromSuperview];
    for (int i = 90006; i < 90008; i ++)
    {
        UIButton * reActionBtn = [cell viewWithTag:i];
        [reActionBtn removeFromSuperview];
    }
    
    
    
    UIImageView * goodsImg = [[UIImageView alloc] initWithFrame:CGRectMake(30 *myDelegate.autoSizeScaleX, 10 * myDelegate.autoSizeScaleY, 102 * myDelegate.autoSizeScaleX, 95 * myDelegate.autoSizeScaleY)];
    goodsImg.tag = 90001;
    goodsImg.image = [UIImage imageNamed:@"滑动视图示例"];
    [cell addSubview:goodsImg];
    
    UILabel * goodsNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodsImg.frame) + 18 * myDelegate.autoSizeScaleX, 10 * myDelegate.autoSizeScaleY, [CommonMethod getLabelLengthWithString:@"哈威V30D140液压泵哈威" WithFont:16 * myDelegate.autoSizeScaleX ], 40 * myDelegate.autoSizeScaleY)];
    goodsNameLabel.numberOfLines = 2;
    goodsNameLabel.tag = 90002;
    goodsNameLabel.text = @"哈威V30D140液压泵哈威V30D140液压泵";
    goodsNameLabel.font = [UIFont systemFontOfSize:16 * myDelegate.autoSizeScaleX];
    [cell addSubview:goodsNameLabel];
    
    UILabel * goodsTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodsImg.frame) + 18 * myDelegate.autoSizeScaleX, CGRectGetMaxY(goodsNameLabel.frame) + 9 * myDelegate.autoSizeScaleY, [CommonMethod getLabelLengthWithString:@"哈威V30D140液压泵哈威" WithFont:16 * myDelegate.autoSizeScaleX ], 14 * myDelegate.autoSizeScaleX)];
    goodsTypeLabel.tag = 90003;
    goodsTypeLabel.text = @"产品型号：XXXXXXX";
    goodsTypeLabel.textColor = [CommonMethod getUsualColorWithString:@"#666666"];
    goodsTypeLabel.font = [UIFont systemFontOfSize:14 * myDelegate.autoSizeScaleX];
    [cell addSubview:goodsTypeLabel];
    
    UILabel * priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodsImg.frame) + 18 * myDelegate.autoSizeScaleX, CGRectGetMaxY(goodsTypeLabel.frame) + 13 * myDelegate.autoSizeScaleY, 110 * myDelegate.autoSizeScaleX, 15 * myDelegate.autoSizeScaleX)];
    priceLabel.tag = 90004;
    priceLabel.textColor = [UIColor redColor];
    priceLabel.text = [NSString stringWithFormat:@"¥%.2f",1200.00];
    priceLabel.font = [UIFont systemFontOfSize:15 * myDelegate.autoSizeScaleX];
    [cell addSubview:priceLabel];
    
    UILabel * goodsNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodsImg.frame) + 164 * myDelegate.autoSizeScaleX, 82 * myDelegate.autoSizeScaleY, [CommonMethod getLabelLengthWithString:@"数量：2" WithFont:14 * myDelegate.autoSizeScaleX], 14 * myDelegate.autoSizeScaleX)];
    goodsNumLabel.tag = 90005;
    goodsNumLabel.text = @"数量：2";
    goodsNumLabel.font = [UIFont systemFontOfSize:14 * myDelegate.autoSizeScaleX];
    [cell addSubview:goodsNumLabel];
    
    if (indexPath.section % 3 != 0)
    {
        for (int i = 0; i < 2; i ++)
        {
            UIButton * actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            actionBtn.frame = CGRectMake(138 * myDelegate.autoSizeScaleX + (127 * i) * myDelegate.autoSizeScaleX, 125 * myDelegate.autoSizeScaleY, 100 * myDelegate.autoSizeScaleX, 40 * myDelegate.autoSizeScaleY);
            actionBtn.layer.cornerRadius = 2;
            actionBtn.clipsToBounds = YES;
            actionBtn.tag = 90006 + i;
//            [actionBtn setBackgroundColor:[UIColor redColor]];
            if (i == 1)
            {
                [actionBtn setTitle:@"再来一单" forState:UIControlStateNormal];
                [actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                actionBtn.backgroundColor = [CommonMethod getUsualColorWithString:@"#ffa304"];
            }
            else
            {
                if (indexPath.section % 3 == 1)
                {
                    
                    [actionBtn setTitle:@"确认收货" forState:UIControlStateNormal];
                    [actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    actionBtn.backgroundColor = [CommonMethod getUsualColorWithString:@"#d59423"];
                }
                else
                {
                    if (indexPath.section % 3 == 2)
                    {
                        
                        [actionBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                        [actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        actionBtn.backgroundColor = [UIColor redColor];
                    }
                }
            }
//
            [cell addSubview:actionBtn];
        }
    }
    
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld区 %ld个",indexPath.section,indexPath.row);
    HKXMineBuyingDetailViewController * buyingDetailVC = [[HKXMineBuyingDetailViewController alloc] init];
    buyingDetailVC.navigationItem.title = @"订单详情";
    [self.navigationController pushViewController:buyingDetailVC animated:YES];
}
#pragma mark - Setters & Getters

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
