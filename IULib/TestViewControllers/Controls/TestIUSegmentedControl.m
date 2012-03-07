//
//  TestIUSegmentedControl.m
//  IULib
//
//  Created by wimo wimo on 12. 3. 7..
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TestIUSegmentedControl.h"

@implementation TestIUSegmentedControl

@synthesize segCon1;
@synthesize segCon2;
@synthesize segCon3;
@synthesize segCon4;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"IUSegmentedControl";
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
    // Do any additional setup after loading the view from its nib.
    self.segCon1.offFont = [UIFont systemFontOfSize:12.0f];
    self.segCon1.onFont = [UIFont boldSystemFontOfSize:12.0f];
    self.segCon1.onTintColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
    self.segCon1.offTintColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
    self.segCon1.onTextColor = [UIColor whiteColor];
    self.segCon1.offTextColor = [UIColor blueColor];
    
    self.segCon2.offFont = [UIFont systemFontOfSize:12.0f];
    self.segCon2.onFont = [UIFont boldSystemFontOfSize:12.0f];
    self.segCon2.onTintColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
    self.segCon2.offTintColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
    self.segCon2.onTextColor = [UIColor whiteColor];
    self.segCon2.offTextColor = [UIColor blueColor];
    
    self.segCon3.offFont = [UIFont systemFontOfSize:12.0f];
    self.segCon3.onFont = [UIFont boldSystemFontOfSize:12.0f];
    self.segCon3.onTintColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
    self.segCon3.offTintColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
    self.segCon3.onTextColor = [UIColor whiteColor];
    self.segCon3.offTextColor = [UIColor blueColor];
    
    self.segCon4.offFont = [UIFont systemFontOfSize:12.0f];
    self.segCon4.onFont = [UIFont boldSystemFontOfSize:12.0f];
    self.segCon4.onTintColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
    self.segCon4.offTintColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
    self.segCon4.onTextColor = [UIColor whiteColor];
    self.segCon4.offTextColor = [UIColor blueColor];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
