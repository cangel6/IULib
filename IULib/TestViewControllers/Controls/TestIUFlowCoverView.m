//
//  TestIUFlowCoverView.m
//  IULib
//
//  Created by wimo wimo on 12. 3. 8..
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TestIUFlowCoverView.h"

@implementation TestIUFlowCoverView

@synthesize iuFlowCoverView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"TestIUFlowCoverView";
        
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
    self.iuFlowCoverView.dataSource = self;
    self.iuFlowCoverView.delegate = self;
    self.iuFlowCoverView.imageMode = IUFlowCoverViewImageModeCenterCrop;
    //[self.iuFlowCoverView draw];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.iuFlowCoverView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (IBAction)loopSwitch:(id)sender{
    UISwitch * item = sender;
    iuFlowCoverView.enableLoop = item.on;
    NSLog(@"loop");
}

- (IBAction)shadowSwitch:(id)sender{
    UISwitch * item = sender;
    iuFlowCoverView.enableShadow = item.on;
    NSLog(@"shadow");
}

#pragma mark - IUFlowCoverViewDataSource

- (int)imageCountOfIUFlowCoverView:(IUFlowCoverView *)view{
    return 10;
}

- (UIImage *)getImageForIUFlowCoverView:(IUFlowCoverView *)view index:(NSInteger)index{
    NSString *fileName = [NSString stringWithFormat:@"IUCoverFlowView%02d.jpg", index+1];
    return [UIImage imageNamed:fileName];
}

#pragma mark - IUFlowCoverViewDelegate

- (void)didSelectedIUFlowCoverView:(IUFlowCoverView *)view atIndex:(NSInteger)index{
    NSLog(@"selected index : %d", index);
}

@end
