//
//  GBFileInputUtils.c
//  Cue Editor
//
//  Created by 竞纬 戴 on 6/12/12.
//  Copyright (c) 2012 Hunan Institute of Science. All rights reserved.
//

#import "GBWideStringUtils.h"

static char buff[102] = { '\0' };

@implementation NSNumber (WideCharacter)

+ (NSNumber *)numberWithWCString:(const wchar_t *)str
{
	wcstombs(buff, str, 4);
	return [NSNumber numberWithInt:atoi(buff)];
}

@end

int
nextDataString (FILE *afile, wchar_t *dstStr)
{
	wchar_t *chPtr, ch;
	
	while ((ch = getwc(afile)) != '\"')
		if (ch == EOF)
			return 0;
	
	for (chPtr = &dstStr[0]; (ch = getwc(afile)) != '\"'; ++chPtr)
		*chPtr = ch;
	*chPtr = '\0';
	
	return 1;
}

int nextTokenString (FILE *afile, wchar_t *dstStr)
{
	return fwscanf(afile, L"%ls", dstStr);
}


