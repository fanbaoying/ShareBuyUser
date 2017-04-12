//
//  BaseWebViewController.m
//  ShareBuyUser
//
//  Created by soldier on 16/8/18.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "BaseWebViewController.h"
#import "FillOrderViewController.h"
#import "GoodsCommentViewController.h"

@interface BaseWebViewController ()

@property (nonatomic, assign) NSInteger number;
@property (nonatomic, strong) NSMutableArray *localCartGoodsArray;
@property (nonatomic, strong) NSMutableDictionary *localCartDic;            //本地购物车数据
@property (nonatomic, strong) NSString *isColleciton;               //是否收藏

@end

@implementation BaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.webView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([_webUrlStr length] != 0) {
        [self setTitle:@"商品详情"];
        _number = 1;
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webUrlStr]]];
        [self.view addSubview:self.bottomView];
        [_webView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight -kNavigationBarHight-45)];
        self.navigationItem.rightBarButtonItem = self.shareBarBtnItem;
        [self getGoodsInfoRequest];
    }
    if ([_htmlString length] != 0) {
        [_webView loadHTMLString:_htmlString baseURL:nil];
        [_webView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight -kNavigationBarHight)];
    }
}

- (UIWebView *)webView
{
    if (!_webView) {
        _webView = ({
            UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight -kNavigationBarHight)];
            [webView setBackgroundColor:[UIColor clearColor]];
            [webView setDelegate:self];
            
            webView;
        });
    }
    return _webView;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-kNavigationBarHight-45, kScreenWidth, 45)];
            [view setBackgroundColor:[UIColor whiteColor]];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
            [lineView setBackgroundColor:UIColorFromHex(0xcccccc, 1)];
            [view addSubview:lineView];
            
            NSArray *titleArray = @[@"收藏",@"加入购物车",@"立即购买"];
            for (int i = 0; i<[titleArray count]; i++) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setFrame:CGRectMake(i*kScreenWidth/3, 0, kScreenWidth/3, 45)];
                [button setTag:(100+i)];
                [button setTitle:titleArray[i] forState:UIControlStateNormal];
                button.titleLabel.font = UIFontPingFangMedium(14.0f);
                [button addTarget:self action:@selector(clickGoodsDetailFunction:) forControlEvents:UIControlEventTouchUpInside];
                switch (i) {
                    case 0:
                        [button setBackgroundColor:[UIColor clearColor]];
                        [button setTitleColor:UIColorFromHex(0x696969, 1) forState:UIControlStateNormal];
                        [button setImage:[UIImage imageNamed:@"good_collection"] forState:UIControlStateNormal];
//                        [button setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
                        break;
                    case 1:
                        [button setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(0xfdac9d, 1) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
                        [button setImage:[UIImage imageNamed:@"good_shopcart"] forState:UIControlStateNormal];
//                        [button setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
                        break;
                    case 2:
                        [button setBackgroundImage:[UIImage imageWithColor:kMainColor size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
                        break;
                        
                    default:
                        break;
                }
                [view addSubview:button];
            }
            
            view;
        });
    }
    return _bottomView;
}

- (UIBarButtonItem *)shareBarBtnItem
{
    if (!_shareBarBtnItem) {
        _shareBarBtnItem = ({
            UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"good_share"] style:UIBarButtonItemStylePlain target:self action:@selector(clickShareBtn:)];
            
            barButtonItem;
        });
    }
    return _shareBarBtnItem;
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *jsCode = [NSString stringWithFormat:@"set(%ld);",_number];
    [_webView stringByEvaluatingJavaScriptFromString:jsCode];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = [[request URL] absoluteString];
    NSArray *urlComps = [urlString componentsSeparatedByString:@"://"];
    if([urlComps count] && [[urlComps objectAtIndex:0] isEqualToString:@"objc"])
    {
        NSArray *arrFucnameAndParameter = [(NSString*)[urlComps objectAtIndex:1] componentsSeparatedByString:@":/"];
        NSString *funcStr = [arrFucnameAndParameter objectAtIndex:0];
        if (1 == [arrFucnameAndParameter count])
        {
            // 没有参数
            if([funcStr isEqualToString:@"doJia"])
            {
                /*调用本地函数*/
                [self numPlus];
            }
            if([funcStr isEqualToString:@"doJian"])
            {
                /*调用本地函数*/
                [self numMinus];
            }
            if([funcStr isEqualToString:@"doMore"])
            {
                /*调用本地函数*/
                [self clickMore];
            }
        }
        else if(2 == [arrFucnameAndParameter count])
        {
            //有参数的
            if([funcStr isEqualToString:@"tkjh:"] && [arrFucnameAndParameter objectAtIndex:1])
            {
                /*调用本地函数*/
            }
        }
        return NO;
    };
    return YES;
}

