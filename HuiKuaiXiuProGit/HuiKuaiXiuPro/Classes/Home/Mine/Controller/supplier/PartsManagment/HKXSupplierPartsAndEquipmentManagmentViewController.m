//
//  HKXSupplierPartsAndEquipmentManagmentViewController.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/7/12.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXSupplierPartsAndEquipmentManagmentViewController.h"
#import "CommonMethod.h"
#import "HKXSupplierReleasePartsViewController.h"
#import "HKXSupplierReleaseEquipmentViewController.h"

#import "HKXHttpRequestManager.h"
#import "HKXSupplierPartsManagementModelDataModels.h"
#import "HKXMineServeCertificateProfileModelDataModels.h"
#import "HKXSupplierEquipmentManagementModelDataModels.h"

#import "HKXSupplierReleasePartsModel.h"

#import "UIImageView+WebCache.h"

#import "CustomAlertView.h"

@interface HKXSupplierPartsAndEquipmentManagmentViewController ()<UITableViewDelegate , UITableViewDataSource  >

{
    UITableView * _bottomTableView;
    
}

@property (nonatomic , strong) NSMutableArray * infoArray;//所有设备/配件数组
@property (nonatomic , strong) HKXSupplierReleasePartsModel * partsModel;//配件model
@property (nonatomic , strong) NSMutableArray * selectArray;//被搜索出来的数组

@end

