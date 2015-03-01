//
//  TimeLogManager.m
//
//
//  Created by sazu on 2013/11/15.
//  Copyright (c) 2013年 CATest. All rights reserved.
//
//*** TimeLogのシングルトン版 オブジェクト間超えて計測する場合はこちら ***//

#ifdef DEBUG


#import "TimeLogManager.h"

@interface TimeLogManager()
@end

static TimeLogManager* _sharedManager = nil;

@implementation TimeLogManager

@synthesize first;
@synthesize previous;


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


#pragma mark -
#pragma mark Singleton base

- (id)init
{
    self = [super init];
    if (self) {
        // 初期処理
        _preFix = @"";
        gettimeofday(&first, NULL);
        gettimeofday(&previous, NULL);
        NSLog(@"%@:start or reset" , _preFix);
    }
    return self;
}

+ (TimeLogManager*)sharedManager{
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[TimeLogManager alloc] init];
    });
    return _sharedManager;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (_sharedManager == nil) {
            _sharedManager = [super allocWithZone:zone];
            return _sharedManager;  // 最初の割り当てで代入し、返す
        }
    }
    return nil; // 以降の割り当てではnilを返すようにする
}

- (id)copyWithZone:(NSZone *)zone{
    return self;
}

+ (void)deleteManager
{
	if(_sharedManager) {
		@synchronized(self) {
			_sharedManager = nil;
		}
	}
}


@end



#endif
