//
//  Materia.h
//  MasterGuide
//
//  Created by Juliana Lima on 20/10/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Materia : NSObject
{
    NSString *titulo;
    NSString *texto;
    NSString *foto;
    NSString *site;
    
    NSString *especial;
    NSString *fotoEspecial;
    
    NSString *idiomaId;
}

@property (nonatomic, retain) NSString *titulo;
@property (nonatomic, retain) NSString *texto;
@property (nonatomic, retain) NSString *foto;
@property (nonatomic, retain) NSString *site;
@property (nonatomic, retain) NSString *idiomaId;

@property (nonatomic, retain) NSString *especial;
@property (nonatomic, retain) NSString *fotoEspecial;

@end
