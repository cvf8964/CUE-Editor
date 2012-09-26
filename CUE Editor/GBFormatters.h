//
//  GBFormatters.h
//  Cue Editor
//
//  Created by 竞纬 戴 on 6/22/12.
//  Copyright (c) 2012 Hunan Institute of Science. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum {
	GBDurationLongStyle = 2,
	GBDurationShortStyle = 1
} GBDurationStyle;

@interface GBDurationDescriptionFormatter : NSFormatter
@property (nonatomic, assign) GBDurationStyle durationStyle;
@end

@interface GBDateFormatter : NSFormatter
@end

@interface GBTrackNumberFormatter : NSFormatter
@end

