//
//  Estabelecimento.h
//  MasterGuide
//
//  Created by Juliana Lima on 17/10/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Estabelecimento : NSObject
{
    NSString *estabelecimentoId;
    NSString *idiomaId;
    NSString *categoriaId;
    
    NSMutableArray *endereco;
    NSString *nome;
    NSString *descricao;
    NSString *foto1;
    NSString *foto2;
    NSString *foto3;
    NSString *anuncioPago;
    NSString *email;
    NSString *site;
}

@property (nonatomic, retain) NSString *estabelecimentoId;
@property (nonatomic, retain) NSString *idiomaId;
@property (nonatomic, retain) NSString *categoriaId;

@property (nonatomic, retain) NSMutableArray *endereco;

@property (nonatomic, retain) NSString *nome;
@property (nonatomic, retain) NSString *descricao;
@property (nonatomic, retain) NSString *foto1;
@property (nonatomic, retain) NSString *foto2;
@property (nonatomic, retain) NSString *foto3;
@property (nonatomic, retain) NSString *anuncioPago;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *site;

@end
