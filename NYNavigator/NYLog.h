//
//  NYLog.h
//  NYNavigatorDemo
//
//  Created by William on 16/1/7.
//  Copyright © 2016年 William. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#define NYLog(format, ...)                                                     \
  __NYLog(@__FILE__, __LINE__,                                                 \
          [NSString stringWithFormat:format, ##__VA_ARGS__])
#else
#define NYLog(format, ...)
#endif

@interface NYLog : NSObject
void __NYLog(NSString *file, NSInteger line, NSString *content);
@end
