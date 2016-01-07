//
//  SecondUIViewController.m
//  NYNavigatorDemo
//
//  Created by William on 16/1/7.
//  Copyright © 2016年 William. All rights reserved.
//

#import "SecondUIViewController.h"
@interface SecondUIViewController ()
@property(nonatomic, strong) UITextView *textView;
@property(nonatomic, copy) NSString *test;
@end

@implementation SecondUIViewController
- (BOOL)handleWithURLAction:(NYURLAction *)urlAction {
  _test = [urlAction stringForKey:@"message"];
  return YES;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  _textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 100, 300, 200)];
  [_textView setTextColor:[UIColor blackColor]];
  [_textView setText:_test];
  [self.view setBackgroundColor:[UIColor lightGrayColor]];
  [self.view addSubview:_textView];
}

@end
