const ByteBuffer = require("bytebuffer");
const { xml2json } = require('../utils/utils');
const fs = require('fs');

// fs.writeFileSync(`./output/${fileName}/package.xml`, fairyTML, { encoding: "utf-8" })
const createEntryFile = (path, file) => {
    fs.writeFileSync("./output/test.fairy", fairyTML, { encoding: "utf-8" })
}

const createMovieClip = async (data, srcImageInput, output) => {
    let { content, id, size } = data;
    let movieclipData = await xml2json(content);
    let width = size.split(',')[0];
    let height = size.split(',')[0];
    let { interval, swing, repeatDelay } = movieclipData["movieclip"]['$'];
    let frameList = movieclipData["movieclip"]['frames']['frame'];
    let version = 102;
    let movieClipHeader = "yytou";
    let len = frameList.length;
    let offset = 0;
    let buf = new ByteBuffer();
    let fps = 24;
    let speed = interval ? Math.floor(+interval / 1000 * fps) : 1;
    repeatDelay = repeatDelay ? Math.floor(+repeatDelay / +interval) : 0;
    buf.writeUint16(movieClipHeader.length, offset);
    offset += 2;
    buf.writeUTF8String(movieClipHeader, offset);
    offset += movieClipHeader.length;
    buf.writeInt32(version, offset) // version
    offset += 4;
    buf.writeUint8(fps, offset) // fps
    offset++;
    buf.writeUint8(0, offset)
    offset++;
    buf.writeUint8(0, offset)
    offset++;
    buf.writeUint8(0, offset)
    offset++;
    buf.writeUint16(0, offset) // boundRect.x
    offset += 2;
    buf.writeUint16(0, offset) // boundRect.y
    offset += 2;
    buf.writeUint16(+width, offset) // boundRect.width
    offset += 2;
    buf.writeUint16(+height, offset) // boundRect.height
    offset += 2;
    buf.writeUint8(speed, offset) // speed
    offset++;
    buf.writeUint8(repeatDelay, offset) // repeatDelay
    offset++;
    buf.writeUint8(swing ? 1 : 0, offset) // swing
    offset++;
    buf.writeUint16(len, offset);// frameList.length
    frameList.forEach((frame, index) => {
        let rect = frame['$']['rect'].split(",");
        let addDelay = Math.round(frame['$']['addDelay'] / 1000 * fps) || 0;
        offset += 2;
        buf.writeUint16(+addDelay, offset);
        offset += 2;
        buf.writeUint16(+rect[0], offset);
        offset += 2;
        buf.writeUint16(+rect[1], offset);
        offset += 2;
        buf.writeUint16(+rect[2], offset);
        offset += 2;
        buf.writeUint16(+rect[3], offset);
        offset += 2;
        buf.writeUint16(index, offset);
    })
    offset += 2;
    buf.writeUint16(len, offset);// textureList
    offset += 2;
    for (let i = 0; i < len; i++) {
        let item = `${srcImageInput}${id}_${i}.png`;
        let buffer = fs.readFileSync(item);
        buf.writeUint32(buffer.byteLength, offset);
        offset += 4;
        buf.append(buffer, "utf-8", offset);
        offset += buffer.byteLength;
    }
    fs.writeFileSync(output, buf.buffer);
    console.log("createMovieClip done");
}

exports.createEntryFile = createEntryFile;
exports.createMovieClip = createMovieClip;