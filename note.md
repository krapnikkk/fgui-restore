## 生成id方法
function genDevCode(){
    let a = 0;
    let b = 0;
    let c = 0;
    while(b<4){
        c = Math.random() * 26;
        a = a + Math.pow(26, b) * (c + 10);
        b++;
    }
    a = a + (parseInt(Math.random() * 1000000) + parseInt(Math.random() * 222640));
    a = parseInt(a);
    return a.toString(36);
}

## 生成UID
function generateUID(){
    const FIX = parseInt(Math.random() * 36).toString(36).substr(0, 1);
    let a = "0000" + parseInt(Math.random() * 1679616).toString(36);
    let b = "000" + parseInt(Math.random() * 46656).toString(36);
    return FIX + a.substr(a.length - 4) + b.substr(b.length - 3);
}
