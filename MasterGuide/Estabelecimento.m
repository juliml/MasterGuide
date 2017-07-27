//
//  Estabelecimento.m
//  MasterGuide
//
//  Created by Juliana Lima on 17/10/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import "Estabelecimento.h"

@implementation Estabelecimento
@synthesize estabelecimentoId, idiomaId, categoriaId, endereco, nome, descricao, foto1, foto2, foto3, anuncioPago, email, site;

- (id)init
{
    if ((self = [super init]))
    {

    }
    return self;
}

@end
