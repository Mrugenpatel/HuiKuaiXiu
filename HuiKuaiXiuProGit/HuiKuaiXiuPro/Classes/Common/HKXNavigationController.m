//
//  HKXNavigationController.m
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/8/22.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXNavigationController.h"

@interface HKXNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation HKXNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.interactivePopGestureRecognizer.delegate = self;
}
 -(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
     // 如果viewController不是最早push进来的子控制器
     // 这么去思考，返回按钮是属于上一个控制器的，点击返回按钮，回到上一个控制器嘛
     // 返回按钮不是属于当前显示的控制器的
     // 所以设置返回按钮的控制器就是从第1个子控制器开始的，也就是下面的>0的判断写法
     if (self.childViewControllers.count > 0) {
   
    UIButton* backButton = ({
     UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //hy:这里需要设置按钮的image，根据需求不需要设置title
    [backButton setImage:[UIImage imageNamed:@"back-arrow"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"back-arrow"] forState:UIControlStateHighlighted];
    [backButton setTitle:@"" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [backButton sizeToFit];// 图片自动适应按钮大小
     //hy:然后这里设置按钮的内边距的偏移量 (上，左，下，右) 需要按照需求去改改 40
     backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
      [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
      backButton;
      });
 // 将上面这个自定义的按钮设置到导航控制器的返回按钮上
      viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
 // 隐藏底部的工具条
      viewController.hidesBottomBarWhenPushed = YES;
  }
 // 上面设置搞定后，再push控制器显示出来
[super pushViewController:viewController animated:YES];
 }
 #pragma mark - <UIGestureRecognizerDelegate>
 /**
    56  * 手势识别对象会调用这个代理方法来决定手势是否有效
    57  *
    58  * @return YES : 手势有效， NO : 手势无效
    59 */
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
        // 当前，导航控制器的子控制器有2个以上的时候，手势有效。 62
    return self.childViewControllers.count > 1;
}
 #pragma mark - 按钮监听的方法
 // 导航控制器返回按钮监听的方法
-(void)back{
    
  [self popViewControllerAnimated:YES];
    
 }
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
