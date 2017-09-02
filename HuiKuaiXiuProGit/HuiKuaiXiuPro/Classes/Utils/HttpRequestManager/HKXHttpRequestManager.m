//
//  HKXHttpRequestManager.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/7/4.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXHttpRequestManager.h"
#import "HKXLoginResultDataModels.h"//用户登录结果
#import "HKXRegisterResultDataModels.h"//用户注册结果
#import "HKXRegisterBasicInfoModel.h"//用户注册填写的基本信息
#import "HKXUserVertificationCodeResultModelDataModels.h"//根据用户手机获得验证码信息
#import "HKXUserLocationModelDataModels.h"//用户省市区信息
#import "HKXOwnerRegisterMachineModel.h"//机主录入设备model
#import "HKXSupplierCompanyInfoModel.h"//供应商公司信息model
#import "HKXMineOwnerInfoModelDataModels.h"//机主个人中心信息
#import "HKXMineServeInfoModelDataModels.h"//服务维修人员个人中心信息
#import "HKXMineSupplierInfoModelDataModels.h"//供应商个人中心信息
#import "HKXMineServeCertificateProfileModelDataModels.h"//服务维修人员个人中心证书资料
#import "HKXSupplierReleasePartsModel.h"//供应商发布配件model
#import "HKXSupplierPartsManagementModelDataModels.h"//配件管理界面配件信息
#import "HKXEquipmentSpecModel.h"//整机分类接口
#import "HKXMineOwnerRepairListModelDataModels.h"//个人中心机主报修设备列表model
#import "HKXMIneOwnerRepairCostModelDataModels.h"//个人中心机主报修花费model
#import "HKXMineRepairDetailModelDataModels.h"//个人中心记住查看报修设备详情model
#import "HKXMineServerOrderListModelDataModels.h"//个人中心维修师傅的订单列表model
#import "HKXMineOwnerEquipmentListModelDataModels.h"//个人中心机主设备列表model

#import "HKXMineShoppingCartListModelDataModels.h"//个人中心购物车列表
#import "HKXMineShoppingCartUpdateCartNumberModelDataModels.h"//个人中心购物车商品增加/减少model

#import "HKXMineSupplierInqiryListModelDataModels.h"//个人中心供应商询价列表
#import "HKXMineDefaultAddressExistModelDataModels.h"//个人中心默认收货地址查询
#import "HKXMineAddressListModelDataModels.h"//个人中心所有收货地址

@implementation HKXHttpRequestManager

/**
 根据用户账号或手机号以及用户密码获取用户登录信息
 
 @param userName 账号或手机号
 @param userPassword 密码
 @param complete 登录结果信息
 */
+ (void)sendRequestWithUserName:(NSString *)userName WithUserPassword:(NSString *)userPassword ToGetLoginResult:(void (^)(id data))complete
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           userName,@"username",
                           userPassword,@"password",
                           nil];
    [manager POST:kLOGINURL parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HKXLoginResult * model = [HKXLoginResult modelObjectWithDictionary:responseObject];
        complete(model);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.description);
    }];
}

/**
 根据手机号密码注册角色
 
 @param userName 手机号
 @param userPsw 密码
 @param userRole 角色类型
 @param verificationCode 验证码
 @param complete 注册结果
 */
+ (void)sendRequestWithUserName:(NSString *)userName WithUserPsw:(NSString *)userPsw WithUserRole:(NSString * )userRole WithUserVerificationCode:(NSString *)verificationCode ToGetRegisterResult:(void (^)(id data))complete
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           userName,@"username",
                           userPsw,@"password",
                           userRole,@"role",
                           verificationCode,@"number",
                           nil];
    
    [manager POST:[NSString stringWithFormat:@"%@user/register.do",kBASICURL] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HKXRegisterResult * model = [HKXRegisterResult modelObjectWithDictionary:responseObject];
        complete(model);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.description);
    }];
}
/**
 根据用户填写的基本信息获得用户的注册结果
 
 @param basicInfo 用户填写的基本信息
 @param complete 用户的注册结果
 */
