//
//  FacileController.m
//  Facile
//
//  Created by William Whitlock on 4/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FacileController.h"


@implementation FacileController


-(id)init{
	[super init];
	NSMutableDictionary *defaultPrefs = [NSMutableDictionary dictionary];
	[defaultPrefs setObject:@"1" forKey:@"timeDelay"];
	[defaultPrefs setObject:@"0.9" forKey:@"alpha"];
	[defaultPrefs setObject:@"7" forKey:@"eraseAfter"];
	[defaultPrefs setObject:@"NO" forKey:@"statusMenuBOOL"];
	
	prefs = [[NSUserDefaults standardUserDefaults] retain];
	[prefs registerDefaults:defaultPrefs];
	
	NSSortDescriptor *timeDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"time" ascending:NO] autorelease];
	statusSortOrder=[NSArray arrayWithObjects:timeDescriptor, nil];
	[GrowlApplicationBridge setGrowlDelegate:self];
	
	return self;

}

-(void)awakeFromNib{
	
	context = [[NSApp delegate] managedObjectContext];
	[mainWindow bind:@"alphaValue" toObject:prefs withKeyPath:@"alpha" options:nil];
	[toolbar setDelegate:toolbarDelegate];	
	[mainWindow setToolbar:toolbar];
	[NSApp activateIgnoringOtherApps:YES];
	
	[table setTarget:self];
	[table setDoubleAction:@selector(gotoprofile:)];
	
	cellDelegate = [[FacileCellDelegate alloc] init];
	NSTableColumn* column = [[table tableColumns] objectAtIndex:0];
	FacileCell* cell = [[[FacileCell alloc] init] autorelease];
	[cell setDataDelegate: cellDelegate];
	[column setDataCell: cell];
	
	statusItem = [[[NSStatusBar systemStatusBar]
				   statusItemWithLength:NSVariableStatusItemLength] retain];
	[statusItem setHighlightMode:YES];
	[statusItem setImage:[NSImage imageNamed:@"menubar"]];
	[statusItem setTarget:self];
	[statusItem setAction:@selector(toggleWindow:)];
	[statusItem setEnabled:YES];
	
	
	MKFacebook *fbConnection = [[MKFacebook facebookWithAPIKey:@"1557f283d3de4a97a07df85adc427e6a" delegate:self] retain];
	[fbConnection login];
	
	[NSTimer scheduledTimerWithTimeInterval:1
									 target:self
								   selector:@selector(getStatus)
								   userInfo:nil
									repeats:NO];
	
	[NSTimer scheduledTimerWithTimeInterval:(60 * [[prefs valueForKey:@"timeDelay"] intValue])
									 target:self
								   selector:@selector(getStatus)
								   userInfo:nil
									repeats:YES];
	
	
	

}

-(IBAction)toggleWindow:(id)sender
{
	if ([mainWindow isVisible]) {
		[mainWindow close];
	} else {
		[table deselectAll:nil];
		[NSApp activateIgnoringOtherApps:YES];
		[mainWindow makeKeyAndOrderFront:nil];
		[statusItem setImage:[NSImage imageNamed:@"menubar"]];
	}
}

- (void)windowWillClose:(NSNotification *)notification
{
	[NSApp hide:nil];
}

-(void)getStatus
{
	MKFacebook *fbConnection = [[MKFacebook facebookWithAPIKey:@"1557f283d3de4a97a07df85adc427e6a" delegate:self] retain];
	MKFacebookRequest *request = [MKFacebookRequest requestWithDelegate:self];
	NSMutableDictionary *parameters = [[[NSMutableDictionary alloc] init] autorelease];
	[parameters setValue:[fbConnection uid] forKey:@"uid"];
	[parameters setValue:[NSString stringWithFormat:@"SELECT uid, name, status, pic_square FROM user WHERE status.message > 0 AND uid IN (SELECT uid2 FROM friend WHERE uid1 = %@) OR uid IN (%@)", [fbConnection uid],[fbConnection uid]] forKey:@"query"];
	[request sendRequest:@"fql.query" withParameters:parameters];
	
}

