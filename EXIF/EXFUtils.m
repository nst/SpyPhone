//
//  EXFUtils.m
//  iphone-test
//
//  Created by steve woodcock on 30/03/2008.
//  Copyright 2008 __MyCompanyName__. 
//  Licensed under GPL 2.0 http://www.gnu.org/licenses/gpl-2.0.txt
//

#import "EXFUtils.h"
#import "EXFConstants.h"

@implementation EXFUtils

/* Start of utility helper methods */
+(UInt32) read4Bytes:(UInt8**) bytePtr: (BOOL) bigEndianOrder
{
    UInt8* ptr = *bytePtr;
    UInt32 val =0;
	if (bigEndianOrder)
		val= ((ptr[0] << 24) | (ptr[1] << 16) | (ptr[2] << 8) | ptr[3]);
	else
		val = ((ptr[3] << 24) | (ptr[2] << 16) | (ptr[1] << 8) | ptr[0]);
    return val;
}



+(SInt32) read4SignedBytes:(UInt8**) bytePtr: (BOOL) bigEndianOrder
{
    UInt8* ptr = *bytePtr;
    SInt32 val =0;
	if (bigEndianOrder)
		val= ((ptr[0] << 24) | (ptr[1] << 16) | (ptr[2] << 8) | ptr[3]);
	else
		val = ((ptr[3] << 24) | (ptr[2] << 16) | (ptr[1] << 8) | ptr[0]);
    return val;
}



+(UInt16) read2Bytes:(UInt8**) bytePtr: (BOOL) bigEndianOrder
{
     UInt8* ptr = *bytePtr;
    UInt16 val =0;
    
	if (bigEndianOrder){
     
		val = ((ptr[0] << 8) | ptr[1]);
	}else{
		val =((ptr[1] << 8) | ptr[0]);
    }
    return val;
}

+(SInt16) read2SignedBytes:(UInt8**) bytePtr: (BOOL) bigEndianOrder
{
     UInt8* ptr = *bytePtr;
    SInt16 val =0;
    
	if (bigEndianOrder){
		val = ((ptr[0] << 8) | ptr[1]);
	}else{
		val =((ptr[1] << 8) | ptr[0]);
    }
    return val;
}


+(void) write4Bytes:(UInt8**) bytePtr: (id) value: (BOOL) bigEndianOrder{
    UInt32 val = [((NSNumber*)value) unsignedLongValue];
    
    UInt8* ptr = *bytePtr;
    
	if (bigEndianOrder){
        ptr[0] = (UInt8) (val >> 24);
        ptr[1] = (UInt8) ( val >> 16);
        ptr[2] = (UInt8) (val >> 8);
        ptr[3] = (UInt8) (val);
        }
	else{
		ptr[3] = (UInt8) (val >> 24);
        ptr[2] = (UInt8) (val >> 16);
        ptr[1] = (UInt8) (val >> 8);
        ptr[0] = (UInt8) (val );
        }
    }

+(void) write4SignedBytes:(UInt8**) bytePtr: (id) value: (BOOL) bigEndianOrder{
    SInt32 val = [((NSNumber*)value) longValue];
    
    UInt8* ptr = *bytePtr;
    
    if (bigEndianOrder){
        ptr[0] = (UInt8) (val >> 24);
        ptr[1] = (UInt8) (val >> 16);
        ptr[2] = (UInt8) (val >> 8);
        ptr[3] = (UInt8) (val & 0xff);
    }
	else{
    ptr[3] = (UInt8) (val >> 24);
    ptr[2] = (UInt8) (val >> 16);
    ptr[1] = (UInt8) (val >> 8);
    ptr[0] = (UInt8) (val & 0xff);
        }

    
    }

+(void) write2Bytes:(UInt8**) bytePtr: (id) value:(BOOL) bigEndianOrder{
    UInt16 val = [((NSNumber*)value) unsignedIntValue];
    
    UInt8* ptr = *bytePtr;
    if (bigEndianOrder){
        ptr[0] = (UInt8) (val >> 8);
        ptr[1] = (UInt8) (val & 0xff);
        ptr[2] = ptr[3] =0;
    }
	else{
        ptr[1] = (UInt8) (val >> 8);
        ptr[0] = (UInt8) (val & 0xff);
        ptr[2] = ptr[3] =0;
    }
    
    }

+(void) write1Byte:(UInt8**) bytePtr: (id) value:(BOOL) bigEndianOrder{
    UInt16 val = [((NSNumber*)value) unsignedCharValue];
    
    UInt8* ptr = *bytePtr;

        ptr[0] = (UInt8) (val & 0xff);
        ptr[1] = ptr[2] = ptr[3] =0;
   
    
}

