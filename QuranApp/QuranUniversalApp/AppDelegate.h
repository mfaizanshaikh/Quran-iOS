//
//  AppDelegate.h
//  QuranUniversalApp
//
//  Created by Faizan on 6/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pageAppViewController.h"
#import "singletonManager.h"

@class pageAppViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) pageAppViewController *pageViewCont;

@end
