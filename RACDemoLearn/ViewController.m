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
    //文本事件
  //  [self textFieldRAC];
    //[self gesRAC];
 //   [self notifyRAC];
   // [self RACSignalDemo];
    
    [self switchRACWithIndex:9];
    
//    void (^t2)() = ^(id name){
//        NSLog(@"我服了===%@",name);
//        return;
//    };
//    
//    t2(@"123");
}

#pragma mark - RAC总类
-(void)switchRACWithIndex:(NSInteger)index{
    
    switch (index) {
            
        case 9:{
            [self demoOfReduce];
            break;
        }
    
        case 8:{
            [self demoOfMap];
            break;
        }
            
        case 7:{
            
            [self demoOfZip];
            break;
        }
        case 6:{
            [self demoOfConat];
            break;
        }
        case 5:{
            
            [self demoOfBind];
            break;
        }
        case 4:{
            
            [self demoOfRACGroupSubject];
            break;
        }
        case 0://RAC
        {
            [self RACSignalDemo];
            break;
        }
        case 1:{
            
            [self demoOfRACSubject];
            break;
        }
        case 2:{
            [self demoOfRACBehaviorSubject];
            break;
        }
        case 3:{
            
            [self demoOfRACReplaySubject];
            break;
        }
        
            break;
            
        default:
            break;
    }
}

#pragma makr -事件

#pragma mark -- 文本事件
- (void)textFieldRAC{
    
    _rac_TextField = ({
    
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 200, 40)];
        textField.borderStyle = UITextBorderStyleLine;
        textField;
    
    });
    [self.view addSubview:_rac_TextField];
    
//    [[self.rac_TextField rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(NSString * x) {
//        
//        NSLog(@"textFiled = %@",x);
//    }];
    
    [self.rac_TextField.rac_textSignal subscribeNext:^(NSString * x) {
        NSLog(@"textFiled222 = %@",x);
    }];
    
}
#pragma mark --手势
-(void)gesRAC{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    
    [self.view addGestureRecognizer:tap];
    [[tap rac_gestureSignal] subscribeNext:^(UITapGestureRecognizer *tap) {
        NSLog(@"用户点击");
    }];
}

#pragma mark - Notify
-(void)notifyRAC{
    
RACSignal *signal = [[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidBecomeActiveNotification object:@"231"];
    
    [signal subscribeNext:^(NSNotification * x) {
        
        NSLog(@"我收到了通知%@",x.object);
    }];
    
}

-(void)demoOfReduce{
    
    
    RACSignal *A  = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        
         RACTuple *t = [RACTuple tupleWithObjects:@10, @5,@20, nil];
        [subscriber sendNext:t];
      //  [subscriber sendNext:@"20"];
        
        // [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"A 摧毁");
        }];
    }];

    
    RACSignal *B = [A reduceEach:^id(id number,id number2){
        
        NSLog(@"B=%@",number);
        return @([number integerValue] + [number2 integerValue]);
    }];
    
    [B subscribeNext:^(id x) {
        NSLog(@"-----%@",x);
    }];
    
    
}

-(void)demoOfMap{
    
    RACSignal *A  = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@"10"];
        [subscriber sendNext:@"20"];
        
        // [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"A 摧毁");
        }];
    }];
    
    
   RACSignal *C =  [A mapReplace:@"50"];
    
    RACSignal *B = [A  map:^id(id value) {
        return @([value integerValue] * 10);
    }];
    
    
    
    [B subscribeNext:^(id x) {
       
        NSLog(@"%@",x);
    }];
    
    [C subscribeNext:^(id x) {
        
        NSLog(@"C接收%@",x);
    }];
    
    
}
-(void)demoOfZip{
    
    
    
    //A B至少发送一次消息nextblock
    RACSignal *A  = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
       [subscriber sendNext:@"A0"];
        [subscriber sendNext:@"A1"];

       // [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"A 摧毁");
        }];
    }];
    
    RACSignal *B = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"B0"];
        [subscriber sendNext:@"B1"];

       // [subscriber sendError:nil];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"B 摧毁");
        }];    }];
    
    
    RACSignal *C = [A zipWith:B];
    
    RACDisposable *cd =   [C subscribeNext:^(id x) { //返回RACTuple
        NSLog(@"C == %@",x);
    }];
    
    [cd dispose];
}