-(void)facebookRequest:(MKFacebookRequest *)request responseReceived:(id)response
{
	
	//NSLog(@"Look at all the cool stuff we got: %@",[returnXML XMLStringWithOptions:NSXMLNodePrettyPrint]);
	MKFacebook *fbConnection = [[MKFacebook facebookWithAPIKey:@"1557f283d3de4a97a07df85adc427e6a" delegate:self] retain];
	
	NSXMLDocument *xmlDocument = response;
	NSXMLElement *xmlElement = [xmlDocument rootElement];
	
	if ([xmlDocument validFacebookResponse]){
		NSLog(@"YES!");
		
		NSArray *friendData = [xmlElement arrayFromXMLElement];
		NSMutableArray *updatedStatuses = [[NSMutableArray alloc] initWithObjects:nil];
		NSLog(@"%@",friendData);
		for(NSDictionary *friend in friendData){
			if([[friend valueForKey:@"uid"] isEqualToString:[fbConnection uid]]){
				if([[friend objectForKey:@"status"] valueForKey:@"message"] != nil){
					[[statusField cell] setPlaceholderString:[NSString stringWithFormat:@"%@ %@",[friend valueForKey:@"name"],[[friend objectForKey:@"status"] valueForKey:@"message"]]]; 
				} else {
					[[statusField cell] setPlaceholderString:[NSString stringWithFormat:@"%@... ",[friend valueForKey:@"name"]]]; 
				}
			}
			if([[friend objectForKey:@"status"] valueForKey:@"message"] != nil){
				
				NSString *uid=[friend valueForKey:@"uid"];
				NSDate *time=[NSDate dateWithTimeIntervalSince1970:[[[friend objectForKey:@"status"] valueForKey:@"time"] intValue]];
				NSFetchRequest *request = [[NSFetchRequest alloc] init];
				[request setEntity:[NSEntityDescription entityForName:@"Status" inManagedObjectContext:context]];		
				NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(uid == %@) AND (time == %@) ",uid,time];
				[request setPredicate:predicate];
				NSArray *dupes=[context executeFetchRequest:request error:nil];
				[request autorelease];
				
				if([dupes count]==0){
					[updatedStatuses addObject:friend];
					[context lock];
					NSLog(@"lock");
					NSManagedObject *status = [NSEntityDescription insertNewObjectForEntityForName:@"Status" inManagedObjectContext:context];
					[status setValue:[friend valueForKey:@"name"] forKey:@"name"];
					[status setValue:uid forKey:@"uid"];
					[status setValue:[friend valueForKey:@"pic_square"] forKey:@"picurl"];
					[status setValue:[[friend objectForKey:@"status"] valueForKey:@"message"] forKey:@"message"];
					[status setValue:time forKey:@"time"];
					[context unlock];
					NSLog(@"unlock");					
				}
			}
		}
		//NSLog(@"hi");
		[self growlAlert:updatedStatuses];
		[updatedStatuses autorelease];
	}	
	
	else {
		NSLog(@"error");
	}
	
}

-(void)growlAlert:(NSArray *)updates
{
	if(![mainWindow isVisible] && [updates count] > 0){
		[statusItem setImage:[NSImage imageNamed:@"alert"]];
	}	
	if([updates count] < 6){
		
		for(NSDictionary *friend in updates){
			NSData *iconData;
			if([[friend valueForKey:@"pic_square"] length]>0){
				iconData=[NSData dataWithContentsOfURL:[NSURL URLWithString:[friend valueForKey:@"pic_square"]]];
			} else {
				iconData=nil;
			}
			
			[GrowlApplicationBridge
			 notifyWithTitle:[friend valueForKey:@"name"]
			 description:[[friend objectForKey:@"status"] valueForKey:@"message"]
			 notificationName:@"Friend Status"
			 iconData:iconData
			 priority:0
			 isSticky:NO
			 clickContext:nil];
		}
	}
	else {
		
		[GrowlApplicationBridge
		 notifyWithTitle:@"Status Updates"
		 description:[NSString stringWithFormat:@"%d of your friends have updated their status.",[updates count]]
		 notificationName:@"Friend Status"
		 iconData:nil
		 priority:0
		 isSticky:NO
		 clickContext:nil];
	}
}

-(void)gotPermission:(NSXMLDocument *)xmlDocument
{
	MKFacebook *fbConnection = [[MKFacebook facebookWithAPIKey:@"1557f283d3de4a97a07df85adc427e6a" delegate:self] retain];
	//NSLog(@"Look at all the cool stuff we got: %@",[xmlDocument XMLStringWithOptions:NSXMLNodePrettyPrint]);
	if ([xmlDocument validFacebookResponse]){			
		if(![[[[xmlDocument rootElement] childAtIndex:0] description] intValue]){
			if([[NSAlert alertWithMessageText:@"Give Facile permission?" defaultButton:@"Give Permission" alternateButton:@"No, Thanks" otherButton:nil informativeTextWithFormat:@"Facile needs permission to be able to send your status updates to Facebook."] runModal] == NSAlertDefaultReturn)
			{
				[fbConnection grantExtendedPermission:@"publish_stream"];
			} else {
				[statusField setEditable:FALSE];
			}
		}
		else {
			//NSLog(@"has permission");
			[statusField setEditable:TRUE];
		}
	}
	else {
		NSLog(@"error");
	}
}

