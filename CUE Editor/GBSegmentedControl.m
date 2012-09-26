//
//  GBSegmentedControl.m
//  Cue Editor
//
//  Created by 竞纬 戴 on 6/13/12.
//  Copyright (c) 2012 Hunan Institute of Science. All rights reserved.
//

#import "GBSegmentedControl.h"

@interface GBSegmentedControl ()
@property (nonatomic, readonly) float seperatorX;
@end

@implementation GBSegmentedControl

@synthesize seperatorX = _seperatorX;
@synthesize mostRecentSelectedTag = _mostRecentSelectedTag;

- (id)initWithCoder:(NSCoder *)coder
{
    if ((self = [super initWithCoder:coder]))
	{
		_seperatorX = (self.frame.size.width / 2.0) + self.frame.origin.x;
    }
    return self;
}

- (void)mouseDown:(NSEvent *)theEvent
{
	if (theEvent.locationInWindow.x < self.seperatorX)
		_mostRecentSelectedTag = 0;
	else
		_mostRecentSelectedTag = 1;

	[super mouseDown:theEvent];		// this has to be put behind the assignments, or the targeted action takes place before them
}


@end
