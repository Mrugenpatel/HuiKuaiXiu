/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import <UIKit/UIKit.h>

@interface UIViewController (HUD)

- (void)showHudInView:(UIView *)view hint:(NSString *)hint;

- (void)hideHud;

- (void)showHint:(NSString *)hint;

- (void)showHintWithLines:(NSString *)hint;


/** 显示内容 ?秒后消失 */
- (void)showHint:(NSString *)hint AfterDelaySeconds :(NSUInteger)delaySeconds;

// 从默认(showHint:)显示的位置再往上(下)yOffset
- (void)showHint:(NSString *)hint yOffset:(float)yOffset;

- (void)hideHud:(NSUInteger) delaySeconds;
- (void)showHudInViewOnlyText:(UIView *)view hint:(NSString *)hint;

/** 从父类视图移除 */

- (void)removeFromSuperViewOnHide;
@end
