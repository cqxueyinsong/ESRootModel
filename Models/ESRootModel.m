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

static NSString * ESRootModel_Default_Type = @"_ESRootModel_Default_Type";

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

    Class currentclass = [self class];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString * className = NSStringFromClass(currentclass);
    
    while ( ![className isEqualToString:@"ESRootModel"] ) {
        
        unsigned int propsCount;
        objc_property_t *props = class_copyPropertyList(currentclass, &propsCount);
        
        for(int i = 0;i < propsCount; i++){
            
            objc_property_t prop = props[i];
            NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
            
            if ([self getUselessFieldsWithKey:propName]) {
                continue;
            }
            
            id value = [self valueForKey:propName];
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
        
        for(int i = 0;i < propsCount; i++){
            
            objc_property_t prop = props[i];
            NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];

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
        for(NSString *key in objdic.allKeys){
            
            [dic setObject:[ESRootModel getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return [NSDictionary dictionaryWithDictionary:dic];
    }
    
    return [ESRootModel getObjectData:obj];
}

#ifdef DEBUG
- (void)dealloc{
//    NSLog(@"%@ dealloc",[self class]);
}
#endif


#pragma mark - 用字典为当前对象赋值


- (void)setObjectsWithDic:(NSDictionary *)diconary{
    
    
    Class currentclass = [self class];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString * className = NSStringFromClass(currentclass);
    
    
    while ( ![className isEqualToString:@"ESRootModel"] ) {
        
        unsigned int propsCount;
        objc_property_t *props = class_copyPropertyList(currentclass, &propsCount);
        
        for(int i = 0;i < propsCount; i++){
            
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
            if (attributes.count > 1) {
                type = [attributes objectAtIndex:1];
            }else{
                type = ESRootModel_Default_Type;
            }
            

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
    
    if ([NSStringFromClass(type) isEqualToString:ESRootModel_Default_Type]) {
        return obj;
    }
    
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
            id arrayObj;
            
/**
 当前对象有三种情况:
 
 ①:如果是数组,则找到数组的最里面一层然后实例化该对象一层层返回，递归完毕后追加到当前数组
 
 ②:如果是字典,直接递归当前方法，获取该字典对应的实例赋值后追加到当前数组
 
 ③:如果既不是字典也不是数组,说明是一个基础的OC的数据类型(NSString,NSNumber,NSData),直接追加到当前数组
 **/
            if ([objarr[i] isKindOfClass:[NSArray class]] || [objarr[i] isKindOfClass:[NSDictionary class]]) {
                arrayObj = [self object:objarr[i] OfType:arrayType forKey:key];
                
                if (arrayObj) {
                    [arr setObject:arrayObj atIndexedSubscript:i];
                }
            }else{
                [arr addObject:objarr[i]];
            }
            
//本次没有做追加操作，说名当前对象是数组或者字典且最后没有获取到对应的实例
            if (arr.count <= i) {
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
