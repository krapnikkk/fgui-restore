const fs = require('fs');
const zlib = require("zlib");
const Jimp = require('jimp');
const resolve = require('path').resolve;
const { exists, xml2json, json2xml } = require('./utils/utils');
const { createMovieClip } = require('./build/create');
const { ByteArray } = require('./ByteArray');

const XMLHeader = '<?xml version="1.0" encoding="utf-8"?>\n';
const packageTML = `${XMLHeader}
<packageDescription id="{id}" type="{type}" version="3.0"/>
</packageDescription>`;


let improtFileName = "Basics",
    inputPath = "./dist/",
    outputPath = './output/',
    temp = '/temp/',
    tempPath = `${outputPath}${improtFileName}${temp}`;

let pkgName = "", pkgId = "";

const createByPackage = async (pkgData) => {
    // 处理package.xml 获取包名&id
    const packageData = await xml2json(pkgData["package.xml"]);
    pkgName = packageData["packageDescription"]['$']['name'];
    pkgId = packageData["packageDescription"]['$']['id'];

    // 校验纹理合图是否存在同一目录
    let atlasInfo = packageData["packageDescription"]['resources']['atlas'];
    handleAltas(atlasInfo);

    // 解析 sprites.bytes
    let imageInfo = packageData["packageDescription"]['resources']['image'];
    let spritesMap = parseSprites(pkgData['sprites.bytes']);
    imageInfo.forEach((item) => {
        let image = item['$'];
        let key = image['id'];
        Object.assign(spritesMap[key], image);
    })
    await handleSprites(spritesMap);

    let soundInfo = packageData["packageDescription"]['resources']['sound'];
    handleSound(soundInfo);

    let fontInfo = packageData["packageDescription"]['resources']['font'];
    let fontMap = {};
    fontInfo.forEach((item) => {
        let font = item['$'];
        let file = `${font['id']}.fnt`;
        font['content'] = pkgData[file];
        fontMap[file] = font;
    })
    createFileByData(fontMap, '.fnt');
    let movieclipInfo = packageData["packageDescription"]['resources']['movieclip'];
    let movieclipMap = {};
    movieclipInfo.forEach((item) => {
        let movieclip = item['$'];
        let file = `${movieclip['id']}.xml`;
        movieclip['content'] = pkgData[file];
        delete pkgData[file];
        movieclipMap[file] = movieclip;
    })

    await handleMovieclip(movieclipMap);

    let componentInfo = packageData["packageDescription"]['resources']['component'];
    let componentMap = {};
    componentInfo.forEach((item) => {
        let component = item['$'];
        let file = `${component['id']}.xml`;
        component['content'] = pkgData[file];
        componentMap[file] = component;
    })
    createFileByData(componentMap, ".xml");
    let path = resolve(tempPath);
    let files = fs.readdirSync(path);
    files.forEach((file) => {
        fs.unlinkSync(path + '/' + file);
    });
    fs.rmdirSync(path);
}

function decodeUncompressed(buf) {
    let ba = new ByteArray(buf);
    ba.littleEndian = true;
    let pos = ba.length - 22;
    ba.pos = pos + 10;
    let entryCount = ba.readUshort();
    ba.pos = pos + 16;
    pos = ba.readInt();
    let data = {};
    for (let i = 0; i < entryCount; i++) {
        ba.pos = pos + 28;
        let len = ba.readUshort();
        let len2 = ba.readUshort() + ba.readUshort();

        ba.pos = pos + 46;
        let entryName = ba.readString(len);

        if (entryName[entryName.length - 1] != '/' && entryName[entryName.length - 1] != '\\') //not directory
        {
            ba.pos = pos + 20;
            let size = ba.readInt();
            ba.pos = pos + 42;
            let offset = ba.readInt() + 30 + len;

            if (size > 0) {
                ba.pos = offset;
                data[entryName] = ba.readString(size);
            }
        }

        pos += 46 + len + len2;
    }
    return data;
}

