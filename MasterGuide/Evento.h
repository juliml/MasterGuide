//
//  Evento.h
//  MasterGuide
//
//  Created by Juliana Lima on 20/10/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Evento : NSObject
{
    NSString *eventoID;
    NSString *titulo;
    NSString *descricao;
    NSString *since1970;
    NSString *endereco;
	NSString *imagem;
    
    NSString *idiomaId;
}
@property (nonatomic, retain) NSString *eventoID;
@property (nonatomic, retain) NSString *titulo;
@property (nonatomic, retain) NSString *descricao;
@property (nonatomic, retain) NSString *since1970;
@property (nonatomic, retain) NSString *idiomaId;
@property (nonatomic, retain) NSString *endereco;
@property (nonatomic, retain) NSString *imagem;

@end