@implementation HKXSupplierPartsAndEquipmentManagmentViewController

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createUI];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}
#pragma mark - CreateUI
- (void)createUI
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.view.backgroundColor = [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1];
    
    UIView * searchBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 10 * myDelegate.autoSizeScaleY + 64, ScreenWidth  , 40 * myDelegate.autoSizeScaleY)];
    searchBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:searchBarView];
    
    
    
    _bottomTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 50 * myDelegate.autoSizeScaleY, ScreenWidth, ScreenHeight  - 50 * myDelegate.autoSizeScaleY - 64) style:UITableViewStylePlain];
    _bottomTableView.backgroundColor = [UIColor whiteColor];
    _bottomTableView.dataSource = self;
    _bottomTableView.delegate = self;
    [self.view addSubview:_bottomTableView];
}
#pragma mark - ConfigData
- (void)loadData
{
    long userId = [[NSUserDefaults standardUserDefaults] doubleForKey:@"userDataId"];
    [self.view showActivity];
    if (self.isParts)
    {
        [HKXHttpRequestManager sendRequestWithUserID:[NSString stringWithFormat:@"%ld",userId] WithPageNum:@"1" WithPageSize:@"7" ToGetCurrentReleasedPartsInfo:^(id data) {
            [self.view hideActivity];
            HKXSupplierPartsManagementModel * partsModel = data;
            
            for (HKXSupplierPartsManagementData * partsData in partsModel.data)
            {
                [self.infoArray addObject:partsData];
                [self.selectArray addObject:partsData];
            }
            [_bottomTableView reloadData];
        }];
    }
    else
    {
        [HKXHttpRequestManager sendRequestWithSupplierUserId:[NSString stringWithFormat:@"%ld",userId] WithPageNum:@"1" WithPageSize:@"7" ToGetSupplierAllEquipmentInfoResult:^(id data) {
            [self.view hideActivity];
            HKXSupplierEquipmentManagementModel * equipmentModel = data;
            
            for (HKXSupplierEquipmentManagementData * equipmentData in equipmentModel.data)
            {
                [self.infoArray addObject:equipmentData];
                [self.selectArray addObject:equipmentData];
            }
            
            [_bottomTableView reloadData];
        }];
    }
    
}
#pragma mark - Action
- (void)putawayOrSoldOutGoodsBtnClick:(UIButton *)btn
{
    NSInteger indexPath = btn.tag - 70000;
    
    if (btn.selected == NO)
    {
//        点击按钮上架,此时商品为下架状态
        btn.selected = YES;
        if (self.isParts)
        {
//            上架配件
            HKXSupplierPartsManagementData * data = self.infoArray[indexPath];
            
        }
        else
        {
//            上架设备
            HKXSupplierEquipmentManagementData * data = self.infoArray[indexPath];
        }
    }
    else
    {
//        点击按钮下架，此时商品为上架状态
        btn.selected = NO;
        if (self.isParts)
        {
            //            下架配件
            HKXSupplierPartsManagementData * data = self.infoArray[indexPath];
            
        }
        else
        {
            //            下架设备
            HKXSupplierEquipmentManagementData * data = self.infoArray[indexPath];
        }
    }
}
- (void)editOrDeleteBtnClick:(UIButton *)btn
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.hidesBottomBarWhenPushed = YES;
    if (btn.tag < 45000)
    {
        NSInteger indexPath = btn.tag - 35000;
//        编辑
        if (self.isParts)
        {
            HKXSupplierReleasePartsViewController * releasePartsVC = [[HKXSupplierReleasePartsViewController alloc] init];
            releasePartsVC.navigationItem.title = @"发布配件";
            HKXSupplierPartsManagementData * data = self.infoArray[indexPath];
            self.partsModel.pid = [NSString stringWithFormat:@"%d",data.pId];
            self.partsModel.mid = [NSString stringWithFormat:@"%ld",data.mId];
            self.partsModel.number = [NSString stringWithFormat:@"%ld",data.number];
            self.partsModel.brand = data.brand;
            self.partsModel.basename = data.basename;
            self.partsModel.model = data.model;
            self.partsModel.tempPrice = [NSString stringWithFormat:@"%f",data.price];
            self.partsModel.introduct = data.introduct;
            self.partsModel.picture = data.picture;
            self.partsModel.category = data.category;
            self.partsModel.applyCareModel = data.applyCareModel;
            self.partsModel.stock = [NSString stringWithFormat:@"%d",data.stock];
            releasePartsVC.partsInfoModel = self.partsModel;
            releasePartsVC.isEditable = YES;
            
            [self.navigationController pushViewController:releasePartsVC animated:YES];
        }
        else
        {
            HKXSupplierReleaseEquipmentViewController * releaseEquipmentVC = [[HKXSupplierReleaseEquipmentViewController alloc] init];
            releaseEquipmentVC.navigationItem.title = @"发布设备";
            releaseEquipmentVC.equipmentModel = self.infoArray[indexPath];
            releaseEquipmentVC.isEditable = YES;
            [self.navigationController pushViewController:releaseEquipmentVC animated:YES];
        }
    }
    else
    {
        NSInteger indexPath = btn.tag - 45000;
//        删除
        CustomAlertView * deleteAlertView = [CustomAlertView alertViewWithTitle:@"提示" content:@"确定删除此条信息吗？" cancel:@"取消" sure:@"删除" cancelBtnClick:^{
            [self tapGestureClick];
        } sureBtnClick:^{
            if (self.isParts)
            {
                HKXSupplierPartsManagementData * data = self.infoArray[indexPath];
                [HKXHttpRequestManager sendRequestWithSupplierPartsPid:[NSString stringWithFormat:@"%d",data.pId] ToGetDeleteResult:^(id data) {
                    HKXMineServeCertificateProfileModel * model = data;
                    if (model.success)
                    {
                        [self loadData];
                    }
                }];
            }
            else
            {
                HKXSupplierEquipmentManagementData * data = self.infoArray[indexPath];
                [HKXHttpRequestManager sendRequestWithSupplierEquipmentPid:[NSString stringWithFormat:@"%d",data.pmaId] ToGetDeleteEquipmentResult:^(id data) {
                    HKXMineServeCertificateProfileModel * model = data;
                    if (model.success)
                    {
                        [self loadData];
                    }
                }];
            }
        } WithAlertHeight:240 * myDelegate.autoSizeScaleY];
        
        deleteAlertView.tag = 502;
        [self.view addSubview:deleteAlertView];
        
    }
}
#pragma mark - Private Method
- (void)tapGestureClick
{
    for (UIView * view in self.view.subviews)
    {
        if (view.tag >= 500 && view.tag <= 507 )
        {
            [view removeFromSuperview];
        }
    }
}
#pragma mark - Delegate & Data Source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return 115 * myDelegate.autoSizeScaleY;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return self.selectArray.count;
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    static NSString * cellIdentifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    UIImageView * reLogoImage = [cell viewWithTag:3000];
    [reLogoImage removeFromSuperview];
    UILabel * reTitleLabel = [cell viewWithTag:3001];
    [reTitleLabel removeFromSuperview];
    UILabel * reLabelLabel = [cell viewWithTag:3002];
    [reLabelLabel removeFromSuperview];
    UILabel * reNumberLabel = [cell viewWithTag:3003];
    [reNumberLabel removeFromSuperview];
