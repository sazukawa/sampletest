//
//  NTDLConnectionViewController.m
//  NSURLSessionTest
//
//

#import "NTDLConnectionViewController.h"

@interface NTDLConnectionViewController ()

@end

@implementation NTDLConnectionViewController

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
    
    NSLog(@"NTDLConnectionViewController viewDidLoad");
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    dlUrlListArray = [NSMutableArray arrayWithObjects:
					  @"https://pbs.twimg.com/media/Byxcq61CIAA6Sri.png",
					  @"https://pbs.twimg.com/media/ByxhqHyCQAIyzKc.png",
					  @"https://pbs.twimg.com/media/By1WTN1CEAAzn4-.jpg",
					  @"https://pbs.twimg.com/media/By3JizNCUAA6sIu.jpg",
					  @"https://pbs.twimg.com/media/BzARzraCUAAQVBf.jpg",
					  @"https://pbs.twimg.com/media/BzAT1LHCQAAprXJ.jpg",
					  @"https://pbs.twimg.com/media/BzAUngjCMAAARHj.jpg",
					  @"https://pbs.twimg.com/media/BzAyhFxCYAAzM0l.jpg",
					  @"https://pbs.twimg.com/media/BzAzVBRCEAEN_pW.jpg",
					  @"https://pbs.twimg.com/media/BzPqtonCEAAE6hg.jpg",
                   nil];
    


    dlCompImageArray = [NSMutableArray array];
    
    for(int i=0; i<10; i++){
        DLImageView *imageView = [[DLImageView alloc] init];
        imageView.center = CGPointMake(10 + i*20, 100 + i*20);
        [imageView dlImage:[dlUrlListArray objectAtIndex:i] beforeImage:nil indicatorEnable:YES];
        
        [self.view addSubview:imageView];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)backButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
