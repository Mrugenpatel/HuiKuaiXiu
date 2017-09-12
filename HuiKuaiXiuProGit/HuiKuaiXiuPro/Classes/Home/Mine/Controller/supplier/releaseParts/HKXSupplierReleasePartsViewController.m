//
//  HKXSupplierReleasePartsViewController.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/7/12.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXSupplierReleasePartsViewController.h"
#import "CommonMethod.h"

#import <Photos/Photos.h>
#import <CTAssetsPickerController/CTAssetsPickerController.h>
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>

#import "UIImageView+WebCache.h"

#import "HKXHttpRequestManager.h"
#import "HKXMineServeCertificateProfileModelDataModels.h"

#import "CustomSubmitView.h"

@interface HKXSupplierReleasePartsViewController ()<UITextFieldDelegate,CTAssetsPickerControllerDelegate>
{
    UIScrollView * _bottomScrollView;
    
    NSString    * _base64String;//转码之后的字符串
}

@property (nonatomic , strong) NSMutableArray              * imageArray;//选择的图片数组
@property (nonatomic , strong) NSMutableArray              * imageBase64Array;//选择的图片转码数据的数组

@end

@implementation HKXSupplierReleasePartsViewController

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _base64String = [[NSString alloc] init];
    [self createUI];
}
#pragma mark - CreateUI
- (void)createUI
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.view.backgroundColor = [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1];
    
    
    _bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 10 * myDelegate.autoSizeScaleY, ScreenWidth, ScreenHeight - 20  - 10 * myDelegate.autoSizeScaleY)];
    _bottomScrollView.backgroundColor = [UIColor whiteColor];
    _bottomScrollView.contentSize = CGSizeMake(ScreenWidth, (10 + 50 * 9 + 106 + 36 + 44 + 20) * myDelegate.autoSizeScaleY);
    _bottomScrollView.pagingEnabled = NO;
    _bottomScrollView.bounces = NO;
    [self.view addSubview:_bottomScrollView];
    
    NSArray * placeHolderArray = @[@"编号",@"品牌",@"型号",@"名称",@"价格",@"产品描述",@"配件类型",@"适用车型",@"库存"];
    NSArray * contentArray = [NSArray array];
    if (self.partsInfoModel.pid != nil)
    {
        contentArray = [NSArray arrayWithObjects:self.partsInfoModel.number,self.partsInfoModel.brand,self.partsInfoModel.model,self.partsInfoModel.basename,self.partsInfoModel.tempPrice,self.partsInfoModel.introduct,self.partsInfoModel.category,self.partsInfoModel.applyCareModel,self.partsInfoModel.stock, nil];
    }
    for (int i = 0; i < 10 ; i ++)
    {
        UITextField * contentTF = [[UITextField alloc] initWithFrame:CGRectMake(22 * myDelegate.autoSizeScaleX, (10 + (40 + 10) * i) * myDelegate.autoSizeScaleY, 331 * myDelegate.autoSizeScaleX, 40 * myDelegate.autoSizeScaleY)];
//        if (i == 4) {
//            
////            contentTF.keyboardType =UIKeyboardTypeDecimalPad;
//        }
        if (i == 9)
        {
            contentTF.frame = CGRectMake(22 * myDelegate.autoSizeScaleX, (10 + (40 + 10) * i) * myDelegate.autoSizeScaleY, 331 * myDelegate.autoSizeScaleX, 106 * myDelegate.autoSizeScaleY);
        }
        contentTF.borderStyle = UITextBorderStyleRoundedRect;
        if (i != 9)
        {
            contentTF.placeholder = placeHolderArray[i];
            contentTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 13 * myDelegate.autoSizeScaleX, contentTF.frame.size.height)];
            contentTF.leftView.backgroundColor = [UIColor clearColor];
            contentTF.leftViewMode = UITextFieldViewModeAlways;
            if (self.partsInfoModel != nil)
            {
                contentTF.text = contentArray[i];
            }
        }
        else
        {
            UITextField * picTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, contentTF.frame.size.width, 36 * myDelegate.autoSizeScaleY)];
            picTF.placeholder = @"产品图片";
            picTF.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];
            picTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 13 * myDelegate.autoSizeScaleX, picTF.frame.size.height)];
            picTF.leftView.backgroundColor = [UIColor clearColor];
            picTF.leftViewMode = UITextFieldViewModeAlways;
            picTF.tag = 30010;
            
            [contentTF addSubview:picTF];
            
            UIButton * addPicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            addPicBtn.frame = CGRectMake((13 + (97 + 5) * 0) * myDelegate.autoSizeScaleX, CGRectGetMaxY(picTF.frame), 97 * myDelegate.autoSizeScaleX, 61 * myDelegate.autoSizeScaleY);
            addPicBtn.tag = 40000 ;
            [addPicBtn addTarget:self action:@selector(openPhotoLibraryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            if (_isEditable) {
                
                [contentTF addSubview:addPicBtn];
            }
            
            
//                虚线边框
            CAShapeLayer *border = [CAShapeLayer layer];
            border.strokeColor = [CommonMethod getUsualColorWithString:@"#a0a0a0"].CGColor;
            border.fillColor = nil;
            border.path = [UIBezierPath bezierPathWithRect:addPicBtn.bounds].CGPath;
            border.frame = addPicBtn.bounds;
            border.lineWidth = 0.5;
            border.lineCap = @"square";
            border.lineDashPattern = @[@4, @2];
            [addPicBtn.layer addSublayer:border];
            
            
            UIImageView * addImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"添加"]];
            addImage.frame = CGRectMake(37.5 * myDelegate.autoSizeScaleX, 20 * myDelegate.autoSizeScaleY, 22 * myDelegate.autoSizeScaleX, 22 * myDelegate.autoSizeScaleX);
            if (_isEditable) {
                
                [addPicBtn addSubview:addImage];
            }
            
            
            for (int j = 0; j < 3; j ++)
            {
                UIImageView * selectedImageView = [[UIImageView alloc] initWithFrame:CGRectMake((13 + (97 + 5) * j) * myDelegate.autoSizeScaleX, CGRectGetMaxY(picTF.frame), 97 * myDelegate.autoSizeScaleX, 61 * myDelegate.autoSizeScaleY)];
                [contentTF addSubview:selectedImageView];
                selectedImageView.userInteractionEnabled = YES;
                if (_isEditable) {
                    
                    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openPhotoLibraryBtnClick:)];
                    [selectedImageView addGestureRecognizer:tap];
                }
                
                [self.imageArray addObject:selectedImageView];
                
                if (self.partsInfoModel != nil)
                {
                //TODO:在此处获取图片链接
//                    if (j == 0)
//                    {
                    NSArray * picArr = [self.partsInfoModel.picture componentsSeparatedByString:@"$"];
                    NSMutableArray * tempArr = [NSMutableArray arrayWithArray:picArr];
                    if (picArr.count < 3) {
                        
                        for ( int i = 0; i < 3 - picArr.count; i ++) {
                            
                            [tempArr addObject:@"0"];
                        }
                    }
                        [selectedImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kIMAGEURL,tempArr[j]]]];
                    }
                }
           // }
        }
        contentTF.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];
        contentTF.tag = 30000 + i;
        contentTF.delegate = self;
        [_bottomScrollView addSubview:contentTF];
        if (!self.isEditable)
        {
            contentTF.enabled = NO;
        }
    }
    
    UITextField * lastTopTF = [_bottomScrollView viewWithTag:30009];
    NSArray * btnTitleArray = @[@"取 消",@"提 交"];
    NSArray * btnBGColorArray = @[@"#e06e15",@"#ffa304"];
    for (int i = 0; i < 2; i ++)
    {
        UIButton * actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        actionBtn.frame = CGRectMake((22 + (150 + 31) * i) * myDelegate.autoSizeScaleX, CGRectGetMaxY(lastTopTF.frame) + 36 * myDelegate.autoSizeScaleY, 150 * myDelegate.autoSizeScaleX, 44 * myDelegate.autoSizeScaleY);
        [actionBtn setTitle:btnTitleArray[i] forState:UIControlStateNormal];
        [actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        actionBtn.backgroundColor = [CommonMethod getUsualColorWithString:btnBGColorArray[i]];
        actionBtn.tag = 50000 + i;
        [actionBtn addTarget:self action:@selector(actionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        actionBtn.layer.cornerRadius = 2;
        actionBtn.clipsToBounds = YES;
        if (!self.isEditable)
        {
            actionBtn.hidden = YES;
        }
        [_bottomScrollView addSubview:actionBtn];
    }
}
#pragma mark - ConfigData
- (void)prepareData
{
    if (self.partsInfoModel.pid == nil)
    {
        self.partsInfoModel = [HKXSupplierReleasePartsModel getUserModel];
    }
//    用户编号
    long userId = [[NSUserDefaults standardUserDefaults] doubleForKey:@"userDataId"];
    self.partsInfoModel.mid = [NSString stringWithFormat:@"%ld",userId];
//    配件编号
    UITextField * numberTF = [_bottomScrollView viewWithTag:30000];
    self.partsInfoModel.number = [numberTF.text isEqualToString:@""] ? (NSString *)[NSNull null] : numberTF.text;
//    配件品牌
    UITextField * brandTF = [_bottomScrollView viewWithTag:30001];
    self.partsInfoModel.brand = [brandTF.text isEqualToString:@""] ? (NSString *)[NSNull null] : brandTF.text;
//    配件型号
    UITextField * modelTF = [_bottomScrollView viewWithTag:30002];
    self.partsInfoModel.model = [modelTF.text isEqualToString:@""] ? (NSString *)[NSNull null] : modelTF.text;
//    配件名称
    UITextField * baseNameTF = [_bottomScrollView viewWithTag:30003];
    self.partsInfoModel.basename = [baseNameTF.text isEqualToString:@""] ? (NSString *)[NSNull null] : baseNameTF.text;
//        价格
    UITextField * tempPriceTF = [_bottomScrollView viewWithTag:30004];
    self.partsInfoModel.tempPrice = [tempPriceTF.text isEqualToString:@""] ? (NSString *)[NSNull null] : tempPriceTF.text;
//        产品描述
    UITextField * discribeTF = [_bottomScrollView viewWithTag:30005];
    self.partsInfoModel.introduct = [discribeTF.text isEqualToString:@""] ? (NSString *)[NSNull null] : discribeTF.text;
//        配件类型
    UITextField * specTF = [_bottomScrollView viewWithTag:30006];
    self.partsInfoModel.category = [specTF.text isEqualToString:@""] ? (NSString *)[NSNull null] : specTF.text;
//        适用车型
    UITextField * carStyleTF = [_bottomScrollView viewWithTag:30007];
    self.partsInfoModel.applyCareModel = [carStyleTF.text isEqualToString:@""] ? (NSString *)[NSNull null] : carStyleTF.text;
//        库存
    UITextField * stockTF = [_bottomScrollView viewWithTag:30008];
    self.partsInfoModel.stock = [stockTF.text isEqualToString:@""] ? (NSString *)[NSNull null] : stockTF.text;
    
//    图片
    _base64String = [self.imageBase64Array componentsJoinedByString:@"$"];
    self.partsInfoModel.picture = _base64String;
    
    if (self.partsInfoModel.pid == nil)
    {
        [HKXHttpRequestManager sendRequestWithSupplierReleasePartsInfoModel:self.partsInfoModel ToGetReleaseResult:^(id data) {
            HKXMineServeCertificateProfileModel * model = data;
            CustomSubmitView * customAlertView = [CustomSubmitView alertViewWithTitle:@"提示" content:model.message sure:@"确定" sureBtnClick:^{
                [self tapGestureClick];
                if (model.success)
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } WithAlertHeight:160];
            customAlertView.tag = 501;
            [self.view addSubview:customAlertView];
        }];
    }
    else
    {
        [HKXHttpRequestManager sendRequestWithSupplierUpdatePartsInfoModel:self.partsInfoModel ToGetUpdateResult:^(id data) {
            HKXMineServeCertificateProfileModel * model = data;
            CustomSubmitView * customAlertView = [CustomSubmitView alertViewWithTitle:@"提示" content:model.message sure:@"确定" sureBtnClick:^{
                [self tapGestureClick];
                if (model.success)
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } WithAlertHeight:160];
            customAlertView.tag = 501;
            [self.view addSubview:customAlertView];
        }];
    }
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
}
- (void)openPhotoLibraryBtnClick:(UIButton *)btn
{
    NSLog(@"打开系统相册");
//    for (UIImageView * imag in self.imageArray)
//    {
//        imag.image = NULL;
//    }
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
- (void)actionBtnClick:(UIButton *)btn
{
    if (btn.tag - 50000 == 0)
    {
        NSLog(@"取消");
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        NSLog(@"提交");
        [self prepareData];
//
    }
}
#pragma mark - Private Method
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
#pragma mark - Delegate & Data Source
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    UITextField * priceTF = [_bottomScrollView viewWithTag:30004];
    UITextField * storageTF = [_bottomScrollView viewWithTag:30008];
    
    if (priceTF == textField || storageTF == textField)
    {
        return [self validateNumber:string];
    }
    else
    {
        return YES;
    }
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            CustomSubmitView * customAlertView = [CustomSubmitView alertViewWithTitle:@"提示" content:@"此处应输入数字" sure:@"确定" sureBtnClick:^{
                [self tapGestureClick];
                
            } WithAlertHeight:160];
            customAlertView.tag = 501;
            [self.view addSubview:customAlertView];
            break;
        }
        i++;
    }
    return res;
}

#pragma mark - <CTAssetsPickerControllerDelegate>
- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(PHAsset *)asset
{
    NSInteger max = 3;
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
    
    //    改变因图片选择而影响底层view的frame
    UITextField * tf = [_bottomScrollView viewWithTag:30009];
    UIButton * btn = [tf viewWithTag:40000];
    UITextField * picTF = [tf viewWithTag:30010];
    if (assets.count < 3)
    {
        btn.frame = CGRectMake((13 + (97 + 5) * assets.count) * myDelegate.autoSizeScaleX, CGRectGetMaxY(picTF.frame), 97 * myDelegate.autoSizeScaleX, 61 * myDelegate.autoSizeScaleY);
    }
    else
    {
        btn.hidden = YES;
    }
    
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
            
            imageView.image = result;
            
            NSData * data = UIImageJPEGRepresentation(result, 0.3);
            NSString * dataStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            NSString * typeStr = [self contentTypeForImageData:data];
            __block NSString * imageDataString;
            imageDataString = [NSString stringWithFormat:@"data:image/%@;base64,%@",typeStr,dataStr];
            
            [self.imageBase64Array addObject:imageDataString];
            
        }];
    }
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 30009 || textField.tag == 30010)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}
#pragma mark - Setters & Getters  
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
