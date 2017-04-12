//
//  HomeViewController.m
//  ShareBuyUser
//
//  Created by soldier on 16/8/8.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeCollectionViewCell.h"
//#import "GoodsCollectionViewCell.h"
//#import "ShopCollectionViewCell.h"
#import "ScanQRCodeViewController.h"
#import "AdReusableView.h"
#import "TitleHeadReusableView.h"
#import "HotShopViewController.h"
#import "StoreDetailViewController.h"
#import "CityViewController.h"
#import "BaseWebViewController.h"
#import "HotActivityViewController.h"
#import "SearchViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <CoreLocation/CoreLocation.h>

@interface HomeViewController () <UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,AdReusableDelegete,TitleHeadReusableViewDelegate,CityViewControllerDelegate,AMapLocationManagerDelegate,CLLocationManagerDelegate, AMapSearchDelegate>
{
    NSString *cityName;
    NSString *cityCode;
    CLLocationManager *locationManager1;
    CLLocation *newLocation;
    NSInteger test;
    NSDictionary *dict1;
    NSString *longitude;
    NSString *latitude;
    
    NSInteger rate;
    
    NSDictionary *dictt;
    UILabel *leftItemLabel;
}

@property (nonatomic, assign) BOOL deferringUpdates;

@property (nonatomic, strong) AdReusableView *adHeadView;
@property (nonatomic, strong) TitleHeadReusableView *titleHeadView;
@property (nonatomic, strong) UICollectionView *homeCollectionView;
@property (nonatomic, strong) UIButton *cityBtn;
           
@property (nonatomic, strong) NSMutableArray *homeArray;
@property (nonatomic, strong) NSMutableArray *adInfoArray;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) AMapSearchAPI *search;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.homeCollectionView];
    
    //高德定位
    [self getLocation];
    
    //查询发送位置间隔
    [self getRate];
    
//    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(startLoaction) userInfo:@"" repeats:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"citycode"]) {
        [_homeCollectionView.legendHeader beginRefreshing];
    }
}


- (void)getRate {
//    [DDPBLL requestWithURL:DEF_URL_GETUSERROUTESRATE Dict:nil result:^(NSDictionary *responseDict) {
//        if (responseDict == nil) {
//            return ;
//        }
//        if ([responseDict[@"status"] integerValue] == 0) {
//            rate = [responseDict[@"data"][@"rate"] integerValue];
//            if (rate != 0) {
//                [NSTimer scheduledTimerWithTimeInterval:rate target:self selector:@selector(startLoaction) userInfo:@"" repeats:YES];
//                
//                //设置允许后台定位参数，保持不会被系统挂起
//                [self.locationManager setPausesLocationUpdatesAutomatically:NO];
//                
//                [self.locationManager setAllowsBackgroundLocationUpdates:YES];//iOS9(含)以上系统需设置
//                //开始持续定位
//                [self.locationManager startUpdatingLocation];
//            }
//        }
//        else {
//            [self showHint:responseDict[@"msg"] yOffset:0];
//        }
//    }];
}

