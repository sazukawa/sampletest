//
//  TimeLog.h
//
//
//  Created by sazu on 2013/11/15.
//  Copyright (c) 2013年 CATest. All rights reserved.
//
//*** TimeLog 複数同時計測する場合はこちらを使用 ***//

#ifdef DEBUG

#import <Foundation/Foundation.h>
#import <sys/time.h>


@interface TimeLog : NSObject
{
    NSString *_preFix;
}

@property (nonatomic) struct timeval first;
@property (nonatomic) struct timeval previous;

- (id)initWithPreFix:(NSString *)preFix;
-(void)reset:(NSString *)preFix;
-(void)log:(NSString *)message;
-(void)finish;

@end

#endif