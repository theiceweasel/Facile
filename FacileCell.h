//
//  FacileCell.h
//  Facile
//
//  Created by Eli Dourado on 11/17/07.
//  Copyright 2007 Eli Dourado. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FacileCell : NSTextFieldCell {
	NSObject* delegate;
	NSString* iconKeyPath;
	NSString* primaryTextKeyPath;
	NSString* secondaryTextKeyPath;
}

- (void) setDataDelegate: (NSObject*) aDelegate;

- (void) setIconKeyPath: (NSString*) path;
- (void) setPrimaryTextKeyPath: (NSString*) path;
- (void) setSecondaryTextKeyPath: (NSString*) path;

@end

@interface NSObject(FacileCellDelegate)

- (NSImage*) iconForCell: (FacileCell*) cell data: (NSObject*) data;
- (NSString*) primaryTextForCell: (FacileCell*) cell data: (NSObject*) data;
- (NSString*) secondaryTextForCell: (FacileCell*) cell data: (NSObject*) data;
//- (NSString*) timestampForCell: (FacileCell*) cell data: (NSObject*) data;

					   // optional: give the delegate a chance to set a different data object
					   // This is especially useful for those cases where you do not want that NSCell creates copies of your data objects (e.g. Core Data objects).
					   // In this case you bind a value to the NSTableColumn that enables you to retrieve the correct data object. You retrieve the objects
					   // in the method dataElementForCell
- (NSObject*) dataElementForCell: (FacileCell*) cell;

	// optional
- (BOOL) disabledForCell: (FacileCell*) cell data: (NSObject*) data;

@end