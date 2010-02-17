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
//  MKFacebook.h
//  MKAbeFook
//
//  Created by Mike on 10/11/06.
//  Copyright 2006 Mike Kinney. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MKLoginWindow;

extern NSString *MKAPIServerURL;
extern NSString *MKLoginUrl;
extern NSString *MKFacebookAPIVersion;
extern NSString *MKFacebookFormat;

@interface MKFacebook : NSObject {
	
	MKLoginWindow *loginWindow;
	NSString *apiKey;
	NSString *secretKey;
	NSString *authToken;
	NSString *sessionKey;
	NSString *sessionSecret;
	NSString *uid;
	NSString *defaultsName;
	BOOL hasAuthToken;
	BOOL hasSessionKey;
	BOOL hasSessionSecret;
	BOOL hasUid;
	BOOL userHasLoggedInMultipleTimes; //used to prevent persistent session from loading if a user as logged out but the application hasn't written the NSUserDefaults yet
	NSTimeInterval connectionTimeoutInterval;
	id _delegate;	
}


+(MKFacebook *)facebookWithAPIKey:(NSString *)apiKey withSecret:(NSString *)secretKey delegate:(id)aDelegate withDefaultsName:(NSString *)aDefaultsName;
-(MKFacebook *)initUsingAPIKey:(NSString *)anApi usingSecret:(NSString *)aSecret delegate:(id)aDelegate withDefaultsName:(NSString *)aDefaultsName;

-(NSString *)apiKey;
-(NSString *)sessionKey;
-(NSString *)generateSigForParameters:(NSDictionary *)parameters;
-(NSString *)generateTimeStamp;


-(void)setConnectionTimeoutInterval:(double)aConnectionTimeoutInterval;
-(NSTimeInterval)connectionTimeoutInterval;


-(NSString *)uid;
-(BOOL)userLoggedIn;
-(void)resetFacebookConnection;
-(BOOL)loadPersistentSession;


//Login Window
-(void)getAuthSession;
-(void)showFacebookLoginWindow;
-(NSWindow *)showFacebookLoginWindowForSheet;

//prepare url
-(NSURL *)generateFacebookURL:(NSString *)aMethodName parameters:(NSDictionary *)parameters;


//synchronous request
-(id)fetchFacebookData:(NSURL *)theURL;



@end



@interface NSString (StringExtras)
- (NSString *) encodeURLLegally;
@end


