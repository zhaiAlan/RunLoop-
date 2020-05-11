//
//  XZBlockMonitor.h
//  卡顿检测-RunLoop
//
//  Created by Alan on 5/7/20.
//  Copyright © 2020 zhaixingzhi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZBlockMonitor : NSObject
+ (instancetype)sharedInstance;

- (void)start;

@end

NS_ASSUME_NONNULL_END
