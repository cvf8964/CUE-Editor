//
//  GBURLView.m
//  Cue Editor
//
//  Created by 竞纬 戴 on 6/12/12.
//  Copyright (c) 2012 Hunan Institute of Science. All rights reserved.
//

#import "GBURLView.h"


@implementation GBURLView

@synthesize URL	 = _URL;
@synthesize filePathField = _filePathField;

- (id)initWithURL:(NSURL *)URL
{

	if ((self = [super init]))
		[self setURL:URL];
	
	return self;
}

+ (id)URLViewWithURL:(NSURL *)URL
{
	GBURLView *__autoreleasing aView = [[GBURLView alloc] initWithURL:URL];
	return aView;
}

- (BOOL)isEqual:(id)object
{
	if (_URL == object)
		return YES;
	return NO;
}

- (void)setBackgroundStyle:(NSBackgroundStyle)backgroundStyle
{
	NSColor *textColor = (backgroundStyle == NSBackgroundStyleDark ? [NSColor whiteColor] : [NSColor grayColor]);
	self.filePathField.textColor = textColor;
	[super setBackgroundStyle:backgroundStyle];
}

- (void)setURL:(NSURL *)URL
{
	_URL = URL;
	
	if (_URL)
	{
		NSString *path = URL.path;
		
		[self.textField setStringValue:path.lastPathComponent];
		[self.imageView setImage:[[NSWorkspace sharedWorkspace] iconForFile:path]];
		[self.filePathField setStringValue:path.stringByAbbreviatingWithTildeInPath];
	}
}

- (NSMenu *)menuForEvent:(NSEvent *)event
{
	if (event.type == NSRightMouseDown)
		return self.menu;
	return nil;
}


@end






