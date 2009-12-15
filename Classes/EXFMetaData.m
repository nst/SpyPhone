//
//  Exif.m
//  iphone-test
//
//  Created by steve woodcock on 14/03/2008.
//  Copyright 2008. All rights reserved.
//


#import "EXFMutableMetaData.h"
#import "EXFLogging.h"
#import "EXFGPS.h"
#import "EXFConstants.h"
#import "EXFUtils.h"



@implementation EXFraction

-(id) initWith: (long) aNumerator : (long) aDenominator{
    
     if (self = [super init]) {
         numerator = aNumerator;
         denominator = aDenominator;
     }
    return self;
}


@synthesize numerator;
@synthesize denominator;

-(NSString*) description{
    
    return [NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:(double)numerator/(double) denominator]];
}
@end


@interface EXFTag ()
@property (readwrite) EXFTagId tagId;
@property (readwrite) int parentTagId;
@property (readwrite) EXFDataType dataType;
@property (readwrite, retain) NSString* name;
@property (readwrite) BOOL editable;
@property (readwrite) int components;
@end


@interface EXFWriter : NSObject {
    NSMutableData* tagData;
    NSMutableData* overflowData;
    }
@property (readwrite, retain) NSMutableData* tagData;
@property (readwrite, retain) NSMutableData* overflowData;
@property (readonly) int blockLength;
@end


@implementation EXFTag

@synthesize tagId;
@synthesize parentTagId;
@synthesize dataType;
@synthesize name;
@synthesize editable;
@synthesize components;

-(id) initWith: (EXFTagId) aTag: (EXFDataType)aDataType: (NSString*) aName : (int) aParentTagId: (BOOL)isEditable: (int)theComponets{
    if (self = [super init]) {
        self.tagId = aTag;
        self.dataType = aDataType;
        self.name =aName;
        self.parentTagId = aParentTagId;
        self.editable = isEditable;
        self.components = theComponets;
    }
    return self;
}

-(void) dealloc{
    self.name = nil;
    [super dealloc];
}

@end

@implementation EXFWriter

@synthesize tagData;
@synthesize overflowData;

-(id) init{
if (self = [super init]) {
    NSMutableData* theData = [[NSMutableData alloc] init];
    self.tagData = theData;
    [theData release];
    
    NSMutableData* theOverflow = [[NSMutableData alloc] init];
    self.overflowData = theOverflow;
    [theOverflow release];
    }
    return self;
}

-(int) blockLength {
    // length of block in 2 bytes at start of tagData
    int temp =0;
    temp += [tagData length];
    temp += [overflowData length];
    return temp;
    
    }


-(void) dealloc{
    self.tagData = nil;
    self.overflowData = nil;
    [super dealloc];
}

@end
    



@implementation EXFMetaData 

@synthesize  compression;
@synthesize bitsPerPixel;
@synthesize height;
@synthesize  width;
@synthesize  byteLength;
@synthesize  bigEndianOrder;
@synthesize  exif_ptr;

@synthesize userKeyedHandlers;
@synthesize keyedTagValues;
@synthesize keyedHandlers;
@synthesize tagDefinitions;
@synthesize  keyedThumbnailTagValues;
@synthesize thumbnailBytes;

// start of Exif String
const UInt8 exifChars[5] = {0x45,0x78,0x69,0x66,0x00};
 
// Big endian or Little endian constant chars
const UInt8 M_ORDER = 0x4d;
const UInt8 I_ORDER = 0x49;

// tag constants
const UInt16 bytesPerFormat[] = {0,1,1,2,4,8,1,1,2,4,8,4,8};

// Tags that have nested tag sets
const int TAG_EXIF_ROOT = -1;
const UInt16 TAG_EXIF_OFFSET = 0x8769;
const UInt16 TAG_INTEROP_OFFSET = 0xa005;
const UInt16 TAG_EXIF_GPS = 0x8825;


// allowed substitutes
const NSString* typeMappings [13] ={@"",@"CciISs",@"NSString",@"SsCcIi",@"LlIiSsCc",@"EXFraction",@"cCiISs", @"NSData", @"IisSCc",@"LlIiSsCc",@"EXFraction",@"EXFraction",@"EXFraction"};

-(EXFTag*) tagDefinition: (NSNumber*) aTagId{
    return [self.tagDefinitions.definitions objectForKey:aTagId];
}
  
-(NSMutableArray*) tagDefinitionsForParent:(NSNumber*) parent withoutImmutable:(BOOL) includeImmutable {
				
				// see if a sub array
				NSMutableArray* returnArray = [NSMutableArray arrayWithCapacity:[self.tagDefinitions.definitions count]];
				
				NSArray* keys = [self.tagDefinitions.definitions allKeys];
				
				for(id key in keys){
								EXFTag* tag = [self.tagDefinitions.definitions objectForKey:key];
								
								if ([tag parentTagId] == [parent intValue]){
												
												if ([tag editable]){
																[returnArray addObject:tag];
												}else if (includeImmutable){
																[returnArray addObject:tag];
												}
								}
				
				}
				return returnArray;
				
}

-(id) tagValue: (NSNumber*) aTagId{
    // in order - first try and get the tag definition to find parent
    
    id value = [self.keyedTagValues objectForKey:aTagId];
    
    if (value == nil){
    
       EXFTag* tag = [self.tagDefinitions.definitions objectForKey:aTagId];
       
       if (tag != nil){
           NSDictionary* dict = [self.keyedTagValues objectForKey:[NSNumber numberWithInt: tag.parentTagId]];
           if (dict != nil){
               value = [dict objectForKey:aTagId];
           }
           
       }else{
            NSDictionary* dict = [self.keyedTagValues objectForKey:[NSNumber numberWithInt: EXIF_GPS ]];
            value = [dict objectForKey:aTagId];
            
            if (value ==nil){
                dict = [self.keyedTagValues objectForKey:[NSNumber numberWithInt: EXIF_Exif]];
                value = [dict objectForKey:aTagId];
            }
       }
       // try the geo and then the 
       // 

        

    }
    return value;
   
}


-(id) thumbnailTagValue: (NSNumber*) aTagId{
    return [self.keyedThumbnailTagValues objectForKey:aTagId];
}

/* End of setter and getter methods */



/* Add the handler to the handler dictionary */

-(void) addHandler:(id)handler: (UInt16) keyValue{
    
    NSNumber* _key =nil;
    // add the invocation into the handler map
     _key = [[NSNumber alloc] initWithUnsignedInt:keyValue];
    
    [self.keyedHandlers setObject:handler forKey: _key];
    
       
    // release number objects

    [_key release];
   
    
}

/* Set up the handlers we know about. */

-(void) setupHandlers{
    
    // Set up the GPS location handlers
    EXFGPSLocationHandler* locationHandler = [[EXFGPSLocationHandler alloc] init];
    [self addHandler:locationHandler :EXIF_GPSLatitude];   
    [self addHandler:locationHandler :EXIF_GPSLongitude];
    [self addHandler:locationHandler :EXIF_GPSDestLatitude];    
    [self addHandler:locationHandler :EXIF_GPSDestLongitude];
    [locationHandler release];
    
    // do the gps timestamp
    EXFGPSTimeHandler* timeHandler = [[EXFGPSTimeHandler alloc] init];
    [self addHandler:timeHandler :EXIF_GPSTimeStamp];
    [timeHandler release];
   
  
   
    // do the char set tags
    EXFTextHandler* textHandler = [[EXFTextHandler alloc] init];
    [self addHandler:textHandler :EXIF_UserComment];
    [textHandler release];

    
    // Set up the ascii handlers
    EXFASCIIHandler* asciiHandler = [[EXFASCIIHandler alloc] init];
    [self addHandler:asciiHandler :EXIF_ExifVersion];
    [self addHandler:asciiHandler :EXIF_FlashpixVersion];
    [asciiHandler release];
    
    
    // set up the byte handler for individual bytes and undefined tag types
    EXFByteHandler* byteHandler = [[EXFByteHandler alloc] init];
    [self addHandler:byteHandler :EXIF_FileSource]; 
    [byteHandler release];
    
    // byte array tag handler
    EXFByteArrayHandler* byteArrayHandler = [[EXFByteArrayHandler alloc] init];
    [self addHandler:byteArrayHandler :EXIF_ComponentsConfiguration];
    [byteArrayHandler release];
}


