//
//  pageAppViewController.m
//  Quran1
//
//  Created by Faizan on 5/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "pageAppViewController.h"


@implementation pageAppViewController

@synthesize btnSurah;
@synthesize btnChapter;
@synthesize pageController;
@synthesize pageContent;
@synthesize topBar=_topBar;
@synthesize bottomBar=_bottomBar;

- (void) createContentPages
{
    NSMutableArray *pageStrings = [[NSMutableArray alloc] init];
    for (int i = 1; i < 620; i++)
    {
        NSString *contentString = [[NSString alloc]
                                   initWithFormat:@"<html><head></head><body><img width=\"960px\" src=\"qm%d.png\"</body></html>",i];
        [pageStrings addObject:contentString];
    }
    pageContent = [[NSArray alloc] initWithArray:pageStrings];
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark - View lifecycle


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}


- (NSUInteger)indexOfViewController:(contentViewController *)viewController
{
    return [self.pageContent indexOfObject:viewController.dataObject];
}

- (contentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    // Return the data view controller for the given index.
    if (([self.pageContent count] == 0) || 
        (index >= [self.pageContent count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    
    
    contentViewController *dataViewController;   
    
    // Create a new view controller and pass suitable data.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        dataViewController = [[contentViewController alloc] initWithNibName:
                              @"contentViewController_iPhone" bundle:nil];
    } else {
        dataViewController = [[contentViewController alloc] initWithNibName:
                              @"contentViewController_iPad" bundle:nil];
    }

    
    
    dataViewController.dataObject = 
    [self.pageContent objectAtIndex:index];
    return dataViewController;
}


- (UIViewController *)pageViewController:
(UIPageViewController *)pageViewController viewControllerBeforeViewController:
(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:
                        (contentViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageContent count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];

}

- (UIViewController *)pageViewController:
(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:
                        (contentViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}


- (void)jumpToPage:(NSUInteger)page {    
    contentViewController *rightViewController = [self viewControllerAtIndex:page];
    // [self.pageController setViewControllers:<#(NSArray *)#> direction:<#(UIPageViewControllerNavigationDirection)#> animated:<#(BOOL)#> completion://<#^(BOOL finished)completion#>
    
    
    // choose view controllers according to the orientation
    NSArray *viewControllers;
    
    viewControllers = [NSArray arrayWithObject:rightViewController];
    
    // fire the method which actually trigger the animation
    [self.pageController setViewControllers:viewControllers 
                                  direction:UIPageViewControllerNavigationDirectionForward 
                                   animated:NO 
                                 completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createContentPages];    
    
    singletonManager *mySingletonManager = [singletonManager sharedSingletonManager];
    
    [self.btnSurah addTarget:self action:@selector(selectSurah:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [self.btnChapter addTarget:self action:@selector(selectChapter:) forControlEvents:(UIControlEvents)UIControlEventTouchDown]; 
    
    // filling up the Quran Surah and Parah mapping to the page numbers
    //Surah Mapping
    NSString *surahPath = [[NSBundle mainBundle]pathForResource:@"SurahMapping" ofType:@"plist"];
    mySingletonManager.surahMapping = [[NSMutableArray alloc]initWithContentsOfFile:surahPath];
    
    //Para Mapping
    NSString *paraPath = [[NSBundle mainBundle]pathForResource:@"chapterMapping" ofType:@"plist"];
    mySingletonManager.chapterMapping = [[NSMutableArray alloc]initWithContentsOfFile:paraPath];

    
    //tapgesture to show/hide the top/bottom bar
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handtap:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipe.delegate = self;
    [swipe setDirection:UISwipeGestureRecognizerDirectionRight|UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipe];
    
    NSDictionary *options = 
    [NSDictionary dictionaryWithObject:
     [NSNumber numberWithInteger:UIPageViewControllerSpineLocationMax]
                                forKey: UIPageViewControllerOptionSpineLocationKey];
    
    self.pageController = [[UIPageViewController alloc] 
                           initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                           navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                           options: options];
    
    pageController.dataSource = self;
    [[pageController view] setFrame:[[self view] bounds]];
    
   
    contentViewController *initialViewController =  [self viewControllerAtIndex:mySingletonManager.pageNumToJump];
    
    NSArray *viewControllers =  [NSArray arrayWithObject:initialViewController];
    
    [pageController setViewControllers:viewControllers  
                             direction:UIPageViewControllerNavigationDirectionForward
                              animated:NO 
                            completion:nil];
    
    [self addChildViewController:pageController];
    [[self view] addSubview:[pageController view]];
    
    [pageController didMoveToParentViewController:self];
}

// necessary for the gestures to be recognized
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void) handleSwipe:(id)ignored {
    
    if (self.topBar.alpha==1) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
            
        self.topBar.alpha = 0;
        self.bottomBar.alpha = 0;
        
        [UIView commitAnimations];
    }
}

- (void)handtap:(id)ignored
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    
    if (self.topBar.alpha==1) {
        self.topBar.alpha = 0;
        self.bottomBar.alpha = 0;
    }
    else {
        self.topBar.alpha = 1;
        self.bottomBar.alpha = 1;
        [self.view bringSubviewToFront:self.topBar];
        [self.view bringSubviewToFront:self.bottomBar];
    }
    
    [UIView commitAnimations];
}

-(void) viewWillAppear:(BOOL)animated{

    singletonManager *mySingletonManager = [singletonManager sharedSingletonManager];
    // do not jump if pagenumber is 0
    if(mySingletonManager.pageNumToJump != 0){
        [self jumpToPage:mySingletonManager.pageNumToJump];
        [self handtap:nil]; // to remove the top and bottom bar
    }
}

- (void)selectSurah:(id)sender {

    SurahTableViewController * surahTableViewController = [[SurahTableViewController alloc] initWithNibName:@"SurahTableViewController" bundle:nil];
    surahTableViewController.navigationItem.title=@"Surah";
    
    UINavigationController *aNavigationController = [[UINavigationController alloc] initWithRootViewController:surahTableViewController];
    
    [self presentModalViewController:aNavigationController animated:YES];
    

}

- (void)selectChapter:(id)sender {
    
    ParaTableViewController * paraTableViewController = [[ParaTableViewController alloc] initWithNibName:@"ParaTableViewController" bundle:nil];
    paraTableViewController.navigationItem.title=@"Chapters";
    
    UINavigationController *aNavigationController = [[UINavigationController alloc] initWithRootViewController:paraTableViewController];
    
    [self presentModalViewController:aNavigationController animated:YES];    
}

- (void)viewDidUnload {
    [self setBtnSurah:nil];
    [self setBtnChapter:nil];
    [super viewDidUnload];
}
@end
