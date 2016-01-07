//
//  NSArray+Functional.h
//  NYTrain
//
//  Created by William on 16/1/5.
//  Copyright © 2016年 William. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef BOOL (^NYValidationBlock)(id obj);
@interface NSArray (Functional)

/**
 *  find the object match condition in array
 *
 *  @param block condition
 *
 *  @return matched object or nil
 */
- (id)NY_find:(NYValidationBlock)block;
- (id)NY_match:(NYValidationBlock)block;
@end
