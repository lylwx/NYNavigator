//
//  NSArray+Functional.m
//  NYTrain
//
//  Created by William on 16/1/5.
//  Copyright © 2016年 William. All rights reserved.
//

#import "NSArray+Functional.h"

@implementation NSArray (Functional)

- (id)NY_find:(NYValidationBlock)block {
  for (id obj in self) {
    if (block(obj)) {
      return obj;
    }
  }
  return nil;
}

- (id)NY_match:(NYValidationBlock)block {
  for (id object in self) {
    if (block(object)) {
      return object;
    }
  }
  return nil;
}

@end
