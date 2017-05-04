//
//  TestModel.h
//  TestModel
//
//  Created by eShow on 16/8/19.
//  Copyright © 2016年 eShow. All rights reserved.
//

#import "ESRootModel.h"
#import "TestSubModel.h"

typedef NS_ENUM(NSInteger, TYPE_TEST_) {
    TYPE_TEST_FIRST = 1,
    TYPE_TEST_SECOND = 2
};

@interface TestModel : ESRootModel

@property (nonatomic, strong)NSString           * testName;
@property (nonatomic, strong)NSNumber           * testId;
@property (nonatomic, strong)NSArray            * testStrAry;
@property (nonatomic, strong)TestSubModel       * subModel;
@property (nonatomic, assign)TYPE_TEST_           type;

@property (nonatomic, assign)NSInteger            intV;

@property (nonatomic, assign)float                floatV;

//字典中转化为ASCII码
@property (nonatomic, assign)char                 charV;

@property (nonatomic, assign)BOOL                 boolV;
@end
