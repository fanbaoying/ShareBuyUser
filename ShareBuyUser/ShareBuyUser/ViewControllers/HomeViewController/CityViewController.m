//
//  CityViewController.m
//  ShareBuyUser
//
//  Created by soldier on 16/8/17.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "CityViewController.h"
#import "LocationCityCell.h"
#import "HotCityCell.h"
#import "CityCell.h"
#import <AMapFoundationKit/AMapFoundationKit.h>

#import <AMapLocationKit/AMapLocationKit.h>

@interface CityViewController () <UITableViewDelegate,UITableViewDataSource,HotCityCellDelegate,AMapLocationManagerDelegate>

@property (nonatomic, strong) UITableView *cityTableView;
@property (nonatomic, strong) NSMutableArray *cityArray;
@property (nonatomic, strong) AMapLocationManager *locationManager;

@end

@implementation CityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"城市选择"];
    
    self.cityArray = [NSMutableArray array];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"city"]) {
        [_cityArray addObject:@{@"first":@"当前定位城市",@"city":@[@{@"region_code":[[NSUserDefaults standardUserDefaults] objectForKey:@"citycode"],@"region_id":@"0",@"region_name":[[NSUserDefaults standardUserDefaults] objectForKey:@"city"]}]}];
    }
    else {
        [_cityArray addObject:@{@"first":@"当前定位城市",@"city":@[@{@"region_code":@"",@"region_id":@"",@"region_name":@""}]}];
    }
    
    [self.view addSubview:self.cityTableView];
    
    [self findRegionRequest];
    
    //高德定位
    [self getLocation];
}

- (void)getLocation {
    [AMapServices sharedServices].apiKey =@"c213bb805f3dbca6465ca30c65c1093d";
    
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    [self.locationManager setLocationTimeout:6];
    
    [self.locationManager setReGeocodeTimeout:3];
    
    //带逆地理的单次定位
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                [self.cityArray replaceObjectAtIndex:0 withObject:@{@"first":@"当前定位城市",@"city":@[@{@"region_code":@"",@"region_id":@"",@"region_name":@""}]}];
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
                [self.cityArray replaceObjectAtIndex:0 withObject:@{@"first":@"当前定位城市",@"city":@[@{@"region_code":@"3101",@"region_id":@"0",@"region_name":@"上海市"}]}];
            }else
            {
                [self.cityArray replaceObjectAtIndex:0 withObject:@{@"first":@"当前定位城市",@"city":@[@{@"region_code":[regeocode.adcode substringToIndex:4],@"region_id":@"0",@"region_name":regeocode.city}]}];
            }
            
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
            [_cityTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
}

#pragma mark - Get Method
- (UITableView *)cityTableView
{
    if (!_cityTableView) {
        _cityTableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
            [tableView setDelegate:self];
            [tableView setDataSource:self];
            [tableView setBackgroundColor:[UIColor clearColor]];
            [tableView setTableFooterView:[UIView new]];
            [tableView setSeparatorInset:UIEdgeInsetsZero];
            [tableView setLayoutMargins:UIEdgeInsetsZero];
            [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
            
            tableView;
        });
    }
    return _cityTableView;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    [view setBackgroundColor:UIColorFromHex(0xf2f2f2, 1)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, kScreenWidth - 30, 20)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:UIColorFromHex(0x999999, 1)];
    [label setFont:UIFontPingFangRegular(13)];
    [label setText:_cityArray[section][@"first"]];
    [view addSubview:label];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0&&[_cityArray[indexPath.section][@"city"][indexPath.row][@"region_name"] isEqualToString:@""]) {
        return;
    }
    if ([_delegate respondsToSelector:@selector(chooseCity:)]) {
                [_delegate chooseCity:_cityArray[indexPath.section][@"city"][indexPath.row]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_cityArray[section][@"city"] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_cityArray count];
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView __TVOS_PROHIBITED
{
    NSMutableArray *keyArray = [[NSMutableArray alloc] init];
    for (int i = 0 ; i<[_cityArray count]; i++) {
        [keyArray addObject:[_cityArray[i][@"first"] substringWithRange:NSMakeRange(0, 1)]];
    }
    return keyArray;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            static NSString *cellID = @"LocationCell";
            LocationCityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[LocationCityCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            [cell.titleLabel setText:_cityArray[indexPath.section][@"city"][indexPath.row][@"region_name"]];
            
            if ([_cityArray[indexPath.section][@"city"][indexPath.row][@"region_name"] isEqualToString:@""]) {
                [cell.locationBtn setHidden:NO];
                [cell.titleLabel setHidden:YES];
                [cell.locationBtn addTarget:self action:@selector(clickLocationBtn) forControlEvents:UIControlEventTouchUpInside];
            }
            else {
                [cell.locationBtn setHidden:YES];
                [cell.titleLabel setHidden:NO];
            }
            return cell;
        }
            break;
//        case 1:
//        {
//            static NSString *cellID = @"HotCell";
//            HotCityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//            if (!cell) {
//                cell = [[HotCityCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                
//                [cell setHotCityArray:_cityArray[indexPath.section][@"city"]];
//                [cell setDelegate:self];
//            }
//            
//            return cell;
//        }
//            break;
            
        default:
        {
            static NSString *cellID = @"CityCell";
            CityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[CityCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            if ([_cityArray[indexPath.section][@"city"] count] == 0) {
                [cell.titleLabel setText:@""];
            }
            [cell.titleLabel setText:_cityArray[indexPath.section][@"city"][indexPath.row][@"region_name"]];
            
            return cell;
        }
            break;
    }
}

- (void)clickLocationBtn {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"定位服务未开启" message:@"请进入系统【设置】》【隐私】》【定位】中打开开关，并允许“分享购”访问您的位置" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
    }
    else {
        [self getLocation];
    }
}


#pragma mark - HotCityCellDelegate
- (void)hotCityCell:(HotCityCell *)cell selectedButtonWithTag:(NSInteger)tag
{
    if ([_delegate respondsToSelector:@selector(chooseCity:)]) {
        [_delegate chooseCity:_cityArray[1][@"city"][tag-100]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Networking
// 查询地区 (市)  
- (void)findRegionRequest
{
    [DDPBLL requestWithURL:DEF_URL_FindRegion  Dict:nil result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@",responseDict);
        if (responseDict == nil) {
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue] == 0) {
            NSLog(@"查询地区成功");
            
            for (int i = 'A'; i<='Z'; i++) {
                NSString *str = [NSString stringWithFormat:@"%c",i];
                
                NSMutableArray *array = [NSMutableArray array];
                for (int j = 0; j<[responseDict[@"data"] count]; j++) {
                    if ([responseDict[@"data"][j][@"first"] isEqualToString:str]) {
                        [array addObject:responseDict[@"data"][j]];
                    }
                }
                
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setValue:array forKey:@"city"];
                [dic setValue:str forKey:@"first"];
                [_cityArray addObject:dic];
            }
      
            [_cityTableView reloadData];
        }
        else{
            [self showHint:responseDict[@"msg"]];
        }
    }];
}

//获取拼音首字母(传入汉字字符串, 返回大写拼音首字母)
- (NSString *)firstCharactor:(NSString *)aString
{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    //获取并返回首字母
    return [pinYin substringToIndex:1];
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
