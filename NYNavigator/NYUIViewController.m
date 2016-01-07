//
//  NYUIViewController.m
//  NYTrain
//
//  Created by William on 16/1/6.
//  Copyright © 2016年 William. All rights reserved.
//

#import "NYUIViewController.h"

@implementation NYUIViewController
@synthesize urlAction = _urlAction;

- (BOOL)handleWithURLAction:(NYURLAction *)urlAction {
  self.urlAction = urlAction;
  return YES;
}

@end
