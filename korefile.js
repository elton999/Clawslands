let fs = require('fs');
let path = require('path');
let project = new Project('Clawslands');
project.addDefine('HXCPP_API_LEVEL=332');
project.targetOptions = {"html5":{},"flash":{},"android":{},"ios":{}};
project.setDebugDir('build/linux');
await project.addProject('build/linux-build');
await project.addProject('c:/Program Files (x86)/Steam/steamapps/common/Kode Studio/resources/app/kodeExtensions/kha/Kha');
resolve(project);
