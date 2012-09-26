//
//  GBAppDelegate.h
//  Cue Editor
//
//  Created by 竞纬 戴 on 6/8/12.
//  Copyright (c) 2012 Hunan Institute of Science. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GBAppDelegate : NSDocumentController <NSApplicationDelegate, NSTableViewDelegate, NSTableViewDataSource>

@property (nonatomic, assign) IBOutlet NSWindow *welcomePanel;

@end
