export default class ByteArray {
	private static SIZE_OF_BOOLEAN:number = 1;
	private static SIZE_OF_INT8:number = 1;
	private static SIZE_OF_INT16:number = 2;
	private static SIZE_OF_INT32:number = 4;
	// private static SIZE_OF_UINT8:number = 1;
	private static SIZE_OF_UINT16:number = 2;
	private static SIZE_OF_UINT32:number = 4;
	private static SIZE_OF_FLOAT32:number = 4;
	private static SIZE_OF_FLOAT64:number = 8;

	public endian:string;
	constructor(buffer?:ArrayBuffer) {
		this.$setArrayBuffer(buffer || new ArrayBuffer(0));
		this.endian = Endian.BIG_ENDIAN;
	}
	
	public get buffer():ArrayBuffer {return this._data.buffer;}

	private _data:DataView;
	public get data():DataView {return this._data;}
	public set data(value:DataView) {
		this._data = value;
	}

	public get bufferOffset():number {return this._data.byteOffset;}

	private _position:number;
	public get position():number {return this._position;}
	public set position(value:number) {
		this._position = Math.max(0,Math.min(value,this.length));
	}

	public get length():number {
		return this._data.byteLength;
	}

	public set length(value:number) {
		if(this.length == value) return;

		let tmp:Uint8Array = new Uint8Array(new ArrayBuffer(value));
		tmp.set(new Uint8Array(this.buffer, 0+this.bufferOffset, Math.min(this.length, value)));
		this._data = new DataView(tmp.buffer);

		this._position = Math.min(this._position,value)
	}
	
	public get bytesAvailable():number {
		return this._data.byteLength - this._position;
	}

	public clear():void {
		this.$setArrayBuffer(new ArrayBuffer(0));
	}

	public readBoolean():boolean {
		console.assert(this.bytesAvailable >= 1,"out of range");
		return this._data.getUint8(this.position++) != 0;
	}

	public readByte():number {
		console.assert(this.bytesAvailable >= 1,"out of range");
		return this._data.getInt8(this.position++);
	}

	public readBytes(bytes:ByteArray, offset:number = 0, length:number = 0):void {
		length = length || this.bytesAvailable;

		console.assert(this.bytesAvailable >= length,"out of range");

		bytes.position = offset;
		bytes.writeUint8Array(new Uint8Array(this.buffer,this._position+this.bufferOffset,length));
		this.position += length;
		// bytes.validateBuffer(offset + length);
		// for (let i = 0; i < length; i++) {
		// 	bytes._data.setUint8(i + offset, this._data.getUint8(this.position++));
		// }
	}

	public readDouble():number {
		console.assert(this.bytesAvailable >= ByteArray.SIZE_OF_FLOAT64,"out of range");

		let value:number = this._data.getFloat64(this.position, this.endian == Endian.LITTLE_ENDIAN);
		this.position += ByteArray.SIZE_OF_FLOAT64;
		return value;
	}

	public readFloat():number {
		console.assert(this.bytesAvailable >= ByteArray.SIZE_OF_FLOAT32,"out of range");

		let value:number = this._data.getFloat32(this.position, this.endian == Endian.LITTLE_ENDIAN);
		this.position += ByteArray.SIZE_OF_FLOAT32;
		return value;
	}

	public readInt():number {
		console.assert(this.bytesAvailable >= ByteArray.SIZE_OF_INT32,"out of range");

		let value = this._data.getInt32(this.position, this.endian == Endian.LITTLE_ENDIAN);
		this.position += ByteArray.SIZE_OF_INT32;
		return value;
	}

	public readShort():number {
		console.assert(this.bytesAvailable >= ByteArray.SIZE_OF_INT16,"out of range");

		let value = this._data.getInt16(this.position, this.endian == Endian.LITTLE_ENDIAN);
		this.position += ByteArray.SIZE_OF_INT16;
		return value;
	}

