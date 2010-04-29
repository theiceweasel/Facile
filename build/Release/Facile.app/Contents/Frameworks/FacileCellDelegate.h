//
//  FacileCellDelegate.h
//  Facile
//
//  Created by Eli Dourado on 12/10/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FacileCell.h"


@interface FacileCellDelegate : NSObject {
	NSImage *mask;
}

@property (retain) NSImage *mask;
@end