//TODO:此处待修改button的tag值
    UIButton * reEditBtn = [cell viewWithTag:3004];
    [reEditBtn removeFromSuperview];
    UIButton * reDeleteBtn = [cell viewWithTag:3005];
    [reDeleteBtn removeFromSuperview];
    
    for (int i = 70000 ; i < 70001 + indexPath.row; i ++)
    {
        UIButton * reUpBtn = [cell viewWithTag:i];
        [reUpBtn removeFromSuperview];
    }
    
    if (self.isParts)
    {
        HKXSupplierPartsManagementData * data = self.selectArray[indexPath.row];
        
        UIImageView * logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(17 * myDelegate.autoSizeScaleX, 10 * myDelegate.autoSizeScaleY, 102 * myDelegate.autoSizeScaleX, 95 * myDelegate.autoSizeScaleY)];
//        logoImageView.image = [UIImage imageNamed:@"滑动视图示例"];
        NSArray * picaArr = [data.picture componentsSeparatedByString:@"$"];
        [logoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kIMAGEURL,picaArr[0]]] placeholderImage:[UIImage imageNamed:@"滑动视图示例"]];
        logoImageView.tag = 3000;
        [cell addSubview:logoImageView];
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(logoImageView.frame) + 15 * myDelegate.autoSizeScaleX, 16 * myDelegate.autoSizeScaleY, 184 * myDelegate.autoSizeScaleX, 13 * myDelegate.autoSizeScaleX)];
        titleLabel.tag = 3001;
        titleLabel.font = [UIFont systemFontOfSize:13 * myDelegate.autoSizeScaleX];
//        titleLabel.text = @"慧快修 工程机械专用液压油";
        titleLabel.text = [NSString stringWithFormat:@"%@%@",data.basename,data.model];
        [cell addSubview:titleLabel];
        
        UILabel * labelLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(logoImageView.frame) + 15 * myDelegate.autoSizeScaleX, CGRectGetMaxY(titleLabel.frame) + 12 * myDelegate.autoSizeScaleY, 184 * myDelegate.autoSizeScaleX, 13 * myDelegate.autoSizeScaleX)];
        labelLabel.tag = 3002;
        labelLabel.font = [UIFont systemFontOfSize:13 * myDelegate.autoSizeScaleX];
//        labelLabel.text = @"壳牌";
        labelLabel.text = data.brand;
        [cell addSubview:labelLabel];
        
        UILabel * numeberLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(logoImageView.frame) + 15 * myDelegate.autoSizeScaleX,CGRectGetMaxY(labelLabel.frame) + 10 * myDelegate.autoSizeScaleY, 184 * myDelegate.autoSizeScaleX, 13 * myDelegate.autoSizeScaleX)];
        numeberLabel.tag = 3003;
        numeberLabel.font = [UIFont systemFontOfSize:13 * myDelegate.autoSizeScaleX];
