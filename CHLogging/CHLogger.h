//
//  CHLog.h
//  CHCore
//
//  Created by Dave DeLong on 6/12/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
	CHLogLevelDebug = 0,
	CHLogLevelInfo = 1,
	CHLogLevelNotice = 2,
	CHLogLevelWarning = 3,
	CHLogLevelError = 4,
	CHLogLevelCritical = 5,
	CHLogLevelAlert = 6,
	CHLogLevelEmergency = 7
};
typedef NSUInteger CHLogLevel;

@interface CHLogger : NSObject {
	NSString * logFile;
	NSFileHandle * outputHandle;
	NSMutableSet * mirrors;
	CHLogLevel minimumLogLevel;
	
	BOOL shouldLogDate;
	BOOL shouldLogProcessName;
	BOOL shouldLogProcessID;
	BOOL shouldLogThread;
	BOOL shouldLogFile;
	BOOL shouldLogLineNumber;
	BOOL shouldLogMethod;
	BOOL shouldLogLevel;
	
	NSUInteger maximumLogSize;
}

@property CHLogLevel minimumLogLevel;
@property BOOL shouldLogDate;
@property BOOL shouldLogProcessName;
@property BOOL shouldLogProcessID;
@property BOOL shouldLogThread;
@property BOOL shouldLogFile;
@property BOOL shouldLogLineNumber;
@property BOOL shouldLogMethod;
@property BOOL shouldLogLevel;

@property NSUInteger maximumLogSize;

+ (id) currentLog;

- (id) initWithOutput:(NSFileHandle *)output;
- (id) initWithLogFile:(NSString *)logFile;

- (void) mirrorOutputToLog:(CHLogger *)aLog;
- (void) stopMirroringOutputToLog:(CHLogger *)aLog;

- (void) writeMessage:(NSString *)msg fromObject:(id)object selector:(SEL)method line:(int)lineNumber file:(char *)file function:(const char *)function level:(CHLogLevel)level;

@end
