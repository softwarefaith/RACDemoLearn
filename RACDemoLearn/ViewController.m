//
//  ViewController.m
//  RACDemoLearn
//
//  Created by 蔡杰 on 2017/4/17.
//  Copyright © 2017年 蔡杰. All rights reserved.
//

#import "ViewController.h"

#import <ReactiveCocoa/ReactiveCocoa.h>


@interface ViewController ()

@property (nonatomic,strong) UITextField *rac_TextField;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
   // [self RACSignalDemo];
}

#pragma makr -事件

#pragma mark -- 文本事件
- (void)

- (void)RACSignalDemo{
    // RACSignal: 信号类,当我们有数据产生,创建一个信号!
    //1.创建信号(冷信号!)
    //didSubscribe调用:只要一个信号被订阅就会调用!!
    //didSubscribe作用:利用subscriber发送数据!!
    RACSignal *singal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"有人订阅了~~");
        //3.发送数据
        [subscriber sendNext:@"小妹子，我来了"];
        //发送错误互斥
        [subscriber sendNext:@"大妹子，我也来了"];
        
        [subscriber sendError:[NSError errorWithDomain:@"what" code:-100 userInfo:nil]];
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"我已经收到信号已经销毁");
        }];
    }];
    //2.订阅信号
    //nextBlock调用:只要订阅者发送数据就会调用!
    //nextBlock作用:处理数据,展示UI界面!
    RACDisposable *disposable =  [singal  subscribeNext:^(id x) {
        NSLog(@"subscribe value = %@",x);
    } error:^(NSError *error) {
        NSLog(@"subcribe error = %@",error);
    } completed:^{
        NSLog(@"发送完成");
    }];
    //4.信号销毁
    [disposable dispose];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
