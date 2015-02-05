//
//  ViewController.m
//  CompareForMe
//
//  Created by Narlei Moreira on 02/02/15.
//  Copyright (c) 2015 NarleiMoreira. All rights reserved.
//

#import "ViewController.h"
#import "Arquivo.h"
#import "ArquivoTabela.h"
#import "Auxiliar.h"
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableViewLeft setDataSource:self];
    [self.tableViewLeft setDelegate:self];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    // Update the view, if already loaded.
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    ArquivoTabela *arquivo = [self.arquivos objectAtIndex:row];
    
    if( [tableColumn.identifier isEqualToString:@"NameRightColumn"] )
    {
        [cellView.textField setStringValue:arquivo.arquivoRigth.nome];
    }
    if( [tableColumn.identifier isEqualToString:@"NameLeftColumn"] )
    {
        [cellView.textField setStringValue:arquivo.arquivoLeft.nome];
    }
    if( [tableColumn.identifier isEqualToString:@"CompareColumn"] )
    {
        NSString *comparacao = @"Diferentes";
        if (arquivo.identicos) {
            comparacao = @"Iguais";
        }
        [cellView.textField setStringValue:comparacao];
    }
    
    if (arquivo.identicos) {
        [cellView.textField setTextColor:[NSColor colorWithCalibratedRed:0.251 green:0.502 blue:0.000 alpha:1.000]];
    }else{
        [cellView.textField setTextColor:[NSColor colorWithCalibratedRed:0.502 green:0.000 blue:0.000 alpha:1.000]];
    }
    
    return cellView;
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [self.arquivos count];
}


-(void) tableViewSelectionDidChange:(NSNotification *)notification{
    NSInteger row = [self.tableViewLeft selectedRow];
    ArquivoTabela *arquivo = [self.arquivos objectAtIndex:row];
    [self.labelNomeArquivoLeft setStringValue:[NSString stringWithFormat:@"%@%@",arquivo.arquivoLeft.path,arquivo.arquivoLeft.nome]];
    [self.labelNomeArquivoRight setStringValue:[NSString stringWithFormat:@"%@%@",arquivo.arquivoRigth.path,arquivo.arquivoRigth.nome]];
    
}


-(void) compararArquivos{
    NSInteger row = [self.tableViewLeft selectedRow];
    ArquivoTabela *arquivo = [self.arquivos objectAtIndex:row];
    
    NSArray *args = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@%@",arquivo.arquivoLeft.path,arquivo.arquivoLeft.nome],[NSString stringWithFormat:@"%@%@",arquivo.arquivoRigth.path,arquivo.arquivoRigth.nome], nil];
    
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:@"/usr/bin/opendiff"];
    [task setArguments: args];
    [task launch];
}


-(void) getArquivosPasta:(BOOL) esquerda{
    
    if (esquerda) {
        self.arquivosEsquerda = [NSMutableArray new];
    }else{
        self.arquivosDireita = [NSMutableArray new];
    }
    
    
    
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    // Enable the selection of files in the dialog.
    [openDlg setCanChooseFiles:NO];
    
    // Enable the selection of directories in the dialog.
    [openDlg setCanChooseDirectories:YES];
    
    // Change "Open" dialog button to "Select"
    [openDlg setPrompt:@"Select"];
    
    // Display the dialog.  If the OK button was pressed,
    // process the files.
    if ( [openDlg runModal] == NSModalResponseOK )
    {
        // Get an array containing the full filenames of all
        // files and directories selected.
        NSArray* files = [openDlg URLs];
        
        // Loop through all the files and process them.
        for( int i = 0; i < [files count]; i++ )
        {
            NSURL* fileName = [files objectAtIndex:i];
            
            NSString *nomePasta = [fileName absoluteString];
            nomePasta = [nomePasta stringByReplacingOccurrencesOfString:@"file:" withString:@""];
            nomePasta = [nomePasta stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
            if (esquerda) {
                [self.pathControlLeft setURL:[NSURL URLWithString:nomePasta]];
            }else{
                [self.pathControlRight setURL:[NSURL URLWithString:nomePasta]];
            }
            
            NSFileManager *manager = [NSFileManager defaultManager];
            NSDirectoryEnumerator *direnum = [manager enumeratorAtPath:nomePasta];
            __block NSString* arqName;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                while ((arqName = [direnum nextObject] )) {
                    if (![arqName containsString:@".svn"] && ![arqName containsString:@".git"]) {
                        Arquivo *arquivo = [Arquivo new];
                        NSFileManager *man = [NSFileManager defaultManager];
                        NSDictionary *attrs = [man attributesOfItemAtPath: [NSString stringWithFormat:@"%@%@",nomePasta,arqName] error: NULL];
                        
                        NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@%@",nomePasta,arqName] options:0 error:nil];
                        
                        
                        
                        arquivo.nome = arqName;
                        arquivo.path = nomePasta;
                        arquivo.attributes = attrs;
                        arquivo.md5 = [data MD5];
                        
                        
                        if (esquerda) {
                            [self.arquivosEsquerda addObject:arquivo];
                        }else{
                            [self.arquivosDireita addObject:arquivo];
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (esquerda) {
                                [self.labelTotalArquivosLeft setStringValue:[NSString stringWithFormat:@"%lu", (unsigned long)self.arquivosEsquerda.count]];
                            }else{
                                [self.labelTotalArquivosRight setStringValue:[NSString stringWithFormat:@"%lu", (unsigned long)self.arquivosDireita.count]];
                            }
                        });
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self compareArrays];
                });
            });
            
        }
    }
    
}

