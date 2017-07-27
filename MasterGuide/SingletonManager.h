//
//  SingletonManager.h
//  DoeSuaEnergia
//
//  Created by Juliana Lima on 18/11/13.
//  Copyright (c) 2013 Ampla. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingletonManager : NSObject
{
	NSString *id_usu;
	NSString *nome_usu;
	UIImage *image_usu;
	
	UIImage *thumb_usu;
	
}
@property(strong, nonatomic) NSString *id_usu;
@property(strong, nonatomic) NSString *nome_usu;
@property(strong, nonatomic) UIImage *image_usu;
@property(strong, nonatomic) UIImage *thumb_usu;

- (BOOL) checkConexaoInternet;
- (UIImage *)convertToGreyscale:(UIImage *)i;

+ (SingletonManager *)sharedController;

@end