function decodeBinary(buffer) {
    let ver2 = buffer.version >= 2;
    let indexTablePos = buffer.pos;
    let _items = [];
    let _pixelHitTestDatas = [];
    let _itemMap = {};
    let _sprites = {};
    let cnt;
    let i;
    let nextPos;
    let str;
    let branchIncluded;

    buffer.seek(indexTablePos, 4);

    cnt = buffer.readInt();
    let stringTable = [];
    for (i = 0; i < cnt; i++)
        stringTable[i] = buffer.readString();
    buffer.stringTable = stringTable;

    buffer.seek(indexTablePos, 0);
    cnt = buffer.readShort();
    let _dependencies = [];
    for (i = 0; i < cnt; i++)
        _dependencies.push({ id: buffer.readS(), name: buffer.readS() });

    if (ver2) {
        cnt = buffer.readShort();
        if (cnt > 0) {
            let _branches = buffer.readSArray(cnt);
            if (_branch) {
                let _branchIndex = _branches.indexOf(_branch);
                console.log(_branchIndex);
            }
        }

        branchIncluded = cnt > 0;
    }

    buffer.seek(indexTablePos, 1);


    let fileNamePrefix = pkgName + "_";

    cnt = buffer.readUshort();
    for (i = 0; i < cnt; i++) { // package.xml
        let pi = {};
        nextPos = buffer.readInt();
        nextPos += buffer.pos;
        pi.type = buffer.readByte();
        pi.id = buffer.readS();
        pi.name = buffer.readS();
        pi.path = buffer.readS(); //path
        str = buffer.readS();
        if (str)
            pi.file = str;
        pi.exported = buffer.readBool();//exported
        pi.width = buffer.readInt();
        pi.height = buffer.readInt();

        switch (pi.type) {
            case 0:// Image:
                {
                    pi.objectType = 0;// Image;
                    let scaleOption = buffer.readByte();
                    if (scaleOption == 1) {
                        pi.scale9Grid = {};
                        pi.scale9Grid.x = buffer.readInt();
                        pi.scale9Grid.y = buffer.readInt();
                        pi.scale9Grid.width = buffer.readInt();
                        pi.scale9Grid.height = buffer.readInt();

                        pi.tileGridIndice = buffer.readInt();
                    }
                    else if (scaleOption == 2)
                        pi.scaleByTile = true;

                    pi.smoothing = buffer.readBool();
                    break;
                }

            case 1:// MovieClip:
                {
                    pi.smoothing = buffer.readBool();
                    pi.objectType = 1; // MovieClip;
                    pi.rawData = buffer.readBuffer();
                    break;
                }

            case 5: // Font:
                {
                    pi.rawData = buffer.readBuffer();
                    break;
                }

            case 3: // Component:
                {
                    let extension = buffer.readByte();
                    if (extension > 0)
                        pi.objectType = extension;
                    else
                        pi.objectType = 9; // Component;
                    pi.rawData = buffer.readBuffer();

                    // Decls.UIObjectFactory.resolveExtension(pi);
                    break;
                }

            case 4: // Atlas:
            case 2: // Sound:
            case 7: // Misc:
                {
                    pi.file = fileNamePrefix + pi.file;
                    break;
                }
        }

        if (ver2) {
            str = buffer.readS();//branch
            if (str)
                pi.name = str + "/" + pi.name;

            let branchCnt = buffer.readByte();
            if (branchCnt > 0) {
                if (branchIncluded)
                    pi.branches = buffer.readSArray(branchCnt);
                else
                    _itemMap[buffer.readS()] = pi;
            }

            let highResCnt = buffer.readByte();
            if (highResCnt > 0)
                pi.highResolution = buffer.readSArray(highResCnt);
        }

        _items.push(pi);
        _itemMap[pi.id] = pi;
        if (pi.name != null)
            _itemMap[pi.name] = pi;

        buffer.pos = nextPos;

    }

    buffer.seek(indexTablePos, 2);

    cnt = buffer.readUshort();
    for (i = 0; i < cnt; i++) {
        nextPos = buffer.readUshort();
        nextPos += buffer.pos;

        let itemId = buffer.readS();
        pi = _itemMap[buffer.readS()];

        let rect = {};
        rect.x = buffer.readInt();
        rect.y = buffer.readInt();
        rect.width = buffer.readInt();
        rect.height = buffer.readInt();
        let sprite = { atlas: pi, rect: rect, offset: {}, originalSize: {} };
        sprite.rotated = buffer.readBool();
        if (ver2 && buffer.readBool()) {
            sprite.offset.x = buffer.readInt();
            sprite.offset.y = buffer.readInt();
            sprite.originalSize.x = buffer.readInt();
            sprite.originalSize.y = buffer.readInt();
        }
        else {
            sprite.originalSize.x = sprite.rect.width;
            sprite.originalSize.y = sprite.rect.height;
        }
        _sprites[itemId] = sprite;
        // handle sprites

        buffer.pos = nextPos;
    }

    if (buffer.seek(indexTablePos, 3)) {
        cnt = buffer.readUshort();
        for (i = 0; i < cnt; i++) {
            nextPos = buffer.readInt();
            nextPos += buffer.pos;

            let pi = _itemMap[buffer.readS()];
            if (pi && pi.type == PackageItemType.Image) {
                let pixelHitTestData = {};
                buffer.readInt();
                pixelHitTestData.pixelWidth = buffer.readInt();
                pixelHitTestData.scale = 1.0 / buffer.readByte();
                let len = buffer.readInt();
                pixelHitTestData.pixels = new Uint8Array(buffer.data, buffer.pos, len);
                buffer.skip(len);
                _pixelHitTestDatas.push(pixelHitTestData);
            }

            buffer.pos = nextPos;
        }
    }
    // console.log(_items); // package.xml
    // console.log(_itemMap);
    // console.log(_sprites); // sprites.bytes
    // console.log(_pixelHitTestDatas);
    return {"package.xml":_items,"sprites.bytes":_sprites,"files":_itemMap};
}

