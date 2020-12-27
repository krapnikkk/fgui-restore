class ByteArray {
    stringTable;
    version = 0;
    littleEndian;
    _buffer;
    _view;
    _pos;
    _length;

    constructor(buffer, offset, length) {
        offset = offset || 0;
        if (length == null || length == -1)
            length = buffer.byteLength - offset;

        this._buffer = buffer;
        this._view = new DataView(this._buffer, offset, length);
        this._pos = 0;
        this._length = length;
    }

    get data() {
        return this._buffer;
    }

    get pos() {
        return this._pos;
    }

    set pos(value) {
        if (value > this._length) throw "Out of bounds";
        this._pos = value;
    }

    get length() {
        return this._length;
    }

    skip(count) {
        this._pos += count;
    }

    validate(forward) {
        if (this._pos + forward > this._length) throw "Out of bounds";
    }

    readByte() {
        this.validate(1);
        let ret = this._view.getUint8(this._pos);
        this._pos++;
        return ret;
    }

    readBool() {
        return this.readByte() == 1;
    }

    readShort() {
        this.validate(2);
        let ret = this._view.getInt16(this._pos, this.littleEndian);
        this._pos += 2;
        return ret;
    }

    readUshort() {
        this.validate(2);
        let ret = this._view.getUint16(this._pos, this.littleEndian);
        this._pos += 2;
        return ret;
    }

    readInt() {
        this.validate(4);
        let ret = this._view.getInt32(this._pos, this.littleEndian);
        this._pos += 4;
        return ret;
    }

    readUint() {
        this.validate(4);
        let ret = this._view.getUint32(this._pos, this.littleEndian);
        this._pos += 4;
        return ret;
    }

    readFloat() {
        this.validate(4);
        let ret = this._view.getFloat32(this._pos, this.littleEndian);
        this._pos += 4;
        return ret;
    }

    readString(len) {
        if (len == undefined) len = this.readUshort();
        this.validate(len);

        let decoder = new TextDecoder();
        let ret = decoder.decode(new DataView(this._buffer, this._view.byteOffset + this._pos, len));
        this._pos += len;

        return ret;
    }

    readS() {
        var index = this.readUshort();
        if (index == 65534) //null
            return null;
        else if (index == 65533)
            return ""
        else
            return this.stringTable[index];
    }

    readSArray(cnt) {
        var ret = new Array(cnt);
        for (var i = 0; i < cnt; i++)
            ret[i] = this.readS();

        return ret;
    }

    writeS(value) {
        var index = this.readUshort();
        if (index != 65534 && index != 65533)
            this.stringTable[index] = value;
    }

    readColor() {
        var r = this.readByte();
        var g = this.readByte();
        var b = this.readByte();
        this.readByte(); //a

        return (r << 16) + (g << 8) + b;
    }

    readFullColor() {
        var r = this.readByte();
        var g = this.readByte();
        var b = this.readByte();
        var a = this.readByte();
        return new Color4((r << 16) + (g << 8) + b, a / 255);
    }

    readChar() {
        var i = this.readUshort();
        return String.fromCharCode(i);
    }

    readBuffer() {
        var count = this.readUint();
        this.validate(count);
        var ba = new ByteArray(this._buffer, this._view.byteOffset + this._pos, count);
        ba.stringTable = this.stringTable;
        ba.version = this.version;
        this._pos += count;
        return ba;
    }
    

    seek(indexTablePos, blockIndex) {
        var tmp = this._pos;
        this._pos = indexTablePos;
        var segCount = this.readByte();
        if (blockIndex < segCount) {
            var useShort = this.readByte() == 1;
            var newPos;
            if (useShort) {
                this._pos += 2 * blockIndex;
                newPos = this.readUshort();
            }
            else {
                this._pos += 4 * blockIndex;
                newPos = this.readUint();
            }

            if (newPos > 0) {
                this._pos = indexTablePos + newPos;
                return true;
            }
            else {
                this._pos = tmp;
                return false;
            }
        }
        else {
            this._pos = tmp;
            return false;
        }
    }
}

module.exports = { ByteArray };