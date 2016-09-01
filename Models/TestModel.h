//
//  TestModel.h
//  TestModel
//
//  Created by eShow on 16/8/19.
//  Copyright © 2016年 eShow. All rights reserved.
//

#import "ESRootModel.h"
#import "TestSubModel.h"
@interface TestModel : ESRootModel

@property (nonatomic, strong)NSString           * testName;
@property (nonatomic, strong)NSNumber           * testId;
@property (nonatomic, strong)TestSubModel       * subModel;


@end
