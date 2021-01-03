const fs = require('fs');
const { parseStringPromise, Builder } = require('xml2js');
const uuidv4 = () => {
    return 'xxxxxxxxxxxx4xxxyxxxxxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
        let r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
        return v.toString(16);
    });
}

const ascii2Str = (num) => {
    return String.fromCharCode(num);
}

const exists = (path) => {
    return fs.existsSync(path);
}

const xml2json = (xml) => {
    return new Promise((resolve, reject) => {
        parseStringPromise(xml, { trim: true, explicitArray: false }).then((result) => {
            resolve(result);
        }).catch((err) => {
            reject(err);
        })
    })
}

const getItemById = (itemMap, id) => {
    let item;
    for (let key in itemMap) {
        let ele = itemMap[key];
        if (ele.id == id) {
            item = ele;
        }
    };
    return item;
}

const json2xml = (json) => {
    var builder = new Builder({ xmldec: { 'version': '1.0', 'encoding': 'UTF-8' } });
    return builder.buildObject(json);
}

const rgbaToHex = (str,alpha = true) => {
    const colorArr = str.match(/(0\.)?\d+/g);
    const color = colorArr.map((ele, index, array) => {
        if (index === array.length - 1 && alpha) {    
            let opacity = (ele * 100 * 255) / 100;
            return Math.round(opacity)
                .toString(16)
                .padEnd(2, "0");
        }
        return Number.parseFloat(ele)
            .toString(16)
            .padStart(2, "0");
    });
    if(alpha){
        color.unshift(color.pop());// argb
    }
    return `#${color.join("")}`;
}

module.exports.xml2json = xml2json;
module.exports.json2xml = json2xml;
module.exports.exists = exists;
module.exports.uuidv4 = uuidv4;
module.exports.ascii2Str = ascii2Str;
module.exports.getItemById = getItemById;
module.exports.rgbaToHex = rgbaToHex;