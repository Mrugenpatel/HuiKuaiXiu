//
//  HKXHttpRequestManager.h
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/7/4.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HKXRegisterBasicInfoModel;
@class HKXOwnerRegisterMachineModel;
@class HKXSupplierCompanyInfoModel;
@class HKXSupplierReleasePartsModel;
#import "HKXSupplierEquipmentManagementModelDataModels.h"//发布或更新新设备

@interface HKXHttpRequestManager : NSObject


/**
 根据用户账号或手机号以及用户密码获取用户登录信息

 @param userName 账号或手机号
 @param userPassword 密码
 @param complete 登录结果信息
 */
+ (void)sendRequestWithUserName:(NSString *)userName WithUserPassword:(NSString *)userPassword ToGetLoginResult:(void (^)(id data))complete;


/**
 根据手机号密码注册角色

 @param userName 手机号
 @param userPsw 密码
 @param userRole 角色类型
 @param verificationCode 验证码
 @param complete 注册结果
 */
+ (void)sendRequestWithUserName:(NSString *)userName WithUserPsw:(NSString *)userPsw WithUserRole:(NSString * )userRole WithUserVerificationCode:(NSString *)verificationCode ToGetRegisterResult:(void (^)(id data))complete;


/**
 根据用户填写的基本信息获得用户的注册结果

 @param basicInfo 用户填写的基本信息
 @param complete 用户的注册结果
 */
+ (void)sendRequestWithBasicInfo:(HKXRegisterBasicInfoModel *)basicInfo ToGetRegisterResult:(void (^)(id data))complete;


/**
 根据用户填写的手机号获得该手机号对应的验证码信息

 @param phoneNumber 用户填写的手机号
 @param complete 验证码
 */
+ (void)sendRequestWithUserPhoneNumber:(NSString *)phoneNumber ToGetVertificationCode:(void (^)(id data))complete;


/**
 根据机主填写的设备信息获得设备录入结果

 @param model 机主填写的设备信息
 @param complete 设备录入结果
 */
+ (void)sendRequestWithOwnerInfo:(HKXOwnerRegisterMachineModel *)model ToGetOwnerAddMachineResult:(void (^)(id data))complete;


/**
 根据用户账号，用户新密码以及验证码获得忘记密码结果

 @param userName 用户账号
 @param userPsw 用户新密码
 @param verificateCode 验证码
 @param complete 验证密码结果
 */
+ (void)sendRequestWithUserName:(NSString *)userName WithUserPsw:(NSString *)userPsw WithVerificateCode:(NSString *)verificateCode ToGetResetPswResult:(void (^)(id data))complete;

/**
 根据供应商公司信息录入获得供应商公司信息录入结果

 @param companyModel 供应商公司信息录入
 @param complete 录入结果
 */
+ (void)sendRequestWithSupplierCompanyInfo:(HKXSupplierCompanyInfoModel *)companyModel ToGetUpdateSupplierCompanyInfoResult:(void (^)(id data))complete;


/**
 根据服务维修师傅信息录入师傅信息

 @param companyModel 服务维修师傅信息
 @param complete 师傅信息
 */
+ (void)sendRequestWithServeInfo:(HKXSupplierCompanyInfoModel *)companyModel ToGetUpdateServeInfoResult:(void (^)(id data))complete;


/**
 根据用户id以及role获得个人信息界面

 @param userId 用户id
 @param userRole role
 @param complete 个人信息
 */
+ (void)sendRequestWithUserId:(NSString *)userId WithUserRole:(NSString *)userRole ToGetUserInfoResult:(void (^)(id data))complete;


/**
 根据用户id以及新头像base64转码获得修改头像的结果

 @param userId 用户id
 @param photoString 新头像base64转码
 @param complete 结果
 */
+ (void)sendRequestWithUserId:(NSString *)userId WithPhotoString:(NSString *)photoString ToGetUpdateImageResult:(void (^)(id data))complete;


/**
 根据用户ID获得该用户的所有证书资料

 @param userId 用户id
 @param complete 证书资料
 */
+ (void)sendRequestWithUserId:(NSString *)userId ToGetUserCertificateProfileResult:(void (^)(id data))complete;

/**
 根据供应商提供的配件信息获得发布配件的结果

 @param model 供应商提供的配件信息
 @param complete 发布配件的结果
 */
+ (void)sendRequestWithSupplierReleasePartsInfoModel:(HKXSupplierReleasePartsModel *)model ToGetReleaseResult:(void (^)(id data))complete;


/**
 根据用户id以及当前页数和当前页应有数据获得已发布的所有配件信息

 @param userId 用户id
 @param pageNum 当前页数
 @param pageSize 当前页应有数据
 @param complete 所有配件信息
 */
+ (void)sendRequestWithUserID:(NSString *)userId WithPageNum:(NSString *)pageNum WithPageSize:(NSString *)pageSize ToGetCurrentReleasedPartsInfo:(void (^)(id data))complete;
/**
 根据供应商提供的配件信息获得更新配件的结果
 
 @param model 供应商提供的配件信息
 @param complete 发布配件的结果
 */
+ (void)sendRequestWithSupplierUpdatePartsInfoModel:(HKXSupplierReleasePartsModel *)model ToGetUpdateResult:(void (^)(id data))complete;


