//
//  NYNavigator.h
//  NYTrain
//
//  Created by William on 16/1/5.
//  Copyright © 2016年 William. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NYURLAction.h"

@class NYNavigator;
extern void NYInternalSetNavigator(NYNavigator *navigator);

@protocol NYNavigatorDelegate <NSObject>

@optional

/**
 * 遇到了无法处理的urlAction
 * @param urlAction 无法处理的urlAction
 **/
- (void)navigator:(NYNavigator *)navigator
    onMatchUnhandledURLAction:(NYURLAction *)urlAction;

/**
 * 找到了映射的Class
 **/
- (void)navigator:(NYNavigator *)navigator
    onMatchViewController:(UIViewController *)controller
            withURLAction:(NYURLAction *)urlAction;

@end

@interface NYNavigator : NSObject {
  UINavigationController *_mainNavigationContorller;
  NSString *_handleableURLScheme;
  NSArray *_fileNamesOfURLMapping;

  NSMutableArray *_urlActionWaitingList; //待处理的URLAction

  NSMutableDictionary *
      _urlMapping; // host与NVURLPattern的映射关系，host为key，NVURLPattern为value
}

/**
 * 所有的页面跳转都会在mainNavigationContorller中进行
 */
@property(nonatomic, readonly) UINavigationController *mainNavigationContorller;
@property(nonatomic, readonly) NSString *handleableURLScheme;
@property(nonatomic, readonly) NSArray *fileNamesOfURLMapping;
@property(nonatomic, weak) id<NYNavigatorDelegate> delegate;

/**
 * 具体由不同的App来定义。
 * 一般在业务层中需要重载提供自定义的NYNavigator（使用NYInternal.h
 * NYInternalSetNavigator），并且子类必须实现NYNavigator
 **/
+ (NYNavigator *)navigator;

/**
 * 设置程序的主导航控制器
 * 所有的页面跳转都会在mainNavigationContorller中进行
 **/
- (void)setMainNavigationController:
        (UINavigationController *)mainNavigationContorller;

/**
 * 设置可以处理的URL Scheme
 **/
- (void)setHandleableURLScheme:(NSString *)scheme;

/**
 * 设置URL mapping文件名称
 * url mapping文件只能是包含在工程项目中的文件
 **/
- (void)setFileNamesOfURLMapping:(NSArray *)fileNames;

/**
 * 在当前的NYNavigator栈中打开新的URL
 * 例如：[[NYNavigator navigator] openURL:[NSURL
 * URLWithString:@"dianping://shop?id=123"]]
 * NYOpenURL([NSURL URLWithString:@"dianping://shop?id=123"])
 **/
- (UIViewController *)openURL:(NSURL *)url
           fromViewController:(UIViewController *)controller;

- (UIViewController *)openURLString:(NSString *)urlString
                 fromViewController:(UIViewController *)controller;

/**
 在当前的NYNavigator栈中打开新的URL
 可以向NYURLAction中传入制定的参数，参数可以为integer, double, string
 bool的参数可以用0和1表示
 URL中附带的参数和setXXX:forKey:所设置的参数等价，
 例如下面两种写法是等价的：
 NYURLAction *a = [NYURLAction actionWithURL:@"ny://test?id=1"];
 和
 NYURLAction *a = [NYURLAction actionWithURL:@"ny://test"];
 [a setInteger:1 forKey:@"id"]
 在获取参数时，调用[a integerForKey:@"id"]，返回值均为1
 */
- (UIViewController *)openURLAction:(NYURLAction *)urlAction fromViewController:(UIViewController *)controller;

- (UIViewController *)openURLAction:(NYURLAction *)urlAction;


- (BOOL)pop2Scheme:(NSString *)scheme;
- (BOOL)pop2AnyScheme:(NSArray *)schemeArray;
/**
 * 判断当前页面是否从某个特定的页面跳转而来
 * @param scheme 某个页面的scheme
 */
- (BOOL)isFromScheme:(NSString *)scheme;

@end
