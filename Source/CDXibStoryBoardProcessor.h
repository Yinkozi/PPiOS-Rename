#import <Foundation/Foundation.h>


@interface CDXibStoryBoardProcessor : NSObject
@property(nonatomic, copy) NSString *xibBaseDirectory;

- (BOOL)obfuscateFilesUsingSymbols:(NSDictionary *)symbols;
@end