	public readUnsignedByte():number {
		console.assert(this.bytesAvailable >= 1,"out of range");

		return this._data.getUint8(this.position++);
	}

	public readUnsignedInt():number {
		console.assert(this.bytesAvailable >= ByteArray.SIZE_OF_UINT32,"out of range");

		let value = this._data.getUint32(this.position, this.endian == Endian.LITTLE_ENDIAN);
		this.position += ByteArray.SIZE_OF_UINT32;
		return value;
	}

	public readUnsignedShort():number {
		console.assert(this.bytesAvailable >= ByteArray.SIZE_OF_UINT16,"out of range");

		let value = this._data.getUint16(this.position, this.endian == Endian.LITTLE_ENDIAN);
		this.position += ByteArray.SIZE_OF_UINT16;
		return value;
	}

	public readUTF():string {
		let length:number = this.readUnsignedShort();
		if(length == 0) return ""
		
		return this.readUTFBytes(length);
	}

	public readUTFBytes(length:number):string {
		console.assert(this.bytesAvailable >= length,"out of range");

		let bytes:Uint8Array = new Uint8Array(this.buffer, this.bufferOffset + this.position, length);
		this.position += length;

		return this.decodeUTF8(bytes);
	}

	public writeBoolean(value:boolean):void {
		this.checkSize(ByteArray.SIZE_OF_BOOLEAN);
		this._data.setUint8(this.position++, value ? 1 : 0);
	}

	public writeByte(value:number):void {
		this.checkSize(ByteArray.SIZE_OF_INT8);
		this._data.setInt8(this.position++, value);
	}

	public writeBytes(bytes:ByteArray, offset:number = 0, length:number = 0):void {
		if (offset < 0 || length < 0) return;

		let total = bytes.length - offset;
		length = length || total
		let writeLength:number = Math.min(total, length);
		if (writeLength == 0) return;

		this.checkSize(writeLength);

		// let tmp_data = new DataView(bytes.buffer);
		// let length = writeLength;
		// while(length-->0) {
		// 	this.data.setUint8(this.position++, tmp_data.getUint8(offset++));
		// }

		new Uint8Array(this.buffer,this.position + this.bufferOffset,writeLength)
		.set(new Uint8Array(bytes.buffer,offset+bytes.bufferOffset,writeLength));
		this.position+=writeLength;
	}

	public writeDouble(value:number):void {
		this.checkSize(ByteArray.SIZE_OF_FLOAT64);

		this._data.setFloat64(this.position, value, this.endian == Endian.LITTLE_ENDIAN);
		this.position += ByteArray.SIZE_OF_FLOAT64;
	}

	public writeFloat(value:number):void {
		this.checkSize(ByteArray.SIZE_OF_FLOAT32);

		this._data.setFloat32(this.position, value, this.endian == Endian.LITTLE_ENDIAN);
		this.position += ByteArray.SIZE_OF_FLOAT32;
	}

	public writeInt(value:number):void {
		this.checkSize(ByteArray.SIZE_OF_INT32);

		this._data.setInt32(this.position, value, this.endian == Endian.LITTLE_ENDIAN);
		this.position += ByteArray.SIZE_OF_INT32;
	}

	public writeShort(value:number):void {
		this.checkSize(ByteArray.SIZE_OF_INT16);

		this._data.setInt16(this.position, value, this.endian == Endian.LITTLE_ENDIAN);
		this.position += ByteArray.SIZE_OF_INT16;
	}

	public writeUnsignedInt(value:number):void {
		this.checkSize(ByteArray.SIZE_OF_UINT32);

		this._data.setUint32(this.position, value, this.endian == Endian.LITTLE_ENDIAN);
		this.position += ByteArray.SIZE_OF_UINT32;
	}