-(void) addHandler:(id<EXFTagHandler>) aTagHandler forKey:(NSNumber*) aKey{
    // test key type
    if (aKey == nil || ! [aKey isMemberOfClass:[NSNumber class]]){
        //throw an error here
        NSException* myException = [NSException
                                    exceptionWithName:@"InvalidKey"
                                    reason:@"Key is nil or not a Number"
                                    userInfo:nil];
        @throw myException;
    }
    
    // test the tag handler is not null
    if (aTagHandler == nil){
        //throw an error here
        NSException* myException = [NSException
                                    exceptionWithName:@"InvalidHandler"
                                    reason:@"Tag Handler is nil"
                                    userInfo:nil];
        @throw myException;
    }
    if ( ! [((NSObject*)aTagHandler) conformsToProtocol:@protocol(EXFTagHandler)]  ) {
        // Object does not conform to EXFTagHandler protocol
        NSException* myException = [NSException
                                    exceptionWithName:@"InvalidHandler"
                                    reason:@"Tag Handler Does not conform to protocol EXFTagHandler"
                                    userInfo:nil];
        @throw myException;
    }
    
    // do not allow overwrite of nested values
    if ([aKey intValue] == TAG_EXIF_OFFSET || [aKey intValue] == TAG_INTEROP_OFFSET ||
        [aKey intValue] == TAG_EXIF_GPS){
        NSException* myException = [NSException
                                    exceptionWithName:@"InvalidHandler"
                                    reason:@"Tag Handler cannot override tags that are containers for other tag sets"
                                    userInfo:nil];
        @throw myException;
    }
    
    
    // now check optional conformance - if no tag exists then it must implement all the methods
     EXFTag* tag =  [self.keyedTagDefinitions objectForKey:aKey];
     if (tag == nil){
         // check that all the types are specified
         NSException* myException = nil;
         if ([((NSObject*)aTagHandler) respondsToSelector:@selector(tagFormat)] ){
             if (([aTagHandler tagFormat] <0 && [aTagHandler tagFormat] != -99) || 
             [aTagHandler tagFormat] < FMT_BYTE || [aTagHandler tagFormat] >FMT_DOUBLE){
                 myException = [NSException
                                exceptionWithName:@"InvalidHandler"
                                reason:@"Tag Handler tagFormat is not valid - please see documentation"
                                userInfo:nil]; 
                 
             }
         }else{
             myException = [NSException
                            exceptionWithName:@"InvalidHandler"
                            reason:@"Tag Handler must implement tagFormat to support new tag Id"
                            userInfo:nil]; 
         }
         if ([((NSObject*)aTagHandler) respondsToSelector:@selector(parentTagId)] ){
             if ([aTagHandler parentTagId]  != TAG_EXIF_GPS || [aTagHandler parentTagId] != TAG_EXIF_OFFSET
                  || [aTagHandler parentTagId] != TAG_EXIF_ROOT || [aTagHandler parentTagId] != TAG_INTEROP_OFFSET){
                 myException = [NSException
                                exceptionWithName:@"InvalidHandler"
                                reason:@"Tag Handler parent Tag Id is invalid - please see documentation"
                                userInfo:nil]; 
                 
             }
         }else{
             myException = [NSException
                            exceptionWithName:@"InvalidHandler"
                            reason:@"Tag Handler must implement tagFormat to support new tag Id"
                            userInfo:nil]; 
         }
         if (![((NSObject*)aTagHandler) respondsToSelector:@selector(isEditable)] ){
                     myException = [NSException
                                    exceptionWithName:@"InvalidHandler"
                                    reason:@"Tag Handler must implement isEditable to support new tag Id"
                                    userInfo:nil]; 
        }
         
         if (myException != nil){
             @throw myException;
         }
             
         
     }
    
    
    // otherwise add it to the user handlers
    [self.userKeyedHandlers setObject:aTagHandler forKey:aKey];
}

-(void) removeHandler: (NSNumber*) aKey{
    [self.userKeyedHandlers removeObjectForKey:aKey]; 
}

-(void) removeAllHandlers{
    [self.userKeyedHandlers removeAllObjects];
}



/* Init method */

-(id) init {
    if (self = [super init]) {
        
		// Initialize the tag definitions
        EXFTagDefinitionHolder* theTagDefs = [[EXFTagDefinitionHolder alloc] init];
        self.tagDefinitions = theTagDefs;
        [theTagDefs release];
        
        // initialise the tag values
        NSMutableDictionary* keyedValues = [[NSMutableDictionary alloc] init];
        self.keyedTagValues =keyedValues;
        [keyedValues release];
        
        // initialise the handlers
        NSMutableDictionary* handlerDict = [[NSMutableDictionary alloc] init];
        self.keyedHandlers = handlerDict;
        [handlerDict release];
        
        //initialise the user handlers
        NSMutableDictionary* userDict = [[NSMutableDictionary alloc] init];
        self.userKeyedHandlers = userDict;
        [userDict release];
        
        
        NSMutableDictionary* theKeyedThumbnailTagValues = [[NSMutableDictionary alloc] init];
        self.keyedThumbnailTagValues = theKeyedThumbnailTagValues;
        [theKeyedThumbnailTagValues release];
        
        self.thumbnailBytes =nil;
        
        // initialise the default image values
        self.height = 0;
        self.width=0;
        self.compression=0;
        self.bitsPerPixel=0;
        self.byteLength =0;
        self.bigEndianOrder =NO;
        self.exif_ptr =NULL;
        
        // set up the special handlers
        [self setupHandlers];
      
	}
	return self;
}

-(void) dealloc{
    
    
    self.exif_ptr = NULL;
   
    self.keyedHandlers = nil;
    self.keyedTagValues =nil;
    self.tagDefinitions=nil;
    self.userKeyedHandlers=nil;
    self.keyedThumbnailTagValues  =nil;
    self.thumbnailBytes =nil;
    [super dealloc];
}


