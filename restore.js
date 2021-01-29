var fguiRestore = require("./lib.js");

function run(argv) {
    if (argv.length == 0) {
        console.info('Usage: fguiRestore fguiFile [outputFile]');
        process.exit(0);
    }

    var fguiFile = argv[0];
    var outputFile;

    for (var i = 1; i < argv.length; i++) {
        var arg = argv[i];
        if (!outputFile)
            outputFile = arg;
        else {
            console.error('unknown argument: ' + arg);
            process.exit(1);
        }
    }
    console.log(outputFile)
    fguiRestore.restore(fguiFile, outputFile);
}

run(process.argv.slice(2));