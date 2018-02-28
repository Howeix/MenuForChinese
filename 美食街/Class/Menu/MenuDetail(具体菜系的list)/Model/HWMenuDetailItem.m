//
//  HWMenuDetailItem.m
//  美食街
//
//  Created by 黄炜 on 2018/1/22.
//  Copyright © 2018年 黄炜. All rights reserved.
//

#import "HWMenuDetailItem.h"

@implementation HWMenuDetailItem

// //** classid */
//@property (strong, nonatomic) NSString *classid;
///* content  label*/
//@property(strong,nonatomic)NSString *content;
///* cookingtime  label*/
//@property(strong,nonatomic)NSString *cookingtime;
////** id  */
////@property (strong, nonatomic) NSString *id;
////** material  字典数组: @[@{@"mname" : @"xx", @"amount" : @"xx"},...]  */
//@property (strong, nonatomic) NSArray *material;
///* name  label */
//@property(strong,nonatomic)NSString *name;
///* peoplenum  label */
//@property(strong,nonatomic)NSString *peoplenum;
///* pic  UIImageView*/
//@property(strong,nonatomic)NSString *pic;
///* preparetime  label*/
//@property(strong,nonatomic)NSString *preparetime;
////** process   字典数组 @[@{@"pcontent": @"xxx", @"pic" : @"xxx"}] */
//@property(strong, nonatomic)NSArray *process;
///* tag */
//@property(strong,nonatomic)NSString *tag;


-(CGFloat)contentViewHeight{
    
    CGSize contentSize = CGSizeMake(HWScreenW, MAXFLOAT);
    
    return [_content sizeWithFont:[UIFont systemFontOfSize:19] constrainedToSize:contentSize].height + 25;
}

-(NSString *)content{
    return [_content stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
}
//归档的时候调用
/** 将某个对象写入文件的时候会调用,在这个方法中说明哪些对象的哪些属性需要存储*/
-(void)encodeWithCoder:(NSCoder *)aCoder{
//    [aCoder encodeObject:self.name forKey:@"name"];
//    [aCoder encodeObject:self.content forKey:@"content"];
//    [aCoder encodeObject:self.cookingtime forKey:@"cookingtime"];
//    [aCoder encodeObject:self.material forKey:@"material"];
//    [aCoder encodeObject:self.peoplenum forKey:@"peoplenum"];
//    [aCoder encodeObject:self.pic forKey:@"pic"];
//    [aCoder encodeObject:self.preparetime forKey:@"preparetime"];
//    [aCoder encodeObject:self.process forKey:@"process"];
//    [aCoder encodeObject:self.tag forKey:@"tag"];
    [aCoder encodeRootObject:self];
}
/** 解档时候调用,在这个方法中说清楚哪些属性要解档*/
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        //读取文件内容
        self = [aDecoder decodeObject];
    }
    return self;
}

@end
