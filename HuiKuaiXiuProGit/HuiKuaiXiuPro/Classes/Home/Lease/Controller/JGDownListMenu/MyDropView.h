//
//  MyDropView.h
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/7/26.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MyDownListMenuDelegate1 <NSObject>

/**
 *  代理
 */
-(void)dropDownListParame1:(NSString *)aStr;

@end

@interface MyDropView : UIView


/**
 *  下拉列表
 *  @param array       数据源
 *  @param listFrame   尺寸
 *  @param rowHeight   行高
 *  @param v           控制器>>>可根据需求修改
 */
-(id)initWithFrame1:(CGRect)listFrame
    ListDataSource1:(NSArray *)array
         rowHeight1:(CGFloat)rowHeight
              view1:(UIView *)v;




/**
 *  设置代理
 */
@property(nonatomic,assign)id<MyDownListMenuDelegate1>delegate;

/**
 *   显示下拉列表
 */
-(void)showList1;
/**
 *   隐藏
 */
-(void)hiddenList1;
@end
