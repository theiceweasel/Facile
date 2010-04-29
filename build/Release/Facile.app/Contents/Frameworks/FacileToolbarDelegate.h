//
//  FacileToolbarDelegate.h
//  Facile
//
//  Created by Eli Dourado on 12/10/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FacileToolbarDelegate : NSObject {
	IBOutlet NSMenu *menu;
	IBOutlet NSArrayController *data;
	IBOutlet NSToolbarItem *searchItem;
	IBOutlet NSSearchField *search;
	IBOutlet NSToolbar *toolbar;
}

@property (retain) NSMenu *menu;
@property (retain) NSArrayController *data;
@property (retain) NSToolbarItem *searchItem;
@property (retain) NSSearchField *search;
@property (retain) NSToolbar *toolbar;
@end
