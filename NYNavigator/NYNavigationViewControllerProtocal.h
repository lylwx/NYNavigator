//
//  NYNavigationViewControllerProtocal.h
//  NYTrain
//
//  Created by William on 16/1/6.
//  Copyright © 2016年 William. All rights reserved.
//
#import "NYURLAction.h"

@protocol NYNavigatorViewControllerProtocal <NSObject>

@optional

- (BOOL)handleWithURLAction:(NYURLAction *)urlAction;
@end
