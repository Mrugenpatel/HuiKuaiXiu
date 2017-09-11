//
//  HKXServerMoreInfoViewController.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/7/5.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXServerMoreInfoViewController.h"
#import "CommonMethod.h"
#import "CustomAlertView.h"

#import "HKXHttpRequestManager.h"
#import "HKXSupplierCompanyInfoModel.h"
#import "HKXUserVertificationCodeResultModelDataModels.h"

#import "HKXHomePageViewController.h"//homePage
#import "HKXShoppingMallViewController.h"//shoppingMall
#import "HKXRepairsViewController.h"//repairs
#import "HKXOrderReceivingViewController.h"//orderReceiving
#import "HKXLeaseViewController.h"//lease
#import "HKXMineViewController.h"//mine
#import "HKXNavigationController.h"
#import "CustomSubmitView.h"

#import <Photos/Photos.h>
#import <CTAssetsPickerController/CTAssetsPickerController.h>
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>

#import <UShareUI/UShareUI.h>

@interface HKXServerMoreInfoViewController ()< CTAssetsPickerControllerDelegate ,UIImagePickerControllerDelegate , UINavigationControllerDelegate , UIActionSheetDelegate>


{
    UIScrollView * _bottomView;
    NSString     * _headImageString;//头像
    NSString     * _baseString;//证书
}

@property (nonatomic , strong) UIActionSheet * actionSheet;
@property (nonatomic , strong) HKXSupplierCompanyInfoModel * serverModel;
@property (nonatomic , strong) NSArray                     * serveSpecArray;
@property (nonatomic , strong) NSMutableArray              * majorArray;//选择的主修
@property (nonatomic , strong) NSMutableArray              * imageArray;//选择的图片数组
@property (nonatomic , strong) NSMutableArray              * imageBase64Array;//选择的图片转码数据的数组

@end

@implementation HKXServerMoreInfoViewController

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _baseString = [[NSString alloc] init];
    _headImageString = [[NSString alloc] init];
    
    
    [self createUI];
}
#pragma mark - CreateUI
- (void)createUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.view.backgroundColor = [UIColor colorWithRed:233 / 255.0 green:233 / 255.0 blue:233 / 255.0 alpha:1];
    
    self.navigationItem.title = @"服务维修";
    
    _bottomView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 10 * myDelegate.autoSizeScaleY + 60, ScreenWidth, ScreenHeight - 30 * myDelegate.autoSizeScaleY - 60)];
    _bottomView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight - 30 * myDelegate.autoSizeScaleY - 60);
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    
//    头像
    UIButton * headImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    headImageBtn.frame = CGRectMake((ScreenWidth - 100 * myDelegate.autoSizeScaleX) / 2, 20 * myDelegate.autoSizeScaleY, 100 * myDelegate.autoSizeScaleX , 100 * myDelegate.autoSizeScaleX);
    headImageBtn.layer.cornerRadius = 50 * myDelegate.autoSizeScaleX;
    headImageBtn.clipsToBounds = YES;
    headImageBtn.tag = 80000;
    [headImageBtn addTarget:self action:@selector(openPhotoLibraryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [headImageBtn setBackgroundImage:[UIImage imageNamed:@"相机"] forState:UIControlStateNormal];
    [_bottomView addSubview:headImageBtn];
    
//    文本框
    NSArray * placeHolderArray = @[@"输入您的身份证号",@"简要输入个人技能描述"];
    for (int i = 0; i < placeHolderArray.count; i ++)
    {
        UITextField * idNumberTF = [[UITextField alloc] initWithFrame:CGRectMake(22 * myDelegate.autoSizeScaleX, CGRectGetMaxY(headImageBtn.frame) + 15 * myDelegate.autoSizeScaleY + i * 147 * myDelegate.autoSizeScaleY, ScreenWidth - 44 * myDelegate.autoSizeScaleX, 40 * myDelegate.autoSizeScaleY)];
        idNumberTF.tag = 7000 + i;
        idNumberTF.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];
        idNumberTF.placeholder = placeHolderArray[i];
        idNumberTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10 * myDelegate.autoSizeScaleX, idNumberTF.frame.size.height)];
        idNumberTF.leftView.backgroundColor = [UIColor clearColor];
        idNumberTF.leftViewMode = UITextFieldViewModeAlways;
        idNumberTF.borderStyle = UITextBorderStyleRoundedRect;
        [_bottomView addSubview:idNumberTF];
    }
    
