//
//  ViewController.m
//  NYNavigatorDemo
//
//  Created by William on 16/1/7.
//  Copyright © 2016年 William. All rights reserved.
//

#import "ViewController.h"
#import "NYNavigator.h"

@interface ViewController ()
@property(nonatomic, strong) UIButton *goButton;
@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  _goButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 200, 200, 80)];
  [_goButton setBackgroundColor:[UIColor blackColor]];
  [_goButton addTarget:self
                action:@selector(buttonClicked)
      forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:_goButton];
}

- (void)buttonClicked {
  NYNavigator *navigator = [NYNavigator navigator];
  NYURLAction *action =
      [[NYURLAction alloc] initWithURLString:@"nymer://second"];
  [action setString:@"From First UIViewController" forKey:@"message"];
  [navigator openURLAction:action];
}

@end
