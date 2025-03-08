const fs = require('fs');
const path = require('path');

function getSubDirectories(folder) {
  if (!fs.existsSync(folder)) {
    return [];
  }
  const dir = p =>
      fs.readdirSync(p).filter(f => fs.statSync(path.join(p, f)).isDirectory());
  return dir(folder);
}

function getFiles(folder) {
  if (!fs.existsSync(folder)) {
    return {};
  }
  let obj = {};
  return fileNames = fs.readdirSync(folder).filter(
             f => fs.statSync(path.join(folder, f)).isFile());
}

function getFilesWithContent(folder, filesToIgnore) {
  if (!fs.existsSync(folder)) {
    return {};
  }
  let obj = {};
  const fileNames = fs.readdirSync(folder).filter(
      f => fs.statSync(path.join(folder, f)).isFile());
  fileNames.filter(x => filesToIgnore.indexOf(x) === -1).forEach(fileName => {
    const fileContent = fs.readFileSync(path.join(folder, fileName), {
      encoding : 'utf8',
    });
    obj[fileName] = fileContent;
  });

  return obj;
}

let files = getFiles('../bin/Temp/ExtensionBundle');

for (let i = 0; i < files.length; i++) {
  let fileName = files[i].replace(".nupkg", "");
  let dirPath = '../bin/Temp/Temp-' + fileName
  let templatesDir = path.join(dirPath, 'templates');

  if (!fs.existsSync(templatesDir)) {
    continue;
  }

  const version = '2';
  let templateListJson = [];
  const templates = getSubDirectories(path.join(dirPath, 'templates'));
  templates.forEach(template => {
    let templateObj = {};
    const filePath = path.join(dirPath, 'templates', template);
    let files = getFilesWithContent(filePath, [ 'function.json', 'metadata.json' ]);

    templateObj.id = template;
    templateObj.runtime = version;
    templateObj.files = files;

    templateObj.function = require(path.join(filePath, 'function.json'));
    templateObj.metadata = require(path.join(filePath, 'metadata.json'));
    templateListJson.push(templateObj);
  });

  let writeSubPath = path.join('../bin/Temp/', fileName);
  let writePath = path.join('../bin/Temp/out', fileName, 'templates');

  if (!fs.existsSync(writeSubPath)) {
    fs.mkdirSync(writeSubPath);
  }

  if (!fs.existsSync(writePath)) {
    fs.mkdirSync(writePath);
  }
  writePath = path.join(writePath, 'templates.json');
  fs.writeFileSync(writePath, new Buffer(JSON.stringify(templateListJson, null, 2)));
}
