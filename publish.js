"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    Object.defineProperty(o, k2, { enumerable: true, get: function() { return m[k]; } });
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
var bytebuffer_1 = __importDefault(require("bytebuffer"));
var fs = __importStar(require("fs"));
var id = "id", pkgName = "name", version = 2, compress = false;
var ba = new bytebuffer_1.default();
ba.writeByte("F".charCodeAt(0));
ba.writeByte("G".charCodeAt(0));
ba.writeByte("U".charCodeAt(0));
ba.writeByte("I".charCodeAt(0));
ba.writeInt(version); // version
ba.writeByte(0); // compress
writeString(ba, id);
writeString(ba, pkgName);
var i = 0;
while (i < 20) {
    ba.writeByte(0);
    i++;
}
FU(ba, 6, false);
fs.writeFileSync("./output/test.bin", ba.buffer);
function writeString(ba, str) {
    var len = str.length;
    ba.writeUint16(len);
    ba.writeString(str);
}
function writeBoolean(ba, bool) {
    var num = bool ? 1 : 0;
    ba.writeByte(num);
}
function FU(ba, len, flag) {
    ba.writeByte(len);
    writeBoolean(ba, flag);
    var _loc_4 = 0;
    while (_loc_4 < len) {
        if (flag) {
            ba.writeShort(0);
        }
        else {
            ba.writeInt(0);
        }
        _loc_4++;
    }
}
