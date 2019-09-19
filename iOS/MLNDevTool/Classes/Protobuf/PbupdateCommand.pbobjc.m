// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: PBUpdateCommand.proto

// This CPP symbol can be defined to use imports that match up to the framework
// imports needed when using CocoaPods.
#if !defined(GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
 #define GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 0
#endif

#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <Protobuf/GPBProtocolBuffers_RuntimeSupport.h>
#else
 #import "GPBProtocolBuffers_RuntimeSupport.h"
#endif

#import "PbupdateCommand.pbobjc.h"
#import "PbbaseCommand.pbobjc.h"
// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - PbupdateCommandRoot

@implementation PbupdateCommandRoot

// No extensions in the file and none of the imports (direct or indirect)
// defined extensions, so no need to generate +extensionRegistry.

@end

#pragma mark - PbupdateCommandRoot_FileDescriptor

static GPBFileDescriptor *PbupdateCommandRoot_FileDescriptor(void) {
  // This is called by +initialize so there is no need to worry
  // about thread safety of the singleton.
  static GPBFileDescriptor *descriptor = NULL;
  if (!descriptor) {
    GPB_DEBUG_CHECK_RUNTIME_VERSIONS();
    descriptor = [[GPBFileDescriptor alloc] initWithPackage:@""
                                                     syntax:GPBFileSyntaxProto3];
  }
  return descriptor;
}

#pragma mark - pbupdatecommand

@implementation pbupdatecommand

@dynamic hasBasecommand, basecommand;
@dynamic filePath;
@dynamic relativeFilePath;
@dynamic fileData;

typedef struct pbupdatecommand__storage_ {
  uint32_t _has_storage_[1];
  pbbasecommand *basecommand;
  NSString *filePath;
  NSString *relativeFilePath;
  NSData *fileData;
} pbupdatecommand__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "basecommand",
        .dataTypeSpecific.className = GPBStringifySymbol(pbbasecommand),
        .number = pbupdatecommand_FieldNumber_Basecommand,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(pbupdatecommand__storage_, basecommand),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeMessage,
      },
      {
        .name = "filePath",
        .dataTypeSpecific.className = NULL,
        .number = pbupdatecommand_FieldNumber_FilePath,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(pbupdatecommand__storage_, filePath),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "relativeFilePath",
        .dataTypeSpecific.className = NULL,
        .number = pbupdatecommand_FieldNumber_RelativeFilePath,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(pbupdatecommand__storage_, relativeFilePath),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "fileData",
        .dataTypeSpecific.className = NULL,
        .number = pbupdatecommand_FieldNumber_FileData,
        .hasIndex = 3,
        .offset = (uint32_t)offsetof(pbupdatecommand__storage_, fileData),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeBytes,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[pbupdatecommand class]
                                     rootClass:[PbupdateCommandRoot class]
                                          file:PbupdateCommandRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(pbupdatecommand__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\003\002\010\000\003\020\000\004\010\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    #if defined(DEBUG) && DEBUG
      NSAssert(descriptor == nil, @"Startup recursed!");
    #endif  // DEBUG
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end


#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