#pragma mark - UIButton Action
- (void)clickGoodsDetailFunction:(UIButton *)sender
{
    switch (sender.tag) {
        case 100:
            NSLog(@"收藏商品");
            if (![UserModel ifLogin]) {
                [self presentViewController:[[BaseNavController alloc] initWithRootViewController:[LoginViewController new]] animated:YES completion:^{
                }];
                return;
            }
            
            if ([_isColleciton integerValue] == 0) {
                NSLog(@"发送收藏请求");
                [self insertCollectionRequest];
            }else
            {
                NSLog(@"发送取消收藏请求");
                [self deleteCollectionRequest];
            }
            break;
        case 101:
            NSLog(@"加入购物车");
            
            if (![UserModel ifLogin]) {
                [self presentViewController:[[BaseNavController alloc] initWithRootViewController:[LoginViewController new]] animated:YES completion:^{
                }];
                return;
            }
        {
            //判断本地购物车中，是否有该商品。如有，数量变化；未有，新增商品
            BOOL isHaveGood = NO;
            for (int j = 0; j<[_localCartGoodsArray count]; j++) {
                if ([_goodsDic[@"goodsid"] isEqual:_localCartGoodsArray[j][@"goodsInfo"][@"goodsid"]]) {
                    NSLog(@"存在该商品");
                    NSLog(@"%ld",_number+[_localCartGoodsArray[j][@"goodsNum"] integerValue]);
                    [_localCartGoodsArray[j] setValue:[NSString stringWithFormat:@"%ld",_number+[_localCartGoodsArray[j][@"goodsNum"] integerValue]] forKey:@"goodsNum"];
                    [_localCartGoodsArray[j] setValue:@"1" forKey:@"isCheck"];
                    isHaveGood = YES;
                }
            }
            if (!isHaveGood) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setValue:_goodsDic forKey:@"goodsInfo"];
                [dic setValue:[NSString stringWithFormat:@"%ld",_number] forKey:@"goodsNum"];
                [dic setValue:@"1" forKey:@"isCheck"];
                [_localCartGoodsArray addObject:dic];
            }
            
            [self updateLocationCart];
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"加入购物车成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:^{
                
            }];
        }
            break;
        case 102:
            if (![UserModel ifLogin]) {
                [self presentViewController:[[BaseNavController alloc] initWithRootViewController:[LoginViewController new]] animated:YES completion:^{
                }];
                return;
            }
            
            NSLog(@"立即购买");
        {
            FillOrderViewController *writeOrderVC = [[FillOrderViewController alloc] init];
            writeOrderVC.orderType = @"1";
            writeOrderVC.isShopCartOrder = NO;
            NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:_goodsDic, @"goodsInfo", @(_number), @"goodsNum", nil];
            NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:_goodsDic[@"businessid"], @"businessid", @[dic1], @"goodsArray", nil];
            writeOrderVC.goodsArray = [@[dic2] mutableCopy];
            [self.navigationController pushViewController:writeOrderVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UIButton Action
- (void)clickShareBtn:(UIButton *)sender
{
    NSLog(@"分享……");
    if (![UserModel ifLogin]) {
        [self presentViewController:[[BaseNavController alloc] initWithRootViewController:[LoginViewController new]] animated:YES completion:^{
        }];
        return;
    }
    
    //分享的url
    [_webUrlStr substringToIndex:_webUrlStr.length - 9];
}

//数量加
- (void)numPlus
{
    NSLog(@"js调用本地不带参数的方法成功！");
    _number++;
    NSString *jsCode = [NSString stringWithFormat:@"set(%ld);",_number];
    [_webView stringByEvaluatingJavaScriptFromString:jsCode];
}

//数量减
- (void)numMinus
{
    NSLog(@"js调用本地不带参数的方法成功！");
    if (_number == 1) {
        return;
    }
    _number--;
    NSString *jsCode = [NSString stringWithFormat:@"set(%ld);",_number];
    [_webView stringByEvaluatingJavaScriptFromString:jsCode];
}
//加载更多评论
-(void)clickMore
{
    NSLog(@"加载更多");
    GoodsCommentViewController *goodsCommentVC = [[GoodsCommentViewController alloc] init];
    goodsCommentVC.goodsID = _goodsDic[@"goodsid"];
    [self.navigationController pushViewController:goodsCommentVC animated:YES];
}


//获取购物车中数据
- (void)getLocalShoppingCart
{
    self.localCartGoodsArray = [NSMutableArray array];
    if ([ReadWriteSandbox propertyFileExists:ShopCart_File_Path]) {
        self.localCartDic = [NSMutableDictionary dictionaryWithDictionary:[ReadWriteSandbox readPropertyFile:ShopCart_File_Path]];
        NSArray *cartArray = [ReadWriteSandbox readPropertyFile:ShopCart_File_Path][@"data"];
        for (int i = 0; i<[cartArray count]; i++) {
            if ([cartArray[i][@"userToken"] isEqual:[UserModel shareUserModel].userToken] && [cartArray[i][@"businessid"] isEqual:_goodsDic[@"businessid"]]) {
                [self.localCartGoodsArray addObjectsFromArray:cartArray[i][@"goodsArray"]];
            }
        }
    }
}

//更新本地购物车数据
- (void)updateLocationCart
{
    //如果存在购物车plist, 更新或新增数据；如果未存在plist, 创建plist, 并新增数据
    if ([ReadWriteSandbox propertyFileExists:ShopCart_File_Path]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[ReadWriteSandbox readPropertyFile:ShopCart_File_Path]];
        NSMutableArray *cartArray = [NSMutableArray arrayWithArray:dic[@"data"]];
        BOOL isHaveUserID = NO;
        for (int i = 0; i<[cartArray count]; i++) {
            if ([cartArray[i][@"userToken"] isEqual:[UserModel shareUserModel].userToken] && [_goodsDic[@"businessid"] isEqual:cartArray[i][@"businessid"]]) {
                isHaveUserID = YES;
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:cartArray[i]];
                [dict setValue:_localCartGoodsArray forKey:@"goodsArray"];
                [cartArray replaceObjectAtIndex:i withObject:dict];
            }
        }
        //如果没有该userid下的数据，新增购物车数据
        if (!isHaveUserID) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:[UserModel shareUserModel].userToken forKey:@"userToken"];
            [dict setValue:_localCartGoodsArray forKey:@"goodsArray"];
            [dict setValue:_goodsDic[@"businessid"] forKey:@"businessid"];
            [cartArray addObject:dict];
        }
        
        [dic setValue:cartArray forKey:@"data"];
        [ReadWriteSandbox writePropertyFile:dic FilePath:ShopCart_File_Path];
    }else
    {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSMutableArray *cartArray = [NSMutableArray array];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:[UserModel shareUserModel].userToken forKey:@"userToken"];
        [dict setValue:_localCartGoodsArray forKey:@"goodsArray"];
        [dict setValue:_goodsDic[@"businessid"] forKey:@"businessid"];
        [cartArray addObject:dict];
        
        [dic setValue:cartArray forKey:@"data"];
        [ReadWriteSandbox writePropertyFile:dic FilePath:ShopCart_File_Path];
    }
}

