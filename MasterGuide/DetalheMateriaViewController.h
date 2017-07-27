//
//  DetalheMateriaViewController.h
//  MasterGuide
//
//  Created by Juliana Lima on 26/09/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingletonManager.h"
#import "Materia.h"
#import "EGOImageView.h"

@class EGOImageView;
@interface DetalheMateriaViewController : UIViewController <UIScrollViewDelegate, EGOImageViewDelegate>
{
    UITextView *texto;
    UIImageView *imagem;
    
    Boolean especial;
    
    Materia *materia;
    EGOImageView* imageView;
    
}
@property (strong, nonatomic) UITextView *texto;
@property (nonatomic) Boolean especial;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *carregador;

@property (strong, nonatomic) Materia *materia;
@property (strong, nonatomic) SingletonManager *singleton;

@end
