//
//  GBFormatters.m
//  Cue Editor
//
//  Created by 竞纬 戴 on 6/22/12.
//  Copyright (c) 2012 Hunan Institute of Science. All rights reserved.
//

#import "GBFormatters.h"
#import "GBDuration.h"

@implementation GBDurationDescriptionFormatter

@synthesize durationStyle = _durationStyle;


- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _durationStyle = GBDurationShortStyle;
    }
    return self;
}

- (NSString *)stringForObjectValue:(id)obj
{
	switch (_durationStyle) {
		case GBDurationLongStyle:
			return [obj description];
			
		default:
			return [obj shortDescription];
	}
}

- (BOOL)getObjectValue:(__autoreleasing id *)obj forString:(NSString *)string errorDescription:(NSString *__autoreleasing *)error
{
	*obj = [GBDuration durationWithString:string];
	return *obj != nil;
}

- (BOOL)isPartialStringValid:(NSString *)partialString newEditingString:(NSString *__autoreleasing *)newString errorDescription:(NSString *__autoreleasing *)error
{
	const char *cstrPtr = partialString.UTF8String;
	int colonCount = 0;
	
	for (; *cstrPtr != '\0'; ++cstrPtr)
	{
		if (!isnumber(*cstrPtr))
		{
			if (*cstrPtr == ':')
				++colonCount;
			else
				break;
		}
	}
	
	if (*cstrPtr == '\0' && colonCount == _durationStyle)
		return YES;
	
	NSBeep();
	return NO;
}

@end

@implementation GBDateFormatter

- (NSString *)stringForObjectValue:(id)obj
{
	if (obj)
		return StringFromNumber(obj);
	return @"";
}

- (BOOL)getObjectValue:(__autoreleasing id *)obj forString:(NSString *)string errorDescription:(NSString *__autoreleasing *)error
{
	if (![string isEqualToString:@""])		// most times
		*obj = NumberWithString(string);
	
	return YES;
}

- (BOOL)isPartialStringValid:(NSString *)partialString newEditingString:(NSString *__autoreleasing *)newString errorDescription:(NSString *__autoreleasing *)error
{
	NSUInteger length = partialString.length;
	for (int i = 0; i < length; ++i)
		if (!isnumber([partialString characterAtIndex:i]))
		{
			NSBeep();
			return NO;
		}
	return YES;
}

@end


@implementation GBTrackNumberFormatter

- (NSString *)stringForObjectValue:(id)obj
{
	return StringFromNumber(obj);
}

- (BOOL)getObjectValue:(__autoreleasing id *)obj forString:(NSString *)string errorDescription:(NSString *__autoreleasing *)error
{
	*obj = [NSNumber numberWithInt:string.intValue];
	return YES;
}

- (BOOL)isPartialStringValid:(NSString *)partialString newEditingString:(NSString *__autoreleasing *)newString errorDescription:(NSString *__autoreleasing *)error
{
	if (partialString.intValue > 0)
		return YES;
	else
	{
		NSBeep();
		return NO;
	}
}

@end

