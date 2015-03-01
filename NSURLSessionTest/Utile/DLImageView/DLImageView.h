//
//  DLImageView.h
//  ImageViewTest
//
//  Created by sazu on 11/03/13.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIImageView.h>

@interface DLImageView : UIImageView {
	//非同期DL
	NSURLConnection *dlConnect;
	NSMutableData *async_data;
	
	//BOOL indicatorFlag;
	UIActivityIndicatorView *activityIndicator;
}
-(void)dlImage:(NSString*)imageURL beforeImage:(UIImage*)bImage indicatorEnable:(BOOL)flag;
@end