//        numeberLabel.text = @"XG806F";
        numeberLabel.text = [NSString stringWithFormat:@"%ld",data.number];
        [cell addSubview:numeberLabel];

        UIButton * putAwayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        putAwayBtn.tag = 70000 + indexPath.row;
        putAwayBtn.frame = CGRectMake(CGRectGetMaxX(logoImageView.frame) + 119 * myDelegate.autoSizeScaleX, 87 * myDelegate.autoSizeScaleY, 50 * myDelegate.autoSizeScaleX, 16 * myDelegate.autoSizeScaleY);
        putAwayBtn.layer.cornerRadius = 2;
        //        putAwayBtn.clipsToBounds = YES;
        putAwayBtn.layer.borderColor = [CommonMethod getUsualColorWithString:@"#e06e15"].CGColor;
        putAwayBtn.layer.borderWidth = 1.f;
        putAwayBtn.backgroundColor = [UIColor whiteColor];
        [putAwayBtn setTitle:@"上架" forState:UIControlStateNormal];
        [putAwayBtn setTitle:@"下架" forState:UIControlStateSelected];
        putAwayBtn.titleLabel.font = [UIFont systemFontOfSize:11 * myDelegate.autoSizeScaleX];
        [putAwayBtn setTitleColor:[CommonMethod getUsualColorWithString:@"#ffa304"] forState:UIControlStateNormal];
        [putAwayBtn setTitleColor:[CommonMethod getUsualColorWithString:@"#ffa304"] forState:UIControlStateSelected];
        putAwayBtn.selected = NO;
        [putAwayBtn addTarget:self action:@selector(putawayOrSoldOutGoodsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:putAwayBtn];
        
        NSArray * btnTitleArr = @[@"编辑",@"删除"];
        for (int i = 0; i < 2; i ++)
        {
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
//            btn.tag = 3004 + i;
            btn.tag = 35000 + i * 10000 + indexPath.row ;
            
            btn.frame = CGRectMake(CGRectGetMaxX(logoImageView.frame) + 33 * myDelegate.autoSizeScaleX * i + 184 * myDelegate.autoSizeScaleX, 87 * myDelegate.autoSizeScaleY, 33 * myDelegate.autoSizeScaleX, 16 * myDelegate.autoSizeScaleY);
            [btn setTitle:btnTitleArr[i] forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor whiteColor];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(editOrDeleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.titleLabel.font = [UIFont systemFontOfSize:11 * myDelegate.autoSizeScaleX];
            [cell addSubview:btn];
        }
    }
    else
    {
        HKXSupplierEquipmentManagementData * equipmentModel = self.selectArray[indexPath.row];
        
        UIImageView * logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(17 * myDelegate.autoSizeScaleX, 10 * myDelegate.autoSizeScaleY, 102 * myDelegate.autoSizeScaleX, 95 * myDelegate.autoSizeScaleY)];
//        logoImageView.image = [UIImage imageNamed:@"滑动视图示例"];
        [logoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kIMAGEURL,equipmentModel.picture]] placeholderImage:[UIImage imageNamed:@"滑动视图示例"]];
        logoImageView.tag = 3000;
        [cell addSubview:logoImageView];
        
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(logoImageView.frame) + 15 * myDelegate.autoSizeScaleX, 16 * myDelegate.autoSizeScaleY, 184 * myDelegate.autoSizeScaleX, 13 * myDelegate.autoSizeScaleX)];
        titleLabel.tag = 3001;
        titleLabel.font = [UIFont systemFontOfSize:13 * myDelegate.autoSizeScaleX];
//        titleLabel.text = @"慧快修 工程机械专用液压油";
        titleLabel.text = [NSString stringWithFormat:@"%@",equipmentModel.type];
        [cell addSubview:titleLabel];
        
        UILabel * labelLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(logoImageView.frame) + 15 * myDelegate.autoSizeScaleX, CGRectGetMaxY(titleLabel.frame) + 12 * myDelegate.autoSizeScaleY, 184 * myDelegate.autoSizeScaleX, 13 * myDelegate.autoSizeScaleX)];
        labelLabel.tag = 3002;
        labelLabel.font = [UIFont systemFontOfSize:13 * myDelegate.autoSizeScaleX];
//        labelLabel.text = @"壳牌";
        labelLabel.text = equipmentModel.modelnum;
        [cell addSubview:labelLabel];
        
        UILabel * numeberLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(logoImageView.frame) + 15 * myDelegate.autoSizeScaleX,CGRectGetMaxY(labelLabel.frame) + 10 * myDelegate.autoSizeScaleY, 184 * myDelegate.autoSizeScaleX, 13 * myDelegate.autoSizeScaleX)];
        numeberLabel.tag = 3003;
        numeberLabel.font = [UIFont systemFontOfSize:13 * myDelegate.autoSizeScaleX];
//        numeberLabel.text = @"XG806F";
        numeberLabel.text = equipmentModel.brand;
        [cell addSubview:numeberLabel];
        
        UIButton * putAwayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        putAwayBtn.tag = 70000 + indexPath.row;
        putAwayBtn.frame = CGRectMake(CGRectGetMaxX(logoImageView.frame) + 119 * myDelegate.autoSizeScaleX, 87 * myDelegate.autoSizeScaleY, 50 * myDelegate.autoSizeScaleX, 16 * myDelegate.autoSizeScaleY);
        putAwayBtn.layer.cornerRadius = 2;
