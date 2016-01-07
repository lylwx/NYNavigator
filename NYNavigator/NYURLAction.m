//
//  NYURLAction.m
//  NYTrain
//
//  Created by William on 16/1/5.
//  Copyright © 2016年 William. All rights reserved.
//

#import "NYURLAction.h"
#import "NSURL+Ext.h"
#import "NYNavigator.h"

@interface NYURLAction ()

@property(strong, nonatomic) NSMutableDictionary *params; // setParams:forKey:

@end

@implementation NYURLAction

+ (id)actionWithURL:(NSURL *)url {
  return [[NYURLAction alloc] initWithURL:url];
}

+ (id)actionWithURLString:(NSString *)urlString {
  return [[self alloc] initWithURLString:urlString];
}

+ (id)actionWithHost:(NSString *)host {
  return [[self alloc] initWithHost:host];
}

- (id)initWithURL:(NSURL *)url {
  if (self = [super init]) {
    _url = url;
    NSDictionary *dic = [url parseQuery];
    _params = [NSMutableDictionary dictionary];
    for (NSString *key in [dic allKeys]) {
      id value = [dic objectForKey:key];
      [_params setObject:value forKey:[key lowercaseString]];
    }
  }
  return self;
}

- (id)initWithURLString:(NSString *)urlString {
  return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (id)initWithHost:(NSString *)host {
  NSString *scheme = [[NYNavigator navigator] handleableURLScheme];
  if (scheme.length < 1) {
    return nil;
  }
  return [self
      initWithURLString:[NSString stringWithFormat:@"%@://%@", scheme, host]];
}

- (void)setInteger:(NSInteger)intValue forKey:(NSString *)key {
  [_params setObject:[NSNumber numberWithInteger:intValue]
              forKey:[key lowercaseString]];
}

- (void)setDouble:(double)doubleValue forKey:(NSString *)key {
  [_params setObject:[NSNumber numberWithDouble:doubleValue]
              forKey:[key lowercaseString]];
}

- (void)setString:(NSString *)string forKey:(NSString *)key {
  if (string.length > 0) {
    [_params setObject:string forKey:[key lowercaseString]];
  }
}

- (void)setObject:(NSObject *)object forKey:(NSString *)key {
  if (object) {
    [_params setObject:object forKey:[key lowercaseString]];
  }
}

- (void)setParamDictionary:(NSDictionary *)dic {
  if (!dic) {
    return;
  }
  [_params addEntriesFromDictionary:dic];
}

- (NSInteger)integerForKey:(NSString *)key {
  NSString *urlStr = [_params objectForKey:[key lowercaseString]];
  if (urlStr) {
    if ([urlStr isKindOfClass:[NSString class]]) {
      return [urlStr integerValue];
    } else if ([urlStr isKindOfClass:[NSNumber class]]) {
      return [(NSNumber *)urlStr integerValue];
    }
  }
  return 0;
}

- (double)doubleForKey:(NSString *)key {
  NSString *urlStr = [_params objectForKey:[key lowercaseString]];
  if (urlStr) {
    if ([urlStr isKindOfClass:[NSString class]]) {
      return [urlStr doubleValue];
    } else if ([urlStr isKindOfClass:[NSNumber class]]) {
      return [(NSNumber *)urlStr doubleValue];
    }
  }
  return .0;
}

- (NSString *)stringForKey:(NSString *)key {
  NSString *urlStr = [_params objectForKey:[key lowercaseString]];
  if (urlStr) {
    if ([urlStr isKindOfClass:[NSString class]]) {
      return urlStr;
    }
  }
  return nil;
}

- (NSDictionary *)queryDictionary {
  return _params;
}

@end
