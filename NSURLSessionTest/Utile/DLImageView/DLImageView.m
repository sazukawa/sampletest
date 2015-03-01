//
//  DLImageView.m
//  ImageViewTest
//
//  Created by sazu on 11/03/13.
//

#import "DLImageView.h"

#import "TimeLog.h"

TimeLog *_timelog = nil;

@implementation DLImageView

-(void)dlImage:(NSString*)imageURL beforeImage:(UIImage*)bImage indicatorEnable:(BOOL)flag
{
	//初期画像を登録
	self.image = bImage;
	
	//URLがnilの場合は非同期通信しない
	if(imageURL == nil)
	{
		return;	
	}
	
	//リクエストの生成
	NSURL *url = [NSURL URLWithString:imageURL];
	//NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                         timeoutInterval:30.0f];
    
	dlConnect = [
				  [NSURLConnection alloc]
				  initWithRequest : request
				  delegate : self
				  ];
    
    _timelog = [[TimeLog alloc] initWithPreFix:@"test"];
	
	//インジゲータの表示
	if(flag)
	{
		if(activityIndicator)
		{
			[activityIndicator stopAnimating];
			[activityIndicator removeFromSuperview];
			[activityIndicator release];
		}
		
		//インジケーターの表示
		activityIndicator = [ [UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		activityIndicator.frame = self.bounds;//CGRectMake(0, 0, 20, 20);
		//activityIndicator.center = self.center;
		[self addSubview:activityIndicator];
		[activityIndicator startAnimating];
	}
	//エラー時の対処は未実装
	//if (connection==nil) {};
}

// 非同期通信 ヘッダーが返ってきた
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	// データを初期化
	async_data = [[NSMutableData alloc] initWithData:0];
	//	// プログレスバー更新
	//	totalbytes = [response expectedContentLength];
	//	loadedbytes = 0.0;
	//	[progress setProgress:loadedbytes];
    [_timelog log:@"didReceiveResponse"];
}

// 非同期通信 ダウンロード中
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	// データを追加する
	[async_data appendData:data];
	//	// プログレスバー更新
	//	loadedbytes += [data length];
	//	[progress setProgress:(loadedbytes/totalbytes)];
    NSLog(@"didReceiveData %d", [data length]);
    [_timelog log:@"didReceiveData"];
}

// 非同期通信 エラー
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSString *error_str = [error localizedDescription];
	NSLog(@"RequestError:%@", error_str);
	
	if(activityIndicator)
	{
		[activityIndicator stopAnimating];
		[activityIndicator removeFromSuperview];
		[activityIndicator release];
	}
	
	// memory
	if(dlConnect)[dlConnect release];
	if(async_data)[async_data release];
}

// 非同期通信 ダウンロード完了
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [_timelog log:@"connectionDidFinishLoading"];
	
	//画像を更新
	UIImage *dlImage = [UIImage imageWithData:async_data];
	self.image = dlImage;
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, dlImage.size.width/2, dlImage.size.height/2);
	
	//	// プログレスバー更新
	//	[progress setProgress:1.0];
	
	if(activityIndicator)
	{
		[activityIndicator stopAnimating];
		[activityIndicator removeFromSuperview];
		[activityIndicator release];
        activityIndicator = nil;
	}
	
	// memory
	if(dlConnect)[dlConnect release];
    
    dlConnect = nil;
	if(async_data)[async_data release];
    async_data = nil;
    
    
    [_timelog finish];
}

-(void)dealloc
{
	[super dealloc];
	
//	if(activityIndicator)
//	{
//		[activityIndicator stopAnimating];
//		[activityIndicator removeFromSuperview];
//		[activityIndicator release];
//	}
	
	// memory
	if(dlConnect)[dlConnect release];
	if(async_data)[async_data release];
	
}

@end
