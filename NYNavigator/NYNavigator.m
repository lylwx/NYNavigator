//
//  NYNavigator.m
//  NYTrain
//
//  Created by William on 16/1/5.
//  Copyright © 2016年 William. All rights reserved.
//

#import "NYNavigator.h"
#import "NYURLPattern.h"
#import "NSArray+Functional.h"
#import "NYNavigationViewControllerProtocal.h"
#import "NYLog.h"

static NYNavigator *gNavigator = nil;
void NYInternalSetNavigator(NYNavigator *navigator) { gNavigator = navigator; }

@implementation NYNavigator {
  NSTimer *_checkBlockTimer; // 检查堵塞模式消失的事件
}

- (id)init {
  self = [super init];
  if (self) {
    _urlActionWaitingList = [NSMutableArray array];
    _handleableURLScheme = @"nymer";
  }
  return self;
}

- (void)checkTimerBlockModeDismiss {
  if (_urlActionWaitingList.count < 1) {
    [_checkBlockTimer invalidate];
    _checkBlockTimer = nil;
    return;
  }
  if (![self inBlockMode]) {
    [_checkBlockTimer invalidate];
    _checkBlockTimer = nil;
    [self flush];
  }
}

- (BOOL)inBlockMode {
  return [self.mainNavigationContorller presentedViewController];
}

- (void)flush {
  while (_urlActionWaitingList.count > 0) {
    if ([self inBlockMode]) {
      if (!_checkBlockTimer) {
        _checkBlockTimer = [NSTimer
            scheduledTimerWithTimeInterval:0.4
                                    target:self
                                  selector:@selector(checkTimerBlockModeDismiss)
                                  userInfo:nil
                                   repeats:YES];
      }
      return;
    }
    NYURLAction *urlAction = _urlActionWaitingList[0];
    [_urlActionWaitingList removeObject:urlAction];
    [self openURLAction:urlAction];
  }
}

- (BOOL)pop2Scheme:(NSString *)scheme {
  return [self pop2AnyScheme:[NSArray arrayWithObject:scheme]];
}

- (BOOL)pop2AnyScheme:(NSArray *)schemeArray {
  if (schemeArray.count == 0 || !_mainNavigationContorller) {
    return NO;
  }

  if ([self inBlockMode]) {
    return NO;
  }

  for (NSInteger i = self.mainNavigationContorller.viewControllers.count - 1;
       i >= 0; i--) {
    for (NSString *scheme in schemeArray) {
      NYURLPattern *pattern =
          [_urlMapping objectForKey:[scheme lowercaseString]];
      Class class = pattern.targetClass;
      if (class == nil) {
        return NO;
      }
      if ([self.mainNavigationContorller.viewControllers[i]
              isKindOfClass:class]) {
        [self.mainNavigationContorller
            popToViewController:self.mainNavigationContorller.viewControllers[i]
                       animated:YES];
        return YES;
      }
    }
  }
  return NO;
}