- (void)getLocation {
    [AMapServices sharedServices].apiKey =@"c213bb805f3dbca6465ca30c65c1093d";
    
    self.locationManager = [[AMapLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    [self.locationManager setLocationTimeout:6];
    [self.locationManager setReGeocodeTimeout:3];
    
    self.search = [[AMapSearchAPI alloc] init];
    [self.search setDelegate:self];
    
    //带逆地理的单次定位
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            if (error.code == AMapLocationErrorLocateFailed)
            {
                cityCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"citycode"]?[[NSUserDefaults standardUserDefaults] objectForKey:@"citycode"]:@"3101";
                cityName = [[NSUserDefaults standardUserDefaults] objectForKey:@"city"]?[[NSUserDefaults standardUserDefaults] objectForKey:@"city"]:@"上海市";
                [_homeCollectionView.legendHeader beginRefreshing];
                
                return;
            }
        }
        
        //定位信息
        NSLog(@"location:%@", location);
        //逆地理信息
        if (regeocode)
        {
            NSLog(@"reGeocode:%@", regeocode);
            if ((regeocode.adcode.length == 0 || [regeocode.adcode isKindOfClass:[NSNull class]])) {
                cityCode = @"3101";
                cityName = @"上海市";
                [[NSUserDefaults standardUserDefaults] setObject:cityName forKey:@"city"];
                [[NSUserDefaults standardUserDefaults] setObject:cityCode forKey:@"citycode"];
            }
            else {
                cityCode = [regeocode.adcode substringToIndex:4];
                cityName = regeocode.city;
            }
            
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"city"]) {
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"city"] isEqualToString:cityName]) {
//                    [_cityBtn setTitle:cityName forState:UIControlStateNormal];
                    leftItemLabel.text = cityName;
                    [[NSUserDefaults standardUserDefaults] setObject:cityName forKey:@"city"];
                    [[NSUserDefaults standardUserDefaults] setObject:cityCode forKey:@"citycode"];
                }
                else {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"是否切换到当前城市" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"切换" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                        [_cityBtn setTitle:cityName forState:UIControlStateNormal];
                        leftItemLabel.text = cityName;
                        [[NSUserDefaults standardUserDefaults] setObject:cityName forKey:@"city"];
                        [[NSUserDefaults standardUserDefaults] setObject:cityCode forKey:@"citycode"];
                        [_homeCollectionView.legendHeader beginRefreshing];
                    }];
                    [alert addAction:action1];
                    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"不切换" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        cityCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"citycode"]?[[NSUserDefaults standardUserDefaults] objectForKey:@"citycode"]:@"3101";
                        cityName = [[NSUserDefaults standardUserDefaults] objectForKey:@"city"]?[[NSUserDefaults standardUserDefaults] objectForKey:@"city"]:@"上海市";
                    }];
                    [alert addAction:action2];
                    [self.navigationController presentViewController:alert animated:YES completion:nil];
                }
            }
            else {
//                [_cityBtn setTitle:cityName forState:UIControlStateNormal];
                leftItemLabel.text = cityName;
                [[NSUserDefaults standardUserDefaults] setObject:cityName forKey:@"city"];
                [[NSUserDefaults standardUserDefaults] setObject:cityCode forKey:@"citycode"];
                [_homeCollectionView.legendHeader beginRefreshing];
            }
        }
    }];
}

#pragma mark - Get Method
- (UIBarButtonItem *)areaBarBtnItem
{
    if (!_areaBarBtnItem) {
        _areaBarBtnItem = ({
            UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:self.cityBtn];
            barBtnItem;
        });
    }
    return _areaBarBtnItem;
}

- (UIBarButtonItem *)scanBarBtnItem
{
    if (!_scanBarBtnItem) {
        _scanBarBtnItem = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(0, 0, 20, 19)];
            [button setBackgroundImage:[UIImage imageNamed:@"home_scan_button"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(clickScanBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:button];
            barBtnItem;
        });
    }
    return _scanBarBtnItem;
}

- (UIButton *)searchButton
{
    if (!_searchButton) {
        _searchButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(0, 0, 220, 30)];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 15.0f;
            [button setBackgroundColor:UIColorFromHex(0xffffff, 0.8)];
            [button addTarget:self action:@selector(clickSearchBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 30)];
            [label setText:@"请输入搜索关键字"];
            [label setTextColor:kMainColor];
            [label setFont:UIFontPingFangMedium(13.0f)];
            [button addSubview:label];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(button.frame.size.width-25, 7.5, 15, 15)];
            [imageView setImage:[UIImage imageNamed:@"home_search"]];
            [button addSubview:imageView];
            
            button;
        });
    }
    return _searchButton;
}

- (UIButton *)cityBtn
{
    if (!_cityBtn) {
        _cityBtn = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(0, 0, 60, 40)];
    
            leftItemLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 45, 40)];
            leftItemLabel.font = UIFontPingFangRegular(15);
            leftItemLabel.textColor = [UIColor whiteColor];
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"city"]) {
                leftItemLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"city"];
            }
            else {
                leftItemLabel.text = @"上海市";
            }
            [button addSubview:leftItemLabel];
            
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(45, 0, 15, 40)];
            img.image = [UIImage imageNamed:@"home_location_arrow_button_normal"];
            img.contentMode = UIViewContentModeCenter;
            [button addSubview:img];
            
            [button addTarget:self action:@selector(clickAreaBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            button;
        });
    }
    return _cityBtn;
}

