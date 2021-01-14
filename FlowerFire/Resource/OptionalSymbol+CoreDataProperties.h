//
//  OptionalSymbol+CoreDataProperties.h
//  
//
//  Created by 王涛 on 2020/5/26.
//
//

#import "OptionalSymbol+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface OptionalSymbol (CoreDataProperties)

+ (NSFetchRequest<OptionalSymbol *> *)fetchRequest;

@property (nonatomic) int64_t marketID;

@end

NS_ASSUME_NONNULL_END
