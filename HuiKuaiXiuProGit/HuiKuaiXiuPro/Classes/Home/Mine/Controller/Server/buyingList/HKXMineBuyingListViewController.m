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
#import "HKXMinePayViewController.h"//支付
#import "goodsPartDetailViewController.h"//配件详情
#import "HKXOrderStoreModel.h"
#import "HKXOrderGoodsModel.h"
#import "PartGoodsModel.h"
#import "UIImageView+WebCache.h"
@interface HKXMineBuyingListViewController ()<UICollectionViewDelegate , UICollectionViewDataSource>
{
    UICollectionView * _buyingCollectionView;//买入订单
    int page;
}

@property(nonatomic ,strong)NSMutableArray *storeArr;
@property(nonatomic ,strong)NSMutableArray *goodsArr;
@end

@implementation HKXMineBuyingListViewController
#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    [_buyingCollectionView.mj_header beginRefreshing];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (NSMutableArray *)storeArr{
    
    if (!_storeArr) {
        
        _storeArr = [NSMutableArray array];
    }
    return _storeArr;
}
- (NSMutableArray *)goodsArr{
    
    if (!_goodsArr) {
        
        _goodsArr = [NSMutableArray array];
    }
    return _goodsArr;
}
#pragma mark - CreateUI
- (void)createUI
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout * flowLayOut = [[UICollectionViewFlowLayout alloc] init];
    flowLayOut.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _buyingCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0 ,ScreenWidth, ScreenHeight  - 20 * myDelegate.autoSizeScaleY) collectionViewLayout:flowLayOut];
    _buyingCollectionView.backgroundColor = [UIColor whiteColor];
    _buyingCollectionView.delegate = self;
    _buyingCollectionView.dataSource = self;
    _buyingCollectionView.contentInset = UIEdgeInsetsMake(7 * myDelegate.autoSizeScaleY, 0, 0, 0);
    [self.view addSubview:_buyingCollectionView];
    
    [_buyingCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [_buyingCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [_buyingCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    
    _buyingCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(configData)];
    
    
    _buyingCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
}
#pragma mark - ConfigData
- (void)configData
{
    page = 2;
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
        [_buyingCollectionView.mj_header endRefreshing];
        if ([dicts[@"success"] boolValue] == YES) {
            
            self.storeArr = [HKXOrderStoreModel modelWithArray:dicts[@"data"]];
            [_buyingCollectionView reloadData];
            
        }else{
            
            [self showHint:dicts[@"message"]];
        }
        
    } failure:^(NSError *error) {
        
        [_buyingCollectionView.mj_header endRefreshing];
        NSLog(@"请求失败%@",error);
        [self.view hideActivity];
    
    }];
 
}

- (void)loadData{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    double uId = [defaults doubleForKey:@"userDataId"];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithDouble:uId],@"uId",[NSString stringWithFormat:@"%d",page],@"pageNo",
                           @"8",@"pageSize",
                           nil];
    [self.view showActivity];
    
    [IWHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"userOrder/selectBuy.do"] params:dict success:^(id responseObject) {
        
        NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"请求成功%@",dicts);
        [self.view hideActivity];
        [_buyingCollectionView.mj_footer endRefreshing];
        if ([dicts[@"success"] boolValue] == YES) {
            
            NSMutableArray * tempArr = [[NSMutableArray alloc] init];
            tempArr = [HKXOrderStoreModel modelWithArray:dicts[@"data"]];
            if (tempArr.count != 0) {
                for (int i = 0; i < tempArr.count; i ++) {
                    
                    [self.storeArr addObject:tempArr[i]];
                }
                [_buyingCollectionView reloadData];
                page++;
            }else{
                
            [self showHint:dicts[@"message"]];
            }

        }else{
            
            [self showHint:dicts[@"message"]];
        }
        
    } failure:^(NSError *error) {
        
        [_buyingCollectionView.mj_footer endRefreshing];
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
//设置区脚大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
   
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    HKXOrderStoreModel * store = self.storeArr[section];
    //卖家待发货
    if ([[NSString stringWithFormat:@"%@",store.orderStatus] isEqualToString:@"10"]){
        
    return CGSizeMake(0, 0);
        
    }else{
        
    return CGSizeMake(ScreenWidth, 45 * myDelegate.autoSizeScaleY);
        
    }
}

