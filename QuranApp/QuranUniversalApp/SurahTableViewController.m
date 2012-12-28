//
//  SurahTableViewController.m
//  QuranUniversalApp
//
//  Created by Faizan on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SurahTableViewController.h"

@implementation SurahTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(goBack:)];   
    
    self.navigationItem.leftBarButtonItem = btn;

    
}

- (IBAction)goBack:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}
/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    singletonManager *mySingletonManager = [singletonManager sharedSingletonManager];
    // Return the number of rows in the section.
    return [mySingletonManager.surahMapping count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    singletonManager *mySingletonManager = [singletonManager sharedSingletonManager];
    cell.textLabel.text = [[mySingletonManager.surahMapping objectAtIndex:indexPath.row] objectForKey:@"surahName"];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    singletonManager *mySingletonManager = [singletonManager sharedSingletonManager];
    
    mySingletonManager.pageNumToJump =[[[mySingletonManager.surahMapping objectAtIndex:indexPath.row] objectForKey:@"pageNumber"] integerValue];
    
    
    [self dismissModalViewControllerAnimated:YES];
}



- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