	public writeUnsignedShort(value:number):void {
		this.checkSize(ByteArray.SIZE_OF_UINT16);

		this._data.setUint16(this.position, value, this.endian == Endian.LITTLE_ENDIAN);
		this.position += ByteArray.SIZE_OF_UINT16;
	}

	public writeUTF(value:string):void {
		let utf8bytes:Uint8Array = this.encodeUTF8(value);
		let length:number = utf8bytes.length;
		this.writeUnsignedShort(length)
		this.writeUint8Array(utf8bytes);
	}

	public writeUTFBytes(value:string):void {
		this.writeUint8Array(this.encodeUTF8(value));
	}

	public toString():string {
		return "[ByteArray] length:" + this.length + ", bytesAvailable:" + this.bytesAvailable;
	}

	public writeUint8Array(bytes:Uint8Array):void {
		this.checkSize(bytes.length);

		new Uint8Array(this.buffer,this.position+this.bufferOffset).set(bytes);
		this.position+=bytes.length;
	}

	public getPlatformEndianness() {
		var buffer = new ArrayBuffer(2);
		new DataView(buffer).setInt16(0, 256, true);
		return new Int16Array(buffer)[0] === 256 
			? Endian.LITTLE_ENDIAN
			:Endian.BIG_ENDIAN;
	}

	private $setArrayBuffer(buffer:ArrayBuffer):void {
		this._data = new DataView(buffer);
		this._position = 0;
	}

	private checkSize(len:number):void {
		this.length = Math.max(len+this._position,this.length);
	}
	
	private encodeUTF8(str:string):Uint8Array {return UTF8.encode(str)}
	private decodeUTF8(data:Uint8Array):string {return UTF8.decode(data);}
}
class UTF8{
	static encode(str:string){return new UTF8().encode(str)}
	static decode(data:Uint8Array){return new UTF8().decode(data)}

	private EOF_byte:number = -1;
	private EOF_code_point:number = -1;
	private encoderError(code_point:number) {
		console.error("UTF8 encoderError",code_point)
	}
	private decoderError(fatal:boolean, opt_code_point?:number):number {
		if (fatal) console.error("UTF8 decoderError",opt_code_point)
		return opt_code_point || 0xFFFD;
	}
	private inRange(a:number, min:number, max:number) {
		return min <= a && a <= max;
	}
	private div(n:number, d:number) {
		return Math.floor(n / d);
	}
	private stringToCodePoints(string:string) {
		/** @type {Array.<number>} */
		let cps = [];
		// Based on http://www.w3.org/TR/WebIDL/#idl-DOMString
		let i = 0, n = string.length;
		while (i < string.length) {
			let c = string.charCodeAt(i);
			if (!this.inRange(c, 0xD800, 0xDFFF)) {
				cps.push(c);
			} else if (this.inRange(c, 0xDC00, 0xDFFF)) {
				cps.push(0xFFFD);
			} else { // (inRange(c, 0xD800, 0xDBFF))
				if (i == n - 1) {
					cps.push(0xFFFD);
				} else {
					let d = string.charCodeAt(i + 1);
					if (this.inRange(d, 0xDC00, 0xDFFF)) {
						let a = c & 0x3FF;
						let b = d & 0x3FF;
						i += 1;
						cps.push(0x10000 + (a << 10) + b);
					} else {
						cps.push(0xFFFD);
					}
				}
			}
			i += 1;
		}
		return cps;
	}

