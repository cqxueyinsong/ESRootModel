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
    
    UILabel * title = [[UILabel alloc]init];
    [title setBounds:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
    [title setCenter:CGPointMake(title.bounds.size.width/2, 60)];
    [title setFont:[UIFont boldSystemFontOfSize:30]];
    [title setText:@"ESRootModel"];
    [title setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:title];
    
    UILabel * desLabel = [[UILabel alloc]init];
    [desLabel setText:@"  请在控制台看LOG\n  test方法:创建一个TestModel类，通过setter为model对象赋值，然后创建另外一个TestModel类，用之前创建的model类生成的字典为新的model对象赋值\n\n\n   注意:本类目前版本不能识别非对象的属性,所有的属性必须使用OC类,int、float、double、long等基础类型请使用NSNumber\n\n☻☻☻☻☻邮箱:steamxys2013@163.com  "];
    [desLabel setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 20, 20)];
    [desLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [desLabel setNumberOfLines:0];
    [desLabel sizeToFit];
    [desLabel setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/2, CGRectGetMaxY(title.frame) + desLabel.frame.size.height/2 + 20)];
    [self.view addSubview:desLabel];
    
    [self test];
}

- (void)test{
    TestModel * model = [[TestModel alloc]init];
    [model setTestName:@"测试Name"];
    [model setTestId:@(10)];
    [model setTestStrAry:@[@"1",@"2",@"3",@"4"]];
    
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