-(void)setStatus:(NSXMLDocument *)xmlDocument
{	
	//NSLog(@"Look at all the cool stuff we got: %@",[xmlDocument XMLStringWithOptions:NSXMLNodePrettyPrint]);
	if ([xmlDocument validFacebookResponse]){			
		if([[[[xmlDocument rootElement] childAtIndex:0] description] intValue]){
			[self getStatus];
			[statusField setStringValue:@""];
			[progress stopAnimation:nil];
		}
		else {
			NSLog(@"something is wrong");
			[progress stopAnimation:nil];
		}
	}
	else {
		NSLog(@"error");
		[progress stopAnimation:nil];
	}
}

-(IBAction)setSpellChecking:(id)sender
{
	[(NSTextView *)[mainWindow firstResponder] setContinuousSpellCheckingEnabled:YES];
}

-(IBAction)refresh:(id)sender
{
	[self getStatus];
}

-(IBAction)loginout:(id)sender
{
	MKFacebook *fbConnection = [[MKFacebook facebookWithAPIKey:@"1557f283d3de4a97a07df85adc427e6a" delegate:self] retain];
	if([fbConnection userLoggedIn]){
		[fbConnection logout];
		[loginoutMenuItem setTitle:@"Log In"];		
		[[statusField cell] setPlaceholderString:@""];
	} else {
		[fbConnection login];
	}
}

-(IBAction)gotoprofile:(id)sender
{
	NSString *friendid = [[[data arrangedObjects] objectAtIndex:[sender clickedRow]] valueForKey:@"uid"];
	if([friendid length]>0){
		[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.facebook.com/profile.php?id=%@",friendid]]];
	}
}

-(IBAction)sendStatus:(id)sender
{
	MKFacebookRequest *request = [MKFacebookRequest requestWithDelegate:self selector:@selector(setStatus:)];
	NSMutableDictionary *parameters = [[[NSMutableDictionary alloc] init] autorelease];
	[parameters setValue:[statusField stringValue] forKey:@"status"];
	[parameters setValue:@"true" forKey:@"status_includes_verb"];
	[request sendRequest:@"users.setStatus" withParameters:parameters];
	[progress startAnimation:nil];
}

-(IBAction)clearStatus:(id)sender
{
	[progress displayIfNeeded];
	MKFacebookRequest *request = [MKFacebookRequest requestWithDelegate:self selector:@selector(setStatus:)];
	NSMutableDictionary *parameters = [[[NSMutableDictionary alloc] init] autorelease];
	[parameters setValue:@"true" forKey:@"clear"];
	[request sendRequest:@"users.setStatus" withParameters:parameters];
	[progress startAnimation:nil];
}

-(void)userLoginSuccessful
{
	NSLog(@"neat");
	[loginoutMenuItem setTitle:@"Log Out"];
	
	MKFacebookRequest *request = [MKFacebookRequest requestWithDelegate:self selector:@selector(gotPermission:)];
	NSMutableDictionary *parameters = [[[NSMutableDictionary alloc] init] autorelease];
	[parameters setValue:@"status_update" forKey:@"ext_perm"];
	[request sendRequest:@"facebook.users.hasAppPermission" withParameters:parameters];
	[self getStatus];
	
}

-(void)userLoginFailed:(id)message
{
	NSLog(@"%@",message);
	[[statusField cell] setPlaceholderString:@""]; 
}

-(IBAction)quitFacile:(id)sender
{
	// clearing out statuses older than 1 week
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:[NSEntityDescription entityForName:@"Status" inManagedObjectContext:context]];		
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(time < %@)",[[NSDate date] addTimeInterval:-(60 *60 * 24 * [[prefs valueForKey:@"eraseAfter"] intValue])]];
	[request setPredicate:predicate];
	
	NSArray *oldstatuses = [context executeFetchRequest:request error:nil];
	[request autorelease];
	
	for(id loopItem in oldstatuses){
		[context deleteObject:loopItem];
	}
	[NSApp terminate:nil];
}


@synthesize statusSortOrder;

@synthesize mainWindow;
@synthesize updater;
@synthesize toolbar;
@synthesize toolbarDelegate;
@synthesize data;
@synthesize table;
@synthesize statusField;
@synthesize cellDelegate;
@synthesize statusItem;
@synthesize prefs;
@synthesize context;
@end