#pragma mark UICollectionViewDataSource
//返回collectionView的区个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.storeArr.count;
}
//返回collectionView的item的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    HKXOrderStoreModel * store = self.storeArr[section];
    
    return store.goodsArr.count;
}
//设置区头（区脚）
- (UICollectionReusableView* )collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    HKXOrderStoreModel * store = self.storeArr[indexPath.section];
     UICollectionReusableView *reusableView = nil;
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
        storeNameLabel.text = store.companyName;
        storeNameLabel.font = [UIFont systemFontOfSize:14 * myDelegate.autoSizeScaleX];
        storeNameLabel.tag = 80001;
        [headerView addSubview:storeNameLabel];
        
        UIButton * deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.tag = 80002;
        deleteBtn.frame = CGRectMake(250 * myDelegate.autoSizeScaleX, 5 * myDelegate.autoSizeScaleY, [CommonMethod getLabelLengthWithString:@"卖家待发货gdgfdgdg" WithFont:14 * myDelegate.autoSizeScaleX], 20 * myDelegate.autoSizeScaleY);
        
        [deleteBtn setTitle:store.orderMessage forState:UIControlStateNormal];
        [deleteBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        [headerView addSubview:deleteBtn];
        
         reusableView = headerView;
    }else if([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        //在这设置区脚
        UICollectionReusableView * footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        footerView.tag = indexPath.section;
        UIButton * reDeleteBtn1 = [footerView viewWithTag:90006];
        [reDeleteBtn1 removeFromSuperview];
        UIButton * reDeleteBtn2 = [footerView viewWithTag:90007];
        [reDeleteBtn2 removeFromSuperview];
            //        防重用
        for (int i = 0; i < 2; i ++){
                
            UIButton * actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            actionBtn.frame = CGRectMake(138 * myDelegate.autoSizeScaleX + (127 * i) * myDelegate.autoSizeScaleX, 0, 100 * myDelegate.autoSizeScaleX, 40 * myDelegate.autoSizeScaleY);
            actionBtn.layer.cornerRadius = 2;
            actionBtn.clipsToBounds = YES;
            actionBtn.tag = 90006 + i;
            [actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            actionBtn.backgroundColor = [CommonMethod getUsualColorWithString:@"#d59423"];
            [actionBtn addTarget:self action:@selector(actionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            //卖家待发货
            if ([[NSString stringWithFormat:@"%@",store.orderStatus] isEqualToString:@"10"]){
                
                
                
            } //交易成功
            else if ([[NSString stringWithFormat:@"%@",store.orderStatus] isEqualToString:@"0"]){
                    
                    if (i == 0 ) {
                        
                        [actionBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                    }else{
                        
                        [actionBtn setTitle:@"再来一单" forState:UIControlStateNormal];
                    }
                    
                }//待付款
                else if ([[NSString stringWithFormat:@"%@",store.orderStatus] isEqualToString:@"11"]){
                    if (i == 0 ) {
                        
                        [actionBtn setTitle:@"取消订单" forState:UIControlStateNormal];
                    }else{
                        
                        [actionBtn setTitle:@"立即支付" forState:UIControlStateNormal];
                    }
                    
                }//卖家已发货
                else if ([[NSString stringWithFormat:@"%@",store.orderStatus] isEqualToString:@"2"]){
                    
                    if (i == 0 ) {
                        
                        [actionBtn setTitle:@"确认收货" forState:UIControlStateNormal];
                    }else{
                        
                        [actionBtn setTitle:@"再来一单" forState:UIControlStateNormal];
                    }
                    
                }//交易成功
                else if ([[NSString stringWithFormat:@"%@",store.orderStatus] isEqualToString:@"3"]){
                    
                    if (i == 0 ) {
                        
                        [actionBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                    }else{
                        
                        [actionBtn setTitle:@"再来一单" forState:UIControlStateNormal];
                    }
                }//已取消
                else if ([[NSString stringWithFormat:@"%@",store.orderStatus] isEqualToString:@"-1"]){
                    
                    if (i == 0 ) {
                        
                        actionBtn.hidden = YES;
                    }else{
                        
                        [actionBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                    }
                }
                [footerView addSubview:actionBtn];
                reusableView = footerView;
            }
 
        //}

    }
    
    return reusableView;
}

//设置每个item的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    static NSString* cellIdentifier = @"cell";
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    HKXOrderStoreModel * store = self.storeArr[indexPath.section];
    HKXOrderGoodsModel * goods = store.goodsArr[indexPath.row];
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
    [goodsImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kIMAGEURL,goods.goodPicture]] placeholderImage:[UIImage imageNamed:@"滑动视图示例"]];
    [CommonMethod scanBigImageWithImageView:goodsImg];
    [cell addSubview:goodsImg];
    
    UILabel * goodsNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodsImg.frame) + 18 * myDelegate.autoSizeScaleX, 10 * myDelegate.autoSizeScaleY, [CommonMethod getLabelLengthWithString:@"哈威V30D140液压泵哈威" WithFont:16 * myDelegate.autoSizeScaleX ], 40 * myDelegate.autoSizeScaleY)];
    goodsNameLabel.numberOfLines = 2;
    goodsNameLabel.tag = 90002;
    goodsNameLabel.text = goods.goodName;
    goodsNameLabel.font = [UIFont systemFontOfSize:16 * myDelegate.autoSizeScaleX];
    [cell addSubview:goodsNameLabel];
    
    UILabel * goodsTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodsImg.frame) + 18 * myDelegate.autoSizeScaleX, CGRectGetMaxY(goodsNameLabel.frame) + 9 * myDelegate.autoSizeScaleY, [CommonMethod getLabelLengthWithString:@"哈威V30D140液压泵哈威" WithFont:16 * myDelegate.autoSizeScaleX ], 14 * myDelegate.autoSizeScaleX)];
    goodsTypeLabel.tag = 90003;
    goodsTypeLabel.text = goods.goodModel;
    goodsTypeLabel.textColor = [CommonMethod getUsualColorWithString:@"#666666"];
    goodsTypeLabel.font = [UIFont systemFontOfSize:14 * myDelegate.autoSizeScaleX];
    [cell addSubview:goodsTypeLabel];
    
    UILabel * priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodsImg.frame) + 18 * myDelegate.autoSizeScaleX, CGRectGetMaxY(goodsTypeLabel.frame) + 13 * myDelegate.autoSizeScaleY, 110 * myDelegate.autoSizeScaleX, 15 * myDelegate.autoSizeScaleX)];
    priceLabel.tag = 90004;
    priceLabel.textColor = [UIColor redColor];
    priceLabel.text = [NSString stringWithFormat:@"¥%@",goods.goodPrice];
    priceLabel.font = [UIFont systemFontOfSize:15 * myDelegate.autoSizeScaleX];
    [cell addSubview:priceLabel];
    
    UILabel * goodsNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodsImg.frame) + 164 * myDelegate.autoSizeScaleX, 82 * myDelegate.autoSizeScaleY, [CommonMethod getLabelLengthWithString:@"数量：2" WithFont:14 * myDelegate.autoSizeScaleX], 14 * myDelegate.autoSizeScaleX)];
    goodsNumLabel.tag = 90005;
    goodsNumLabel.text = [NSString stringWithFormat:@"数量:%@",goods.buyNumber];
    goodsNumLabel.font = [UIFont systemFontOfSize:14 * myDelegate.autoSizeScaleX];
    [cell addSubview:goodsNumLabel];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld区 %ld个",indexPath.section,indexPath.row);
    HKXMineBuyingDetailViewController * buyingDetailVC = [[HKXMineBuyingDetailViewController alloc] init];
    buyingDetailVC.store = self.storeArr[indexPath.section];
    buyingDetailVC.navigationItem.title = @"订单详情";
    [self.navigationController pushViewController:buyingDetailVC animated:YES];
}

