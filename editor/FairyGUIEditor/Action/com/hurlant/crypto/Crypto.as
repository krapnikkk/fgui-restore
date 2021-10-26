package com.hurlant.crypto
{
    import *.*;
    import com.hurlant.crypto.hash.*;
    import com.hurlant.crypto.prng.*;
    import com.hurlant.crypto.rsa.*;
    import com.hurlant.crypto.symmetric.*;
    import com.hurlant.util.*;
    import flash.utils.*;

    public class Crypto extends Object
    {
        private var b64:Base64;

        public function Crypto()
        {
            return;
        }// end function

        public static function getCipher(param1:String, param2:ByteArray, param3:IPad = null) : ICipher
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            _loc_4 = param1.split("-");
            switch(_loc_4[0])
            {
                case "simple":
                {
                    _loc_4.shift();
                    param1 = _loc_4.join("-");
                    _loc_5 = getCipher(param1, param2, param3);
                    if (_loc_5 is IVMode)
                    {
                        return new SimpleIVMode(_loc_5 as IVMode);
                    }
                    return _loc_5;
                }
                case "aes":
                case "aes128":
                case "aes192":
                case "aes256":
                {
                    _loc_4.shift();
                    if (param2.length * 8 == _loc_4[0])
                    {
                        _loc_4.shift();
                    }
                    return getMode(_loc_4[0], new AESKey(param2), param3);
                }
                case "bf":
                case "blowfish":
                {
                    _loc_4.shift();
                    return getMode(_loc_4[0], new BlowFishKey(param2), param3);
                }
                case "des":
                {
                    _loc_4.shift();
                    if (_loc_4[0] != "ede" && _loc_4[0] != "ede3")
                    {
                        return getMode(_loc_4[0], new DESKey(param2), param3);
                    }
                    if (_loc_4.length == 1)
                    {
                        _loc_4.push("ecb");
                    }
                }
                case "3des":
                case "des3":
                {
                    _loc_4.shift();
                    return getMode(_loc_4[0], new TripleDESKey(param2), param3);
                }
                case "xtea":
                {
                    _loc_4.shift();
                    return getMode(_loc_4[0], new XTeaKey(param2), param3);
                }
                case "rc4":
                {
                    _loc_4.shift();
                    return new ARC4(param2);
                }
                default:
                {
                    break;
                }
            }
            return null;
        }// end function

        public static function getHash(param1:String) : IHash
        {
            switch(param1)
            {
                case "md2":
                {
                    return new MD2();
                }
                case "md5":
                {
                    return new MD5();
                }
                case "sha":
                case "sha1":
                {
                    return new SHA1();
                }
                case "sha224":
                {
                    return new SHA224();
                }
                case "sha256":
                {
                    return new SHA256();
                }
                default:
                {
                    break;
                }
            }
            return null;
        }// end function

        public static function getRSA(param1:String, param2:String) : RSAKey
        {
            return RSAKey.parsePublicKey(param2, param1);
        }// end function

        private static function getMode(param1:String, param2:ISymmetricKey, param3:IPad = null) : IMode
        {
            switch(param1)
            {
                case "ecb":
                {
                    return new ECBMode(param2, param3);
                }
                case "cfb":
                {
                    return new CFBMode(param2, param3);
                }
                case "cfb8":
                {
                    return new CFB8Mode(param2, param3);
                }
                case "ofb":
                {
                    return new OFBMode(param2, param3);
                }
                case "ctr":
                {
                    return new CTRMode(param2, param3);
                }
                case "cbc":
                {
                }
                default:
                {
                    return new CBCMode(param2, param3);
                    break;
                }
            }
        }// end function

        public static function getKeySize(param1:String) : uint
        {
            var _loc_2:* = null;
            _loc_2 = param1.split("-");
            switch(_loc_2[0])
            {
                case "simple":
                {
                    _loc_2.shift();
                    return getKeySize(_loc_2.join("-"));
                }
                case "aes128":
                {
                    return 16;
                }
                case "aes192":
                {
                    return 24;
                }
                case "aes256":
                {
                    return 32;
                }
                case "aes":
                {
                    _loc_2.shift();
                    return parseInt(_loc_2[0]) / 8;
                }
                case "bf":
                case "blowfish":
                {
                    return 16;
                }
                case "des":
                {
                    _loc_2.shift();
                    switch(_loc_2[0])
                    {
                        case "ede":
                        {
                            return 16;
                        }
                        case "ede3":
                        {
                            return 24;
                        }
                        default:
                        {
                            return 8;
                            break;
                        }
                    }
                }
                case "3des":
                case "des3":
                {
                    return 24;
                }
                case "xtea":
                {
                    return 8;
                }
                case "rc4":
                {
                    if (parseInt(_loc_2[1]) > 0)
                    {
                        return parseInt(_loc_2[1]) / 8;
                    }
                    return 16;
                }
                default:
                {
                    break;
                }
            }
            return 0;
        }// end function

        public static function getPad(param1:String) : IPad
        {
            switch(param1)
            {
                case "null":
                {
                    return new NullPad();
                }
                case "pkcs5":
                {
                }
                default:
                {
                    return new PKCS5();
                    break;
                }
            }
        }// end function

        public static function getHMAC(param1:String) : HMAC
        {
            var _loc_2:* = null;
            var _loc_3:* = 0;
            _loc_2 = param1.split("-");
            if (_loc_2[0] == "hmac")
            {
                _loc_2.shift();
            }
            _loc_3 = 0;
            if (_loc_2.length > 1)
            {
                _loc_3 = parseInt(_loc_2[1]);
            }
            return new HMAC(getHash(_loc_2[0]), _loc_3);
        }// end function

    }
}
