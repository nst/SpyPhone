/*
 *  EXFUtils.h
 *  iphoneGeo
 *
 *  Created by steve woodcock on 23/03/2008.
 *  Copyright 2008. 
//  Licensed under GPL 2.0 http://www.gnu.org/licenses/gpl-2.0.txt
 *
 * Static helper methods to deal with byte array read/write and big endian/little endian ordering
 */

#import "EXFConstants.h"


@interface EXFUtils : NSObject {
 
}

+(UInt32) read4Bytes:(UInt8**) bytePtr: (BOOL) bigEndianOrder;
+(SInt32) read4SignedBytes:(UInt8**) bytePtr: (BOOL) bigEndianOrder;
+(UInt16) read2Bytes:(UInt8**) bytePtr: (BOOL) bigEndianOrder;
+(SInt16) read2SignedBytes:(UInt8**) bytePtr: (BOOL) bigEndianOrder;

+(void) write1Byte:(UInt8**) bytePtr: (id) value:(BOOL) bigEndianOrder;
+(void) write1SignedByte:(UInt8**) bytePtr: (id) value:(BOOL) bigEndianOrder;
+(void) write4Bytes:(UInt8**) bytePtr: (id) value: (BOOL) bigEndianOrder;
+(void) write4SignedBytes:(UInt8**) bytePtr: (id) value: (BOOL) bigEndianOrder;
+(void) write2Bytes:(UInt8**) bytePtr: (id) value:(BOOL) bigEndianOrder;
+(void) write2SignedBytes:(UInt8**) bytePtr: (id) value: (BOOL) bigEndianOrder;

+(NSString*)newStringFromBuffer:(UInt8**) ptr: (UInt32) byteCount: (NSStringEncoding) encoding;


+(void) appendRationalToData:( NSMutableData*) target: (NSNumber*) rational: (BOOL) bigEndianOrder;
+(void) appendFractionToData:( NSMutableData*) target: (EXFraction*) fraction: (BOOL) bigEndianOrder;

+(void) convertRationalToFraction: (long**) numDenumArray: (NSNumber*) rational;


@end
