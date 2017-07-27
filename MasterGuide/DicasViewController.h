//
//  DicasViewController.h
//  MasterGuide
//
//  Created by Juliana Lima on 15/09/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingletonManager.h"
#import "CellDicas.h"

@interface DicasViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *itens;
}

@property (strong, nonatomic) SingletonManager *singleton;
@property (weak, nonatomic) IBOutlet UITableView *tabela;
@property (assign, nonatomic) IBOutlet CellDicas *customCell;

@end
