//
//  DetalheLugaresViewController.h
//  MasterGuide
//
//  Created by Juliana Lima on 18/09/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingletonManager.h"
#import "Estabelecimento.h"

@class EGOImageView;
@interface DetalheLugaresViewController : UIViewController <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
{
    UITextView *texto;

    NSMutableArray *listaEnderecos;    
    NSString *telefoneSelecionado;
    
    Estabelecimento *local;
    
    UIScrollView *images;
    UIPageControl *pageControl;
    NSMutableArray *arrayImages;

}
@property (strong, nonatomic) NSString *telefoneSelecionado;
@property (strong, nonatomic) SingletonManager *singleton;
@property (strong, nonatomic) UITextView *texto;

@property (nonatomic, retain) UIScrollView *images;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) NSMutableArray *arrayImages;

@property (strong, nonatomic) Estabelecimento *local;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UITableView *tabela;

@end
