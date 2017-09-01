//
//  CustomAlertView.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/6/30.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "CustomAlertView.h"
#import "CommonMethod.h"

@implementation CustomAlertView
{
    UILabel  * _titleLabel;//标题
    UILabel  * _contentLabel;//内容
    UIButton * _cancelBtn;//取消按钮
    UIButton * _sureBtn;//确定按钮
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self = [super initWithFrame:frame];
    if (self)
    {
//        标题
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 31 * myDelegate.autoSizeScaleY, self.frame.size.width, 17 * myDelegate.autoSizeScaleX)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];
        _titleLabel.textColor = [CommonMethod getUsualColorWithString:@"#333333"];
        [self addSubview:_titleLabel];
        
//        内容
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleLabel.frame) + 17 * myDelegate.autoSizeScaleY, self.frame.size.width, 14 * myDelegate.autoSizeScaleX)];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.font = [UIFont systemFontOfSize:14 * myDelegate.autoSizeScaleX];
        _contentLabel.textColor = [CommonMethod getUsualColorWithString:@"#666666"];
        _contentLabel.numberOfLines = 0;
        [self addSubview:_contentLabel];
//        取消按钮
        _cancelBtn=[[UIButton alloc]initWithFrame:CGRectMake(13 * myDelegate.autoSizeScaleX, CGRectGetMaxY(_contentLabel.frame) + 29 * myDelegate.autoSizeScaleY, 190 / 2 * myDelegate.autoSizeScaleX, 44 * myDelegate.autoSizeScaleY)];
        _cancelBtn.backgroundColor=[UIColor colorWithRed:219 / 255.0 green:98 / 255.0 blue:21 / 255.0 alpha:1];
        _cancelBtn.layer.cornerRadius = 3 * myDelegate.autoSizeScaleX;
        _cancelBtn.clipsToBounds = YES;
        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelBtClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelBtn];
        //确定按钮
        _sureBtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_cancelBtn.frame) + 44 * myDelegate.autoSizeScaleX, CGRectGetMaxY(_contentLabel.frame) + 29 * myDelegate.autoSizeScaleY, 190 / 2 * myDelegate.autoSizeScaleX, 44 * myDelegate.autoSizeScaleY)];
        _sureBtn.backgroundColor=[CommonMethod getUsualColorWithString:@"#ffa304"];
        _sureBtn.layer.cornerRadius = 3 * myDelegate.autoSizeScaleX;
        _sureBtn.clipsToBounds = YES;
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureBtClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_sureBtn];
    }
    return self;
}

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
                   WithAlertHeight:(float)height
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    CustomAlertView * alertView = [[CustomAlertView alloc] initWithFrame:CGRectMake(0, 0, 260 * myDelegate.autoSizeScaleX, height)];
    alertView.backgroundColor = [UIColor whiteColor];
    alertView.center = CGPointMake(ScreenWidth / 2, ScreenHeight/2);
    alertView.layer.cornerRadius = 5;
    alertView.layer.masksToBounds = YES;
    alertView.title = title;
    alertView.content = content;
    alertView.cancel = cancel;
    alertView.sure = sure;
    alertView.cancel_block=cancelBlock;
    alertView.sure_block=sureBlock;
    
    
    return alertView;
}

#pragma mark--给属性重新赋值
-(void)setTitle:(NSString *)title
{
    _titleLabel.text=title;
}
-(void)setContent:(NSString *)content
{
    _contentLabel.text=content;
}
-(void)setSure:(NSString *)sure
{
    [_sureBtn setTitle:sure forState:UIControlStateNormal];
}
-(void)setCancel:(NSString *)cancel
{
    [_cancelBtn setTitle:cancel forState:UIControlStateNormal];
}
#pragma mark----取消按钮点击事件
-(void)cancelBtClick
{
    [self removeFromSuperview];
    self.cancel_block();
}
#pragma mark----确定按钮点击事件
-(void)sureBtClick
{
    [self removeFromSuperview];
    self.sure_block();
}
@end
