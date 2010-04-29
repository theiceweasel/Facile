//
//  FacileCellDelegate.m
//  Facile
//
//  Created by Eli Dourado on 12/10/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "FacileCellDelegate.h"


@implementation FacileCellDelegate

- (id) init {
	self = [super init];
	if (self != nil) {
		mask = [NSImage imageNamed:@"mask"];
	}
	return self;
}


- (NSImage*) iconForCell: (FacileCell*) cell data: (NSObject*) data1 {
	NSManagedObject* status = (NSManagedObject*) data1;
	if([[status valueForKey:@"picurl"] length] > 0){
		NSImage *icon = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:[status valueForKey:@"picurl"]]];
		[icon lockFocus];
		[mask compositeToPoint:NSMakePoint(0,0) operation:NSCompositeDestinationIn];
		[icon unlockFocus];
		//NSBezierPath *path = [NSBezierPath bezierPathWithOvalInRect:NSMakeRect(0,0,50,50)];
		return [icon autorelease];
	} else {
		return [NSImage imageNamed:@"default"];
	}
}
- (NSString*) primaryTextForCell: (FacileCell*) cell data: (NSObject*) data1 {
	NSManagedObject* status = (NSManagedObject*) data1;
	return [status valueForKey:@"name"];
}
- (NSString*) secondaryTextForCell: (FacileCell*) cell data: (NSObject*) data1 {
	NSManagedObject* status = (NSManagedObject*) data1;
	return [NSString stringWithFormat:@"%@ (%@)",[status valueForKey:@"message"],[[status valueForKey:@"time"] descriptionWithCalendarFormat:@"%A @ %I:%M %p" timeZone:nil
																																	  locale:nil]];
}


@synthesize mask;
@end
