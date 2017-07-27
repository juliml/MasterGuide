//
//  AjustesViewController.m
//  MasterGuide
//
//  Created by Lindolfo Lacerda on 14/09/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import "AjustesViewController.h"
#import "IIViewDeckController.h"
#import "Language.h"

#import "AppDelegate.h"

#import "MenuViewController.h"
#import "CompartilhaViewController.h"

#import "SHKTwitter.h"
#import "SHKFacebook.h"
#import "SHKFoursquareV2.h"

@interface AjustesViewController ()

@end

@implementation AjustesViewController
@synthesize tabela, pickerView, singleton, cellIdioma;

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
    
    itens = [[NSMutableArray alloc] initWithObjects:@"Facebook", @"Twitter", @"Foursquare", [Language get:@"btnIdioma" alter:nil], nil];
    [tabela reloadData];
    
    //BG TABELA
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Background_DemaisTelas.png"]];
    [tabela setBackgroundView:imageView];
    [tabela setSeparatorColor:[UIColor clearColor]];
    
    //BOTAO MENU
    UIButton *btnMenu =[[UIButton alloc] init];
    [btnMenu setBackgroundImage:[UIImage imageNamed:@"NavBar_MenuBtn.png"] forState:UIControlStateNormal];
    
    btnMenu.frame = CGRectMake(100, 100, 40, 31);
    UIBarButtonItem *barBtnMenu =[[UIBarButtonItem alloc] initWithCustomView:btnMenu];
    [btnMenu addTarget:self.viewDeckController action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = barBtnMenu;
    [[self.tabBarController viewDeckController] setEnabled:FALSE];
    
    //TITULO
    CGRect frame = CGRectMake(0, 0, 120, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Zeppelin 33" size:18.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = [Language get:@"titAjustes" alter:nil];
    
    self.navigationItem.titleView = label;
    
    //PICKERVIEW
    idomas = [[NSMutableArray alloc] init];
    [idomas addObject:@"Português"];
    [idomas addObject:@"English"];

}

- (void)viewDidUnload
{
    [self setTabela:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [itens count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"AjusteCell";
    CellAjustes *cell = (CellAjustes *)[tableView dequeueReusableCellWithIdentifier:[CellAjustes reuseIdentifier]];
    
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = _customCell;
        _customCell = nil;
    }
    
    // Set up the cell...
    NSString *cellValue = [itens objectAtIndex:indexPath.row];
    if ([cellValue isEqual:@"Idioma"] || [cellValue isEqual:@"Language"]) {
        cell.habilita.hidden = TRUE;
        cellIdioma = cell;
    }
    
    [cell.titulo setFont:[UIFont fontWithName:@"Zeppelin 33" size:12.0]];
    cell.titulo.text = cellValue;
    
    [cell.habilita setOnTintColor:[UIColor colorWithRed:175/255.0f green:10/255.0f blue:35/255.0f alpha:1.0]];
    [cell.habilita setTag:indexPath.row];
    [cell.habilita addTarget:self action:@selector(switchAction:)
       forControlEvents:UIControlEventValueChanged];
    
    switch (indexPath.row) {
        case 0:
                if ([SHKFacebook isServiceAuthorized])
                {
                    [singleton setSetFacebook:[SHKFacebook isServiceAuthorized]];
                    [cell.habilita setOn:YES animated:NO];
                }
                else [cell.habilita setOn:NO animated:NO];
            break;
            
        case 1:
                if ([singleton setFoursquare]) [cell.habilita setOn:YES animated:NO];
                else [cell.habilita setOn:NO animated:NO];
            break;
            
        case 2:
                if ([SHKFoursquareV2 isServiceAuthorized])
                {
                    [singleton setSetFoursquare:[SHKFoursquareV2 isServiceAuthorized]];
                    [cell.habilita setOn:YES animated:NO];
                }
                else [cell.habilita setOn:NO animated:NO];
            break;
    }
    
    return cell;
}

- (void) switchAction:(id)sender
{
    UISwitch *opcao = (UISwitch *)sender;
    
    switch (opcao.tag)
    {
        case 0:
            if (!opcao.on) {
                
                NSString *titulo = [NSString stringWithFormat:@"%@ Facebook", [Language get:@"alertSociaisCancTxt" alter:nil]];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"alertSociaisCancTit" alter:nil] message:titulo delegate:self cancelButtonTitle:[Language get:@"btnCancelar" alter:nil] otherButtonTitles:[Language get:@"btnConfirmar" alter:nil],nil];
                [alert setTag:1];
                [alert show];
                
            } else {
                
                NSString *titulo = [NSString stringWithFormat:@"%@ Facebook", [Language get:@"alertConectTexto" alter:nil]];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"alertConectTitulo" alter:nil] message:titulo delegate:self cancelButtonTitle:[Language get:@"btnCancelar" alter:nil] otherButtonTitles:[Language get:@"btnConfirmar" alter:nil],nil];
                [alert setTag:4];
                [alert show];
                
            }
            break;
            
        case 1:
            
            if (!opcao.on) {
                
                NSString *titulo = [NSString stringWithFormat:@"%@ Twitter", [Language get:@"alertSociaisCancTxt" alter:nil]];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"alertSociaisCancTit" alter:nil] message:titulo delegate:self cancelButtonTitle:[Language get:@"btnCancelar" alter:nil] otherButtonTitles:[Language get:@"btnConfirmar" alter:nil],nil];
                [alert setTag:2];
                [alert show];
                
            } else {
                
                
                NSString *titulo = [NSString stringWithFormat:@"%@ Twitter", [Language get:@"alertConectTexto" alter:nil]];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"alertConectTitulo" alter:nil] message:titulo delegate:self cancelButtonTitle:[Language get:@"btnCancelar" alter:nil] otherButtonTitles:[Language get:@"btnConfirmar" alter:nil],nil];
                [alert setTag:5];
                [alert show];

            }
            
            break;
            
        case 2:
            
            if (!opcao.on) {
                
                NSString *titulo = [NSString stringWithFormat:@"%@ Foursquare", [Language get:@"alertSociaisCancTxt" alter:nil]];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"alertSociaisCancTit" alter:nil] message:titulo delegate:self cancelButtonTitle:[Language get:@"btnCancelar" alter:nil] otherButtonTitles:[Language get:@"btnConfirmar" alter:nil],nil];
                [alert setTag:3];
                [alert show];
                
            } else {
                
                NSString *titulo = [NSString stringWithFormat:@"%@ Foursquare", [Language get:@"alertConectTexto" alter:nil]];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"alertConectTitulo" alter:nil] message:titulo delegate:self cancelButtonTitle:[Language get:@"btnCancelar" alter:nil] otherButtonTitles:[Language get:@"btnConfirmar" alter:nil],nil];
                [alert setTag:6];
                [alert show];
                
            }
            
            break;
    }
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    NSString *item = [itens objectAtIndex:[indexPath row]];
    
    if ([item isEqualToString:@"Idioma"] || [item isEqualToString:@"Language"])
    {
        [self showPicker];
        posicao = [singleton idioma] -1;
        [pickerView selectRow:posicao inComponent:0 animated:YES];
        
    } else {
        
        CellAjustes *tipo = (CellAjustes *)[tableView cellForRowAtIndexPath:indexPath];
        UISwitch *escolha = [tipo habilita];
    
        [self checkRedes:escolha indice:indexPath.row];

    }
     
}