+ (void)sendRequestWithBasicInfo:(HKXRegisterBasicInfoModel *)basicInfo ToGetRegisterResult:(void (^)(id data))complete
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           basicInfo.userId,@"id",
                           basicInfo.realName,@"realName",
                           basicInfo.address,@"address",
                           basicInfo.companyName,@"companyName",
                           basicInfo.inviteCode,@"inviteCode",
                           nil];
    
    [manager POST:[NSString stringWithFormat:@"%@user/updateInfo.do",kBASICURL] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HKXRegisterResult * model = [HKXRegisterResult modelObjectWithDictionary:responseObject];
        complete(model);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.description);
    }];
}

/**
 根据用户填写的手机号获得该手机号对应的验证码信息
 
 @param phoneNumber 用户填写的手机号
 @param complete 验证码
 */
+ (void)sendRequestWithUserPhoneNumber:(NSString *)phoneNumber ToGetVertificationCode:(void (^)(id data))complete
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           phoneNumber,@"username",
                           
                           nil];
    
    [manager POST:[NSString stringWithFormat:@"%@user/number.do",kBASICURL] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HKXUserVertificationCodeResultModel * model = [HKXUserVertificationCodeResultModel modelObjectWithDictionary:responseObject];
        complete(model);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.description);
    }];
}

/**
 根据机主填写的设备信息获得设备录入结果
 
 @param model 机主填写的设备信息
 @param complete 设备录入结果
 */
+ (void)sendRequestWithOwnerInfo:(HKXOwnerRegisterMachineModel *)model ToGetOwnerAddMachineResult:(void (^)(id data))complete
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           model.uId,@"uId",
                           model.nameplateNum,@"nameplateNum",
                           model.category,@"category",
                           model.brand,@"brand",
                           model.model,@"model",
                           model.buyDate,@"buyDate",
                           model.address,@"address",
                           model.parameter,@"parameter",
                           model.remarks,@"remarks",
                           model.picture,@"picture",
                           
                           nil];
    
    [manager POST:[NSString stringWithFormat:@"%@machine/add.do",kBASICURL] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HKXUserVertificationCodeResultModel * model = [HKXUserVertificationCodeResultModel modelObjectWithDictionary:responseObject];
        complete(model);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.description);
    }];
}

/**
 根据用户账号，用户新密码以及验证码获得忘记密码结果
 
 @param userName 用户账号
 @param userPsw 用户新密码
 @param verificateCode 验证码
 @param complete 验证密码结果
 */
+ (void)sendRequestWithUserName:(NSString *)userName WithUserPsw:(NSString *)userPsw WithVerificateCode:(NSString *)verificateCode ToGetResetPswResult:(void (^)(id data))complete
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           userName,@"username",
                           userPsw,@"password",
                           verificateCode,@"number",
                           
                           nil];
    
    [manager POST:[NSString stringWithFormat:@"%@user/findPass.do",kBASICURL] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HKXUserVertificationCodeResultModel * model = [HKXUserVertificationCodeResultModel modelObjectWithDictionary:responseObject];
        complete(model);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.description);
    }];
}

/**
 根据供应商公司信息录入获得供应商公司信息录入结果
 
 @param companyModel 供应商公司信息录入
 @param complete 录入结果
 */
+ (void)sendRequestWithSupplierCompanyInfo:(HKXSupplierCompanyInfoModel *)companyModel ToGetUpdateSupplierCompanyInfoResult:(void (^)(id data))complete
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           companyModel.uId,@"id",
                           companyModel.role,@"role",
                           companyModel.realName,@"realName",
                           companyModel.companyName,@"companyName",
                           companyModel.companyAddress,@"address",
                           companyModel.registerCapital,@"registerCapital",
                           companyModel.establishmentTime,@"establishmentTime",
                           companyModel.companyIntroduce,@"companyIntroduce",
                           companyModel.companyMain,@"companyMain",
                           
                           
                           nil];
    
    [manager POST:[NSString stringWithFormat:@"%@info/supplier.do",kBASICURL] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HKXUserVertificationCodeResultModel * model = [HKXUserVertificationCodeResultModel modelObjectWithDictionary:responseObject];
        complete(model);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.description);
    }];
}

/**
 根据服务维修师傅信息录入师傅信息
 
 @param companyModel 服务维修师傅信息
 @param complete 师傅信息
 */
