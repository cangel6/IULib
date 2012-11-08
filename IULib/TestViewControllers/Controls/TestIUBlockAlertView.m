//
//  TestIUBlockAlertView.m
//  IULib
//
//  Created by young-soo park on 12. 10. 22..
//
//

#import "TestIUBlockAlertView.h"
#import "IUBlockAlertView.h"

@interface TestIUBlockAlertView ()

@end

@implementation TestIUBlockAlertView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    IUBlockAlertView *testAlert = [[IUBlockAlertView alloc]initWithTitle:@"IUBlockAlertView" message:@"test" delegate:nil cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
    [testAlert showWithFinishBlock:^(NSInteger buttonIndex)
     {
         if (buttonIndex == testAlert.cancelButtonIndex) {
             [_resultLabel setText:@"취소"];
         }
         else
         {
             [_resultLabel setText:[NSString stringWithFormat:@"%d", buttonIndex]];
         }
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