//    主修
    UITextField * idNumTF = [_bottomView viewWithTag:7000];
    float majorServeLabelLength = [CommonMethod getLabelLengthWithString:@"主修" WithFont:17 * myDelegate.autoSizeScaleX];
    UILabel * majorServeLabel = [[UILabel alloc] initWithFrame:CGRectMake(22 * myDelegate.autoSizeScaleX, CGRectGetMaxY(idNumTF.frame) + 22 * myDelegate.autoSizeScaleY, majorServeLabelLength, 17 * myDelegate.autoSizeScaleX)];
    majorServeLabel.text = @"主修";
    majorServeLabel.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];
    [_bottomView addSubview:majorServeLabel];
    
    float serveSpecLabelLength = [CommonMethod getLabelLengthWithString:@"液压系统" WithFont:14 * myDelegate.autoSizeScaleX];
    self.serveSpecArray = @[@"液压系统",@"机械部位",@"发动机",@"电路",@"保养"];
    for (int i = 0; i < self.serveSpecArray.count; i ++)
    {
        int X = i % 3;
        int Y = i / 3;
        UIButton * serveSpecBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(majorServeLabel.frame) + 16 * myDelegate.autoSizeScaleX + X * (38 * myDelegate.autoSizeScaleX + serveSpecLabelLength), CGRectGetMaxY(idNumTF.frame) + 22 * myDelegate.autoSizeScaleY + Y * 49 * myDelegate.autoSizeScaleY, 12 * myDelegate.autoSizeScaleX, 12 * myDelegate.autoSizeScaleX)];
        [serveSpecBtn setImage:[UIImage imageNamed:@"复选框-未选中"] forState:UIControlStateNormal];
        [serveSpecBtn setImage:[UIImage imageNamed:@"复选框_已选择"] forState:UIControlStateSelected];
        serveSpecBtn.selected = NO;
        serveSpecBtn.tag = 30000 + i;
        [serveSpecBtn addTarget:self action:@selector(selectServeSpecBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:serveSpecBtn];
        
        UILabel * serveSpecLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(serveSpecBtn.frame) + 10 * myDelegate.autoSizeScaleX, serveSpecBtn.frame.origin.y, serveSpecLabelLength, 14 * myDelegate.autoSizeScaleX)];
        serveSpecLabel.text = self.serveSpecArray[i];
        serveSpecLabel.font = [UIFont systemFontOfSize:14 * myDelegate.autoSizeScaleX];
        [_bottomView addSubview:serveSpecLabel];
    }
    
//    证书
    UITextField * skillTF = [_bottomView viewWithTag:7001];
    UILabel * certificateLabel = [[UILabel alloc] initWithFrame:CGRectMake(22 * myDelegate.autoSizeScaleX, CGRectGetMaxY(skillTF.frame) + 23 * myDelegate.autoSizeScaleY, majorServeLabelLength, 17 * myDelegate.autoSizeScaleX)];
    certificateLabel.text = @"证书";
    certificateLabel.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];
    [_bottomView addSubview:certificateLabel];
    
    UIButton * certificateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    certificateBtn.frame = CGRectMake(CGRectGetMaxX(certificateLabel.frame) + 17 * myDelegate.autoSizeScaleX, CGRectGetMaxY(skillTF.frame) + 23 * myDelegate.autoSizeScaleY, 97 * myDelegate.autoSizeScaleX, 61 * myDelegate.autoSizeScaleY);
    CAShapeLayer *border = [CAShapeLayer layer];
    border.strokeColor = [CommonMethod getUsualColorWithString:@"#a0a0a0"].CGColor;
    border.fillColor = nil;
    border.path = [UIBezierPath bezierPathWithRect:certificateBtn.bounds].CGPath;
    border.frame = certificateBtn.bounds;
    border.lineWidth = 0.5;
    border.lineCap = @"square";
    border.lineDashPattern = @[@4, @2];
    [certificateBtn.layer addSublayer:border];
    certificateBtn.tag = 80001;
    [certificateBtn addTarget:self action:@selector(openPhotoLibraryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:certificateBtn];
    
    UIImageView * addImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"添加"]];
    addImage.frame = CGRectMake(37.5 * myDelegate.autoSizeScaleX, 20 * myDelegate.autoSizeScaleY, 22 * myDelegate.autoSizeScaleX, 22 * myDelegate.autoSizeScaleX);
    [certificateBtn addSubview:addImage];
    