+ (void)sendRequestWithServeInfo:(HKXSupplierCompanyInfoModel *)companyModel ToGetUpdateServeInfoResult:(void (^)(id data))complete
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           companyModel.uId,@"id",
                           companyModel.role,@"role",
                           companyModel.realName,@"photo",
                           companyModel.companyAddress,@"idCode",
                           companyModel.companyName,@"majorMachine",
                           companyModel.registerCapital,@"profile",
                           companyModel.establishmentTime,@"img",
    
                           nil];
    NSLog(@"------%@",dict);
    [manager POST:[NSString stringWithFormat:@"%@info/repair.do",kBASICURL] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HKXUserVertificationCodeResultModel * model = [HKXUserVertificationCodeResultModel modelObjectWithDictionary:responseObject];
        complete(model);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.description);
    }];
}

/**
 根据用户id以及role获得个人信息界面
 
 @param userId 用户id
 @param userRole role
 @param complete 个人信息
 */
+ (void)sendRequestWithUserId:(NSString *)userId WithUserRole:(NSString *)userRole ToGetUserInfoResult:(void (^)(id data))complete
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           userId,@"id",
                           
                           nil];
    
    [manager POST:[NSString stringWithFormat:@"%@info/information.do",kBASICURL] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([userRole isEqualToString:@"0"])
        {
            HKXMineOwnerInfoModel * model = [HKXMineOwnerInfoModel modelObjectWithDictionary:responseObject];
            
            complete(model);
        }
        if ([userRole isEqualToString:@"1"])
        {
            HKXMineServeInfoModel * model = [HKXMineServeInfoModel modelObjectWithDictionary:responseObject];
            complete(model);
        }
        if ([userRole isEqualToString:@"2"])
        {
            HKXMineSupplierInfoModel * model = [HKXMineSupplierInfoModel modelObjectWithDictionary:responseObject];
            complete(model);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.description);
    }];
}


/**
 根据用户id以及新头像base64转码获得修改头像的结果
 
 @param userId 用户id
 @param photoString 新头像base64转码
 @param complete 结果
 */
+ (void)sendRequestWithUserId:(NSString *)userId WithPhotoString:(NSString *)photoString ToGetUpdateImageResult:(void (^)(id data))complete
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           userId,@"id",
                           photoString,@"photo",
                           
                           nil];
    [manager POST:[NSString stringWithFormat:@"%@info/photo.do",kBASICURL] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HKXUserVertificationCodeResultModel * model = [HKXUserVertificationCodeResultModel modelObjectWithDictionary:responseObject];
        complete(model);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.description);
    }];
}

/**
 根据用户ID获得该用户的所有证书资料
 
 @param userId 用户id
 @param complete 证书资料
 */
+ (void)sendRequestWithUserId:(NSString *)userId ToGetUserCertificateProfileResult:(void (^)(id data))complete
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           userId,@"id",
                           
                           
                           nil];
    [manager POST:[NSString stringWithFormat:@"%@info/credentials.do",kBASICURL] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HKXMineServeCertificateProfileModel * model = [HKXMineServeCertificateProfileModel modelObjectWithDictionary:responseObject];
        complete(model);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.description);
    }];
}

/**
 根据供应商提供的配件信息获得发布配件的结果
 
 @param model 供应商提供的配件信息
 @param complete 发布配件的结果
 */
+ (void)sendRequestWithSupplierReleasePartsInfoModel:(HKXSupplierReleasePartsModel *)model ToGetReleaseResult:(void (^)(id data))complete
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           model.mid,@"mId",
                           model.number,@"number",
                           model.brand,@"brand",
                           model.basename,@"basename",
                           model.model,@"model",
                           model.tempPrice,@"tempPrice",
                           model.introduct,@"introduct",
                           model.picture,@"picture",
                           model.category,@"category",
                           model.applyCareModel,@"applyCareModel",
                           model.stock,@"stock",
                           
                           
                           nil];
    [manager POST:[NSString stringWithFormat:@"%@supplierbase/addProductBase.do",kBASICURL] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HKXMineServeCertificateProfileModel * model = [HKXMineServeCertificateProfileModel modelObjectWithDictionary:responseObject];
        complete(model);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.description);
    }];
}

/**
 根据用户id以及当前页数和当前页应有数据获得已发布的所有配件信息
 
 @param userId 用户id
 @param pageNum 当前页数
 @param pageSize 当前页应有数据
 @param complete 所有配件信息
 */
