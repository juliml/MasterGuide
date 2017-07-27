//
//  DetalheAjustesViewController.h
//  MasterGuide
//
//  Created by Juliana Lima on 15/09/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetalheAjustesViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) NSString *titulo;
@property (weak, nonatomic) IBOutlet UITextField *campoNome;
@property (weak, nonatomic) IBOutlet UITextField *campoSenha;
@end
