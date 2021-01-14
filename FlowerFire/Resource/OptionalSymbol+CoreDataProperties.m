//
//  OptionalSymbol+CoreDataProperties.m
//  
//
//  Created by 王涛 on 2020/5/26.
//
//

#import "OptionalSymbol+CoreDataProperties.h"

@implementation OptionalSymbol (CoreDataProperties)

+ (NSFetchRequest<OptionalSymbol *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"OptionalSymbol"];
}

@dynamic marketID;

@end
