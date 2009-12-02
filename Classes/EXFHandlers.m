//
//  EXFHandlers.m
//  iphone-test
//
//  Created by steve woodcock on 30/03/2008.
//  Copyright 2008 __MyCompanyName__. 
//  Licensed under GPL 2.0 http://www.gnu.org/licenses/gpl-2.0.txt
//

#import "EXFHandlers.h"
#import "EXFUtils.h"
#import "EXFGPS.h"
#import "EXFConstants.h"



// character set start byte for for text tags
const UInt8 ASCIIChars[8] = {0x41,0x53,0x43,0x49,0x49,0x00,0x00,0x00};
const UInt8 JISChars[8] =   {0x4a,0x49,0x53,0x00,0x00,0x0,0x00,0x00};
const UInt8 UNIChars[8] =  {0x55,0x4e,0x49,0x43,0x4f,0x44,0x45,0x00};

@implementation EXFGPSLocationHandler

-(void)decodeTag:(NSMutableDictionary*) keyedValues: (NSNumber*) tagId: (CFDataRef*) tagData: (BOOL) bigEndianOrder{
    
    UInt8* ptr = (UInt8*) CFDataGetBytePtr(*tagData);
    
    // Debug(@"In timestamp method for %x",tag);
    // we first need to get the hours
    
    UInt32 num = [EXFUtils read4Bytes:&ptr:bigEndianOrder];
    
    ptr +=4;
    UInt32 denom =  [EXFUtils read4Bytes:&ptr:bigEndianOrder];
    
    EXFGPSLoc* location = [[EXFGPSLoc alloc] init];
    
    EXFraction* value = [[EXFraction alloc] initWith:num :denom];
    location.degrees =value;
    [value release];
    
    // Debug(@"Got hours num %i nad denom %i", num, denom);
    
    ptr +=4;
    
    num = [EXFUtils read4Bytes:&ptr:bigEndianOrder];
    ptr+=4;
    denom = [EXFUtils read4Bytes:&ptr:bigEndianOrder];
    
    value = [[EXFraction alloc] initWith:num :denom];
    location.minutes =value;
    [value release];
    
    // Debug(@"Got minutes num %i and denom %i", num, denom);
    
    
    //  get seconds
    ptr+=4;
    num = [EXFUtils read4Bytes:&ptr:bigEndianOrder];
    ptr+=4;
    denom = [EXFUtils read4Bytes:&ptr:bigEndianOrder];
    // Debug(@"Got seconds num %i and denom %i", num, denom);
    value = [[EXFraction alloc] initWith:num :denom];
    location.seconds =value;
    [value release];
    
    // Debug(@"Got Timestamp %@ Degrees %@ Minutes %@ Seconds",timestamp.degrees , timestamp.minutes,timestamp.seconds);
    [keyedValues setObject: location forKey: tagId];
    
    [location release];
     

}


-(void)encodeTag: (NSMutableData*) targetBuffer: (id) tagData:(BOOL) bigEndianOrder{
    // tag data is an array of NSNumber
    EXFGPSLoc* loc = (EXFGPSLoc*)tagData;
    
    
    [EXFUtils appendFractionToData:targetBuffer :loc.degrees :bigEndianOrder];
    
    [EXFUtils appendFractionToData:targetBuffer :loc.minutes :bigEndianOrder];
    [EXFUtils appendFractionToData:targetBuffer :loc.seconds :bigEndianOrder];
    
    
    
}

-(BOOL)supportsValueType:(id) value{

    if ([value isKindOfClass:[EXFGPSLoc class]]){
        return TRUE;
    }else{
        return FALSE;
    }
}

-(int) getSizeOfValue:(id)value{
    // value should be a GPS Loc
    return 3;
}

-(NSString*) description{
        return @"GPSLocation Handler";
}
@end


@implementation EXFGPSTimeHandler 

-(void)decodeTag:(NSMutableDictionary*) keyedValues: (NSNumber*) tagId: (CFDataRef*) tagData: (BOOL) bigEndianOrder{
    
    UInt8* ptr = (UInt8*) CFDataGetBytePtr(*tagData);
    
    // Debug(@"In timestamp method for %x",tag);
    // we first need to get the hours
    
    UInt32 num = [EXFUtils read4Bytes:&ptr:bigEndianOrder];
    
    ptr +=4;
    UInt32 denom =  [EXFUtils read4Bytes:&ptr:bigEndianOrder];
    
    EXFGPSTimeStamp* timestamp = [[EXFGPSTimeStamp alloc] init];
    
    EXFraction* value = [[EXFraction alloc] initWith:num :denom];
   
    timestamp.hours =value;
    [value release];
    
    // Debug(@"Got hours num %i nad denom %i", num, denom);
    
    ptr +=4;
    
    num = [EXFUtils read4Bytes:&ptr:bigEndianOrder];
    ptr+=4;
    denom = [EXFUtils read4Bytes:&ptr:bigEndianOrder];
    
    value =  [[EXFraction alloc] initWith:num :denom];
    timestamp.minutes =value;
    [value release];
    
    // Debug(@"Got minutes num %i and denom %i", num, denom);
    
    
    //  get seconds
    ptr+=4;
    num = [EXFUtils read4Bytes:&ptr:bigEndianOrder];
    ptr+=4;
    denom = [EXFUtils read4Bytes:&ptr:bigEndianOrder];
    // Debug(@"Got seconds num %i and denom %i", num, denom);
    value =  [[EXFraction alloc] initWith:num :denom];
    timestamp.seconds =value;
    [value release];
    
    // Debug(@"Got Timestamp %@ Degrees %@ Minutes %@ Seconds",timestamp.degrees , timestamp.minutes,timestamp.seconds);
    [keyedValues setObject: timestamp forKey: tagId];
    
    [timestamp release];
    
    
}

