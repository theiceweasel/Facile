/*
 Copyright (c) 2006, Mike Kinney
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
//  MKParsingExtras.h
//  MKAbeFook
//
//  Created by Mike on 12/1/06.
//  Copyright 2006 Mike Kinney. All rights reserved.
//
//  Modified by Josh Wiseman (Facebook, Inc.) on 1/24/07
//

#import "MKAbeFook.h"
@interface MKFacebook (MKParsingExtras)

// helper methods

	/*!
	@method arrayFromXMLElement:
	 @param XMLElement The element from which to generate the array
	 @abstract Parses XML into NSArray object.
	 @discussion Recursively traverses the hierarchy rooted at XMLElement, aggregating the top-level results into a list (array). If conflicting top-level elements are found, the top-level elements are packaged into a structure (dictionary), and returned as the only object of the array. Each element in the array is either another array, a dictionary, or a string.
	 @result NSArray
	*/
-(NSArray *)arrayFromXMLElement:(NSXMLElement *)XMLElement;

	/*!
	@method dictionaryFromXMLElement:
	 @param XMLElement The element from which to generate the dictionary
	 @abstract Parses XML into NSDictionary object.
	 @discussion Recursively traverses the hierarchy rooted at XMLElement, aggregating the top-level results into a structure (dictionary). Each element in the dictionary is either an array, a dictionary, or a string.
	 @result NSDictionary
	 */
-(NSDictionary *)dictionaryFromXMLElement:(NSXMLElement *)XMLElement;

	/*!
	@method validXMLResponse:
	 @param XMLResponse An NSXMLDocument, the result of a Facebook API call
	 @abstract Determines whether an XML response from a Facebook API call is valid
	 @discussion Checks the top-level element of an XML response, making sure that it isn't an error.
	 @result BOOL
	*/
-(BOOL)validXMLResponse:(NSXMLDocument *)XMLResponse;

	/*!
	@method arrayFromXMLResponse:
	 @param XMLResponse An XMLDoccument, the result of a Facebook API call
	 @abstract Parses an XML response from a Facebook API call into an array. See arrayfromXMLElement: for the semantics of the response.
	 @result NSArray
	*/
-(NSArray *)arrayFromXMLResponse:(NSXMLDocument *)XMLResponse;

	/*!
	@method dictionaryFromXMLResponse:
	 @param XMLResponse An XMLDoccument, the result of a Facebook API call
	 @abstract Parses an XML response from a Facebook API call into a dictionary. See dictionaryfromXMLElement: for the semantics of the response.
	 @result NSDictionary
	 */
-(NSDictionary *)dictionaryFromXMLResponse:(NSXMLDocument *)XMLResponse;


@end
