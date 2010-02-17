//
//  FacileController.m
//  Facile
//
//  Created by Eli Dourado on 11/16/07.
//  Copyright 2007 Eli Dourado. All rights reserved.
//

#import "FacileController.h"

@implementation FacileController

- (id)init
{
	[super init];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(setSpellChecking:) 
												 name:NSControlTextDidBeginEditingNotification object:statusField];
	
	expiredkey=[NSString stringWithFormat:@"expired%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
	
	NSMutableDictionary *defaultPrefs = [NSMutableDictionary dictionary];
	[defaultPrefs setObject:@"1" forKey:@"timeDelay"];
	[defaultPrefs setObject:@"0" forKey:expiredkey];
	[defaultPrefs setObject:@"0.9" forKey:@"alpha"];
	prefs = [[NSUserDefaults standardUserDefaults] retain];
	[prefs registerDefaults:defaultPrefs];
	if ([[NSDate date] compare:[NSDate dateWithNaturalLanguageString:@"January 15, 2009"]]==NSOrderedDescending) {
//		[prefs setValue:@"1" forKey:expiredkey];
	}
	
	NSSortDescriptor *timeDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"time" ascending:NO] autorelease];
	statusSortOrder=[NSArray arrayWithObjects:timeDescriptor, nil];
	[GrowlApplicationBridge setGrowlDelegate:self];
	
	return self;
}

- (void)awakeFromNib
{
	context = [[NSApp delegate] managedObjectContext];
	[mainWindow bind:@"alphaValue" toObject:prefs withKeyPath:@"alpha" options:nil];
	toolbar=[[NSToolbar alloc] initWithIdentifier:@"toolbar"];
	[toolbar setDelegate:toolbarDelegate];
	[toolbar setDisplayMode:NSToolbarDisplayModeIconOnly];
	[toolbar setSizeMode:NSToolbarSizeModeSmall];
	[topMenuItem setImage:[NSImage imageNamed:@"Gear.icns"]];
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
	
	[self login];
}

- (void)expire
{
	if([[NSAlert alertWithMessageText:@"Facile has expired" defaultButton:@"Check For New Version" alternateButton:@"Quit" otherButton:nil informativeTextWithFormat:@"This version of Facile has expired.  Please download the latest version from the homepage."] runModal] == NSAlertDefaultReturn)
	{
		[updater checkForUpdates:nil];
	} else {
		[self quitFacile:nil];
	}
}



