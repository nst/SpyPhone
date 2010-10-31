//
//  SPSourceKeyboardTVC.m
//  SpyPhone
//
//  Created by Nicolas Seriot on 11/16/09.
//  Copyright 2009. 
//  Licensed under GPL 2.0 http://www.gnu.org/licenses/gpl-2.0.txt
//

#import "SPSourceKeyboardTVC.h"


@implementation SPSourceKeyboardTVC

- (BOOL)caseInsensitiveString:(NSString *)s startsWithUnichar:(unichar)c {
	if(![s length]) return NO;
	
	unichar c1 = [[s lowercaseString] characterAtIndex:0];
	unichar c2 = [[[NSString stringWithFormat:@"%c", c] lowercaseString] characterAtIndex:0];
	return c1 == c2;
}

- (NSString *)sanitizeString:(NSString *)s {
	NSString *s2 = [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	s2 = [s2 stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
	return [s2 stringByTrimmingCharactersInSet:[NSCharacterSet illegalCharacterSet]];
}

- (NSArray *)wordsInDictionaryCacheFileAtPath:(NSString *)path {
	
	NSData *data = [NSData dataWithContentsOfFile:path];
	if(!data) return nil;
	
	static const int BUFSIZE = 256;
	
	int length = [data length];
	int len = 0;
	int pos = 0;
	NSRange range;
	char buf[BUFSIZE];
	NSString *w = nil;

	NSMutableArray *words = [NSMutableArray array];
	
	while(pos < length) {
		range = NSMakeRange(pos, MIN(BUFSIZE, length-pos));
		[data getBytes:buf range:range];
		len = strlen(buf);
		w = [[NSString alloc] initWithBytes:buf length:len encoding:NSUTF8StringEncoding];
		if([w length]) {
			[words addObject:[self sanitizeString:w]];
		}
		[w release];
		pos += (len + 1);
	}
	
	return words;
}

- (void)loadData {
	if(contentsDictionaries) return;

	NSMutableSet *set = [NSMutableSet set];
	
	NSString *dir = @"/var/mobile/Library/Keyboard/";
	NSError *error = nil;
	NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dir error:&error];
	
	if(dirContents == nil) {
		NSLog(@"-- error: %@", error);
		return;
	}
	
	for(NSString *filePath in dirContents) {
		if(![filePath hasSuffix:@".dat"]) continue;
		NSArray *a = [self wordsInDictionaryCacheFileAtPath:[dir stringByAppendingPathComponent:filePath]];
		if(!a) continue;
		[set addObjectsFromArray:a];
	}
	
	NSArray *words = [[set allObjects] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	
	NSMutableArray *letters = [NSMutableArray array];
	NSMutableArray *letterWords = [[NSMutableArray alloc] init];
	
	NSString *current = nil;
	
	for(NSString *w in words) {
		if([w length] == 0) continue;
		
		NSString *s = [[w substringToIndex:1] lowercaseString];
		
		if([s isEqualToString:current]) {
			// w starts with current letter
			[letterWords addObject:w];
		} else {
			// w start with new letter

			// add previous letterWords to letters
			if(current) {
				[letters addObject:[NSDictionary dictionaryWithObjectsAndKeys:letterWords, current, nil]];
			}
			
			// update current
			current = s;

			// create new letterWords
			[letterWords release];
			letterWords = [[NSMutableArray alloc] init];
			[letterWords addObject:w];
		}
	}
	
	if(!current) current = @"";
	
	[letters addObject:[NSDictionary dictionaryWithObjectsAndKeys:letterWords, current, nil]];
	
	[letterWords release];
	
	self.contentsDictionaries = letters;
}

#pragma mark UITableViewDataSource

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	NSMutableArray *a = [NSMutableArray array];
	for(NSDictionary *d in contentsDictionaries) {
		[a addObject:[[d allKeys] lastObject]];
	}
	return a;
}

@end
