//
//  ViewController.h
//  QuranUniversalApp
//
//  Created by Faizan on 6/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "contentViewController.h"
#import "singletonManager.h"
#import "SurahTableViewController.h"
#import "ParaTableViewController.h"

@interface pageAppViewController : UIViewController <UIPageViewControllerDataSource,UIGestureRecognizerDelegate>
{
    UIPageViewController *pageController;
    NSArray *pageContent;
}
@property (strong, nonatomic) IBOutlet UINavigationBar *topBar;
@property (strong, nonatomic) IBOutlet UINavigationBar *bottomBar;
@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) NSArray *pageContent;

@property (weak, nonatomic) IBOutlet UIButton *btnSurah;
@property (weak, nonatomic) IBOutlet UIButton *btnChapter;

@end
