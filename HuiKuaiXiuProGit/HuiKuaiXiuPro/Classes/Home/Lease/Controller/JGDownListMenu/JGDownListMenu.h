//
//  JGDownListMenu.h
//  JGDownListMenu
//
//  Created by 郭军 on 2017/3/18.
//  Copyright © 2017年 ZJNY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DownListMenuDelegate <NSObject>

/**
 *  代理
 */
-(void)dropDownListParame:(NSString *)aStr;

@end

@interface JGDownListMenu : UIView


/**
 *  下拉列表
 *  @param array       数据源
 *  @param listFrame   尺寸
 *  @param rowHeight   行高
 *  @param v           控制器>>>可根据需求修改
 */
-(id)initWithFrame:(CGRect)listFrame
    ListDataSource:(NSArray *)array
         rowHeight:(CGFloat)rowHeight
              view:(UIView *)v;




/**
 *  设置代理
 */
@property(nonatomic,assign)id<DownListMenuDelegate>delegate;

@property(nonatomic ,copy)NSString * mark;

/**
 *   显示下拉列表
 */
-(void)showList;
/**
 *   隐藏
 */
-(void)hiddenList;


@end