- (UICollectionView *)homeCollectionView
{
    if (!_homeCollectionView) {
        _homeCollectionView = ({
            UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc]init];
            [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
//            flowLayout.minimumLineSpacing = 5;
//            flowLayout.minimumInteritemSpacing = 5;
//            flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
//            flowLayout.itemSize = CGSizeMake(kScreenWidth/2-8, kScreenWidth/2+35);
            
            UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNavigationBarHight, kScreenWidth, kScreenHeight-kNavigationBarHight-kTabbarHight) collectionViewLayout:flowLayout];
            [collectionView setBackgroundColor:[UIColor clearColor]];
            [collectionView setDelegate:self];
            [collectionView setDataSource:self];
            [collectionView setAlwaysBounceVertical:YES];
            [collectionView setClipsToBounds:NO];
            [collectionView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([HomeCollectionViewCell class])];
//            [collectionView registerClass:[GoodsCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([GoodsCollectionViewCell class])];
//            [collectionView registerClass:[ShopCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([ShopCollectionViewCell class])];
            [collectionView registerClass:[AdReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([AdReusableView class])];
            [collectionView registerClass:[TitleHeadReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([TitleHeadReusableView class])];
            
            [collectionView addLegendHeaderWithRefreshingBlock:^{
                dictt = @{@"regionCode":cityCode?cityCode:@"3101"};
                [self getHomeIndexHotPageRequest:dictt];
            }];


            collectionView;
            
        });
    }
    return _homeCollectionView;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [_homeArray count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return [_homeArray[section] count];
    }
    else
    {
        return [[_homeArray[section] allValues][0] count];
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSLog(@"广告");
        _adHeadView= [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([AdReusableView class]) forIndexPath:indexPath];
        [_adHeadView setDelegate:self];
        
        NSMutableArray *imgArray = [NSMutableArray array];
        for (int i = 0; i<[self.adInfoArray count]; i++) {
            [imgArray addObject:self.adInfoArray[i][@"imgurl"]];
        }
        _adHeadView.adArray = imgArray;
        [_adHeadView.bannerView reloadData];
        return _adHeadView;
    }else
    {
        _titleHeadView= [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([TitleHeadReusableView class]) forIndexPath:indexPath];

//        _titleHeadView = [[TitleHeadReusableView alloc] init];
        if ([[_homeArray[indexPath.section] allKeys][0] isEqualToString:@"businessList"]) {
            [_titleHeadView.titleLabel setText:@"热门商家"];
        }else
        {
            [_titleHeadView.titleLabel setText:@"热门活动"];
        }
        [_titleHeadView setDelegate:self];
        _titleHeadView.moreButton.tag = indexPath.section+100;
        return _titleHeadView;
    }
    
