//
//  PinAnnotation.m
//  MasterGuide
//
//  Created by Juliana Lima on 05/10/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import "PinAnnotation.h"

@implementation PinAnnotation

@synthesize filtro = _filtro;
@synthesize coordinate = _coordinate;

@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize idLocal = _idLocal;

- (id)initWithName:(NSString*)name subtitle:(NSString *)subtitle filtro:(NSNumber*)filtro idlocal:(NSString *)idloc coordinate:(CLLocationCoordinate2D)coordinate
{
    if ((self = [super init])) {
        _title = [name copy];
        _subtitle = [subtitle copy];
        _filtro = [filtro copy];
        _coordinate = coordinate;
        _idLocal = idloc;
    }
    return self;
}

- (NSNumber *)filtro {
    return _filtro;
}


@end