+ (void)sendRequestWithUserID:(NSString *)userId WithPageNum:(NSString *)pageNum WithPageSize:(NSString *)pageSize ToGetCurrentReleasedPartsInfo:(void (^)(id data))complete
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           userId,@"mId",
                           @"1",@"pageNo",
                           [NSString stringWithFormat:@"%d",INT_MAX],@"pageSize",
                           
                           
                           nil];
    [manager POST:[NSString stringWithFormat:@"%@supplierbase/queryBaseByMId.do",kBASICURL] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HKXSupplierPartsManagementModel * model = [HKXSupplierPartsManagementModel modelObjectWithDictionary:responseObject];
        complete(model);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.description);
    }];
}

/**
 根据供应商提供的配件信息获得更新配件的结果
 
 @param model 供应商提供的配件信息
 @param complete 发布配件的结果
 */
+ (void)sendRequestWithSupplierUpdatePartsInfoModel:(HKXSupplierReleasePartsModel *)model ToGetUpdateResult:(void (^)(id data))complete
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           model.mid,@"mId",
                           model.number,@"number",
                           model.brand,@"brand",
                           model.basename,@"basename",
                           model.model,@"model",
                           model.tempPrice,@"tempPrice",
                           model.introduct,@"introduct",
                           model.picture,@"picture",
                           model.category,@"category",
                           model.applyCareModel,@"applyCareModel",
                           model.stock,@"stock",
                           model.pid,@"pId",
                           
                           nil];
    [manager POST:[NSString stringWithFormat:@"%@supplierbase/updateProductBase.do",kBASICURL] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HKXMineServeCertificateProfileModel * model = [HKXMineServeCertificateProfileModel modelObjectWithDictionary:responseObject];
        complete(model);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.description);
    }];
}
/**
 根据供应商配件pid信息获得删除该配件结果
 
 @param pid 供应商配件pid信息
 @param complete 删除该配件结果
 */
+ (void)sendRequestWithSupplierPartsPid:(NSString *)pid ToGetDeleteResult:(void (^)(id data))complete
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           pid,@"pId",
                           
                           nil];
    [manager POST:[NSString stringWithFormat:@"%@supplierbase/delBaseById.do",kBASICURL] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HKXMineServeCertificateProfileModel * model = [HKXMineServeCertificateProfileModel modelObjectWithDictionary:responseObject];
        complete(model);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.description);
    }];
}

/**
 慧快修获取整机分类接口
 
 @param complete 所有整机分类
 */
+ (void)sendRequestToGetAllEquipmentSpecResult:(void (^)(id data))complete
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:[NSString stringWithFormat:@"%@category/machine.do",kBASICURL] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HKXEquipmentSpecModel * model = [HKXEquipmentSpecModel modelObjectWithDictionary:responseObject];
        complete(model);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.description);
    }];
}

/**
 慧快修获取整机品牌接口
 
 @param complete 所有整机品牌
 */
+ (void)sendRequestToGetAllEquipmentBrandResult:(void (^)(id data))complete
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:[NSString stringWithFormat:@"%@brand/machine.do",kBASICURL] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HKXEquipmentSpecModel * model = [HKXEquipmentSpecModel modelObjectWithDictionary:responseObject];
        complete(model);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.description);
    }];
}

/**
 根据供应商的设备信息获得发布设备的结果
 
 @param model 设备信息
 @param complete 发布设备的结果
 */
+ (void)sendRequestWithSupplierEquipmentInfo:(HKXSupplierEquipmentManagementData *)model ToGetReleaseEquipmentResult:(void (^)(id data))complete
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSString stringWithFormat:@"%ld",model.mId],@"mId",
                           model.picture,@"picture",
                           model.type,@"type",
                           model.brand,@"brand",
                           model.modelnum,@"modelnum",
                           model.parameter,@"parameter",
                           model.compname,@"compname",
                           model.bewrite,@"bewrite",
                           
                           
                           nil];
    
    [manager POST:[NSString stringWithFormat:@"%@supplier/addProductMachine.do",kBASICURL] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HKXEquipmentSpecModel * model = [HKXEquipmentSpecModel modelObjectWithDictionary:responseObject];
        complete(model);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.description);
    }];
}

/**
 根据供应商用户id获得该供应商名下发布的所有设备信息
 
 @param userID 供应商用户id
 @param pageNum 当前页数
 @param pageSize 当前页含有多少条信息
 @param complete 发布的所有设备信息
 */
