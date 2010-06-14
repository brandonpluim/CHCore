//
//  CHLog.m
//  CHCore
//
//  Created by Dave DeLong on 6/12/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "CHLogger.h"
#import "CHLogFunctions.h"

NSString * const CHLogThreadKey = @"CHLogThreadKey";
NSString * const CHLogLevelNames[8] = {
	@"DEBUG",
	@"INFO",
	@"NOTE",
	@"WARN",
	@"ERROR",
	@"CRITICAL",
	@"ALERT",
	@"EMERGENCY"
};

@interface CHLogger ()

@property (readonly) NSFileHandle * outputHandle;
@property (readonly) NSString * logFile;

- (void) writeData:(NSData *)data;
- (void) rotateIfNecessary;

@end

@implementation CHLogger

@synthesize outputHandle;
@synthesize minimumLogLevel;
@synthesize logFile;
@synthesize maximumLogSize;

@synthesize shouldLogDate;
@synthesize shouldLogProcessName;
@synthesize shouldLogProcessID;
@synthesize shouldLogThread;
@synthesize shouldLogMethod;
@synthesize shouldLogFile;
@synthesize shouldLogLineNumber;
@synthesize shouldLogLevel;

+ (id) currentLog {
	NSThread * current = [NSThread currentThread];
	NSMutableDictionary * threadData = [current threadDictionary];
	
	CHLogger * threadLog = [threadData objectForKey:CHLogThreadKey];
	if (threadLog == nil) {
		threadLog = [[CHLogger alloc] initWithOutput:[NSFileHandle fileHandleWithStandardOutput]];
		[threadData setObject:threadLog forKey:CHLogThreadKey];
		[threadLog autorelease];
	}
	
	return [[threadLog retain] autorelease];
}

- (id) initWithOutput:(NSFileHandle *)output forFile:(NSString *)file {
	if (self = [super init]) {
		outputHandle = [output retain];
		logFile = [file copy];
		mirrors = [[NSMutableSet alloc] init];
		maximumLogSize = 0;
		
		[self setShouldLogDate:CHLogDateDefault()];
		[self setShouldLogProcessName:CHLogProcessNameDefault()];
		[self setShouldLogProcessID:CHLogProcessIDDefault()];
		[self setShouldLogThread:CHLogThreadDefault()];
		[self setShouldLogMethod:CHLogMethodDefault()];
		[self setShouldLogFile:CHLogFileDefault()];
		[self setShouldLogLineNumber:CHLogLineNumberDefault()];
		[self setShouldLogLevel:CHLogLevelDefault()];
	}
	return self;
}

- (id) initWithLogFile:(NSString *)file {
	if (file == nil) { goto errorExit; }
	if ([[NSFileManager defaultManager] fileExistsAtPath:file] == NO) {
		BOOL ok = [[NSFileManager defaultManager] createFileAtPath:file contents:nil attributes:nil];
		if (!ok) { goto errorExit; }
	}
	NSFileHandle * handle = [NSFileHandle fileHandleForWritingAtPath:file];
	if (handle == nil) { goto errorExit; }
	return [self initWithOutput:handle forFile:file];
	
errorExit:
	[self release];
	return nil;
}

- (id) initWithOutput:(NSFileHandle *)output {
	return [self initWithOutput:output forFile:nil];
}

- (void) dealloc {	
	[outputHandle release], outputHandle = nil;
	[mirrors release], mirrors = nil;
	[logFile release], logFile = nil;
	[super dealloc];
}

- (void) mirrorOutputToLog:(CHLogger *)aLog {
	if (aLog == self) { return; }
	if (aLog == nil) { return; }
	
	[mirrors addObject:aLog];
}

- (void) stopMirroringOutputToLog:(CHLogger *)aLog {
	if (aLog == nil) { return; }
	[mirrors removeObject:aLog];
}

- (void) addDateToFormatString:(NSMutableString *)formatString {
	if ([self shouldLogDate]) {
		[formatString appendFormat:@"%@ ", [NSDate date]];
	}
}

