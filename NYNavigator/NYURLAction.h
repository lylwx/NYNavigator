//
//  NYURLAction.h
//  NYTrain
//
//  Created by William on 16/1/5.
//  Copyright © 2016年 William. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSInteger NYNaviAnimation;
#define NYNaviAnimationNone -1 // 没有动画
#define NYNaviAnimationPush 0  // 标准的导航压入动画

@interface NYURLAction : NSObject

/**
 * 需要导航到的url地址
 **/
@property(nonatomic, strong, readonly) NSURL *url;

/**
 * 导航动画，默认为NYNaviAnimationPush
 **/
@property(nonatomic) NYNaviAnimation animation;

/**
 * 所有的参数构建成query
 **/
@property(nonatomic, readonly) NSString *query;

/**
 * 实例化NYURLAction
 **/
+ (id)actionWithURL:(NSURL *)url;
+ (id)actionWithURLString:(NSString *)urlString;
+ (id)actionWithHost:(NSString *)host;
- (id)initWithURL:(NSURL *)url;
- (id)initWithURLString:(NSString *)urlString;
- (id)initWithHost:(NSString *)host;

/**
 * 设置传递参数
 **/
- (void)setInteger:(NSInteger)intValue forKey:(NSString *)key;
- (void)setDouble:(double)doubleValue forKey:(NSString *)key;
- (void)setString:(NSString *)string forKey:(NSString *)key;
- (void)setParamDictionary:(NSDictionary *)dic; //一次写入多个参数

/**
 * 查询传递参数
 **/
- (NSInteger)integerForKey:(NSString *)key;
- (double)doubleForKey:(NSString *)key;
- (NSString *)stringForKey:(NSString *)key;
- (NSDictionary *)queryDictionary;

@end
