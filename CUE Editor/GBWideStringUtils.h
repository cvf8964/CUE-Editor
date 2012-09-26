//
//  GBFileInputUtils.h
//  Cue Editor
//
//  Created by 竞纬 戴 on 6/12/12.
//  Copyright (c) 2012 Hunan Institute of Science. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <wchar.h>

@interface NSNumber (WideCharacter)
+ (NSNumber *)numberWithWCString:(const wchar_t *)str;
@end

extern int
nextDataString (FILE *afile, wchar_t *dstStr);

extern int
nextTokenString (FILE *afile, wchar_t *dstStr);


#ifndef WideCharacterUtils
#define wcsequ(s1, s2) (wcscmp(s1, s2) == 0)
#define NumberWithWCString(str) [NSNumber numberWithWCString:str]
#define StringWithWCString(buffer) [[NSString alloc] initWithBytes:buffer length:sizeof(wchar_t) * wcslen(buffer) encoding:NSUTF32LittleEndianStringEncoding]
#endif

