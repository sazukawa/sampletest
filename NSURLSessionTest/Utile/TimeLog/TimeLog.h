//
//  TimeLog.h
//
//
//  Created by sazu on 2013/11/15.
//

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