-(void) addTagValue:(id)value forKey:(NSNumber*) aTagKey {
    

    // get tag definition - may be nil
    EXFTag* tag =  [self.keyedTagDefinitions objectForKey:aTagKey];
    
    int parentTagId = -1;
    
    // see if we have a user registered handler for support
    id<EXFTagHandler> handler = [self.userKeyedHandlers objectForKey:aTagKey];
    
    if (handler == nil){
        //see if we have one of our default handlers
        handler = [self.keyedHandlers objectForKey:aTagKey];
    }
    
    if(handler != nil){
         NSException *e =nil;
        if (![handler supportsValueType:value]){
           e = [NSException
                              exceptionWithName:@"InvalidTypeException"
                              reason:[NSString stringWithFormat: @"Handler %@ does not support value for %@",handler, value]
                              userInfo:nil];      
        }
        
        
        if ([((NSObject*)handler) respondsToSelector:@selector(isEditable)]){
            if ([handler isEditable] == FALSE){
                e = [NSException
                     exceptionWithName:@"NonEditableKeyException"
                     reason:[NSString stringWithFormat: @"Handler %@ does not support editing for %@",handler, aTagKey]
                     userInfo:nil];  
            }
        }else{
            if (![tag editable]){
                e = [NSException
                     exceptionWithName:@"NonEditableKeyException"
                     reason:[NSString stringWithFormat: @"Tag does not support editing for %@", aTagKey]
                     userInfo:nil];
            }
        }
        if ([((NSObject*)handler) respondsToSelector:@selector(parentTagId)]){
            parentTagId = [handler parentTagId];
        }else{
            if (tag != nil){
                parentTagId = [tag parentTagId];
            }else{
                e = [NSException
                     exceptionWithName:@"NonEditableKeyException"
                     reason:[NSString stringWithFormat: @"Tag definition not found for %@ - and parentTagId not supported by handler", aTagKey]
                     userInfo:nil];
            }
        }
        if (e != nil){
            @throw e;
        }
    } else{
        
        if (tag == nil){
            Debug(@"Tag %i is not found",tag.tagId);
            NSException *e = [NSException
                              exceptionWithName:@"NonEditableKeyException"
                              reason:[NSString stringWithFormat: @"No Tag found for Key %@", aTagKey]
                              userInfo:nil];
            @throw e;
            
        }
        
        // check if it exists that it is editable
        if (! tag.editable){
            Debug(@"Tag %x is not editiable",tag.tagId);
            NSException *e = [NSException
                              exceptionWithName:@"NonEditableKeyException"
                              reason:@"Tag is not editable"
                              userInfo:nil];
            @throw e;
            
        }
        
         parentTagId = tag.parentTagId;
         
        // lets check the type mappings for the standard tags
        int type = tag.dataType;
       
        // else lets get the string that matches the types
        NSString* dataTypeStr = (NSString*) typeMappings[type];
        
        if ([@"NSString" isEqualToString:dataTypeStr ]) {
             // it has to match the class name in the typemappings
            if(! [value isKindOfClass:[NSString class]] || (! [value canBeConvertedToEncoding:NSASCIIStringEncoding])  ){
                NSException *e = [NSException
                               exceptionWithName:@"InvalidTypeForHandlerException"
                               reason:[NSString stringWithFormat: @"Tag %@ only supports NSString in ASCII format",aTagKey]
                               userInfo:nil];
                @throw e;
             }
        } else if ([@"NSData" isEqualToString:dataTypeStr] ){
            if(! [value isKindOfClass:[NSData class]] ){
                    NSException *e = [NSException
                                      exceptionWithName:@"InvalidTypeForHandlerException"
                                      reason:[NSString stringWithFormat: @"Tag %@ only supports NSData",aTagKey]
                                      userInfo:nil];
                    @throw e;
            }  
        } else if ([@"EXFraction" isEqualToString:dataTypeStr] ){
            if(! [value isKindOfClass:[EXFraction class]] ){
                NSException *e = [NSException
                                  exceptionWithName:@"InvalidTypeForHandlerException"
                                  reason:[NSString stringWithFormat: @"Tag %@ only supports EXFraction",aTagKey]
                                  userInfo:nil];
                @throw e;
            }  
        }else{
            // it can opnly be a number - or an array of numbers
            // Array handling is a bit wierd here - to do in a more elegant manner
            id tempValue = value;
            int i=0;
            
            if ([value isKindOfClass:[NSArray class]]){
                tempValue = [((NSArray*)value) objectAtIndex:i];
                
            } 
            
            while(true){
                    Debug(@"tempvalue class %@",[tempValue class]);
																if (! [tempValue isKindOfClass:[NSNumber class]] ) 
																{
																				NSException *e = [NSException
																																						exceptionWithName:@"InvalidTypeException"
																																						reason:[NSString stringWithFormat: @"Tag %@ supports only numeric types of %@ - unsupported type %@",aTagKey, dataTypeStr, [tempValue class]]
																																						userInfo:nil];
																				@throw e;
																} 
                    if (! [tempValue isKindOfClass:[NSNumber class]]  ||
                        [dataTypeStr rangeOfString:[NSString stringWithFormat:@"%s",[tempValue objCType]]].location == NSNotFound) 
                       {
                        NSException *e = [NSException
                                          exceptionWithName:@"InvalidTypeException"
                                          reason:[NSString stringWithFormat: @"Tag %@ does not support numeric type %c for %@",aTagKey, [tempValue objCType],value]
                                          userInfo:nil];
                        @throw e;
                    } 
                    i++;
               if ([value isKindOfClass:[NSArray class]] && i<[((NSArray*)value) count]){
                   tempValue = [((NSArray*)value) objectAtIndex:i];
               }else{
                   break;
               }
            
           }
                         
        }
             
        
    }
    
    // now add the value - and make sure we add in the right sub dir
    NSMutableDictionary* dictionary =  self.keyedTagValues ;
    
   
    
    if (parentTagId != -1)
    {
    // let dictionary = subdictionary
        NSNumber* parentTagNumber = [[NSNumber alloc] initWithInt:parentTagId]; 
        dictionary = [self.keyedTagValues objectForKey: parentTagNumber];
        if (dictionary == nil){
                 dictionary = [[NSMutableDictionary alloc] init];
                 [self.keyedTagValues setObject:dictionary forKey: parentTagNumber];
                [dictionary release];
                 dictionary = [self.keyedTagValues objectForKey:parentTagNumber];
        }
        [parentTagNumber release];
    }
                 
    // set the value
    [dictionary setObject:value forKey:aTagKey];
}
  


-(void) removeTagValue:(NSNumber*) aTagKey {
    
				
    // get tag definition - may be nil
    EXFTag* tag =  [self.keyedTagDefinitions objectForKey:aTagKey];
    
    int parentTagId = -1;

				if (tag == nil){
								// see if one of the sub tags
								if ([aTagKey intValue] == EXIF_Exif){
								
								Debug(@"Tag %i is not found",tag.tagId);
								NSException *e = [NSException
																										exceptionWithName:@"NonEditableKeyException"
																										reason:[NSString stringWithFormat: @"Tag group %@ cannot be removed", aTagKey]
																										userInfo:nil];
								@throw e;
								}
								
				}else	if (! tag.editable){
								Debug(@"Tag %x is not editiable",tag.tagId);
								NSException *e = [NSException
																										exceptionWithName:@"NonEditableKeyException"
																										reason:@"Tag is not editable"
																										userInfo:nil];
								@throw e;
								
				}
				
				//it is either an editable tag or a gps block
								
				if (tag != nil){
								parentTagId = tag.parentTagId;
				}
				
				// remove the tag
				NSMutableDictionary* dictionary =  self.keyedTagValues ;
    
				
    
    if (parentTagId != -1)
    {
								// let dictionary = subdictionary
        NSNumber* parentTagNumber = [[NSNumber alloc] initWithInt:parentTagId]; 
        dictionary = [self.keyedTagValues objectForKey: parentTagNumber];
        if (dictionary == nil){
												// we can just return as no parent to release
												Debug(@"No Parent tag %@ found for tag %@", parentTagNumber,aTagKey);
        }
        [parentTagNumber release];
    }
				
				// otherwise rmove tag
				[dictionary removeObjectForKey:aTagKey];
			
				//remove the parent if empty
				if ([dictionary count] ==0 && parentTagId != -1){
								[self removeTagValue:[NSNumber numberWithInt:parentTagId]];
				}
				
				
				
				
}
-(NSDictionary*) keyedTagDefinitions{
    return self.tagDefinitions.definitions;  
}






