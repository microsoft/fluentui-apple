//
//  XCPHashing.c
//  XcodeProjCExt
//
//  Created by Michael Eisel on 3/16/20.
//

#include "XCPHashing.h"
#include <CommonCrypto/CommonCrypto.h>

// Given a number, c, between 0-15, returns its hexadecimal representation
static inline char toHex(uint8_t c) {
    if (c < 10) {
        return c + '0';
    } else {
        return (c - 10) + 'A';
    }
}

// Given some data, returns its MD5 hash as a hex string
const char *XCPComputeMD5(const char *data, int length) {
    uint8_t md[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data, length, md);
    char *hex = malloc(CC_MD5_DIGEST_LENGTH * 2 + 1);
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        uint8_t n = md[i];
        hex[i * 2] = toHex(n / 16);
        hex[i * 2 + 1] = toHex(n % 16);
    }
    hex[CC_MD5_DIGEST_LENGTH * 2] = '\0';
    return hex;
}
