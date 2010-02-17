//
//  FacileController.h
//  Facile
//
//  Created by Eli Dourado on 11/16/07.
//  Copyright 2007 Eli Dourado. All rights reserved.
//

#import <Sparkle/Sparkle.h>
#import <Cocoa/Cocoa.h>
#import <MKAbeFook/MKAbeFook.h>
#import <Growl/Growl.h>
#import "FacileCell.h"
#import "FacileCellDelegate.h"
#import "FacileToolbarDelegate.h"

@interface FacileController : NSObject <GrowlApplicationBridgeDelegate> {
	NSStatusItem *statusItem;
	NSTimer *mainTimer;
	NSUserDefaults *prefs;
	NSManagedObjectContext *context;
	MKFacebook *fb;
	NSArray *statusSortOrder;
	NSToolbar *toolbar;
	IBOutlet SUUpdater *updater;
	IBOutlet NSPanel *mainWindow;
	IBOutlet NSTextField *statusField;
	IBOutlet NSProgressIndicator *progress;
	IBOutlet NSArrayController *data;
	IBOutlet NSTableView *table;
	IBOutlet NSMenuItem *topMenuItem;
	IBOutlet NSMenuItem *loginoutMenuItem;
	NSString *expiredkey;
	FacileCellDelegate *cellDelegate;
	IBOutlet FacileToolbarDelegate *toolbarDelegate;
}

-(void)setTimeDelay;
-(void)timer:(NSTimer *)timer;
-(IBAction)toggleWindow:(id)sender;
-(void)gotSomeData:(NSXMLDocument *)xmlDocument;
-(void)gotPermission:(NSXMLDocument *)xmlDocument;
-(void)setStatus:(NSXMLDocument *)xmlDocument;
-(IBAction)sendStatus:(id)sender;
-(IBAction)clearStatus:(id)sender;
-(IBAction)refresh:(id)sender;
-(IBAction)loginout:(id)sender;
-(IBAction)gotoprofile:(id)sender;
-(IBAction)quitFacile:(id)sender;
-(IBAction)donate:(id)sender;
-(void)expire;
-(void)login;
-(void)growlAlert:(NSArray *)updates;


@end