-(void)demoOfConat{
    
    
    RACSignal *A  = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@"A"];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"A 摧毁");
        }];
    }];
    
    RACSignal *B = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"B"];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"B 摧毁");
        }];    }];
    
    
    RACSignal *C = [A concat:B];
    
   RACDisposable *cd =   [C subscribeNext:^(id x) {
        NSLog(@"C == %@",x);
    }];
    
    [cd dispose];
}

-(void)demoOfBind{
    
    
    RACSignal *A  = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        //实际数据来源
        NSLog(@"A开始发送数据");
        [subscriber sendNext:@"A"];
        return nil;
    }];
    
    RACSignal *C  = [A bind:^RACStreamBindBlock{
        
        
    
        return ^RACSignal *(id value, BOOL *stop){
            NSLog(@"这里C也受到了==%@",value);
            return [RACSignal return:value];
        };
        
    }];
    
    
    [C subscribeNext:^(id x) {
        
        
        NSLog(@"C发送==%@",x);
    }];
    
//    [A subscribeNext:^(id x) {
//        
//    
//        NSLog(@"A发送==%@",x);
//    }];
//    
    
    
}

- (void)demoOfRACGroupSubject{
    
   // RACGroupedSignal *groupSubject = [RACGroupedSignal signalWithKey:@"AAAAA"];
    
    
   RACSubject *subject = [RACSubject subject];
   RACSignal *signal = [ subject groupBy:^id<NSCopying>(id object) {
       
       NSLog(@"groupBy");
       return nil;
    } transform:^id(id object) {
        NSLog(@"transform");

        return nil;
    }];
    
    [signal subscribeNext:^(id x) {
        
        NSLog(@"我来了==%@",x);
    }];
    
   
    
}


- (void)demoOfRACReplaySubject{
    
    
    RACReplaySubject *behaviorSubject = [RACReplaySubject replaySubjectWithCapacity:6];
    
    [behaviorSubject  subscribeNext:^(id x) {
        NSLog(@"接收到了数据A-%@",x);
        
    }];
    
    [behaviorSubject sendNext:@"001"];
    
    [behaviorSubject subscribeNext:^(id x) {
        
        NSLog(@"接收到了数据B-%@",x);
    }];
    
    [behaviorSubject sendNext:@"002"];
    
    
    [behaviorSubject subscribeNext:^(id x) {
        
        NSLog(@"接收到了数据C-%@",x);
    }];
    
    //[behaviorSubject sendNext:@"003"];
    
    
}


- (void)demoOfRACBehaviorSubject{
    
    
    RACBehaviorSubject *behaviorSubject = [RACBehaviorSubject behaviorSubjectWithDefaultValue:@(000)];
    
    [behaviorSubject  subscribeNext:^(id x) {
        NSLog(@"接收到了数据A-%@",x);

    }];
    
    [behaviorSubject sendNext:@"001"];
    
    [behaviorSubject subscribeNext:^(id x) {
        
        NSLog(@"接收到了数据B-%@",x);
    }];
    
    [behaviorSubject sendNext:@"002"];
    
    
    [behaviorSubject subscribeNext:^(id x) {
        
        NSLog(@"接收到了数据C-%@",x);
    }];
    
    [behaviorSubject sendNext:@"003"];

    
}

- (void)demoOfRACSubject{
    
    RACSubject *subject = [RACSubject subject];
    
    [subject sendNext:@"000000"];

    [subject subscribeNext:^(id x) {
        
        NSLog(@"接收到了数据A-%@",x);
    }];
    [subject sendNext:@"001"];

    [subject subscribeNext:^(id x) {
        
        NSLog(@"接收到了数据B-%@",x);
    }];
    
    [subject sendNext:@"002"];
    
    
    [subject subscribeNext:^(id x) {
        
        NSLog(@"接收到了数据C-%@",x);
    } completed:^{
        NSLog(@"C完成了");
    }];
    
    [subject subscribeCompleted:^{
        
        NSLog(@"订阅完成了");
    }];
    
    [subject sendCompleted];

}

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
        
        [subscriber sendNext:@"小妹子1，我来了"];
        //发送错误互斥
        [subscriber sendNext:@"大妹子1，我也来了"];
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"我已经收到信号已经销毁");
        }];
    }];
    //2.订阅信号
    //nextBlock调用:只要订阅者发送数据就会调用!
    //nextBlock作用:处理数据,展示UI界面!
    RACDisposable *disposable =  [[singal startWith:@"小妹子1，我来了"]  subscribeNext:^(id x) {
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
