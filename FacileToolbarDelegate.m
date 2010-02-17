//
//  FacileToolbarDelegate.m
//  Facile
//
//  Created by Eli Dourado on 12/10/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "FacileToolbarDelegate.h"


@implementation FacileToolbarDelegate

- ( NSToolbarItem * ) toolbar: ( NSToolbar * ) toolbar
		itemForItemIdentifier: ( NSString * ) itemIdentifier
	willBeInsertedIntoToolbar: ( BOOL ) flag
{
	NSToolbarItem *item = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
	
	if ([itemIdentifier isEqualToString: @"actionMenuItem"])
	{
		[item setToolTip:@"Actions"];
		[item setLabel:[item toolTip]];
		[item setPaletteLabel:[item toolTip]];
		NSPopUpButton *popupMenu = [[[NSPopUpButton alloc] init] autorelease];
		[popupMenu setPullsDown:YES];
		[popupMenu setMenu:menu];
		[item setMinSize:NSMakeSize(32.0,32.0)];
		[item setMaxSize:NSMakeSize(50.0,32.0)];
		[item setView:popupMenu];
    }
	else if ([itemIdentifier isEqualToString: @"searchItem"])
	{
		[item setPaletteLabel:@"Search"];
		NSSearchField *search = [[[NSSearchField alloc] init] autorelease];
		[[search cell] setScrollable:YES];
		[search bind:@"predicate" toObject:data withKeyPath:@"filterPredicate" options:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"Search",@"message contains[c] $value OR name contains[c] $value",nil] forKeys:[NSArray arrayWithObjects:NSDisplayNameBindingOption,NSPredicateFormatBindingOption,nil]]];
		[item setMinSize:NSMakeSize(32.0,32.0)];
		[item setMaxSize:NSMakeSize(300.0,32.0)];
		[item setView:search];
    }
    return [item autorelease];
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar{
	return [NSArray arrayWithObjects:@"actionMenuItem",NSToolbarFlexibleSpaceItemIdentifier,@"searchItem",nil];
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar{
	return [NSArray arrayWithObjects:@"actionMenuItem",NSToolbarFlexibleSpaceItemIdentifier,@"searchItem",nil];
}

@end
