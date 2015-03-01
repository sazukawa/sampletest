//
//  TimeLogManager.h
//
//
//  Created by sazu on 2013/11/15.
//  Copyright (c) 2013年 CATest. All rights reserved.
//
//*** TimeLogのシングルトン版 オブジェクト間超えて計測する場合はこちら ***//

#ifdef DEBUG

#import <Foundation/Foundation.h>
#import <sys/time.h>


@interface TimeLogManager : NSObject
{
    NSString *_preFix;
}

@property (nonatomic) struct timeval first;
@property (nonatomic) struct timeval previous;

+ (id)sharedManager;
+ (void)deleteManager;
-(void)reset:(NSString *)preFix;
-(void)log:(NSString *)message;
-(void)finish;

@end

#endif