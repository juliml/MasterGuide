//
//  FavoritosViewController.h
//  MasterGuide
//
//  Created by Juliana Lima on 18/09/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingletonManager.h"
#import "CellFavorito.h"

@interface FavoritosViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *itens;
    SingletonManager *singleton;
    
    Boolean editarTAB;
}
@property (strong, nonatomic) SingletonManager *singleton;
@property (assign, nonatomic) IBOutlet CellFavorito *customCell;
@property (weak, nonatomic) IBOutlet UITableView *tabela;

@end
