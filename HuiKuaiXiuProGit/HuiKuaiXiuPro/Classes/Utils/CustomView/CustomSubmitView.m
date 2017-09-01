//
//  CustomSubmitView.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/6/30.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "CustomSubmitView.h"
#import "CommonMethod.h"

@implementation CustomSubmitView
{
    UILabel  * _titleLabel;//标题
    UILabel  * _contentLabel;//内容
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
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.borderWidth = 1.f;
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
        [self addSubview:_contentLabel];

//       确定按钮
        _sureBtn=[[UIButton alloc]initWithFrame:CGRectMake(70 * myDelegate.autoSizeScaleX, CGRectGetMaxY(_contentLabel.frame) + 29 * myDelegate.autoSizeScaleY, 120 * myDelegate.autoSizeScaleX, 44 * myDelegate.autoSizeScaleY)];
        _sureBtn.backgroundColor = [CommonMethod getUsualColorWithString:@"#ffa304"];
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

 @param sure 确定按钮内容
 @param sureBlock 确定按钮点击事件
 @param height 提示框高度
 @return CustomAlertView
 */
+ (instancetype)alertViewWithTitle:(NSString *)title
                           content:(NSString *)content

                              sure:(NSString *)sure
                      sureBtnClick:(sureBlock)sureBlock
                   WithAlertHeight:(float)height
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    CustomSubmitView * alertView = [[CustomSubmitView alloc] initWithFrame:CGRectMake(0, 0, 260 * myDelegate.autoSizeScaleX, height)];
    alertView.backgroundColor = [UIColor whiteColor];
    alertView.center = CGPointMake(ScreenWidth / 2, ScreenHeight/2);
    alertView.layer.cornerRadius = 5;
    alertView.layer.masksToBounds = YES;
    alertView.title = title;
    alertView.content = content;
    alertView.sure = sure;
    alertView.sure_block = sureBlock;
    
    
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

#pragma mark----确定按钮点击事件
-(void)sureBtClick
{
    [self removeFromSuperview];
    self.sure_block();
}


@end
