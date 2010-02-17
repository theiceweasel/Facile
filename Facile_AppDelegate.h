//
//  Facile_AppDelegate.h
//  Facile
//
//  Created by Eli Dourado on 11/16/07.
//  Copyright Eli Dourado 2007 . All rights reserved.
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

@end
