//
//  HWMenuOfLocationViewController.m
//  美食街
//
//  Created by 黄炜 on 2018/1/22.
//  Copyright © 2018年 黄炜. All rights reserved.
//

#import "HWMenuOfLocationViewController.h"
#import "HWMenuDetailItem.h"
#import <UIImageView+WebCache.h>
#import "HWMaterialItem.h"
#import "HWMaterialCollectionView.h"
#import "HWMaterialCollectionViewCell.h"
#import <MJExtension.h>
#import "HWProcessItem.h"
#import "HWProcessView.h"
#import "HWProcessCell.h"
#import "HWDigestView.h"
#import "UIImage+Image.h"
//#import "HWProcessTableView.h"


static NSString * const ID = @"materialCell";

@interface HWMenuOfLocationViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>


//@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
/* collectionView */
//@property(weak,nonatomic)HWMaterialCollectionView *collectionView;
@property (weak, nonatomic) IBOutlet HWMaterialCollectionView *collectionView;

//@property (weak, nonatomic) IBOutlet UITableViewCell *tabCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *tabCell;
@property (weak, nonatomic) IBOutlet HWProcessCell *processCell;


/* materialItems */
@property(strong,nonatomic)NSMutableArray *materialItems;

//** processCellHeight */
@property (assign, nonatomic) CGFloat processCellHeight;

@property (weak, nonatomic) IBOutlet UITableViewCell *digestView;

/**
 processItems模型数组 用于存放烹制步骤数据
 */
@property (strong, nonatomic) NSMutableArray <HWProcessItem *>*processItems;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (strong, nonatomic) UIButton *starButton;

@property (strong, nonatomic) NSMutableArray *cachesData;

@end

@implementation HWMenuOfLocationViewController

-(NSMutableArray *)cachesData{
    if (!_cachesData) {
        _cachesData = [NSMutableArray array];
    }
    return _cachesData;
}

-(NSMutableArray *)items{
    if (!_materialItems) {
        _materialItems = [NSMutableArray array];
    }
    return _materialItems;
}

-(NSMutableArray *)processItems{
    if (!_processItems) {
        _processItems = [NSMutableArray array];
    }
    return _processItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showData];

    //禁止cell被选中
    self.tableView.allowsSelection = NO;
    //添加digestView
    [self setupDigestView];
    
    //添加collectionView
    [self setupCollectionView];
    //添加processCell
    //    if(self.processCell.subviews.count < 3){
    [self setupProcessView];
    
    //添加content
    [self setupContentView];
    
//    NSLog(@"processCell.frame = %@---------  %f",NSStringFromCGRect(self.processCell.frame),self.processCellHeight);
    
//    NSLog(@"digestView.height - %f",self.digestView.frame.size.height);
    
    //添加导航栏右侧按钮
    [self setupRightBarButtonItem];
    
    //获取并解析 data.plist 并存入全局数组中以供使用
    [self resolveDataFromCachesDir];
    
    
    //判断当前item是否存在于本地数据中
    [self detectStarOrNot];
    
}


-(void)resolveDataFromCachesDir{
    self.cachesData = [[NSMutableArray alloc] initWithContentsOfFile:dataFullPathFromCaches];
}

-(void)detectStarOrNot{
    //解析 data.plist 写入数组
    NSArray *arr = [[NSArray alloc] initWithContentsOfFile:dataFullPathFromCaches];
    
    //遍历数组查看数组中是否有当前的item 如果有就点亮星星
    for (NSDictionary *dict in arr) {
        if ([dict[@"pic"] isEqualToString:_item.pic]) {
            //能来到这里说明已经保存过数据 要点亮星星
            self.starButton.selected = YES;
            return;
        }else{
            self.starButton.selected = NO;
        }
    }
}

-(void)setupRightBarButtonItem{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightButton.imageView.image = [UIImage imageWithOriginalImage:[UIImage imageNamed:@"Favorite"]];
    
    rightButton.frame = CGRectMake(0, 0, 5, 5);
    [rightButton setImage:[UIImage imageNamed:@"Favorite_Normal"] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"Favorite_Selected"] forState:UIControlStateSelected];
    [rightButton addTarget:self action:@selector(clickFavorite:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton sizeToFit];
//    [rightButton setHighlighted:NO];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.starButton = rightButton;
    self.navigationItem.rightBarButtonItem = buttonItem;
}


