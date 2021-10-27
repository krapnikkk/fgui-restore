import ByteBuffer from "bytebuffer";
import * as fs from "fs"; 
const id: string = "id", pkgName: string = "name", version: number = 2, compress: boolean = false;
let ba = new ByteBuffer();
ba.writeByte("F".charCodeAt(0));
ba.writeByte("G".charCodeAt(0));
ba.writeByte("U".charCodeAt(0));
ba.writeByte("I".charCodeAt(0));
ba.writeInt(version); // version
ba.writeByte(0); // compress
writeString(ba, id);
writeString(ba, pkgName);
let i = 0;
while (i < 20) {
    ba.writeByte(0);
    i++;
}
FU(ba, 6, false);
fs.writeFileSync("./output/test.bin", ba.buffer);

function writeString(ba: ByteBuffer, str: string) {
    let len = str.length;
    ba.writeUint16(len);
    ba.writeString(str);
}

function writeBoolean(ba: ByteBuffer, bool: boolean) {
    let num = bool ? 1 : 0;
    ba.writeByte(num);
}

function FU(ba: ByteBuffer, len: number, flag: boolean) {
    ba.writeByte(len);
    writeBoolean(ba,flag);
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