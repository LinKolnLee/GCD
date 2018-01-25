//
//  ViewController.m
//  GCDDemo
//
//  Created by admin on 2018/1/25.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // 并行队列（Concurrent Dispatch Queue）：可以让多个任务并行（同时）执行（自动开启多个线程同时执行任务）
   // 并行功能只有在异步（dispatch_async）函数下才有效
   // 串行队列（Serial Dispatch Queue）：让任务一个接着一个地执行（一个任务执行完毕后，再执行下一个任务）
    
    //同步执行（sync）：只能在当前线程中执行任务，不具备开启新线程的能力
    //异步执行（async）：可以在新的线程中执行任务，具备开启新线程的能力
    
    //并行队列的同步执行和串行队列的同步执行有什么区别？？？？？从打印的数据上看是没什么区别的
    //并行队列的异步执行和串行队里的异步执行有什么区别？？？？？ 并行队列会开辟多条线程 串行队列只会开辟一条
    //在开发中串行队列的用处？？什么场景会用到？？
    
    //[self setupSerial];
    //[self setupConcurrent];
    //[self setupMainThread];
    //[self GCDMessage];
    //[self setupBarrier];
   // [self setupAfter];
   // [self setupApply];
    [self setupGroup];
    //[self setupSemaphore];
    //[self setupSynchronized];
    // Do any additional setup after loading the view, typically from a nib.
}
#pragma mark 串行队列
-(void)setupSerial{
    //串行队列 + 同步执行
    //[self setupSyncSerial];
    //串行队列 + 异步执行
    //[self setupAsyncSerial];
}
#pragma mark 并行队列
-(void)setupConcurrent{
    //并行队列 + 同步执行
    //[self setupSyncConcurrent];
    //并行队列 + 异步执行
    //[self setupAsyncConcurrent];
}
#pragma mark 主队列
-(void)setupMainThread{
    //主队列 + 同步执行
    //[self setupSyncMainThread];
    //[self setupTestMainThread];
    //主队列 + 异步执行
    //[self setupAsyncMainThread];
}
#pragma mark 串行队列 + 同步执行
-(void)setupSyncSerial{
    //不会开启新线程，在当前线程执行任务。任务是串行的，执行完一个任务，再执行下一个任务
    NSLog(@"SyncSerial == begin %@",[NSThread currentThread]);
    dispatch_queue_t queue = dispatch_queue_create("serial.queue", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
    });
    NSLog(@"SyncSerial == end %@",[NSThread currentThread]);
    // Thread 的地址一样 没有创建其他线程 始终在一个线程内执行
}
#pragma mark 串行队列+异步执行
-(void)setupAsyncSerial{
    //会开启新线程，但是因为任务是串行的，执行完一个任务，再执行下一个任务
    NSLog(@"SyncSerial == begin %@",[NSThread currentThread]);
    dispatch_queue_t queue = dispatch_queue_create("AsyncSerial", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"2------%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"3------%@",[NSThread currentThread]);
        }
    });
    NSLog(@"SyncSerial == end %@",[NSThread currentThread]);
    //开辟了一个新线程
}
#pragma mark 并行队列 + 同步执行
-(void)setupSyncConcurrent{
    NSLog(@"SyncConcurrent == begin %@",[NSThread currentThread]);
    dispatch_queue_t queue = dispatch_queue_create("SyncConcurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"2------%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"3------%@",[NSThread currentThread]);
        }
    });
    NSLog(@"SyncSerial == end %@",[NSThread currentThread]);
    //从并行队列 + 同步执行中可以看到，所有任务都是在主线程中执行的。由于只有一个线程，所以任务只能一个一个执行。
    //同时可以看到，所有任务都在打印的syncConcurrent---begin和syncConcurrent---end之间，这说明任务是添加到队列中马上执行的。
}
#pragma mark 并行队列 + 异步执行
-(void)setupAsyncConcurrent{
    NSLog(@"AsyncConcurrent == begin %@",[NSThread currentThread]);
    dispatch_queue_t queue = dispatch_queue_create("AyncConcurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"2------%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"3------%@",[NSThread currentThread]);
        }
    });
    NSLog(@"AsyncConcurrent == end %@",[NSThread currentThread]);
    //在并行队列 + 异步执行中可以看出，除了主线程，又开启了3个线程，并且任务是交替着同时执行的。
    
    //另一方面可以看出，所有任务是在打印的syncConcurrent---begin和syncConcurrent---end之后才开始执行的。说明任务不是马上执行，而是将所有任务添加到队列之后才开始异步执行。
}
#pragma mark 主队列 + 同步执行
-(void)setupSyncMainThread{
    NSLog(@"SyncMainThread == begin %@",[NSThread currentThread]);
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"2------%@",[NSThread currentThread]);
        }
    });

    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"3------%@",[NSThread currentThread]);
        }
    });
    NSLog(@"SyncMainThread == end %@",[NSThread currentThread]);
    //发生崩溃警告
    //把任务放到了主队列中，也就是放到了主线程的队列中。而同步执行有个特点，就是对于任务是立马执行的。那么当我们把第一个任务放进主队列中，它就会立马执行。但是主线程现在正在处理syncMain方法，所以任务需要等syncMain执行完才能执行。

}
#pragma mark 在异步线程中运行同步操作
-(void)setupTestMainThread{
    //在并行队列中的异步线程中运行
    dispatch_queue_t queue = dispatch_queue_create("test.Queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        [self setupSyncMainThread];
    });
    //不会开启新线程，执行完一个任务，再执行下一个任务 立即执行（在其他线程中调用）
}
-(void)setupAsyncMainThread{
    NSLog(@"AsyncMainThread == begin %@",[NSThread currentThread]);;
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"2------%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"3------%@",[NSThread currentThread]);
        }
    });
    
     NSLog(@"AsyncMainThread == end %@",[NSThread currentThread]);;
    // 任务的异步执行是先加入到队列中在执行的 
}
#pragma mark GCD线程之间通讯
-(void)GCDMessage{
    //DISPATCH_QUEUE_PRIORITY_DEFAULT 优先级设置
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            NSLog(@"2-------%@",[NSThread currentThread]);
//        });
//        for (int i = 0; i < 2; ++i) {
//            NSLog(@"1------%@",[NSThread currentThread]);
//        }
    
    
        
    //});
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"2-------%@",[NSThread currentThread]);
        });
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
    });
    //同步调主线程和异步调主线程的区别？ 没区别
    //将for循环放到主线程下边有什么区别？没区别
    //将for循环放到同步主线程下边有什么区别？先执行同步操作 在执行异步操作
    //同步线程通知不到主线程
    //执行完For函数后调用的主线程
}
#pragma mark barrier 函数 栅栏函数
-(void)setupBarrier{
    dispatch_queue_t queue = dispatch_queue_create("barrier", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
         NSLog(@"----1-----%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
         NSLog(@"----2-----%@", [NSThread currentThread]);
    });
    dispatch_barrier_async(queue, ^{
        NSLog(@"-==-========------%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"----4-----%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"----5-----%@", [NSThread currentThread]);
    });
    //执行完栅栏前面的操作之后，才执行栅栏操作，最后再执行栅栏后边的操作。用栅栏函数来控制执行顺序
    //应用场景？？？
}
#pragma mark after 延时执行
-(void)setupAfter{
    NSLog(@"begin==========");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"end========");
    });
}
#pragma mark once
-(void)setupOnce{
    //我们在创建单例、或者有整个程序运行过程中只执行一次的代码时，我们就用到了GCD的dispatch_once方法。使用dispatch_once函数能保证某段代码在程序运行过程中只被执行1次。
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //默认线程安全
    });
}
#pragma mark apply
-(void)setupApply{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_apply(10, queue, ^(size_t index) {
        NSLog(@"%zd ------- %@",index,[NSThread mainThread]);
    });
    //不在一个线程中执行
    //Swift中的For循环是不是这种方式？？？
}
-(void)setupGroup{
    //线程组的线程执行完以后dispatch_group_notify才会执行
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"end===%@",[NSThread currentThread]);
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"1===%@",[NSThread currentThread]);
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"2===%@",[NSThread currentThread]);
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"3===%@",[NSThread currentThread]);
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"4===%@",[NSThread currentThread]);
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"5===%@",[NSThread currentThread]);
    });
    
    
}
-(void)setupSemaphore{
    dispatch_group_t group = dispatch_group_create();
    //最多运行并发数
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(11);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i = 0; i<100; i++) {
        //等待，直到信号量大于0时，即可操作，同时将信号量-1
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_group_async(group, queue, ^{
            NSLog(@"%i",i);
            sleep(4);
            // 信号释放通知，即让信号量+1
            dispatch_semaphore_signal(semaphore);
        });
    }
    //应用场景？？？
    
}
#pragma mark @synchronized

-(void)setupSynchronized{
    NSObject *obj = [[NSObject alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //被@synchronized()的对象只有在这个线程执行完成以后才可以被别的线程访问
        @synchronized(obj) {
            NSLog(@"需要线程同步的操作1 开始");
            sleep(3);
            NSLog(@"需要线程同步的操作1 结束");
        }
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1);
        @synchronized(obj) {
            NSLog(@"需要线程同步的操作2");
        }
    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
