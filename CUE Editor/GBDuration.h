//
//  GBDuration.h
//  Cue Editor
//
//  Created by 竞纬 戴 on 6/11/12.
//  Copyright (c) 2012 Hunan Institute of Science. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GBDuration : NSObject <NSCopying>

@property (nonatomic, assign) int minute;
@property (nonatomic, assign) int second;
@property (nonatomic, assign) int millisecond;
@property (nonatomic, assign) NSInteger duration; // seconds

@property (nonatomic, assign) NSString *description;
@property (nonatomic, assign) NSString *shortDescription;

- (id)addSeconds:(int)secs;
- (id)addMilliseconds:(int)millisecs;

- (id)initWithTime:(NSUInteger)time;
- (id)initWithString:(NSString *)aString;
- (id)initWithDuration:(GBDuration *)duration;

+ (id __autoreleasing)durationWithTime:(NSUInteger)time;
+ (id __autoreleasing)durationWithString:(NSString *)aString;
+ (id __autoreleasing)durationWithDuration:(GBDuration *)duration;

// in seconds
- (NSInteger)intervalBetween:(GBDuration *)anObject;

@end