-(void)encodeTag: (NSMutableData*) targetBuffer: (id) tagData:(BOOL) bigEndianOrder{
    // tag data is an array of NSNumber
    EXFGPSTimeStamp* time = (EXFGPSTimeStamp*)tagData;
    

    [EXFUtils appendFractionToData:targetBuffer :time.hours :bigEndianOrder];
    
    [EXFUtils appendFractionToData:targetBuffer :time.minutes :bigEndianOrder];
    [EXFUtils appendFractionToData:targetBuffer :time.seconds :bigEndianOrder];
       
    
    
}

-(BOOL)supportsValueType:(id) value{
    
    if ([value isKindOfClass:[EXFGPSTimeStamp class]]){
        return TRUE;
    }else{
        return FALSE;
    }
}

-(int) getSizeOfValue:(id)value{
    // value should be a GPS Time
    return 3;
}

-(NSString*) description{
    return @"GPSTime Handler";
}

@end


@implementation EXFTextHandler


-(void)decodeTag:(NSMutableDictionary*) keyedValues: (NSNumber*) tagId: (CFDataRef*) tagData: (BOOL) bigEndianOrder{
    
    
    // get the first 8 bytes to see the char set
    // Debug(@"offset %i" ,valueOffset);
    UInt8* ptr = (UInt8*) CFDataGetBytePtr(*tagData);
    
    CFIndex length = CFDataGetLength(*tagData);
    
    if (length <9){
        return;    
    }
    
    UInt8 bytes[8];
    for(int i=0;i<8;i++){
        bytes[i]=ptr[i];
    }

    // Debug(@"got bytes %x,%x,%x,%x,%x,%x,%x,%x", bytes[0],bytes[1],bytes[2],bytes[3],bytes[4],bytes[5],bytes[6],bytes[7]);
    
    NSStringEncoding encoding = NSASCIIStringEncoding;
    
    if (bytes[0] == 0x0 && bytes[1] == 0x0 && bytes[2] == 0x0 &&  bytes[3] == 0x0 && bytes[4] == 0x0 && 
        bytes[5] == 0x0 && bytes[6] == 0x0 && bytes[7] == 0x0  ){
        // Debug(@"Undefined charset here");
        // we can try ascii here
         
        
    }else if (bytes[0] == JISChars[0] && bytes[1] == JISChars[1] && bytes[2] == JISChars[2] ){
        encoding = NSShiftJISStringEncoding;
        // Debug(@"JIF charset here");
    }else if (bytes[0] == UNIChars[0] && bytes[1] == UNIChars[1] && bytes[2] == UNIChars[2] && bytes[3] == UNIChars[3] && 
              bytes[4] == UNIChars[4] && bytes[5] == UNIChars[5] && bytes[6] == UNIChars[6] ){
        encoding = NSUnicodeStringEncoding;
        // Debug(@"Unicode charset");
    } else{
        // Debug(@"Unknown charset %x,%x,%x,%x,%x,%x,%x,%x", bytes[0],bytes[1],bytes[2],bytes[3],bytes[4],bytes[5],bytes[6],bytes[7]);
        encoding = 0;
    }
    // now try and create the string
    if (encoding != 0){
        UInt8* start_ptr = ptr+8;
        NSString* string =[EXFUtils newStringFromBuffer:&start_ptr: length-8:encoding];
        // Debug(@"Got String in text field %@", string);
        [keyedValues setObject: string forKey: tagId];
        
        [string release];
    
    }
    
    
    
}

-(void)encodeTag: (NSMutableData*) targetBuffer: (id) tagData:(BOOL) bigEndianOrder{
    // tag data is an array of NSNumber
    int length = [((NSString*)tagData) lengthOfBytesUsingEncoding:NSASCIIStringEncoding];
    const char* cString = [((NSString*)tagData) cStringUsingEncoding:NSASCIIStringEncoding];
    [targetBuffer appendBytes:ASCIIChars length:8];
    [targetBuffer appendBytes: cString length:length];
    
    
}
-(BOOL)supportsValueType:(id) value{
    
    if ([value isKindOfClass:[NSString class]]){
        return TRUE;
    }else{
        return FALSE;
    }
}

