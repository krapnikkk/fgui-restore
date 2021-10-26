// const ByteArray = require('./ByteArray');
var ByteBuffer = require("bytebuffer");
const fs = require('fs');
// let arrayBuffer = new ArrayBuffer(1000);
let ba = new ByteBuffer();
ba.writeByte("F".charCodeAt(0));
ba.writeByte("G".charCodeAt(0));
ba.writeByte("U".charCodeAt(0));
ba.writeByte("I".charCodeAt(0));
ba.writeInt(2); // version
ba.writeInt32(1,4); // compress
// ba.writeCString("id"); // id
// ba.writeCString("name");// name
// console.log(ba.buffer.byteLength);

ba.writeUint16(ba.buffer.byteLength); // 写入字符长度
ba.writeString("id"); // id
ba.writeUint16(ba.buffer.byteLength);
ba.writeString("name");// name
let i = 0;
while (i < 20) {
    ba.writeByte(0);
    i++;
}
fs.writeFileSync("./output/test.bin", ba.buffer);
