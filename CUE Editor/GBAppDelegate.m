//
//  GBAppDelegate.m
//  Cue Editor
//
//  Created by 竞纬 戴 on 6/8/12.
//  Copyright (c) 2012 Hunan Institute of Science. All rights reserved.
//

#import "GBAppDelegate.h"
#import "GBCueSheetDocument.h"
#import "GBURLView.h"
#import "GBAboutWindowController.h"
#import "GBAboutWindowController.h"

@interface GBAppDelegate ()

@property (nonatomic, assign) IBOutlet NSTableView *recentsTableView;

@property (nonatomic, strong) NSIndexSet *selectedRecentsIndexSet;

@property (nonatomic, assign) BOOL showWelcomePanel;
@property (nonatomic, strong) NSOpenPanel *openPanel;
@property (nonatomic, strong) GBAboutWindowController *aboutController;

- (IBAction)welcomeToCueEditor:(id)sender;
- (IBAction)openOther:(id)sender;
- (IBAction)openSelected:(id)sender;
- (IBAction)showAboutWindow:(id)sender;

@end

@implementation GBAppDelegate

@synthesize welcomePanel = _welcomePanel;
@synthesize showWelcomePanel = _showWelcomePanel;
@synthesize openPanel = _openPanel;
@synthesize recentsTableView = _recentsTableView;
@synthesize selectedRecentsIndexSet = _selectedRecentsIndexSet;
@synthesize aboutController = _aboutController;


+ (void)initialize
{
	NSDictionary *defaults = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], @"Show Welcome Panel", nil];
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}


#pragma mark _
#pragma mark Application Delegate


- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
	if (self.showWelcomePanel)
		[self.welcomePanel makeKeyAndOrderFront:self];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag
{
	if (!flag)
	{
		if (self.showWelcomePanel)
			[self.welcomePanel makeKeyAndOrderFront:self];
		return YES;
	}
	return NO;
}

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender
{
	return NO;
}


#pragma mark _
#pragma mark NSTableViewDataSource Overrides

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
	return [self.recentDocumentURLs count];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
	GBURLView *aView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
	[aView setURL:[self.recentDocumentURLs objectAtIndex:row]];
	return aView;
}

- (void)insertNewRow
{
	[_recentsTableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:0] withAnimation:YES];
}


#pragma mark _
#pragma mark NSDocumentController Overrides


//- (void)noteNewRecentDocument:(NSDocument *)document
//{
//	[super noteNewRecentDocument:document];
//}

- (void)noteNewRecentDocumentURL:(NSURL *)url
{
	BOOL containsObject = [self.recentDocumentURLs containsObject:url];
		
	[_recentsTableView beginUpdates];
	if (!containsObject || (self.recentDocumentURLs.count == 1 && self.recentsTableView.numberOfRows == 0))
	{
		[super noteNewRecentDocumentURL:url];
		[self performSelector:@selector(insertNewRow) withObject:nil afterDelay:0.5];
	}
	else
	{
		[_recentsTableView moveRowAtIndex:[self.recentDocumentURLs indexOfObject:url] toIndex:0];
		[super noteNewRecentDocumentURL:url];
	}
	[_recentsTableView endUpdates];
}

- (void)clearRecentDocuments:(id)sender
{
	[super clearRecentDocuments:self];
	[_recentsTableView reloadData];
}


#pragma mark _
#pragma mark Application Controller

- (void)openOther:(id)sender
{
	[self.openPanel beginSheetModalForWindow:_welcomePanel completionHandler:^(NSInteger result) {
		if (result == NSFileHandlingPanelOKButton)
			[self openDocumentWithContentsOfURL:_openPanel.URL display:YES error:nil];
	}];
}

- (void)openSelected:(id)sender
{
	_selectedRecentsIndexSet = _recentsTableView.selectedRowIndexes;
	
	[_selectedRecentsIndexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
		GBURLView *theView = [self.recentsTableView viewAtColumn:0 row:idx makeIfNecessary:NO];
		if (theView.URL.isFileURL)
			[self openDocumentWithContentsOfURL:theView.URL display:YES error:nil];
	}];
}

- (NSOpenPanel *)openPanel
{
	if (!_openPanel)
	{
		_openPanel = [[NSOpenPanel alloc] init];
		[_openPanel setCanChooseFiles:YES];
		[_openPanel setAllowedFileTypes:[NSArray arrayWithObject:@"cue"]];
		[_openPanel setDirectoryURL:[[NSUserDefaults standardUserDefaults] URLForKey:@"NSNavLastRootDirectory"]];
	}
	return _openPanel;
}

- (IBAction)showAboutWindow:(id)sender
{
	if (!_aboutController)
		_aboutController = [[GBAboutWindowController alloc] init];
	[_aboutController showWindow:self];
}

- (void)welcomeToCueEditor:(id)sender
{
	[self.welcomePanel makeKeyAndOrderFront:self];
}

- (BOOL)showWelcomePanel
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:@"Show Welcome Panel"];
}

- (void)setShowWelcomePanel:(BOOL)showWelcomePanel
{
	[[NSUserDefaults standardUserDefaults] setBool:showWelcomePanel forKey:@"Show Welcome Panel"];
}

@end