-(int) getSizeOfValue:(id)value{
    // value should be a GPS Loc
    if ([value isKindOfClass:[NSString class]]){
        
        return[((NSString*)value) lengthOfBytesUsingEncoding:NSASCIIStringEncoding] +8;
    }
    return -1;
    
}

-(NSString*) description{
    return @"EXF Text Handler";
}

@end

@implementation EXFASCIIHandler

-(void)decodeTag:(NSMutableDictionary*) keyedValues: (NSNumber*) tagId: (CFDataRef*) tagData: (BOOL) bigEndianOrder{
    
    UInt8* ptr = (UInt8*) CFDataGetBytePtr(*tagData);
    CFIndex byteLength = CFDataGetLength(*tagData);
    NSString* value = [EXFUtils newStringFromBuffer:&ptr: byteLength: NSASCIIStringEncoding];
    // Debug(@"Assigned string %@",value);
    
    [keyedValues setObject: value forKey: tagId];
    
    [value release];
    
}

-(void)encodeTag: (NSMutableData*) targetBuffer: (id) tagData:(BOOL) bigEndianOrder{
    // tag data is an array of NSNumber
    int length = [((NSString*)tagData) lengthOfBytesUsingEncoding:NSASCIIStringEncoding];
    const char* cString = [((NSString*)tagData) cStringUsingEncoding:NSASCIIStringEncoding];
    [targetBuffer appendBytes: cString length:length];
    
    
}

-(BOOL)supportsValueType:(id) value{
    
    if ([value isMemberOfClass:[NSString class]]){
        return TRUE;
    }else{
        return FALSE;
    }
}

-(int) getSizeOfValue:(id)value{
    // value should be a GPS Loc
    if ([value isKindOfClass:[NSString class]]){
        
        return[((NSString*)value) lengthOfBytesUsingEncoding:NSASCIIStringEncoding];
    }else{
        return -1;
    }
}

-(NSString*) description{
    return @"EXF ASCII Handler";
}
@end

@implementation EXFByteHandler

-(void)decodeTag:(NSMutableDictionary*) keyedValues: (NSNumber*) tagId: (CFDataRef*) tagData: (BOOL) bigEndianOrder{
    
    UInt8* ptr = (UInt8*) CFDataGetBytePtr(*tagData);
    NSNumber* num = [[NSNumber alloc] initWithInt: (*ptr) & 0xff] ;
    [keyedValues setObject: num forKey: tagId];
    
    [num release];
}

-(void)encodeTag: (NSMutableData*) targetBuffer: (id) tagData:(BOOL) bigEndianOrder{
    // tag data is an array of NSNumber
    UInt8 byte[1];
    
        byte[0] = (UInt8) [((NSNumber*) tagData) intValue];
        [targetBuffer appendBytes:byte length:1];
    
    
}

-(BOOL)supportsValueType:(id) value{
    
    if ([value isKindOfClass:[NSNumber class]]){
        return TRUE;
    }else{
        return FALSE;
    }
}

-(int) getSizeOfValue:(id)value{
    // value should be a GPS Loc
    if ([value isKindOfClass:[NSNumber class]]){
        
        return 1;
    }else{
        return -1;
    }
}

-(NSString*) description{
    return @"EXF Byte Handler";
}
@end

@implementation EXFByteArrayHandler

-(void)decodeTag:(NSMutableDictionary*) keyedValues: (NSNumber*) tagId: (CFDataRef*) tagData: (BOOL) bigEndianOrder{
    
    UInt8* ptr = (UInt8*) CFDataGetBytePtr(*tagData);
    CFIndex byteLength = CFDataGetLength(*tagData);
    NSMutableArray* byteArray = [[NSMutableArray alloc] init];
    
    for (int i =0;i<byteLength;i++){
        NSNumber* num = [[NSNumber alloc] initWithInt: (*(ptr+i)) & 0xff] ;
        [byteArray addObject: num];
        [num release];
    }
    // Debug(@"Assigned string %@",value);
    
    [keyedValues setObject: byteArray forKey: tagId];
    
    [byteArray release];
    
}

-(void)encodeTag: (NSMutableData*) targetBuffer: (id) tagData:(BOOL) bigEndianOrder{
    // tag data is an array of NSNumber
    UInt8 byte[1];
    for(NSNumber* val in ((NSArray*)tagData)){
        byte[0] =(UInt8) [val intValue];
        [targetBuffer appendBytes:byte length:1];
    }
    
}

-(BOOL)supportsValueType:(id) value{
    
    if ([value isKindOfClass:[NSArray class]]){
        return TRUE;
    }else{
        return FALSE;
    }
}

-(int) getSizeOfValue:(id)value{
    // value should be an array
    if ([value isKindOfClass:[NSArray class]]){
        
        return [((NSArray*)value) count];
    }else{
        return -1;
    }
}

-(NSString*) description{
    return @"EXF Byte Array Handler";
}
@end
