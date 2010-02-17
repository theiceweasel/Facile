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
//  MKPhotoUploader.h
//  MKAbeFook
//
//  Created by Mike on 3/4/07.
//  Copyright 2007 Mike Kinney. All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import "MKFacebook.h"


@interface MKPhotoUploader : NSObject {
	NSURLConnection *facebookUploadConnection;
	id _delegate;
	MKFacebook *facebookConnection;
	NSMutableData *responseData;
	NSArray *bunchOfPhotosArray;
	BOOL isUploadingABunchOfPhotos;
	int bunchOfPhotosIndex; 
}

+(MKPhotoUploader *)usingFacebookConnection:(MKFacebook *)aFacebookConnection delegate:(id)aDelegate;
-(MKPhotoUploader *)initUsingFacebookConnection:(MKFacebook *)aFacebookConnection delegate:(id)aDelegate;
-(id)delegate;
-(void)setDelegate:(id)aDelegate;

-(void)uploadABunchOfPhotos:(NSArray *)aBunchOfPhotosArray;
//this should be private
-(void)uploadNextPhoto;

-(void)facebookPhotoUpload:(NSString *)anAid caption:(NSString *)aCaption image:(NSImage *)anImage;
-(void)facebookPhotoUpload:(NSString *)anAid caption:(NSString *)aCaption pathToImage:(NSString *)aPathToImage;
-(void)cancelUpload;

@end


@interface MKPhotoUploader(MKPhotoUploaderDelegateMethods)
-(void)photoDidFinishUploading:(id)facebookResponse;
-(void)bunchOfPhotosDidFinishUploading;
-(void)invalidImage:(NSDictionary *)aDictionary;
@end