- (void) checkRedes:(UISwitch*)escolha indice:(NSInteger)pos
{
    
    NSLog(@"ESCOLHA %d", escolha.on);
    
    switch (pos)
    {
        case 0:
            if (escolha.on) {
                
                NSString *titulo = [NSString stringWithFormat:@"%@ Facebook", [Language get:@"alertSociaisCancTxt" alter:nil]];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"alertSociaisCancTit" alter:nil] message:titulo delegate:self cancelButtonTitle:[Language get:@"btnCancelar" alter:nil] otherButtonTitles:[Language get:@"btnConfirmar" alter:nil],nil];
                [alert setTag:1];
                [alert show];
                
            } else {
                
                NSString *titulo = [NSString stringWithFormat:@"%@ Facebook", [Language get:@"alertConectTexto" alter:nil]];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"alertConectTitulo" alter:nil] message:titulo delegate:self cancelButtonTitle:[Language get:@"btnCancelar" alter:nil] otherButtonTitles:[Language get:@"btnConfirmar" alter:nil],nil];
                [alert setTag:4];
                [alert show];

            }
            break;
            
        case 1:
            
            if (escolha.on) {
                
                NSString *titulo = [NSString stringWithFormat:@"%@ Twitter", [Language get:@"alertSociaisCancTxt" alter:nil]];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"alertSociaisCancTit" alter:nil] message:titulo delegate:self cancelButtonTitle:[Language get:@"btnCancelar" alter:nil] otherButtonTitles:[Language get:@"btnConfirmar" alter:nil],nil];
                [alert setTag:2];
                [alert show];
                
            } else {
                
                NSString *titulo = [NSString stringWithFormat:@"%@ Twitter", [Language get:@"alertConectTexto" alter:nil]];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"alertConectTitulo" alter:nil] message:titulo delegate:self cancelButtonTitle:[Language get:@"btnCancelar" alter:nil] otherButtonTitles:[Language get:@"btnConfirmar" alter:nil],nil];
                [alert setTag:5];
                [alert show];
                
            }
            
            break;
            
        case 2:
            
            if (escolha.on) {
                
                NSString *titulo = [NSString stringWithFormat:@"%@ Foursquare", [Language get:@"alertSociaisCancTxt" alter:nil]];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"alertSociaisCancTit" alter:nil] message:titulo delegate:self cancelButtonTitle:[Language get:@"btnCancelar" alter:nil] otherButtonTitles:[Language get:@"btnConfirmar" alter:nil],nil];
                [alert setTag:3];
                [alert show];
                
            } else {
                
                NSString *titulo = [NSString stringWithFormat:@"%@ Foursquare", [Language get:@"alertConectTexto" alter:nil]];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"alertConectTitulo" alter:nil] message:titulo delegate:self cancelButtonTitle:[Language get:@"btnCancelar" alter:nil] otherButtonTitles:[Language get:@"btnConfirmar" alter:nil],nil];
                [alert setTag:6];
                [alert show];
                
            }
            
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {

        if ([alertView tag] == 1) //FACEBOOK
        {
            CellAjustes *tipo = (CellAjustes *)[tabela cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            UISwitch *escolha = [tipo habilita];
            [escolha setOn:YES animated:YES];
        }
        else if ([alertView tag] == 2) //TWITTER
        {
            CellAjustes *tipo = (CellAjustes *)[tabela cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            UISwitch *escolha = [tipo habilita];
            [escolha setOn:YES animated:YES];
        }
        else if ([alertView tag] == 3) //FOURSQUARE
        {
            CellAjustes *tipo = (CellAjustes *)[tabela cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            UISwitch *escolha = [tipo habilita];
            [escolha setOn:YES animated:YES];
        }
        
        else if ([alertView tag] == 4) //FACEBOOK
        {
            CellAjustes *tipo = (CellAjustes *)[tabela cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            UISwitch *escolha = [tipo habilita];
            [escolha setOn:NO animated:YES];
        }
        else if ([alertView tag] == 5) //TWITTER
        {
            CellAjustes *tipo = (CellAjustes *)[tabela cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            UISwitch *escolha = [tipo habilita];
            [escolha setOn:NO animated:YES];
        }
        else if ([alertView tag] == 6) //FOURSQUARE
        {
            CellAjustes *tipo = (CellAjustes *)[tabela cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            UISwitch *escolha = [tipo habilita];
            [escolha setOn:NO animated:YES];
        }
        
    }
    else if (buttonIndex == 1)
    {
        if ([alertView tag] == 1) //FACEBOOK
        {
            CellAjustes *tipo = (CellAjustes *)[tabela cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            UISwitch *escolha = [tipo habilita];
            [escolha setOn:NO animated:YES];
            
            [singleton setSetFacebook:FALSE];
            [SHKFacebook logout];
            
        }
        else if ([alertView tag] == 2) //TWITTER
        {
            CellAjustes *tipo = (CellAjustes *)[tabela cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            UISwitch *escolha = [tipo habilita];
            [escolha setOn:NO animated:YES];
            
            [singleton setSetTwitter:FALSE];
            [SHKTwitter logout];
        }
        else if ([alertView tag] == 3) //FOURSQUARE
        {
            
            CellAjustes *tipo = (CellAjustes *)[tabela cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            UISwitch *escolha = [tipo habilita];
            [escolha setOn:NO animated:YES];
            
            [singleton setSetFoursquare:FALSE];
            [SHKFoursquareV2 logout];
            
        }
        
        else if ([alertView tag] == 4) //FACEBOOK
        {
            if (![SHKFacebook isServiceAuthorized])
            {
                SHKItem *item = [SHKItem text:@" via http://www.facebook.com/MasterGuideApp"];
                [SHKFacebook shareItem:item];
                
                CellAjustes *tipo = (CellAjustes *)[tabela cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                UISwitch *escolha = [tipo habilita];
                [escolha setOn:YES animated:YES];
            }
        }
        
        else if ([alertView tag] == 5) //TWITTER
        {
            CellAjustes *tipo = (CellAjustes *)[tabela cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            UISwitch *escolha = [tipo habilita];
            
            [singleton setSetTwitter:TRUE];
            [escolha setOn:YES animated:YES];
        }
        
        else if ([alertView tag] == 6) //FOURSQUARE
        {
            if (![SHKFoursquareV2 isServiceAuthorized])
            {
                SHKItem *item = [SHKItem text:@" via @masterguideapp"];
                [SHKFoursquareV2 shareItem:item];
                
                CellAjustes *tipo = (CellAjustes *)[tabela cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                UISwitch *escolha = [tipo habilita];
                [escolha setOn:YES animated:YES];
            }
        }
    }
}

- (void) viewDidDisappear:(BOOL)animated
{
    [singleton setSetFacebook:[SHKFacebook isServiceAuthorized]];
    [singleton setSetFoursquare:[SHKFoursquareV2 isServiceAuthorized]];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:[self.singleton setTwitter] forKey:@"twitter"];
    [prefs setInteger:[self.singleton setFacebook] forKey:@"facebook"];
    [prefs setInteger:[self.singleton setFoursquare] forKey:@"foursquare"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)showPicker
{

    // create the picker and add it to the view
    actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                              delegate:nil
                                     cancelButtonTitle:nil
                                destructiveButtonTitle:nil
                                     otherButtonTitles:nil];
    
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    CGRect pickerFrame = CGRectMake(0, 44, 0, 0);
    
    pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
    pickerView.showsSelectionIndicator = NO;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    
    [actionSheet addSubview:pickerView];
    
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Ok"]];

    closeButton.momentary = YES;
    closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 31.0f);
    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = [UIColor colorWithRed:136/255.f green:2/255.f blue:22/255.f alpha:1.0];
    [closeButton addTarget:self action:@selector(closePicker:) forControlEvents:UIControlEventValueChanged];
    [actionSheet addSubview:closeButton];
    
    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    [actionSheet setBounds:CGRectMake(0, 0, 320, 485)];

}

-(BOOL)closePicker:(id)sender
{
    
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
	return YES;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    posicao = row;
    [singleton setIdioma:posicao+1];
    
    //SALVA ESCOLHA
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:[self.singleton idioma] forKey:@"idioma"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (posicao == 0) [Language setLanguage:@"pt"];
    else if (posicao == 1) [Language setLanguage:@"en"];
    
    [self reloadTab];
    [self.pickerView reloadAllComponents];
}

- (void) reloadTab
{
    cellIdioma.titulo.text = [Language get:@"btnIdioma" alter:nil];
    
    UILabel *label = (UILabel *)self.navigationItem.titleView;
    label.text = [Language get:@"titAjustes" alter:nil];
    
    UITabBar *tabBar = self.tabBarController.tabBar;
    
    UITabBarItem *itemHome = [tabBar.items objectAtIndex:0];
    [itemHome setTitle:[Language get:@"tabHome" alter:nil]];
    
    UITabBarItem *itemCidade = [tabBar.items objectAtIndex:1];
    [itemCidade setTitle:[Language get:@"tabCidade" alter:nil]];
    
    UITabBarItem *itemLocais = [tabBar.items objectAtIndex:2];
    [itemLocais setTitle:[Language get:@"tabLocais" alter:nil]];
    
    UITabBarItem *itemCamera = [tabBar.items objectAtIndex:3];
    [itemCamera setTitle:[Language get:@"tabCamera" alter:nil]];
    
    UITabBarItem *itemAjustes = [tabBar.items objectAtIndex:4];
    [itemAjustes setTitle:[Language get:@"tabAjustes" alter:nil]];
    
    MenuViewController *menu = (MenuViewController *)[[[self tabBarController] viewDeckController] leftController];
    [menu reloadMenu];
    
    CompartilhaViewController *compartilhar = (CompartilhaViewController *)[[[self tabBarController] viewDeckController] rightController];
    [compartilhar reloadMenu];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UIView *pickerviewtemp=[[UIView alloc] initWithFrame:CGRectZero];
    
    UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(40, -15, 240, 30)];
    [lbl setTextColor:[UIColor blackColor]];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setText:[idomas objectAtIndex:row]];
    [lbl setFont:[UIFont boldSystemFontOfSize:25]];
    [pickerviewtemp addSubview:lbl];
    
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(15, -5, 14, 14)];
    if (row == posicao) {
        [imgView setImage:[UIImage imageNamed:@"check.png"]];
        [lbl setTextColor:[UIColor colorWithRed:50/255.f green:79/255.f blue:133/255.f alpha:1.0]];
    }
    else {
       [imgView setImage:nil];
    }
    
    [pickerviewtemp addSubview:imgView];
    return pickerviewtemp;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [idomas count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    return [idomas objectAtIndex:row];
}


@end
