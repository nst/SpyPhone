//
//  EXFTagDefinition.h
//  iphone-test
//
//  Created by steve woodcock on 26/03/2008.
//  Copyright 2008 __MyCompanyName__. 
//  Licensed under GPL 2.0 http://www.gnu.org/licenses/gpl-2.0.txt
//

#import "EXFConstants.h"

@interface EXFTagDefinitionHolder :NSObject {

NSMutableDictionary* definitions;
}
 
@property (readwrite, retain) NSDictionary* definitions;

-(void) addTagDefinition: (EXFTag*) aTagDefinition forKey: (NSNumber*) aTagKey;

@end



