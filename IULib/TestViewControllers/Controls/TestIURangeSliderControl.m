//
//  TestIURangeController.m
//  IULib
//
//  Created by wimo wimo on 12. 3. 6..
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TestIURangeSliderControl.h"

@implementation TestIURangeSliderControl

@synthesize minValueLabel;
@synthesize maxValueLabel;
@synthesize testIURangeSlider;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"IURangeSliderControl";
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
    [self.minValueLabel setText:[NSString stringWithFormat:@"선택된 최소값 : %f", self.testIURangeSlider.selectedMinimumValue]];
    [self.maxValueLabel setText:[NSString stringWithFormat:@"선택된 최대값 : %f", self.testIURangeSlider.selectedMaximumValue]];
    [self.testIURangeSlider addTarget:self action:@selector(sliderValueChange) forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.minValueLabel = nil;
    self.maxValueLabel = nil;
    self.testIURangeSlider = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)sliderValueChange
{
    [self.minValueLabel setText:[NSString stringWithFormat:@"선택된 최소값 : %f", self.testIURangeSlider.selectedMinimumValue]];
    [self.maxValueLabel setText:[NSString stringWithFormat:@"선택된 최대값 : %f", self.testIURangeSlider.selectedMaximumValue]];
}

@end
