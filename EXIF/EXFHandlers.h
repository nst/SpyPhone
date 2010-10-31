/*!
  @header EXFTagHandler
  @copyright 2008. Created by steve woodcock on 30/03/2008. 
//  Licensed under GPL 2.0 http://www.gnu.org/licenses/gpl-2.0.txt
				@discussion The EXFHandlers are to enable either overriding of default tag handling, or to be able to handle tags that 
  are not recognised by the parser.
 
  In order to use this the implementation must support the protocol that at the very least provides:
  1) Decoding the tag data from a byte format
  2) The size in bytes that the value will occupy
  3) Whether it will support the object type provided 
  4) Encoding of the value into a byte form
  5) (Optionally) the tagFomat (see EXFConstants for the tagFormat enumeration)
  
 
 */

/*!
	@protocol EXFTagHandler
	@abstract Prtocol defintion for User defined Tag Handlers
	*/
@protocol EXFTagHandler

/*!
   Decoding of the tag from a byte buffer and insertion into the provided dictionary under the key provided
 */
-(void)decodeTag:(NSMutableDictionary*) keyedValues: (NSNumber*) tagId: (CFDataRef*) tagData: (BOOL) bigEndianOrder;

-(int) getSizeOfValue:(id)value;

-(BOOL)supportsValueType:(id) value;

-(void)encodeTag: (NSMutableData*) targetBuffer: (id) tagData:(BOOL) bigEndianOrder;

@optional

-(int) tagFormat;
-(int) parentTagId;
-(BOOL) isEditable;

@end

/*
 These are the internal Handlers used to provide specialised handling for 
 certain tags.
 */

@interface EXFGPSLocationHandler: NSObject<EXFTagHandler>

@end

@interface EXFGPSTimeHandler: NSObject<EXFTagHandler>

@end

@interface EXFTextHandler: NSObject<EXFTagHandler>

@end

@interface EXFASCIIHandler: NSObject<EXFTagHandler>

@end

@interface EXFByteHandler: NSObject<EXFTagHandler>
@end

@interface  EXFByteArrayHandler: NSObject<EXFTagHandler>
@end