//    确定
    UIButton * confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(98 / 2 * myDelegate.autoSizeScaleX , CGRectGetMaxY(certificateBtn.frame) + 45 * myDelegate.autoSizeScaleY, 554 / 2 * myDelegate.autoSizeScaleX , 87 / 2 * myDelegate.autoSizeScaleY);
    [confirmBtn setTitle:@"确 定" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:20 * myDelegate.autoSizeScaleX];
    confirmBtn.backgroundColor = [CommonMethod getUsualColorWithString:@"#ffa304"];
    confirmBtn.layer.cornerRadius = 2;
    confirmBtn.clipsToBounds = YES;
    confirmBtn.tag = 80002;
    [confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:confirmBtn];
    
    float length = [CommonMethod getLabelLengthWithString:@"主修资料" WithFont:17 * myDelegate.autoSizeScaleY];
    for (int i = 0; i < 5; i ++)
    {
        int x = i % 2;
        int y = i / 2;
        UIImageView * selectedImageView = [[UIImageView alloc] initWithFrame:CGRectMake((length + (22 + 17) * myDelegate.autoSizeScaleX ) + x * 100 * myDelegate.autoSizeScaleX, 345 * myDelegate.autoSizeScaleY + y * 70 * myDelegate.autoSizeScaleY, 97 * myDelegate.autoSizeScaleX, 61 * myDelegate.autoSizeScaleY)];
        [_bottomView addSubview:selectedImageView];
        selectedImageView.hidden = YES;
        [self.imageArray addObject:selectedImageView];
    }

}
#pragma 正则匹配用户身份证号15或18位
- (BOOL)checkUserIdCard: (NSString *) idCard
{
    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:idCard];
    return isMatch;
}
#pragma mark - ConfigData
- (void)prepareData
{
    self.serverModel.uId = [NSString stringWithFormat:@"%ld",self.userRegisterData.dataIdentifier];
    self.serverModel.role = [NSString stringWithFormat:@"%d",self.userRegisterData.role];
    
//    头像
    self.serverModel.realName = _headImageString;
    
//    主修
    self.serverModel.companyName = [self.majorArray componentsJoinedByString:@","];
    
//    身份证号
    UITextField * idNumTF = [_bottomView viewWithTag:7000];
    if (![self checkUserIdCard:idNumTF.text]) {
        [self showHint:@"请输入正确身份证号码"];
        return;
    }
    self.serverModel.companyAddress = [idNumTF.text isEqualToString:@""] ? (NSString *)[NSNull null] : idNumTF.text;
    
//    个人技能描述
    UITextField * skillTF = [_bottomView viewWithTag:7001];
    self.serverModel.registerCapital = [skillTF.text isEqualToString:@""] ? (NSString *)[NSNull null] : skillTF.text;
    
//    证书图片
    _baseString = [self.imageBase64Array componentsJoinedByString:@"$"];
    
    self.serverModel.establishmentTime = _baseString;
    
    [self.view showActivity];
    [HKXHttpRequestManager sendRequestWithServeInfo:self.serverModel ToGetUpdateServeInfoResult:^(id data) {
        [self.view hideActivity];
        HKXUserVertificationCodeResultModel * model = data;
        CustomSubmitView * customAlertView = [CustomSubmitView alertViewWithTitle:@"提示" content:model.message sure:@"确定" sureBtnClick:^{
            if (model.success)
            {
//                [self createTabbar:self.userRegisterData.role];
//                NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//                [defaults setInteger:self.userRegisterData.role forKey:@"userDataRole"];
//                [defaults  setDouble:self.userRegisterData.dataIdentifier forKey:@"userDataId"];
//                [defaults synchronize];
                [self showRecommandCode];
            }
            else
            {
                [self tapGestureClick];
            }
            
        } WithAlertHeight:160];
        customAlertView.tag = 501;
        [self.view addSubview:customAlertView];
    }];
}
#pragma mark - Action
- (void)tapGestureClick
{
    for (UIView * view in self.view.subviews)
    {
        if (view.tag >= 500 && view.tag <= 507 )
        {
            [view removeFromSuperview];
        }
    }
    
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    for (UIView * view in window.subviews)
    {
        if (view.tag == 500000 || view.tag == 500001 || view.tag == 500002)
        {
            [view removeFromSuperview];
        }
    }
    
}
- (void)openPhotoLibraryBtnClick:(UIButton *)btn
{
    if (btn.tag == 80000)
    {
        [self callActionSheetFunc];

    }
    else
    {
//        for (UIImageView * imag in self.imageArray)
//        {
//            imag.image = NULL;
//        }
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status != PHAuthorizationStatusAuthorized) return;
            dispatch_async(dispatch_get_main_queue(), ^{
                CTAssetsPickerController * pickerVC = [[CTAssetsPickerController alloc] init];
                pickerVC.delegate = self;
                pickerVC.view.tag = 889;
                pickerVC.showsSelectionIndex = YES;
                pickerVC.showsEmptyAlbums = NO;
                [self presentViewController:pickerVC animated:YES completion:nil];
            });
        }];
    }
    
}
- (void)selectServeSpecBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected)
    {
        [self.majorArray addObject:[NSString stringWithFormat:@"%ld",btn.tag - 30000]];
    }
    else
    {
        [self.majorArray removeObject:[NSString stringWithFormat:@"%ld",btn.tag - 30000]];
    }
}
- (void)confirmBtnClick:(UIButton *)btn
{
    [self prepareData];
}
#pragma mark - Private Method
- (void)showRecommandCode
{
        //    TODO:此处跳转至首页
        [self createTabbar:self.userRegisterData.role];
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:self.userRegisterData.role forKey:@"userDataRole"];
        [defaults setDouble:self.userRegisterData.dataIdentifier forKey:@"userDataId"];
        [defaults setBool:YES forKey:@"userLoginState"];
        NSArray * arr = [[NSString stringWithFormat:@"%ld",self.userRegisterData.dataIdentifier] componentsSeparatedByString:@"."];
        if ([defaults integerForKey:@"userDataRole"] == 0) {
            
            [UMessage addAlias:arr[0] type:@"HKX_MACHINE" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
                
                NSLog(@"%@",responseObject);;
                
            }];
        }else if([defaults integerForKey:@"userDataRole"] == 1){
            
            
            [UMessage addAlias:arr[0] type:@"HKX_REPAIR" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
                
                NSLog(@"%@",responseObject);;
                
            }];
        }else if([defaults integerForKey:@"userDataRole"] == 2){
            
            [UMessage addAlias:arr[0] type:@"HKX_SUPPLIER" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
                
                NSLog(@"%@",responseObject);;
                
            }];
        }
        [defaults synchronize];
    

}
/**
 根据不同角色，布局相应首页tabbar
 */
