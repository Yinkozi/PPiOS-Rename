#import "CDXibStoryBoardProcessor.h"
#import "CDXibStoryboardParser.h"


@implementation CDXibStoryBoardProcessor

- (BOOL)obfuscateFilesUsingSymbols:(NSDictionary *)symbols {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *keys = @[NSURLIsDirectoryKey];
    NSURL *directoryURL;
    if (self.xibBaseDirectory) {
        directoryURL = [NSURL URLWithString:[self.xibBaseDirectory stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    } else {
        directoryURL = [NSURL URLWithString:@"."];
    }

    NSDirectoryEnumerator *enumerator = [fileManager
        enumeratorAtURL:directoryURL
        includingPropertiesForKeys:keys
        options:0
        errorHandler:^(NSURL *url, NSError *error) {
            // Handle the error.
            // Return YES if the enumeration should continue after the error.
            return YES;
    }];

    CDXibStoryboardParser *parser = [[CDXibStoryboardParser alloc] init];
    for (NSURL *url in enumerator) {
        NSError *error;
        NSNumber *isDirectory = nil;
        if ([url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error] && ![isDirectory boolValue]) {
            if ([url.absoluteString hasSuffix:@".xib"] || [url.absoluteString hasSuffix:@".storyboard"]) {
                NSLog(@"Obfuscating IB file at path %@", url);
                NSData *data = [parser obfuscatedXmlData:[NSData dataWithContentsOfURL:url] symbols:symbols];
                if (!data) {
                    return NO;
                }
                NSString *formatedXml = [parser prettyPrintXML:data];
                if (!formatedXml) {
                    return NO;
                }
                if (![formatedXml writeToURL:url atomically:YES encoding:NSUnicodeStringEncoding error:&error]) {
                    NSLog(@"Error writing file at %@ (%@(", url, [error localizedFailureReason]);
                    return NO;
                }
            }
        }
    }

    return YES;
}

@end
