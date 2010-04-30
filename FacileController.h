//
//  FacileController.h
//  Facile
//
//  Created by William Whitlock on 4/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Sparkle/Sparkle.h>
#import <Cocoa/Cocoa.h>
#import <MKAbeFook/MKAbeFook.h>
#import <Growl/Growl.h>
#import "FacileCell.h"
#import "FacileCellDelegate.h"
#import "FacileToolbarDelegate.h"

@interface FacileController : NSObject {
	IBOutlet NSPanel *mainWindow;
	IBOutlet SUUpdater *updater;
	IBOutlet NSToolbar *toolbar;
	IBOutlet FacileToolbarDelegate *toolbarDelegate;
	IBOutlet NSArrayController *data;
	IBOutlet NSTableView *table;
	IBOutlet NSProgressIndicator *progress;
	IBOutlet NSTextField *statusField;
	FacileCellDelegate *cellDelegate;
	NSStatusItem *statusItem;
	NSUserDefaults *prefs;
	NSManagedObjectContext *context;
	NSArray *statusSortOrder;
	IBOutlet NSMenuItem *loginoutMenuItem;
	MKFacebookRequestResponseFormat responseFormat;
	IBOutlet NSMenuItem *topMenuItem;
	IBOutlet NSMenu *statusMenu;

}
-(void)getStatus;
-(IBAction)toggleWindow:(id)sender;
-(void)facebookRequest:(MKFacebookRequest *)request responseReceived:(id)response;
-(IBAction)sendStatus:(id)sender;
-(IBAction)clearStatus:(id)sender;
-(IBAction)refresh:(id)sender;
-(IBAction)loginout:(id)sender;
-(IBAction)gotoprofile:(id)sender;
-(IBAction)quitFacile:(id)sender;
-(void)userLoginFailed:(id)message;
-(void)userLoginSuccessful;
-(void)growlAlert:(NSArray *)updates;
-(IBAction)loginout:(id)sender;

@property (retain) NSArray *statusSortOrder;
@property (retain) NSPanel *mainWindow;
@property (retain) SUUpdater *updater;
@property (retain) NSToolbar *toolbar;
@property (retain) FacileToolbarDelegate *toolbarDelegate;
@property (retain) NSArrayController *data;
@property (retain) NSTableView *table;
@property (retain) NSTextField *statusField;
@property (retain) FacileCellDelegate *cellDelegate;
@property (retain) NSStatusItem *statusItem;
@property (retain) NSUserDefaults *prefs;
@property (retain) NSManagedObjectContext *context;
@end
