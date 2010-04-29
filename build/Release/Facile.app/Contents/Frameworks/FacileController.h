//
//  FacileController.h
//  Facile
//
//  Created by Eli Dourado on 11/16/07.
//  // Edited By William Whitlock                                                                                                    
//

#import <Sparkle/Sparkle.h>
#import <Cocoa/Cocoa.h>
#import <MKAbeFook/MKAbeFook.h>
#import <Growl/Growl.h>
#import <WebKit/WebKit.h>
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
	IBOutlet NSToolbar *toolbar;
	IBOutlet SUUpdater *updater;
	IBOutlet NSPanel *mainWindow;
	IBOutlet NSTextField *statusField;
	IBOutlet NSProgressIndicator *progress;
	IBOutlet NSArrayController *data;
	IBOutlet NSTableView *table;
	IBOutlet NSMenuItem *topMenuItem;
	IBOutlet NSMenuItem *loginoutMenuItem;
	IBOutlet NSMenu *statusMenu;
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
-(void)setAgent;
-(void)growlAlert:(NSArray *)updates;


@property (retain) NSStatusItem *statusItem;
@property (retain) NSMenu *statusMenu;
@property (retain) NSTimer *mainTimer;
@property (retain) NSUserDefaults *prefs;
@property (retain) NSManagedObjectContext *context;
@property (retain) MKFacebook *fb;
@property (retain) NSArray *statusSortOrder;
@property (retain) NSToolbar *toolbar;
@property (retain) SUUpdater *updater;
@property (retain) NSPanel *mainWindow;
@property (retain) NSTextField *statusField;
@property (retain) NSProgressIndicator *progress;
@property (retain) NSArrayController *data;
@property (retain) NSTableView *table;
@property (retain) NSMenuItem *topMenuItem;
@property (retain) NSMenuItem *loginoutMenuItem;
@property (retain) NSString *expiredkey;
@property (retain) FacileCellDelegate *cellDelegate;
@property (retain) FacileToolbarDelegate *toolbarDelegate;
@end
