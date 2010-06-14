//
//  CHLogFunctions.h
//  CHCore
//
//  Created by Dave DeLong on 6/12/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CHLogger.h"

extern CHLogLevel CHLogDefaultLevel();
extern void CHLogSetDefaultLevel(CHLogLevel newDefault);

extern BOOL CHLogDateDefault();
extern void CHLogDateSetDefault(BOOL shouldLog);

extern BOOL CHLogProcessNameDefault();
extern void CHLogProcessNameSetDefault(BOOL shouldLog);

extern BOOL CHLogProcessIDDefault();
extern void CHLogProcessIDSetDefault(BOOL shouldLog);

extern BOOL CHLogThreadDefault();
extern void CHLogThreadSetDefault(BOOL shouldLog);

extern BOOL CHLogFileDefault();
extern void CHLogFileSetDefault(BOOL shouldLog);

extern BOOL CHLogLineNumberDefault();
extern void CHLogLineNumberSetDefault(BOOL shouldLog);

extern BOOL CHLogMethodDefault();
extern void CHLogMethodSetDefault(BOOL shouldLog);

extern BOOL CHLogLevelDefault();
extern void CHLogLevelSetDefault(BOOL shouldLog);