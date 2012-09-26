//
//  GBCueSheetComponents.m
//  Cue Editor
//
//  Created by 竞纬 戴 on 6/14/12.
//  Copyright (c) 2012 Hunan Institute of Science. All rights reserved.
//

#import "GBCueSheetComponents.h"

const char * audioFormatArray[4] = { "APE", "FLAC", "MP3", "WAVE" };

NSCharacterSet *quoteMarkSet;
NSCharacterSet *newlineSet;
NSCharacterSet *whitespaceAndNewlineSet;
NSDateFormatter *dateFormatter;

#pragma mark _
#pragma mark Macros

#define ScannerSkipNextCharacter(scanner) scanner.scanLocation += 1
#define ScanNextKey(scanner, buffer) [scanner scanUpToCharactersFromSet:whitespaceAndNewlineSet intoString:&buffer]
#define ScanToEndOfLine(scanner) [scanner scanUpToCharactersFromSet:newlineSet intoString:nil]
#define ScanNextValue(scanner, buffer) [scanner scanUpToCharactersFromSet:quoteMarkSet intoString:&buffer]

GBCueSheetFormat formatWithString (NSString *str);
GBCueSheetFormat formatWithWCString (const wchar_t *str);


#pragma mark _
#pragma mark GBCueAlbumInfo Implementation

@implementation GBCueAlbumInfo

@synthesize genre = _genre;
@synthesize title = _title;
@synthesize artist = _artist;
@synthesize fileName = _fileName;
@synthesize releasedate = _releasedate;
@synthesize albumFileFormat = _albumFileFormat;

@synthesize docUndoManager = _docUndoManager;


+ (void)initialize
{	
	newlineSet = [NSCharacterSet newlineCharacterSet];
	whitespaceAndNewlineSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
	quoteMarkSet = [NSMutableCharacterSet characterSetWithCharactersInString:@"\""];
	[(NSMutableCharacterSet *)quoteMarkSet formUnionWithCharacterSet:newlineSet];
	dateFormatter = [[NSDateFormatter alloc] initWithDateFormat:@"%Y" allowNaturalLanguage:NO];
}

- (id)initWithScanner:(NSScanner *)scanner
{
	if ((self = [super init]))
		[self readFromScanner:scanner error:nil];
	
	return self;
}

- (BOOL)readFromScanner:(NSScanner *)scanner error:(NSError *__autoreleasing *)error
{
	NSString *keyBuffer, *dataBuffer;
	
	while (!scanner.isAtEnd)
	{
		ScanNextKey(scanner, keyBuffer);
		
		if ([keyBuffer isEqualToString:@"REM"])
		{
			ScanNextKey(scanner, keyBuffer);
			ScanNextValue(scanner, dataBuffer);
			
			if ([keyBuffer isEqualToString:@"GENRE"])
				self.genre = dataBuffer;
			else if ([keyBuffer isEqualToString:@"DATE"])
				self.releasedate = NumberWithString(dataBuffer);
		}
		else if ([keyBuffer isEqualToString:@"TITLE"])
		{
			ScanNextValue(scanner, dataBuffer);
			self.title = dataBuffer;
		}
		else if ([keyBuffer isEqualToString:@"PERFORMER"])
		{
			ScanNextValue(scanner, dataBuffer);
			self.artist = dataBuffer;
		}
		else if ([keyBuffer isEqualToString:@"FILE"])
		{
			ScanNextValue(scanner, dataBuffer);
			self.fileName = dataBuffer;
			
			ScanNextKey(scanner, dataBuffer);
			self.albumFileFormat = formatWithString(dataBuffer);
		}
		else if ([keyBuffer isEqualToString:@"TRACK"])
		{
			scanner.scanLocation -= 5;
			break;
		}
	}
	return YES;
}

- (void)setGenre:(NSString *)genre
{
	if (_genre != genre)
	{
		[[_docUndoManager prepareWithInvocationTarget:self] setGenre:_genre];
		_genre = genre;
	}
}

- (void)setTitle:(NSString *)title
{
	if (_title != title)
	{
		[[_docUndoManager prepareWithInvocationTarget:self] setTitle:_title];
		_title = title;
	}
}

- (void)setArtist:(NSString *)artist
{
	if (_artist != artist)
	{
		[[_docUndoManager prepareWithInvocationTarget:self] setArtist:_artist];
		_artist = artist;
	}
}

- (void)setFileName:(NSString *)fileName
{
	if (_fileName != fileName)
	{
		[[_docUndoManager prepareWithInvocationTarget:self] setFileName:_fileName];
		_fileName = fileName;
	}
}

- (void)setReleasedate:(NSNumber *)releasedate
{
	if (_releasedate != releasedate)
	{
		[[_docUndoManager prepareWithInvocationTarget:self] setReleasedate:_releasedate];
		_releasedate = releasedate;
	}
}