-(void)clickFavorite:(UIButton *)favoriteButton{
    favoriteButton.selected = !favoriteButton.selected;
    if (favoriteButton.selected) {
        
        //判断如果没有就写入并保存到 data.plist 有就返回
        for (NSDictionary *dict in _cachesData) {
            if ([dict[@"pic"] isEqualToString:_item.pic]) {
                return;
            }
        }
        NSDictionary *dict = [NSDictionary dictionary];
        dict = [_item mj_keyValues];
        [_cachesData insertObject:dict atIndex:0];
        [_cachesData writeToFile:dataFullPathFromCaches atomically:YES];
        
        /*
        NSString *doc = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
        
        
        //拼接文件全路径
        NSString *path = [doc stringByAppendingPathComponent:_item.name];
        
//        [NSKeyedArchiver archiveRootObject:_item toFile:path];
        //新建一块可变数据区
        NSMutableData *data = [NSMutableData data];
        //将数据区连接到一个NSKeyedAchiver对象
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
//        [archiver encodeObject:_item forKey:@"item"];
        [archiver encodeObject:_item forKey:@"item"];
        [archiver finishEncoding];
        
        [data writeToFile:[path stringByAppendingPathExtension:@"data"] atomically:YES];
        NSLog(@"%@",path);
         */
        
    }else{
        
        //如果是取消星星的话就从data.plist中删除item
        for (NSDictionary *dict in _cachesData) {
            if ([dict[@"pic"] isEqualToString:_item.pic]) {
                [_cachesData removeObject:dict];
                [_cachesData writeToFile:dataFullPathFromCaches atomically:YES];
                return;
            }
            
            
        }
        
        
        /*
        NSString *doc = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
        NSString *path = [doc stringByAppendingPathComponent:_item.name];
        NSData *data = [NSData dataWithContentsOfFile:path];
        
        NSKeyedUnarchiver *unachiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        HWMenuDetailItem *item = [unachiver decodeObjectForKey:@"item"];
        
        //创建文件管理对象
        NSFileManager *fileManager = [NSFileManager defaultManager];
//        NSDirectoryEnumerator *result = [fileManager enumeratorAtPath:doc];
        
        //获得缓存文件加下所有对象存入数组
        NSArray *arr = [fileManager contentsOfDirectoryAtPath:doc error:nil];
        
        [unachiver finishDecoding];

        //遍历数组
        for (NSMutableData *data in arr) {
            if ([data isKindOfClass:[NSMutableData class]]) {
                NSLog(@"%@",data);
            }
        }
        
//        NSLog(@"%@",item.name);
        */
    }
    
}

-(void)setupContentView{
    NSLog(@"%@",self.item.content);
    self.contentLabel.text = self.item.content;
}


-(void)setupDigestView{
    
    //创建DigestView
    HWDigestView *digestV = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HWDigestView class]) owner:nil options:nil][0];
    
    digestV.item = _item;
    [self.digestView addSubview:digestV];
    
    
}


-(void)setupCollectionView{
    // 设置collectionView 计算collectionView高度 = rows * itemWH
    // Rows = (count - 1) / cols + 1  3 cols4
    //列数
    NSInteger cols = 4;
    //间距
    NSInteger margin = 0;
    //cell的宽高
    CGFloat itemWH = (HWScreenW - (cols - 1) * margin) / cols;
    
    NSInteger count = self.materialItems.count;
    
    //计算总行数
    NSInteger rows = (count - 1) / cols + 1;
    
    //collectionView的高度
    CGFloat cellH = rows * itemWH;

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    //在这里被坑过, 原因就是因为没有宽高,所以就是没有尺寸, 所以collectionview一直不会显示出来\
    由于在"小码哥"的项目中是tableview的footview,让collectionView占据footview, 所以只需要设置高度就行
    HWMaterialCollectionView *cv = [[HWMaterialCollectionView alloc] initWithFrame:CGRectMake(0, 0, HWScreenW, cellH) collectionViewLayout:layout];

    //设置cell的高度
    self.tabCell.HW_Height = cellH;
    
    //这里同时也要给cell的高度进行修改
    self.tabCell.frame = cv.frame;
    
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    
    self.collectionView = cv;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    //设置collectionView不允许被滚动
//    self.collectionView.scrollEnabled = NO;
    
    //注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"HWMaterialCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:ID];

//    self.collectionView.HW_Height = itemWH * rows;
    [self.tabCell addSubview:self.collectionView];
    
    //处理collectionView填补最后的空格(如果有的话)
    [self resolveData];
    
    [self.collectionView reloadData];
    
}

