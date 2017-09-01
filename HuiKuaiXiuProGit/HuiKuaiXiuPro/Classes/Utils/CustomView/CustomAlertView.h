//
//  CustomAlertView.h
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/6/30.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 取消按钮点击事件
 */
typedef void(^cancelBlock) ();


/**
 确定按钮点击事件
 */
typedef void(^sureBlock) ();


@interface CustomAlertView : UIView

@property (nonatomic ,copy) cancelBlock cancel_block;
@property (nonatomic ,copy) sureBlock   sure_block;

/**
 自定义提示框

 @param title 标题
 @param content 内容
 @param cancel 取消按钮内容
 @param sure 确定按钮内容
 @param cancelBlock 取消按钮点击事件
 @param sureBlock 确定按钮点击事件
 @param height 提示框高度
 @return CustomAlertView
 */
+ (instancetype)alertViewWithTitle:(NSString *)title
                           content:(NSString *)content
                            cancel:(NSString *)cancel
                              sure:(NSString *)sure
                    cancelBtnClick:(cancelBlock)cancelBlock
                      sureBtnClick:(sureBlock)sureBlock
                   WithAlertHeight:(float)height;
@end