+ (void)sendRequestWithSupplierUserId:(NSString *)userID WithPageNum:(NSString *)pageNum WithPageSize:(NSString *)pageSize ToGetSupplierAllEquipmentInfoResult:(void (^)(id data))complete
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           userID,@"mId",
                           @"1",@"pageNo",
                           [NSString stringWithFormat:@"%d",INT_MAX],@"pageSize",
                           
                           
                           nil];
    [manager POST:[NSString stringWithFormat:@"%@supplier/queryMachineById.do",kBASICURL] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HKXSupplierEquipmentManagementModel * model = [HKXSupplierEquipmentManagementModel modelObjectWithDictionary:responseObject];
        complete(model);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.description);
    }];
}

/**
 根据供应商名下的整机的pid获得删除该整机设备的结果
 
 @param pid 整机的pid
 @param complete 删除该整机设备的结果
 */
+ (void)sendRequestWithSupplierEquipmentPid:(NSString *)pid ToGetDeleteEquipmentResult:(void (^)(id data))complete
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           
                           pid,@"pmaid",
                           
                           
                           nil];
    
    [manager POST:[NSString stringWithFormat:@"%@supplier/delMachineByPmaId.do",kBASICURL] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HKXMineServeCertificateProfileModel * model = [HKXMineServeCertificateProfileModel modelObjectWithDictionary:responseObject];
        complete(model);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.description);
    }];
}

/**
 根据供应商的设备信息获得更新设备的结果
 
 @param model 设备信息
 @param complete 更新设备的结果
 */
+ (void)sendRequestWithSupplierUpdateEquipmentInfo:(HKXSupplierEquipmentManagementData *)model ToGetUpdateEquipmentResult:(void (^)(id data))complete
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSString stringWithFormat:@"%ld",model.mId],@"mId",
                           model.picture,@"picture",
                           model.type,@"type",
                           model.brand,@"brand",
                           model.modelnum,@"modelnum",
                           model.parameter,@"parameter",
                           model.compname,@"compname",
                           model.bewrite,@"bewrite",
                           [NSString stringWithFormat:@"%d",model.pmaId],@"pmaId",
                           
                           nil];
    
    [manager POST:[NSString stringWithFormat:@"%@supplier/updateProductMachine.do",kBASICURL] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HKXEquipmentSpecModel * model = [HKXEquipmentSpecModel modelObjectWithDictionary:responseObject];
        complete(model);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.description);
    }];
}

/**
 根据机主id以及当前页数和页数所含信息数量获得当前页数的所有报修设备的列表
 
 @param userId 机主id
 @param pageNum 当前页数
 @param pageContent 当前页数的信息量
 @param complete 所有报修设备的列表
 */
+ (void)sendRequestWithUserID:(NSString *)userId WithPageNumber:(NSString *)pageNum WithPageContent:(NSString *)pageContent ToGetAllMineOwnerRepairListResult:(void (^)(id data))complete
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           userId,@"uId",
                           @"1",@"pageNo",
                           [NSString stringWithFormat:@"%d",INT_MAX],@"pageSize",
                           
                           
                           nil];
    
    [manager POST:[NSString stringWithFormat:@"%@repair/ruoList.do",kBASICURL] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HKXMineOwnerRepairListModel * model = [HKXMineOwnerRepairListModel modelObjectWithDictionary:responseObject];
        complete(model);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.description);
    }];
}

/**
 根据报修单id获得该报修单应支付的费用
 
 @param ruoId 报修单id
 @param complete 应支付的费用
 */
+ (void)sendRequestWithRepairId:(NSString *)ruoId ToGetOwnerRepairCostResult:(void (^)(id data))complete
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           ruoId,@"ruoId",
                           nil];
    [manager POST:[NSString stringWithFormat:@"%@repair/ruoCost.do",kBASICURL] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HKXMIneOwnerRepairCostModel * model = [HKXMIneOwnerRepairCostModel modelObjectWithDictionary:responseObject];
        complete(model);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.description);
    }];
}

/**
 根据报修单id获得机主查看该报修单详情
 
 @param ruoId 报修单id
 @param complete 报修单详情
 */
+ (void)sendRequestWithRuoId:(NSString *)ruoId ToGetOwnerRepairDetailResult:(void (^)(id data))complete
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           ruoId,@"ruoId",
                           nil];
    [manager POST:[NSString stringWithFormat:@"%@repair/ruodetail.do",kBASICURL] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HKXMineRepairDetailModel * model = [HKXMineRepairDetailModel modelObjectWithDictionary:responseObject];
        complete(model);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.description);
    }];
}

