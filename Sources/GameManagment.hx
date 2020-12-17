package;
import entities.Player;
import entities.enemies.*;
import entities.solids.MovePlatform;
import umbrellatoolkit.Scene;
import umbrellatoolkit.level.AssetsManagment;
import umbrellatoolkit.helpers.Timer;
import kha.Framebuffer;

class GameManagment {
	public var Scene: Scene;
	private var AssetsManagment:AssetsManagment = new AssetsManagment();

	public var FullScreem:Bool = true;
	private var DeltaTime:Timer;
	private var DeltaTimeUpdateData:Timer;

	public function new (){
		this.Scene = new Scene();
		this.DeltaTime = new Timer();
		this.DeltaTimeUpdateData = new Timer();

		// Set Assets
		this.AssetsManagment.add(Player, "player", LayersScene.PLAYER);
		this.AssetsManagment.add(Troll, "troll", LayersScene.ENEMIES);
		this.AssetsManagment.add(Spider, "spider", LayersScene.ENEMIES);
		this.AssetsManagment.add(Jumper, "jumper", LayersScene.ENEMIES);
		this.AssetsManagment.add(MovePlatform, "move platform", LayersScene.MIDDLEGROUND);
	}

	private var LoadScene:Bool = false;
	public function update(): Void {
		
		if(!this.LoadScene){
			this.Scene.scene = new Scene();
			this.Scene.scene.cameraLerpSpeed = 8;
			this.Scene.scene.LoadLevel("Content_Maps_TileSettings_ogmo", "Content_Maps_level_complete_json", this.AssetsManagment);
			this.LoadScene = true;
		}

		if(this.Scene.scene != null)
			this.Scene.scene.update(this.DeltaTime.delta);

		this.DeltaTime.update();
	}

	public function updateData():Void{
		if(this.Scene.scene != null)
			this.Scene.scene.updateData(this.DeltaTimeUpdateData.delta);
		this.DeltaTimeUpdateData.update();
	}

	public function render(framebuffer: Framebuffer): Void {
		if(this.Scene.scene != null){
			this.Scene.scene.render(framebuffer);
		}
	}
}