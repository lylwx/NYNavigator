//
//  NYPattern.m
//  NYTrain
//
//  Created by William on 16/1/5.
//  Copyright © 2016年 William. All rights reserved.
//

#import "NYURLPattern.h"
static Class defaultWebViewControllerClass = NULL;

@implementation NYURLPattern

+ (void)setDefaultWebViewControllerClass:(Class)webControllerClass {
  defaultWebViewControllerClass = webControllerClass;
}

+ (NYURLPattern *)patternWithClassName:(NSString *)className
                               withKey:(NSString *)key {
  return [[self alloc] initWithString:className
                                 type:NYURLPatternTypeClass
                              withKey:key];
}

+ (NYURLPattern *)patternWithHttp:(NSString *)url withKey:(NSString *)key {
  return
      [[self alloc] initWithString:url type:NYURLPatternTypeHttp withKey:key];
}

- (id)initWithString:(NSString *)string
                type:(NYURLPatternType)type
             withKey:(NSString *)key {
  self = [super init];
  if (self) {
    if (string.length < 1 || key.length < 1) {
      return nil;
    }
    _type = type;
    _key = key;
    _patternString = string;
  }
  return self;
}

- (Class)targetClass {
  if (_type == NYURLPatternTypeHttp) {
    if (defaultWebViewControllerClass == NULL) {
      NSLog(@"default WebViewController Class is not assigned, please call "
            @"[NVURLPattern setDefaultWebViewControllerClass:] method "
            @"first!!");
      return NULL;
    }
    return defaultWebViewControllerClass;
  }

  if (_patternString.length < 1) {
    return NULL;
  }
  if (_type == NYURLPatternTypeClass) {
    return NSClassFromString(_patternString);
  } else {
    return NULL;
  }
}

@end