-(void)setupProcessView{
    
    //获取模型的数量然后计算出cell的高度 现在占位视图是一个cell
    NSInteger count = self.processItems.count;
    
    //将模型数组给processCell
    self.processCell.processArr = _processItems;
    
    //设置processCell的高度,由于固定了每个processView的高度为220
    self.processCell.HW_Height = count * 290;
    self.processCellHeight = self.processCell.HW_Height;
    
//    UIView *contentView = [[UIView alloc] init];
//    contentView.frame = CGRectMake(0, 0, HWScreenW, self.processCellHeight);
//    contentView.backgroundColor = [UIColor yellowColor];
//    [self.processCell addSubview:contentView];
    
    for (int i = 0; i < count; i++) {
        HWProcessView *pV = [[NSBundle mainBundle] loadNibNamed:@"HWProcessView" owner:nil options:nil][0];
        
        
        //获得有几个模型
//        NSInteger count = self.processArr.count;
        CGFloat processViewH = 290;
        CGFloat processViewY = i * processViewH;
        pV.frame = CGRectMake(0, processViewY,HWScreenW,processViewH);
        [self.processCell addSubview:pV];
        
        
        
        pV.pLabel.text = self.processItems[i].pcontent;
        pV.pLabel.text = [pV.pLabel.text stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
        
        [pV.pImage sd_setImageWithURL:[NSURL URLWithString:self.processItems[i].pic]];
//        self.pLabel.text = _item.pcontent;
//        [self.pImage sd_setImageWithURL:[NSURL URLWithString:_item.pic]];
    }
    
    
//    NSLog(@"ProcessCell.frame = %@",NSStringFromCGRect(self.processCell.frame));
}



//给相应的控件传递数据
-(void)showData{
    //设置栈顶控制器的Title
    self.title = _item.name;
    //设置展示图片
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:self.item.pic]];
//    NSLog(@"%@",detailItem.material);
    //字典数组转模型数组   item为HWMenuDetailItem有所有的list字典
    _materialItems = [HWMaterialItem mj_objectArrayWithKeyValuesArray:_item.material];
    
    _processItems = [HWProcessItem mj_objectArrayWithKeyValuesArray:_item.process];
    
    
}

-(void)resolveData{
    //判断下缺几个cell
    //3 % 4 = 3 cols - 3 = 1
    //5 % 4 = 1 cols - 1 = 3
    NSInteger count = self.materialItems.count;
    NSInteger exter = count % 4;
    //判断是否有余数,如果有余数那就填补空格, 以一个空的模型为数据显示在控件上
    if (exter) {
        exter = 4 - exter;
        for (int i = 0; i < exter; i++) {
            HWMaterialItem *item = [[HWMaterialItem alloc] init];
            [self.materialItems addObject:item];
        }
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _materialItems.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
        return 425;
    }else if (indexPath.row == 1){
        return 250;
    }else if (indexPath.row == 2){
        return self.tabCell.HW_Height;
    }else if (indexPath.row == 3){
        return self.processCellHeight;
    }else{
        return _item.contentViewHeight;
    }
    
}

-(HWMaterialCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HWMaterialCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.backgroundColor = self.tabCell.backgroundColor;
    cell.item = _materialItems[indexPath.row];
    //设置tableView的cell不能被选中  self.tableView.allowsSection = NO;
    return cell;
}


@end
