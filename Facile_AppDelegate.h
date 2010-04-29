//
//  Facile_AppDelegate.h
//  Facile
//
//  Created by Eli Dourado on 11/16/07.
//  //  // Edited By William Whitlock                                                   Eli Dourado 2007 . All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Facile_AppDelegate : NSObject 
{
    IBOutlet NSWindow *window;
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
- (NSManagedObjectModel *)managedObjectModel;
- (NSManagedObjectContext *)managedObjectContext;

- (IBAction)saveAction:sender;

@property (retain) NSWindow *window;
@end