const parseXML = (source) => {
    let curr = 0;
    let fn;
    let size;
    let resData = {};
    while (true) {
        let pos = source.indexOf("|", curr);
        if (pos == -1)
            break;
        fn = source.substring(curr, pos);
        curr = pos + 1;
        pos = source.indexOf("|", curr);
        size = parseInt(source.substring(curr, pos));
        curr = pos + 1;
        resData[fn] = source.substr(curr, size);
        curr += size;
    }
    return resData;
}

const parseSprites = (resDic) => {
    let sep1 = "\n", sep2 = " ";
    let res = resDic.split(sep1), sprites = {};
    for (let len = res.length, i = 1; len > i; i++) {
        if (r = res[i]) {
            let l = r.split(sep2)
                , u = { "rect": {} }
                , c = l[0]
                , _ = parseInt(l[1]);
            if (_ >= 0)
                u.atlas = "atlas" + _;
            else {
                let p = c.indexOf("_");
                -1 == p ? u.atlas = "atlas_" + c : u.atlas = "atlas_" + c.substr(0, p)
            }
            u.rect.x = parseInt(l[2]),
                u.rect.y = parseInt(l[3]),
                u.rect.width = parseInt(l[4]),
                u.rect.height = parseInt(l[5]),
                u.rotated = "1" == l[6],
                sprites[c] = u;
        }
    }
    return sprites;
}

const handleSprites = async (spritesMap) => {
    console.log("start crop image");
    for (key in spritesMap) {
        let item = spritesMap[key];
        let { name, path } = item;
        let { atlas, rect, rotated } = item;
        if (!name) { // atlas temp
            name = key;
            path = temp
        }
        let output = path ? `${outputPath}${improtFileName}${path}${name}.png` : `${outputPath}${improtFileName}/${name}.png`;
        await new Promise((resolve, reject) => {
            Jimp.read(`${inputPath}${improtFileName}@${atlas}.png`)
                .then(image => {
                    // Do stuff with the image.
                    let { x, y, width, height } = rect;
                    width = rotated ? rect.height : width;
                    height = rotated ? rect.width : height;
                    let bitmap = image.crop(x, y, width, height);
                    if (rotated) {
                        bitmap.rotate(90);
                    }
                    bitmap.write(output);
                    resolve();
                })
                .catch(err => {
                    // Handle an exception.
                    console.log(err);
                    reject(err)
                });
        })
    }
    console.log("finish crop image");
}

