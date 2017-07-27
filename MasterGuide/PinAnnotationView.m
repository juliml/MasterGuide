//
//  PinAnnotationView.m
//  MasterGuide
//
//  Created by Juliana Lima on 05/10/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import "PinAnnotationView.h"
#import "PinAnnotation.h"

@implementation PinAnnotationView

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self != nil)
    {
        CGRect frame = self.frame;
        frame.size = CGSizeMake(53.0, 53.0);
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        //self.centerOffset = CGPointMake(26.0, 26.0);
    }
    return self;
}

- (void)setAnnotation:(id <MKAnnotation>)annotation
{
    [super setAnnotation:annotation];
    
    // this annotation view has custom drawing code.  So when we reuse an annotation view
    // (through MapView's delegate "dequeueReusableAnnoationViewWithIdentifier" which returns non-nil)
    // we need to have it redraw the new annotation data.
    //
    // for any other custom annotation view which has just contains a simple image, this won't be needed
    //
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if ([self.annotation isKindOfClass:[PinAnnotation class]]) {
        PinAnnotation *item = (PinAnnotation *)self.annotation;
        if (item != nil)
        {

            NSString *imageName = nil;
            switch ([item.filtro integerValue])
            {
                case Diversao:
                    imageName = @"Pino_Diversao.png";
                    break;
                case DiversaoPago:
                    imageName = @"Pino_DiversaoPAGO.png";
                    break;
                    
                case Restaurantes:
                    imageName = @"Pino_Gastronomia.png";
                    break;
                case RestaurantesPago:
                    imageName = @"Pino_GastronomiaPAGO.png";
                    break;
                    
                case Exposicoes:
                    imageName = @"Pino_Expo.png";
                    break;
                case ExposicoesPago:
                    imageName = @"Pino_ExpoPAGO.png";
                    break;
                    
                case Bares:
                    imageName = @"Pino_Bares.png";
                    break;
                case BaresPago:
                    imageName = @"Pino_BaresPAGO.png";
                    break;
                    
                case Compras:
                    imageName = @"Pino_ComprasServicos.png";
                    break;
                case ComprasPago:
                    imageName = @"Pino_ComprasServicosPAGO.png";
                    break;
                    
                case Teatro:
                    imageName = @"Pino_Teatro.png";
                    break;
                case TeatroPago:
                    imageName = @"Pino_TeatroPAGO.png";
                    break;
                    
                case Parques:
                    imageName = @"Pino_Parques.png";
                    break;
                case ParquesPago:
                    imageName = @"Pino_ParquesPAGO.png";
                    break;
                    
                case Hoteis:
                    imageName = @"Pino_Hotel.png";
                    break;
                case HotelPago:
                    imageName = @"Pino_HotelPAGO.png";
                    break;
                    
                case Corrida:
                    imageName = @"Pino_autodromo.png";
                    break;
            }
            
            [[UIImage imageNamed:imageName] drawInRect:CGRectMake(0.0, 0.0, 53.0, 53.0)];
        }
    }
}


@end
