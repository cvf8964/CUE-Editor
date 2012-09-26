//
//  GBPathDragDropTextField.m
//  Cue Editor
//
//  Created by 竞纬 戴 on 6/12/12.
//  Copyright (c) 2012 Hunan Institute of Science. All rights reserved.
//

#import "GBPathDragDropTextField.h"

@interface GBPathDragDropTextField ()
@property (nonatomic, assign) BOOL mouseRollOver;
@end

@implementation GBPathDragDropTextField

@synthesize mouseRollOver = _mouseRollOver;


- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self registerForDraggedTypes:[NSArray arrayWithObject:NSFilenamesPboardType]];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
	
	if (_mouseRollOver)
	{
		[[NSColor keyboardFocusIndicatorColor] set];
		[NSBezierPath setDefaultLineWidth:6];
		[NSBezierPath strokeRect:self.bounds];
	}
}

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
	self.mouseRollOver = YES;
	[self setNeedsDisplay:YES];
	return NSDragOperationCopy;
}

- (void)draggingEnded:(id<NSDraggingInfo>)sender
{
	self.mouseRollOver = NO;
	[self setNeedsDisplay:YES];
}

- (void)draggingExited:(id<NSDraggingInfo>)sender
{
	self.mouseRollOver = NO;
	[self setNeedsDisplay:YES];
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender
{
	NSArray *files = [[sender draggingPasteboard] propertyListForType:NSFilenamesPboardType];
	[self setStringValue:[files.lastObject lastPathComponent]];

	return YES;
}


@end
