//
//  HKXSeverCollectionViewCell.h
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/8/25.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HKXSeverCollectionViewCell;

@protocol HKXCollectionCellDelegate <NSObject>

-(void)moveImageBtnClick:(HKXSeverCollectionViewCell *)aCell;

@end

@interface HKXSeverCollectionViewCell : UICollectionViewCell

@property(nonatomic ,strong)UIImageView *imgView;
@property(nonatomic ,strong)UILabel *text;
@property(nonatomic ,strong)UIButton *btn;
@property(nonatomic,strong)UIButton * close;
@property(nonatomic,assign)id<HKXCollectionCellDelegate>delegate;


@end
