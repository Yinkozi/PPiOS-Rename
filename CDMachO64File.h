// -*- mode: ObjC -*-

//  This file is part of class-dump, a utility for examining the Objective-C segment of Mach-O files.
//  Copyright (C) 2009 Steve Nygard.  All rights reserved.

#import "CDMachOFile.h"

@interface CDMachO64File : CDMachOFile
{
    struct mach_header_64 header;
}

- (id)initWithData:(NSData *)someData offset:(NSUInteger)anOffset;

- (uint32_t)magic;
- (cpu_type_t)cputype;
- (cpu_subtype_t)cpusubtype;
- (uint32_t)filetype;
- (uint32_t)flags;

- (NSString *)bestMatchForLocalArch;

- (NSString *)description;

@end