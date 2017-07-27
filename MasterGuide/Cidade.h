//
//  Cidade.h
//  MasterGuide
//
//  Created by Juliana Lima on 24/10/12.
//  Copyright (c) 2012 Flip Digital. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cidade : NSObject
{
    NSString *cidadeID;
    NSString *idiomaID;
    NSString *estadoID;
    
    NSString *nome;
    NSString *descricao;
    NSString *foto1;
    NSString *foto2;
    NSString *foto3;
    
}
@property (nonatomic, strong) NSString *cidadeID;
@property (nonatomic, strong) NSString *idiomaID;
@property (nonatomic, strong) NSString *estadoID;

@property (nonatomic, strong) NSString *nome;
@property (nonatomic, strong) NSString *descricao;
@property (nonatomic, strong) NSString *foto1;
@property (nonatomic, strong) NSString *foto2;
@property (nonatomic, strong) NSString *foto3;

@end
