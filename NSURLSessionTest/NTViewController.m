//
//  NTViewController.m
//  NSURLSessionTest
//
//

#import "NTViewController.h"
#import "NTDLConnectionViewController.h"
#import "NTDLSessionViewController.h"

@interface NTViewController ()

@end

@implementation NTViewController

@synthesize connectTestButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)connectTestButton:(id)sender
{
    NSLog(@"connectTestButton");
    UIViewController *controlelr = [[NTDLConnectionViewController alloc] initWithNibName:@"NTDLConnectionViewController" bundle:nil];
    [self presentModalViewController:controlelr animated:YES];
}

-(IBAction)sessionTestButton:(id)sender
{
    NSLog(@"sessionTestButton");
    UIViewController *controlelr = [[NTDLSessionViewController alloc] initWithNibName:@"NTDLSessionViewController" bundle:nil];
    [self presentModalViewController:controlelr animated:YES];
    
}

@end
