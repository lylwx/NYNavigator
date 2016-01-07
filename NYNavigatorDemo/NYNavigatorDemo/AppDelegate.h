//
//  AppDelegate.h
//  NYNavigatorDemo
//
//  Created by William on 16/1/7.
//  Copyright © 2016年 William. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property(strong, nonatomic) UIWindow *window;
// 主导航控制器
@property(strong, nonatomic, readonly)
    UINavigationController *navigationController;

@end

