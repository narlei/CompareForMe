//
//  Auxiliar.m
//  CompareForMe
//
//  Created by Narlei Moreira on 03/02/15.
//  Copyright (c) 2015 NarleiMoreira. All rights reserved.
//

#import "Auxiliar.h"

@implementation Auxiliar
// Ordena Um Array
+(NSArray *) orderArray:(NSArray *) array keyOrder:(NSString *) keyOrder{
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:keyOrder
                                                 ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *arrayRetorno;
    arrayRetorno = [array sortedArrayUsingDescriptors:sortDescriptors];
    
    return arrayRetorno;
}
@end