/* End of utility helper methods */

/* start of tag population methods */

-(void) assignElements: (NSMutableDictionary*) keyedValues: (NSNumber*) tag: (id) elements: (UInt32) components{
    if (components > 1){
        [keyedValues setObject: elements forKey: tag];
    }else{
        [keyedValues setObject: [elements objectAtIndex:0] forKey: tag]; 
    }
}

-(void) assignSByte:(NSMutableDictionary*) keyedValues: (NSNumber*) tag: (UInt32) valueOffset: (UInt32) components{

    // have to use byte count for list
    NSMutableArray* elements = [[NSMutableArray alloc] init];
    
    for(int i =0;i<components;i++){
        SInt8 val = exif_ptr[valueOffset];
        // Debug(@"Got Signed byte %i",val);
        // create the byte
        NSNumber* value = [[NSNumber alloc] initWithInt:val];
        valueOffset+=1;
        [elements addObject:value];
        [value release];
    }
    
    [self assignElements:keyedValues :tag :elements :components];
    
    [elements release];

   
    
}

-(void) assignByte:(NSMutableDictionary*) keyedValues: (NSNumber*) tag: (UInt32) valueOffset: (UInt32) components{
    
    // have to use byte count for list
    NSMutableArray* elements = [[NSMutableArray alloc] init];
    
    for(int i =0;i<components;i++){
        
        UInt8 val = exif_ptr[valueOffset];
    // Debug(@"Got byte %i",val);
    
        NSNumber* value = [[NSNumber alloc]  initWithUnsignedInt:val];
    
        valueOffset+=1;
        [elements addObject:value];
        [value release];
    }
    
    // release the val
    [self assignElements:keyedValues :tag :elements :components];
    
    
    [elements release];
    
}

-(void) assignUShort:(NSMutableDictionary*) keyedValues: (NSNumber*) tag: (UInt32) valueOffset: (UInt32) components{
    
    // have to use byte count for list
    NSMutableArray* elements = [[NSMutableArray alloc] init];
    
    for(int i =0;i<components;i++){
        
        UInt8* ptr = exif_ptr+valueOffset;
        UInt16 val = [EXFUtils read2Bytes:&ptr: self.bigEndianOrder];
    // Debug(@"Got U Short %i",val);
        NSNumber* value = [[NSNumber alloc] initWithUnsignedInt:val];
    
        
        valueOffset+=2;
        [elements addObject:value];
        [value release];
    }
    
    // release the val
    [self assignElements:keyedValues :tag :elements :components];
    
    
    [elements release];
}

-(void) assignShort:(NSMutableDictionary*) keyedValues: (NSNumber*) tag: (UInt32) valueOffset: (UInt32) components{
    
    // have to use byte count for list
    NSMutableArray* elements = [[NSMutableArray alloc] init];
    
    for(int i =0;i<components;i++){
        UInt8* ptr = exif_ptr+valueOffset;
        SInt16 val = [EXFUtils read2SignedBytes:&ptr: self.bigEndianOrder];
        // Debug(@"Got U Short %i",val);
        NSNumber* value = [[NSNumber alloc] initWithInt:val];
        
        valueOffset+=2;
        [elements addObject:value];
        [value release];
        
    }    
   
    
    // release the val
    [self assignElements:keyedValues :tag :elements :components];
    
    
    [elements release];
    
}

-(void) assignLong:(NSMutableDictionary*) keyedValues: (NSNumber*) tag: (UInt32) valueOffset: (UInt32) components{
    
    // have to use byte count for list
    NSMutableArray* elements = [[NSMutableArray alloc] init];
    
    for(int i =0;i<components;i++){
   
        
        UInt8* ptr = exif_ptr+valueOffset;
        SInt32 val = [EXFUtils read4SignedBytes:&ptr: self.bigEndianOrder];
        // Debug(@"Got Long %i",val);
    
        NSNumber* value = [[NSNumber alloc] initWithLong:val];
    
        valueOffset+=4;
        [elements addObject:value];
        [value release];
        
    }    
    
    
    // release the val
    [self assignElements:keyedValues :tag :elements :components];
    
    
    [elements release];
}

-(void) assignULong:(NSMutableDictionary*) keyedValues: (NSNumber*) tag: (UInt32) valueOffset: (UInt32) components{
    
    // have to use byte count for list
    NSMutableArray* elements = [[NSMutableArray alloc] init];
    
    for(int i =0;i<components;i++){
        
        UInt8* ptr = exif_ptr+valueOffset;
        UInt32 val = [EXFUtils read4Bytes:&ptr: self.bigEndianOrder];
    // Debug(@"Got U Long %i",val);
    
        NSNumber* value = [[NSNumber alloc] initWithUnsignedLong:val];
    
        valueOffset+=4;
        [elements addObject:value];
        [value release];
        
    }    
    
    
    // release the val
    [self assignElements:keyedValues :tag :elements :components];
    
    
    [elements release];
}

-(void) assignString:(NSMutableDictionary*) keyedValues: (NSNumber*) tag: (UInt32) valueOffset: (UInt32) components{
    UInt8* ptr = exif_ptr+valueOffset;
    NSString* value = [EXFUtils newStringFromBuffer:&ptr: components: NSASCIIStringEncoding];
    // Debug(@"Assigned string %@",value);
    
    [keyedValues setObject: value forKey: tag];
    
    [value release];
    
}

-(void) assignData:(NSMutableDictionary*) keyedValues: (NSNumber*) tag: (UInt32) valueOffset: (UInt32) components{
    UInt8* ptr = exif_ptr+valueOffset;
    NSData* value = [[NSData alloc] initWithBytes:ptr length: components];
    Debug(@"Assigned data block %@",value);
    
    [keyedValues setObject: value forKey: tag];
    
    [value release];
    
}

-(void) assignFraction:(NSMutableDictionary*) keyedValues: (NSNumber*) tag: (UInt32) valueOffset: (UInt32) components{
    
    // have to use byte count for list
    NSMutableArray* elements = [[NSMutableArray alloc] init];
    
    for(int i =0;i<components;i++){
        UInt8* ptr = exif_ptr+valueOffset;
        UInt32 num = [EXFUtils read4Bytes:&ptr: self.bigEndianOrder];
        ptr = exif_ptr+valueOffset+4;
        UInt32 denom = [EXFUtils read4Bytes:&ptr: self.bigEndianOrder];
   
        EXFraction* value = [[EXFraction alloc] initWith:num: denom];
        
        valueOffset+=8;
        [elements addObject:value];
        [value release];
        
    }    
    
    
    // release the val
    [self assignElements:keyedValues :tag :elements :components];
    
    
    [elements release];    
    
}

-(void) assignSignedFraction:(NSMutableDictionary*) keyedValues: (NSNumber*) tag: (UInt32) valueOffset: (UInt32) components{
    
    // have to use byte count for list
    NSMutableArray* elements = [[NSMutableArray alloc] init];
    
    for(int i =0;i<components;i++){
        
        UInt8* ptr = exif_ptr+valueOffset;
        SInt32 num = [EXFUtils read4SignedBytes:&ptr: self.bigEndianOrder];
        ptr = exif_ptr+valueOffset+4;
        SInt32 denom = [EXFUtils read4SignedBytes:&ptr: self.bigEndianOrder];
    
          EXFraction* value = [[EXFraction alloc] initWith:num: denom];
    // Debug(@"Assign signed rational called %@", value);
        valueOffset+=8;
        [elements addObject:value];
        [value release];
        
    }    
    
    
    // release the val
    [self assignElements:keyedValues :tag :elements :components];
    
    
    [elements release];       
    
}

