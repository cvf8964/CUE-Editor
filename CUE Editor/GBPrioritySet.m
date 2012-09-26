//
//  GBPrioritySet.m
//  Cue Editor
//
//  Created by 竞纬 戴 on 6/15/12.
//  Copyright (c) 2012 Hunan Institute of Science. All rights reserved.
//

#import "GBPrioritySet.h"

#import "GBURLView.h"

#define _enumerateNodes(headNode) for (node aNode = headNode->next; aNode != headNode; aNode = aNode->next)

struct _node;
typedef struct _node *node;

struct _node {
	id object;
	node prev;
	node next;
};

node _nodeCreate (id anObject)
{
	node anode = malloc(sizeof(*anode));
	
	//	HERE'S THE CODE:
	//	CHANGE IT TO " = [anObject retain] "
	anode->object = [[GBURLView alloc] initWithURL:anObject];
	return anode;
}

void _nodeDestroy (node aNode)
{
	[aNode->object release];
	free(aNode);
}

@interface GBMutablePrioritySet ()

@property (nonatomic, assign) node headNode;

//@property (nonatomic, assign) node *emptyNodes;
//@property (nonatomic, assign) NSUInteger maxNumItems;
//@property (nonatomic, assign) unsigned int emptyNodeIndex;

//- (node)_newNode;
//- (void)_destroyNode:(node)aNode;

@end

@implementation GBMutablePrioritySet

@synthesize count = _count;
@synthesize headNode = _headNode;

//@synthesize emptyNodes = _emptyNodes;
//@synthesize maxNumItems = _maxNumItems;
//@synthesize emptyNodeIndex = _emptyNodeIndex;

- (id)init
{
	if ((self = [super init]))
	{
		_headNode = _nodeCreate(nil);
		_headNode->prev = _headNode;
		_headNode->next = _headNode;
		_count = 0;
	}
	return self;
}

- (id)initWithPrioritySet:(GBMutablePrioritySet *)aSet
{
	if ((self = [self init]))
	{
		
	}
	return self;
}

- (void)dealloc
{
	_enumerateNodes(_headNode) {
		_nodeDestroy(aNode);
	}
	
	[super dealloc];
}

- (void)addObject:(id)anObject
{
	node aNode = [self nodeWithAssociatedObject:anObject];
	
	if (aNode == NULL)
	{
		aNode = _nodeCreate(anObject);
		++_count;
	}
	else
	{
		aNode->prev->next = aNode->next;
		aNode->next->prev = aNode->prev;
	}
	
	aNode->prev = _headNode;
	aNode->next = _headNode->next;
	
	_headNode->next->prev = aNode;
	_headNode->next = aNode;
}

- (void)addObjectToEnd:(id)anObject
{
	node aNode = [self nodeWithAssociatedObject:anObject];
	
	if (aNode == NULL)
	{
		aNode = _nodeCreate(anObject);
		++_count;
	}
	else
	{
		aNode->prev->next = aNode->next;
		aNode->next->prev = aNode->prev;
	}

	aNode->next = _headNode;
	aNode->prev = _headNode->prev;
	
	_headNode->prev->next = aNode;
	_headNode->prev = aNode;
}

- (id)objectAtIndex:(NSUInteger)index
{
	node aNode = _headNode->next;
	
	for (int i = 0; i < index; ++i)
		aNode = aNode->next;
	return aNode->object;
}

- (id)objectAtIndexCountingFromBack:(NSUInteger)index
{
	node aNode = _headNode->prev;
	
	for (int i = 0; i < index; ++i)
		aNode = aNode->prev;
	return aNode->object;
}

- (BOOL)containsObject:(id)anObject objectPointer:(__weak id *)objectPtr
{
	node aNode = [self nodeWithAssociatedObject:anObject];

	if (aNode != NULL)
		*objectPtr = aNode->object;
	
	return aNode != NULL;
}

- (node)nodeWithAssociatedObject:(id)anObject
{
	_enumerateNodes(_headNode) 
	{
		if ([aNode->object isEqual:anObject])
			return aNode;
	}
	return NULL;
}

- (void)enumerateObjectsWithOption:(GBEnumerationMode)mode UsingBlock:(void (^)(id anObject))block ;
{
	_enumerateNodes(_headNode) {
		block(aNode->object);	
	}
}




//- (node)_newNode
//{
//	if (_maxNumItems <= _emptyNodeIndex)
//	{
//		free(_emptyNodes);
//		_emptyNodeIndex = 0;
//
//		_emptyNodes = malloc(sizeof(node) * _maxNumItems);
//		for (int i = 0; i < _maxNumItems; ++i)
//			_emptyNodes[i] = malloc(sizeof(struct _node));
//	}
//	
//	return nil;
//}




@end
