//
//  HKXMineShoppingGoodsDetailViewController.h
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/8/24.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKXMineShoppingCartListModelDataModels.h"//购物车model

@interface HKXMineShoppingGoodsDetailViewController : UIViewController

@property (nonatomic , strong) NSMutableArray * selectGoodsArray;//选中商品数组
@property (nonatomic , copy) NSString * totalCount;//总金额

@end
