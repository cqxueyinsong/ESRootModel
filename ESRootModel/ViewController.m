//
//  ViewController.m
//  TestModel
//
//  Created by eShow on 16/8/19.
//  Copyright © 2016年 eShow. All rights reserved.
//

#import "ViewController.h"
#import "TestModel.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    TestModel * model = [[TestModel alloc]init];
    [model setTestName:@"测试Name"];
    [model setTestId:@(10)];
    
    TestSubModel * subModel = [[TestSubModel alloc]init];
    [subModel setSubName:@"TestModel中的TestSubModel"];
    [subModel setSubId:@(11)];
    
    NSMutableArray * array = [NSMutableArray array];
    for (NSInteger i = 0 ; i < 5; i ++) {
        TestSubModel * model = [[TestSubModel alloc]init];
        [model setSubName:[NSString stringWithFormat:@"testSubModel中的submodels的第%@个testSubmodel",@(i).description]];
        [model setSubId:@(i)];
        [array addObject:model];
    }
    [subModel setSubModels:array];
    
    [model setSubModel:subModel];
    //model转字典
    NSDictionary * jsonObj = [model getObjectData];
    NSLog(@"%@",model);
    //字典转model
    TestModel * jsonModel = [[TestModel alloc]init];
    [jsonModel setObjectsWithDic:jsonObj];
    NSLog(@"%@",jsonModel);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
