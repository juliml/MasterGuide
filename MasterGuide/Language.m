//
//  Language.m
//  TesteIntercionalizacao
//
//  Created by Juliana on 24/09/12.
//  Copyright (c) 2012 Juliana. All rights reserved.
//

#import "Language.h"

@implementation Language

static NSBundle *bundle = nil;

+(void)initialize {
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
	NSArray* languages = [defs objectForKey:@"AppleLanguages"];
	NSString *current = [languages objectAtIndex:0];
	[self setLanguage:current];
    
}

/*
 example calls:
 [Language setLanguage:@"it"];
 [Language setLanguage:@"de"];
 */
+(void)setLanguage:(NSString *)l {
    NSLog(@"preferredLang: %@", l);
    NSString *path = [[ NSBundle mainBundle ] pathForResource:l ofType:@"lproj" ];
    bundle = [NSBundle bundleWithPath:path];
}

+(NSString *)get:(NSString *)key alter:(NSString *)alternate {
    return [bundle localizedStringForKey:key value:alternate table:nil];
}

@end
