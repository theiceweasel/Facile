//
//  FacileToolbarDelegate.m
//  Facile
//
//  Created by Eli Dourado on 12/10/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "FacileToolbarDelegate.h"


@implementation FacileToolbarDelegate
@synthesize searchItem;
@synthesize search;

- (void)awakeFromNib
{
	[search bind:@"predicate" toObject:data withKeyPath:@"filterPredicate" options:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"Search",@"message contains[c] $value OR name contains[c] $value",nil] forKeys:[NSArray arrayWithObjects:NSDisplayNameBindingOption,NSPredicateFormatBindingOption,nil]]];

}



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
    return [item autorelease];
}


@synthesize menu;
@synthesize data;
@synthesize toolbar;
@end
