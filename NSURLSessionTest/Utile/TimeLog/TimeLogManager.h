//
//  TimeLogManager.h
//
//
//  Created by sazu on 2013/11/15.
//
//*** TimeLogのシングルトン版 ***//

#ifdef DEBUG

#import <Foundation/Foundation.h>
#import <sys/time.h>
#import "TimeLog.h"


@interface TimeLogManager : NSObject
{
    //基本機能
    NSString *_preFix;
    
    //key管理(TimeLogオブジェクトをkey毎に管理)
    NSMutableDictionary *_timeLogDict;
}

@property (nonatomic) struct timeval first;
@property (nonatomic) struct timeval previous;

+ (id)sharedManager;
+ (void)deleteManager;

//基本機能(Dictionary使用しない。単体の計測はこちらを使用した方が良い)
-(void)reset:(NSString *)preFix;
-(void)log:(NSString *)message;
-(void)finish;

//key毎に測定(Dictionaryのメソッド実行コスト考えると微妙かも)
-(void)resetWithKey:(NSString *)key;
-(void)logWithKey:(NSString *)message keyStr:(NSString *)key;
-(void)finishWithKey:(NSString *)key;


/*** サンプルコード
	//測定開始(リセット)
	[[TimeLogManager sharedManager] resetWithKey:keyName];
	
	//途中測定
	[[TimeLogManager sharedManager] logWithKey:@"ログメッセージをいれてください" keyStr:fileName];
	
	//測定終了
	[TimeLogManager sharedManager] finishWithKey:keyName];
	
 

***/

@end

#endif