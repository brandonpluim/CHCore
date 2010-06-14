//
//  CHLogFunctions.m
//  CHCore
//
//  Created by Dave DeLong on 6/12/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "CHLogFunctions.h"

static CHLogLevel _kCHDefaultLogLevel = CHLogLevelDebug;
static BOOL _kCHLogDateDefault = YES;
static BOOL _kCHLogProcessNameDefault = YES;
static BOOL _kCHLogProcessIDDefault = YES;
static BOOL _kCHLogThreadDefault = YES;
static BOOL _kCHLogMethodDefault = YES;
static BOOL _kCHLogFileDefault = YES;
static BOOL _kCHLogLineNumberDefault = YES;
static BOOL _kCHLogLevelDefault = NO;

CHLogLevel CHLogDefaultLevel() {
	return _kCHDefaultLogLevel;
}

void CHLogSetDefaultLevel(CHLogLevel newDefault) {
	_kCHDefaultLogLevel = newDefault;
}



BOOL CHLogDateDefault() { return _kCHLogDateDefault; }
void CHLogDateSetDefault(BOOL shouldLog) { _kCHLogDateDefault = shouldLog; }

BOOL CHLogProcessNameDefault() { return _kCHLogProcessNameDefault; }
void CHLogProcessNameSetDefault(BOOL shouldLog) { _kCHLogProcessNameDefault = shouldLog; }

BOOL CHLogProcessIDDefault() { return _kCHLogProcessIDDefault; }
void CHLogProcessIDSetDefault(BOOL shouldLog) { _kCHLogProcessIDDefault = shouldLog; }

BOOL CHLogThreadDefault() { return _kCHLogThreadDefault; }
void CHLogThreadSetDefault(BOOL shouldLog) { _kCHLogThreadDefault = shouldLog; }

BOOL CHLogFileDefault() { return _kCHLogFileDefault; }
void CHLogFileSetDefault(BOOL shouldLog) { _kCHLogFileDefault = shouldLog; }

BOOL CHLogLineNumberDefault() { return _kCHLogLineNumberDefault; }
void CHLogLineNumberSetDefault(BOOL shouldLog) { _kCHLogLineNumberDefault = shouldLog; }

BOOL CHLogMethodDefault() { return _kCHLogMethodDefault; }
void CHLogMethodSetDefault(BOOL shouldLog) { _kCHLogMethodDefault = shouldLog; }

BOOL CHLogLevelDefault() { return _kCHLogLevelDefault; }
void CHLogLevelSetDefault(BOOL shouldLog) { _kCHLogLevelDefault = shouldLog; }