//
//  GBPrioritySet.h
//  Cue Editor
//
//  Created by 竞纬 戴 on 6/15/12.
//  Copyright (c) 2012 Hunan Institute of Science. All rights reserved.
//


//	IMPORTANT:
//	THIS CLASS HAS BEEN CUSTOMIZED TO WORK WITH GBURLView OBJECTS!
//	REMEMBER TO REMOVE THE GBURLView PARTS FOR OTHER USAGES!
//	IT'S THE _nodeCreate() PRIVATE FUNCTION


#import <Foundation/Foundation.h>

typedef enum {
	GBEnumerationNormalMode = 101,
	GBEnumerationReverseMode = 101
} GBEnumerationMode;

@interface GBMutablePrioritySet : NSObject

@property (nonatomic, assign) NSUInteger count;

- (id)init;
//- (id)initWithCapacity:(NSUInteger)numItems;
- (id)initWithPrioritySet:(GBMutablePrioritySet *)aSet;

- (void)addObject:(id)anObject;
- (void)addObjectToEnd:(id)anObject;

- (id)objectAtIndex:(NSUInteger)index;

- (BOOL)containsObject:(id)anObject objectPointer:(__weak id *)objectPtr;
- (void)enumerateObjectsWithOption:(GBEnumerationMode)mode UsingBlock:(void (^)(id anObject))block ;

@end