const handleSound = async (soundInfo) => {
    console.log("start handleSound");
    soundInfo.forEach((item) => {
        let sound = item['$'];
        let { file, path, name } = sound;
        let extName = file.split('.').pop();
        let output = path ? `${outputPath}${improtFileName}${path}` : `${outputPath}${improtFileName}/`;
        file = `${inputPath}${improtFileName}@${file}`;
        if (exists(file)) {
            if (!exists(output)) {
                fs.mkdirSync(resolve(output));
            }
            output = `${output}${name}.${extName}`;
            fs.copyFileSync(file, output);
        } else {
            console.warn(`FILE: ${file} NOT FOUND!`);
        }
    })
    console.log("finish handleSound");
}

const handleAltas = (atlasInfo) => {
    // todo check atlas size
    if (!atlasInfo.every((item) => {
        let file = item['$']['file'];
        let name = `${inputPath}${improtFileName}@${file}`;
        if (exists(name)) {
            return true;
        } else {
            console.warn(`FILE: ${name} NOT FOUND!`);
            return false;
        }
    })) {
        throw "Atlas NOT FOUND!";
    }
}

const createFileByData = (data, ext) => {
    console.log("start createFileByData");
    for (let key in data) {
        let item = data[key];
        let { path, content, name } = item;
        let output = path ? `${outputPath}${improtFileName}${path}` : `${outputPath}${improtFileName}/`;
        if (!exists(output)) {
            fs.mkdirSync(resolve(output));
        }
        output = `${output}${name}${ext}`;
        if (ext == ".xml") {
            content = XMLHeader + content;
        }
        fs.writeFileSync(output, content)
    }
    console.log("finish createFileByData");
}

const handleMovieclip = async (movieclipInfo) => {
    console.log("start handleMovieclip");
    for (let key in movieclipInfo) {
        let movieclip = movieclipInfo[key];
        let { path, name } = movieclip;
        let output = path ? `${outputPath}${improtFileName}${path}${name}.jta` : `${outputPath}${improtFileName}/${name}.jta`;

        await createMovieClip(movieclip, tempPath, output);
    }
    console.log("finish handleMovieclip");
}

const handlePackageData = async (data) => {
    let xml = await xml2json(data);
    let packageDescription = xml['packageDescription'];
    let { id, name } = packageDescription['$'];
    delete packageDescription['$']; // reset
    delete packageDescription['resources']['atlas'];
    packageDescription['$'] = { id };
    packageDescription['publish'] = { "$": { name } };
    packageDescription['publish']['atlas'] = { "$": { name: "Default", index: 0 } };

    let resources = packageDescription['resources'];
    let components = resources['component'];
    let images = resources['image'];
    let movieclips = resources['movieclip'];
    let fonts = resources['font'];
    let sounds = resources['sound'];
    if (components) {
        components.forEach((item) => {
            item['$']['name'] = item['$']['name'] + '.xml';
            delete item['$']['size'];
        })
    }
    if (images) {
        images.forEach((item) => {
            item['$']['name'] = item['$']['name'] + '.png';
            delete item['$']['size'];
        })
    }
    if (movieclips) {
        movieclips.forEach((item) => {
            item['$']['name'] = item['$']['name'] + '.jta';
            delete item['$']['size'];
        })
    }
    if (fonts) {
        fonts.forEach((item) => {
            item['$']['name'] = item['$']['name'] + '.fnt';
            delete item['$']['size'];
        })
    }
    if (sounds) {
        sounds.forEach((item) => {
            // todo check file ext
            item['$']['name'] = item['$']['name'] + '.' + item['$']['file'].split(".").pop();
            delete item['$']['size'];
            delete item['$']['file'];
        })
    }
    return json2xml(xml);
}

