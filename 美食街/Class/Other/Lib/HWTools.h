//
//  HWTools.h
//  美食街
//
//  Created by 黄炜 on 2018/3/6.
//  Copyright © 2018年 黄炜. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWTools : NSObject

//进入app判断是否在缓存文件中存有'data.plist'文件, 如果没有就创建一个
-(void)informIfTheDataExist;
@end
