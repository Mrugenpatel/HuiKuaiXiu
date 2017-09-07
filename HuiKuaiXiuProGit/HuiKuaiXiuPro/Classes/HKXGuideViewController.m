//
//  HKXGuideViewController.m
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/8/14.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXGuideViewController.h"

#import "ViewController.h"

@interface HKXGuideViewController ()<UIScrollViewDelegate>{
    
    UIPageControl * pageControl;
    
    
}

@end

@implementation HKXGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
    
}



- (void)createUI{
    
    
    
    NSArray * imageNames = @[@"引导页1",@"引导页2"];
    
    UIScrollView *myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    for (int i = 0; i < 2; i ++) {
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth * i, 0, ScreenWidth, ScreenHeight)];
        
        imageView.image = [UIImage imageNamed:imageNames[i]];
        
        if (i == 1) {
            imageView.backgroundColor = [UIColor whiteColor];
            imageView.userInteractionEnabled = YES;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.frame = CGRectMake(ScreenWidth / 3, ScreenHeight * 7 / 8, ScreenWidth / 3, ScreenHeight / 16);
            [button setTitle:@"点击进入" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.layer.borderWidth = 2;
            button.layer.cornerRadius = 5;
            button.clipsToBounds = YES;
            button.layer.borderColor = [UIColor whiteColor].CGColor;
            [button addTarget:self action:@selector(goAPP:) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:button];
            
        }
        imageView.backgroundColor = [UIColor blueColor];
        [myScrollView addSubview:imageView];
    }
    
    myScrollView.bounces = NO;
    myScrollView.pagingEnabled = YES;
    myScrollView.showsHorizontalScrollIndicator = NO;
    myScrollView.contentSize = CGSizeMake(ScreenWidth * 2, ScreenHeight);
    myScrollView.delegate = self;
    [self.view addSubview:myScrollView];
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(ScreenWidth / 3, ScreenHeight * 15 / 16, ScreenWidth / 3, ScreenHeight / 16)];
    
    pageControl.numberOfPages = 2;
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    
    [self.view addSubview:pageControl];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 计算当前在第几页
    pageControl.currentPage = (NSInteger)(scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width);
    
}


- (void)goAPP:(UIButton *)btn {
    
    NSUserDefaults *useDef = [NSUserDefaults standardUserDefaults];
    // 保存用户数据
    [useDef setBool:YES forKey:@"isFirst"];
    [useDef synchronize];
    // 切换根视图控制器
    self.view.window.rootViewController = [[ViewController alloc] init];
    
   
    
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
