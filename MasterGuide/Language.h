//
//  Language.h
//  TesteIntercionalizacao
//
//  Created by Juliana on 24/09/12.
//  Copyright (c) 2012 Juliana. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Language : NSObject

+(void)initialize;
+(void)setLanguage:(NSString *)l;
+(NSString *)get:(NSString *)key alter:(NSString *)alternate;

@end