-(void) appendDataFromBytes: (NSMutableData*) data: (NSArray*) bytes{
    UInt8 byte[1];
    for(NSNumber* val in bytes){
        byte[0] = [val intValue] && 0xff;
        [data appendBytes:byte length:1];
    }
}

-(int) processExifDir:(NSMutableDictionary*) keyedValues: (int) dirStart: (int) offsetBase: (BOOL) thumbnail{
     
    // if we have a tag failure it is not safe to get the thumbnail as the offsets could be wrong
    BOOL tagFailure =FALSE;
   
    Debug(@"********** Entering exif processing at offset %i ********",dirStart);
    UInt8* ptr = exif_ptr+dirStart;
    UInt16 numEntries = [EXFUtils read2Bytes:&ptr: self.bigEndianOrder];
    
    // the possible thumbnail offset with no overflow values
    int thumbnailDataCount = dirStart;
    
     Debug(@"Number of entries in block %i", numEntries);
    
    for (int de =0;de <numEntries;de++){
        int dirOffset = dirStart +2 +(12*de);
        
        // count of current processed values
        int processedValueCount = [keyedValues count];
        
        // get the tag id
        ptr = exif_ptr+dirOffset;
        UInt16 tag = [EXFUtils read2Bytes:&ptr: self.bigEndianOrder];
        
        // this is a hack for IPhone - which appears to have an off by one error in the EXIF block
        // this may be a problem in the GPS blok if tag 0 is the last one
        if (tag ==0 && de == numEntries -1){
            numEntries -=1;
            NSLog(@"*** Warning IPhone off by one count - skipping non-existent tag");
            continue;
        }
        
        
        Debug(@"Parsing tag %i at location %i",tag, dirOffset);
              
        // get format
        ptr = exif_ptr + dirOffset +2;
        UInt16 format = [EXFUtils read2Bytes:&ptr: self.bigEndianOrder];
        
        // get number of components
         ptr = exif_ptr + dirOffset +4;
        UInt32 components = [EXFUtils read4Bytes:&ptr: self.bigEndianOrder];
        
        // check format is known
        
        if ((format < FMT_BYTE) ||( format > FMT_DOUBLE)) {
            NSLog(@"*** Warning Unknown format %i for tag %i",format, tag);
            tagFailure =TRUE;
            continue;
	       }
        
        // work out how many bytes we need for format
        UInt32 byteCount = components * bytesPerFormat[format];
        
        // offset to read from if data in tag (default)
        UInt32 valueOffset = dirOffset + 8;
        
        // if more than 4 bytes then must be in overflow - so set the valueOffset to be the location in the overflow
        if (byteCount > 4) {
             ptr = exif_ptr + dirOffset +8;
            UInt32 offsetVal = [EXFUtils read4Bytes:&ptr: self.bigEndianOrder];
            valueOffset = offsetBase + offsetVal;
            Debug(@"Offset %i found for tag %i with bytecount %i",valueOffset, tag,byteCount);
            
        }
        
       // sometimes thumbnail has no tag just runs on end of data - so keep track of where we are in block
       
         if (byteCount <4 && (valueOffset +4 > thumbnailDataCount)){
            thumbnailDataCount = valueOffset + 4;
        }else if (valueOffset + byteCount > thumbnailDataCount){
          thumbnailDataCount = valueOffset + byteCount;   
        }
        
         
        // get a tagNumber object to work with the maps
        NSNumber* tagNumber = [[NSNumber alloc] initWithUnsignedInt:tag];
        
      
        // if this a nested tag type then create a new value map and recurse into this method
        if (tag == TAG_EXIF_OFFSET || tag == TAG_INTEROP_OFFSET || tag == TAG_EXIF_GPS) {
             
            ptr = exif_ptr + valueOffset;
            UInt32 subdirOffset = [EXFUtils read4Bytes:&ptr: self.bigEndianOrder];
            
            
            Debug(@"Nested pointer to %i found for tag %i with bytecount %i",subdirOffset +offsetBase, tag,byteCount);
            
            // create a new sub directory for the tag
            NSMutableDictionary* subDir = [[NSMutableDictionary alloc] init];
            
            // set it into the current directory
            [keyedValues setObject: subDir forKey:tagNumber];
            
            // process the sub dir - ignore the return value as should always be 0
            [self processExifDir:subDir: offsetBase+subdirOffset: offsetBase: FALSE];
            
            // release the map we created
            [subDir release];
         }else{
            
            // see if we have a user handler
            id<EXFTagHandler> handler = [[self userKeyedHandlers] objectForKey:tagNumber];
            
            // if not see if we have a default specific handler
            if (handler == nil){
                handler = [[self keyedHandlers] objectForKey:tagNumber];

            }
            
            // a handler is dealing with this tag
            if (handler != nil){
                Debug(@"Handler %@ invoked for tag %@ invoked with offset %i and byte count %i",handler, tagNumber, valueOffset, byteCount);
                
                
                // create the NSData object to pass to the handler
                NSData* tagData = [NSData dataWithBytes:&self.exif_ptr[valueOffset] length:byteCount];
            
                 
                Debug(@"Retain count for tagData is %i", [tagData retainCount]);
                // try and decode the tag here - catch any errors
                @try {
                                   
                    [handler decodeTag: keyedValues: tagNumber:(CFDataRef*) &tagData: self.bigEndianOrder];
                                   
                }@catch (NSException *theError) {
                                   NSLog(@"Unable to process Tag %i due to error %@", tagNumber,  theError);           
                 
                } 
               
            }else{
                // see if we have a known tag definition
                
                EXFTag* tagDefinition = [self.keyedTagDefinitions objectForKey:tagNumber];
                
                if (tagDefinition == nil){
                    // we should ignore this
                    Debug(@"*** Ignoring unknown tag definition for %@", tagNumber);
                    tagFailure = TRUE;
                    continue;
                }else{
                        switch (format) {
                            case FMT_UNDEFINED:
                                // ignore this for now
                                 Debug(@"Undefined format found for tag %@ treating as NSData", tagNumber);
                                // this gets put in as an nsdata entry
                                [self assignData:keyedValues: tagNumber :valueOffset :components];
                                break;
                            case FMT_STRING:
                                [self assignString:keyedValues: tagNumber :valueOffset :components];
                                
                                break;
                            case FMT_SBYTE:
                                [self assignSByte:keyedValues: tagNumber :valueOffset :components];
                                break;
                            case FMT_BYTE:
                                [self assignByte:keyedValues :tagNumber :valueOffset :components];
                                break;
                            case FMT_USHORT:
                                [self assignUShort:keyedValues: tagNumber :valueOffset :components];
                                break;
                            case FMT_SSHORT:
                                [self assignShort:keyedValues: tagNumber :valueOffset :components];
                                break;
                            case FMT_SLONG:
                                [self assignLong:keyedValues: tagNumber :valueOffset :components];
                                break;
                            case FMT_ULONG:
                                [self assignLong:keyedValues: tagNumber :valueOffset :components];
                                break;
                            case FMT_URATIONAL:
                                [self assignFraction:keyedValues: tagNumber :valueOffset :components];
                                break;
                            case FMT_SRATIONAL:
                                [self assignSignedFraction:keyedValues: tagNumber :valueOffset :components];
                                break;
                           default:
                                 Debug(@"Unexpected format for tag %x", tag);
                                tagFailure =TRUE;
                                break;   
                        } 
                    }
                   
                }

        

        }
        // make sure we release the tag number
        if ([keyedValues count] == processedValueCount){
            tagFailure =TRUE;
            Debug(@"*** Warning No entry added for tag %@", tagNumber);    
        }
        [tagNumber release];
        
       
    }
    

    // now get the offset pointer to thumbnail if any
    int nextIFD =  dirStart +2 +(12*numEntries);
    
    UInt8* nextPtr = exif_ptr + nextIFD;
    UInt32 nextOffset = [EXFUtils read4Bytes:&nextPtr: self.bigEndianOrder] ;

    Debug(@"Next Offset %i at %i",nextOffset, nextIFD);
    
    
    // bit of a hack but needs to be done here as some times we get thumbnail with no tags 
    if(thumbnail){
        long thumbnailStart = 0;
        long thumbnailLength =0;
        
        // get the offset to the data
        NSNumber* jpegOffset = [keyedValues objectForKey : [NSNumber numberWithInt: EXIF_JPEGInterchangeFormat]];
        
        // if we have a tag identifying offset we should be able to get length
        if (jpegOffset != nil){
            // get the length
            NSNumber* jpegLength = [keyedValues objectForKey : [NSNumber numberWithInt: EXIF_JPEGInterchangeFormatLength]];
            
            thumbnailStart = [jpegOffset longValue];
            thumbnailLength = [jpegLength longValue];
            
        }else if (! tagFailure) {
            // tags are missing but we could still work this out - if we have not had a tag Failure
            
             // make sure if we are at the end of thumbnail tags we include overflow 
            if (nextIFD +4 > thumbnailDataCount){
                thumbnailStart = nextIFD +4;
            }else{
                thumbnailStart = thumbnailDataCount;
            }
            thumbnailLength = self.byteLength - thumbnailStart;
        }else if (tagFailure){
            NSLog(@"Tag Failure occurred so unable to calculate if any thumbnail exists");
        }
            
            // see if thubnail data is less than block length - as there may be no thumbnail at all
        if (thumbnailLength >0 && thumbnailStart + thumbnailLength == self.byteLength){
            // looks ok - try and get remaining block as thumbnail
                nextPtr = exif_ptr + thumbnailStart ;
                NSData* thumbnailDataArray = [[NSData alloc] initWithBytes:nextPtr length: thumbnailLength];
                self.thumbnailBytes = thumbnailDataArray;
                [thumbnailDataArray release];                
                
        } else if (thumbnailStart + thumbnailLength > self.byteLength){
                
                Debug(@"*** Thumbnail start of %i and length %i is more than total block length %i", thumbnailStart, thumbnailLength, self.byteLength);
        }else{
                
                Debug(@"*** Thumbnail start of %i and length %i is less than total block length %i", thumbnailStart, thumbnailLength, self.byteLength);
        }
    }
        // if there has not been an offset value 
       
    
      Debug(@"********** Leaving exif processing at %i with nextOffset %i***********",dirStart  , nextOffset);
    return nextOffset;
}

