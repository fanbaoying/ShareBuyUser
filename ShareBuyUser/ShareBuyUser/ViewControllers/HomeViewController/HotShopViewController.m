//
//  HotShopViewController.m
//  ShareBuyUser
//
//  Created by soldier on 16/8/9.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "HotShopViewController.h"
#import "ShopCollectionViewCell.h"
#import "StoreDetailViewController.h"

@interface HotShopViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSInteger currentPage;
}

@property (nonatomic, strong) UICollectionView *hotCollectionView;

@property (nonatomic, strong) NSMutableArray *storeArray;

@end

@implementation HotShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"热门店铺"];
    
    [self.view addSubview:self.hotCollectionView];
    
    self.storeArray = [NSMutableArray array];
    
    NSLog(@"获得更多热门商户信息");
    currentPage = 0;
    NSDictionary *dic = @{@"pageIndex":[NSString stringWithFormat:@"%ld",currentPage+1]};
    [self getHotPageRequestWithDict:dic];
}

#pragma mark - Get Method
- (UICollectionView *)hotCollectionView
{
    if (!_hotCollectionView) {
        _hotCollectionView = ({
            UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc]init];
            [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
            
            UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHight) collectionViewLayout:flowLayout];
            [collectionView setBackgroundColor:[UIColor clearColor]];
            [collectionView setDelegate:self];
            [collectionView setDataSource:self];
            [collectionView setAlwaysBounceVertical:YES];
            [collectionView setClipsToBounds:NO];
            [collectionView registerClass:[ShopCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([ShopCollectionViewCell class])];
            
            [collectionView addLegendFooterWithRefreshingBlock:^{
                currentPage++;
                NSLog(@"获得更多热门商户信息");
                NSDictionary *dic = @{@"pageIndex":[NSString stringWithFormat:@"%ld",currentPage+1]};
                [self getHotPageRequestWithDict:dic];
            }];
            
            collectionView;
        });
    }
    return _hotCollectionView;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_storeArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ShopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ShopCollectionViewCell class]) forIndexPath:indexPath];
    [cell.shopImgView setImageWithURL:[NSURL URLWithString:_storeArray[indexPath.row][@"imgurl"]] placeholderImage:[UIImage imageNamed:@"product_placeholder"]];
    [cell.shopTitleLabel setText:_storeArray[indexPath.row][@"businessname"]];
    [cell.shopAddLabel setText:_storeArray[indexPath.row][@"address"]];

    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    StoreDetailViewController *storeDetailVC = [[StoreDetailViewController alloc] init];
    [storeDetailVC setTitle:_storeArray[indexPath.row][@"businessname"]];
    storeDetailVC.imgUrlStr = _storeArray[indexPath.row][@"imgurl"];
    storeDetailVC.storeID = _storeArray[indexPath.row][@"businessid"];
    [self.navigationController pushViewController:storeDetailVC animated:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kScreenWidth/2-12, kScreenWidth/2+35);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 8;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 8;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(8, 8, 8, 8);
}
             
#pragma mark - NetWorking  
//获得更多热门商户信息
- (void)getHotPageRequestWithDict:(NSDictionary *)dict
{
    [self showHudInView:self.view hint:nil];
    [DDPBLL requestWithURL:DEF_URL_HotPage  Dict:dict result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@",responseDict);
        if (responseDict == nil) {
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue] == 0) {
            if ([responseDict[@"data"] count] != 0) {
                [self.storeArray addObjectsFromArray:responseDict[@"data"]];
                [_hotCollectionView reloadData];
            }else
            {
                // legendFooter置为"没有更多内容了"状态
                [_hotCollectionView.legendFooter noticeNoMoreData];
            }
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
