//
//  HWTools.m
//  美食街
//
//  Created by 黄炜 on 2018/3/6.
//  Copyright © 2018年 黄炜. All rights reserved.
//

#import "HWTools.h"
@interface HWTools()


//@property (strong, nonatomic) NSMutableArray *dataArray;

@end


@implementation HWTools
//-(NSMutableArray *)dataArray{
//    if (!_dataArray) {
//        _dataArray = [NSMutableArray array];
//    }
//    return _dataArray;
//}


-(void)informIfTheDataExist{
    
    NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"data.plist"];
    NSLog(@"%@",fullPath);
    NSFileManager *fm = [NSFileManager defaultManager];
    //判断是否有 data.plist
    if ([fm fileExistsAtPath:fullPath isDirectory:nil]) {
        NSLog(@"data.plist已存在");
    }else{
        NSMutableArray *dataArray = [NSMutableArray array];
        //如果不存在就创建一个数组 写入data.plist
        [dataArray writeToFile:fullPath atomically:YES];
    }
    
    
}

@end
