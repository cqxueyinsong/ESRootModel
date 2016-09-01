//
//  TestSubModel.h
//  TestModel
//
//  Created by eShow on 16/8/19.
//  Copyright © 2016年 eShow. All rights reserved.
//

#import "ESRootModel.h"

@interface TestSubModel : ESRootModel


@property (nonatomic, strong)NSString                * subName;
@property (nonatomic, strong)NSNumber                * subId;
//TestSubModel类型的数组
@property (nonatomic, strong)NSArray<TestSubModel *> * subModels;

@end