//    return headerView;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HomeCollectionViewCell class]) forIndexPath:indexPath];
    
    if ([[_homeArray[indexPath.section] allKeys][0] isEqualToString:@"businessList"]) {
        [cell.locationImgView setHidden:NO];
        [cell.titleLabel setFrame:CGRectMake(10, cell.frame.size.width+3, cell.frame.size.width-20, 20)];
        [cell.subTitleLabel setFrame:CGRectMake(25, cell.frame.size.width+25, cell.frame.size.width-30, 15)];
        [cell.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [cell.subTitleLabel setTextAlignment:NSTextAlignmentLeft];
        
        [cell.titleLabel setText:[_homeArray[indexPath.section] allValues][0][indexPath.row][@"businessname"]];
        [cell.subTitleLabel setText:[_homeArray[indexPath.section] allValues][0][indexPath.row][@"address"]];
        [cell.imgView setImageWithURL:[NSURL URLWithString:[_homeArray[indexPath.section] allValues][0][indexPath.row][@"imgurl"]] placeholderImage:[UIImage imageNamed:@"product_placeholder"]];
    }else
    {
        [cell.locationImgView setHidden:YES];
        [cell.titleLabel setFrame:CGRectMake(0, cell.frame.size.width+3, cell.frame.size.width, 20)];
        [cell.subTitleLabel setFrame:CGRectMake(0, cell.frame.size.width+25, cell.frame.size.width, 15)];
        [cell.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [cell.subTitleLabel setTextAlignment:NSTextAlignmentCenter];
        
        [cell.titleLabel setText:[_homeArray[indexPath.section] allValues][0][indexPath.row][@"activityname"]];
//        NSString *subString = [self filterHTML:[_homeArray[indexPath.section] allValues][0][indexPath.row][@"describes"]];
//        [cell.subTitleLabel setText:subString];
        [cell.subTitleLabel setText:[_homeArray[indexPath.section] allValues][0][indexPath.row][@"profile"]];
        [cell.imgView setImageWithURL:[NSURL URLWithString:[_homeArray[indexPath.section] allValues][0][indexPath.row][@"imgurl"]] placeholderImage:[UIImage imageNamed:@"product_placeholder"]];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if ([[_homeArray[indexPath.section] allKeys][0] isEqualToString:@"businessList"])
    {
        StoreDetailViewController *storeDetailVC = [[StoreDetailViewController alloc] init];
        [storeDetailVC setTitle:[_homeArray[indexPath.section] allValues][0][indexPath.row][@"businessname"]];
        storeDetailVC.imgUrlStr = [_homeArray[indexPath.section] allValues][0][indexPath.row][@"imgurl"];
        storeDetailVC.storeID = [_homeArray[indexPath.section] allValues][0][indexPath.row][@"businessid"];
        [self.navigationController pushViewController:storeDetailVC animated:YES];
    }else
    {
        NSLog(@"热门活动");
        BaseWebViewController *baseWebVC = [[BaseWebViewController alloc] init];
        baseWebVC.title = [_homeArray[indexPath.section] allValues][0][indexPath.row][@"activityname"];
        baseWebVC.htmlString = [_homeArray[indexPath.section] allValues][0][indexPath.row][@"describes"];
        [self.navigationController pushViewController:baseWebVC animated:YES];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kScreenWidth/2-12, kScreenWidth/2+35);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return UIEdgeInsetsMake(0, 0, 5, 5);
    }else
    {
        return UIEdgeInsetsMake(8, 8, 8, 8);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }else
    {
        return 8;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }else
    {
        return 8;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(kScreenWidth, 150);
    }else
    {
        return CGSizeMake(kScreenWidth, 30);
    }
}

#pragma mark AdReusableDelegete
- (void)selectHomeAdReusableView:(AdReusableView *)view andPage:(NSInteger)page
{
    NSLog(@"Select Ad : %ld",(long)page);
//    [self requestAdDetailDataWithAdID:_adArray[page][@"adid"]];
    BaseWebViewController *baseWebVC = [[BaseWebViewController alloc] init];
    baseWebVC.title = _adInfoArray[page][@"title"];
    baseWebVC.htmlString = _adInfoArray[page][@"content"];
    [self.navigationController pushViewController:baseWebVC animated:YES];
}

#pragma mark - TitleHeadReusableViewDelegate
- (void)clickTitleHeadMoreButton:(UIButton *)sender
{
    NSLog(@"%lu",sender.tag);
    NSLog(@"更多");
    if ([[_homeArray[sender.tag-100] allKeys][0] isEqualToString:@"businessList"])
    {
        [self.navigationController pushViewController:[HomeViewController new] animated:YES];
    }else
    {
        NSLog(@"热门活动");
        [self.navigationController pushViewController:[HotActivityViewController new] animated:YES];
    }

}

#pragma mark - CityViewControllerDelegate
- (void)chooseCity:(NSDictionary *)cityDic
{
    NSLog(@"城市选择%@",cityDic);
    
    leftItemLabel.text = cityDic[@"region_name"];
    cityCode = cityDic[@"region_code"];
    NSLog(@"%@",cityCode);
    dictt = @{@"regionCode":cityDic[@"region_code"]};
    cityName = cityDic[@"region_name"];
    NSLog(@"%@",cityName);
    [[NSUserDefaults standardUserDefaults] setObject:cityCode forKey:@"citycode"];
    [[NSUserDefaults standardUserDefaults] setObject:cityName forKey:@"city"];
//    [_homeCollectionView reloadData];
//    [self getHomeIndexHotPageRequest:dictt];
}

#pragma mark - AMapLocationManagerDelegate

- (void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location                    = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension            = YES;
    
    [self.search AMapReGoecodeSearch:regeo];
}

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    
    NSLog(@"%@", response.regeocode.formattedAddress);
    dict1 = @{@"lng":longitude, @"lat":latitude,@"address":response.regeocode.formattedAddress,@"token":[UserModel shareUserModel].userToken};
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
//    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    latitude = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    longitude = [NSString stringWithFormat:@"%f", location.coordinate.longitude];

    CLLocationCoordinate2D cll2D = location.coordinate;
    [self searchReGeocodeWithCoordinate:cll2D];
}