	private encode(str:string):Uint8Array {
		let pos:number = 0;
		let codePoints = this.stringToCodePoints(str);
		let outputBytes = [];

		while (codePoints.length > pos) {
			let code_point:number = codePoints[pos++];

			if (this.inRange(code_point, 0xD800, 0xDFFF)) {
				this.encoderError(code_point);
			}
			else if (this.inRange(code_point, 0x0000, 0x007f)) {
				outputBytes.push(code_point);
			} else {
				let count = 0, offset = 0;
				if (this.inRange(code_point, 0x0080, 0x07FF)) {
					count = 1;
					offset = 0xC0;
				} else if (this.inRange(code_point, 0x0800, 0xFFFF)) {
					count = 2;
					offset = 0xE0;
				} else if (this.inRange(code_point, 0x10000, 0x10FFFF)) {
					count = 3;
					offset = 0xF0;
				}

				outputBytes.push(this.div(code_point, Math.pow(64, count)) + offset);

				while (count > 0) {
					let temp = this.div(code_point, Math.pow(64, count - 1));
					outputBytes.push(0x80 + (temp % 64));
					count -= 1;
				}
			}
		}
		return new Uint8Array(outputBytes);
	}

	private decode(data:Uint8Array):string {
		let fatal:boolean = false;
		let pos:number = 0;
		let result:string = "";
		let code_point;
		let utf8_code_point = 0;
		let utf8_bytes_needed = 0;
		let utf8_bytes_seen = 0;
		let utf8_lower_boundary = 0;

		while (data.length > pos) {
			let _byte = data[pos++];

			if (_byte == this.EOF_byte) {
				if (utf8_bytes_needed != 0) {
					code_point = this.decoderError(fatal);
				} else {
					code_point = this.EOF_code_point;
				}
			} else {
				if (utf8_bytes_needed == 0) {
					if (this.inRange(_byte, 0x00, 0x7F)) {
						code_point = _byte;
					} else {
						if (this.inRange(_byte, 0xC2, 0xDF)) {
							utf8_bytes_needed = 1;
							utf8_lower_boundary = 0x80;
							utf8_code_point = _byte - 0xC0;
						} else if (this.inRange(_byte, 0xE0, 0xEF)) {
							utf8_bytes_needed = 2;
							utf8_lower_boundary = 0x800;
							utf8_code_point = _byte - 0xE0;
						} else if (this.inRange(_byte, 0xF0, 0xF4)) {
							utf8_bytes_needed = 3;
							utf8_lower_boundary = 0x10000;
							utf8_code_point = _byte - 0xF0;
						} else {
							this.decoderError(fatal);
						}
						utf8_code_point = utf8_code_point * Math.pow(64, utf8_bytes_needed);
						code_point = null;
					}
				} else if (!this.inRange(_byte, 0x80, 0xBF)) {
					utf8_code_point = 0;
					utf8_bytes_needed = 0;
					utf8_bytes_seen = 0;
					utf8_lower_boundary = 0;
					pos--;
					code_point = this.decoderError(fatal, _byte);
				} else {
					utf8_bytes_seen += 1;
					utf8_code_point = utf8_code_point + (_byte - 0x80) * Math.pow(64, utf8_bytes_needed - utf8_bytes_seen);

					if (utf8_bytes_seen !== utf8_bytes_needed) {
						code_point = null;
					} else {
						let cp = utf8_code_point;
						let lower_boundary = utf8_lower_boundary;
						utf8_code_point = 0;
						utf8_bytes_needed = 0;
						utf8_bytes_seen = 0;
						utf8_lower_boundary = 0;
						if (this.inRange(cp, lower_boundary, 0x10FFFF) && !this.inRange(cp, 0xD800, 0xDFFF)) {
							code_point = cp;
						} else {
							code_point = this.decoderError(fatal, _byte);
						}
					}

				}
			}
			//Decode string
			if (code_point !== null && code_point !== this.EOF_code_point) {
				if (code_point <= 0xFFFF) {
					if (code_point > 0)result += String.fromCharCode(code_point);
				} else {
					code_point -= 0x10000;
					result += String.fromCharCode(0xD800 + ((code_point >> 10) & 0x3ff));
					result += String.fromCharCode(0xDC00 + (code_point & 0x3ff));
				}
			}
		}
		return result;
	}
}

export class Endian {
	public static LITTLE_ENDIAN:string = "littleEndian";
	public static BIG_ENDIAN:string = "bigEndian";
}