- (void)actionBtnClick:(UIButton *)actionBtn{
    
    
    UIView * view = [actionBtn superview];
    HKXOrderStoreModel * store = self.storeArr[view.tag];
    HKXOrderGoodsModel * goods = store.goodsArr[0];
    if (actionBtn.tag == 90006) {
       
        //交易成功
        if ([[NSString stringWithFormat:@"%@",store.orderStatus] isEqualToString:@"0"]){
            
            //删除订单
            [self delaeteOrderWithOrderId:store.orderId];
            
        }//待付款
        else if ([[NSString stringWithFormat:@"%@",store.orderStatus] isEqualToString:@"11"]){
            
            [self cancelOrderWithOrderId:store.orderId];
            
        }//卖家已发货
        else if ([[NSString stringWithFormat:@"%@",store.orderStatus] isEqualToString:@"2"]){
            
           //确认收货
            [self confirmTakeGoodsWithOrderId:store.orderId];
                       
        }//交易成功
        else if ([[NSString stringWithFormat:@"%@",store.orderStatus] isEqualToString:@"3"]){
            
            //删除订单
             [self delaeteOrderWithOrderId:store.orderId];
            
        }//已取消
        else if ([[NSString stringWithFormat:@"%@",store.orderStatus] isEqualToString:@"-1"]){
            
            
        
        }
        
    }else if(actionBtn.tag == 90007){
        
        //交易成功
        if ([[NSString stringWithFormat:@"%@",store.orderStatus] isEqualToString:@"0"]){
            
            //再来一单
            [self BuyGoodsAgainWithPId:goods.mId];
        }//待付款
        else if ([[NSString stringWithFormat:@"%@",store.orderStatus] isEqualToString:@"11"]){
            
            //支付
            HKXMinePayViewController * pay = [[HKXMinePayViewController alloc] init];
            pay.ruoId = store.orderId;
            pay.payCount =[NSString stringWithFormat:@"%@",store.cost];
            [self.navigationController pushViewController:pay animated:YES];
            
        }//卖家已发货
        else if ([[NSString stringWithFormat:@"%@",store.orderStatus] isEqualToString:@"2"]){
            
            //再来一单
            [self BuyGoodsAgainWithPId:goods.mId];
        }//交易成功
        else if ([[NSString stringWithFormat:@"%@",store.orderStatus] isEqualToString:@"3"]){
            
            //再来一单
            [self BuyGoodsAgainWithPId:goods.mId];
        }//已取消
        else if ([[NSString stringWithFormat:@"%@",store.orderStatus] isEqualToString:@"-1"]){
            
            //删除订单
            [self delaeteOrderWithOrderId:store.orderId];
            
        }

    }
   
    
}

