const fs = require('fs-extra');
const zlib = require("zlib");
const Jimp = require('jimp').default || require('jimp');
const ByteArray = require('./ByteArray');
const { resolve, dirname, basename } = require('path');
const { exists, xml2json, json2xml, getItemById, getObjectById, rgbaToHex, deleteObjectProps, mkdirs } = require('./utils/utils');
const { createMovieClip } = require('./build/create');
const _ = require('lodash');
const path = require('path');
process.on("uncaughtException", function (err) {
    console.log(err);
});

const XMLHeader = '<?xml version="1.0" encoding="utf-8"?>\n';
let importFileName = "Basics",
    packageFileExtension = "fui",
    inputPath = "./test/",
    outputPath = './output/',
    temp = '/temp/',
    defaultFPS = 24,
    tempPath = `${outputPath}${importFileName}${temp}`,
    pkgName = "",
    pkgId = "",
    UIPackage = {},
    QuoteUIPackage = {},
    quotePackageMap = {},
    ObjectType = [
        "Image",
        "MovieClip",
        "Swf",
        "Graph",
        "Loader",
        "Group",
        "Text",
        "RichText",
        "InputText",
        "Component",
        "List",
        "Label",
        "Button",
        "ComboBox",
        "ProgressBar",
        "Slider",
        "ScrollBar",
        "Tree",
        "Loader3D"
    ],
    downEffectType = [
        "none",
        "dark",
        "scale"
    ],
    OverflowType = [
        "visible",
        "hidden",
        "scroll"
    ],
    ChildrenRenderOrder = [
        "ascent",
        "descent",
        "arch"
    ],
    ListSelectionMode = [
        "single",
        "multiple",
        "multipleSingleClick",
        "none"
    ],
    ListLayoutType = [
        "colum",
        "row",
        "flow_hz",
        "flow_vt",
        "pagination"
    ],
    ButtonMode = [
        "Common",
        "Check",
        "Radio"
    ],
    GraphType = [
        "none",
        "rect",
        "eclipse", // ellipse a mistake
        "polygon",
        "regular_polygon"
    ],
    RelationType = [
        "left-left",
        "left-center",
        "left-right",
        "center-center",
        "right-left",
        "right-center",
        "right-right",
        "top-top",
        "top-middle",
        "top-bottom",
        "middle-middle",
        "bottom-top",
        "bottom-middle",
        "bottom-bottom",
        "width-width",
        "height-height",
        "leftext-left",
        "leftext-right",
        "rightext-left",
        "rightext-right",
        "topext-top",
        "topext-bottom",
        "bottomext-top",
        "bottomext-bottom",
        // Size
    ],
    fillMethodType = [
        "None",
        "hz",
        "vt",
        "radial90",
        "radial180",
        "radial360",
    ],
    FlipType = [
        "None",
        "hz",
        "vt",
        "both"
    ],
    LoaderFillType = [
        "none",
        "scale",
        "scaleMatchHeight",
        "scaleMatchWidth",
        "scaleFree",
        "scaleNoBorder"
    ],
    FillOrigin = [
        "topLeft",
        "topRight",
        "bottomLeft",
        "bottomRight"
    ],
    ScrollType = [
        "horizontal",
        "vertical",
        "both"
    ],
    EaseType = [
        "Linear",
        "Sine.In",
        "Sine.Out",
        "Sine.InOut",
        "Quad.In",
        "Quad.Out",
        "Quad.InOut",
        "Cubic.In",
        "Cubic.Out",
        "Cubic.InOut",
        "Quart.In",
        "Quart.Out",
        "Quart.InOut",
        "Quint.In",
        "Quint.Out",
        "Quint.InOut",
        "Expo.In",
        "Expo.Out",
        "Expo.InOut",
        "Circ.In",
        "Circ.Out",
        "Circ.InOut",
        "Elastic.In",
        "Elastic.Out",
        "Elastic.InOut",
        "Back.In",
        "Back.Out",
        "Back.InOut",
        "Bounce.In",
        "Bounce.Out",
        "Bounce.InOut",
        "Custom",
    ],
    AutoSizeType = [
        "none",
        "both",
        "height",
        "shrink"
    ],
    ScrollBarDisplayType = [
        "default",
        "visible",
        "auto",
        "hidden"
    ],
    PackageItemType = [
        // Image,
        // MovieClip,
        // Sound,
        // Component,
        // Atlas,
        // Font,
        // Swf,
        // Misc,
        // Unknown
        ".png",
        ".jta",
        "Sound",
        ".xml",
        ".png",
        ".fnt",
        ".swf"
    ],
    ProgressTitleType = [
        "percent",
        "valueAndmax", // valueAndmax a mistake
        "value",
        "max"
    ],
    ActionType = [
        "XY",
        "Size",
        "Scale",
        "Pivot",
        "Alpha",
        "Rotation",
        "Color",
        "Animation",
        "Visible",
        "Sound",
        "Transition",
        "Shake",
        "ColorFilter",
        "Skew",
        "Text",
        "Icon",
        "Unknown"
    ],
    PopupDirection = [
        "auto",
        "up",
        "down"
    ],
    UIConfig = {},// default
    GearType = [
        "gearDisplay", "gearXY", "gearSize", "gearLook", "gearColor",
        "gearAni", "gearText", "gearIcon", "gearDisplay2", "gearFontSize"
    ];

/**
 *  check package format
 *  decodeUncompressed only for [Laya/Egret/CocosCreateor] version 
 */
// restore(`${inputPath}${importFileName}.bin`);
const restore = async (path, output) => {
    console.time('RestoreTask');
    inputPath = dirname(path) + "/";
    let tempName = basename(path).split(".");
    packageFileExtension = tempName.pop();
    importFileName = tempName[0];
    if (output) outputPath = resolve(output) + "/";
    tempPath = `${outputPath}${importFileName}${temp}`;
    if (!exists(output)) {
        mkdirs(resolve(output));
    }
    let buf = fs.readFileSync(`${path}`); // Buffer 
    let arrayBuffer = buf.buffer.slice(buf.byteOffset, buf.byteOffset + buf.byteLength);
    let ba = new ByteArray(arrayBuffer), pkgData;
    let formatFlag = ba.readUint(); // 1179080009
    if (formatFlag == 0x46475549) { // binary 
        pkgData = await parseBufferBin(ba);
        await handlePackageFileBin(pkgData);
        await createByPackageBin(pkgData);
    } else { // xml
        pkgData = await parseBufferXML(buf);
        await handlePackageFileXML(pkgData);
        await createByPackageXML(pkgData);
    }
    console.timeEnd('RestoreTask');
    console.log(`restore ${importFileName} finish!! \noutputPath:${outputPath}`)
}

/** XML */
const parseBufferXML = async (buf) => {
    let data;
    let mark = new Uint8Array(buf.buffer.slice(0, 2));
    if (mark[0] == 0x50 && mark[1] == 0x4b) {
        data = decodeUncompressed(buf.buffer);
    } else {
        let str = zlib.inflateRawSync(buf).toString();
        data = formatXMLStr(str);
    }
    return data;
}