/**
 根据供应商配件pid信息获得删除该配件结果

 @param pid 供应商配件pid信息
 @param complete 删除该配件结果
 */
+ (void)sendRequestWithSupplierPartsPid:(NSString *)pid ToGetDeleteResult:(void (^)(id data))complete;


/**
 慧快修获取整机分类接口

 @param complete 所有整机分类
 */
+ (void)sendRequestToGetAllEquipmentSpecResult:(void (^)(id data))complete;

/**
 慧快修获取整机品牌接口

 @param complete 所有整机品牌
 */
+ (void)sendRequestToGetAllEquipmentBrandResult:(void (^)(id data))complete;


/**
 根据供应商的设备信息获得发布设备的结果

 @param model 设备信息
 @param complete 发布设备的结果
 */
+ (void)sendRequestWithSupplierEquipmentInfo:(HKXSupplierEquipmentManagementData *)model ToGetReleaseEquipmentResult:(void (^)(id data))complete;


/**
 根据供应商用户id获得该供应商名下发布的所有设备信息

 @param userID 供应商用户id
 @param pageNum 当前页数
 @param pageSize 当前页含有多少条信息
 @param complete 发布的所有设备信息
 */
+ (void)sendRequestWithSupplierUserId:(NSString *)userID WithPageNum:(NSString *)pageNum WithPageSize:(NSString *)pageSize ToGetSupplierAllEquipmentInfoResult:(void (^)(id data))complete;


/**
 根据供应商名下的整机的pid获得删除该整机设备的结果

 @param pid 整机的pid
 @param complete 删除该整机设备的结果
 */
+ (void)sendRequestWithSupplierEquipmentPid:(NSString *)pid ToGetDeleteEquipmentResult:(void (^)(id data))complete;

/**
 根据供应商的设备信息获得更新设备的结果
 
 @param model 设备信息
 @param complete 更新设备的结果
 */
+ (void)sendRequestWithSupplierUpdateEquipmentInfo:(HKXSupplierEquipmentManagementData *)model ToGetUpdateEquipmentResult:(void (^)(id data))complete;

/**
 根据机主id以及当前页数和页数所含信息数量获得当前页数的所有报修设备的列表

 @param userId 机主id
 @param pageNum 当前页数
 @param pageContent 当前页数的信息量
 @param complete 所有报修设备的列表
 */
+ (void)sendRequestWithUserID:(NSString *)userId WithPageNumber:(NSString *)pageNum WithPageContent:(NSString *)pageContent ToGetAllMineOwnerRepairListResult:(void (^)(id data))complete;

/**
 根据报修单id获得该报修单应支付的费用

 @param ruoId 报修单id
 @param complete 应支付的费用
 */
+ (void)sendRequestWithRepairId:(NSString *)ruoId ToGetOwnerRepairCostResult:(void (^)(id data))complete;

/**
 根据报修单id获得机主查看该报修单详情

 @param ruoId 报修单id
 @param complete 报修单详情
 */
+ (void)sendRequestWithRuoId:(NSString *)ruoId ToGetOwnerRepairDetailResult:(void (^)(id data))complete;


/**
 根据用户id以及当前页数和当前页所含信息数获得符合条件的该维修师傅所有订单列表

 @param userID 用户id
 @param pageNo 当前页数
 @param pageSize 当前页所含信息数
 @param complete 符合条件的该维修师傅所有订单列表
 */
+ (void)sendRequestWithUserId:(NSString *)userID WithPageNo:(NSString *)pageNo WithPageSize:(NSString *)pageSize ToGetAllServerOrderListResult:(void (^)(id data))complete;

/**
 根据用户id以及当前页数和当前页所含信息数获得符合条件的该机主所有的设备列表

 @param userId 用户id
 @param pageNo 当前页数
 @param pageSize 当前页所含信息数
 @param complete 符合条件的该机主所有的设备列表
 */
+ (void)sendRequestWithUserId:(NSString *)userId WithPageNo:(NSString *)pageNo WithPageSize:(NSString *)pageSize ToGetMineOwnerAllEquipmentListResult:(void (^)(id data))complete;

/**
 根据用户id获得该用户所有商城购物车列表

 @param userId 用户id
 @param complete 该用户所有商城购物车列表
 */
+ (void)sendRequestWithUserId:(NSString *)userId ToGetAllMineShoppingCartListResult:(void (^)(id data))complete;

/**
 根据购物车商品id以及更改后的购买数量获得该商品更改购买数量之后的结果

 @param cartId 购物车商品id
 @param buyNumber 更改后的购买数量
 @param complete 该商品更改购买数量之后的结果
 */
+ (void)sendRequestWithCartId:(NSString *)cartId WithBuyNumber:(NSString *)buyNumber ToGetUpdateShoppingCartNumberResult:(void (^)(id data))complete;

/**
 根据用户id以及当前页数和当前页所含信息数获得供应商的询价列表

 @param userId 用户id
 @param pageNo 当前页数
 @param pageSize 当前页所含信息数
 @param complete 供应商的询价列表
 */
+ (void)sendRequestWithUserId:(NSString *)userId WithPageNo:(NSString *)pageNo WithPageSize:(NSString *)pageSize ToGetSupplierInquiryList:(void (^)(id data))complete;
@end
