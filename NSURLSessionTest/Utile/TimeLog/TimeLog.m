//
//  TimeLog.m
//
//
//  Created by sazu on 2013/11/15.
//


#ifdef DEBUG


#import "TimeLog.h"

@interface TimeLog()
@end


@implementation TimeLog

@synthesize first;
@synthesize previous;

- (id)init
{
    self = [super init];
    if (self) {
        // 初期処理
        if(_preFix==nil)_preFix = @"";
        gettimeofday(&first, NULL);
        gettimeofday(&previous, NULL);
        NSLog(@"%@:start or reset" , _preFix);
    }
    return self;
}

- (id)initWithPreFix:(NSString *)preFix
{
    _preFix = preFix;
    return [super init];
}


-(void)reset:(NSString *)preFix
{
    if(preFix != nil)_preFix = preFix;
    gettimeofday(&first, NULL);
    gettimeofday(&previous, NULL);
    NSLog(@"%@:start or reset" , _preFix);
    
}

-(void)log:(NSString *)message
{
    struct timeval now;
    gettimeofday(&now, NULL);
    
    double start = previous.tv_sec * 1000 + previous.tv_usec * 1e-3;
    double finish = now.tv_sec * 1000 + now.tv_usec * 1e-3;
    NSLog(@"%@:Check Point: %f ms - %@", _preFix, finish - start, message);
    gettimeofday(&previous, NULL);
}

-(void)finish
{
    struct timeval now;
    gettimeofday(&now, NULL);
    
    double start = first.tv_sec * 1000 + first.tv_usec * 1e-3;
    double finish = now.tv_sec * 1000 + now.tv_usec * 1e-3;
    NSLog(@"%@:Final: %f ms - from beggining", _preFix, finish - start);
    gettimeofday(&previous, NULL);
}


@end



#endif
