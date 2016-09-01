//
//  Models.h
//  Reuse
//
//  Created by xys on 15/11/23.
//  Copyright © 2015年 xuchen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESRootModel : NSObject


/**
 *  @author EShow, 16-08-18 17:08:19
 *
 *  @brief 这个字段非常重要，当某个model类的某个属性为数组(该数组的数据类型也是一个model类，如果是基础类型请忽略)时，请吧该属性的属性名作为key值，该属性的数组里面元素最终的类型的字符串作为value保存在当前字典里
 */
@property (nonatomic,strong,readonly)NSDictionary * arrayTypesForKey;

/**
 *  @author EShow, 16-08-19 11:08:01
 *
 *  @brief model转换为字典时该类里面不需要的字段，通过设置 @{@"FieldsName" : @(NO)}来赋值
 */
@property (nonatomic,strong,readonly)NSDictionary * uselessFields;

/**
 *  @author EShow, 16-08-19 12:08:19
 *
 *  @brief model转化为字典
 *
 *  @return 返回的属性列表的字典，不包括uselessFields中忽略的字段
 */
- (NSDictionary*)getObjectData;

/**
 *  @author EShow, 16-08-19 12:08:01
 *
 *  @brief 为该model赋值
 *
 *  @param diconary 传入所需要的字典
 */
- (void)setObjectsWithDic:(NSDictionary *)diconary;

@end
