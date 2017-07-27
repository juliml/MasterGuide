//
//  PinAnnotation.h
//  MasterGuide
//
//  Created by Juliana Lima on 05/10/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

enum PinFiltros
{
    Diversao = 1,
    Compras,
    Restaurantes,
    Exposicoes,
    Bares,
    Teatro,
    Parques,
    Hoteis,
    DiversaoPago,
    ComprasPago,
    RestaurantesPago,
    ExposicoesPago,
    BaresPago,
    TeatroPago,
    ParquesPago,
    HotelPago,
    Corrida
};

@interface PinAnnotation : NSObject <MKAnnotation> 
{
    NSString *_title;
    NSString *_subtitle;
    
    NSNumber *_filtro;
    NSString *_idLocal;
    
    CLLocationCoordinate2D _coordinate;
}

@property (nonatomic, copy) NSNumber *filtro;

@property (nonatomic,copy)NSString* title;
@property (nonatomic,copy)NSString* subtitle;
@property (nonatomic,copy)NSString* idLocal;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithName:(NSString*)name subtitle:(NSString*)subtitle filtro:(NSNumber*)filtro idlocal:(NSString *)idloc coordinate:(CLLocationCoordinate2D)coordinate;

@end
