package com.codeazur.as3swf
{
    import com.codeazur.as3swf.data.*;
    import com.codeazur.as3swf.data.actions.*;
    import com.codeazur.as3swf.data.filters.*;
    import com.codeazur.as3swf.factories.*;
    import com.codeazur.utils.*;
    import flash.utils.*;

    public class SWFData extends BitArray
    {
        public static const FLOAT16_EXPONENT_BASE:Number = 15;

        public function SWFData()
        {
            endian = Endian.LITTLE_ENDIAN;
            return;
        }// end function

        public function readSI8() : int
        {
            resetBitsPending();
            return readByte();
        }// end function

        public function writeSI8(param1:int) : void
        {
            resetBitsPending();
            writeByte(param1);
            return;
        }// end function

        public function readSI16() : int
        {
            resetBitsPending();
            return readShort();
        }// end function

        public function writeSI16(param1:int) : void
        {
            resetBitsPending();
            writeShort(param1);
            return;
        }// end function

        public function readSI32() : int
        {
            resetBitsPending();
            return readInt();
        }// end function

        public function writeSI32(param1:int) : void
        {
            resetBitsPending();
            writeInt(param1);
            return;
        }// end function

        public function readUI8() : uint
        {
            resetBitsPending();
            return readUnsignedByte();
        }// end function

        public function writeUI8(param1:uint) : void
        {
            resetBitsPending();
            writeByte(param1);
            return;
        }// end function

        public function readUI16() : uint
        {
            resetBitsPending();
            return readUnsignedShort();
        }// end function

        public function writeUI16(param1:uint) : void
        {
            resetBitsPending();
            writeShort(param1);
            return;
        }// end function

        public function readUI24() : uint
        {
            resetBitsPending();
            var _loc_1:* = readUnsignedShort();
            var _loc_2:* = readUnsignedByte();
            return _loc_2 << 16 | _loc_1;
        }// end function

        public function writeUI24(param1:uint) : void
        {
            resetBitsPending();
            writeShort(param1 & 65535);
            writeByte(param1 >> 16);
            return;
        }// end function

        public function readUI32() : uint
        {
            resetBitsPending();
            return readUnsignedInt();
        }// end function

        public function writeUI32(param1:uint) : void
        {
            resetBitsPending();
            writeUnsignedInt(param1);
            return;
        }// end function

        public function readFIXED() : Number
        {
            resetBitsPending();
            return readInt() / 65536;
        }// end function

        public function writeFIXED(param1:Number) : void
        {
            resetBitsPending();
            writeInt(int(param1 * 65536));
            return;
        }// end function

        public function readFIXED8() : Number
        {
            resetBitsPending();
            return readShort() / 256;
        }// end function

        public function writeFIXED8(param1:Number) : void
        {
            resetBitsPending();
            writeShort(int(param1 * 256));
            return;
        }// end function

        public function readFLOAT() : Number
        {
            resetBitsPending();
            return readFloat();
        }// end function

        public function writeFLOAT(param1:Number) : void
        {
            resetBitsPending();
            writeFloat(param1);
            return;
        }// end function

        public function readDOUBLE() : Number
        {
            resetBitsPending();
            return readDouble();
        }// end function

        public function writeDOUBLE(param1:Number) : void
        {
            resetBitsPending();
            writeDouble(param1);
            return;
        }// end function

        public function readFLOAT16() : Number
        {
            resetBitsPending();
            var _loc_1:* = readUnsignedShort();
            var _loc_2:* = (_loc_1 & 32768) != 0 ? (-1) : (1);
            var _loc_3:* = _loc_1 >> 10 & 31;
            var _loc_4:* = _loc_1 & 1023;
            if (_loc_3 == 0)
            {
                if (_loc_4 == 0)
                {
                    return 0;
                }
                return _loc_2 * Math.pow(2, 1 - FLOAT16_EXPONENT_BASE) * (_loc_4 / 1024);
            }
            if (_loc_3 == 31)
            {
                if (_loc_4 == 0)
                {
                    return _loc_2 < 0 ? (Number.NEGATIVE_INFINITY) : (Number.POSITIVE_INFINITY);
                }
                else
                {
                    return Number.NaN;
                }
            }
            return _loc_2 * Math.pow(2, _loc_3 - FLOAT16_EXPONENT_BASE) * (1 + _loc_4 / 1024);
        }// end function

        public function writeFLOAT16(param1:Number) : void
        {
            HalfPrecisionWriter.write(param1, this);
            return;
        }// end function

        public function readEncodedU32() : uint
        {
            resetBitsPending();
            var _loc_1:* = readUnsignedByte();
            if (_loc_1 & 128)
            {
                _loc_1 = _loc_1 & 127 | readUnsignedByte() << 7;
                if (_loc_1 & 16384)
                {
                    _loc_1 = _loc_1 & 16383 | readUnsignedByte() << 14;
                    if (_loc_1 & 2097152)
                    {
                        _loc_1 = _loc_1 & 2097151 | readUnsignedByte() << 21;
                        if (_loc_1 & 268435456)
                        {
                            _loc_1 = _loc_1 & 268435455 | readUnsignedByte() << 28;
                        }
                    }
                }
            }
            return _loc_1;
        }// end function

        public function writeEncodedU32(param1:uint) : void
        {
            var _loc_2:* = 0;
            while (true)
            {
                
                _loc_2 = param1 & 127;
                var _loc_3:* = param1 >> 7;
                param1 = param1 >> 7;
                if (_loc_3 == 0)
                {
                    this.writeUI8(_loc_2);
                    break;
                }
                this.writeUI8(_loc_2 | 128);
            }
            return;
        }// end function

        public function readUB(param1:uint) : uint
        {
            return readBits(param1);
        }// end function

        public function writeUB(param1:uint, param2:uint) : void
        {
            writeBits(param1, param2);
            return;
        }// end function

        public function readSB(param1:uint) : int
        {
            var _loc_2:* = 32 - param1;
            return int(readBits(param1) << _loc_2) >> _loc_2;
        }// end function

        public function writeSB(param1:uint, param2:int) : void
        {
            writeBits(param1, param2);
            return;
        }// end function

        public function readFB(param1:uint) : Number
        {
            return Number(this.readSB(param1)) / 65536;
        }// end function

        public function writeFB(param1:uint, param2:Number) : void
        {
            this.writeSB(param1, param2 * 65536);
            return;
        }// end function

        public function readString() : String
        {
            var _loc_1:* = position;
            while (this[_loc_1++])
            {
                
            }
            resetBitsPending();
            return readUTFBytes(_loc_1 - position);
        }// end function

        public function writeString(param1:String) : void
        {
            if (param1 && param1.length > 0)
            {
                writeUTFBytes(param1);
            }
            writeByte(0);
            return;
        }// end function

        public function readLANGCODE() : uint
        {
            resetBitsPending();
            return readUnsignedByte();
        }// end function

        public function writeLANGCODE(param1:uint) : void
        {
            resetBitsPending();
            writeByte(param1);
            return;
        }// end function

        public function readRGB() : uint
        {
            resetBitsPending();
            var _loc_1:* = readUnsignedByte();
            var _loc_2:* = readUnsignedByte();
            var _loc_3:* = readUnsignedByte();
            return 4278190080 | _loc_1 << 16 | _loc_2 << 8 | _loc_3;
        }// end function

        public function writeRGB(param1:uint) : void
        {
            resetBitsPending();
            writeByte(param1 >> 16 & 255);
            writeByte(param1 >> 8 & 255);
            writeByte(param1 & 255);
            return;
        }// end function

        public function readRGBA() : uint
        {
            resetBitsPending();
            var _loc_1:* = this.readRGB() & 16777215;
            var _loc_2:* = readUnsignedByte();
            return _loc_2 << 24 | _loc_1;
        }// end function

        public function writeRGBA(param1:uint) : void
        {
            resetBitsPending();
            this.writeRGB(param1);
            writeByte(param1 >> 24 & 255);
            return;
        }// end function

        public function readARGB() : uint
        {
            resetBitsPending();
            var _loc_1:* = readUnsignedByte();
            var _loc_2:* = this.readRGB() & 16777215;
            return _loc_1 << 24 | _loc_2;
        }// end function

        public function writeARGB(param1:uint) : void
        {
            resetBitsPending();
            writeByte(param1 >> 24 & 255);
            this.writeRGB(param1);
            return;
        }// end function

        public function readRECT() : SWFRectangle
        {
            return new SWFRectangle(this);
        }// end function

        public function writeRECT(param1:SWFRectangle) : void
        {
            param1.publish(this);
            return;
        }// end function

        public function readMATRIX() : SWFMatrix
        {
            return new SWFMatrix(this);
        }// end function

        public function writeMATRIX(param1:SWFMatrix) : void
        {
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            this.resetBitsPending();
            var _loc_2:* = param1.scaleX != 1 || param1.scaleY != 1;
            var _loc_3:* = param1.rotateSkew0 != 0 || param1.rotateSkew1 != 0;
            writeBits(1, _loc_2 ? (1) : (0));
            if (_loc_2)
            {
                if (param1.scaleX == 0 && param1.scaleY == 0)
                {
                    _loc_5 = 1;
                }
                else
                {
                    _loc_5 = calculateMaxBits(true, [param1.scaleX * 65536, param1.scaleY * 65536]);
                }
                this.writeUB(5, _loc_5);
                this.writeFB(_loc_5, param1.scaleX);
                this.writeFB(_loc_5, param1.scaleY);
            }
            writeBits(1, _loc_3 ? (1) : (0));
            if (_loc_3)
            {
                _loc_6 = calculateMaxBits(true, [param1.rotateSkew0 * 65536, param1.rotateSkew1 * 65536]);
                this.writeUB(5, _loc_6);
                this.writeFB(_loc_6, param1.rotateSkew0);
                this.writeFB(_loc_6, param1.rotateSkew1);
            }
            var _loc_4:* = calculateMaxBits(true, [param1.translateX, param1.translateY]);
            this.writeUB(5, _loc_4);
            this.writeSB(_loc_4, param1.translateX);
            this.writeSB(_loc_4, param1.translateY);
            return;
        }// end function

        public function readCXFORM() : SWFColorTransform
        {
            return new SWFColorTransform(this);
        }// end function

        public function writeCXFORM(param1:SWFColorTransform) : void
        {
            param1.publish(this);
            return;
        }// end function

        public function readCXFORMWITHALPHA() : SWFColorTransformWithAlpha
        {
            return new SWFColorTransformWithAlpha(this);
        }// end function

        public function writeCXFORMWITHALPHA(param1:SWFColorTransformWithAlpha) : void
        {
            param1.publish(this);
            return;
        }// end function

        public function readSHAPE(param1:Number = 20) : SWFShape
        {
            return new SWFShape(this, 1, param1);
        }// end function

        public function writeSHAPE(param1:SWFShape) : void
        {
            param1.publish(this);
            return;
        }// end function

        public function readSHAPEWITHSTYLE(param1:uint = 1, param2:Number = 20) : SWFShapeWithStyle
        {
            return new SWFShapeWithStyle(this, param1, param2);
        }// end function

        public function writeSHAPEWITHSTYLE(param1:SWFShapeWithStyle, param2:uint = 1) : void
        {
            param1.publish(this, param2);
            return;
        }// end function

        public function readSTRAIGHTEDGERECORD(param1:uint) : SWFShapeRecordStraightEdge
        {
            return new SWFShapeRecordStraightEdge(this, param1);
        }// end function

        public function writeSTRAIGHTEDGERECORD(param1:SWFShapeRecordStraightEdge) : void
        {
            param1.publish(this);
            return;
        }// end function

        public function readCURVEDEDGERECORD(param1:uint) : SWFShapeRecordCurvedEdge
        {
            return new SWFShapeRecordCurvedEdge(this, param1);
        }// end function

        public function writeCURVEDEDGERECORD(param1:SWFShapeRecordCurvedEdge) : void
        {
            param1.publish(this);
            return;
        }// end function

        public function readSTYLECHANGERECORD(param1:uint, param2:uint, param3:uint, param4:uint = 1) : SWFShapeRecordStyleChange
        {
            return new SWFShapeRecordStyleChange(this, param1, param2, param3, param4);
        }// end function

        public function writeSTYLECHANGERECORD(param1:SWFShapeRecordStyleChange, param2:uint, param3:uint, param4:uint = 1) : void
        {
            param1.numFillBits = param2;
            param1.numLineBits = param3;
            param1.publish(this, param4);
            return;
        }// end function

        public function readFILLSTYLE(param1:uint = 1) : SWFFillStyle
        {
            return new SWFFillStyle(this, param1);
        }// end function

        public function writeFILLSTYLE(param1:SWFFillStyle, param2:uint = 1) : void
        {
            param1.publish(this, param2);
            return;
        }// end function

        public function readLINESTYLE(param1:uint = 1) : SWFLineStyle
        {
            return new SWFLineStyle(this, param1);
        }// end function

        public function writeLINESTYLE(param1:SWFLineStyle, param2:uint = 1) : void
        {
            param1.publish(this, param2);
            return;
        }// end function

        public function readLINESTYLE2(param1:uint = 1) : SWFLineStyle2
        {
            return new SWFLineStyle2(this, param1);
        }// end function

        public function writeLINESTYLE2(param1:SWFLineStyle2, param2:uint = 1) : void
        {
            param1.publish(this, param2);
            return;
        }// end function

        public function readBUTTONRECORD(param1:uint = 1) : SWFButtonRecord
        {
            if (this.readUI8() == 0)
            {
                return null;
            }
            var _loc_3:* = position - 1;
            position = _loc_3;
            return new SWFButtonRecord(this, param1);
        }// end function

        public function writeBUTTONRECORD(param1:SWFButtonRecord, param2:uint = 1) : void
        {
            param1.publish(this, param2);
            return;
        }// end function

        public function readBUTTONCONDACTION() : SWFButtonCondAction
        {
            return new SWFButtonCondAction(this);
        }// end function

        public function writeBUTTONCONDACTION(param1:SWFButtonCondAction) : void
        {
            param1.publish(this);
            return;
        }// end function

        public function readFILTER() : IFilter
        {
            var _loc_1:* = this.readUI8();
            var _loc_2:* = SWFFilterFactory.create(_loc_1);
            _loc_2.parse(this);
            return _loc_2;
        }// end function

        public function writeFILTER(param1:IFilter) : void
        {
            this.writeUI8(param1.id);
            param1.publish(this);
            return;
        }// end function

        public function readTEXTRECORD(param1:uint, param2:uint, param3:SWFTextRecord = null, param4:uint = 1) : SWFTextRecord
        {
            if (this.readUI8() == 0)
            {
                return null;
            }
            var _loc_6:* = position - 1;
            position = _loc_6;
            return new SWFTextRecord(this, param1, param2, param3, param4);
        }// end function

        public function writeTEXTRECORD(param1:SWFTextRecord, param2:uint, param3:uint, param4:SWFTextRecord = null, param5:uint = 1) : void
        {
            param1.publish(this, param2, param3, param4, param5);
            return;
        }// end function

        public function readGLYPHENTRY(param1:uint, param2:uint) : SWFGlyphEntry
        {
            return new SWFGlyphEntry(this, param1, param2);
        }// end function

        public function writeGLYPHENTRY(param1:SWFGlyphEntry, param2:uint, param3:uint) : void
        {
            param1.publish(this, param2, param3);
            return;
        }// end function

        public function readZONERECORD() : SWFZoneRecord
        {
            return new SWFZoneRecord(this);
        }// end function

        public function writeZONERECORD(param1:SWFZoneRecord) : void
        {
            param1.publish(this);
            return;
        }// end function

        public function readZONEDATA() : SWFZoneData
        {
            return new SWFZoneData(this);
        }// end function

        public function writeZONEDATA(param1:SWFZoneData) : void
        {
            param1.publish(this);
            return;
        }// end function

        public function readKERNINGRECORD(param1:Boolean) : SWFKerningRecord
        {
            return new SWFKerningRecord(this, param1);
        }// end function

        public function writeKERNINGRECORD(param1:SWFKerningRecord, param2:Boolean) : void
        {
            param1.publish(this, param2);
            return;
        }// end function

        public function readGRADIENT(param1:uint = 1) : SWFGradient
        {
            return new SWFGradient(this, param1);
        }// end function

        public function writeGRADIENT(param1:SWFGradient, param2:uint = 1) : void
        {
            param1.publish(this, param2);
            return;
        }// end function

        public function readFOCALGRADIENT(param1:uint = 1) : SWFFocalGradient
        {
            return new SWFFocalGradient(this, param1);
        }// end function

        public function writeFOCALGRADIENT(param1:SWFFocalGradient, param2:uint = 1) : void
        {
            param1.publish(this, param2);
            return;
        }// end function

        public function readGRADIENTRECORD(param1:uint = 1) : SWFGradientRecord
        {
            return new SWFGradientRecord(this, param1);
        }// end function

        public function writeGRADIENTRECORD(param1:SWFGradientRecord, param2:uint = 1) : void
        {
            param1.publish(this, param2);
            return;
        }// end function

        public function readMORPHFILLSTYLE(param1:uint = 1) : SWFMorphFillStyle
        {
            return new SWFMorphFillStyle(this, param1);
        }// end function

        public function writeMORPHFILLSTYLE(param1:SWFMorphFillStyle, param2:uint = 1) : void
        {
            param1.publish(this, param2);
            return;
        }// end function

        public function readMORPHLINESTYLE(param1:uint = 1) : SWFMorphLineStyle
        {
            return new SWFMorphLineStyle(this, param1);
        }// end function

        public function writeMORPHLINESTYLE(param1:SWFMorphLineStyle, param2:uint = 1) : void
        {
            param1.publish(this, param2);
            return;
        }// end function

        public function readMORPHLINESTYLE2(param1:uint = 1) : SWFMorphLineStyle2
        {
            return new SWFMorphLineStyle2(this, param1);
        }// end function

        public function writeMORPHLINESTYLE2(param1:SWFMorphLineStyle2, param2:uint = 1) : void
        {
            param1.publish(this, param2);
            return;
        }// end function

        public function readMORPHGRADIENT(param1:uint = 1) : SWFMorphGradient
        {
            return new SWFMorphGradient(this, param1);
        }// end function

        public function writeMORPHGRADIENT(param1:SWFMorphGradient, param2:uint = 1) : void
        {
            param1.publish(this, param2);
            return;
        }// end function

        public function readMORPHFOCALGRADIENT(param1:uint = 1) : SWFMorphFocalGradient
        {
            return new SWFMorphFocalGradient(this, param1);
        }// end function

        public function writeMORPHFOCALGRADIENT(param1:SWFMorphFocalGradient, param2:uint = 1) : void
        {
            param1.publish(this, param2);
            return;
        }// end function

        public function readMORPHGRADIENTRECORD() : SWFMorphGradientRecord
        {
            return new SWFMorphGradientRecord(this);
        }// end function

        public function writeMORPHGRADIENTRECORD(param1:SWFMorphGradientRecord) : void
        {
            param1.publish(this);
            return;
        }// end function

        public function readACTIONRECORD() : IAction
        {
            var _loc_2:* = null;
            var _loc_4:* = 0;
            var _loc_1:* = position;
            var _loc_3:* = this.readUI8();
            if (_loc_3 != 0)
            {
                _loc_4 = _loc_3 >= 128 ? (this.readUI16()) : (0);
                _loc_2 = SWFActionFactory.create(_loc_3, _loc_4, _loc_1);
                _loc_2.com.codeazur.as3swf.data.actions:IAction::parse(this);
            }
            return _loc_2;
        }// end function

        public function writeACTIONRECORD(param1:IAction) : void
        {
            param1.com.codeazur.as3swf.data.actions:IAction::publish(this);
            return;
        }// end function

        public function readACTIONVALUE() : SWFActionValue
        {
            return new SWFActionValue(this);
        }// end function

        public function writeACTIONVALUE(param1:SWFActionValue) : void
        {
            param1.publish(this);
            return;
        }// end function

        public function readREGISTERPARAM() : SWFRegisterParam
        {
            return new SWFRegisterParam(this);
        }// end function

        public function writeREGISTERPARAM(param1:SWFRegisterParam) : void
        {
            param1.publish(this);
            return;
        }// end function

        public function readSYMBOL() : SWFSymbol
        {
            return new SWFSymbol(this);
        }// end function

        public function writeSYMBOL(param1:SWFSymbol) : void
        {
            param1.publish(this);
            return;
        }// end function

        public function readSOUNDINFO() : SWFSoundInfo
        {
            return new SWFSoundInfo(this);
        }// end function

        public function writeSOUNDINFO(param1:SWFSoundInfo) : void
        {
            param1.publish(this);
            return;
        }// end function

        public function readSOUNDENVELOPE() : SWFSoundEnvelope
        {
            return new SWFSoundEnvelope(this);
        }// end function

        public function writeSOUNDENVELOPE(param1:SWFSoundEnvelope) : void
        {
            param1.publish(this);
            return;
        }// end function

        public function readCLIPACTIONS(param1:uint) : SWFClipActions
        {
            return new SWFClipActions(this, param1);
        }// end function

        public function writeCLIPACTIONS(param1:SWFClipActions, param2:uint) : void
        {
            param1.publish(this, param2);
            return;
        }// end function

        public function readCLIPACTIONRECORD(param1:uint) : SWFClipActionRecord
        {
            var _loc_2:* = position;
            var _loc_3:* = param1 >= 6 ? (this.readUI32()) : (this.readUI16());
            if (_loc_3 == 0)
            {
                return null;
            }
            position = _loc_2;
            return new SWFClipActionRecord(this, param1);
        }// end function

        public function writeCLIPACTIONRECORD(param1:SWFClipActionRecord, param2:uint) : void
        {
            param1.publish(this, param2);
            return;
        }// end function

        public function readCLIPEVENTFLAGS(param1:uint) : SWFClipEventFlags
        {
            return new SWFClipEventFlags(this, param1);
        }// end function

        public function writeCLIPEVENTFLAGS(param1:SWFClipEventFlags, param2:uint) : void
        {
            param1.publish(this, param2);
            return;
        }// end function

        public function readTagHeader() : SWFRecordHeader
        {
            var _loc_1:* = position;
            var _loc_2:* = this.readUI16();
            var _loc_3:* = _loc_2 & 63;
            if (_loc_3 == 63)
            {
                _loc_3 = this.readSI32();
            }
            return new SWFRecordHeader(_loc_2 >> 6, _loc_3, position - _loc_1);
        }// end function

        public function writeTagHeader(param1:uint, param2:uint, param3:Boolean = false) : void
        {
            if (param2 < 63 && !param3)
            {
                this.writeUI16(param1 << 6 | param2);
            }
            else
            {
                this.writeUI16(param1 << 6 | 63);
                this.writeSI32(param2);
            }
            return;
        }// end function

        public function swfUncompress(param1:String, param2:uint = 0) : void
        {
            var _loc_5:* = 0;
            var _loc_3:* = position;
            var _loc_4:* = new ByteArray();
            if (param1 == SWF.COMPRESSION_METHOD_ZLIB)
            {
                readBytes(_loc_4);
                _loc_4.position = 0;
                _loc_4.uncompress();
            }
            else if (param1 == SWF.COMPRESSION_METHOD_LZMA)
            {
                _loc_5 = 0;
                while (_loc_5 < 5)
                {
                    
                    _loc_4.writeByte(this[_loc_5 + 12]);
                    _loc_5 = _loc_5 + 1;
                }
                _loc_4.endian = Endian.LITTLE_ENDIAN;
                _loc_4.writeUnsignedInt(param2 - 8);
                _loc_4.writeUnsignedInt(0);
                position = 17;
                readBytes(_loc_4, 13);
                _loc_4.position = 0;
                _loc_4.uncompress(param1);
            }
            else
            {
                throw new Error("Unknown compression method: " + param1);
            }
            var _loc_6:* = _loc_3;
            position = _loc_3;
            length = _loc_6;
            writeBytes(_loc_4);
            position = _loc_3;
            return;
        }// end function

        public function swfCompress(param1:String) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = 0;
            var _loc_2:* = position;
            _loc_3 = new ByteArray();
            if (param1 == SWF.COMPRESSION_METHOD_ZLIB)
            {
                readBytes(_loc_3);
                _loc_3.position = 0;
                _loc_3.compress();
            }
            else
            {
                if (param1 == SWF.COMPRESSION_METHOD_LZMA)
                {
                    throw new Error("Can\'t publish LZMA compressed SWFs");
                    _loc_3.writeBytes(_loc_4, 13);
                }
                throw new Error("Unknown compression method: " + param1);
            }
            var _loc_6:* = _loc_2;
            position = _loc_2;
            length = _loc_6;
            writeBytes(_loc_3);
            return;
        }// end function

        public function readRawTag() : SWFRawTag
        {
            return new SWFRawTag(this);
        }// end function

        public function skipBytes(param1:uint) : void
        {
            position = position + param1;
            return;
        }// end function

        public static function dump(param1:ByteArray, param2:uint, param3:int = 0) : void
        {
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_4:* = param1.position;
            var _loc_10:* = Math.min(Math.max(_loc_4 + param3, 0), param1.length - param2);
            param1.position = Math.min(Math.max(_loc_4 + param3, 0), param1.length - param2);
            var _loc_5:* = _loc_10;
            var _loc_6:* = "[Dump] total length: " + param1.length + ", original position: " + _loc_4;
            var _loc_7:* = 0;
            while (_loc_7 < param2)
            {
                
                _loc_8 = param1.readUnsignedByte().toString(16);
                if (_loc_8.length == 1)
                {
                    _loc_8 = "0" + _loc_8;
                }
                if (_loc_7 % 16 == 0)
                {
                    _loc_9 = (_loc_5 + _loc_7).toString(16);
                    _loc_9 = "00000000".substr(0, 8 - _loc_9.length) + _loc_9;
                    _loc_6 = _loc_6 + ("\r" + _loc_9 + ": ");
                }
                _loc_8 = _loc_8 + " ";
                _loc_6 = _loc_6 + _loc_8;
                _loc_7 = _loc_7 + 1;
            }
            param1.position = _loc_4;
            trace(_loc_6);
            return;
        }// end function

    }
}
