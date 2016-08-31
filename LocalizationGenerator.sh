#!/bin/sh

#  LocalizationGenerator.sh
#
#  Created by EscapedDog on 16/8/31.
#  Copyright © 2016年 EscapedDog. All rights reserved.
set -e

FILE=$(dirname $0)
NAME="${PROJECT_NAME}Localization.strings"

if find $FILE -name $NAME
then
    H_STRINGS="#import <UIKit/UIKit.h>\n\n@interface ${PROJECT_NAME}Strings: NSObject\n+ (instancetype)local;\n"
    M_STRINGS="#import \"${PROJECT_NAME}Strings.h\"\n#define LG_Local(__key, __bundle, __tbl) NSLocalizedStringWithDefaultValue((__key), (__tbl), [NSBundle bundleWithPath:[[NSBundle mainBundle]pathForResource:(__bundle) ofType:@\"bundle\"]]?:[NSBundle mainBundle], nil, nil)\n\n@implementation ${PROJECT_NAME}Strings\n+ (instancetype)local {\nstatic dispatch_once_t onceToken;\nstatic ${TARGET_NAME}Strings *instance;\ndispatch_once(&onceToken, ^{\ninstance = [${TARGET_NAME}Strings new];\n});\nreturn instance;\n}\n"
    while IFS='' read -r line || [[ -n "$line" ]]; do
        if [[ $line =~ ^\" ]]
        then
            STRING="$(echo -e "${line}" | tr -d '[[:space:]]')"
            echo $STRING
            while IFS='=' read -ra ADDR; do
                VAR="$(echo -e "${ADDR[0]}" | tr -d '[["]]')"
                DESC="$(echo -e "${ADDR[1]}" | tr -d '[["]]')"
                H_STRINGS=$H_STRINGS"/**\n*  $DESC\n*/\n@property (copy, readonly, nonatomic) NSString *$VAR;\n\n"
                M_STRINGS=$M_STRINGS"- (NSString *)$VAR {\nreturn LG_Local(@\"$VAR\", @\"${PROJECT_NAME}\", @\"${PROJECT_NAME}Localization\");\n}\n\n"
            done <<< "$STRING"
        fi
    done < $FILE"/"$NAME
    H_STRINGS=$H_STRINGS"@end\n"
    M_STRINGS=$M_STRINGS"@end\n"
    echo -e $H_STRINGS > $FILE"/${TARGET_NAME}Strings.h"
    echo -e $M_STRINGS > $FILE"/${TARGET_NAME}Strings.m"
fi