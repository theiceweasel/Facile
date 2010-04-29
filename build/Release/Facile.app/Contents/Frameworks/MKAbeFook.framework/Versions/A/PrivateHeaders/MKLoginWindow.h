/*
 Copyright (c) 2007, Mike Kinney
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the 
 following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this list of conditions and the 
 following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the 
 following disclaimer in the documentation and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, 
 INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
 WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE 
 USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
 */
//
//  LoginWindow.h
//  MKAbeFook
//
//  Created by Mike on 10/11/06.
//  Copyright 2006 Mike Kinney. All rights reserved.
//

#import <Cocoa/Cocoa.h>
//0.6 case sensitivity issue fixed.  Thanks Dale.
#import <WebKit/WebKit.h>
@interface MKLoginWindow : NSWindowController {
	NSString *path;
	IBOutlet WebView *loginWebView;
	IBOutlet NSButton *closeSheetButton; 
	id _delegate;
}

-(id)initWithDelegate:(id)aDelegate;
-(id)initForSheetWithDelegate:aDelegate;
-(void)loadURL:(NSURL *)loginURL forSheet:(BOOL)webViewForSheet;
-(IBAction)closeSheet:(id)sender;

@end