const formatXMLStr = (source) => {
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

const decodeUncompressed = (buf) => {
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

const handlePackageDataXML = async (data) => {
    let json = await xml2json(data);
    let packageDescription = json['packageDescription'];
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
        if (!Array.isArray(components)) components = [components];
        components.forEach((item) => {
            item['$']['name'] = item['$']['name'] + '.xml';
            delete item['$']['size'];
        })
    }
    if (images) {
        if (!Array.isArray(images)) images = [images];
        images.forEach((item) => {
            debugger;
            item['$']['name'] = item['$']['name'] + '.png';
            delete item['$']['size'];
        })
    }
    if (movieclips) {
        if (!Array.isArray(movieclips)) movieclips = [movieclips];
        movieclips.forEach((item) => {
            item['$']['name'] = item['$']['name'] + '.jta';
            delete item['$']['size'];
        })
    }
    if (fonts) {
        if (!Array.isArray(fonts)) fonts = [fonts];
        fonts.forEach((item) => {
            item['$']['name'] = item['$']['name'] + '.fnt';
            delete item['$']['size'];
        })
    }
    if (sounds) {
        if (!Array.isArray(sounds)) sounds = [sounds];
        sounds.forEach((item) => {
            // todo check file ext
            item['$']['name'] = item['$']['name'] + '.' + item['$']['file'].split(".").pop();
            delete item['$']['size'];
            delete item['$']['file'];
        })
    }
    return json2xml(json);
}

const handlePackageFileXML = async (data) => {
    let packageXml = XMLHeader + data['package.xml'];
    packageXml = await handlePackageDataXML(packageXml);

    let output = `${outputPath}${importFileName}`;
    if (!exists(output)) {
        mkdirs(resolve(output));
    }
    fs.writeFileSync(`${output}/package.xml`, packageXml);
}

const createByPackageXML = async (pkgData) => {
    // handle package.xml & get pkgName and pkgId
    const packageData = await xml2json(pkgData["package.xml"]);
    pkgName = packageData["packageDescription"]['$']['name'];
    pkgId = packageData["packageDescription"]['$']['id'];

    // Verifies if the texture exists in the same directory
    let atlasInfo = packageData["packageDescription"]['resources']['atlas'];
    if (atlasInfo) {
        if (!Array.isArray(atlasInfo)) atlasInfo = [atlasInfo];
        handleAltas(atlasInfo);
    }

    // parse sprites.bytes
    let imageInfo = packageData["packageDescription"]['resources']['image'];
    if (imageInfo) {
        if (!Array.isArray(imageInfo)) imageInfo = [imageInfo];
        let spritesMap = parseSprites(pkgData['sprites.bytes']);
        imageInfo.forEach((item) => {
            let image = item['$'];
            let key = image['id'];
            Object.assign(spritesMap[key], image);
        })
        await handleSprites(spritesMap);
    }

    let soundInfo = packageData["packageDescription"]['resources']['sound'];
    if (soundInfo) {
        if (!Array.isArray(soundInfo)) soundInfo = [soundInfo];
        handleSound(soundInfo);
    }

    let fontInfo = packageData["packageDescription"]['resources']['font'];
    if (fontInfo) {
        let fontMap = {};
        if (!Array.isArray(fontInfo)) fontInfo = [fontInfo];
        fontInfo.forEach((item) => {
            let font = item['$'];
            let file = `${font['id']}.fnt`;
            font['content'] = pkgData[file];
            fontMap[file] = font;
        })
        createFileByData(fontMap, '.fnt');
    }
    let movieclipInfo = packageData["packageDescription"]['resources']['movieclip'];
    if (movieclipInfo) {
        if (!Array.isArray(movieclipInfo)) movieclipInfo = [movieclipInfo];
        let movieclipMap = {};
        movieclipInfo.forEach((item) => {
            let movieclip = item['$'];
            let file = `${movieclip['id']}.xml`;
            movieclip['content'] = pkgData[file];
            delete pkgData[file];
            movieclipMap[file] = movieclip;
        })

        await handleMovieclip(movieclipMap);
    }

    let componentInfo = packageData["packageDescription"]['resources']['component'];
    if (componentInfo) {
        if (!Array.isArray(componentInfo)) componentInfo = [componentInfo];
        let componentMap = {};
        componentInfo.forEach((item) => {
            let component = item['$'];
            let file = `${component['id']}.xml`;
            component['content'] = XMLHeader + pkgData[file];
            componentMap[file] = component;
        })
        createFileByData(componentMap, ".xml");
    }

    deleteTemp(tempPath);
}

const handlePackageDataBin = (pkgData, name) => {
    let data = pkgData['package.xml'];
    let sprites = pkgData['sprites.bytes'];
    let pkgXmlData = {
        'packageDescription': {
            "$": {
                id: pkgId
            },
            "resources": {
                "component": [],
                "image": [],
                "movieclip": [],
                "font": [],
                "sound": [],
                "atlas": []
            },
            "publish": {
                "$": { name },
                "atlas": {
                    "$": { name: "Default", index: 0 }
                }
            }
        }
    }
    let components = pkgXmlData['packageDescription']['resources']['component'];
    let images = pkgXmlData['packageDescription']['resources']['image'];
    let movieclips = pkgXmlData['packageDescription']['resources']['movieclip'];
    let fonts = pkgXmlData['packageDescription']['resources']['font'];
    let sounds = pkgXmlData['packageDescription']['resources']['sound'];
    let atlas = pkgXmlData['packageDescription']['resources']['atlas'];

    data.forEach((element) => {
        let { type, id, name, path, size, exported, file, smoothing, width, height } = element;
        let item = {
            "$": {

            }
        };
        Object.assign(item['$'], { id, name, path, size, file, exported, smoothing });
        if (!item['$']['exported']) {
            delete item['$']['exported'];
        }
        if (item['$']['smoothing']) {
            delete item['$']['smoothing'];
        }
        switch (type) {
            case 0:
                if (element['scaleOption'] == 1) { // 9grid
                    item['$']['scale'] = '9grid';
                    let { x, y, width, height } = element['scale9Grid'];
                    item['$']['scale9grid'] = `${x},${y},${width},${height}`;
                } else if (element['scaleOption'] == 2) { // tile
                    item['$']['scale'] = 'tile';
                }
                if (item['$']['name'].indexOf('.png') == -1) {

                    let ext = getFileExt(item['$']['file']||".png");
                    item['$']['name'] = item['$']['name'] + ext;
                }
                images.push(item);
                break;
            case 1:
                item['$']['name'] = item['$']['name'] + '.jta';
                item['$']['size'] = `${width},${height}`
                movieclips.push(item);
                break;
            case 2:
                item['$']['name'] = item['$']['name'] + '.' + item['$']['file'].split(".").pop();
                sounds.push(item);
                break;
            case 3:
                item['$']['name'] = item['$']['name'] + '.xml';
                components.push(item);
                break;
            case 4:
                // atlas.push(item);
                break;
            case 5:
                item['$']['name'] = item['$']['name'] + '.fnt';
                for (let key in sprites) {
                    let sprite = sprites[key];
                    if (sprites[id] && JSON.stringify(sprite['rect']) === JSON.stringify(sprites[id]['rect']) && key != id) {
                        item['$']['texture'] = key;
                        item['$']['fontTexture'] = key;
                    }
                }

                fonts.push(item);
                break;
            default:
                debugger;
                break;
        }
    })
    pkgData['package.xml'] = pkgXmlData;

    return json2xml(pkgXmlData);
}

const handlePackageFileBin = async (data) => {
    let str = handlePackageDataBin(data, pkgName);
    let output = `${outputPath}${importFileName}`;
    if (!exists(output)) {
        mkdirs(resolve(output));
    }
    fs.writeFileSync(`${output}/package.xml`, str);
}

const parseBufferBin = async (ba, isQuotePackage = false) => {
    ba.version = ba.readInt();
    let compressed = ba.readBool();
    pkgId = ba.readString();
    pkgName = ba.readString();
    ba.skip(20);
    if (compressed) { // compressed
        let buf = new Uint8Array(ba._buffer, ba._pos, ba._length - ba._pos);
        let inflater = zlib.inflateRawSync(buf);
        let ba2 = new ByteArray(inflater.buffer);
        ba2.version = ba.version;
        ba = ba2;
    }
    return decodeBinary(ba, isQuotePackage);
}

let imagesFileMap;
const createByPackageBin = async (pkgData) => {
    // handle package.xml & get pkgName and pkgId
    const packageData = pkgData["package.xml"];
    const sprites = pkgData['sprites.bytes'];
    const files = pkgData['files'];
    imagesFileMap = files;
    // Verifies if the texture exists in the same directory
    let atlasInfo = packageData["packageDescription"]['resources']['atlas'];
    if (atlasInfo) {
        if (!Array.isArray(atlasInfo)) atlasInfo = [atlasInfo];
        handleAltas(atlasInfo);
    }

    // parse sprites.bytes
    let imageInfo = packageData["packageDescription"]['resources']['image'];
    if (imageInfo) {
        if (!Array.isArray(imageInfo)) imageInfo = [imageInfo];
        let spritesMap = pkgData['sprites.bytes'];
        let resFiles = pkgData["files"];
        let imageMap = {};
        imageInfo.forEach((item) => {
            let image = item['$'];
            image.name = image.name.replace(".png", '').replace(".svg", '');
            let key = image['id'];
            let sprites = spritesMap[key];
            if (sprites) {
                Object.assign(sprites, image);
            } else {
                imageMap[key] = image
            }
        })
        await handleSprites(spritesMap, false, resFiles);
        await handleImages(imageMap);
    }

    let soundInfo = packageData["packageDescription"]['resources']['sound'];
    if (soundInfo) {
        if (!Array.isArray(soundInfo)) soundInfo = [soundInfo];
        handleSound(soundInfo, false);
    }

    let fontInfo = packageData["packageDescription"]['resources']['font'];
    if (fontInfo) {
        let fontMap = {};
        if (!Array.isArray(fontInfo)) fontInfo = [fontInfo];
        fontInfo.forEach((item) => {
            let font = item['$'];
            let file = `${font['id']}.fnt`;
            font['content'] = decodeFontData(font['id'], sprites, files);
            fontMap[file] = font;
        })
        createFileByData(fontMap, '');
    }

    let movieclipInfo = packageData["packageDescription"]['resources']['movieclip'];
    if (movieclipInfo) {
        if (!Array.isArray(movieclipInfo)) movieclipInfo = [movieclipInfo];
        let movieclipMap = {};
        movieclipInfo.forEach((item) => {
            let movieclip = item['$'];
            let { id } = movieclip;
            movieclip['content'] = decodeMovieclipData(id, sprites, files);
            movieclipMap[id] = movieclip;
        })
        await handleMovieclip(movieclipMap, false);
    }

    let componentInfo = packageData["packageDescription"]['resources']['component'];
    if (componentInfo) {
        if (!Array.isArray(componentInfo)) componentInfo = [componentInfo];
        let componentMap = {};
        for (let i = 0; i < componentInfo.length; i++) {
            item = componentInfo[i];
            let component = item['$'];
            let { id } = component;
            let content = await decodeComponentData(UIPackage[id], files);
            component['content'] = parseJSON2XML(content);
            componentMap[id] = component;
        }
        // componentInfo.forEach((item) => {
        //     let component = item['$'];
        //     let { id } = component;
        //     let content = await decodeComponentData(UIPackage[id], files);
        //     component['content'] = parseJSON2XML(content);
        //     componentMap[id] = component;
        // })
        createFileByData(componentMap, "");
    }
    deleteTemp(tempPath);
}

function deleteTemp(path) {
    path = resolve(path);
    if (exists(path)) {
        let tempfiles = fs.readdirSync(path);
        if (tempfiles) {
            for (let i = 0; i < tempfiles.length; i++) {
                let file = tempfiles[i];
                fs.unlinkSync(path + '/' + file);
            }
        }
        fs.rmdirSync(path);
    }
}

function decodeFontData(id, sprites, files) {
    let rawData = UIPackage[id].rawData, pi = {};
    rawData.seek(0, 0);
    pi.font = { glyphs: [] };
    pi.font.ttf = rawData.readBool();
    pi.font.tint = rawData.readBool();
    pi.font.resizable = rawData.readBool();
    pi.font.hasChannel = rawData.readBool();
    pi.font.size = rawData.readInt();
    pi.font.xadvance = rawData.readInt();
    pi.font.lineHeight = rawData.readInt();

    rawData.seek(0, 1);

    let mainTexture;
    let mainSprite = sprites[id];
    // if (mainSprite)
    //     mainTexture = mainSprite.atlas;

    let charCnt = rawData.readInt();
    for (let j = 0; j < charCnt; j++) {
        let nextPosition = rawData.readShort();
        nextPosition += rawData.pos;

        let bg = {};
        let ch = rawData.readChar() || " ";
        pi.font.glyphs[ch] = bg;

        let img = rawData.readS();
        bg.bx = rawData.readInt();
        bg.by = rawData.readInt();
        bg.x = rawData.readInt();
        bg.y = rawData.readInt();
        bg.width = rawData.readInt();
        bg.height = rawData.readInt();
        bg.advance = rawData.readInt();
        bg.channel = rawData.readByte();
        if (bg.channel == 1)
            bg.channel = 3;
        else if (bg.channel == 2)
            bg.channel = 2;
        else if (bg.channel == 3)
            bg.channel = 1;

        if (pi.font.ttf) { // face
            bg.texture = mainSprite;
            bg.lineHeight = pi.font.lineHeight;
        }
        else { // creator=UIBuilder
            let charImg = getItemById(files, img);
            if (charImg) {
                mainTexture = sprites[charImg.id];
                bg.width = charImg.width;
                bg.height = charImg.height;
                bg.texture = charImg.id;
                let { x, y } = mainTexture.offset;
                bg.xoffset = x;
                bg.yoffset = y;
            }

            if (bg.advance == 0) {
                if (pi.font.xadvance == 0)
                    bg.advance = bg.x + bg.width;
                else
                    bg.advance = pi.font.xadvance;
            }

            bg.lineHeight = bg.y < 0 ? bg.height : (bg.y + bg.height);
            if (bg.lineHeight < pi.font.size)
                bg.lineHeight = pi.font.size;
        }
        rawData.pos = nextPosition;
    }
    return parseFont(pi.font);
}

function decodeMovieclipData(id, _sprites, files) {
    let rawData = UIPackage[id].rawData, pi = {};

    rawData.seek(0, 0);

    let interval = rawData.readInt();
    let swing = rawData.readBool();
    let repeatDelay = rawData.readInt();

    rawData.seek(0, 1);

    let frameCount = rawData.readShort();
    pi.frames = frameCount;

    // let spriteId;
    // let sprite;
    let movieclip = {
        "movieclip": {
            "$": {
                interval,
                swing,
                repeatDelay
            },
            "frames": {
                "frame": []
            }
        }
    };

    for (let i = 0; i < frameCount; i++) {
        let nextPos = rawData.readShort();
        nextPos += rawData.pos;

        let frame = {};
        let x = rawData.readInt();
        let y = rawData.readInt();
        let width = rawData.readInt();//width
        let height = rawData.readInt();//height
        let rect = `${x},${y},${width},${height}`;
        frame.rect = rect;
        let addDelay = rawData.readInt();
        if (addDelay) { frame.addDelay = addDelay };
        movieclip['movieclip']['frames']['frame'].push({ "$": frame });
        // spriteId = rawData.readS();

        // if (spriteId != null && (sprite = _sprites[spriteId]) != null) {
        // let atlas = data.getItemAsset(sprite.atlas);
        // frame.texture = new egret.Texture();
        // frame.texture.bitmapData = atlas.bitmapData;
        // frame.texture.$initData(atlas.$bitmapX + sprite.rect.x, atlas.$bitmapY + sprite.rect.y,
        //     sprite.rect.width, sprite.rect.height,
        //     fx, fy,
        //     item.width, item.height,
        //     atlas.$sourceWidth, atlas.$sourceHeight, sprite.rotated);
        // }
        pi.frames[i] = frame;

        rawData.pos = nextPos;
    }
    return movieclip;
}

async function loadQuotePackage(files) {
    for (let i = 0; i < files.length; i++) {
        let file = files[i];
        let buf = fs.readFileSync(`${inputPath}${file}`); // Buffer 
        let arrayBuffer = buf.buffer.slice(buf.byteOffset, buf.byteOffset + buf.byteLength);;
        let ba = new ByteArray(arrayBuffer), pkgData;
        let formatFlag = ba.readUint(); // 1179080009
        if (formatFlag == 0x46475549) { // binary 
            pkgData = await parseBufferBin(ba, true);
            handlePackageDataBin(pkgData, pkgName);
            quotePackageMap[file] = pkgData['package.xml'];

        } else { // xml
            debugger;
            // todo
            // pkgData = await parseBufferXML(buf);
            // await handlePackageFileXML(pkgData);
        }
    }
}

async function decodeComponentData(contentItem, files) {
    let { rawData, objectType } = contentItem;
    let pi = { "children": [], objectType };
    rawData.seek(0, 0);

    // size
    pi.width = rawData.readInt();
    pi.height = rawData.readInt();


    // restrictSize
    if (rawData.readBool()) {
        pi.minWidth = rawData.readInt();
        pi.maxWidth = rawData.readInt();
        pi.minHeight = rawData.readInt();
        pi.maxHeight = rawData.readInt();
    }

    // pivot
    if (rawData.readBool()) {
        pi.pivotX = rawData.readFloat();
        pi.pivotY = rawData.readFloat();
    }

    // margin
    if (rawData.readBool()) {
        pi.margin = {};
        pi.margin.top = rawData.readInt();
        pi.margin.bottom = rawData.readInt();
        pi.margin.left = rawData.readInt();
        pi.margin.right = rawData.readInt();
    }

    // overflow
    let overflow = rawData.readByte();
    pi.overflow = overflow;
    if (overflow == 2) { // 2
        let savedPos = rawData.pos;
        rawData.seek(0, 7);
        pi.scroll = setupScroll(rawData);
        rawData.pos = savedPos;
    }


    if (rawData.readBool()) {
        // rawData.skip(8);
        pi.clipSoftness = {};
        pi.clipSoftness.x = rawData.readInt();
        pi.clipSoftness.y = rawData.readInt();
    }

    rawData.seek(0, 1);

    //controller
    let controllerCount = rawData.readShort();
    pi.controllers = [];
    for (let i = 0; i < controllerCount; i++) {
        nextPos = rawData.readShort();
        nextPos += rawData.pos;

        let controller = setupController(rawData); // controller.setup
        pi.controllers.push(controller);
        rawData.pos = nextPos;
    }

    rawData.seek(0, 2);

    let childCount = rawData.readShort();

    for (let i = 0; i < childCount; i++) {
        let child = {};
        let dataLen = rawData.readShort();
        curPos = rawData.pos;


        rawData.seek(curPos, 0);

        let type = rawData.readByte();
        let src = rawData.readS();
        let pkgId = rawData.readS(); // use src
        child.type = type;
        child.src = src;
        child.pkgId = pkgId;
        let packageItem = null;

        if (src != null && pkgId == null) {
            packageItem = UIPackage[src];
            if (packageItem) { // GComponent
                child.objectType = packageItem.objectType;
                let file = getObjectById(files, "id", src);
                if (file) child.file = file.name;
            } else { // altas && image
                packageItem = files[src];
                if (!packageItem) {
                    debugger
                    break;
                }
                child.file = packageItem.name;
            }
            child.path = packageItem.path;
            child.packageItemType = packageItem.type;
        }

        if (pkgId != null) { // 跨包引用了，扫描同目录下的其他文件
            var quoteFiles = fs.readdirSync(inputPath);
            var quotePackage = [];
            quoteFiles.forEach((file) => {
                if (file.indexOf(packageFileExtension) > -1 && file != `${importFileName}.${packageFileExtension}`) {
                    quotePackage.push(file);
                }
            });
            if (Object.keys(quotePackageMap).length == 0) {
                await loadQuotePackage(quotePackage);
            }

            // 跳过跨包资源检查，继续处理可以处理的部分
            if (Object.keys(quotePackageMap).length == 0) {
                console.warn(`警告：找不到跨包资源，将尝试继续处理可以处理的部分...`);
                console.warn(`  - 需要的包ID: ${pkgId}`);
                console.warn(`  - 资源类型: ${type === 0 ? 'image' : type === 1 ? 'movieclip' : type === 2 ? 'sound' : type === 3 ? 'component' : type === 4 ? 'atlas' : 'unknown'}`);
                console.warn(`  - 请确保引用的外部包资源文件已放置在与当前资源相同的目录下`);
                // 不抛出错误，继续执行
            }

            for (let i in quotePackageMap) {
                let package = quotePackageMap[i]['packageDescription'];
                if (package['$']['id'] === pkgId) {
                    let resType = "image";
                    switch (type) {
                        case 0:
                            resType = "image";
                            break;
                        case 1:
                            resType = "movieclip";
                            break;
                        case 2:
                            resType = "sound";
                            break;
                        case 3:
                            resType = "component";
                            break;
                        case 4:
                            resType = "atlas";
                            break;
                        case 5:
                            resType = "font";
                            break;
                        case 9:
                            resType = "component";
                            break;
                        default:
                            debugger;
                            break;
                    }
                    package['resources'][resType].forEach((res) => {
                        if (res.$.id == src) {
                            packageItem = res.$;
                            let fileName = packageItem.name;
                            child.file = fileName.split(".")[0];
                            child.path = packageItem.path;
                            child.packageItemType = type;
                        }
                    })

                    // 存在同名包的情况，直到找到为止
                    if (child.file && child.path) {
                        break;
                    }
                }
            }
        }


        child.beforeContent = setup_beforeAdd(child.type, rawData, curPos) // setup_beforeAdd
        pi.children.push(child);
        // console.log(pi,child);
        rawData.pos = curPos + dataLen;
    }

    rawData.seek(0, 3);
    pi.relations = relationSetup(rawData, true); //relations.setup

    rawData.seek(0, 2);
    rawData.skip(2);


    for (let i = 0; i < childCount; i++) {
        nextPos = rawData.readShort();
        nextPos += rawData.pos;

        rawData.seek(rawData.pos, 3);
        if (!pi.children[i]) { debugger }
        pi.children[i].relations = relationSetup(rawData, false); //relations.setup

        rawData.pos = nextPos;
    }

    rawData.seek(0, 2);
    rawData.skip(2);

    for (let i = 0; i < childCount; i++) {
        nextPos = rawData.readShort();
        nextPos += rawData.pos;

        child = pi.children[i];
        // setup_afterAdd
        let type = child.type || child.objectType;
        let position = rawData.pos;
        child.afterContent = setup_afterAdd(type, rawData, position);
        child.content = Object.assign({}, child.beforeContent, child.afterContent);
        delete child.beforeContent;
        delete child.afterContent;
        rawData.pos = nextPos;
    }

    rawData.seek(0, 4);
    // rawData.skip(2); //customData

    pi.remark = rawData.readS(); //component customData
    pi.opaque = rawData.readBool();
    let maskId = rawData.readShort();
    if (maskId != -1) {
        pi.maskId = maskId;
        pi.reversedMask = rawData.readBool(); //reversedMask
    }
    pi.hitTestId = rawData.readS();
    i1 = rawData.readInt();
    i2 = rawData.readInt();
    // if (pi.hitTestId != null) {
    //     pi.hitTestId = _pixelHitTestDatas[hitTestId];//contentItem.owner.getItemById(hitTestId);
    //     if (pi && pi.pixelHitTestData)
    //         pi.rootContainer.hitArea = new PixelHitTest(pi.pixelHitTestData, i1, i2);
    // } else if (i1 != 0 && i2 != -1) {
    //     pi.rootContainer.hitArea = pi.getChildAt(i2).displayObject;
    // }

    rawData.seek(0, 5);

    let transitionCount = rawData.readShort();
    pi.transitions = [];
    for (i = 0; i < transitionCount; i++) {
        nextPos = rawData.readShort();
        nextPos += rawData.pos;

        let trans = transitionSetup(rawData);
        pi.transitions.push(trans);

        rawData.pos = nextPos;
    }

    if (pi.objectType != 9)
        pi.extensionData = constructExtension(pi.objectType, rawData);
    return pi;
}

function decodeGraphBefore(rawData, position) {
    let data = { "shape": {} };
    rawData.seek(position, 5);

    let type = rawData.readByte();
    if (type != 0) {
        let i;
        let cnt;

        let lineSize = rawData.readInt();
        let lineColor = rgbaToHex(rawData.readFullColor());
        let fillColor = rgbaToHex(rawData.readFullColor());
        let roundedRect = rawData.readBool();
        let cornerRadius;
        if (roundedRect) {
            cornerRadius = [];
            for (i = 0; i < 4; i++)
                cornerRadius[i] = rawData.readFloat();
        }

        if (type == 1) {
            if (roundedRect)
                data.shape = { lineSize, lineColor, fillColor, cornerRadius };
            else
                data.shape = { lineSize, lineColor, fillColor };
        }
        else if (type == 2) {
            data.shape = { lineSize, fillColor, lineColor, fillColor };
        }
        else if (type == 3) {
            cnt = rawData.readShort();
            let points = [];
            points.length = cnt;
            for (i = 0; i < cnt; i++) {
                let point = rawData.readFloat();
                if (point) point = point;
                points[i] = point
            }
            data.shape = { points, fillColor, lineSize, lineColor };
        }
        else if (type == 4) {
            let sides = rawData.readShort();
            let startAngle = rawData.readFloat();
            cnt = rawData.readShort();
            let distances;
            if (cnt > 0) {
                distances = [];
                for (i = 0; i < cnt; i++) {
                    let distance = rawData.readFloat();
                    if (distance) distance = distance.toFixed(2);
                    distances[i] = distance
                }
            }

            data.shape = { sides, lineSize, fillColor, lineColor, fillColor, startAngle, distances };
        }
        Object.assign(data.shape, { type });
    }
    return data;
}

function decodeTextFieldBefore(rawData, position) {
    let data = { "textFormat": {} };
    rawData.seek(position, 5);

    let tf = data.textFormat;

    tf.font = rawData.readS();
    tf.size = rawData.readShort();
    tf.color = rgbaToHex(rawData.readColor(), false);
    let c = rawData.readByte();
    data.align = c == 0 ? "left" : (c == 1 ? "center" : "right");
    c = rawData.readByte();
    data.verticalAlign = c == 0 ? "top" : (c == 1 ? "middle" : "bottom");
    tf.leading = rawData.readShort();
    tf.letterSpacing = rawData.readShort();
    data.ubb = rawData.readBool();
    data.autoSize = rawData.readByte();
    tf.underline = rawData.readBool();
    tf.italic = rawData.readBool();
    tf.bold = rawData.readBool();
    data.singleLine = rawData.readBool();
    if (rawData.readBool()) {
        tf.outlineColor = rgbaToHex(rawData.readColor(), false);
        tf.outline = rawData.readFloat() + 1;
    }

    if (rawData.readBool()) //shadow
    {
        tf.shadowColor = rgbaToHex(rawData.readColor(), false);
        let f1 = rawData.readFloat();
        let f2 = rawData.readFloat();
        tf.shadowOffsetX = f1;
        tf.shadowOffsetY = f2;
    }

    if (rawData.readBool())
        data.template = {};

    if (rawData.version >= 3)
        tf.strikethrough = rawData.readBool();

    return data;
}

function decodeTextInputBefore(rawData, position) {
    let text = decodeTextFieldBefore(rawData, position);
    let data = {};
    rawData.seek(position, 4);

    let str = rawData.readS();
    if (str != null)
        data.prompt = str;

    str = rawData.readS();
    if (str != null)
        data.restrict = str;

    let iv = rawData.readInt();
    if (iv != 0)
        data.maxLength = iv;
    iv = rawData.readInt();
    if (iv != 0) {
        if (iv == 4)
            data.keyboardType = "number";
        else if (iv == 3)
            data.keyboardType = "url";
    }
    if (rawData.readBool())
        data.password = true;

    return Object.assign(data, text);
}

function decodeLoaderBefore(rawData, position) {
    let data = { "content": {} };
    rawData.seek(position, 5);
    data.url = rawData.readS();
    let iv = rawData.readByte();
    data.align = iv == 0 ? "left" : (iv == 1 ? "center" : "right");
    iv = rawData.readByte();
    data.vAlign = iv == 0 ? "top" : (iv == 1 ? "middle" : "bottom");
    data.fill = rawData.readByte();
    data.shrinkOnly = rawData.readBool();
    data.autoSize = rawData.readBool();
    rawData.readBool(); //_showErrorSign
    data.content.playing = rawData.readBool();
    data.content.frame = rawData.readInt();

    if (rawData.readBool()) {
        data.color = rawData.readColor();
    }
    data.content.fillMethod = rawData.readByte();
    if (data.content.fillMethod != 0) {
        data.content.fillOrigin = rawData.readByte();
        data.content.fillClockwise = rawData.readBool();
        data.content.fillAmount = rawData.readFloat();
    }
    return data;
}

function decodeGroupBefore(rawData, position) {
    let data = {};
    rawData.seek(position, 5);
    data.advanced = true;
    data.layout = rawData.readByte();
    data.lineGap = rawData.readInt();
    data.colGap = rawData.readInt();
    if (rawData.version >= 2) {
        data.excludeInvisibles = rawData.readBool();
        data.autoSizeDisabled = rawData.readBool();
        data.mainGridIndex = rawData.readShort();
    }
    return data;
}

function decodeListBefore(rawData, position, treeView = false) {
    let data = {};
    rawData.seek(position, 5);
    let i1;

    data.layout = rawData.readByte();
    data.selectionMode = rawData.readByte();
    i1 = rawData.readByte();
    data.align = i1 == 0 ? "left" : (i1 == 1 ? "center" : "right");
    i1 = rawData.readByte();
    data.vAlign = i1 == 0 ? "top" : (i1 == 1 ? "middle" : "bottom");
    data.lineGap = rawData.readShort();
    data.colGap = rawData.readShort();
    data.lineCount = rawData.readShort();
    data.columnCount = rawData.readShort();
    data.autoResizeItem = rawData.readBool();
    data.childrenRenderOrder = rawData.readByte();
    data.apexIndex = rawData.readShort();

    if (rawData.readBool()) {
        data.margin = {};
        data.margin.top = rawData.readInt();
        data.margin.bottom = rawData.readInt();
        data.margin.left = rawData.readInt();
        data.margin.right = rawData.readInt();
    }

    data.overflow = rawData.readByte();
    if (data.overflow == 2) {
        let savedPos = rawData.pos;
        rawData.seek(position, 7);
        data.scroll = setupScroll(rawData);
        rawData.pos = savedPos;
    }

    if (rawData.readBool()) {//clipSoftness
        // rawData.skip(8);
        data.clipSoftness = {};
        data.clipSoftness.x = rawData.readInt();
        data.clipSoftness.y = rawData.readInt();
    }

    if (rawData.version >= 2) {
        data.scrollItemToViewOnClick = rawData.readBool();
        data.foldInvisibleItems = rawData.readBool();
    }

    rawData.seek(position, 8);

    data.defaultItem = rawData.readS();
    data.items = readItems(rawData, data, treeView);
    return data;
}

function readItems(buffer, list, treeView) {
    let data = [];
    let cnt;
    let i;
    let nextPos;
    let str;
    var isFolder;
    var level;

    cnt = buffer.readShort();
    for (i = 0; i < cnt; i++) {
        nextPos = buffer.readShort();
        nextPos += buffer.pos;

        str = buffer.readS();
        let url;
        if (str == null) {
            str = list.defaultItem;
            if (!str) {
                buffer.pos = nextPos;
                continue;
            }
        } else {
            url = str;
        }
        if (treeView) {
            isFolder = buffer.readBool();
            level = buffer.readByte();
        }
        let id = str.replace(`ui://${pkgId}`, '');
        // let pkg = UIPackage[id];
        let obj = { id, buffer };
        let item;
        if (obj) {
            item = setupItem(buffer, id);
        }
        item.url = url;
        // item.isFolder = isFolder; // wait for extension
        item.level = level;
        data.push(item);

        buffer.pos = nextPos;
    }
    return data;
}

function setupItem(buffer, id) {
    let pkg = UIPackage[id];
    let data = {};
    let str;

    str = buffer.readS();
    if (str != null)
        data.title = str ? _.escape(str) : str;
    str = buffer.readS();
    if (str != null && pkg.objectType == 12) // GButton
        data.selectedTitle = str;
    str = buffer.readS();
    if (str != null)
        data.icon = str;
    str = buffer.readS();
    if (str != null && pkg.objectType == 12)// GButton
        data.selectedIcon = str;
    str = buffer.readS();
    if (str != null)
        data.name = _.escape(str);

    let cnt;
    let i;

    if (pkg && pkg.type == 9) { // GComponent todo
        debugger;
        cnt = buffer.readShort();
        for (i = 0; i < cnt; i++) {
            let cc = obj.getController(buffer.readS());
            str = buffer.readS();
            if (cc)
                cc.selectedPageId = str;
        }

        if (buffer.version >= 2) {
            cnt = buffer.readShort();
            debugger;
            for (i = 0; i < cnt; i++) {
                let target = buffer.readS();
                let propertyId = buffer.readShort();
                let value = buffer.readS();
                let obj2 = obj.getChildByPath(target);
                if (obj2)
                    obj2.setProp(propertyId, value);
            }
        }
    }
    return data;
}


function decodeTreeBefore(rawData, position) {
    let list = decodeListBefore(rawData, position, true);
    let data = {};
    rawData.seek(position, 9);

    data.indent = rawData.readInt();
    data.clickToExpand = rawData.readByte();
    return Object.assign(data, list);
}

function decodeTextFieldAfter(rawData, position) {
    let data = {};
    rawData.seek(position, 6);

    let str = rawData.readS();
    if (str != null)
        data.text = encodeHTML(str);
    return data;
}

function decodeComponetAfter(rawData, position) {
    let data = { "scrollPane": {} };
    rawData.seek(position, 4);

    let pageController = rawData.readShort();
    if (pageController != -1)
        data.scrollPane.pageController = pageController;// this.parent.getControllerAt(pageController);

    let cnt = rawData.readShort();
    for (let i = 0; i < cnt; i++) {
        let control = rawData.readS();
        data.control = control;
        let pageId = rawData.readS();
        if (pageId)
            data.selectedPageId = pageId;
    }

    if (rawData.version >= 2) {
        cnt = rawData.readShort();
        data.props = [];
        for (i = 0; i < cnt; i++) {
            // debugger;
            let target = rawData.readS();
            let propertyId = rawData.readShort();
            let value = rawData.readS();
            data.props.push({ target, propertyId, value });
        }
    }
    return data;
}

function transitionSetup(buffer) {
    let data = { "items": [] };
    data.name = buffer.readS();
    data.options = buffer.readInt();
    data.autoPlay = buffer.readBool();
    data.autoPlayTimes = buffer.readInt();
    data.autoPlayDelay = buffer.readFloat();
    data.totalDuration = 0;
    let cnt = buffer.readShort();
    for (let i = 0; i < cnt; i++) {
        let dataLen = buffer.readShort();
        let curPos = buffer.pos;

        buffer.seek(curPos, 0);
        let type = buffer.readByte();
        let item = { type, value: {} };
        data.items[i] = item;

        item.time = buffer.readFloat();
        let targetId = buffer.readShort();
        if (targetId < 0)
            item.targetId = "";
        else
            item.targetId = targetId;
        item.label = buffer.readS();
        let tween = buffer.readBool();
        item.tween = tween;
        if (tween) {
            buffer.seek(curPos, 1);

            item.tweenConfig = { "startValue": {}, "endValue": {} };
            item.tweenConfig.duration = buffer.readFloat();
            if (item.time + item.tweenConfig.duration > data.totalDuration)
                data.totalDuration = item.time + item.tweenConfig.duration;
            item.tweenConfig.easeType = buffer.readByte();
            item.tweenConfig.repeat = buffer.readInt();
            item.tweenConfig.yoyo = buffer.readBool();
            item.tweenConfig.label2 = buffer.readS();

            buffer.seek(curPos, 2);

            decodeValue(item, buffer, item.tweenConfig.startValue);

            buffer.seek(curPos, 3);

            decodeValue(item, buffer, item.tweenConfig.endValue);

            if (buffer.version >= 2) {
                let pathLen = buffer.readInt();
                if (pathLen > 0) {
                    item.tweenConfig.path = {};
                    let pts = [];
                    for (let j = 0; j < pathLen; j++) {
                        let curveType = buffer.readByte();
                        let x = buffer.readFloat();
                        let y = buffer.readFloat();
                        let control1_x, control1_y, control2_x, control2_y;
                        switch (curveType) {
                            case 1:
                                control1_x = buffer.readFloat();
                                control1_y = buffer.readFloat();
                                pts.push({
                                    x, y, control1_x, control1_y
                                });
                                break;
                            case 2:
                                control1_x = buffer.readFloat();
                                control1_y = buffer.readFloat();
                                control2_x = buffer.readFloat();
                                control2_y = buffer.readFloat();
                                pts.push({
                                    x, y, control1_x, control1_y, control2_x, control2_y
                                });
                                break;

                            default:
                                pts.push({
                                    x,
                                    y,
                                    curveType
                                });
                                break;
                        }
                    }
                    item.tweenConfig.path = pts;
                }
            }
        } else {
            if (item.time > data.totalDuration)
                data.totalDuration = item.time;
            buffer.seek(curPos, 2);

            decodeValue(item, buffer, item.value);
        }

        buffer.pos = curPos + dataLen;
    }
    return data;
}

function decodeValue(item, buffer, value) {
    switch (item.type) {
        case 0: // XY
        case 1: // Size
        case 3: // Pivot
        case 13: // Skew
            value.b1 = buffer.readBool();
            value.b2 = buffer.readBool();
            value.f1 = buffer.readFloat();
            value.f2 = buffer.readFloat();

            if (buffer.version >= 2 && item.type == 0)
                value.b3 = buffer.readBool(); //percent
            break;

        case 4: // Alpha
        case 5: // Rotation
            value.b1 = value.b2 = true;
            value.f1 = buffer.readFloat();
            break;

        case 2: // Scale
            value.b1 = value.b2 = true;
            value.f1 = buffer.readFloat();
            value.f2 = buffer.readFloat();
            break;

        case 6: // Color
            value.b1 = value.b2 = true;
            value.f1 = buffer.readColor();
            break;

        case 7: // Animation
            value.playing = buffer.readBool();
            value.frame = buffer.readInt();
            break;

        case 8: // Visible
            value.visible = buffer.readBool();
            break;

        case 9: // Sound
            value.sound = buffer.readS();
            value.volume = buffer.readFloat();
            break;

        case 10: // Transition
            value.transName = buffer.readS();
            value.playTimes = buffer.readInt();
            break;

        case 11: // Shake
            value.amplitude = buffer.readFloat();
            value.shakeDuration = buffer.readFloat();
            break;

        case 12: // ColorFilter
            value.b1 = value.b2 = true;
            value.f1 = buffer.readFloat();
            value.f2 = buffer.readFloat();
            value.f3 = buffer.readFloat();
            value.f4 = buffer.readFloat();
            break;

        case 14: // Text
        case 15: // Icon
            value.text = buffer.readS();
            break;
    }
}

function relationSetup(buffer, parentToChild) {
    let data = { "items": [] };
    let cnt = buffer.readByte();
    for (let i = 0; i < cnt; i++) {
        let targetIndex = buffer.readShort();
        let newItem = { "relations": [], targetIndex };
        if (targetIndex != -1) {
            newItem.targetIndex = targetIndex;
            newItem.parentToChild = parentToChild;
        }
        data.items.push(newItem);

        let cnt2 = buffer.readByte();
        for (let j = 0; j < cnt2; j++) {
            let rt = buffer.readByte();
            let usePercent = buffer.readBool();
            let relation = { rt, usePercent };
            newItem.relations.push(relation);
        }
    }
    return data;
}

function setupScroll(buffer) {
    let data = { "scrollBarMargin": {} };
    data.scrollType = buffer.readByte();
    let scrollBarDisplay = buffer.readByte();
    let flags = buffer.readInt();
    data.flags = flags;
    if (buffer.readBool()) {
        data.scrollBarMargin.top = buffer.readInt();
        data.scrollBarMargin.bottom = buffer.readInt();
        data.scrollBarMargin.left = buffer.readInt();
        data.scrollBarMargin.right = buffer.readInt();
    }
    data.vtScrollBarRes = buffer.readS();
    data.hzScrollBarRes = buffer.readS();
    data.headerRes = buffer.readS();
    data.footerRes = buffer.readS();
    data.scrollBarDisplay = scrollBarDisplay;

    return data;
}

function gearSetup(buffer, gearType) {
    let gearName = GearType[gearType];
    let data = { "pages": [], gearName };
    data.controllerId = buffer.readShort(); //  controller id
    let i;
    let page, status;
    let cnt = buffer.readShort();
    data.status = [];
    data.extStatus = [];
    // controller in this parent 
    if (gearName == "gearDisplay" || gearName == "gearDisplay2") {  // GearDisplay GearDisplay2
        data.pages = buffer.readSArray(cnt);
    } else {
        for (i = 0; i < cnt; i++) {
            page = buffer.readS();
            if (page == null) {
                // page = i + "";
                // status = {};
                continue;
            }
            status = addStatus(gearType, buffer);

            data.pages.push(page);
            data.status.push(status);
        }

        if (buffer.readBool()) {// default
            data.defaultValues = addStatus(gearType, buffer);
        }
    }

    if (buffer.readBool()) {
        data.tweenConfig = { tween: true };
        data.tweenConfig.ease = buffer.readByte();
        data.tweenConfig.duration = buffer.readFloat();
        data.tweenConfig.delay = buffer.readFloat();
    }

    if (buffer.version >= 2) {
        // positionsInPercent && condition
        if (gearName == "gearXY") { // gearXY
            if (buffer.readBool()) {
                data.positionsInPercent = true;
                for (i = 0; i < cnt; i++) {
                    page = buffer.readS();
                    if (page === null) {
                        extStatus = {}
                    }
                    extStatus = addExtStatus(buffer)
                    data.extStatus.push(extStatus);
                }

                if (buffer.readBool())
                    data.defaultExtStatus = addExtStatus(null, buffer);
            }
        } else if (gearName == "gearDisplay2") {// GearDisplay2
            data.condition = buffer.readByte();
        }
    }
    return data;
}

function addStatus(type, buffer) {
    let data = {};
    switch (GearType[type]) {
        case "gearSize":
            data.width = buffer.readInt();
            data.height = buffer.readInt();
            data.scaleX = buffer.readFloat();
            data.scaleY = buffer.readFloat();
            break;
        case "gearIcon":
            data.default = buffer.readS();
            break;
        case "gearFontSize":
            data.default = buffer.readInt();
            break;
        case "gearColor":
            data.color = buffer.readColor();
            data.strokeColor = buffer.readColor();
            break;
        case "gearText":
            data.default = buffer.readS();
            break;
        case "gearXY":
            data.x = buffer.readInt();
            data.y = buffer.readInt();
            break;
        case "gearLook":
            data.alpha = buffer.readFloat();
            data.rotation = buffer.readFloat();
            data.grayed = buffer.readBool();
            data.touchable = buffer.readBool();
            break;
        case "gearAni":
            data.playing = buffer.readBool();
            data.frame = buffer.readInt();
            break;
        default:
            debugger;
            break;
    }
    return data;
}

function addExtStatus(buffer) {
    let data = {};
    data.px = buffer.readFloat().toFixed(3);
    data.py = buffer.readFloat().toFixed(3);
    return data;
}

function setup_beforeAdd(type, buffer, position) {
    let content = {};
    let object = decodeGObjectBefore(buffer, position);
    switch (type) {
        case 0: // Image
            content = decodeImageBefore(buffer, position);
            break;

        case 1: // MovieClip
            content = decodeMovieClipBefore(buffer, position);
            break;

        case 3: // GGraph
            content = decodeGraphBefore(buffer, position);
            break;

        case 4: // Loader
            content = decodeLoaderBefore(buffer, position);
            break;

        case 5: // Group:
            content = decodeGroupBefore(buffer, position);
            break;

        case 6: // Text
            content = decodeTextFieldBefore(buffer, position);
            break;

        case 7: // RichText
            content = decodeTextFieldBefore(buffer, position);
            break;

        case 8: // InputText
            content = decodeTextInputBefore(buffer, position);
            break;

        case 9: // Gcomponet

            break;
        case 10: // Glist
            content = decodeListBefore(buffer, position);
            break;
        case 17: // GTree
            content = decodeTreeBefore(buffer, position);
            break;
        default:
            break;
    }
    return Object.assign(object, content);
}

function setup_afterAdd(type, buffer, position) {
    let object = decodeGObjectAfter(buffer, position);;
    let data = { "content": {}, "component": {} };
    switch (type) {
        case 6: // Text
            data.content = decodeTextFieldAfter(buffer, position);
            break;
        case 7: // RichText
            data.content = decodeTextFieldAfter(buffer, position);
            break;

        case 8: // InputText
            data.content = decodeTextFieldAfter(buffer, position);
            break;

        case 9: // Gcomponet
            data.content = decodeComponetAfter(buffer, position);
            break;
        case 10: // List
            data.component = decodeComponetAfter(buffer, position);
            data.content = decodeListAfter(buffer, position);
            break;

        case 11: // Label
            data.component = decodeComponetAfter(buffer, position);
            data.content = decodeLabelAfter(buffer, position);
            break;

        case 12: // Button
            data.component = decodeComponetAfter(buffer, position);
            data.content = decodeButtonAfter(buffer, position);
            break;

        case 13: // ComboBox
            data.component = decodeComponetAfter(buffer, position);
            data.content = decodeComboBoxAfter(buffer, position);
            break;

        case 14: // ProgressBar
            data.component = decodeComponetAfter(buffer, position);
            data.content = decodeProgressBarAfter(buffer, position);
            break;

        case 15: // Slider
            data.component = decodeComponetAfter(buffer, position);
            data.content = decodeSliderAfter(buffer, position);
            break;
        default:
            break;
    }
    return Object.assign(object, data.component, data.content, { type });
}

function decodeProgressBarAfter(rawData, position) {
    let data = {};
    if (!rawData.seek(position, 6)) {
        return;
    }

    if (rawData.readByte() != 14) {
        return;
    }

    data.value = rawData.readInt();
    data.max = rawData.readInt();
    if (rawData.version >= 2)
        data.min = rawData.readInt();
    return data;
}

function decodeSliderAfter(rawData, position) {
    let data = {};
    if (!rawData.seek(position, 6)) {
        return;
    }

    if (rawData.readByte() != 15) {
        return;
    }

    data.value = rawData.readInt();
    data.max = rawData.readInt();
    if (rawData.version >= 2)
        data.min = rawData.readInt();
    return data;
}

function decodeImageBefore(rawData, position) {
    let data = {
        "image": {}
    };
    rawData.seek(position, 5);

    if (rawData.readBool())
        data.color = rawData.readColor();
    data.flip = rawData.readByte();
    data.image.fillMethod = rawData.readByte();
    if (data.image.fillMethod != 0) {
        data.image.fillOrigin = rawData.readByte();
        data.image.fillClockwise = rawData.readBool();
        data.image.fillAmount = rawData.readFloat();
    }
    return data;
}

function decodeComboBoxAfter(rawData, position) {
    let data = { "items": [], "values": [] };
    if (!rawData.seek(position, 6))
        return;

    if (rawData.readByte() != 13)
        return;

    let i;
    let iv;
    let nextPos;
    let str;
    let itemCount = rawData.readShort();
    for (i = 0; i < itemCount; i++) {
        nextPos = rawData.readShort();
        nextPos += rawData.pos;

        data.items[i] = rawData.readS();
        data.values[i] = rawData.readS();
        str = rawData.readS();
        if (str != null) {
            if (data.icons == null)
                data.icons = [];
            data.icons[i] = str;
        }

        rawData.pos = nextPos;
    }

    str = rawData.readS();
    if (str != null) {
        data.text = str;
        data.selected = data.items.indexOf(str);
    }
    else if (data.items.length > 0) {
        data.selected = 0;
        data.text = data.items[0];
    }
    else
        data.selected = -1;

    str = rawData.readS();
    if (str != null)
        data.icon = str;

    if (rawData.readBool())
        data.titleColor = rawData.readColor();
    iv = rawData.readInt();
    if (iv > 0)
        data.visibleItemCount = iv;
    data.popupDirection = rawData.readByte();

    iv = rawData.readShort();
    if (iv >= 0)
        data.selectionController = iv;
    if (rawData.version >= 5) {
        str = rawData.readS();
        if (str != null)
            data.sound = str;
        data.volume = rawData.readFloat();
    }
    return data;
}

function decodeMovieClipBefore(rawData, position) {
    let data = {
        "movieClip": {
            "graphics": {}
        }
    };
    rawData.seek(position, 5);

    if (rawData.readBool())
        data.color = rawData.readColor();
    data.movieClip.graphics.flip = rawData.readByte(); //flip
    data.movieClip.frame = rawData.readInt();
    data.movieClip.playing = rawData.readBool();

    return data;
}

function decodeLabelAfter(rawData, position) {
    let data = {};
    if (!rawData.seek(position, 6))
        return;

    if (rawData.readByte() != 11)
        return;

    let str;
    str = rawData.readS();
    if (str != null)
        data.title = _.escape(str);
    str = rawData.readS();
    if (str != null)
        data.icon = str;
    if (rawData.readBool())
        data.titleColor = rawData.readColor();
    let iv = rawData.readInt();
    if (iv != 0)
        data.titleFontSize = iv;

    if (rawData.readBool()) {
        debugger;
        let input = data.getTextField();
        if (input instanceof GTextInput) { // todo
            str = rawData.readS();
            if (str != null)
                input.prompt = str;

            str = rawData.readS();
            if (str != null)
                input.restrict = str;

            iv = rawData.readInt();
            if (iv != 0)
                input.maxLength = iv;
            iv = rawData.readInt();
            if (iv != 0) {
                if (iv == 4)
                    input.keyboardType = 'number';
                else if (iv == 3)
                    input.keyboardType = 'url';
            }
            if (rawData.readBool())
                input.password = true;
        }
        else
            rawData.skip(13);
    }

    return data;
}

function decodeButtonAfter(rawData, position) {
    let data = {};
    if (!rawData.seek(position, 6))
        return;

    if (rawData.readByte() != 12)
        return;
    let str;
    let iv;

    str = rawData.readS();
    if (str != null)
        data.title = _.escape(str);
    str = rawData.readS();
    if (str != null)
        data.selectedTitle = str;
    str = rawData.readS();
    if (str != null)
        data.icon = str;
    str = rawData.readS();
    if (str != null)
        data.selectedIcon = str;
    if (rawData.readBool())
        data.titleColor = rawData.readColor();
    iv = rawData.readInt();
    if (iv != 0)
        data.titleFontSize = iv;
    iv = rawData.readShort();
    if (iv >= 0)
        data.relatedController = iv; // data.parent.getControllerAt(iv);
    data.relatedPageId = rawData.readS();

    str = rawData.readS();
    if (str != null)
        data.sound = str;
    if (rawData.readBool())
        data.volume = rawData.readFloat();

    data.selected = rawData.readBool();

    return data;
}

function decodeListAfter(rawData, position) {
    let data = {};
    rawData.seek(position, 6);

    let i = rawData.readShort();
    if (i != -1)
        data.selectionController = i;
    return data;
}

function parseFont(font) {
    let str = '';
    let { lineHeight, glyphs } = font;
    // todo complete font
    if (font.ttf) {
        str += `info creator=UIBuilder\ncommon lineHeight=${lineHeight}\n`; // todo
        for (let key in glyphs) {
            let glyph = glyphs[key];
            let { x, y, width, height, advance, page, bx, by, channel } = glyph;
            str += `char id=${key.charCodeAt()} x=${bx} y=${by} width=${width} height=${height} xoffset=${x} yoffset=${y} xadvance=${advance} page=${page || 0} chnl=${channel}\n`
        }
    } else {
        str += `info creator=UIBuilder\ncommon lineHeight=${lineHeight}\n`;
        for (let key in glyphs) {
            let glyph = glyphs[key];
            let { x, y, texture, advance } = glyph;
            str += `char id=${key.charCodeAt()} img=${texture} xoffset=${x} yoffset=${y} xadvance=${advance}\n`
        }
    }
    return str;
}

function setupController(buffer) {
    let controller = {
        "pageIds": [],
        "pageNames": [],
        "selected": []
    };

    let beginPos = buffer.pos;
    buffer.seek(beginPos, 0);

    controller.name = buffer.readS();
    if (buffer.readBool()) // autoRadioGroupDepth
        controller.autoRadioGroupDepth = true;

    buffer.seek(beginPos, 1);

    let i;
    let nextPos;
    let cnt = buffer.readShort();

    for (i = 0; i < cnt; i++) {
        controller.pageIds.push(buffer.readS());
        controller.pageNames.push(buffer.readS());
    }

    let homePageIndex = 0;
    if (buffer.version >= 2) {
        let homePageType = buffer.readByte();
        switch (homePageType) {
            case 1: // "specific"
                homePageIndex = buffer.readShort();
                break;

            case 2: // "branch"
                // homePageIndex = controller.pageNames.indexOf(UIPackage.branch);
                if (homePageIndex == -1)
                    homePageIndex = 0;
                break;

            case 3: // "letiable"
                // todo
                // homePageIndex = controller.pageNames.indexOf(UIPackage.getlet(buffer.readS()));
                if (homePageIndex == -1)
                    homePageIndex = 0;
                break;
        }
    }

    buffer.seek(beginPos, 2);



    cnt = buffer.readShort();
    if (cnt > 0) {
        if (!controller.actions)
            controller.actions = [];

        for (i = 0; i < cnt; i++) {
            nextPos = buffer.readShort();
            nextPos += buffer.pos;
            let type = buffer.readByte();
            let action = {};
            let count = buffer.readShort();
            action.fromPage = [];
            for (j = 0; j < count; j++)
                action.fromPage[j] = buffer.readS();

            count = buffer.readShort();
            action.toPage = [];
            for (j = 0; j < count; j++)
                action.toPage[j] = buffer.readS();
            if (type == 0) { // PlayTransitionAction
                action.transitionName = buffer.readS();
                action.playTimes = buffer.readInt();
                action.delay = buffer.readFloat();
                action.stopOnExit = buffer.readBool();
            } else if (type == 1) { // ChangePageAction
                action.objectId = buffer.readS();
                action.controllerName = buffer.readS();
                action.targetPage = buffer.readS();
            }
            controller.actions.push(action);

            buffer.pos = nextPos;
        }
    }

    if (controller.pageIds.length > 0)
        controller.selected = homePageIndex;
    else
        controller.selected = -1;
    return controller;
}

function decodeGObjectAfter(rawData, position) {
    let data = {};
    rawData.seek(position, 1);

    let str = rawData.readS();
    if (str)
        data.tooltips = str;

    let groupId = rawData.readShort();
    if (groupId >= 0)
        data.groupId = groupId;

    rawData.seek(position, 2);

    let cnt = rawData.readShort();
    data.gears = [];
    for (let i = 0; i < cnt; i++) {
        let nextPos = rawData.readShort();
        nextPos += rawData.pos;

        data.gearType = rawData.readByte();
        let gear = gearSetup(rawData, data.gearType);
        data.gears.push(gear);
        rawData.pos = nextPos;
    }
    return data;
}

function decodeGObjectBefore(rawData, position) {
    let data = {};
    rawData.seek(position, 0);
    rawData.skip(5);

    let f1;
    data.id = rawData.readS();
    data.name = _.escape(rawData.readS());
    // position 
    data.x = rawData.readInt();
    data.y = rawData.readInt();

    // size
    if (rawData.readBool()) {
        data.width = rawData.readInt();
        data.height = rawData.readInt();
    }

    if (rawData.readBool()) {
        data.minWidth = rawData.readInt();
        data.maxWidth = rawData.readInt();
        data.minHeight = rawData.readInt();
        data.maxHeight = rawData.readInt();
    }

    // scale
    if (rawData.readBool()) {
        data.scaleX = rawData.readFloat();
        data.scaleY = rawData.readFloat();
    }

    // skew
    if (rawData.readBool()) {
        data.skewX = rawData.readFloat();
        data.skewY = rawData.readFloat();
    }

    // pivot
    if (rawData.readBool()) {
        data.pivotX = rawData.readFloat();
        data.pivotY = rawData.readFloat();
        data.anchor = rawData.readBool();
    }

    f1 = rawData.readFloat();
    if (f1 != 1)
        data.alpha = f1;

    f1 = rawData.readFloat();
    if (f1 != 0)
        data.rotation = f1;

    if (!rawData.readBool())
        data.visible = false;
    if (!rawData.readBool())
        data.touchable = false;
    if (rawData.readBool())
        data.grayed = true;
    let bm = rawData.readByte();
    const BlendModeTranslate = {
        1: "none",
        2: "add",
        3: "multiply",
        4: "screen",
    }
    data.blend = BlendModeTranslate[bm] || null;

    let filter = rawData.readByte();
    if (filter == 1) {
        data.filter = "color";
        data.filterData = [rawData.readFloat().toFixed(2), rawData.readFloat().toFixed(2), rawData.readFloat().toFixed(2), rawData.readFloat().toFixed(2)];
    }

    let str = rawData.readS();
    if (str != null)
        data.customData = str;
    return data;
}

/** constructExtension */
function constructExtension(type, buffer) {
    let data = {};
    switch (type) {
        case 12:
            data = constructButton(buffer);
            break;
        case 13:
            data = constructComboBox(buffer);
            break;
        case 14:
            data = constructProgressBar(buffer);
            break;
        case 15:
            data = constructSlider(buffer);
            break;
        case 16:
            data = constructScrollBar(buffer);
            break;
        default:
            break;
    }
    return data;
}

function constructButton(buffer) {
    let data = {};
    buffer.seek(0, 6);
    /**
     *  Common,
        Check,
        Radio
     */
    data.mode = buffer.readByte();
    let str = buffer.readS();
    if (str)
        data.sound = str;
    data.soundVolumeScale = buffer.readFloat();
    data.downEffect = buffer.readByte();
    data.downEffectValue = buffer.readFloat();
    return data;
}

function constructComboBox(buffer) {
    let data = {};
    data.str = buffer.readS();
    return data;
}

function constructProgressBar(buffer) {
    let data = {};
    buffer.seek(0, 6);

    data.titleType = buffer.readByte();
    data.reverse = buffer.readBool();
    return data;
}

function constructSlider(buffer) {
    let data = {};
    buffer.seek(0, 6);

    data.titleType = buffer.readByte();
    data.reverse = buffer.readBool();
    if (buffer.version >= 2) {
        data.wholeNumbers = buffer.readBool();
        data.changeOnClick = buffer.readBool();
    }
    return data;
}

function constructScrollBar(buffer) {
    let data = {};
    buffer.seek(0, 6);
    data.fixedGripSize = buffer.readBool();
    return data;
}

function decodeBinary(buffer, isQuotePackage = false) {
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
        if (cnt > 0) { // todo
            debugger;
            // let _branches = buffer.readSArray(cnt);
            // if (_branch) {
            //     let _branchIndex = _branches.indexOf(_branch);
            // }
        }
        // branchIncluded = cnt > 0;
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
        let name = buffer.readS()
        pi.name = name ? _.escape(name) : name;
        pi.path = buffer.readS(); //path
        str = buffer.readS();
        if (str) {
            pi.file = str;
        }
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
                    pi.scaleOption = scaleOption;
                    pi.smoothing = buffer.readBool();
                    break;
                }
            case 1:// MovieClip:
                {
                    pi.smoothing = buffer.readBool();
                    pi.objectType = 1; // MovieClip;
                    pi.rawData = buffer.readBuffer();
                    !isQuotePackage ? UIPackage[pi.id] = pi : QuoteUIPackage[pi.id] = pi;
                    break;
                }
            case 5: // Font:
                {
                    pi.rawData = buffer.readBuffer();
                    !isQuotePackage ? UIPackage[pi.id] = pi : QuoteUIPackage[pi.id] = pi;
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
                    !isQuotePackage ? UIPackage[pi.id] = pi : QuoteUIPackage[pi.id] = pi;
                    break;
                }
            case 4: // Atlas:
                {
                    break;
                }
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
        let sprite = { atlas: pi['id'], rect: rect, offset: {}, originalSize: {} };
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
            if (pi && pi.type == 0) {
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
    return { "package.xml": _items, "sprites.bytes": _sprites, "files": _itemMap };
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

const parseJSON2XML = (json) => {
    let base = {
        "component": {
            "$": {},
            "controller": [],
            "displayList": {

            }
        }
    }
    let {
        width, height,
        objectType, overflow, clipSoftness,
        scroll, margin,
        hitTestId, controllers,
        transitions,
        pivotX, pivotY,
        anchor, relations,
        extensionData, children,
        opaque, maskId, reversedMask,
        rootContainer, remark,
    } = json;
    if (!scroll) scroll = {};
    let { flags, scrollBarMargin,
        footerRes, headerRes,
        vtScrollBarRes, hzScrollBarRes,
        scrollType, scrollBarDisplay } = scroll;

    let { component } = base;
    let { $ } = component;
    let size = `${width},${height}` != "undefined,undefined" ? `${width},${height}` : null;
    $.size = size;

    let pivot = `${pivotX},${pivotY}` != "undefined,undefined" ? `${pivotX},${pivotY}` : null;
    $.pivot = pivot;
    if (anchor) $.anchor = anchor;
    $.remark = remark;
    // scroll
    if (overflow) $.overflow = OverflowType[overflow];
    if (clipSoftness) {
        let { x, y } = clipSoftness;
        let clipSoftnessStr = `${x},${y}` != "0,0" ? `${x},${y}` : null;
        $.clipSoftness = clipSoftnessStr;
    }
    if (scrollType != 1) $.scroll = ScrollType[scrollType]; // default 1
    if (flags) $.scrollBarFlags = flags;
    if (scrollBarDisplay) $.scrollBar = ScrollBarDisplayType[scrollBarDisplay];
    if (scrollBarMargin && !_.isEmpty(scrollBarMargin)) {
        let { left, right, top, bottom } = scrollBarMargin;
        $.scrollBarMargin = `${top},${bottom},${left},${right}`;
    }
    if (hzScrollBarRes || vtScrollBarRes) $.scrollBarRes = `${vtScrollBarRes ? vtScrollBarRes : ""},${hzScrollBarRes ? hzScrollBarRes : ""}`;
    if (headerRes || footerRes) $.ptrRes = `${headerRes ? headerRes : ""},${footerRes ? footerRes : ""}`;

    if (margin) {
        let { top, bottom, left, right } = margin;
        let marginStr = `${top},${bottom},${left},${right}` != "0,0,0,0" ? `${top},${bottom},${left},${right}` : null;
        $.margin = marginStr;
    }
    if (hitTestId) $.hitTestId = hitTestId;
    if (maskId) $.mask = children[maskId]['content']['name'];
    if (reversedMask) $.reversedMask = reversedMask;
    if (!opaque) $.opaque = opaque;
    if (rootContainer) $.rootContainer = rootContainer;
    if (remark) $.remark = remark;

    if (objectType && objectType !== 9) {
        let type = ObjectType[objectType];
        $['extention'] = type;
        let extensionProps = parseExtension(type, extensionData);
        if (!_.isEmpty(extensionProps)) {
            component[type] = extensionProps;
        }
    }

    // relations
    if (relations && relations.items) {
        let relation = parseRelation(relations, json);
        Object.assign(component, { relation });
    }

    // controllers
    let controller = parseControllers(controllers);
    if (controller.length > 0) {
        component['controller'] = controller;
    }

    // transitions
    let transition = parseTransitions(transitions, json);
    if (transition.length > 0) {
        component['transition'] = transition;
    }

    // children
    if (children && children.length > 0) {
        component['displayList'] = parseDisplayList(json);
    }
    let xml = json2xml(base);
    xml = xml.replace(/_{\$(\w+)}_/g, "");
    return xml;
}

function parseControllers(controllers) {
    controllers = controllers || [];
    return controllers.map((controller) => {
        let { name, selected, pageIds, pageNames } = controller;
        let pages = "";
        pageIds.forEach((pageId, idx, arr) => {
            if (idx == arr.length - 1) {
                pages += `${pageId},${pageNames[idx]}`;
            } else {
                pages += `${pageId},${pageNames[idx]},`;
            }
        })
        return { $: { name, pages, selected } };
    })
}

function parseTransitions(transitions, parent) {
    transitions = transitions || [];
    return transitions.map((transition) => {
        let { name, options, autoPlay, autoPlayTimes, autoPlayDelay, items } = transition;
        let $ = { name };
        if (options) $.options = options;
        if (autoPlay) $.autoPlay = autoPlay;
        if (autoPlay && autoPlayTimes) $.autoPlayTimes = autoPlayTimes;
        if (autoPlayDelay) $.autoPlayDelay = autoPlayDelay;
        let item = [];
        let { width, height, children } = parent;
        items.forEach((ele) => {
            let { type, value, time, targetId, label, tweenConfig, tween } = ele;
            let target;
            if (targetId === "") {
                targetId = 0;
            } else {
                target = children[targetId]['content']['id'];
            }
            time *= defaultFPS;
            time = time.toFixed(0);
            if (!tween) {
                let args = getActionValue(type, value, width, height);
                item.push({
                    $: {
                        time,
                        type: ActionType[type],
                        target,
                        label,
                        value: args
                    }
                });
            } else {
                let { duration, easeType, repeat, yoyo, label2, startValue, endValue } = tweenConfig;
                let startValueArgs = getActionValue(type, startValue, width, height);
                let endValueArgs = getActionValue(type, endValue, width, height);
                if (!yoyo) yoyo = null;
                if (!repeat) repeat = null;
                duration *= defaultFPS;
                duration = duration.toFixed(0);
                ease = easeType != 5 ? EaseType[easeType] : null;
                item.push({
                    $: {
                        time,
                        type: ActionType[type],
                        target,
                        label,
                        tween,
                        startValue: startValueArgs,
                        endValue: endValueArgs,
                        duration, repeat, yoyo, label2, ease
                    }
                });
            }
        })
        return { $, item }
    })
}

function getActionValue(type, value, width, height) {
    let { b1, b2,
        b3,
        f1, f2, f3, f4,
        playing, frame,
        visible, sound,
        volume, transName,
        playTimes, amplitude,
        shakeDuration, text } = value;
    let args;
    switch (type) {
        case 0:
            if (b3) { //percent
                let pw = b1 ? (width * f1).toFixed(0) : "-";
                let ph = b2 ? (height * f2).toFixed(0) : "-";

                if (f1 != "-" && f1 != 1 & f1 != 0) f1 = f1.toFixed(3);
                if (f2 != "-" && f2 != 1 & f2 != 0) f2 = f2.toFixed(3);
                args = `${pw},${ph},${f1},${f2}`;
            } else {
                if (!b1) f1 = "-";
                if (!b2) f2 = "-";
                args = `${f1},${f2}`;
            }
            break;
        case 1: // Size
            f1 = b1 ? f1 : "-";
            f2 = b2 ? f2 : "-";
            if (f1 != 1 && f1 != 0 && f1 != "-") f1 = f1.toFixed(0);
            if (f2 != 1 && f2 != 0 && f2 != "-") f2 = f2.toFixed(0);
            args = `${f1},${f2}`;
            break;
        case 3: // Pivot
            args = `${f1},${f2}`;
            break;
        case 13: // Skew
            f1 = b1 ? f1 : "-";
            f2 = b2 ? f2 : "-";
            if (f1 != 1 && f1 != 0 && f1 != "-") f1 = f1.toFixed(1);
            if (f2 != 1 && f2 != 0 && f2 != "-") f2 = f2.toFixed(1);
            args = `${f1},${f2}`;
            break;
        case 4: // Alpha
            if (f1 != 0 && f1 != 1) f1 = f1.toFixed(1)
            args = `${f1}`;
            break;
        case 5: // Rotation
            args = `${f1}`;
            break;

        case 2: // Scale
            args = `${f1},${f2}`;
            break;

        case 6: // Color
            args = `${f1}`;
            break;

        case 7: // Animation
            args = `${frame},${playing ? "p" : "s"}`;
            break;

        case 8: // Visible
            args = `${visible}`;
            break;

        case 9: // Sound
            args = `${sound},${Math.round(volume * 100)}`;
            break;

        case 10: // Transition
            args = `${transName},${playTimes}`;
            break;

        case 11: // Shake
            args = `${amplitude},${shakeDuration}`;
            break;

        case 12: // ColorFilter
            args = `${f1},${f2},${f3},${f4}`;
            break;

        case 14: // Text
        case 15: // Icon
            args = `${text}`;
            break;
    }
    return args;
}

function parseDisplayList(parent) {
    let { controllers, children } = parent;
    let displayList = {
        // "_{$1}_image": [],
    };
    children.forEach((child, idx) => {
        let { type, src, pkgId, content, relations, path, packageItemType, file } = child;
        let objectType = ObjectType[type];
        let { width, height,
            minWidth, maxWidth,
            minHeight, maxHeight,
            scaleX, scaleY,
            skewX, skewY,
            id, name,
            x, y,
            rotation,
            pivotX, pivotY,
            gears, grayed,
            groupId, touchable,
            visible, anchor,
            alpha, customData,
            blend, filter, filterData,
            tooltips } = content;
        let image = imagesFileMap[src];
        let size = `${width},${height}` != "undefined,undefined" ? `${width},${height}` : null;
        if(image&&!size){
            size = `${image.width},${image.height}`
        }
        let restrictSize = `${minWidth},${maxWidth},${minHeight},${maxHeight}` != "undefined,undefined,undefined,undefined" ? `${minWidth},${maxWidth},${minHeight},${maxHeight}` : null;
        let scale = `${scaleX},${scaleY}` != "undefined,undefined" ? `${Math.round(scaleX * 100) / 100},${Math.round(scaleY * 100) / 100}` : null;
        let skew = `${skewX},${skewY}` != "undefined,undefined" ? `${skewX},${skewY}` : null;
        let xy = `${x},${y}`;

        if (alpha) alpha = alpha.toFixed(2);
        let pivot = `${pivotX},${pivotY}` != "undefined,undefined" ? `${pivotX},${pivotY}` : null;
        anchor ? anchor : anchor = null;
        if (filter) filterData = filterData.join(",");
        let fileName, pkg = null;
        let GObjectData = parseObject(objectType, content, controllers);
        let { objectData, extensionData, item } = GObjectData;
        if (src) {
            let fileExt = PackageItemType[packageItemType];
            if (!fileExt) {
                // throw new Error("PackageItemType undefined!!");
                fileExt = ".xml";
            }

            if (fileExt == "Sound") {
                fileName = path.slice(1, path.length) + file;
            } else {
                if (!path) {
                    // debugger;
                    //     // fileName = name + fileExt;
                } else {
                    fileName = path.slice(1, path.length) + file + fileExt;
                }
            }
        }
        let group;
        if (parseFloat(groupId).toString() != "NaN") {
            group = parent["children"][groupId]['content']['id'];
        }
        if (pkgId) {
            pkg = pkgId;
        }
        let originData = {
            "$": { id, name, src, fileName, pkg, xy, pivot, anchor, size, restrictSize, scale, skew, rotation, blend, filter, filterData, customData, tooltips, alpha, touchable, grayed, group, visible }
        };
        if (objectData) Object.assign(originData["$"], objectData);

        // gear
        if (gears.length > 0) {
            let gearObject = parseGear(gears, parent, content);
            Object.assign(originData, gearObject);
        }

        // relation
        if (relations && relations.items) {
            let relation = parseRelation(relations, parent);
            Object.assign(originData, { relation });
        }
        if (extensionData) Object.assign(originData, extensionData);
        if (objectType === "Tree") objectType = "List";
        if (objectType === "InputText") objectType = "Text";
        displayList[`_{$${idx}}_${objectType.toLocaleLowerCase()}`] = originData;
        if (item) {
            displayList[`_{$${idx}}_${objectType.toLocaleLowerCase()}`]['item'] = item;
        }
    })
    return displayList;
}

function parseObject(objectType, content, controllers) {
    let { align, vAlign, items } = content;
    let objectData = {}, extensionData = {}, item;
    switch (objectType) {
        case "Image":
            {
                let { image, flip, color } = content;
                if (!image) image = {};
                let { fillMethod, fillOrigin, fillClockwise, fillAmount } = image;
                if (color) objectData.color = rgbaToHex(color, false);
                if (flip) objectData.flip = FlipType[flip];
                if (fillMethod) objectData.fillMethod = fillMethodType[fillMethod];
                if (fillOrigin) objectData.fillOrigin = FillOrigin[fillOrigin];
                if (!fillClockwise) objectData.fillClockwise = fillClockwise;
                if (parseFloat(fillAmount).toString() != "NaN" && fillAmount != 1) {
                    objectData.fillAmount = +(+fillAmount.toFixed(2)) * 100;
                }
            }
            break;
        case "MovieClip":
            let { movieClip, color } = content;
            if (!movieClip) movieClip = {};
            let { frame, playing } = movieClip;
            if (frame) objectData.frame = frame;
            if (!playing) objectData.playing = playing;
            if (color) objectData.color = color;
            break;
        case "Graph":
            {
                let { shape } = content;
                let { lineSize, lineColor,
                    fillColor, cornerRadius,
                    distances, points,
                    sides, startAngle } = shape;
                if (!shape) shape = {};
                objectData.type = GraphType[shape.type];
                if (lineSize != 1) objectData.lineSize = lineSize; // default
                if (lineColor != "#ff000000") objectData.lineColor = lineColor;
                if (fillColor != "#ffffffff") objectData.fillColor = fillColor;
                if (cornerRadius) objectData.corner = `${cornerRadius[0]}`;
                objectData.sides = sides;
                if (startAngle) objectData.startAngle = startAngle;
                objectData.distances = distances;
                objectData.points = points;
            }
            break;
        case "Text":
            objectData = parseText(content);
            break;
        case "RichText":
            objectData = parseText(content);
            break;
        case "InputText":
            let { prompt, keyboardType, password, maxLength, restrict } = content;
            objectData = parseText(content);
            if (restrict) objectData.restrict = restrict;
            objectData.input = true;
            if (prompt) objectData.prompt = prompt;
            if (keyboardType) objectData.keyboardType = keyboardType;
            if (password) objectData.password = password;
            if (maxLength) objectData.maxLength = maxLength;
            break;
        case "Component":
            let { type } = content;
            let extensionName = ObjectType[type];
            switch (extensionName) {
                case "ProgressBar":
                    {
                        let { value, max } = content;
                        extensionData[extensionName] = {
                            "$": { value, max }
                        };
                    }
                    break;
                case "Button":
                    {
                        let { title, selectedTitle,
                            icon,
                            selectedIcon, titleColor,
                            titleFontSize, relatedController,
                            relatedPageId, sound,
                            volume, selected } = content;
                        extensionData[extensionName] = { "$": {} };
                        if (selected) {
                            extensionData[extensionName]["$"] = { "checked": selected };
                        }
                        let controller;
                        if (relatedController == 0 || relatedController) {
                            controller = controllers[relatedController]['name'];
                        }
                        Object.assign(extensionData[extensionName]["$"], {
                            title, selectedTitle,
                            icon, selectedIcon,
                            titleColor, titleFontSize, controller,
                            "page": relatedPageId, sound, volume
                        });
                    }
                    break;
                case "Component":
                    extensionData[extensionName] = { "$": {} };
                    break;
                case "Label":
                    {

                        let { title, icon, titleColor, titleFontSize } = content;
                        if (titleColor) titleColor = rgbaToHex(titleColor, false);
                        extensionData[extensionName] = {
                            "$": { title, titleColor, icon, titleFontSize }
                        };
                    }
                    break;
                case "ComboBox":
                    {
                        let { items, values,
                            icons, popupDirection,
                            // selected, 
                            text, sound,
                            volume,
                            titleColor, visibleItemCount,
                            selectionController } = content;
                        let item = [];
                        items.forEach((ele, idx) => {
                            let icon = icons ? icons[idx] : null;
                            let value = values ? values[idx] : null;
                            item.push({ $: { title: _.escape(ele), value, icon } })
                        })
                        if (selectionController > -1) selectionController = controllers[selectionController]['name'];
                        if (!visibleItemCount) visibleItemCount = null;
                        let direction;
                        if (popupDirection) direction = PopupDirection[popupDirection];
                        if (titleColor) titleColor = rgbaToHex(titleColor, false);
                        if (volume != 1) {
                            volume = (volume * 100).toFixed(0);
                        } else {
                            volume = null;
                        }
                        if (items[0] == text) text = null;
                        extensionData[extensionName] = {
                            "$": { title: text ? _.escape(text) : text, titleColor, visibleItemCount, direction, selectionController, sound, volume },
                            item
                        };
                    }
                    break;
                case "Slider":
                    let { value, max, min } = content;
                    if (!min) min = null;
                    extensionData[extensionName] = {
                        "$": { value, max, min }
                    }
                    break;
                default:
                    console.log(extensionName);
                    debugger;
                    break;
            }
            deleteObjectProps(extensionData[extensionName]["$"])
            if (_.isEmpty(extensionData[extensionName]["$"])) {
                extensionData = {};
            }
            break;
        case "Loader":
            {
                let { shrinkOnly, url, fill } = content;
                let loader = content.content;
                if (!loader) loader = {};
                let { fillMethod, frame, playing, fillOrigin, fillClockwise, fillAmount } = loader;
                objectData.url = url;
                if (fillMethod) objectData.fillMethod = fillMethodType[fillMethod];
                if (fillOrigin) objectData.fillOrigin = FillOrigin[fillOrigin];
                objectData.fillClockwise = fillClockwise;
                objectData.fillAmount = fillAmount;
                objectData.align = align == "left" ? null : align;
                objectData.vAlign = vAlign == "top" ? null : vAlign;
                if (fill) objectData.fill = LoaderFillType[fill];
                if (shrinkOnly) objectData.shrinkOnly = shrinkOnly;
                if (frame) objectData.frame = frame;
                if (!playing) objectData.playing = playing;
            }
            break
        case "List":
            objectData = parseList(content);
            item = [];
            items.forEach((ele) => {
                item.push({
                    "$": ele
                });
            });
            break;
        case "Tree":
            objectData = parseList(content);
            objectData.treeView = true;
            let { indent, clickToExpand } = content;
            objectData.indent = indent;
            objectData.clickToExpand = clickToExpand;
            item = [];
            items.forEach((ele) => {
                item.push({
                    "$": ele
                });
            });
            break;
        case "Group":
            let { advanced, layout, lineGap, colGap, excludeInvisibles, autoSizeDisabled, mainGridIndex } = content;
            objectData.advanced = advanced;
            if (layout) objectData.layout = layout;
            if (lineGap) objectData.lineGap = lineGap;
            if (colGap) objectData.colGap = colGap;
            if (excludeInvisibles) objectData.excludeInvisibles = excludeInvisibles;
            if (autoSizeDisabled) objectData.autoSizeDisabled = autoSizeDisabled;
            if (mainGridIndex > -1) objectData.mainGridIndex = mainGridIndex;
            break;
        default:
            console.log(objectType, content);
            debugger;
            break;
    }
    return { objectData, extensionData, item };
}

function parseGear(gears, parent) {
    let { controllers, width, height } = parent;
    let gearObject = {};
    gears.forEach((gear) => {
        let { controllerId, pages, gearName, status, extStatus, defaultValues, defaultExtStatus, tweenConfig, positionsInPercent, condition } = gear;
        let defaultStr;
        let values = status.map((item, idx) => {
            let value = "-";
            switch (gearName) {
                case "gearXY":
                    if (!_.isEmpty(item)) {
                        let { x, y } = item;
                        value = `${x},${y}`;
                        if (positionsInPercent) {
                            let = { px, py } = extStatus[idx];
                            value += `,${px},${py}`;
                        }
                    }
                    if (defaultValues && !_.isEmpty(defaultValues) && !defaultStr) {
                        let { x, y } = defaultValues;
                        defaultStr = `${x},${y}`;
                        if (positionsInPercent) {
                            let = { px, py } = defaultExtStatus[idx];
                            defaultStr += `,${px},${py}`;
                        }
                    }
                    break;
                case "gearSize":
                    if (!_.isEmpty(item)) {
                        let { width, height, scaleX, scaleY } = item;
                        value = `${width},${height},${scaleX},${scaleY}`;
                    }
                    if (defaultValues && !_.isEmpty(defaultValues) && !defaultStr) {
                        let { width, height, scaleX, scaleY } = defaultValues;
                        defaultStr = `${width},${height},${scaleX},${scaleY}`;
                    }
                    break;
                case "gearLook":
                    if (!_.isEmpty(item)) {
                        let { alpha, rotation, grayed, touchable } = item;
                        value = `${alpha.toFixed(2)},${rotation},${+grayed},${+touchable}`;
                    }
                    if (defaultValues && !_.isEmpty(defaultValues) && !defaultStr) {
                        let { alpha, rotation, grayed, touchable } = defaultValues;
                        defaultStr = `${alpha},${rotation},${+grayed},${+touchable}`;
                    }
                    break;
                case "gearColor":
                    if (!_.isEmpty(item)) {
                        let { color, strokeColor } = item;
                        // console.log(content); // todo compare object color & default
                        if (strokeColor == "rgb(0,0,0)") strokeColor = null; // version 3.0
                        value = `${rgbaToHex(color, false)},${rgbaToHex(strokeColor, false)}`;
                    }
                    if (defaultValues && !_.isEmpty(defaultValues) && !defaultStr) {
                        let { color, strokeColor } = defaultValues;
                        if (strokeColor == "rgb(0,0,0)") strokeColor = null; // version  3.0
                        defaultStr = `${rgbaToHex(color, false)},${rgbaToHex(strokeColor, false)}`;
                    }
                    break;
                case "gearAni":
                    if (!_.isEmpty(item)) {
                        let { frame, playing } = item;
                        value = `${frame},${playing ? "p" : "s"}`;
                    }
                    if (defaultValues && !_.isEmpty(defaultValues) && !defaultStr) {
                        let { frame, playing } = defaultValues;
                        defaultStr = `${frame},${playing ? "p" : "s"}`;
                    }
                    break;
                case "gearFontSize":
                    if (!_.isEmpty(item)) {
                        value = `${item.default}`;
                    }
                    if (defaultValues && !_.isEmpty(defaultValues) && !defaultStr) {
                        defaultStr = `${defaultValues.default}`;
                    }
                    break;
                case "gearIcon":
                    if (!_.isEmpty(item)) {
                        value = `${item.default}`;
                    }
                    if (defaultValues && !_.isEmpty(defaultValues) && !defaultStr) {
                        defaultStr = `${defaultValues.default}`;
                    }
                    break;
                case "gearText":
                    if (!_.isEmpty(item)) {
                        value = `${item.default}`;
                    }
                    if (defaultValues && !_.isEmpty(defaultValues) && !defaultStr) {
                        defaultStr = `${defaultValues.default}`;
                    }
                    break;

                default:
                    debugger;
                    break;
            }
            if (value && value.endsWith(',')) {
                value = value.slice(0, value.length - 1);
            }
            if (defaultStr && defaultStr.endsWith(',')) {
                defaultStr = defaultStr.slice(0, defaultStr.length - 1);
            }
            return value;
        });

        if (values.length == 0) {
            values = null;
        } else {
            values = values.join("|");
        }

        gearObject[gearName] = {
            "$": {
                "controller": controllers[controllerId]['name'],
                "pages": pages.join(","),
                values,
                condition,
                "default": defaultStr

            }
        }

        if (tweenConfig && tweenConfig.tween) {
            let { ease, delay, duration, tween } = tweenConfig;
            if (ease != 5) {
                ease = EaseType[ease];
            } else {
                ease = null;
            }
            duration = duration.toFixed(1);
            duration = duration == "0.3" ? null : duration.replace("0.", ".");

            if (delay === 0) {
                delay = null;
            } else {
                delay = delay.toString().replace("0.", ".");
            }
            Object.assign(gearObject[gearName]['$'], { tween, ease, duration, delay });
        }
        gearObject[gearName]['$']['positionsInPercent'] = positionsInPercent;
    });
    return gearObject;
}

function parseRelation(relations, parent) {
    let relation = [];
    relations.items.forEach((item) => {
        let $ = { "target": "", "sidePair": "" };
        let targetIndex = item.targetIndex;
        if (targetIndex > -1) {
            $.target = parent['children'][targetIndex]['content']['id'];
        }
        let sidePairs = item.relations.map((sidePair) => {
            let { rt, usePercent } = sidePair;
            rt = RelationType[rt];
            usePercent = usePercent ? "%" : "";
            return `${rt}${usePercent}`;
        });
        if (sidePairs) {
            $.sidePair = sidePairs.join(",");
        }
        relation.push({ $ });
    })
    return relation;
}

function parseExtension(type, extensionData) {
    let data = { $: {} };
    switch (type) {
        case "Button":
            let { downEffect, downEffectValue, mode, soundVolumeScale, sound } = extensionData;
            if (mode) data['$']['mode'] = ButtonMode[mode]
            if (sound) data['$']['sound'] = sound;
            if (soundVolumeScale > 1) data['$']['volume'] = volume
            if (downEffect) {
                data['$']['downEffect'] = downEffectType[downEffect];
                if (downEffectValue) data['$']['downEffectValue'] = (+downEffectValue.toFixed(2)).toString().replace("0.", ".");
            }
            break;
        case "Slider":
            {
                let {
                    reverse, changeOnClick,
                    titleType, wholeNumbers } = extensionData;
                if (titleType) data['$']['titleType'] = titleType;
                if (reverse) data['$']['reverse'] = reverse;
                if (wholeNumbers) data['$']['wholeNumbers'] = wholeNumbers;
                if (!changeOnClick) data['$']['changeOnClick'] = changeOnClick;
            }
            break;
        case "ProgressBar":
            {
                let { reverse, titleType } = extensionData;
                if (titleType) data['$']['titleType'] = ProgressTitleType[titleType];
                if (reverse) data['$']['reverse'] = reverse;
            }
            break;
        case "ComboBox":
            {
                let { str } = extensionData;
                if (str) data['$']['dropdown'] = str;
            }
            break;
        case "ScrollBar":
            {
                let { fixedGripSize } = extensionData;
                if (fixedGripSize) data['$']['fixedGripSize'] = fixedGripSize;
            }
            break;
        case "Label":
            data = {}
            break;
        default:
            console.log("parseExtension:", type, extensionData);
            break;
    }
    return data;
}

function parseList(content) {
    let objectData = {};
    let { defaultItem,
        align, vAlign,
        overflow, scroll,
        childrenRenderOrder, apexIndex,
        selectionMode, margin,
        autoResizeItem, scrollItemToViewOnClick,
        foldInvisibleItems, layout,
        lineGap, colGap,
        lineCount, columnCount,
        selectionController, clipSoftness } = content;
    if (!scroll) scroll = {};
    let { flags, scrollBarMargin,
        footerRes, headerRes,
        vtScrollBarRes, hzScrollBarRes,
        scrollType, scrollBarDisplay } = scroll;


    if (selectionMode) objectData.selectionMode = ListSelectionMode[selectionMode];
    if (layout) objectData.layout = ListLayoutType[layout];
    if (overflow) objectData.overflow = OverflowType[overflow];
    if (scrollType != 1) objectData.scroll = ScrollType[scrollType]; // default 1
    if (flags) objectData.scrollBarFlags = flags;
    if (scrollBarDisplay) objectData.scrollBar = ScrollBarDisplayType[scrollBarDisplay];
    if (scrollBarMargin && !_.isEmpty(scrollBarMargin)) {
        let { left, right, top, bottom } = scrollBarMargin;
        objectData.scrollBarMargin = `${top},${bottom},${left},${right}`;
    }

    if (hzScrollBarRes || vtScrollBarRes) objectData.scrollBarRes = `${vtScrollBarRes ? vtScrollBarRes : ""},${hzScrollBarRes ? hzScrollBarRes : ""}`;
    if (headerRes || footerRes) objectData.ptrRes = `${headerRes ? headerRes : ""},${footerRes ? footerRes : ""}`;
    if (margin) {
        let { top, bottom, left, right } = margin;
        let marginStr = `${top},${bottom},${left},${right}`;
        objectData.margin = marginStr;
    }
    if (clipSoftness) {
        let { x, y } = clipSoftness;
        let clipSoftnessStr = `${x},${y}` != "0,0" ? `${x},${y}` : null;
        objectData.clipSoftness = clipSoftnessStr;
    }
    if (lineGap) objectData.lineGap = lineGap;
    if (colGap) objectData.colGap = colGap;
    if (lineCount) objectData.lineCount = lineCount;
    if (columnCount) objectData.columnCount = columnCount;
    objectData.defaultItem = defaultItem;
    objectData.align = align == "left" ? null : align;
    objectData.vAlign = vAlign == "top" ? null : vAlign;
    if (childrenRenderOrder) objectData.renderOrder = ChildrenRenderOrder[childrenRenderOrder];
    if (apexIndex) objectData.apexIndex = apexIndex;
    objectData.autoItemSize = autoResizeItem;
    if (!scrollItemToViewOnClick) objectData.scrollItemToViewOnClick = scrollItemToViewOnClick;
    if (foldInvisibleItems) objectData.foldInvisibleItems = foldInvisibleItems;
    if (selectionController) objectData.selectionController = controllers[selectionController]['name'];
    return objectData;
}

function parseText(content) {
    let objectData = {};
    let { textFormat, singleLine,
        ubb, autoSize, text,
        align, verticalAlign, template } = content;
    if (!textFormat) textFormat = {};
    let { size, color,
        bold, underline,
        italic, letterSpacing,
        leading, font,
        strikethrough, shadowColor,
        shadowOffsetX, shadowOffsetY,
        outlineColor, outline } = textFormat;
    if (font) objectData.font = font;
    objectData.fontSize = size;
    objectData.color = color == "#000000" ? null : color;
    if (leading != 3) objectData.leading = leading;
    if (letterSpacing) objectData.letterSpacing = letterSpacing;
    objectData.align = align == "left" ? null : align;
    objectData.vAlign = verticalAlign == "top" ? null : verticalAlign;
    if (autoSize != 1) objectData.autoSize = AutoSizeType[autoSize]; // default:1
    if (underline) objectData.underline = underline;
    if (bold) objectData.bold = bold;
    if (italic) objectData.italic = italic;
    if (ubb) objectData.ubb = ubb;
    if (template) objectData.template = template;
    objectData.strokeColor = outlineColor;
    if (singleLine) objectData.singleLine = singleLine;
    if (parseFloat(outline).toString() != "NaN" && outline != 2) {
        if (outline > 0) {
            outline--;
        }
        objectData.strokeSize = outline - 1; // default:1
    }
    if (strikethrough) objectData.strikethrough = strikethrough;
    objectData.shadowColor = shadowColor;
    let shadowOffset = `${shadowOffsetX},${shadowOffsetY}` != "undefined,undefined" ? `${shadowOffsetX},${shadowOffsetY}` : null;
    objectData.shadowOffset = shadowOffset;
    objectData.text = text || "";
    return objectData;
}

/** utils  */
/**
 * use spritesMap to crop images
 * @param {*} spritesMap 
 * @param {*} flag  need file ext
 */
/**
 * 处理精灵图，从大图中裁剪出各个小图
 * @param {Object} spritesMap - 精灵图映射表
 * @param {boolean} flag - 标志位，默认为true
 * @param {Object} resFiles - 资源文件映射表
 * @returns {Promise<void>}
 */
const handleSprites = async (spritesMap, flag = true, resFiles) => {
    console.log("start crop image");
    
    // 尝试不同的Jimp导入方式
    let Jimp;
    try {
        // 尝试直接require并获取default属性
        const JimpModule = require('jimp');
        Jimp = JimpModule.default ? JimpModule.default : JimpModule;
        
        // 验证Jimp是否可用
        if (typeof Jimp !== 'function' && typeof Jimp.read !== 'function') {
            console.log('Jimp模块导入失败，尝试备用方法...');
            // 备用方案：如果Jimp不可用，使用简单的文件复制方式
            const fs = require('fs-extra');
            
            for (key in spritesMap) {
                let item = spritesMap[key];
                let { name, path, atlas } = item;
                if (!name) { 
                    name = key;
                    path = temp;
                }
                let output = path ? `${outputPath}${importFileName}${path}${name}` : `${outputPath}${importFileName}/${name}`;
                if (output.indexOf(".png") == -1) output += ".png";
                console.log(`跳过裁剪，创建空文件: ${output}`);
                
                // 确保目录存在
                const dir = require('path').dirname(output);
                if (!exists(dir)) {
                    mkdirs(dir);
                }
                
                // 创建空文件
                fs.writeFileSync(output, Buffer.alloc(0));
            }
            console.log("finish crop image (使用备用方法)");
            return;
        }
    } catch (err) {
        console.error("Jimp导入错误:", err);
        // 如果Jimp完全不可用，直接返回
        console.log("Jimp不可用，跳过图像处理");
        return;
    }
    
    // 如果Jimp可用，使用它来处理图像
    for (key in spritesMap) {
        let item = spritesMap[key];
        let { name, path, atlas, rect, rotated } = item;
        if (!name) { // atlas temp
            name = key;
            path = temp;
        }
        let output = path ? `${outputPath}${importFileName}${path}${name}` : `${outputPath}${importFileName}/${name}`;
        if (output.indexOf(".png") == -1) output += ".png";
        console.log(output);
        
        try {
            let imageName = exists(`${inputPath}${pkgName}@${atlas}.png`) ? `${inputPath}${pkgName}@${atlas}.png` : `${inputPath}${pkgName}_${atlas}.png`;
            if (!exists(imageName)) {
                imageName = `${inputPath}${pkgName}_${resFiles[atlas]['file']}`;
            }
            
            // 确保目录存在
            const dir = require('path').dirname(output);
            if (!exists(dir)) {
                mkdirs(dir);
            }
            
            // 尝试使用Jimp处理图像
            let image;
            if (typeof Jimp.read === 'function') {
                image = await Jimp.read(imageName);
            } else if (typeof Jimp === 'function') {
                image = await new Jimp(imageName);
            } else {
                console.log(`无法处理图像，创建空文件: ${output}`);
                require('fs-extra').writeFileSync(output, Buffer.alloc(0));
                continue;
            }
            
            let { x, y, width, height } = rect;
            let bitmap = image.crop(x, y, width, height);
            if (rotated) {
                bitmap = bitmap.rotate(-90);
            }
            
            // 使用正确的写入方法
            if (bitmap.writeAsync) {
                await bitmap.writeAsync(output);
            } else {
                await new Promise((resolve, reject) => {
                    bitmap.write(output, (err) => {
                        if (err) reject(err);
                        else resolve();
                    });
                });
            }
        } catch (err) {
            console.error(`处理图像 ${name} 时出错:`, err);
            // 出错时创建空文件以继续处理
            require('fs-extra').writeFileSync(output, Buffer.alloc(0));
        }
    }
    console.log("finish crop image");
}

const handleImages = async (imageMap) => {
    for (let key in imageMap) {
        let image = imageMap[key];
        let { file, name, path } = image;
        let ext = getFileExt(file)
        let fileName = name + ext;
        if(fs.existsSync(inputPath + file)){
            let out = outputPath+importFileName + path
            if(!fs.existsSync(out)){
                fs.mkdirSync(out.substring(0,out.length-1).replace(/\//g,"\\"));
            }
            fs.renameSync(inputPath + file, out + fileName);
        }
    }
}

const handleSound = async (soundInfo, flag = true) => {
    console.log("start handleSound");
    soundInfo.forEach((item) => {
        let sound = item['$'];
        let { file, path, name } = sound;
        let extName = file.split('.').pop();
        let output = path ? `${outputPath}${importFileName}${path}` : `${outputPath}${importFileName}/`;
        file = `${inputPath}${file}`;
        if (exists(file)) {
            if (!exists(output)) {
                mkdirs(resolve(output));
            }
            if (flag) {
                output = `${output}${name}.${extName}`;
            } else {
                output = `${output}${name}`;
            }
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
        let names = [`${inputPath}${pkgName}@${file}`, `${inputPath}${pkgName}_${file}`];
        if (names.some((name) => exists(name))) {
            return true;
        } else {
            console.warn(`FILE: ${inputPath}${pkgName}@${file} or ${inputPath}${pkgName}_${file} NOT FOUND!`);
            return false;
        }
    })) {
        throw "Atlas NOT FOUND!";
    }
}

const handleMovieclip = async (movieclipInfo, ext = true) => {
    console.log("start handleMovieclip");
    for (let key in movieclipInfo) {
        let movieclip = movieclipInfo[key];
        let { path, name } = movieclip;
        let dir = path ? `${outputPath}${importFileName}${path}` : `${outputPath}${importFileName}/`;
        let output = path ? `${outputPath}${importFileName}${path}${name}` : `${outputPath}${importFileName}/${name}`;
        if (!exists(dir)) {
            mkdirs(dir);
        }
        if (ext) output += ".jta";
        await createMovieClip(movieclip, tempPath, output);
    }
    console.log("finish handleMovieclip");
}

const createFileByData = (data, ext) => {
    console.log("start createFileByData");
    for (let key in data) {
        let item = data[key];
        let { path, content, name } = item;
        let output = path ? `${outputPath}${importFileName}${path}` : `${outputPath}${importFileName}/`;
        if (!exists(output)) {
            mkdirs(resolve(output));
        }
        output = `${output}${_.unescape(name)}${ext}`;
        fs.writeFileSync(output, content)
    }
    console.log("finish createFileByData");
}

function getFileExt(name) {
    let arr = name.split(".");
    return `.${arr[arr.length - 1]}`;
}

function encodeHTML(str) {
    if (!str)
        return "";
    else
        return str.replace(/&/g, "&amp;").replace(/</g, "&lt;")
            .replace(/>/g, "&gt;").replace(/'/g, "&apos;").replace(/"/g, "&quot;");
}

// restore(`./test/ModalWaiting.bin`, "./output/"); // test

exports.restore = restore