+(void) write1SignedByte:(UInt8**) bytePtr: (id) value:(BOOL) bigEndianOrder{
    UInt16 val = [((NSNumber*)value) intValue];
    
    UInt8* ptr = *bytePtr;
    
    ptr[0] = (UInt8) (val & 0xff);
    ptr[1] = ptr[2] = ptr[3] =0;
    
    
}

+(void) write2SignedBytes:(UInt8**) bytePtr: (id) value: (BOOL) bigEndianOrder{
    SInt16 val = [((NSNumber*)value) intValue];
    UInt8* ptr = *bytePtr;
    
    if (bigEndianOrder){
        ptr[0] = (UInt8) (val >> 8);
        ptr[1] = (UInt8) (val & 0xff);
        ptr[2] = ptr[3] =0;
    }
	else{
        ptr[1] = (UInt8) (val >> 8);
        ptr[0] = (UInt8) (val & 0xff);
        ptr[2] = ptr[3] =0;
    }
    
}

+(NSString*)newStringFromBuffer:(UInt8**) ptr: (UInt32) byteCount: (NSStringEncoding) encoding{
    
    NSString* result =   [[NSString alloc] initWithBytes:*ptr length:byteCount encoding:encoding];
    // Debug(@"Created string %@", result);
    return result;                          
}

+(void) appendRationalToData:( NSMutableData*) target: (NSNumber*) rational: (BOOL) bigEndianOrder {
   
    UInt8* bytes[4];
    UInt8* bytePtr = (UInt8*)bytes;
    
    long temp[2] = {0.0L, 0.0L};
    long* ptr = temp;
    [EXFUtils convertRationalToFraction:&ptr :rational];
    
    [EXFUtils write4Bytes:&bytePtr :[NSNumber numberWithLong:temp[0]] :bigEndianOrder];
    [target appendBytes:bytePtr length:4]; 
    
    [EXFUtils write4Bytes:&bytePtr :[NSNumber numberWithLong:temp[1]] :bigEndianOrder];
    [target appendBytes:bytePtr length:4];    
    }
    
+(void) appendFractionToData:( NSMutableData*) target: (EXFraction*) fraction: (BOOL) bigEndianOrder {
    
    UInt8* bytes[4];
    UInt8* bytePtr = (UInt8*)bytes;
    
    
    [EXFUtils write4Bytes:&bytePtr :[NSNumber numberWithLong:fraction.numerator] :bigEndianOrder];
    [target appendBytes:bytePtr length:4]; 
    
    [EXFUtils write4Bytes:&bytePtr :[NSNumber numberWithLong:fraction.denominator] :bigEndianOrder];
    [target appendBytes:bytePtr length:4];    
}

+(long) ofr_gcd_euclid:  (long) n:  (long) m
{
    /*
     Finds greatest divisor, d, of n and m:   n%d==0, m%d==0
     Restate that as:  n=n'*d, m=m'*d for some n', m',d; find d
     Note that if you have any numbers q,r such that q*m+r=n, then q*m+r=n'd --> r=(n'-q*m')d
     */
    
    if (n < m) {
        long t = n;
        n = m;
        m = t;
    }
    for(;;) {
      //  assert (n >= m);
        long r = n % m;
        if (r == 0)
            return m;  /* n is a multiple of m */
        n = m;
        m = r;
    }
}



+(void) convertRationalToFraction: (long**) numDenumArray: (NSNumber*) rational{
    
    // see how many digits there are
    double originalNumber = [rational doubleValue];
    double number = originalNumber;
    BOOL negative = FALSE;
    long long den =0;
    long long num =0;
    
    long* ptr = *numDenumArray;
    
    long long count =1;
    
    if (number <0){
        negative = TRUE;
       
    }
    
         
    // we should now have number / thousands
    // now work out gcd;
           
    if (number == 0) {
        // set denominator to 1 to prevent divide by 0 issues
        den =1;
    } else if (number ==1){
        // set all to 1
        den= num = 1;
    } else{
        // count the number of digits
        while (number != ((long long)number)){
               number *=10;
               count*=10;
            // overflow - restrict to 9 decimal places
                if (number <0 || count >=10000000){
                    count =1000000;
                    number = (long long)(originalNumber * count);
                    break;
                    }
               }
        long gcd =  [EXFUtils ofr_gcd_euclid: number:  count];
               num = number/gcd;
               den = count/gcd;
    }
    
    if (negative){
        num = abs(num);
    }
    ptr[0]	= num;
    ptr[1] = den;
     
}
 

@end