- (void)createTabbar:(int)userId
{
    NSMutableArray * tabbarArray = [NSMutableArray array];
    NSMutableArray * sonClassVCArray = [NSMutableArray array];
    if (userId == 0)
    {
        //        机主角色
        tabbarArray = [NSMutableArray arrayWithObjects:@"首页",@"商城",@"报修",@"租赁",@"我的", nil];
        sonClassVCArray = [NSMutableArray arrayWithObjects:@"HKXHomePageViewController",@"HKXShoppingMallViewController",@"HKXRepairsViewController",@"HKXLeaseViewController",@"HKXMineViewController", nil];
    }
    if (userId == 2)
    {
        //        供应商角色
        tabbarArray = [NSMutableArray arrayWithObjects:@"首页",@"商城",@"租赁",@"我的", nil];
        sonClassVCArray = [NSMutableArray arrayWithObjects:@"HKXHomePageViewController",@"HKXShoppingMallViewController",@"HKXLeaseViewController",@"HKXMineViewController", nil];
    }
    if (userId == 1)
    {
        //        服务维修角色
        tabbarArray = [NSMutableArray arrayWithObjects:@"首页",@"商城",@"接单",@"租赁",@"我的", nil];
        sonClassVCArray = [NSMutableArray arrayWithObjects:@"HKXHomePageViewController",@"HKXShoppingMallViewController",@"HKXOrderReceivingViewController",@"HKXLeaseViewController",@"HKXMineViewController", nil];
    }
    
    UITabBarController * tabbar = [[UITabBarController alloc] init];
    NSMutableArray * sonViewControllersArray = [NSMutableArray array];
    
    for (int i = 0; i < tabbarArray.count; i ++)
    {
        NSString * titleString = tabbarArray[i];
        
        //        视图的类名
        Class c = NSClassFromString(sonClassVCArray[i]);
        UIViewController * superViewController = [[c alloc] init];
        
        HKXNavigationController * nc = [[HKXNavigationController alloc] initWithRootViewController:superViewController];
        nc.title = titleString;
        
        [sonViewControllersArray addObject:nc];
        
        UIImage * icoImage = [[UIImage imageNamed:tabbarArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage * icoSelectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@选中",tabbarArray[i]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        superViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:titleString image:icoImage selectedImage:icoSelectedImage];
        tabbar.tabBar.tintColor = [CommonMethod getUsualColorWithString:@"#ffa304"];
        
        if ([titleString isEqualToString:@"接单"])
        {
            superViewController.navigationItem.title = @"接单列表";
        }
        else if ([titleString isEqualToString:@"我的"])
        {
            superViewController.navigationItem.title = @"我的个人中心";
        }
        else
        {
            superViewController.navigationItem.title = titleString;
        }
        //        }
    }
    tabbar.viewControllers = sonViewControllersArray;
    
    
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    
    window.rootViewController = tabbar;
    [window makeKeyWindow];
    
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIView * backGroundView = [[UIView alloc] initWithFrame:window.bounds];
    backGroundView.backgroundColor = [UIColor darkGrayColor];
    backGroundView.alpha = 0.3;
    backGroundView.tag = 500000;
    [window addSubview:backGroundView];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick)];
    [backGroundView addGestureRecognizer:tap];
    
    CustomAlertView * submitAlertView = [CustomAlertView alertViewWithTitle:[NSString stringWithFormat:@"推荐码：%@",self.userRegisterData.recommendCode] content:@"复制上面信息发送到社交群里您会有小惊喜" cancel:@"完成" sure:@"复制" cancelBtnClick:^{
        [self tapGestureClick];
    } sureBtnClick:^{
        //TODO:此处添加分享部分
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
            //设置文本
            messageObject.text = self.userRegisterData.recommendCode;
            // 根据获取的platformType确定所选平台进行下一步操作
            [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                if (error) {
                    UMSocialLogInfo(@"************Share fail with error %@*********",error);
                    [self showHint:@"分享失败"];
                    
                }else{
                    if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                        UMSocialShareResponse *resp = data;
                        //分享结果消息
                        UMSocialLogInfo(@"response message is %@",resp.message);
                        //第三方原始返回的数据
                        UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                        
                    }else{
                        UMSocialLogInfo(@"response data is %@",data);
                    }
                }
                
            }];
            
        }];
        [self tapGestureClick];
    } WithAlertHeight:240 * myDelegate.autoSizeScaleY];
    submitAlertView.tag = 500002;
    [window addSubview:submitAlertView];
    
}
//通过图片Data数据第一个字节 来获取图片扩展名
- (NSString *)contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"jpeg";
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        case 0x49:
        case 0x4D:
            return @"tiff";
        case 0x52:
            if ([data length] < 12) {
                return nil;
            }
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return @"webp";
            }
            return nil;
    }
    return nil;
}
/**
 @ 调用ActionSheet
 */
