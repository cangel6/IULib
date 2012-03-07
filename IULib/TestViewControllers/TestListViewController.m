//
//  TestListViewController.m
//  IULib
//
//  Created by wimo wimo on 12. 3. 6..
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TestListViewController.h"
#import "TestIURangeSliderControl.h"

NSString * const    kDataFileName       = @"TestData";
NSString * const    kDataFileType       = @"dat";
NSString * const    kSeperateSection    = @"====";
NSString * const    kSeperateTitle      = @"----";
NSString * const    kSeperateItem       = @"\n";

@interface TestListViewController (PrivateMethods)

- (void)initializeView;

@end

@implementation TestListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"TestList";
        [self initializeView];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)dealloc{
    [_pSectionArray removeAllObjects];
    [_pSectionArray release];
    _pSectionArray  = nil;
    
    [_pItemDic      removeAllObjects];
    [_pItemDic      release];
    _pItemDic       = nil;
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)initializeView{
    _pSectionArray  = [[NSMutableArray alloc]init];
    _pItemDic       = [[NSMutableDictionary alloc]init];
    
    NSString *pPath         = [[NSBundle mainBundle]pathForResource:kDataFileName ofType:kDataFileType];
    NSString *pFileString   = [[NSString stringWithContentsOfFile:pPath encoding:NSUTF8StringEncoding error:nil]
                               stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSArray *pSectionArray  = [pFileString componentsSeparatedByString:kSeperateSection];
    
    for (NSString *pSectionString in pSectionArray) {
        NSArray *pTitleItemArray = [pSectionString componentsSeparatedByString:kSeperateTitle];
        
        if ([pTitleItemArray count] >= 2) {
            NSString *sectionKey = [[pTitleItemArray objectAtIndex:0] 
                                    stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *itemString = [[pTitleItemArray objectAtIndex:1] 
                                    stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            [_pItemDic      setObject:[itemString componentsSeparatedByString:kSeperateItem] forKey:sectionKey];
            [_pSectionArray addObject:sectionKey];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [_pSectionArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString    *pSectionKey    = [_pSectionArray objectAtIndex:section];
    NSArray     *pItemArray     = [_pItemDic objectForKey:pSectionKey];
    return [pItemArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString    *pSectionKey    = [_pSectionArray objectAtIndex:indexPath.section];
    NSArray     *pItemArray     = [_pItemDic objectForKey:pSectionKey];
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    [cell.textLabel setText:[pItemArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_pSectionArray objectAtIndex:section];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString    *pSectionKey    = [_pSectionArray objectAtIndex:indexPath.section];
    NSArray     *pItemArray     = [_pItemDic objectForKey:pSectionKey];
    NSString    *pClassName     = [NSString stringWithFormat:@"Test%@", [pItemArray objectAtIndex:indexPath.row]];
    
    NSLog(@"%@", pClassName);
    
    UIViewController    *testView = [[NSClassFromString(pClassName) alloc]init];
    if (testView) {
        [self.navigationController pushViewController:testView animated:YES];
        [testView release];
    }
    testView = nil;
}

@end