-(void) parseExif: (CFDataRef*) exifData
 {
     
    // get the byte length
     self.byteLength = CFDataGetLength(*exifData);
    
     Debug(@"Length of exif %i", byteLength);
     
     // must be at least 13 bytes
     if (self.byteLength <13){
         NSLog(@"***Warning byte length for EXIF is too short %i must be at least 13 bytes", self.byteLength);
         return;
     }
     
    
    //get the first 4 bytes and make sure they equal the exif chars
    
    
    UInt8 bytes[4];
    CFDataGetBytes(*exifData, CFRangeMake(0,4), bytes);
    
                      // test the start of the EXIF Data
    for (int i=0;i<4;i++){
         if(exifChars[i] != bytes[i]){
             NSLog(@"***Warning 'EXIF' string not present at start of Exif data");
            return;
        }
    }
    
                      
    // skip the next two padding bytes
    
    // get the endian of the bytes
     UInt8 order[2];
     //CFDataGetBytes(*exifData, CFRangeMake(6,8), order);
	 CFDataGetBytes(*exifData, CFRangeMake(6,2), order);

     
     if (M_ORDER == order[0] && M_ORDER == order[1]){
         self.bigEndianOrder =YES;
         Debug(@"Big endian type found for data ");
     }else if (I_ORDER == order[0]&& I_ORDER == order[1]){
         // intel order
         self.bigEndianOrder = NO;
           Debug(@"Little endian type found for data");
     }else{
         // we have an unrecognized type
        NSLog(@"*** Warning Unrecognized endian type %x %x", order[0], order[1]);
        return;
     }
     
                      
     // create initial pointer to start of data
     
     self.exif_ptr = (UInt8*) CFDataGetBytePtr(*exifData);
     
     
    // check header is TIFF header
     UInt8* ptr = exif_ptr +8;
     UInt16 value = [EXFUtils read2Bytes:&ptr:self.bigEndianOrder];
     if ( value != 0x2a) {        
          NSLog(@"*** Warning Not a valid TIFF Header: %x should be 0x2a", value);
         return;
     }
     
     // get the first offset
     ptr = exif_ptr +10;
     UInt32 offset = [EXFUtils read4Bytes:&ptr:self.bigEndianOrder];
                      
     // now process the tag data and get back number of bytes processed
     int thumbnailOffset =  [self processExifDir: self.keyedTagValues: offset+6:6:FALSE];
     
     
     // if we are less than the image size then we need to see if we have a JPEG thumbnail
     if (thumbnailOffset > 0){
         [self processExifDir: self.keyedThumbnailTagValues: thumbnailOffset+6:6:TRUE];
         Debug(@"Got thumbnail data %@", self.keyedThumbnailTagValues);
     }
     
     
    // obviously we need the last 6 here as well
   //  lastOffset+=6;
     Debug(@"Returning from parsing at %i ",thumbnailOffset);
}

/*
Bytes 0-1  Tag 
Bytes 2-3 Type 
Bytes 4-7 Count 
Bytes 8-11 Value Offset 

 */


-(void) writeDataToBuffer: (NSMutableData*) target: (id) obj : (int) dataType: (int) tagByteSize: (UInt8**) bytes{
    
    // Appends data to the NSMutableData buffer depending on type - padding must be done OUTSIDE this method as
    // there is not enough information to deal with array structures
    switch (dataType) {
        case FMT_UNDEFINED:{
                
            if ([obj isKindOfClass:[NSData class]]){
                // assume this is an NSData object
                      [target appendData: (NSData*)obj];
                }else{
                      NSLog(@"Data %@ is not NSData class - populating empty tag data", obj);
                      [target increaseLengthBy:tagByteSize];
                }
            }
            break;
        case FMT_STRING:{
            Debug(@"Writing ASCII String %@ with count of ", obj, tagByteSize);
            const char* cString = [((NSString*)obj) cStringUsingEncoding:NSASCIIStringEncoding];
            [target appendBytes: cString length:tagByteSize];
            
            // seems to be required for examples - check other files
            
          /*  if (tagByteSize >4 && tagByteSize %2!= 0){
                [target increaseLengthBy:1]; 
            }
            */
            }break;
        case FMT_SBYTE:
            [EXFUtils write1SignedByte:bytes :(NSNumber*)obj :self.bigEndianOrder];
            [target appendBytes:*bytes length:1]; 
            break;
            
        case FMT_BYTE:
            [EXFUtils write1Byte:bytes :(NSNumber*)obj :self.bigEndianOrder];
            [target appendBytes:*bytes length:1]; 
            break;
            
        case FMT_USHORT:
            [EXFUtils write2Bytes:bytes :(NSNumber*)obj :self.bigEndianOrder];
            [target appendBytes:*bytes length:2]; 
            break;
        case FMT_SSHORT:
            [EXFUtils write2SignedBytes:bytes :(NSNumber*)obj :self.bigEndianOrder];
            [target appendBytes:*bytes length:2]; 
            break;
        case FMT_SLONG:
            [EXFUtils write4SignedBytes:bytes :(NSNumber*)obj :self.bigEndianOrder];
            [target appendBytes:*bytes length:4]; 
            break;
        case FMT_ULONG:
            [EXFUtils write4Bytes:bytes :(NSNumber*)obj :self.bigEndianOrder];
            [target appendBytes:*bytes length:4]; 
            break;       
            // these can't be 4 or less
        case FMT_URATIONAL:
            [EXFUtils appendFractionToData:target :(EXFraction*) obj :self.bigEndianOrder];
            break;
        case FMT_SRATIONAL:
            [EXFUtils appendFractionToData:target :(EXFraction*) obj :self.bigEndianOrder];
            break;
            
        default:
            Debug(@"Unexpected format for val %@ with tagSize %i", obj, tagByteSize);
            break;   
    } 
    
}


