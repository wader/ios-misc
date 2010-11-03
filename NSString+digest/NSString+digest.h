/*
 * NSString+digest, NSString category adding common message digest methods
 *
 * Copyright (c) 2010 <mattias.wadman@gmail.com>
 *
 * MIT License:
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

#define DIGESTS \
  DIGEST(md2, CC_MD2, CC_MD2_DIGEST_LENGTH) \
  DIGEST(md4, CC_MD4, CC_MD4_DIGEST_LENGTH) \
  DIGEST(md5, CC_MD5, CC_MD5_DIGEST_LENGTH) \
  DIGEST(sha1, CC_SHA1, CC_SHA1_DIGEST_LENGTH) \
  DIGEST(sha224, CC_SHA224, CC_SHA224_DIGEST_LENGTH) \
  DIGEST(sha256, CC_SHA256, CC_SHA256_DIGEST_LENGTH) \
  DIGEST(sha384, CC_SHA384, CC_SHA384_DIGEST_LENGTH) \
  DIGEST(sha512, CC_SHA512, CC_SHA512_DIGEST_LENGTH)

#define DIGEST(NAME, FUNC, LEN) \
  - (NSData *)NAME ## Data; \
  - (NSString *)NAME;

@interface NSString (digest)

// - (NSData *)md5Data
// - (NSString *)md5,
// ... etc
DIGESTS

@end