const handlePackageData2 = (data)=>{
    console.log(data);
    let pkgData = {
        'packageDescription':{
            "$":{
                id:pkgId
            },

        }
    }
    let { id, name } = xml['packageDescription']['$'];
    delete xml['packageDescription']['$']; // reset
    delete xml['packageDescription']['resources']['atlas'];
    xml['packageDescription']['$'] = { id };
    xml['packageDescription']['publish'] = { "$": { name } };
    xml['packageDescription']['publish']['atlas'] = { "$": { name: "Default", index: 0 } };

    let components = xml['packageDescription']['resources']['component'];
    let images = xml['packageDescription']['resources']['image'];
    let movieclips = xml['packageDescription']['resources']['movieclip'];
    let fonts = xml['packageDescription']['resources']['font'];
    let sounds = xml['packageDescription']['resources']['sound'];
    if (components) {
        components.forEach((item) => {
            item['$']['name'] = item['$']['name'] + '.xml';
            delete item['$']['size'];
        })
    }
    if (images) {
        images.forEach((item) => {
            item['$']['name'] = item['$']['name'] + '.png';
            delete item['$']['size'];
        })
    }
    if (movieclips) {
        movieclips.forEach((item) => {
            item['$']['name'] = item['$']['name'] + '.jta';
            delete item['$']['size'];
        })
    }
    if (fonts) {
        fonts.forEach((item) => {
            item['$']['name'] = item['$']['name'] + '.fnt';
            delete item['$']['size'];
        })
    }
    if (sounds) {
        sounds.forEach((item) => {
            // todo check file ext
            item['$']['name'] = item['$']['name'] + '.' + item['$']['file'].split(".").pop();
            delete item['$']['size'];
            delete item['$']['file'];
        })
    }
    debugger;
    return
}

/**
 *  check package format
 *  decodeUncompressed only for [Laya/Egret/CocosCreateor] version 
 */
const parseBuffer = async (buf) => {
    let ba = new ByteArray(buf.buffer), data = {};
    if (ba.readUint() == 0x46475549) { // binary 
        ba.version = ba.readInt();
        let compressed = ba.readBool();

        if (compressed) { // compressed
            // let buf = new Uint8Array(ba.buffer, ba.position, ba.length - ba.position);
            // let inflater = new Zlib.inflateRawSync(buf);
            // let buffer2 = new ByteBuffer(inflater.decompress());
            // buffer2.version = buffer.version;
            // buffer = buffer2;
        } else { // Uncompressed
            pkgId = ba.readString();
            pkgName = ba.readString();
            ba.skip(20);
            data = decodeBinary(ba);
        }
        await handlePackageFile2(data['package.xml']);
    } else { // xml
        let mark = new Uint8Array(buf.buffer.slice(0, 2));
        if (mark[0] == 0x50 && mark[1] == 0x4b) { // compressed
            data = decodeUncompressed(buf.buffer);
        } else { // Uncompressed
            let xml = zlib.inflateRawSync(buf).toString();
            data = parseXML(xml);
        }
        await handlePackageFile(data); // create package.xml
    }
    return data;
}

const handlePackageFile = async (data) => {
    let packageXml = XMLHeader + data['package.xml'];
    packageXml = await handlePackageData(packageXml);

    let output = `${outputPath}${improtFileName}`;
    if (!exists(output)) {
        fs.mkdirSync(resolve(output));
    }
    fs.writeFileSync(`${output}/package.xml`, packageXml);
}

const handlePackageFile2 = async (data)=>{
    let packageXml = await handlePackageData2(data);
    let output = `${outputPath}${improtFileName}`;
    if (!exists(output)) {
        fs.mkdirSync(resolve(output));
    }
    fs.writeFileSync(`${output}/package.xml`, packageXml);
}

async function start() {
    console.time('start');
    let buf = fs.readFileSync(`${inputPath}${improtFileName}.bin`); // Buffer 
    let pkgData = await parseBuffer(buf);
    await createByPackage(pkgData);
    console.timeEnd('start');
}

start();











