//
//  Models.m
//  Reuse
//
//  Created by xys on 15/11/23.
//  Copyright © 2015年 xuchen. All rights reserved.
//

#import "ESRootModel.h"
#import <objc/runtime.h>
#import <objc/message.h>
@implementation ESRootModel





- (void)setValue:(id)value forUndefinedKey:(NSString *)key{

#if DEBUG
    NSLog(@"想要给%@类中的%@属性赋值为%@ 但是当前类没有%@",[self class],key,value,key);
#endif
}

- (NSString *)description{
    NSString * str  = [super description];
    NSString * jsonStr;
    if ([self getObjectData]) {
        jsonStr = [[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:[self getObjectData] options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
    }else{
        jsonStr = @"nil";
    }
    
    return [NSString stringWithFormat:
            @"\n<==============%@============== \n地址 : %@ \n内容 : \n%@ \n==============%@==============>",[self class],str,jsonStr,[self class]];
}

#pragma model转化为字典
/**
 *  获取当前model类的字典属性
 *
 *  @return 返回对应的字典
 */
- (NSDictionary *)getObjectData{
    return [ESRootModel getObjectData:self];
}

/**
 *  将某个类的属性转化成字典
 *
 *  @param obj 对应的类
 *
 *  @return 返回对应的字典
 */
+ (NSDictionary*)getObjectData:(id)obj{
    
   
    Class currentclass = [obj class];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString * className = NSStringFromClass(currentclass);
    
    while ( ![className isEqualToString:@"ESRootModel"] ) {
        
        unsigned int propsCount;
        objc_property_t *props = class_copyPropertyList(currentclass, &propsCount);
        
        for(int i = 0;i < propsCount; i++)
        {
            objc_property_t prop = props[i];
            NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
            
            if ([ESRootModel isNotRequiredToDictionary:propName]) {
                continue;
            }
            
            id value = [obj valueForKey:propName];
            if(value == nil){
                continue;
            }
            else{
                value = [ESRootModel getObjectInternal:value];
            }
            [dic setObject:value forKey:propName];
        }
        free(props);
        currentclass = [currentclass superclass];
        className = NSStringFromClass(currentclass);
    }
    return [NSDictionary dictionaryWithDictionary:dic];
}


+ (id)getObjectInternal:(id)obj{
    
    if([obj isKindOfClass:[NSString class]]
       || [obj isKindOfClass:[NSNumber class]]
       || [obj isKindOfClass:[NSNull class]]
       ||[obj isKindOfClass:[NSData class]]){
        return obj;
    }
    if([obj isKindOfClass:[NSArray class]]){
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i = 0;i < objarr.count; i++){
            [arr setObject:[ESRootModel getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return [NSArray arrayWithArray:arr];
    }
    if([obj isKindOfClass:[NSDictionary class]]){
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys)
        {
            [dic setObject:[ESRootModel getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return [NSDictionary dictionaryWithDictionary:dic];
    }
    
    return [ESRootModel getObjectData:obj];
}

#ifdef DEBUG
- (void)dealloc{
    NSLog(@"%@ dealloc",[self class]);
}
#endif

/**
 *  @author EShow, 16-08-18 16:08:58
 *
 *  @brief 当前属性不需要包含在该字典里面
 *
 *  @param propName 不需要包含的字段名
 *
 *  @return 是否需要包含
 */
+ (BOOL)isNotRequiredToDictionary:(NSString *)propName{
    return ([propName isEqualToString:@"isUseObjResponse"]||[propName isEqualToString:@"responseClass"]);
}


#pragma mark - 用字典为当前对象赋值


- (void)setObjectsWithDic:(NSDictionary *)diconary{
    
    
    Class currentclass = [self class];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString * className = NSStringFromClass(currentclass);
    
    
    while ( ![className isEqualToString:@"ESRootModel"] ) {
        
        unsigned int propsCount;
        objc_property_t *props = class_copyPropertyList(currentclass, &propsCount);
        
        for(int i = 0;i < propsCount; i++)
        {
            objc_property_t prop = props[i];
            NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
            NSString * type = [NSString stringWithUTF8String:property_getAttributes(prop)];
            NSArray * attributes = [type componentsSeparatedByString:@"\""];
#if DEBUG
            if (attributes.count > 1) {
                NSString * errorLog = [NSString stringWithFormat:@"%@属性%@为基础类型",[self class],propName];
                NSAssert(attributes.count > 1, errorLog);
            }
#endif
            type = [attributes objectAtIndex:1];

            id value = [diconary valueForKey:propName];
            if(value == nil){
                continue;
            }
            else{
                value = [self object:diconary[propName] OfType:NSClassFromString(type) forKey:propName];
            }
            if (value) {
                [dic setObject:value forKey:propName];
            }
        }
        
        free(props);
        currentclass = [currentclass superclass];
        className = NSStringFromClass(currentclass);
    }
    [self setValuesForKeysWithDictionary:dic];
}

- (id)object:(id)obj OfType:(Class)type forKey:(NSString *)key{
    
    if ([obj isKindOfClass:[NSDictionary class]]) {
        ESRootModel * model = [[type alloc]init];
        [model setObjectsWithDic:obj];
        return model;
    }
    if([obj isKindOfClass:[NSString class]]
       || [obj isKindOfClass:[NSNumber class]]
       ||[obj isKindOfClass:[NSData class]]){
        return obj;
    }
    
    if([obj isKindOfClass:[NSArray class]]){
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i = 0;i < objarr.count; i++){
            
            Class arrayType = NSClassFromString([self getArrayTypeWithKey:key]);
            id arrayObj = [self object:objarr[i] OfType:arrayType forKey:key];
            if (arrayType) {
                [arr setObject:arrayObj atIndexedSubscript:i];
            }else{
#if DEBUG
                NSString * errorLog = [NSString stringWithFormat:@"%@类在数组赋值的时候，%@为数组且内容为字典，没有提供该属性的类型,请在arrayTypesForKey填充类型",[self class],key];
                NSLog(@"%@",errorLog);
                NSAssert(arrayObj != nil, errorLog);
#else
                //上线后如果代码运行到这里说明出bug了，可以用其他方式统计，在此处不会崩溃
#endif

            }
            
        }
        return [NSArray arrayWithArray:arr];
    }
    
    return nil;
}

- (NSString *)getArrayTypeWithKey:(NSString *)key{
    return self.arrayTypesForKey[key];
}

- (BOOL)getUselessFieldsWithKey:(NSString *)key{
    return [self.uselessFields[key] boolValue];
}

@end
