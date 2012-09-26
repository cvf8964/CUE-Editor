//
//  GBCueSheetDocument.m
//  Cue Editor
//
//  Created by 竞纬 戴 on 6/11/12.
//  Copyright (c) 2012 Hunan Institute of Science. All rights reserved.
//

#import "GBCueSheetDocument.h"
#import "GBDuration.h"
#import "GBSegmentedControl.h"
#import "GBCueSheetComponents.h"
#import <CoreAudioKit/CoreAudioKit.h>
#import "GBAppDelegate.h"

NSArray *genreArray;
NSSavePanel *savePanel;
NSNumberFormatter *numFormatter;
NSMutableCharacterSet *quoteAndWhiteSpaceSet;
NSAlert *couldNotOpenAlert;

#pragma mark _
#pragma mark GBCueSheetDocument Implementation

@interface GBCueSheetDocument ()

@property (nonatomic, strong) GBCueAlbumInfo *albumInfo;
@property (nonatomic, strong) NSMutableArray *trackInfoArray;

@property (nonatomic, strong) IBOutlet NSDrawer *detailDrawer;
@property (nonatomic, assign) IBOutlet NSArrayController *arrayController;

- (IBAction)addOrRemoveTrack:(GBSegmentedControl *)sender;

@end

@implementation GBCueSheetDocument

@synthesize albumInfo = _albumInfo;
@synthesize trackInfoArray = _trackInfoArray;
@synthesize arrayController = _arrayController;
@synthesize detailDrawer = _detailDrawer;

+ (void)initialize
{
	numFormatter = [[NSNumberFormatter alloc] init];
	[numFormatter setFormatWidth:2];
	[numFormatter setPaddingCharacter:@"0"];

	quoteAndWhiteSpaceSet = [[NSMutableCharacterSet alloc] init];
	
	[quoteAndWhiteSpaceSet formUnionWithCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	[quoteAndWhiteSpaceSet formUnionWithCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
	
	savePanel = [[NSSavePanel alloc] init];
	
	[savePanel setExtensionHidden:YES];
	[savePanel setAllowedFileTypes:[NSArray arrayWithObjects:@"cue", nil]];
	[savePanel setDirectoryURL:[[NSUserDefaults standardUserDefaults] URLForKey:@"NSNavLastRootDirectory"]];
	
	NSURL *url = [[NSBundle mainBundle] URLForResource:@"Genre" withExtension:@"plist"];
	genreArray = [[[NSDictionary alloc] initWithContentsOfURL:url] valueForKey:@"Music Genre"];
	genreArray = [genreArray sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
		return [obj1 compare:obj2 options:NSCaseInsensitiveSearch];
	}];
	
	couldNotOpenAlert = [NSAlert alertWithMessageText:@"Document could not be opened" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@""];
}

- (id)init
{
	if ((self = [super init]))
	{
		_albumInfo = [[GBCueAlbumInfo alloc] init];
		_trackInfoArray = [[NSMutableArray alloc] init];		
	}
	return self;
}

- (id)initWithType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
	if ((self = [super initWithType:typeName error:outError]))
	{
		[_albumInfo setDocUndoManager:self.undoManager];
	}
	return self;
}

- (void)close
{
	[super close];
	if ([[(GBAppDelegate *)[NSDocumentController sharedDocumentController] documents] count] == 0)
		[[(GBAppDelegate *)[NSApp delegate] welcomePanel] makeKeyAndOrderFront:self];
}

- (NSString *)windowNibName
{
	return @"CueSheetDocument";
}

