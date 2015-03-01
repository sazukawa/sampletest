//
//  NTViewController.h
//  NSURLSessionTest
//
//

#import <UIKit/UIKit.h>

@interface NTViewController : UIViewController
{
    
    UIButton *connectTestButton;
}
@property (nonatomic,retain) IBOutlet UIButton *connectTestButton;

-(IBAction)connectTestButton:(id)sender;
-(IBAction)sessionTestButton:(id)sender;

@end