- (void)startLoaction{
    if ([UserModel shareUserModel].userToken.length == 0) {
        
    }
    else {
        [self uploadUserRoutes:dict1];
    }
}

#pragma mark - UIButton Action

- (void)uploadUserRoutes:(NSDictionary *)dict {
    [DDPBLL requestWithURL:DEF_URL_ADDUSERRROUTES Dict:dict result:^(NSDictionary *responseDict) {
        if (responseDict == nil) {
            return ;
        }
    }];
}

- (void)clickAreaBtn:(UIButton *)sender
{
    NSLog(@"选择城市");
    CityViewController *cityVc = [[CityViewController alloc] init];
    [cityVc setDelegate:self];
    [self.navigationController pushViewController:cityVc animated:YES];
}

- (void)clickScanBtn:(UIButton *)sender
{
    NSLog(@"点击二维码扫描");
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        NSString *errorStr = @"请进入系统【设置】》【隐私】》【相机】中打开开关，并允许“分享购”访问您的相机";
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"提示" message:errorStr preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//            if([[UIApplication sharedApplication] canOpenURL:url]) {
//                NSURL *url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
//                [[UIApplication sharedApplication] openURL:url];
//            }
        }];
        [alertCon addAction:sureAction];
        [self presentViewController:alertCon animated:YES completion:nil];
        
        return;
    }

    [self.navigationController pushViewController:[ScanQRCodeViewController new] animated:YES];
}

- (void)clickSearchBtn:(UIButton *)sender
{
    NSLog(@"商品搜索");
    [self.navigationController pushViewController:[SearchViewController new] animated:YES];
}

#pragma mark - NetWorking  
//获取首页信息
- (void)getHomeIndexHotPageRequest:(NSDictionary *)dict
{
    [self showHudInView:self.view hint:nil];
    [DDPBLL requestWithURL:DEF_URL_IndexHotPage  Dict:dict result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@-------",responseDict);
        
        
//
//        NSDictionary *dic = [arr[1] objectForKey:@"trendRegion"];
        
//        NSLog(@"%@",[responseDict objectForKey:@"msg"]);
//        
//        NSLog(@"%@",[responseDict objectForKey:@"data"]);
//        
//        NSArray *arr1 = [responseDict objectForKey:@"data"];
//        NSDictionary *dic2 = [arr1[1] objectForKey:@"trendRegion"];
        
//        NSLog(@"%@",[[arr1[1] objectForKey:@"trendRegion"] objectForKey:@"regionName"]);
        
        
        if (responseDict == nil) {
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue] == 0) {
            self.adInfoArray = [NSMutableArray arrayWithArray:responseDict[@"data"][@"adInfoList"]];
//            self.homeArray = [NSMutableArray arrayWithArray:@[@{@"activityList":responseDict[@"data"][@"activityList"]},@{@"businessList":responseDict[@"data"][@"businessList"]}]];
            for (int i = 0; i<[self.homeArray count]; i++) {
                if ([[self.homeArray[i] allValues][0] count] == 0) {
                    [self.homeArray removeObjectAtIndex:i];
                }
            }
            
            [self.homeArray insertObject:@[] atIndex:0];
            [_homeCollectionView.legendHeader endRefreshing];
            [_homeCollectionView reloadData];
        }
        else{
            [self showHint:responseDict[@"msg"]];
            [_homeCollectionView.legendHeader endRefreshing];
        }
    }];
}

//去掉html标签
-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    NSString * regEx = @"<([^>]*)>";
    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    
    NSString * regEx1 = @"&ldquo;";
    html = [html stringByReplacingOccurrencesOfString:regEx1 withString:@"“"];
    
    NSString * regEx2 = @"&rdquo;";
    html = [html stringByReplacingOccurrencesOfString:regEx2 withString:@"”"];
    
    return html;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
