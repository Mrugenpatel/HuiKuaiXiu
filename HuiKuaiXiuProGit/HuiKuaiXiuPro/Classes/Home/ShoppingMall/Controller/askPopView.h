//
//  askPopView.h
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/8/30.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol submitClickDelegate <NSObject>

- (void)submitClick;

@end

@interface askPopView : UIView
@property(nonatomic ,strong)UIView * bgView;//遮罩层

@property(nonatomic ,strong)UIView * showView;//展示层

@property(nonatomic ,strong)UILabel * brandLb;//型号
@property(nonatomic ,strong)UITextField * nameTf;//姓名
@property(nonatomic ,strong)UITextField * teleTf;//电话
@property(nonatomic ,strong)UITextField * addressTF;//地区
@property(nonatomic ,strong)UIButton * submitBtn;//提交
@property (nonatomic ,weak)id<submitClickDelegate>delegate;

@end