-(IBAction)donate:(id)sender
{
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://www.paypal.com/cgi-bin/webscr?cmd=_xclick&business=elidourado%40gmail%2ecom&item_name=Facile%20Development&no_shipping=1&no_note=1&tax=0&currency_code=USD&lc=US&bn=PP%2dDonationsBF&charset=UTF%2d8"]];
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

-(void)setTimeDelay //creates a timer with a user-specified delay, fires the timer
{
    mainTimer = [[NSTimer scheduledTimerWithTimeInterval:(60 * [[prefs valueForKey:@"timeDelay"] intValue])
                                                  target:self
                                                selector:@selector(timer:)
                                                userInfo:nil
                                                 repeats:YES] retain];	
	[mainTimer fire];
}

-(void)timer:(NSTimer *)timer 
{
	NSMutableDictionary *parameters = [[[NSMutableDictionary alloc] init] autorelease];
	[parameters setValue:[NSString stringWithFormat:@"SELECT uid, name, status, pic_square FROM user WHERE status.message > 0 AND uid IN (SELECT uid2 FROM friend WHERE uid1 = %@) OR uid IN (%@)", [fb uid],[fb uid]] forKey:@"query"];
	[MKAsyncRequest fetchFacebookData:@"facebook.fql.query"
						   parameters:parameters
				   facebookConnection:fb
							 delegate:self
							 selector:@selector(gotSomeData:)];
}

-(void)gotSomeData:(NSXMLDocument *)xmlDocument
{
	//NSLog(@"Look at all the cool stuff we got: %@",[xmlDocument XMLStringWithOptions:NSXMLNodePrettyPrint]);
	if ([fb validXMLResponse:xmlDocument]){
		NSArray *friendData = [fb arrayFromXMLResponse:xmlDocument];
		NSMutableArray *updatedStatuses = [[NSMutableArray alloc] initWithObjects:nil];
		
		int i;
		for(i=0; i<[friendData count]; i++){
			NSDictionary *friend = [friendData objectAtIndex:i];
			if([[friend valueForKey:@"uid"] isEqualToString:[fb uid]]){
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
					//NSLog(@"lock");
					NSManagedObject *status = [NSEntityDescription insertNewObjectForEntityForName:@"Status" inManagedObjectContext:context];
					[status setValue:[friend valueForKey:@"name"] forKey:@"name"];
					[status setValue:uid forKey:@"uid"];
					[status setValue:[friend valueForKey:@"pic_square"] forKey:@"picurl"];
					[status setValue:[[friend objectForKey:@"status"] valueForKey:@"message"] forKey:@"message"];
					[status setValue:time forKey:@"time"];
					[context unlock];
					//NSLog(@"unlock");					
				}
			}
		}
		
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
		
		int k;
		for(k=0; k<[updates count]; k++){
			NSDictionary *friend = [updates objectAtIndex:k];
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
	//NSLog(@"Look at all the cool stuff we got: %@",[xmlDocument XMLStringWithOptions:NSXMLNodePrettyPrint]);
	if ([fb validXMLResponse:xmlDocument]){			
		if(![[[[xmlDocument rootElement] childAtIndex:0] description] intValue]){
			if([[NSAlert alertWithMessageText:@"Give Facile permission?" defaultButton:@"Give Permission" alternateButton:@"No, Thanks" otherButton:nil informativeTextWithFormat:@"Facile needs permission to be able to send your status updates to Facebook."] runModal] == NSAlertDefaultReturn)
			{
				[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.facebook.com/authorize.php?api_key=1557f283d3de4a97a07df85adc427e6a&v=1.0&ext_perm=status_update"]];
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
	if ([fb validXMLResponse:xmlDocument]){			
		if([[[[xmlDocument rootElement] childAtIndex:0] description] intValue]){
			[mainTimer invalidate];
			[self setTimeDelay];
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
	[mainTimer invalidate];
	[self setTimeDelay];
}

-(IBAction)loginout:(id)sender
{
	if([fb userLoggedIn]){
		[mainTimer invalidate];
		[fb resetFacebookConnection];
		[loginoutMenuItem setTitle:@"Log In"];		
		[[statusField cell] setPlaceholderString:@""];
	} else {
		[self login];
	}
}

-(void)login
{
	if (![[prefs valueForKey:expiredkey] isEqualTo:@"1"]) {		
		NSString *bundleIdentifier = [[NSBundle bundleForClass:[self class]] bundleIdentifier];
		fb = [[MKFacebook facebookWithAPIKey:@"1557f283d3de4a97a07df85adc427e6a" withSecret:@"e187a4cba59b7e86fe1e67eeb77a2d82" delegate:self withDefaultsName:bundleIdentifier] retain];
		
		if ([fb loadPersistentSession]) {
			//NSLog(@"already logged in");
		} else {
			[fb showFacebookLoginWindow];
		}
	} else {
		[self expire];
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
	NSMutableDictionary *parameters = [[[NSMutableDictionary alloc] init] autorelease];
	[parameters setValue:[statusField stringValue] forKey:@"status"];
	[parameters setValue:@"true" forKey:@"status_includes_verb"];
	[MKAsyncRequest fetchFacebookData:@"facebook.users.setStatus"
						   parameters:parameters
				   facebookConnection:fb
							 delegate:self
							 selector:@selector(setStatus:)];
	[progress startAnimation:nil];
}

-(IBAction)clearStatus:(id)sender
{
	[progress displayIfNeeded];
	NSMutableDictionary *parameters = [[[NSMutableDictionary alloc] init] autorelease];
	[parameters setValue:@"true" forKey:@"clear"];
	[MKAsyncRequest fetchFacebookData:@"facebook.users.setStatus"
						   parameters:parameters
				   facebookConnection:fb
							 delegate:self
							 selector:@selector(setStatus:)];
	[progress startAnimation:nil];
}

-(void)userLoginSuccessful
{
	//NSLog(@"Neat");
	[loginoutMenuItem setTitle:@"Log Out"];
	
	NSMutableDictionary *parameters = [[[NSMutableDictionary alloc] init] autorelease];
	[parameters setValue:@"status_update" forKey:@"ext_perm"];
	[MKAsyncRequest fetchFacebookData:@"facebook.users.hasAppPermission"
						   parameters:parameters
				   facebookConnection:fb
							 delegate:self
							 selector:@selector(gotPermission:)];
	[self setTimeDelay];
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
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(time < %@)",[[NSDate date] addTimeInterval:-604800]];
	[request setPredicate:predicate];
	
	NSArray *oldstatuses = [context executeFetchRequest:request error:nil];
	[request autorelease];
	
	int i;
	for(i=0;i<[oldstatuses count];i++){
		[context deleteObject:[oldstatuses objectAtIndex:i]];
	}
	[NSApp terminate:nil];
}

@end
