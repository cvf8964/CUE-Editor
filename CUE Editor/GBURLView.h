//
//  GBURLView.h
//  Cue Editor
//
//  Created by 竞纬 戴 on 6/12/12.
//  Copyright (c) 2012 Hunan Institute of Science. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuickLook/QuickLook.h>

@interface GBURLView : NSTableCellView

@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) IBOutlet NSTextField *filePathField;

- (id)initWithURL:(NSURL *)URL;
+ (id)URLViewWithURL:(NSURL *)URL;

// compares the URL field!!!
- (BOOL)isEqual:(id)object;

@end

