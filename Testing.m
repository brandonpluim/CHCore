//
//  Testing.m
//  CHCore
//
//  Created by Dave DeLong on 6/12/10.
//  Copyright 2010 Home. All rights reserved.
//
#import "CHLogging.h"

@interface Foo : NSObject
{
}

+ (void) classBar;
- (void) bar;

@end

@implementation Foo

+ (void) classBar {
	CHLogMethod;
}
- (void) bar {
	CHLogMethod;
}

@end

@interface Bar : Foo

@end
@implementation Bar
@end




int main(int argc, char * argv[]) {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	CHLogLevelSetDefault(YES);
	CHLog(@"%d", CHLogLevelDefault());
	CHLog(@"%d", [[CHLogger currentLog] shouldLogLevel]);
	
	CHLogFunction;
	CHLog(@"here!");
	
	[Foo classBar];
	Foo * f = [[Foo alloc] init];
	[f bar];
	
	Bar * b = [[Bar alloc] init];
	[b bar];
	
	[[CHLogger currentLog] setShouldLogDate:NO];
	[[CHLogger currentLog] setShouldLogProcessID:NO];
	[[CHLogger currentLog] setShouldLogProcessName:NO];
	//	[[CHLogger currentLog] setShouldLogThread:NO];
	
	CHLog(@"default");
	CHLogStatement([b release]);
	
	CHLogDebug(@"debug");
	CHLogInfo(@"info");
	CHLogNotice(@"notice");
	CHLogAlert(@"alert");
	CHLogWarning(@"warning");
	CHLogEmergency(@"emergency");
	CHLogError(@"error");
	
	CHLogger * mirror = [[CHLogger alloc] initWithOutput:[NSFileHandle fileHandleWithStandardOutput]];
	[[CHLogger currentLog] mirrorOutputToLog:mirror];
	
	[[NSThread currentThread] setName:@"main"];
	[f bar];
	
	[[CHLogger currentLog] stopMirroringOutputToLog:mirror];
	[mirror release];
	
	[f release];
	
	[pool release];
}