//商品是否收藏 (获得线上商品详情)
- (void)getGoodsInfoRequest
{
    NSDictionary *dict = @{@"token":[UserModel shareUserModel].userToken,@"goodsid":_goodsId};
    [DDPBLL requestWithURL:DEF_URL_GetGoods  Dict:dict result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@",responseDict);
        if (responseDict == nil) {
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue] == 0) {
            NSLog(@"商品详情请求成功,0未收藏，1已收藏");
            _isColleciton = [NSString stringWithFormat:@"%@",responseDict[@"data"][@"collection"]];
            _goodsDic = [NSMutableDictionary dictionaryWithDictionary:responseDict[@"data"][@"goodsInfo"]];

            UIButton *button = (UIButton *)[self.view viewWithTag:100];
            if ([responseDict[@"data"][@"collection"] integerValue] == 0) {
                [button setImage:[UIImage imageNamed:@"good_collection"] forState:UIControlStateNormal];
            }else
            {
                [button setImage:[UIImage imageNamed:@"good_collectioned"] forState:UIControlStateNormal];
            }
            
            [self getLocalShoppingCart];

        }
        else{
            [self showHint:responseDict[@"msg"]];
        }
    }];
}

//取消收藏 
- (void)deleteCollectionRequest
{
    NSDictionary *dict = @{@"token":[UserModel shareUserModel].userToken,@"goodsid":_goodsDic[@"goodsid"]};
    [DDPBLL requestWithURL:DEF_URL_DelCollect  Dict:dict result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@",responseDict);
        if (responseDict == nil) {
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue] == 0) {
            NSLog(@"商品详情请求成功,0未收藏，1已收藏");
            _isColleciton = @"0";
            UIButton *button = (UIButton *)[self.view viewWithTag:100];
            [button setImage:[UIImage imageNamed:@"good_collection"] forState:UIControlStateNormal];
        }
        else{
            [self showHint:responseDict[@"msg"]];
        }
    }];
}

//添加用户收藏商品 
- (void)insertCollectionRequest
{
    NSDictionary *dict = @{@"token":[UserModel shareUserModel].userToken,@"goodsid":_goodsDic[@"goodsid"]};
    [DDPBLL requestWithURL:DEF_URL_InsertCollection  Dict:dict result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@",responseDict);
        if (responseDict == nil) {
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue] == 0) {
            NSLog(@"商品详情请求成功,0未收藏，1已收藏");
            _isColleciton = @"1";
            UIButton *button = (UIButton *)[self.view viewWithTag:100];
            [button setImage:[UIImage imageNamed:@"good_collectioned"] forState:UIControlStateNormal];
        }
        else{
            [self showHint:responseDict[@"msg"]];
        }
    }];
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
