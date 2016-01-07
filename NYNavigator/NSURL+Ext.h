//
//  NSURL+Ext.h
//  NYTrain
//
//  Created by William on 16/1/5.
//  Copyright © 2016年 William. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Ext)

/**
 将query解析为NSDictionary

 @return 返回参数字典对象，参数的值已经进行了decode.
 (stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding)
 */
- (NSDictionary *)parseQuery;
@end
