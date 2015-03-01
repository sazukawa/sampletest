//
//  BDImageView.m
//  ImageViewTest
//
//  Created by sazu on 11/03/13.
//

#import "BDImageView.h"

#import "TimeLogManager.h"

@interface BDImageView()
-(void)DLConmplete:(NSData*) data;
@end

static int dlId = 0;

@implementation BDImageView

//-(id)init
//{
//    
//    return [super init];
//}
//
//- (void)downloadTaskWithCustomDelegate
//{
//
//}



                                                   
-(void)dlImage:(NSString*)imageURL beforeImage:(UIImage*)bImage indicatorEnable:(BOOL)flag
{
	//初期画像を登録
	self.image = bImage;
    fileName = imageURL;
    [fileName retain];
    
    NSLog(@"set! fileName %@", fileName);
	
	//URLがnilの場合は非同期通信しない
	if(imageURL == nil)
	{
		return;	
	}
	
	//リクエストの生成
	NSURL *url = [NSURL URLWithString:imageURL];

    dlId++;
    NSString *idStr = [NSString stringWithFormat:@"%d", dlId];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration backgroundSessionConfiguration:idStr];
    NSLog(@"[identifier] %@", sessionConfiguration.identifier);
    NSLog(@"[networkServiceType] %d", sessionConfiguration.networkServiceType);
    NSLog(@"[discretionary] %hhd", sessionConfiguration.discretionary);
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    
    NSURLSessionDownloadTask *sessionDownloadTask = [session downloadTaskWithURL:url];
    [sessionDownloadTask resume];
    
	[[TimeLogManager sharedManager] resetWithKey:fileName];
    
	
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

// ---------------------------------------------------------------------
//  NSURLSessionTaskDelegate
// ---------------------------------------------------------------------

// URLSession:task:didCompleteWithError:
// Tells the delegate that the task finished transferring data.
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"URLSession 1");
    if(error){
        NSLog(@"%@", [error localizedDescription]);
        // HTTP 404 の場合 : The requested URL was not found on this server.
        // 名前解決できない場合 : A server with the specified hostname could not be found.
        
        NSLog(@"%@", [error localizedFailureReason]);
        NSLog(@"%@", [error localizedRecoverySuggestion]);
    }else{
        NSLog(@"done! fileName %@", fileName);
		[[TimeLogManager sharedManager] finishWithKey:fileName];
    }
}

// URLSession:task:didReceiveChallenge:completionHandler:
// Requests credentials from the delegate in response to an authentication request from the remote server.
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
    NSLog(@"URLSession 2");
}

// URLSession:task:didSendBodyData:totalBytesSent:totalBytesExpectedToSend:
// Periodically informs the delegate of the progress of sending body content to the server.
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    NSLog(@"URLSession 3");
}

// URLSession:task:needNewBodyStream:
// Tells the delegate when a task requires a new request body stream to send to the remote server.
// Note: You do not need to implement this if your code provides the request body using a file URL or an NSData object.
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task needNewBodyStream:(void (^)(NSInputStream *bodyStream))completionHandler
{
    NSLog(@"URLSession 4");
}

// URLSession:task:willPerformHTTPRedirection:newRequest:completionHandler:
// Tells the delegate that the remote server requested an HTTP redirect.
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest *))completionHandler
{
    NSLog(@"URLSession 5");
}


// ---------------------------------------------------------------------
//  NSURLSessionDownloadDelegate
// ---------------------------------------------------------------------
/*
 The NSURLSessionDownloadDelegate protocol defines the methods that a delegate of an NSURLSession object should implement to handle task-level events specific to download tasks. The delegate should also implement the methods in the NSURLSessionTaskDelegate protocol to handle task-level events that are common to all task types.
 */

// URLSession:downloadTask:didResumeAtOffset:expectedTotalBytes:
// Tells the delegate that the download task has resumed downloading. (required)
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    NSLog(@"expectedTotalBytes");
}

// URLSession:downloadTask:didWriteData:totalBytesWritten:totalBytesExpectedToWrite:
// Periodically informs the delegate about the download’s progress. (required)
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    NSLog(@"[bytesWritten] %lld, [totalBytesWritten] %lld, [totalBytesExpectedToWrite] %lld", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    double progress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
    NSLog(@"[progress] %f", progress);
	[[TimeLogManager sharedManager] logWithKey:@"didWriteData" keyStr:fileName];
}

// URLSession:downloadTask:didFinishDownloadingToURL:
// Tells the delegate that a download task has finished downloading. (required)
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    if([location isFileURL]){
        NSLog(@"[location absoluteString] %@", [location absoluteString]);
        NSNumber *fileSizeBytes;
        [location getResourceValue:&fileSizeBytes forKey:NSURLFileSizeKey error:nil];
        NSLog(@"[fileSizeBytes] %@", fileSizeBytes);
        // 実際にダウンロードされたファイルのパスは下記のような感じ．
        // file:///private/var/mobile/Applications/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/tmp/CFNetworkDownload_xxxxxx.tmp
        
        
        //NSLog(@"★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★fileName %@", fileName);
        
        //このタイミングでデータ取らないとファイルは消える？
        
        //NSLog(@"filePath %@", filePath);
        NSURL *url = [NSURL URLWithString:[location absoluteString]];
        //NSLog(@"url %@", url);
        NSData *data = [NSData dataWithContentsOfURL:url];
        //NSLog(@"data %d", [data length]);
        
        //バックグラウンドで動いているので画像系はメインスレッドで処理する
        [self performSelectorOnMainThread:@selector(DLConmplete:) withObject:data waitUntilDone:NO];
		[[TimeLogManager sharedManager] logWithKey:@"didFinishDownloadingToURL" keyStr:fileName];
		
        
    }
}


- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    NSLog(@"URLSessionDidFinishEventsForBackgroundURLSession");
}


-(void)DLConmplete:(NSData*)data
{
	[[TimeLogManager sharedManager] logWithKey:@"DLConmplete start" keyStr:fileName];
	
    UIImage *dlImage = [[UIImage imageWithData:data] retain];
    NSLog(@"dlImage %@", dlImage);
    self.image = dlImage;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, dlImage.size.width/2, dlImage.size.height/2);

    //	// プログレスバー更新
    //	[progress setProgress:1.0];
    
    if(activityIndicator)
    {
        NSLog(@"activityIndicator remove");
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
	
	[[TimeLogManager sharedManager] logWithKey:@"DLConmplete end" keyStr:fileName];
}

-(void)dealloc
{
	[super dealloc];
	
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

@end
