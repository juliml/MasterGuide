//
//  SplashViewController.m
//  MasterGuide
//
//  Created by Juliana Lima on 17/10/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import "SplashViewController.h"
#import "Estabelecimento.h"
#import "Endereco.h"

@interface SplashViewController ()

@end

@implementation SplashViewController
@synthesize connectionJSON, singleton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    singleton = [SingletonManager sharedController];
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if(result.height == 480)
    {
        [self.imagemFundo setImage:[UIImage imageNamed:@"Default.png"]];
    }
    if(result.height == 568)
    {
        [self.imagemFundo setImage:[UIImage imageNamed:@"Default-568h.png"]];
    }
    
    [self downloadData];
    
}

- (void) downloadData
{
    
    if( [self checkConexaoInternet])
    {
        //GET JSON
        connectionJSON = [[JSONFetcher alloc] init];
        [connectionJSON setDelegate:self];
        [connectionJSON queryServiceWithParent:@"http://masterguide.lindolfolacerda.com.br/jsonEstabelecimentos.php"];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ALERTA" message:@"Falha de Conexão. O aplicativo não conseguiu conectar-se à internet."
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:@"Tentar Novamente", nil];
        
        [alert show];
        
    }
}

#pragma mark - ALERT CLICKS

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Tentar Novamente"]) {
        
        [self downloadData];
        
    } else {
        
    }
}

- (void)processSuccessful:(BOOL)success dataReceived:(NSArray *)data
{
    
    if (success)
    {
        NSMutableArray *dados = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [data count]; i++) {
            
            NSDictionary *item = [data objectAtIndex:i];
            Estabelecimento *local = [[Estabelecimento alloc] init];
            
            [local setEstabelecimentoId:[item objectForKey:@"estabelecimentoId"]];
            [local setIdiomaId:[item objectForKey:@"idiomaId"]];
            [local setCategoriaId:[item objectForKey:@"categoriaId"]];
            
            NSMutableArray *locais = [[NSMutableArray alloc] init];
            NSMutableArray *enderecos = (NSMutableArray *)[item objectForKey:@"enderecos"];
            for (int y = 0; y < [enderecos count]; y++) {
                
                Endereco *endereco = [[Endereco alloc] init];
                NSDictionary *item = (NSDictionary *)[enderecos objectAtIndex:y];
                
                [endereco setEndereco:[item objectForKey:@"endereco"]];
                [endereco setNumero:[item objectForKey:@"numero"]];
                [endereco setComplemento:[item objectForKey:@"complemento"]];
                [endereco setBairro:[item objectForKey:@"bairro"]];
                [endereco setCidade:[item objectForKey:@"cidade"]];
                [endereco setEstado:[item objectForKey:@"estado"]];
                [endereco setCep:[item objectForKey:@"cep"]];
                
                [endereco setCidadeID:[item objectForKey:@"cidadeId"]];
                [endereco setEstadoID:[item objectForKey:@"estadoId"]];
                
                NSMutableArray *fones = [[NSMutableArray alloc] init];
                NSMutableArray *telefones = (NSMutableArray *) [item objectForKey:@"telefones"];
                for (int l = 0; l < [telefones count]; l++) {
                    
                    NSDictionary *fone = (NSDictionary *) [telefones objectAtIndex:l];
                    NSString *numero = [fone objectForKey:@"numero"];
                    
                    [fones addObject:numero];
                }
                
                [endereco setTelefones:fones];
                
                [locais addObject:endereco];
                
            }
            
            [local setEndereco:locais];
            [local setNome:[item objectForKey:@"nome"]];
            [local setDescricao:[item objectForKey:@"descricao"]];
            [local setFoto1:[item objectForKey:@"foto1"]];
            [local setFoto2:[item objectForKey:@"foto2"]];
            [local setFoto3:[item objectForKey:@"foto3"]];
            [local setAnuncioPago:[item objectForKey:@"anuncioPago"]];
            [local setEmail:[item objectForKey:@"email"]];
            [local setSite:[item objectForKey:@"site"]];
            
            [dados addObject:local];
            
        }
        
        [singleton setEstabelecimentos:dados];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (BOOL) checkConexaoInternet
{
    BOOL retorno = TRUE;
    NSData *URLData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString: @"http://www.google.com"]];
    
    if ( URLData == NULL ){
        retorno = FALSE;
    }
    
    URLData = nil;
    return retorno;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setImagemFundo:nil];
    [super viewDidUnload];
}
@end
