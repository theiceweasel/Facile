//
//  FacileCell.m
//  Facile
//
//  Created by Eli Dourado on 11/17/07.
//  Copyright 2007 Eli Dourado. All rights reserved.
//

#import "FacileCell.h"

@implementation FacileCell

- (void)dealloc {
	[self setDataDelegate: nil];
	[self setIconKeyPath: nil];
	[self setPrimaryTextKeyPath: nil];
	[self setSecondaryTextKeyPath: nil];
    [super dealloc];
}

- copyWithZone:(NSZone *)zone {
	FacileCell *cell = (FacileCell *)[super copyWithZone:zone];
	cell->delegate = nil;
	[cell setDataDelegate: delegate];
    return cell;
}


- (void)setObjectValue:(id <NSCopying>)object {
    id oldObjectValue = [self objectValue];
    if (object != oldObjectValue) {
        [object retain];
        [oldObjectValue release];
        [super setObjectValue:[NSValue valueWithNonretainedObject:object]];
    }
}

- (id)objectValue {
    return [[super objectValue] nonretainedObjectValue];
}



- (void) setIconKeyPath: (NSString*) path {
	[iconKeyPath autorelease];
	iconKeyPath = [path retain];
}
- (void) setPrimaryTextKeyPath: (NSString*) path {
	[primaryTextKeyPath autorelease];
	primaryTextKeyPath = [path retain];	
}
- (void) setSecondaryTextKeyPath: (NSString*) path {
	[secondaryTextKeyPath autorelease];
	secondaryTextKeyPath = [path retain];	
}

- (void) setDataDelegate: (NSObject*) aDelegate {
	[aDelegate retain];	
	[delegate autorelease];
	delegate = aDelegate;	
}

- (id) dataDelegate {
	if (delegate) return delegate;
	return self; // in case there is no delegate we try to resolve values by using key paths
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	[self setTextColor:[NSColor whiteColor]];
	
	NSObject* data = [self objectValue];
	
	// give the delegate a chance to set a different data object
	if ([[self dataDelegate] respondsToSelector: @selector(dataElementForCell:)]) {
		data = [[self dataDelegate] dataElementForCell:self];
	}
	
	//TODO: Selection with gradient and selection color in white with shadow
	// check out http://www.cocoadev.com/index.pl?NSTableView
	
	BOOL elementDisabled    = NO;	
	if ([[self dataDelegate] respondsToSelector: @selector(disabledForCell:data:)]) {
		elementDisabled = [[self dataDelegate] disabledForCell: self data: data];
	}
	
	NSColor* primaryColor   = [self isHighlighted] ? [NSColor alternateSelectedControlTextColor] : (elementDisabled? [NSColor disabledControlTextColor] : [NSColor whiteColor]);
	NSString* primaryText   = [[self dataDelegate] primaryTextForCell:self data: data];
	
	NSDictionary* primaryTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys: primaryColor, NSForegroundColorAttributeName,
		[NSFont systemFontOfSize:13], NSFontAttributeName, nil];	
//	[primaryText drawAtPoint:NSMakePoint(cellFrame.origin.x+cellFrame.size.height+10, cellFrame.origin.y) withAttributes:primaryTextAttributes];
	[primaryText drawAtPoint:NSMakePoint(cellFrame.origin.x+60, cellFrame.origin.y) withAttributes:primaryTextAttributes];
	
	NSColor* secondaryColor = [self isHighlighted] ? [NSColor alternateSelectedControlTextColor] : (elementDisabled? [NSColor disabledControlTextColor] : [NSColor whiteColor]);
	NSString* secondaryText = [[self dataDelegate] secondaryTextForCell:self data: data];
	NSDictionary* secondaryTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys: secondaryColor, NSForegroundColorAttributeName,
		[NSFont systemFontOfSize:10], NSFontAttributeName, nil];	
//	[secondaryText drawAtPoint:NSMakePoint(cellFrame.origin.x+cellFrame.size.height+10, cellFrame.origin.y+cellFrame.size.height/2) 
//				withAttributes:secondaryTextAttributes];
	
	//(<#float x#>,<#float y#>,<#float w#>,<#float h#>)
	[secondaryText drawInRect:NSMakeRect(cellFrame.origin.x+60, cellFrame.origin.y+20,cellFrame.size.width-60,cellFrame.size.height-20) 
				withAttributes:secondaryTextAttributes];
	
	[[NSGraphicsContext currentContext] saveGraphicsState];
	float yOffset = cellFrame.origin.y;
	if ([controlView isFlipped]) {
		NSAffineTransform* xform = [NSAffineTransform transform];
		[xform translateXBy:0.0 yBy: cellFrame.size.height];
		[xform scaleXBy:1.0 yBy:-1.0];
		[xform concat];		
		yOffset = 0-cellFrame.origin.y;
	}

	NSImage* icon =[[self dataDelegate] iconForCell:self data: data];	
	
	NSImageInterpolation interpolation = [[NSGraphicsContext currentContext] imageInterpolation];
	[[NSGraphicsContext currentContext] setImageInterpolation: NSImageInterpolationHigh];	
	
//	[icon drawInRect:NSMakeRect(cellFrame.origin.x+5,yOffset+3,cellFrame.size.height-6, cellFrame.size.height-6)
/*	[icon drawInRect:NSMakeRect(cellFrame.origin.x+5,yOffset+cellFrame.size.height-55,50,50)
			fromRect:NSMakeRect(0,0,[icon size].width, [icon size].height)
		   operation:NSCompositeSourceOver
			fraction:1.0];
*/	
	[icon setSize:NSMakeSize(50,50)];
	[icon setScalesWhenResized: YES];
	[icon compositeToPoint:NSMakePoint(cellFrame.origin.x+5,yOffset+cellFrame.size.height-55)
				 operation:NSCompositeSourceOver];
	
	[[NSGraphicsContext currentContext] setImageInterpolation: interpolation];
	
	[[NSGraphicsContext currentContext] restoreGraphicsState];	
}

@synthesize delegate;
@end
