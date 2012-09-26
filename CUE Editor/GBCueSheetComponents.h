//
//  GBCueSheetComponents.h
//  Cue Editor
//
//  Created by 竞纬 戴 on 6/14/12.
//  Copyright (c) 2012 Hunan Institute of Science. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "GBDuration.h"

typedef enum {
	GBCueSheetAPEFormat = 0,
	GBCueSheetFLACFormat = 1,
	GBCueSheetMP3Format = 2,
	GBCueSheetWAVEForamt = 3
} GBCueSheetFormat;


@interface GBCueAlbumInfo : NSObject

@property (nonatomic, strong) NSString *genre;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *artist;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSNumber *releasedate;
@property (nonatomic, assign) GBCueSheetFormat albumFileFormat;

@property (nonatomic, assign) NSUndoManager *docUndoManager;


- (id)initWithScanner:(NSScanner *)scanner;

- (BOOL)readFromScanner:(NSScanner *)scanner error:(NSError *__autoreleasing *)error;

@end

@interface GBCueTrackInfo : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *genre;
@property (nonatomic, strong) NSString *artist;
@property (nonatomic, strong) NSNumber *trackNumber;
@property (nonatomic, strong) GBDuration *time;

@property (nonatomic, assign) NSUndoManager *docUndoManager;

- (id)initWithScanner:(NSScanner *)scanner indexArray:(NSMutableArray *__autoreleasing *)indexArray;
+ (id)trackWithScanner:(NSScanner *)scanner indexArray:(NSMutableArray *__autoreleasing *)indexArray;

- (BOOL)readFromScanner:(NSScanner *)scanner indexArray:(NSMutableArray *__autoreleasing *)indexArray error:(NSError *__autoreleasing *)error;

@end