/*
 
 Note: 
 1) Tags which are containers for nested values have no definition
 2) Tags that handlers deal with can have no definition
 3) ALL other tags are expected to have a definition
 
 */
-(void) getDataFromMap: (NSDictionary*) dictionary :(NSMutableArray*) dataWriterArray: (UInt8**) bytes: (int) overflowOffset: (int) offsetBase{ 

    // create a data writer for these tags
    EXFWriter* dataWriter = [[EXFWriter alloc] init];
                    
 
    Debug(@"****** Entering data map at %i", overflowOffset);
    // get the tag keys that we have
    NSArray* allKeys = [dictionary allKeys];
    
    // a placeholder for nested tags that we need to deal with after all the other tags
    NSMutableArray* nestedTags = [[NSMutableArray alloc] init];
    
    // Sort the tags so we do them in ascending order                  
    NSArray *sortedKeysArray =
      [allKeys sortedArrayUsingSelector:@selector(compare:)];
    
    
    // get the size of the key list
    int size = [sortedKeysArray count] ;
    
    
    // the extra plus 4 is where the next ifd for any thumbnail is set
    // if no value then 00000000 pads between blocks 
    int blockCount = (size *12 +2)  +4;
    
    Debug(@"Number of ELements %i and block size of %i",size, blockCount);
   
    // write the number of elements in the first 2 bytes
    [EXFUtils write2Bytes:bytes :[NSNumber numberWithInt:size] :self.bigEndianOrder];
    [dataWriter.tagData appendBytes:*bytes length:2];
    
    // loop through all the elements and add to the current block
   
    for (int de =0;de <size;de++) {
    
        // get the key of the tag
        NSNumber *key = [sortedKeysArray objectAtIndex:de];
  
        // get the value for the key in the value list
        id obj = [dictionary objectForKey:key];
        
        //if it is a dictionary - then record for later as a nested tag block
        if ([obj isKindOfClass:[NSDictionary class]]){
            Debug(@"dictionary found at %@", key);
            [nestedTags addObject:key];
        }else{
            // get the tag definition
            EXFTag* tag = [self.keyedTagDefinitions objectForKey:key];
             
                   
            // number of bytes the tag will occupy - this is not the same as the number of 
            // coponents in the tag          
            int tagComponentSize = 0;
                
            //get the type of data we are writing - default to undefined
            int tagDataType =FMT_UNDEFINED;
                  
            // see if we have a user handler registered first
            id<EXFTagHandler> handler = [[self userKeyedHandlers] objectForKey:key];
                
            // if not see if we have a default handler
            if (handler == nil){
                handler = [[self keyedHandlers] objectForKey:key];    
            }
                
            // get the dynamic tag byte data size from the handler
            if (handler != nil){
                tagComponentSize = [handler getSizeOfValue: obj];
                
                // override the tag type if necessary
                if ([(NSObject*)handler respondsToSelector: @selector(tagFormat)]){
                    tagDataType = [handler tagFormat];
                }else if (tag != nil){
                     tagDataType = tag.dataType;
                }
                    
            }else{
                // set the data type from the tag definition
                tagDataType = tag.dataType;
                
                // now deal with the tags that have arbitrary sizes
                // this must be either NSData or NSString
                if (tag.components <0){
                    // must be size of the data
                    // can be either -1 which is undefined or -99 which is any
                    if ([obj isKindOfClass:[NSData class]]){
                        // this must be a byte length from the data
                        tagComponentSize = [((NSData*)obj) length];
                    } else  if ([obj isKindOfClass:[NSString class]]){
                        // String length is determined by ascii encoding only
                        tagComponentSize = [((NSString*)obj) lengthOfBytesUsingEncoding:NSASCIIStringEncoding];
                        Debug(@"Got String value of %@",obj);
                    }else{
                        // we have a problem here
                        NSLog(@"*** Warning Data in undexpected format for key %@ got format class %@",key, [obj class] );
                            continue;
                        }
                }else{
                    // static types are based on compoenets in tag definition * bytes for each format
                    tagComponentSize = tag.components ;
                }
            }
                
            // now we have tag id/tag size/tag type - we need to get the data byte size
            int tagByteSize = tagComponentSize* bytesPerFormat[tagDataType];

            // if we have a negative tag size we should ignore the tag
            if (tagByteSize <0){
                NSLog(@"*** Warning Unexpected tagsize of %i returned for tag %@ - ignoring tag",tagByteSize, key);
                // we might want to have a dictionary of ignored tags here
            } else{
                // this line tells us where int he final unified block the data will be
                Debug(@"Writing value for key %@ at final location %i",key, [dataWriter.tagData length] + overflowOffset + offsetBase);
                
                // for each tag write the tag id
                [EXFUtils write2Bytes:bytes :key :self.bigEndianOrder];
                // now append this to the writer
                [dataWriter.tagData appendBytes:*bytes length:2];
                
                // write the data type
                [EXFUtils write2Bytes:bytes :[NSNumber numberWithInt: tagDataType] :self.bigEndianOrder];
                [dataWriter.tagData appendBytes:*bytes length:2];
                
                // now write the count
                Debug(@"Writing byte count of %i key %@ ",tagComponentSize, key);
                [EXFUtils write4Bytes:bytes :[NSNumber numberWithInt: tagComponentSize] :self.bigEndianOrder];
                [dataWriter.tagData appendBytes:*bytes length:4]; 
                
                // the target data array is either the block if size is 4 bytes or less or 
                // overflow block if more
                NSMutableData* target = nil;
                
                
                // now set up the data elements to be written
                 if (tagByteSize <=4){
                     target = dataWriter.tagData; 
                 }else{
                    
                     target = dataWriter.overflowData;
                     
                     // write location of the data offset block
                     int temp = blockCount + overflowOffset + [dataWriter.overflowData length];
                     
                     Debug(@"Writing overflow location of %i (%i) for key %@ ",temp,temp+offsetBase, key);
                     
                     [EXFUtils write4Bytes:bytes :[NSNumber numberWithInt: temp] :self.bigEndianOrder];
                     [dataWriter.tagData appendBytes:*bytes length:4]; 
                    
                      Debug(@"Length of tagData %i ",[dataWriter.tagData length]);
                 }
                
                // Now we write the data to the target buffer
                
                if (handler != nil){
                    Debug(@"Encoding with handler for tag %@", key);
                    
                    // We use a temporary buffer here to the user cannot change the real buffer
                    NSMutableData* tagData = [[NSMutableData alloc] init];
                    
                    // encode the data
                    @try {
                      
                        [handler encodeTag:tagData :obj :self.bigEndianOrder];
                      
                    }@catch (NSException *theError) {
                        NSLog(@"***Warning Unable to process Tag %@ due to error %@ - writing empty bytes to tag", key,  theError);            
                    }
                      
                    // the handler returned a different amount than it said
                    if ([tagData length] != tagByteSize){
                        NSLog(@"***Warning Handler %@ returned %i bytes for tag %@ - expected %i. Altering buffer size to projected size", handler, [tagData length],key,tagByteSize);
                        // we should truncate or expand based on the value here
                      [tagData setLength:tagByteSize];
                    } 
                    // pad if we need to
                    if ([tagData length] <4){
                        Debug(@"Tag data less than 4 for tag %@ from handler %@ - padding %i bytes", key, handler, 4 - [tagData length]);
                        [tagData increaseLengthBy: 4 - [tagData length]];
                    }
                    // write the data to the target
                    [target appendData:tagData];
                    // release the temporary buffer
                    [tagData release];
                    
                } else{
                    // if it is an array and undefined then treat as array of bytes
                     if ([obj isKindOfClass:[NSArray class]] && tagDataType == FMT_UNDEFINED){
                         // treat this as a byte array
                         [self appendDataFromBytes:target :(NSArray*)obj];
                    // else we can treat as array of object types
                     }else  if ([obj isKindOfClass:[NSArray class]]){
                        
                        for (id val in ((NSArray*)obj)){
                            [self writeDataToBuffer:target :val :tagDataType :tagByteSize:bytes];
                        }
                         // else it is a single type object - could be an nsdata block though
                    }else{
                        [self writeDataToBuffer:target :obj :tagDataType :tagByteSize:bytes];
                    }
                    // pad if we need to
                    if (tagByteSize <4){
                         [target increaseLengthBy: 4 - tagByteSize];
                    }
                    
                }
                Debug(@"Overflow size of %i", [dataWriter.overflowData length]);

               
                }
                            
                
            }
            
       
       }
    
    // now do the offsets as we should know how big the tag data and the overflow data is
    // note the oustanding nested tags are all fixed size so we do not worry about those yet

    // add the current data writer to the accumulated array
    [dataWriterArray addObject:dataWriter];
         // now do each nested set


 
    int nestedOffset= overflowOffset + blockCount + [dataWriter.overflowData length] ;
    
    for(int i=0;i< [nestedTags count];i++){
        
        NSNumber* key = (NSNumber*) [nestedTags objectAtIndex:i];
        
        
        Debug(@"Writing value for key %@ at location %i",key, [dataWriter.tagData length] + overflowOffset + offsetBase);
        
        // write the nested tag id 
        [EXFUtils write2Bytes:bytes :key :self.bigEndianOrder];
        // now append this to the writer
        [dataWriter.tagData appendBytes:*bytes length:2];
        
        // write the data type
        [EXFUtils write2Bytes:bytes :[NSNumber numberWithInt: FMT_ULONG] :self.bigEndianOrder];
        [dataWriter.tagData appendBytes:*bytes length:2];
        
        // now write the count
        [EXFUtils write4Bytes:bytes :[NSNumber numberWithInt: 1] :self.bigEndianOrder];
        [dataWriter.tagData appendBytes:*bytes length:4];
        
        
        Debug(@"Writing nested tag location of %i (%i) for key %@ ",nestedOffset, nestedOffset +offsetBase, key);
        
        
        [EXFUtils write4Bytes:bytes :[NSNumber numberWithInt: nestedOffset] :self.bigEndianOrder];
        [dataWriter.tagData appendBytes:*bytes length:4];
        
        // now process the nested tag
        [self getDataFromMap:[dictionary objectForKey:key]: dataWriterArray: bytes: nestedOffset: offsetBase];
        
         // release thye current data writer
        EXFWriter* lastWriter = [dataWriterArray lastObject];
        nestedOffset += [lastWriter blockLength] + 4;
        
        // note the counts will be incorrect if there is more than 1 level nesting - fix this up later 

       

    }
    
    [nestedTags release];
    Debug(@"Expected blockCount %i - actual count %i",blockCount,[dataWriter.tagData length]);
    Debug(@"Overflow size is %i",[dataWriter.overflowData length]);
    
    Debug(@"Reporting block count of %i",[dataWriter blockLength]);
    
    [dataWriter release];
    
    //make sure we clean up the tags
   
    Debug(@"****** Leaving data map at %i", overflowOffset);
    
    
}


