//
//  NSURL+Ext.m
//  NYTrain
//
//  Created by William on 16/1/5.
//  Copyright © 2016年 William. All rights reserved.
//

#import "NSURL+Ext.h"

@implementation NSURL (Ext)

- (NSDictionary *)parseQuery {
  NSString *query = [self query];
  NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:6];
  NSArray *pairs = [query componentsSeparatedByString:@"&"];

  for (NSString *pair in pairs) {
    NSArray *elements = [pair componentsSeparatedByString:@"="];
    if ([elements count] <= 1) {
      continue;
    }
    NSString *key = [[elements objectAtIndex:0]
        stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    CFStringRef originValue =
        CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
            NULL, (CFStringRef)([elements objectAtIndex:1]), CFSTR(""),
            kCFStringEncodingUTF8);
    [dict setObject:(__bridge NSString *)originValue forKey:key];
    CFRelease(originValue);
  }
  return dict;
}
@end
