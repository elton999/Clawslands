let project = new Project('Clawslands');
project.addAssets('Assets/**', {
	nameBaseDir: 'Assets',
	destination: '{dir}/{name}',
	name: '{dir}/{name}',
});

project.addShaders('Shaders/**');
project.addSources('Sources/');
callbacks.postCppCompilation = () => { };
resolve(project);
