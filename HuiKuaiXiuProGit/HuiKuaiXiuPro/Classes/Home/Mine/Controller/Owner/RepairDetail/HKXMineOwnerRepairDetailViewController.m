//
//  HKXMineOwnerRepairDetailViewController.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/8/11.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXMineOwnerRepairDetailViewController.h"
#import "CommonMethod.h"

#import "HKXHttpRequestManager.h"
#import "HKXMineRepairDetailModelDataModels.h"

#import "UIImageView+WebCache.h"

@interface HKXMineOwnerRepairDetailViewController ()
{
    UIScrollView * _bottomScrollView;//底层滑动视图
    NSString     * _troubleDecribe;//故障描述
}

@property (nonatomic , strong) NSMutableArray * contentArray;
@property (nonatomic , strong) NSMutableArray * imageArray ;//故障图片数组

@end

@implementation HKXMineOwnerRepairDetailViewController

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self createUI];
    [self loadData];
}
#pragma mark - CreateUI
- (void)createUI
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.view.backgroundColor = [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1];
    
    _bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 10 * myDelegate.autoSizeScaleY + 60, ScreenWidth, ScreenHeight - 60 - 30 * myDelegate.autoSizeScaleY)];
    _bottomScrollView.backgroundColor = [UIColor whiteColor];
    _bottomScrollView.contentSize = CGSizeMake(ScreenWidth, (388 + 280 + 948) / 2 * myDelegate.autoSizeScaleY);
    
    _bottomScrollView.pagingEnabled = NO;
    _bottomScrollView.bounces = NO;
    _bottomScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_bottomScrollView];
    
    
    
}
- (void)loadDataView
{
    
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    for (int i = 0; i < self.contentArray.count; i ++)
    {
        float width ;
        
        width = ([CommonMethod getLabelLengthWithString:self.contentArray[i] WithFont:17 * myDelegate.autoSizeScaleX] >= [CommonMethod getLabelLengthWithString:@"十九字十八字十九字十九字十九字十九字十" WithFont:17 * myDelegate.autoSizeScaleX]) ? [CommonMethod getLabelLengthWithString:@"十九字十九字十九字十九字十九字十九字十" WithFont:17 * myDelegate.autoSizeScaleX] : [CommonMethod getLabelLengthWithString:self.contentArray[i] WithFont:17 * myDelegate.autoSizeScaleX];
        UILabel * contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(22 * myDelegate.autoSizeScaleX, 27 * myDelegate.autoSizeScaleY + (17 + 24) * i * myDelegate.autoSizeScaleY, width, 17 * myDelegate.autoSizeScaleY)];
        
        contentLabel.text = self.contentArray[i];

        contentLabel.textColor = [UIColor blackColor];
        contentLabel.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];
        [_bottomScrollView addSubview:contentLabel];
        
        if (i == 2)
        {
            UILabel * troubleDescribeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(contentLabel.frame), contentLabel.frame.origin.y - 14 * myDelegate.autoSizeScaleY, [CommonMethod getLabelLengthWithString:@"十四字十四字十四字十四字十四" WithFont:17 * myDelegate.autoSizeScaleX], 48 * myDelegate.autoSizeScaleX)];
            troubleDescribeLabel.text = _troubleDecribe;
            troubleDescribeLabel.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];
            troubleDescribeLabel.numberOfLines = 2;
            [_bottomScrollView addSubview:troubleDescribeLabel];
        }
        if (i == 3)
        {
            contentLabel.frame = CGRectMake(22 * myDelegate.autoSizeScaleX, 27 * myDelegate.autoSizeScaleY + (17 + 24) * i * myDelegate.autoSizeScaleY + 31 * myDelegate.autoSizeScaleY, [CommonMethod getLabelLengthWithString:self.contentArray[i] WithFont:17 * myDelegate.autoSizeScaleX], 17 * myDelegate.autoSizeScaleY);
            
            for (int j = 0; j < self.imageArray.count; j ++)
            {
                int X = j % 2;
                int Y = j / 2;
                UIImageView * troublePicImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(contentLabel.frame) + (17 + 100 * X) * myDelegate.autoSizeScaleX , CGRectGetMinY(contentLabel.frame) +  73 * Y * myDelegate.autoSizeScaleY, 97 * myDelegate.autoSizeScaleX, 64 * myDelegate.autoSizeScaleY)];
                
                [troublePicImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kIMAGEURL,self.imageArray[j]]] placeholderImage:[UIImage imageNamed:@"滑动视图示例"]];
                [_bottomScrollView addSubview:troublePicImage];
            }
            
            
        }
        if (i >= 4)
        {
            contentLabel.frame = CGRectMake(22 * myDelegate.autoSizeScaleX, 27 * myDelegate.autoSizeScaleY + (17 + 24) * i * myDelegate.autoSizeScaleY + (31 + 114) * myDelegate.autoSizeScaleY, [CommonMethod getLabelLengthWithString:@"十四字十四字十四字十四字十四" WithFont:17 * myDelegate.autoSizeScaleX], 17 * myDelegate.autoSizeScaleY);
        }
    }
}
#pragma mark - ConfigData
- (void)loadData
{
    _troubleDecribe = [[NSString alloc] init];
    if (self.isOwner == true)
    {
        [HKXHttpRequestManager sendRequestWithRuoId:self.repairId ToGetOwnerRepairDetailResult:^(id data) {
            HKXMineRepairDetailModel * model = data;
            if (model.success)
            {
                HKXMineRepairDetailData * data = model.data;
                self.contentArray = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"维修设备：%@",data.brandModel],[NSString stringWithFormat:@"故障类型：%@",data.fault],@"故障描述：",@"故障图片",[NSString stringWithFormat:@"电话：%@",data.telephone],[NSString stringWithFormat:@"地址：%@",data.address],[NSString stringWithFormat:@"工时费：¥%.2f",data.hourCost],[NSString stringWithFormat:@"配件及附料：¥%.2f",data.partsCost],[NSString stringWithFormat:@"总计：¥%.2f",data.cost],[NSString stringWithFormat:@"维修师傅：%@",data.repairName],[NSString stringWithFormat:@"电话：%@",data.repairPhone], nil];
                
                self.imageArray = (NSMutableArray *)data.picture;
                _troubleDecribe = data.faultInfo;
                
                [self loadDataView];
            }
        }];
    }
    else
    {
        NSString * repairStatus = [[NSString alloc] init];
        if (self.orderData.repairStatus == 5)
        {
            repairStatus = @"等待机主付款";
        }
        if (self.orderData.repairStatus == 0)
        {
            repairStatus = @"已完成";
        }
        self.contentArray = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"维修设备：%@",self.orderData.brandModel],[NSString stringWithFormat:@"维修设备：%@",self.orderData.fault],@"故障描述：",@"故障图片",[NSString stringWithFormat:@"电话：%@",self.orderData.telephone],[NSString stringWithFormat:@"地址：%@",self.orderData.address],[NSString stringWithFormat:@"工时费：¥%.2f",self.orderData.hourCost],[NSString stringWithFormat:@"配件及附料：¥%.2f",self.orderData.partsCost],[NSString stringWithFormat:@"总计：¥%.2f",self.orderData.cost],repairStatus, nil];
        
        self.imageArray = (NSMutableArray *)self.orderData.picture;
        _troubleDecribe = self.orderData.faultInfo;
        
        [self loadDataView];
    }
 
}
#pragma mark - Action
#pragma mark - Private Method
#pragma mark - Delegate & Data Source
#pragma mark - Setters & Getters
- (NSMutableArray *)contentArray
{
    if (!_contentArray)
    {
        _contentArray = [NSMutableArray array];
    }
    return _contentArray;
}
- (NSMutableArray *)imageArray
{
    if (!_imageArray)
    {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
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
