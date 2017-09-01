//
//  goodsDetailViewController.m
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/7/27.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "goodsPartDetailViewController.h"

#import "HKXShoppingMallViewController.h"

#import "goodsInfoTableViewCell.h"
#import "bottomPopView.h"
#import "UIImageView+WebCache.h"

@interface goodsPartDetailViewController ()<UITableViewDelegate,UITableViewDataSource,bottomPopViewDelegate>{
    
    UIButton * goodsInformation;//产品信息
    UIButton * goodsDetail;//产品详情
    UILabel * lineLb;//按钮下面的线
    UIImageView * goodsImgView;//商品图片
    UILabel * goodsName;//产品名字
    UITableView * goodsInfoTableView;//产品信息
    UITableView * goodsDetailTableView;//产品详情
    UIButton * addShoppingCarBtn;//加入购物车
    UIButton * buyBtn;//购买
    bottomPopView * popView;//弹出视图
    NSString * count;
}

@end

@implementation goodsPartDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    count = @"1";
}

- (void)createUI{
    
    
    self.view.backgroundColor  = [UIColor whiteColor];
    AppDelegate * delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIView * titleView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth / 2 - 110, 0, 220 * delegate.autoSizeScaleX, 44* delegate.autoSizeScaleY)];
    self.navigationItem.titleView = titleView;
    
    goodsInformation = [UIButton buttonWithType:UIButtonTypeCustom];
    goodsInformation = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (titleView.frame.size.width / 2 - 10) * delegate.autoSizeScaleX, 44 * delegate.autoSizeScaleY)];
    [goodsInformation setTitle:@"产品信息" forState:UIControlStateNormal];
    [goodsInformation setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [goodsInformation setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    goodsInformation.titleLabel.textAlignment = NSTextAlignmentRight;
    goodsInformation.titleLabel.font = [UIFont systemFontOfSize:17];
    goodsInformation.selected = YES;
    [goodsInformation addTarget:self action:@selector(informationClick:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:goodsInformation];
    
    goodsDetail = [UIButton buttonWithType:UIButtonTypeCustom];
    goodsDetail = [[UIButton alloc] initWithFrame:CGRectMake((goodsInformation.frame.size.width + 20) * delegate.autoSizeScaleX, 0,( titleView.frame.size.width / 2 - 10)* delegate.autoSizeScaleX, 44* delegate.autoSizeScaleY)];
    [goodsDetail setTitle:@"产品详情" forState:UIControlStateNormal];
    [goodsDetail setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [goodsDetail setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    goodsDetail.titleLabel.textAlignment = NSTextAlignmentLeft;
    goodsDetail.titleLabel.font = [UIFont systemFontOfSize:17];
    [goodsDetail addTarget:self action:@selector(detailClick:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:goodsDetail];
    
    lineLb = [[UILabel alloc] initWithFrame:CGRectMake(goodsInformation.frame.origin.x, goodsInformation.frame.size.height - 3, goodsInformation.frame.size.width, 1)];
    lineLb.backgroundColor = [UIColor redColor];
    [titleView addSubview:lineLb];
    
    goodsImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64 * delegate.autoSizeScaleY, ScreenWidth, 220 * delegate.autoSizeScaleY)];
    [goodsImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kIMAGEURL,self.partModel.picture[0]]]];
    [self.view addSubview:goodsImgView];
    
    goodsName = [[UILabel alloc] initWithFrame:CGRectMake(20, goodsImgView.frame.origin.y + goodsImgView.frame.size.height, ScreenWidth - 40, 50 * delegate.autoSizeScaleY)];
    goodsName.text = self.partModel.brand;
    goodsName.numberOfLines = 0;
    goodsName.lineBreakMode = NSLineBreakByWordWrapping;
    goodsName.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:goodsName];
    
    goodsInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, goodsName.frame.origin.y + goodsName.frame.size.height, ScreenWidth - goodsName.frame.origin.x * 2, ScreenHeight - 80 - goodsName.frame.origin.y - goodsName.frame.size.height) style:UITableViewStylePlain];
    goodsInfoTableView.delegate = self;
    goodsInfoTableView.dataSource = self;
    goodsInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [goodsInfoTableView registerNib:[UINib nibWithNibName:@"goodsInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:goodsInfoTableView];
    
    addShoppingCarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addShoppingCarBtn = [[UIButton alloc] initWithFrame:CGRectMake(goodsName.frame.origin.x, ScreenHeight - 80, ScreenWidth /2 - goodsName.frame.origin.x - 10, 50* delegate.autoSizeScaleY)];
    [addShoppingCarBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [addShoppingCarBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    addShoppingCarBtn.layer.cornerRadius = 4;
    addShoppingCarBtn.layer.borderWidth = 1.0f;
    addShoppingCarBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    addShoppingCarBtn.layer.masksToBounds = YES;
    [addShoppingCarBtn addTarget:self action:@selector(addShoppingCar) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addShoppingCarBtn];
    
    buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(addShoppingCarBtn.frame.origin.x + addShoppingCarBtn.frame.size.width + 20 , ScreenHeight - 80, addShoppingCarBtn.frame.size.width, 50 * delegate.autoSizeScaleY)];
    [buyBtn setTitle:@"购买" forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    buyBtn.layer.cornerRadius = 4;
    buyBtn.layer.borderWidth = 1.0f;
    buyBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    buyBtn.layer.masksToBounds = YES;
    [buyBtn addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buyBtn];
    
    goodsDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64,ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    goodsDetailTableView.delegate = self;
    goodsDetailTableView.dataSource = self;
    goodsDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [goodsDetailTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"goodsDetailCell"];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
}
//产品信息
- (void)informationClick:(UIButton *)btn{
    
    [goodsDetailTableView removeFromSuperview];
    if (btn.selected) {
        
        goodsDetail.selected = NO;
    }else{
        
        btn.selected = YES;
        goodsDetail.selected = NO;
        CGRect btnFrame = lineLb.frame;
        btnFrame.origin.x = goodsInformation.frame.origin.x;
        lineLb.frame = btnFrame;
    }
    
    
}
//产品详情
- (void)detailClick:(UIButton *)btn{
    if (btn.selected) {
        
        goodsInformation.selected = NO;
        
    }else{
        
        btn.selected = YES;
        goodsInformation.selected = NO;
        CGRect btnFrame = lineLb.frame;
        btnFrame.origin.x = goodsDetail.frame.origin.x;
        lineLb.frame = btnFrame;
    }
    
    [self.view addSubview:goodsDetailTableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([tableView isEqual:goodsInfoTableView]) {
        
        return 30 * delegate.autoSizeScaleX;
    }else{
        
        return 30 * delegate.autoSizeScaleX;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([tableView isEqual:goodsInfoTableView]) {
        
        return 6;
    }else{
        
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:goodsInfoTableView]) {
        goodsInfoTableViewCell * cell = [goodsInfoTableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            
            cell.titleLb.text = [NSString stringWithFormat:@"¥ %@",self.partModel.price];
            cell.titleLb.textColor = [UIColor redColor];
            cell.detailLB.text = @"";
        }else if (indexPath.row == 1){
            
            cell.titleLb.text = @"供应数量:";
            cell.detailLB.text = [NSString stringWithFormat:@"%@",self.partModel.stock];
        }else if (indexPath.row == 2){
            
            cell.titleLb.text = @"发货期限:";
            cell.detailLB.text = @"面议";
        }else if (indexPath.row == 3){
            
            cell.titleLb.text = @"选择规格数量:";
            cell.detailLB.text = count;
        }else if (indexPath.row == 4){
            
            cell.titleLb.text = @"交易保障:";
            cell.detailLB.text = @"";
        }else if (indexPath.row == 5){
            
            cell.titleLb.text = self.partModel.companyName;
            cell.titleLb.textColor = [UIColor orangeColor];
            cell.detailLB.text = @"";
        }
        
        return cell;
        
    }else{
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"goodsDetailCell" forIndexPath:indexPath];
        UILabel * lb = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth, cell.frame.size.height)];
        lb.textColor = [UIColor blackColor];
        lb.font = [UIFont systemFontOfSize:15];
        lb.numberOfLines = 0;
        if (indexPath.row == 0) {
            
            lb.text = [NSString stringWithFormat:@"编号:%@",self.partModel.number];
        }else if (indexPath.row == 1){
            
            lb.text = [NSString stringWithFormat:@"型号:%@",self.partModel.model];;
        }else if (indexPath.row == 2){
            
            lb.text = [NSString stringWithFormat:@"适用车型:%@",self.partModel.applyCareModel];
        }else if (indexPath.row == 3){
            
            lb.text = [NSString stringWithFormat:@"产品描述:%@",self.partModel.introduct];
        }
        [cell.contentView addSubview:lb];
        return cell;
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:goodsInfoTableView]) {
        if (indexPath.row == 3) {
            
            //点击选择规格数量

            popView = [[bottomPopView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, ScreenHeight)];
            popView.delegate = self;
            popView.partGoodsModel = self.partModel;
            popView.mark = @"规格";
            [self.view addSubview:popView];
            
            
        }else if (indexPath.row == 5){
            
            //点击公司
            NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:self.partModel.mId,@"mId",nil];
            NSLog(@"%@",dict);
            
            [self.view showActivity];
            [IWHttpTool postWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"info/selectCompany.do"] params:dict success:^(id responseObject) {
                
                NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"请求成功%@",dicts);
                [self.view hideActivity];
                if ([dicts[@"success"] boolValue] == YES) {
                   
                    popView = [[bottomPopView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, ScreenHeight)];
                    popView.mark = @"11";
                    CompanyModel * companyModel = [[CompanyModel alloc] initWithDict:dicts[@"data"]];
                    popView.companyModel = companyModel;
                    popView.delegate = self;
                    [self.view addSubview:popView];
                    
                }else{
                    
                    [self showHint:dicts[@"message"]];
                }
                
                
                
            } failure:^(NSError *error) {
                
                NSLog(@"请求失败%@",error);
              
                [self.view hideActivity];
                [self showHint:@"请求失败"];
                
            }];

        }

    }else{
        
        
    }
    
}
//加入购物车
- (void)addShoppingCar{
    
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:self.partModel.mId,@"mid",self.partModel.pId,@"pid",[NSNumber numberWithInt:[count intValue]],@"buynumber",nil];
    NSLog(@"%@",dict);
    
    [self.view showActivity];
    [IWHttpTool postWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"shopcart/synAddShopCart.do"] params:dict success:^(id responseObject) {
        
        NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"请求成功%@",dicts);
        [self.view hideActivity];
        if ([dicts[@"success"] boolValue] == YES) {
            
            [self showHint:dicts[@"message"]];
            
        }else{
            
            [self showHint:dicts[@"message"]];
        }
        
        
        
    } failure:^(NSError *error) {
        
        NSLog(@"请求失败%@",error);
        [self.view hideActivity];
        [self showHint:@"请求失败"];
        
    }];
    

    
    
}
//购买
- (void)buy{
    
    
}

- (void)immedateBuyClick:(NSString *)num{
    
    count = num;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:0];
    [goodsInfoTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
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
