//
//  GBDuration.m
//  Cue Editor
//
//  Created by 竞纬 戴 on 6/11/12.
//  Copyright (c) 2012 Hunan Institute of Science. All rights reserved.
//

#import "GBDuration.h"

NSNumberFormatter *numFormatter;

#define ScanNextKey(scanner, buffer)		[scanner scanUpToString:@":" intoString:&buffer]
#define ScannerSkipNextCharacter(scanner)	scanner.scanLocation += 1

@implementation GBDuration

@synthesize minute = _minute;
@synthesize second = _second;
@synthesize millisecond = _millisecond;
@synthesize duration = _duration;

- (id)init
{
	if ((self = [super init]))
	{
		_minute = 0;
		_second = 0;
		_millisecond = 0;
	}
	return self;
}

- (id)initWithString:(NSString *)aString
{
	if ((self = [self init]))
		[self setDescription:aString];

	return self;
}

- (id)initWithTime:(NSUInteger)time
{
	if ((self = [self init]))
		[self setSecond:time];
	
	return self;
}

- (id)initWithDuration:(GBDuration *)duration
{
	if ((self = [self init]))
	{
		_minute = duration.minute;
		_second = duration.second;
		_millisecond = duration.millisecond;
	}
	return self;
}


- (id)copyWithZone:(NSZone *)zone
{
	return [[GBDuration allocWithZone:zone] initWithDuration:self];
}

+ (__autoreleasing id)durationWithTime:(NSUInteger)time
{
	GBDuration *__autoreleasing duration = [[GBDuration alloc] initWithTime:time];
	return duration;
}
+ (id __autoreleasing)durationWithString:(NSString *)aString
{
	GBDuration *__autoreleasing duration = [[GBDuration alloc] initWithString:aString];
	return duration;
}

+ (id __autoreleasing)durationWithDuration:(GBDuration *)duration
{
	GBDuration *__autoreleasing anObject = [[GBDuration alloc] initWithDuration:duration];
	return anObject;
}

+ (void)initialize
{
	numFormatter = [[NSNumberFormatter alloc] init];
	[numFormatter setFormatWidth:2];
	[numFormatter setPaddingCharacter:@"0"];
}

- (id)addSeconds:(int)secs
{
	[self setSecond:_second + secs];
	return self;
}

- (id)addMilliseconds:(int)millisecs
{
	[self setMillisecond:_millisecond + millisecs];
	return self;
}

- (NSInteger)intervalBetween:(GBDuration *)anObject
{
	NSInteger interval = 0;
	
	interval += (anObject.minute - _minute) * 60;

	if (interval > 0 && anObject.second < _second)
	{
		interval += anObject.second + ( 60 - _second);
		interval -= 60;
	}
	else
		interval += anObject.second - _second;

	return interval;
}

- (void)setSecond:(int)second
{	
	_second = second;
	if (_second >= 60)
	{
		[self setMinute:(_second / 60) + _minute];
		_second %= 60;
	}
}

- (void)setMillisecond:(int)millisecond
{
	_millisecond = millisecond;
	if (_millisecond >= 60)
	{
		[self addSeconds:_millisecond / 60];
		_millisecond %= 60;
	}
}

- (NSInteger)duration
{
	return _second + _minute * 60;
}

- (void)setDuration:(NSInteger)duration
{
	_minute = 0;
	self.second = duration;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"%@:%@:%@", StringFromInt(_minute), StringFromInt(_second), StringFromInt(_millisecond)];
}

- (void)setDescription:(NSString *)description
{
	NSScanner *scanner = [NSScanner scannerWithString:description];
	NSString *buffer;
	
	ScanNextKey(scanner, buffer);
	self.minute = buffer.intValue;
	
	ScannerSkipNextCharacter(scanner);
	ScanNextKey(scanner, buffer);
	self.second = buffer.intValue;
	
	if (!scanner.isAtEnd)
	{
		ScannerSkipNextCharacter(scanner);
		ScanNextKey(scanner, buffer);
		self.millisecond = buffer.intValue;
	}
}

- (void)setShortDescription:(NSString *)shortDescription
{
	NSScanner *scanner = [NSScanner scannerWithString:shortDescription];
	NSString *buffer;
	
	ScanNextKey(scanner, buffer);
	self.minute = buffer.intValue;
	
	ScannerSkipNextCharacter(scanner);
	ScanNextKey(scanner, buffer);
	self.second = buffer.intValue;	
}

- (NSString *)shortDescription
{
	return [NSString stringWithFormat:@"%@:%@", StringFromInt(_minute), StringFromInt(_second)];
}


@end





















