//
//  HWCategoryViewController.m
//  美食街
//
//  Created by 黄炜 on 2018/3/7.
//  Copyright © 2018年 黄炜. All rights reserved.
//

#import "HWCategoryViewController.h"
#import "HWDetailMenuCategoryTableViewController.h"
#import "HWMenuDetailItem.h"
#import <MJExtension.h>

@interface HWCategoryViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(strong,nonatomic)NSArray *items;
@end


static NSString * const ID = @"HWCategoryCell";

@implementation HWCategoryViewController


-(NSArray *)items{
    if (!_items) {
        _items = self.dataDict[@"list"];
    }
    return _items;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = _dataDict[@"name"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self configCollectionView];
    
}

-(void)configCollectionView{
    
//    NSArray *dataArr = self.dataDict[@"list"];
    
    // 设置collectionView 计算collectionView高度 = rows * itemWH
    // Rows = (count - 1) / cols + 1  3 cols4
    //列数
    NSInteger cols = 3;
    //间距
    NSInteger margin = 10;
    //cell的宽高尺寸
    CGFloat itemWH = (HWScreenW - (cols - 1) * margin) / cols;
    
    NSInteger count = self.items.count;
    
    //计算总行数
    NSInteger rows = (count - 1) / cols + 1;
    
    //collectionView的高度
    CGFloat cellH = rows * itemWH;
    
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    //在这里被坑过, 原因就是因为没有宽高,所以就是没有尺寸, 所以collectionview一直不会显示出来\
    由于在"小码哥"的项目中是tableview的footview,让collectionView占据footview, 所以只需要设置高度就行
//    UICollectionView *cv = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, HWScreenW, cellH) collectionViewLayout:self.layout];
    
    //设置collectionView的尺寸
    self.collectionView.frame = CGRectMake(0, 64, HWScreenW, cellH);
    
    //设置cell的高度
//    self.collectionView.HW_Height = cellH;
    
    //这里同时也要给cell的高度进行修改
//    self.collectionView.frame = cv.frame;
    
    self.layout.itemSize = CGSizeMake(itemWH, itemWH);
    self.layout.minimumLineSpacing = 2;
    self.layout.minimumInteritemSpacing = 2;
    
    
//    self.collectionView = cv;
//    self.collectionView.dataSource = self;
//    self.collectionView.delegate = self;
    //设置collectionView不允许被滚动
    //    self.collectionView.scrollEnabled = NO;
    
    //注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"HWCategoryCell" bundle:nil] forCellWithReuseIdentifier:ID];
    
    //    self.collectionView.HW_Height = itemWH * rows;
    [self.view addSubview:self.collectionView];
    
    //处理collectionView填补最后的空格(如果有的话)
//    [self resolveData];
    
    [self.collectionView reloadData];
    
    
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.items.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //获取指定的字典
    NSDictionary *dict = _items[indexPath.row];
    //字典转模型
//     [HWMenuDetailItem mj_objectArrayWithKeyValuesArray:dict];
    
    //创建HWMenuViewController
    HWDetailMenuCategoryTableViewController *vc = [[HWDetailMenuCategoryTableViewController alloc] init];
//
//    //只需将字典中的classid传递给vc, 让vc去根据classid发送请求
    vc.classid = dict[@"classid"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HWCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
//    cell.backgroundColor = self.collectionView.backgroundColor;
//    cell.item = _items[indexPath.row];
    //设置tableView的cell不能被选中  self.tableView.allowsSection = NO;
    
    //取出字典
    NSDictionary *dict = _items[indexPath.row];
    
    cell.textLabel.text = dict[@"name"];
    return cell;
    
}


@end