- (void) addProcessInfoToFormatString:(NSMutableString *)formatString {
	if ([self shouldLogProcessName]) {
		[formatString appendFormat:@"%@", [[NSProcessInfo processInfo] processName]];
	}
	if ([self shouldLogProcessID] || [self shouldLogThread]) {
		[formatString appendString:@"["];
		if ([self shouldLogProcessID]) {
			[formatString appendFormat:@"%d", [[NSProcessInfo processInfo] processIdentifier]];
		}
		if ([self shouldLogProcessID] && [self shouldLogThread]) {
			[formatString appendString:@":"];
		}
		if ([self shouldLogThread]) {
			NSString * threadName = [[NSThread currentThread] name];
			if (threadName == nil) {
				threadName = [NSString stringWithFormat:@"%p", [NSThread currentThread]];
			}
			[formatString appendFormat:@"%@", threadName];
		}
		[formatString appendString:@"]"];
	}
	if ([self shouldLogProcessName] || [self shouldLogProcessID] || [self shouldLogThread]) {
		[formatString appendString:@" "];
	}
}

- (void) addFileInfoToFormatString:(NSMutableString *)formatString fromFile:(char *)file line:(int)line {
	if ([self shouldLogFile]) {
		NSString * filePath = [NSString stringWithUTF8String:file];
		NSString * fileName = [filePath lastPathComponent];
		if ([self shouldLogLineNumber]) {
			[formatString appendFormat:@"%@:%d ", fileName, line];
		} else {
			[formatString appendFormat:@"%@ ", fileName];
		}
	} else if ([self shouldLogLineNumber]) {
		[formatString appendFormat:@"%d ", line];
	}
}

- (void) addMethodInfoToFormatString:(NSMutableString *)formatString fromObject:(id)object selector:(SEL)selector function:(const char *)function {
	if ([self shouldLogMethod]) {
		char methodKind = function[0];
		if (methodKind == '-' || methodKind == '+') {
			NSString * className = NSStringFromClass((methodKind == '-' ? [object class] : object));
			NSString * methodName = NSStringFromSelector(selector);
			[formatString appendFormat:@"%c[%@ %@] ", methodKind, className, methodName];
		} else {
			[formatString appendFormat:@"%s() ", function];
		}
	}
}

- (void) addLogLevel:(CHLogLevel)level toFormatString:(NSMutableString *)formatString {
	if ([self shouldLogLevel]) {
		[formatString appendFormat:@"%@: ", CHLogLevelNames[level]];
	}
}

- (void) addMessage:(NSString *)message toFormatString:(NSMutableString *)formatString {
	[formatString appendFormat:@"%@\n", message];
}

- (void) writeMessage:(NSString *)msg fromObject:(id)object selector:(SEL)selector line:(int)lineNumber file:(char *)file function:(const char *)function level:(CHLogLevel)level {
	if (level < [self minimumLogLevel]) { return; }
	
	NSMutableString * format = [NSMutableString string];
	[self addDateToFormatString:format];
	[self addProcessInfoToFormatString:format];
	[self addFileInfoToFormatString:format fromFile:file line:lineNumber];
	[self addMethodInfoToFormatString:format fromObject:object selector:selector function:function];
	if ([msg length] > 0) {
		[self addLogLevel:level toFormatString:format];
	}
	[self addMessage:msg toFormatString:format];
	
	NSData * formattedData = [format dataUsingEncoding:NSUTF8StringEncoding];
	
	[self writeData:formattedData];
	for (CHLogger * mirror in mirrors) {
		[mirror writeData:formattedData];
	}
}

- (void) writeData:(NSData *)lineData {
	[[self outputHandle] writeData:lineData];
	[self rotateIfNecessary];
}

- (void) rotateIfNecessary {
	if ([self logFile] == nil) { return; }
	if ([self maximumLogSize] == 0) { return; }
}

@end