//        putAwayBtn.clipsToBounds = YES;
        putAwayBtn.layer.borderColor = [CommonMethod getUsualColorWithString:@"#e06e15"].CGColor;
        putAwayBtn.layer.borderWidth = 1.f;
        putAwayBtn.backgroundColor = [UIColor whiteColor];
        [putAwayBtn setTitle:@"上架" forState:UIControlStateNormal];
        [putAwayBtn setTitle:@"下架" forState:UIControlStateSelected];
        putAwayBtn.titleLabel.font = [UIFont systemFontOfSize:11 * myDelegate.autoSizeScaleX];
        [putAwayBtn setTitleColor:[CommonMethod getUsualColorWithString:@"#ffa304"] forState:UIControlStateNormal];
        [putAwayBtn setTitleColor:[CommonMethod getUsualColorWithString:@"#ffa304"] forState:UIControlStateSelected];
        putAwayBtn.selected = NO;
        [putAwayBtn addTarget:self action:@selector(putawayOrSoldOutGoodsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:putAwayBtn];
        
        NSArray * btnTitleArr = @[@"编辑",@"删除"];
        for (int i = 0; i < 2; i ++)
        {
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = 35000 + i * 10000 + indexPath.row ;
            
            btn.frame = CGRectMake(CGRectGetMaxX(logoImageView.frame) + 33 * myDelegate.autoSizeScaleX * i + 184 * myDelegate.autoSizeScaleX, 87 * myDelegate.autoSizeScaleY, 33 * myDelegate.autoSizeScaleX, 16 * myDelegate.autoSizeScaleY);
            [btn setTitle:btnTitleArr[i] forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor whiteColor];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(editOrDeleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.titleLabel.font = [UIFont systemFontOfSize:11 * myDelegate.autoSizeScaleX];
            [cell addSubview:btn];
        }
    }
    
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.hidesBottomBarWhenPushed = YES;
    if (self.isParts)
    {
        HKXSupplierReleasePartsViewController * releasePartsVC = [[HKXSupplierReleasePartsViewController alloc] init];
        releasePartsVC.navigationItem.title = @"发布配件";
        HKXSupplierPartsManagementData * data = self.selectArray[indexPath.row];
        self.partsModel.pid = [NSString stringWithFormat:@"%d",data.pId];
        self.partsModel.mid = [NSString stringWithFormat:@"%ld",data.mId];
        self.partsModel.number = [NSString stringWithFormat:@"%ld",data.number];
        self.partsModel.brand = data.brand;
        self.partsModel.basename = data.basename;
        self.partsModel.model = data.model;
        self.partsModel.tempPrice = [NSString stringWithFormat:@"%f",data.price];
        self.partsModel.introduct = data.introduct;
        self.partsModel.picture = data.picture;
        self.partsModel.category = data.category;
        self.partsModel.applyCareModel = data.applyCareModel;
        self.partsModel.stock = [NSString stringWithFormat:@"%d",data.stock];
        releasePartsVC.partsInfoModel = self.partsModel;
        releasePartsVC.isEditable = NO;
        [self.navigationController pushViewController:releasePartsVC animated:YES];
    }
    else
    {
        HKXSupplierReleaseEquipmentViewController * releaseEquipmentVC = [[HKXSupplierReleaseEquipmentViewController alloc] init];
        releaseEquipmentVC.navigationItem.title = @"发布设备";
        releaseEquipmentVC.equipmentModel = self.selectArray[indexPath.row];
        releaseEquipmentVC.isEditable = NO;
        [self.navigationController pushViewController:releaseEquipmentVC animated:YES];
    }
}
#pragma mark - Setters & Getters
- (NSMutableArray *)infoArray
{
    if (!_infoArray)
    {
        _infoArray = [NSMutableArray array];
    }
    return _infoArray;
}
- (HKXSupplierReleasePartsModel *)partsModel
{
    if (!_partsModel)
    {
        _partsModel = [HKXSupplierReleasePartsModel getUserModel];
    }
    return _partsModel;
}
- (NSMutableArray *)selectArray
{
    if (!_selectArray)
    {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
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
