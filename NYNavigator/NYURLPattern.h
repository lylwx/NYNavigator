//
//  NYPattern.h
//  NYTrain
//
//  Created by William on 16/1/5.
//  Copyright © 2016年 William. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NYURLPatternType) {
  NYURLPatternTypeClass = 0, // host对应创建Class
  NYURLPatternTypeHttp = 1   // host对应创建webviewController
};

@interface NYURLPattern : NSObject
@property(nonatomic, strong, readonly) NSString *key;
@property(nonatomic, strong, readonly) NSString *patternString;
@property(nonatomic, readonly) Class targetClass;
@property(nonatomic, readonly) NYURLPatternType type;

/**
 * 设置默认的WebViewController，用于处理http的scheme
 **/
+ (void)setDefaultWebViewControllerClass:(Class)webControllerClass;
+ (NYURLPattern *)patternWithClassName:(NSString *)className
                               withKey:(NSString *)key;
+ (NYURLPattern *)patternWithHttp:(NSString *)url withKey:(NSString *)key;

@end
