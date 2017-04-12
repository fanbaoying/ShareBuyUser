//
//  ServerUrl.h
//  ShareBuyUser
//
//  Created by soldier on 16/8/8.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#ifndef ServerUrl_h
#define ServerUrl_h

//发送验证码
#define DEF_URL_SendVirficationCode   @"app/userInfo/getRegCode"
//提交注册
#define DEF_URL_Register              @"app/userInfo/register"
//登录
#define DEF_URL_Login                 @"app/userInfo/login"
//获取用户信息
#define DEF_URL_GetUserInfo           @"app/userInfo/getUser"
//获取订单列表
#define DEF_URL_GetOrderList          @"app/orderInfo/getOrderInfoList"
//通过扫码获取订单详情
#define DEF_URL_GetOrderDetailByScan   @"app/orderInfo/getOrderInfoDetailByScan"
//获取首页信息
#define DEF_URL_IndexHotPage           @"app/businessInfo/indexHotPage"
//获得更多热门商户信息
#define DEF_URL_HotPage                 @"app/businessInfo/hotPage"
//获取更多热门活动
#define DEF_URL_GetActivityList         @"app/activityInfo/getActivityList"
//查询店铺分类
#define DEF_URL_FindBusiCategory       @"app/businessInfo/findBusiCategory"
//获取线上商品列表
#define DEF_URL_GetGoodsList            @"app/goodsInfo/getGoodsList"
//店铺搜索
#define DEF_URL_FindBusinessList        @"app/businessInfo/findBusiList"
//获取社区列表
#define DEF_URL_GetCommunityList      @"app/topicInfo/page"
//获取订单详情
#define DEF_URL_GetOrderDetail        @"app/orderInfo/getOrderInfoDetail"
//商铺详细页（优惠信息）
#define DEF_URL_FindBusiMess            @"app/businessInfo/findBusiMess"
//获取地址列表
#define DEF_URL_GetAddressList        @"app/userAddress/get"
//添加地址
#define DEF_URL_AddAddress            @"app/userAddress/add"
//修改地址
#define DEF_URL_EditAddress            @"app/userAddress/edit"
//查询运费模板
#define DEF_URL_FindFreightInfo        @"app/freightinfo/findFreightInfo"
//计算运费
#define DEF_URL_FindFreight             @"app/freightinfo/findFreight"
//提交订单
#define DEF_URL_CreateOrder             @"app/orderInfo/createOrder"
//取消订单
#define DEF_URL_CancelOrder             @"app/orderInfo/cancelOrder"
//忘记密码验证码
#define DEF_URL_SendForgetCode          @"app/userInfo/getForgetCode"
//修改密码
#define DEF_URL_ResetPassword           @"app/userInfo/forgetUpdatePwd"
//意见反馈
#define DEF_URL_Feedback                @"app/feedbackInfo/add"
//系统消息列表
#define DEF_URL_GetMessageInfoList     @"app/messageinfo/getMessageInfoList"
//系统消息删除
#define DEF_URL_DeleteMessage           @"app/messageinfo/deleteMsg"
//用户私信列表
#define DEF_URL_UserPrivateLetter        @"app/userPrivateLetter/page"
//用户私信删除
#define DEF_URL_DeleteUserPrivateLetter @"app/userPrivateLetter/delete"
//获取线上商品信息
#define DEF_URL_GetGoods                  @"app/goodsInfo/getGoods"
//添加用户收藏
#define DEF_URL_InsertCollection            @"app/userCollect/insertCollect"
//取消用户收藏
#define DEF_URL_DelCollect                  @"app/userCollect/delCollect"
//获取拥护收藏列表
#define DEF_URL_GetCollectList              @"app/userCollect/getCollectList"
//上传文件
#define DEF_URL_Upload                      @"app/userInfo/upload"
//修改头像
#define DEF_URL_UploadHead                 @"app/userInfo/uploadHead"
//社区帖子评论列表
#define DEF_URL_TopicAppraisePage          @"app/topicAppraise/page"
//社区添加帖子评论
#define DEF_URL_TopicAppraiseAdd          @"app/topicAppraise/add"
//社区查询帖子用户详情
#define DEF_URL_TopicAppraiseUserInfo     @"app/topicAppraise/topicAppraiseCount"
//新增用户私信
#define DEF_URL_AddUserPrivateLetter      @"app/userPrivateLetter/add"
//用户私信详情
#define DEF_URL_UserPrivateReply            @"app/userPrivateReply/page"
//用户私信回复
#define DEF_URL_AddUserPrivateReply       @"app/userPrivateReply/add"
//客服联系方式
#define DEF_URL_GetCustomerService        @"app/customerService/get"
//查询地区（市）
#define DEF_URL_FindRegion                  @"app/trendRegion/findRegion"
//余额支付
#define DEF_URL_OrderPayByBalance        @"app/orderpay/payBalance"
//社区添加帖子
#define DEF_URL_AddTopicInfo               @"app/topicInfo/add"
//修改昵称
#define DEF_URL_UpdateUserNickName        @"app/userInfo/upUserInfo"
//店铺支付生成订单
#define DEF_URL_InsertOrderBusi              @"app/businessInfo/insertOrderBusi"
//确认收货
#define DEF_URL_TakeOrder                   @"app/orderInfo/takeOrder"
//订单评价
#define DEF_URL_AppraiseOrder               @"app/orderInfo/appraiseOrder"
//申请退款
#define DEF_URL_RefundOrder                 @"app/orderInfo/refundOrder"
//上传用户轨迹
#define DEF_URL_ADDUSERRROUTES               @"app/userRoutes/add"
//获得商品评价
#define DEF_URL_GetGoodsAppraise            @"app/goodsAppraise/getGoodsAppraise"
//支付宝支付获取回调地址(线上支付)
#define DEF_URL_GetOrderPayNotifyUrl       @"app/orderpay/getOrderPayNotifyUrl"
//获取用户上传轨迹频率
#define DEF_URL_GETUSERROUTESRATE            @"app/userRoutesRate/get"
//支付宝订单支付获取回调地址 (扫码)
#define DEF_URL_GetScanOrderPayNotifyUrl        @"app/pay/getOrderPayNotifyUrl"
//支付宝支付获取回调地址(优惠付)
#define DEF_URL_BusinessOrderPayNotifyUrl   @"app/busipay/getOrderPayNotifyUrl"
//微信订单支付获取预支付交易会话标识(优惠付)
#define DEF_URL_BusinessWeChatOrderID       @"app/busipay/getWeChatOrderId"
//微信订单支付获取预支付交易会话标识(扫码)
#define DEF_URL_GetScanWeChatOrderId        @"app/pay/getWeChatOrderId"
//微信订单支付获取预支付交易会话标识(线上支付)
#define DEF_URL_GetWeChatOrderId                @"app/orderpay/getWeChatOrderId"

#endif /* ServerUrl_h */