- (void)setAlbumFileFormat:(GBCueSheetFormat)albumFileFormat
{
	if (_albumFileFormat != albumFileFormat)
	{
		[[_docUndoManager prepareWithInvocationTarget:self] setAlbumFileFormat:_albumFileFormat];
		_albumFileFormat = albumFileFormat;
	}
}

- (NSString *)description
{
	NSMutableString *descriptionStr = [NSMutableString string];

	if (_genre)
		[descriptionStr appendFormat:@"REM GENRE \"%@\"\n", _genre];
	if (_releasedate)
		[descriptionStr appendFormat:@"REM DATE \"%d\"\n", _releasedate.intValue];
	if (_artist)
		[descriptionStr appendFormat:@"PERFORMER \"%@\"\n", _artist];
	if (_title)
		[descriptionStr appendFormat:@"TITLE \"%@\"\n", _title];
	if (_fileName)
		[descriptionStr appendFormat:@"FILE \"%@\" %s\n", _fileName, audioFormatArray[_albumFileFormat]];
	
	return descriptionStr;
}

@end

GBCueSheetFormat formatWithString (NSString *str)
{
	static NSString *formats[4] = { @"APE", @"FLAC", @"MP3", @"WAVE" };
	for (GBCueSheetFormat i = 0; i < 4; ++i)
		if ([str isEqualToString:formats[i]])
			return i;
	return 0;
}



@implementation GBCueTrackInfo

@synthesize artist = _artist;
@synthesize time = _time;
@synthesize genre = _genre;
@synthesize title = _title;
@synthesize trackNumber = _trackNumber;
@synthesize docUndoManager = _docUndoManager;

- (id)init
{
	if ((self = [super init]))
		_time = [[GBDuration alloc] init];
	return self;
}

- (id)initWithScanner:(NSScanner *)scanner indexArray:(NSMutableArray *__autoreleasing *)indexArray
{
	if ((self = [self init]))
		[self readFromScanner:scanner indexArray:indexArray error:nil];
	
	return self;
}

+ (id)trackWithScanner:(NSScanner *)scanner indexArray:(NSMutableArray *__autoreleasing *)indexArray
{
	GBCueTrackInfo *__autoreleasing atrack = [[GBCueTrackInfo alloc] initWithScanner:scanner indexArray:indexArray];
	return atrack;
}

- (BOOL)readFromScanner:(NSScanner *)scanner indexArray:(NSMutableArray *__autoreleasing *)indexArray error:(NSError *__autoreleasing *)error
{
	NSString *buffer;
	
	ScanNextKey(scanner, buffer);
	
	if ([buffer isEqualToString:@"TRACK"])
	{
		ScanNextKey(scanner, buffer);	// track count
		ScanToEndOfLine(scanner);		// keyword "AUDIO"
		self.trackNumber = NumberWithString(buffer);
		
		while (!scanner.isAtEnd)
		{
			ScanNextKey(scanner, buffer);
			if ([buffer isEqualToString:@"TITLE"])
			{
				ScanNextValue(scanner, buffer);
				self.title = buffer;
			}
			else if ([buffer isEqualToString:@"PERFORMER"])
			{
				ScanNextValue(scanner, buffer);
				self.artist = buffer;
			}
			else if ([buffer isEqualToString:@"INDEX"])
			{
				do {
					ScanNextKey(scanner, buffer);
				} while (![buffer isEqualToString:@"01"]);
				ScanNextKey(scanner, buffer);
				if (!(*indexArray))
					*indexArray = [NSMutableArray array];
				[*indexArray addObject:buffer];
			}
			else if ([buffer isEqualToString:@"TRACK"])
			{
				scanner.scanLocation -= 5;
				break;
			}
		}
	}
	else
	{
		*error = [NSError errorWithDomain:@"Bang!" code:1001 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"An unknown error occured when reading from the .cue file", NSLocalizedFailureReasonErrorKey, nil]];
		return NO;
	}
	return YES;
}

- (void)setTitle:(NSString *)title
{
	if (_title != title)
	{
		[[_docUndoManager prepareWithInvocationTarget:self] setTitle:_title];
		_title = title;
	}
}

- (void)setGenre:(NSString *)genre
{
	if (_genre != genre)
	{
		[[_docUndoManager prepareWithInvocationTarget:self] setGenre:_genre];
		_genre = genre;
	}
}

- (void)setArtist:(NSString *)artist
{
	if (_artist != artist)
	{
		[[_docUndoManager prepareWithInvocationTarget:self] setArtist:_artist];
		_artist = artist;
	}
}

- (void)setTrackNumber:(NSNumber *)trackNumber
{
	if (_trackNumber != trackNumber)
	{
		[[_docUndoManager prepareWithInvocationTarget:self] setTrackNumber:_trackNumber];
		_trackNumber = trackNumber;
	}
}

- (void)setTime:(GBDuration *)time
{
	if (_time != time)
	{
		[[_docUndoManager prepareWithInvocationTarget:self] setTime:_time];
		_time = time;
	}
}


@end