- (void)callActionSheetFunc{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择",nil];

    }
    else
    {
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消"destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    
    self.actionSheet.tag = 1000;
    [self.actionSheet showInView:self.view];
}

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1000) {
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    //来源:相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 1:
                    //来源:相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                case 2:
                    return;
            }
        }
        else {
            if (buttonIndex == 2) {
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{
            
        }];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIButton * headImageBtn = [_bottomView viewWithTag:80000];
        [headImageBtn setImage:image forState:UIControlStateNormal];
        
        NSData * data = UIImageJPEGRepresentation(image, 0.3);
        NSString * dataStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
        NSString * typeStr = [self contentTypeForImageData:data];
        _headImageString = [NSString stringWithFormat:@"data:image/%@;base64,%@",typeStr,dataStr];
    }];
    
}
#pragma mark - Delegate & Data Source
#pragma mark - <CTAssetsPickerControllerDelegate>
- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(PHAsset *)asset
{
    NSInteger max = 5;
    if (picker.view.tag == 888)
    {
        max = 1;
    }
    
    if (picker.selectedAssets.count >= max)
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"最多选择%ld张图片",(long)max] preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
        [picker presentViewController:alert animated:YES completion:nil];
        //        这里不能使用self来modal别的控制器，因为此时self.view不在window上
        return NO;
    }
    return YES;
}
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray<PHAsset *> *)assets
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

        NSInteger XPosition = (assets.count ) % 2;
        NSInteger YPosition = (assets.count ) / 2;
        //    改变因图片选择而影响底层view的frame
        _bottomView.contentSize = CGSizeMake(ScreenWidth , ScreenHeight - 20 * myDelegate.autoSizeScaleY - 64 + YPosition * (122 + 40)/ 2 * myDelegate.autoSizeScaleY);
        UIButton * addImageBtn = [_bottomView viewWithTag:80001];
        if (assets.count < 5)
        {
            float length = [CommonMethod getLabelLengthWithString:@"设备照片" WithFont:17 * myDelegate.autoSizeScaleY];
            
            addImageBtn.frame = CGRectMake((length + (22 + 17) * myDelegate.autoSizeScaleX ) + XPosition * 100 * myDelegate.autoSizeScaleX, 345 * myDelegate.autoSizeScaleY + YPosition * 70 * myDelegate.autoSizeScaleY, 194 / 2 * myDelegate.autoSizeScaleX , 122 / 2 * myDelegate.autoSizeScaleY);
        }
        else
        {
            addImageBtn.hidden = YES;
        }
        
        UIButton * submitBtn = [_bottomView viewWithTag:80002];
        submitBtn.frame = CGRectMake((ScreenWidth - 274 * myDelegate.autoSizeScaleX) / 2, 345 * myDelegate.autoSizeScaleY + 70 *( YPosition + 1)* myDelegate.autoSizeScaleY + 38 * myDelegate.autoSizeScaleY, 274 * myDelegate.autoSizeScaleX, 44 * myDelegate.autoSizeScaleY);
        
        //    关闭图片选择界面
        [picker dismissViewControllerAnimated:YES completion:nil];
        CGFloat scale = [[UIScreen mainScreen] scale];
        PHImageRequestOptions * options = [[PHImageRequestOptions alloc] init];
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        //    遍历选中的图片
        for (NSInteger i = 0; i < assets.count; i ++)
        {
            PHAsset * asset = assets[i];
            CGSize size = CGSizeMake(asset.pixelWidth / scale, asset.pixelHeight / scale);
            //        获取图片
            [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                UIImageView * imageView = self.imageArray[i];
                imageView.hidden = NO;
                imageView.image = result;
                
                NSData * data = UIImageJPEGRepresentation(result, 0.3);
                NSString * dataStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                NSString * typeStr = [self contentTypeForImageData:data];
                __block NSString * imageDataString;
                imageDataString = [NSString stringWithFormat:@"data:image/%@;base64,%@",typeStr,dataStr];
                
                [self.imageBase64Array addObject:imageDataString];
//                if (i == 0)
//                {
//                    _baseString = imageDataString;
//                    
//                }
//                else
//                {
//                    NSString * appendString = [NSString stringWithFormat:@"$%@",imageDataString];
//                    _baseString = [_baseString stringByAppendingString:appendString];
//                }
                
            }];
        }

}
#pragma mark - Setters & Getters
- (HKXSupplierCompanyInfoModel *)serverModel
{
    if (!_serverModel)
    {
        _serverModel = [HKXSupplierCompanyInfoModel getUserModel];
    }
    return _serverModel;
}
- (NSArray *)serveSpecArray
{
    if (!_serveSpecArray)
    {
        _serveSpecArray = [NSArray array];
    }
    return _serveSpecArray;
}
- (NSMutableArray *)majorArray
{
    if (!_majorArray)
    {
        _majorArray = [NSMutableArray array];
    }
    return _majorArray;
}
- (NSMutableArray *)imageArray
{
    if (!_imageArray)
    {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}
- (NSMutableArray *)imageBase64Array
{
    if (!_imageBase64Array)
    {
        _imageBase64Array = [NSMutableArray array];
    }
    return _imageBase64Array;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_bottomView endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
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