- (void)cancelOrderWithOrderId:(NSString *)orderId{
    
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认取消订单?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithDouble:[orderId doubleValue]],@"orderId",
                               nil];
        [self.view showActivity];
        [IWHttpTool postWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"userOrder/buycallOrder.do"] params:dict success:^(id responseObject) {
            
            NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求成功%@",dicts);
            [self.view hideActivity];
            if ([dicts[@"success"] boolValue] == YES) {
                
                [self showHint:dicts[@"message"]];
                [_buyingCollectionView.mj_header beginRefreshing];
                
            }else{
                
                [self showHint:dicts[@"message"]];
            }
            
        } failure:^(NSError *error) {
            
            NSLog(@"请求失败%@",error);
            [self.view hideActivity];
            
        }];
 
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}
- (void)confirmTakeGoodsWithOrderId:(NSString *)orderId{
    
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认收货?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithDouble:[orderId doubleValue]],@"orderId",
                               nil];
        [self.view showActivity];
        [IWHttpTool postWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"userOrder/updateTakeGood.do"] params:dict success:^(id responseObject) {
            
            NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求成功%@",dicts);
            [self.view hideActivity];
            if ([dicts[@"success"] boolValue] == YES) {
                [self showHint:dicts[@"message"]];
                [_buyingCollectionView.mj_header beginRefreshing];
                
            }else{
                
                [self showHint:dicts[@"message"]];
            }
            
        } failure:^(NSError *error) {
            
            NSLog(@"请求失败%@",error);
            [self.view hideActivity];
            
        }];

        
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
    
}


- (void)delaeteOrderWithOrderId:(NSString *)orderId{
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认删除订单?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithDouble:[orderId doubleValue]],@"orderId",
                               nil];
        [self.view showActivity];
        [IWHttpTool postWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"userOrder/deleteOrder.do"] params:dict success:^(id responseObject) {
            
            NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求成功%@",dicts);
            [self.view hideActivity];
            if ([dicts[@"success"] boolValue] == YES) {
                
                [self showHint:dicts[@"message"]];
                [_buyingCollectionView.mj_header beginRefreshing];
                
            }else{
                
                [self showHint:dicts[@"message"]];
            }
            
        } failure:^(NSError *error) {
            
            NSLog(@"请求失败%@",error);
            [self.view hideActivity];
            
        }];

        
        
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
//再来一单
- (void)BuyGoodsAgainWithPId:(NSString *)pId{
    
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithInt:[pId intValue]],@"pId",
                           nil];
    [self.view showActivity];
    [IWHttpTool postWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"supplierbase/partdetail.do"] params:dict success:^(id responseObject) {
        
        NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"请求成功%@",dicts);
        [self.view hideActivity];
        if ([dicts[@"success"] boolValue] == YES) {
            
            goodsPartDetailViewController * partDetail = [[goodsPartDetailViewController alloc] init];
            partDetail.partModel = [[PartGoodsModel alloc] initWithDict:dicts[@"data"]];
            [self.navigationController pushViewController:partDetail animated:YES];
            
        }else{
            
            [self showHint:dicts[@"message"]];
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"请求失败%@",error);
        [self showHint:@"请求失败"];
        [self.view hideActivity];
        
    }];
    
    
    
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