- (BOOL)readFromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError *__autoreleasing *)error
{
	BOOL isDirectory = NO;
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:absoluteURL.path isDirectory:&isDirectory] || isDirectory)
	{
		if (isDirectory)
			[couldNotOpenAlert setInformativeText:[NSString stringWithFormat:@"The file \"%@\" appears to be a directory", absoluteURL.lastPathComponent]];
		else
			[couldNotOpenAlert setInformativeText:[NSString stringWithFormat:@"The file \"%@\" does not exist.", absoluteURL.lastPathComponent]];
		[couldNotOpenAlert runModal];
		return NO;
	}
	
	NSWindow *welcomePanel = [(GBAppDelegate *)[NSApp delegate] welcomePanel];
	if (welcomePanel.isVisible)
		[welcomePanel orderOut:self];
	
	NSString *contentString = [[[NSAttributedString alloc] initWithPath:absoluteURL.path documentAttributes:nil] string];
	NSScanner *scanner = [[NSScanner alloc] initWithString:contentString];
		
	[scanner setCharactersToBeSkipped:quoteAndWhiteSpaceSet];
	
	[_albumInfo readFromScanner:scanner error:error];
	
	NSMutableArray *indexArray;
	
	while (!scanner.isAtEnd)
		[_trackInfoArray addObject:[GBCueTrackInfo trackWithScanner:scanner indexArray:&indexArray]];
	
	if (indexArray)
	{
		NSEnumerator *trackEnum = _trackInfoArray.objectEnumerator;
		GBDuration *durationCounter = [[GBDuration alloc] initWithString:[indexArray objectAtIndex:0]];
		NSUInteger count = indexArray.count;
		
		for (unsigned int i = 1; i < count; ++i)
		{
			@autoreleasepool
			{
				GBCueTrackInfo *atrack = trackEnum.nextObject;
				NSInteger duration = [durationCounter intervalBetween:[GBDuration durationWithString:[indexArray objectAtIndex:i]]];
				
				atrack.time = [GBDuration durationWithTime:duration];
				[durationCounter addSeconds:duration];
			}
		}
	}
	
	[_albumInfo setDocUndoManager:self.undoManager];
	for (GBCueTrackInfo *aTrack in _trackInfoArray)
		[aTrack setDocUndoManager:self.undoManager];
	
	return YES;
}

- (BOOL)writeToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName forSaveOperation:(NSSaveOperationType)saveOperation originalContentsURL:(NSURL *)absoluteOriginalContentsURL error:(NSError *__autoreleasing *)error
{
	return [self.description writeToURL:absoluteURL atomically:YES encoding:NSUTF8StringEncoding error:error];
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (void)addOrRemoveTrack:(GBSegmentedControl *)sender
{
	if (sender.mostRecentSelectedTag == 0)					// clicked add
	{
		GBCueTrackInfo *atrack = [[GBCueTrackInfo alloc] init];
		
		atrack.docUndoManager = self.undoManager;
		atrack.trackNumber = [NSNumber numberWithInt:[[_arrayController.arrangedObjects lastObject] trackNumber].intValue + 1];
		
		[_arrayController addObject:atrack];
		[self.undoManager registerUndoWithTarget:_arrayController selector:@selector(removeObject:) object:atrack];
	}
	else													// clicked remove
	{
		NSArray *objects = _arrayController.selectedObjects;
		
		if (objects.count > 0)
		{
			[_arrayController removeObjects:objects];
			[self.undoManager registerUndoWithTarget:_arrayController selector:@selector(addObjects:) object:objects];
		}
	}
}

- (NSString *)description
{
	NSMutableString *descriptionStr = [[NSMutableString alloc] init];
	
	[descriptionStr appendString:_albumInfo.description];
	
	[_trackInfoArray sortUsingComparator:^NSComparisonResult(GBCueTrackInfo *obj1, GBCueTrackInfo *obj2) {
		return [obj1.trackNumber compare:obj2.trackNumber];
	}];
	
	GBDuration *durationCounter = [[GBDuration alloc] init];
	NSInteger prevDuration = 0;

	for (GBCueTrackInfo *aTrack in _trackInfoArray)
	{
		[descriptionStr appendFormat:@"  TRACK %@ AUDIO\n", [numFormatter stringFromNumber:aTrack.trackNumber]];
		[descriptionStr appendFormat:@"    TITLE \"%@\"\n", aTrack.title];
		[descriptionStr appendFormat:@"    PERFORMER \"%@\"\n", aTrack.artist ? aTrack.artist : _albumInfo.artist];		
		[descriptionStr appendFormat:@"    INDEX 01 %@\n", [[durationCounter addSeconds:prevDuration] description]];
		prevDuration = aTrack.time.duration;
	}
	
	return descriptionStr;
}


#pragma mark _
#pragma mark ComboBox Datasource & Delegate (Genre)

- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox
{
	return genreArray.count;
}

- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index
{
	return [genreArray objectAtIndex:index];
}

- (NSString *)comboBox:(NSComboBox *)aComboBox completedString:(NSString *)string
{
	for (NSString *genre in genreArray)
	{
		if ([genre commonPrefixWithString:string options:NSCaseInsensitiveSearch].length == string.length)
			return genre;
	}
	return nil;
}



@end