/**
 根据用户id以及当前页数和当前页所含信息数获得符合条件的该维修师傅所有订单列表
 
 @param userID 用户id
 @param pageNo 当前页数
 @param pageSize 当前页所含信息数
 @param complete 符合条件的该维修师傅所有订单列表
 */
+ (void)sendRequestWithUserId:(NSString *)userID WithPageNo:(NSString *)pageNo WithPageSize:(NSString *)pageSize ToGetAllServerOrderListResult:(void (^)(id data))complete
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           userID,@"uId",
                           @"1",@"pageNo",
                           [NSString stringWithFormat:@"%d",INT_MAX],@"pageSize",
                           
                           
                           nil];
    
    [manager POST:[NSString stringWithFormat:@"%@repair/repairRuoList.do",kBASICURL] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HKXMineServerOrderListModel * model = [HKXMineServerOrderListModel modelObjectWithDictionary:responseObject];
        complete(model);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.description);
    }];
}
/**
 根据用户id以及当前页数和当前页所含信息数获得符合条件的该机主所有的设备列表
 
 @param userId 用户id
 @param pageNo 当前页数
 @param pageSize 当前页所含信息数
 @param complete 符合条件的该机主所有的设备列表
 */
+ (void)sendRequestWithUserId:(NSString *)userId WithPageNo:(NSString *)pageNo WithPageSize:(NSString *)pageSize ToGetMineOwnerAllEquipmentListResult:(void (^)(id data))complete
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           userId,@"id",
                           @"1",@"pageNo",
                           [NSString stringWithFormat:@"%d",INT_MAX],@"pageSize",
                           
                           
                           nil];

    [manager POST:[NSString stringWithFormat:@"%@machine/list.do",kBASICURL] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HKXMineOwnerEquipmentListModel * model = [HKXMineOwnerEquipmentListModel modelObjectWithDictionary:responseObject];
        
        complete(model);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.description);
    }];
}
/**
 根据用户id获得该用户所有商城购物车列表
 
 @param userId 用户id
 @param complete 该用户所有商城购物车列表
 */
+ (void)sendRequestWithUserId:(NSString *)userId ToGetAllMineShoppingCartListResult:(void (^)(id data))complete
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           userId,@"buymid",
                           nil];
    
    [manager POST:[NSString stringWithFormat:@"%@shopcart/synShopCartLis.do",kBASICURL] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HKXMineShoppingCartListModel * model = [HKXMineShoppingCartListModel modelObjectWithDictionary:responseObject];
        
        complete(model);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.description);
    }];
}
/**
 根据购物车商品id以及更改后的购买数量获得该商品更改购买数量之后的结果
 
 @param cartId 购物车商品id
 @param buyNumber 更改后的购买数量
 @param complete 该商品更改购买数量之后的结果
 */
+ (void)sendRequestWithCartId:(NSString *)cartId WithBuyNumber:(NSString *)buyNumber ToGetUpdateShoppingCartNumberResult:(void (^)(id data))complete
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           cartId,@"cartid",
                           buyNumber,@"buynumber",
                           nil];
    
    [manager POST:[NSString stringWithFormat:@"%@shopcart/synUpdateShopCart.do",kBASICURL] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HKXMineShoppingCartUpdateCartNumberModel * model = [HKXMineShoppingCartUpdateCartNumberModel modelObjectWithDictionary:responseObject];
        
        complete(model);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.description);
    }];
}
/**
 根据用户id以及当前页数和当前页所含信息数获得供应商的询价列表
 
 @param userId 用户id
 @param pageNo 当前页数
 @param pageSize 当前页所含信息数
 @param complete 供应商的询价列表
 */
+ (void)sendRequestWithUserId:(NSString *)userId WithPageNo:(NSString *)pageNo WithPageSize:(NSString *)pageSize ToGetSupplierInquiryList:(void (^)(id data))complete
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           userId,@"uId",
                           pageNo,@"pageNo",
                           pageSize,@"pageSize",
                           nil];
    [manager POST:[NSString stringWithFormat:@"%@inquiry/InquiryBySupplierId.do",kBASICURL] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HKXMineSupplierInqiryListModel * model = [HKXMineSupplierInqiryListModel modelObjectWithDictionary:responseObject];
        
        complete(model);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.description);
    }];
}

