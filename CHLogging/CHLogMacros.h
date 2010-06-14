/*
 *  CHLogMacros.h
 *  CHCore
 *
 *  Created by Dave DeLong on 6/12/10.
 *  Copyright 2010 Home. All rights reserved.
 *
 */

#import "CHLogger.h"
#import "CHLogFunctions.h"

/**
 defining self and _cmd at the global level means we can use the same macros in Objective-C methods and C functions
 For reference, see http://stackoverflow.com/questions/3031224
 **/
id self = nil;
SEL _cmd = nil;

#pragma mark -

#define CHLogMethod [[CHLogger currentLog] writeMessage:@"" fromObject:self selector:_cmd line:__LINE__ file:__FILE__ function:__FUNCTION__ level:CHLogLevelDefault()]
#define CHLogFunction [[CHLogger currentLog] writeMessage:@"" fromObject:nil selector:NULL line:__LINE__ file:__FILE__ function:__FUNCTION__ level:CHLogLevelDefault()]

#pragma mark -

#ifndef CHLog
#define CHLog(__f,...) CHLogAtLevel(CHLogLevelDefault(), __f, ##__VA_ARGS__)
#endif

#ifndef CHLogDebug
#define CHLogDebug(__f,...) CHLogAtLevel(CHLogLevelDebug, __f, ##__VA_ARGS__)
#endif

#ifndef CHLogInfo
#define CHLogInfo(__f,...) CHLogAtLevel(CHLogLevelInfo, __f, ##__VA_ARGS__)
#endif

#ifndef CHLogNotice
#define CHLogNotice(__f,...) CHLogAtLevel(CHLogLevelNotice, __f, ##__VA_ARGS__)
#endif

#ifndef CHLogWarning
#define CHLogWarning(__f,...) CHLogAtLevel(CHLogLevelWarning, __f, ##__VA_ARGS__)
#endif

#ifndef CHLogError
#define CHLogError(__f,...) CHLogAtLevel(CHLogLevelError, __f, ##__VA_ARGS__)
#endif

#ifndef CHLogCritical
#define CHLogCritical(__f,...) CHLogAtLevel(CHLogLevelCritical, __f, ##__VA_ARGS__)
#endif

#ifndef CHLogAlert
#define CHLogAlert(__f,...) CHLogAtLevel(CHLogLevelAlert, __f, ##__VA_ARGS__)
#endif

#ifndef CHLogEmergency
#define CHLogEmergency(__f,...) CHLogAtLevel(CHLogLevelEmergency, __f, ##__VA_ARGS__)
#endif

#pragma mark -

#ifndef CHLogStatement
#define CHLogStatement(__s) \
{ \
CHLog(@"%s", #__s); \
(__s); \
}
#endif

#ifndef CHLogObject
#define CHLogObject(__o) \
{ \
CHLog(@"%s => %@", #__o, __o); \
}
#endif

#pragma mark -

#ifndef CHLogAtLevel
#define CHLogAtLevel(__l, __f, ...) \
{ \
NSString * msg = [NSString stringWithFormat:__f, ##__VA_ARGS__]; \
[[CHLogger currentLog] writeMessage:msg fromObject:self selector:_cmd line:__LINE__ file:__FILE__ function:__FUNCTION__ level:__l]; \
}
#endif
