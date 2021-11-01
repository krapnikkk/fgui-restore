import ByteArray from "./ByteArray";
import * as fs from "fs";
const
    //  id: string = "id",
    // pkgName: string = "name",
    version: number = 2,
    compress: boolean = false;

console.log("====start====")

let ba = new ByteArray();
ba.writeByte("F".charCodeAt(0));
ba.writeByte("G".charCodeAt(0));
ba.writeByte("U".charCodeAt(0));
ba.writeByte("I".charCodeAt(0));

ba.writeInt(version); // version
// writeBoolean(ba, compress);// compress
// ba.writeUTF(id);
// writeString(ba, pkgName);
// doTask(ba);
if (compress) {
    // do compress
}



// FU(ba, 6, false);
// Pu(ba, 0);

// let loc7 = new ByteBuffer();
// startSegments(loc7, 6, false);
// writeSegmentPos(loc7, 0);

// let _loc9_ = [];
// var _loc26_: number = 0;
// var _loc22_: any;
// var _loc25_: any[] = _loc22_._dependentPackages;
// for (let key in _loc22_._dependentPackages) {
//     _loc9_.push(key);
// }

fs.writeFileSync("./output/test.bin", ba.data);

// function doTask(ba: ByteArray) {
//     let i = 0;
//     while (i < 20) {
//         ba.writeByte(0);
//         i++;
//     }
// }

// function writeString(ba: ByteArray, str: string) {
//     let len = str.length;
//     ba.writeUint16(len);
//     ba.writeString(str);
// }

// function writeBoolean(ba: ByteArray, bool: boolean) {
//     let num = bool ? 1 : 0;
//     ba.writeByte(num);
// }

// function readBoolean(ba: ByteArray): boolean {
//     return ba.readByte() == 1;
// }

// function FU(ba: ByteArray, len: number, flag: boolean) {
//     ba.writeByte(len);
//     writeBoolean(ba, flag);
//     var _loc_4 = 0;
//     while (_loc_4 < len) {
//         if (flag) {
//             ba.writeShort(0);
//         } else {
//             ba.writeInt(0);
//         }
//         _loc_4++;
//     }
// }

// function Pu(ba: ByteArray, param2: number): void {
//     var _loc_3 = ba.buffer.byteLength;
//     ba
//     ba.offset = 1;
//     var _loc_4 = readBoolean(ba);
//     ba.offset = 2 + param2 * (_loc_4 ? 2 : 4);
//     if (_loc_4) {
//         ba.writeShort(_loc_3);
//     }else {
//         ba.writeInt(_loc_3);
//     }
//     ba.offset = _loc_3;
// }

// function startSegments(ba: ByteBuffer, segment: number, bool: boolean): void {
//     ba.writeByte(segment);
//     writeBoolean(ba, bool);
//     var idx = 0;
//     while (idx < segment) {
//         if (bool) {
//             ba.writeShort(0);
//         }
//         else {
//             ba.writeInt(0);
//         }
//         idx++;
//     }
// }

// function writeSegmentPos(ba: ByteBuffer, pos: number) {
//     var position = ba.offset; // position
//     ba.offset = 1;
//     var _loc4_: Boolean = readBoolean(ba);
//     ba.offset = 2 + pos * (!!_loc4_ ? 2 : 4);
//     if (_loc4_) {
//         ba.writeShort(position);
//     }
//     else {
//         ba.writeInt(position);
//     }
//     ba.offset = position;
// }