/**
 根据用户id查询该用户默认收货地址是否存在
 
 @param userId 用户id
 @param complete 该用户默认收货地址是否存在
 */
+ (void)sendRequestWithUserId:(NSString *)userId ToGetMineDefaultAddressExistResult:(void (^)(id data))complete
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           userId,@"uId",
                           
                           nil];
    [manager POST:[NSString stringWithFormat:@"%@useradd/selectdefault.do",kBASICURL] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HKXMineDefaultAddressExistModel * model = [HKXMineDefaultAddressExistModel modelObjectWithDictionary:responseObject];
        
        complete(model);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.description);
    }];
}

/**
 根据用户id增加该用户的收货地址
 
 @param userId 用户id
 @param userName 收货人姓名
 @param userTel 收货人电话
 @param userAdd 收货人地址
 @param complete 增加地址的结果
 */
+ (void)sendRequestWithUserId:(NSString *)userId WithUserName:(NSString *)userName WithUserTel:(NSString *)userTel WithUserAdd:(NSString *)userAdd ToGetAddNewAddResult:(void (^)(id data))complete
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           userId,@"uId",
                           userName,@"consignees",
                           userAdd,@"consigneesAdd",
                           userTel,@"consigneesTel",
                           nil];
    [manager POST:[NSString stringWithFormat:@"%@useradd/add.do",kBASICURL] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HKXMineServeCertificateProfileModel * model = [HKXMineServeCertificateProfileModel modelObjectWithDictionary:responseObject];
        
        complete(model);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.description);
    }];
}

/**
 根据用户id获得该用户所有收货地址
 
 @param userId 用户id
 @param complete 该用户所有收货地址
 */
+ (void)sendRequestWithUserId:(NSString *)userId ToGetMineAllConsigneeAddressListResult:(void (^)(id data))complete
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           userId,@"uId",
                           
                           nil];
    [manager POST:[NSString stringWithFormat:@"%@useradd/selectList.do",kBASICURL] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HKXMineAddressListModel * model = [HKXMineAddressListModel modelObjectWithDictionary:responseObject];
        
        complete(model);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.description);
    }];
}
/**
 根据用户id修改该用户的收货地址
 
 @param userId 用户id
 @param userName 收货人姓名
 @param userTel 收货人电话
 @param userAdd 收货人地址
 @param complete 增加地址的结果
 */
+ (void)sendRequestWithUserId:(NSString *)userId WithUserName:(NSString *)userName WithUserTel:(NSString *)userTel WithUserAdd:(NSString *)userAdd ToGetUpdateAddResult:(void (^)(id data))complete
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           userId,@"addId",
                           userName,@"consignees",
                           userAdd,@"consigneesAdd",
                           userTel,@"consigneesTel",
                           nil];
    
    [manager POST:[NSString stringWithFormat:@"%@useradd/updateAdd.do",kBASICURL] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HKXMineServeCertificateProfileModel * model = [HKXMineServeCertificateProfileModel modelObjectWithDictionary:responseObject];
        
        complete(model);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.description);
    }];
}

/**
 根据收货地址id和用户id获得修改默认收货地址的结果
 
 @param addId 收货地址id
 @param userId 用户id
 @param complete 修改默认收货地址的结果
 */
+ (void)sendRequestWithAddId:(NSString *)addId WithUserId:(NSString *)userId ToGetMineUpdateDefaultAddressResult:(void (^)(id data))complete
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           addId,@"addId",
                           userId,@"uId",
                           nil];
    
    [manager POST:[NSString stringWithFormat:@"%@useradd/updatedefault.do",kBASICURL] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HKXMineServeCertificateProfileModel * model = [HKXMineServeCertificateProfileModel modelObjectWithDictionary:responseObject];
        
        complete(model);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.description);
    }];
}
/**
 根据购物车商品id获得删除该商品的结果
 
 @param goodsId 商品id
 @param complete 删除结果
 */
+ (void)sendRequestWithGoodsId:(NSString * )goodsId ToGetMineDeleteCartGoodsResult:(void (^)(id data))complete
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           goodsId,@"carid",
                           nil];
    
    [manager POST:[NSString stringWithFormat:@"%@shopcart/syndelecpById.do",kBASICURL] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HKXMineServeCertificateProfileModel * model = [HKXMineServeCertificateProfileModel modelObjectWithDictionary:responseObject];
        
        complete(model);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.description);
    }];
}
@end
