//
//  Endereco.h
//  MasterGuide
//
//  Created by Juliana Lima on 17/10/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Endereco : NSObject
{
    NSString *endereco;
    NSString *numero;
    NSString *complemento;
    NSString *bairro;
    NSString *cidade;
    NSString *estado;
    NSString *cep;
    
    NSString *estadoID;
    NSString *cidadeID;
    
    NSMutableArray *telefones;
    
}

@property (nonatomic, retain) NSString *endereco;
@property (nonatomic, retain) NSString *numero;
@property (nonatomic, retain) NSString *complemento;
@property (nonatomic, retain) NSString *bairro;
@property (nonatomic, retain) NSString *cidade;
@property (nonatomic, retain) NSString *estado;
@property (nonatomic, retain) NSString *cep;
@property (nonatomic, retain) NSMutableArray *telefones;

@property (nonatomic, retain) NSString *estadoID;
@property (nonatomic, retain) NSString *cidadeID;

@end