//
//  HomeViewController.h
//  MasterGuide
//
//  Created by Lindolfo Lacerda on 14/09/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingletonManager.h"
#import "JSONFetcher.h"
#import "MBProgressHUD.h"
#import "EGOImageView.h"

@interface HomeViewController : UIViewController <MBProgressHUDDelegate>
{
    NSDate *destinationDate;
    NSTimer *timer;
    
    JSONFetcher *connectionJSON;
    SingletonManager *singleton;
    
    NSMutableArray *eventos;
    NSInteger dataEvento;
    
    MBProgressHUD *HUD;
}
@property (strong, nonatomic) JSONFetcher *connectionJSON;
@property (strong, nonatomic) SingletonManager *singleton;
@property (strong, nonatomic) NSMutableArray *eventos;

@property (strong, nonatomic) NSDate *destinationDate;
@property (strong, nonatomic) NSTimer *timer;

@property (weak, nonatomic) IBOutlet UILabel *tituloEvento;
@property (weak, nonatomic) IBOutlet UILabel *descricaoEvento;

@property (weak, nonatomic) IBOutlet UILabel *tituloTempo;

@property (weak, nonatomic) IBOutlet UILabel *valDias;
@property (weak, nonatomic) IBOutlet UILabel *valHora;

@property (weak, nonatomic) IBOutlet UILabel *txtDias;
@property (weak, nonatomic) IBOutlet UILabel *txtHora;
@property (weak, nonatomic) IBOutlet UILabel *txtMinutos;
@property (weak, nonatomic) IBOutlet UILabel *txtSegundos;

@property (weak, nonatomic) IBOutlet UILabel *txtMaterias;
@property (weak, nonatomic) IBOutlet UILabel *txtDicas;
@property (weak, nonatomic) IBOutlet UILabel *txtParceiros;
@property (weak, nonatomic) IBOutlet UIImageView *imagemBack;
@property (weak, nonatomic) IBOutlet UIView *imgEvento;


- (IBAction)openMateriasEspeciais:(id)sender;
- (IBAction)openMasterDicas:(id)sender;
- (IBAction)openParceirosOficiais:(id)sender;

- (void) updateData;

@end
