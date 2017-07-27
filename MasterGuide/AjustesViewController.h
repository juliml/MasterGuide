//
//  AjustesViewController.h
//  MasterGuide
//
//  Created by Lindolfo Lacerda on 14/09/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellAjustes.h"
#import "DetalheAjustesViewController.h"
#import "SingletonManager.h"

@interface AjustesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSMutableArray *itens;
    NSMutableArray *idomas;
    
    NSInteger posicao;

    UIActionSheet *actionSheet;
    UIPickerView *pickerView;
    
    CellAjustes *cellIdioma;
    
    SingletonManager *singleton;
}
@property (strong, nonatomic) SingletonManager *singleton;
@property (strong, nonatomic) CellAjustes *cellIdioma;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) IBOutlet UITableView *tabela;
@property (assign, nonatomic) IBOutlet CellAjustes *customCell;


@end
