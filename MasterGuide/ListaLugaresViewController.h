//
//  ListaLugaresViewController.h
//  MasterGuide
//
//  Created by Juliana Lima on 18/09/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingletonManager.h"
#import "CellLugar.h"

@interface ListaLugaresViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *itens;
}

@property (strong, nonatomic) SingletonManager *singleton;
@property (assign, nonatomic) IBOutlet CellLugar *customCell;
@property (weak, nonatomic) IBOutlet UITableView *tabela;

@end