- (IBAction)buttonCompararPressed:(id)sender {
    [self compararArquivos];
}

- (IBAction)abrirArquivoRight:(id)sender {
    [self getArquivosPasta:NO];
}

- (IBAction)abrirArquivoLeft:(id)sender {
    [self getArquivosPasta:YES];
}


-(void) compareArrays{
    self.arquivos = [NSMutableArray new];
    NSMutableArray *arrayLeft = self.arquivosEsquerda;
    NSMutableArray *arrayRight = self.arquivosDireita;
    
    double total = [[NSString stringWithFormat:@"%lu",(unsigned long)[arrayLeft count]] doubleValue];
    self.progress.maxValue = total;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.progress setDoubleValue:0];
    });
    __block double progress = 0;
    for (Arquivo *arquivoLeft in arrayLeft) {
        NSString*nomeArquivoLeft= [[NSFileManager defaultManager] displayNameAtPath:arquivoLeft.nome];
        ArquivoTabela *arquivoTabela = [ArquivoTabela new];
        arquivoTabela.arquivoLeft  = arquivoLeft;
        arquivoTabela.identicos = NO;
        
        for (Arquivo *arquivoRight in arrayRight) {
            NSString*nomeArquivoRight= [[NSFileManager defaultManager] displayNameAtPath:arquivoRight.nome];
            if ([nomeArquivoLeft isEqualToString:nomeArquivoRight]) {
                arquivoTabela.arquivoRigth = arquivoRight;
                
                if ([arquivoLeft.md5 isEqualToString:arquivoRight.md5]) {
                    arquivoTabela.identicos = YES;
                }
                [arrayRight removeObject:arquivoRight];
                break;
            }
        }
        if (!arquivoTabela.arquivoRigth) {
            Arquivo *arquivoRight = [Arquivo new];
            arquivoRight.nome = @"";
            arquivoRight.md5 = @"";
            arquivoTabela.arquivoRigth = arquivoRight;
        }
        progress ++;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.progress setDoubleValue:progress];
            NSLog(@"%f",progress);
        });
        [self.arquivos addObject:arquivoTabela];
    }
    
    
    self.progress.maxValue = [arrayLeft count];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.progress setDoubleValue:0];
    });
    progress = 0;
    
    
    for (Arquivo *arquivoRight in arrayRight) {
        ArquivoTabela *arquivoTabela = [ArquivoTabela new];
        Arquivo *arquivoLeft = [Arquivo new];
        arquivoLeft.nome = @"";
        arquivoLeft.md5 = @"";
        arquivoTabela.arquivoLeft = arquivoLeft;
        arquivoTabela.arquivoRigth = arquivoRight;
        arquivoTabela.identicos = NO;
        progress ++;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.progress setDoubleValue:progress];
        });
        
        [self.arquivos addObject:arquivoTabela];
    }
    
    self.arquivos = [[NSMutableArray alloc] initWithArray:[Auxiliar orderArray:self.arquivos keyOrder:@"identicos"]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableViewLeft reloadData];
        [self.progress setDoubleValue:0];
    });
}

- (IBAction)buttonAbrirLeftPressed:(id)sender {
    NSInteger row = [self.tableViewLeft selectedRow];
    ArquivoTabela *arquivo = [self.arquivos objectAtIndex:row];
    
    NSArray *args = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@%@",arquivo.arquivoLeft.path,arquivo.arquivoLeft.nome], nil];
    
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:@"/usr/bin/open"];
    [task setArguments: args];
    [task launch];
}

- (IBAction)buttonAbrirRightPressed:(id)sender {
    NSInteger row = [self.tableViewLeft selectedRow];
    ArquivoTabela *arquivo = [self.arquivos objectAtIndex:row];
    
    NSArray *args = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@%@",arquivo.arquivoRigth.path,arquivo.arquivoRigth.nome], nil];
    
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:@"/usr/bin/open"];
    [task setArguments: args];
    [task launch];
}

-(void) viewWillDisappear{
    [NSApp terminate:self];
}
@end
