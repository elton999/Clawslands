let project = new Project('Game 2d');
project.addAssets('Assets/**', {
	nameBaseDir: 'Assets',
	destination: '{dir}/{name}',
	name: '{dir}/{name}',
});
project.addShaders('Shaders/**');
project.addSources('Sources/');
project.addSources('Sources/UmbrellaToolKit/');
callbacks.postCppCompilation = () => { 
	
};
resolve(project);
