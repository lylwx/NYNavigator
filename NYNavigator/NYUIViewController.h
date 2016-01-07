//
//  NYUIViewController.h
//  NYTrain
//
//  Created by William on 16/1/6.
//  Copyright © 2016年 William. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NYURLAction.h"
#import "NYNavigationViewControllerProtocal.h"
@interface NYUIViewController
    : UIViewController <NYNavigatorViewControllerProtocal>
@property(nonatomic, strong) NYURLAction *urlAction;
@end