- (NSMutableDictionary *)loadPattern {
  if (_urlMapping) {
    [_urlMapping removeAllObjects];
  } else {
    _urlMapping = [NSMutableDictionary dictionary];
  }

  for (int i = 0; i < self.fileNamesOfURLMapping.count; i++) {
    NSString *fileName = self.fileNamesOfURLMapping[i];
    NSString *path =
        [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    NSString *content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:nil];
    if (content) {
      NSArray *eachLine = [content componentsSeparatedByString:@"\n"];
      for (NSString *aString in eachLine) {
        NSString *lineString =
            [aString stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (lineString.length < 1) {
          // 空行
          continue;
        }
        NSRange commentRange = [lineString rangeOfString:@"#"];
        if (commentRange.location == 0) {
          // #在开头，表明这一行是注释
          continue;
        }
        if (commentRange.location != NSNotFound) {
          // 其后有注释，需要去除后面的注释
          lineString = [lineString substringToIndex:commentRange.location];
        }
        if ([lineString rangeOfString:@":"].location != NSNotFound) {
          NSString *omitString =
              [lineString stringByReplacingOccurrencesOfString:@" "
                                                    withString:@""];
          NSArray *kv = [omitString componentsSeparatedByString:@":"];
          if (kv.count == 2) {
            // got it
            NSString *host = [kv[0] lowercaseString];
            NSString *className = kv[1];
            [_urlMapping setObject:[NYURLPattern patternWithClassName:className
                                                              withKey:host]
                            forKey:host];
          }
        }
      }
    } else {
      NYLog(@"[url mapping error] file(%@) is empty!!!!", fileName);
    }
  }
  return _urlMapping;
}

- (BOOL)isFromScheme:(NSString *)scheme {
  NYURLPattern *pattern = [_urlMapping objectForKey:[scheme lowercaseString]];
  Class class = pattern.targetClass;
  if (class == nil)
    return NO;
  id target =
      [self.mainNavigationContorller.viewControllers NY_find:^BOOL(id obj) {
        return [obj isKindOfClass:class];
      }];
  return target != nil;
}

+ (NYNavigator *)navigator {
  return gNavigator;
}

- (void)setMainNavigationController:
        (UINavigationController *)mainViewContorller {
  _mainNavigationContorller = mainViewContorller;
}

- (void)setHandleableURLScheme:(NSString *)scheme {
  _handleableURLScheme = scheme;
}

- (void)setFileNamesOfURLMapping:(NSArray *)fileNames {
  _fileNamesOfURLMapping = fileNames;

  [self loadPattern];
}

- (UIViewController *)openURL:(NSURL *)url
           fromViewController:(UIViewController *)controller {
  if (!url) {
    return nil;
  }
  return [self openURLAction:[NYURLAction actionWithURL:url]
          fromViewController:controller];
}

- (UIViewController *)openURLString:(NSString *)urlString
                 fromViewController:(UIViewController *)controller {
  if (urlString.length < 1) {
    return nil;
  }
  return [self openURLAction:[NYURLAction
                                 actionWithURL:[NSURL URLWithString:urlString]]
          fromViewController:controller];
}

- (UIViewController *)openURLAction:(NYURLAction *)urlAction
                 fromViewController:(UIViewController *)controller {
  if (![urlAction isKindOfClass:[NYURLAction class]]) {
    NYLog(@"*****************[open url action error] urlAction(%@) is not a "
          @"kind of NYURLAction",
          NSStringFromClass([urlAction class]));
    return nil;
  }
  return [self openURLAction:urlAction];
}

- (UIViewController *)openURLAction:(NYURLAction *)urlAction {
  //合法性检查
  if (!urlAction || !urlAction.url || !_mainNavigationContorller) {
    return nil;
  }
  if ([self inBlockMode]) {
    // in block mode, url action will send to waiting list
    [_urlActionWaitingList addObject:urlAction];
    if (!_checkBlockTimer) {
      _checkBlockTimer = [NSTimer
          scheduledTimerWithTimeInterval:0.4
                                  target:self
                                selector:@selector(checkTimerBlockModeDismiss)
                                userInfo:nil
                                 repeats:YES];
    }
    return nil;
  }
  NSURL *url = urlAction.url;
  NSString *scheme = url.scheme;
  //检查是否为可处理的scheme
  if (![self.handleableURLScheme caseInsensitiveCompare:scheme] ==
      NSOrderedSame) {
    [[UIApplication sharedApplication] openURL:url];
    return nil;
  }

  //找到URLAction对应的Pattern
  NYURLPattern *pattern = [self matchPatternWithURLAction:urlAction];
  if (!pattern) {
    [self onMatchUnhandledURLAction:urlAction];
    return nil;
  }
  //获得即将跳转的UIViewController
  UIViewController *controller = [self obtainControllerWithPattern:pattern];
  if (!controller) {
    [self onMatchUnhandledURLAction:urlAction];
    return nil;
  }

  [self onMatchViewController:controller withURLAction:urlAction];
  if (![controller isKindOfClass:[UIViewController class]]) {
    return nil;
  }

  [self pushViewController:controller withURLAction:urlAction];
  return controller;
}

- (void)pushViewController:(UIViewController *)controller
             withURLAction:(NYURLAction *)urlAction {
  //检查所跳转的VCs是否有handleWithURLAction方法
  if ([controller respondsToSelector:@selector(handleWithURLAction:)]) {
    if (![((id<NYNavigatorViewControllerProtocal>)controller)
            handleWithURLAction:urlAction]) {
      return;
    }
  }
  // 如果是处理堵塞的页面，一次性压入所有页面，只有最后一个页面使用动画
  NYNaviAnimation animation = NYNaviAnimationNone;
  if (_urlActionWaitingList.count > 0) {
    animation = NYNaviAnimationNone;
  } else {
    animation = urlAction.animation;
  }

  [self.mainNavigationContorller
      pushViewController:controller
                animated:(animation != NYNaviAnimationNone)];
}

- (UIViewController *)obtainControllerWithPattern:(NYURLPattern *)pattern {
  if (pattern.targetClass == nil)
    return nil;
  Class class = pattern.targetClass;
  return [class new];
}

- (NYURLPattern *)matchPatternWithURLAction:(NYURLAction *)urlAction {
  if (urlAction.url.host.length < 1) {
    return nil;
  }
  return [_urlMapping objectForKey:[urlAction.url.host lowercaseString]];
}

- (void)onMatchUnhandledURLAction:(NYURLAction *)urlAction {
  if ([self.delegate
          respondsToSelector:@selector(navigator:onMatchUnhandledURLAction:)]) {
    [self.delegate navigator:self onMatchUnhandledURLAction:urlAction];
  }
}

- (void)onMatchViewController:(UIViewController *)controller
                withURLAction:(NYURLAction *)urlAction {
  if ([self.delegate respondsToSelector:@selector(navigator:
                                            onMatchViewController:
                                                    withURLAction:)]) {
    [self.delegate navigator:self
        onMatchViewController:controller
                withURLAction:urlAction];
    }
}

@end
