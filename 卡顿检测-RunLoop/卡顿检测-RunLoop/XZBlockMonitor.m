//
//  XZBlockMonitor.m
//  卡顿检测-RunLoop
//
//  Created by Alan on 5/7/20.
//  Copyright © 2020 zhaixingzhi. All rights reserved.
//

#import "XZBlockMonitor.h"

@interface XZBlockMonitor (){
    CFRunLoopActivity activity;
}

@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic, assign) NSUInteger timeoutCount;
@end

@implementation XZBlockMonitor

+ (instancetype)sharedInstance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)start{
    [self registerObserver];
    [self startMonitor];
}

static void CallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    XZBlockMonitor *monitor = (__bridge XZBlockMonitor *)info;
    monitor->activity = activity;
    // 发送信号
    dispatch_semaphore_t semaphore = monitor->_semaphore;
    dispatch_semaphore_signal(semaphore);
}

- (void)registerObserver{
    CFRunLoopObserverContext context = {0,(__bridge void*)self,NULL,NULL};
    //NSIntegerMax : 优先级最小
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                                            kCFRunLoopAllActivities,
                                                            YES,
                                                            NSIntegerMax,
                                                            &CallBack,
                                                            &context);
    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
}

- (void)startMonitor{
    // 创建信号
    _semaphore = dispatch_semaphore_create(0);
    // 在子线程监控时长
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (YES)
        {
            //超时时间是 1 秒，没有等到信号量，st 就不等于 0， RunLoop 所有的任务
            long st = dispatch_semaphore_wait(_semaphore, dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC));
            if (st != 0)
            {
                if (activity == kCFRunLoopBeforeSources || activity == kCFRunLoopAfterWaiting)
                {
                    if (++self->_timeoutCount < 2){
                        NSLog(@"timeoutCount==%d",_timeoutCount);
                        continue;
                    }
                    NSLog(@"检测到卡顿");
                }
            }
            _timeoutCount = 0;
        }
    });
}



@end