-(void) getData: (NSMutableData*)imageData {
    //first create the NSData
    // first of all we have to construct a a data holder for the image data
     
    
   
     
    int initialSize = [imageData length];
    

     
    NSMutableArray* dataWriters = [[NSMutableArray alloc] init];
    
    // first set up a byte array to hold the temporary values
    UInt8 bytes[4];
    
    UInt8* ptr = bytes;
    [self getDataFromMap:self.keyedTagValues: dataWriters: &ptr: 8: 6];
      
    // add the first 14 bytes first then
    [imageData appendBytes:self.exif_ptr length:14];
    
    int thumbnailOffsetPointer =0;
    for(int i=0;i<[dataWriters count];i++){
    
        EXFWriter* temp = [dataWriters objectAtIndex:i];

        [imageData appendData:temp.tagData];
        // add back in any thubnail values here
        if (i ==0 && [self.keyedThumbnailTagValues count] >0){
            Debug(@"Current image data %@", imageData);
            // take into account the first 6 chars in the file as a whole
            thumbnailOffsetPointer = [imageData length];
            Debug(@"Got pointer to re-write thumbnail at %i", thumbnailOffsetPointer);
        }
        [imageData increaseLengthBy:4];
        
        [imageData appendData:temp.overflowData];
       
    }
    
    [dataWriters removeAllObjects];
    
    // for each dictionary get the 
    
     //add in the thumbnail - if any
     if (thumbnailOffsetPointer != 0){
         
         [EXFUtils write4Bytes:&ptr :[NSNumber numberWithInt:([imageData length] -initialSize) -6]:TRUE];
         Debug(@"Replacing bytes at %i with thumbnailOffset Pointer %i",thumbnailOffsetPointer,([imageData length] -initialSize)-6);
         [imageData replaceBytesInRange:NSMakeRange(thumbnailOffsetPointer, 4) withBytes:bytes];
         
         Debug(@" Adding  thumbnail Data %@", self.keyedThumbnailTagValues);
         
         [self getDataFromMap:self.keyedThumbnailTagValues: dataWriters: &ptr: 8: 6];
          EXFWriter* temp = [dataWriters objectAtIndex:0];
          
         [imageData appendData:temp.tagData];
         // add back in any thubnail values here
         [imageData increaseLengthBy:4];
         
         [imageData appendData:temp.overflowData];
         if (self.thumbnailBytes != nil){
             Debug(@"Adding %i thumbnail bytes to block",[self.thumbnailBytes length]);
             [imageData appendData:self.thumbnailBytes];
         }else{
             
             Debug(@"No Thumbnail bytes found");
         }
         
    } else{
        
        Debug(@"No thumbnail tags found");
    }
     [dataWriters release];
     
    Debug(@"Got Final data block of size %i", [imageData length] -initialSize);
    // write the size back out
    

    
}

@end
