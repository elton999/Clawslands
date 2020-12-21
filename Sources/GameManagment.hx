package;
import entities.Player;
import gameplay.Door;
import entities.enemies.*;
import entities.solids.MovePlatform;
import umbrellatoolkit.Scene;
import umbrellatoolkit.level.AssetsManagment;
import umbrellatoolkit.helpers.Timer;
import kha.Framebuffer;

class GameManagment {
	public var Scene: Scene;

	public var room1: Scene;
	public var room2: Scene;
	public var room3: Scene;
	public var room4: Scene;
	public var room5: Scene;
	public var room6: Scene;
	public var room7: Scene;
	public var room8: Scene;

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
		this.AssetsManagment.add(Door, "exit room", LayersScene.MIDDLEGROUND);
		this.AssetsManagment.add(Troll, "troll", LayersScene.ENEMIES);
		this.AssetsManagment.add(Spider, "spider", LayersScene.ENEMIES);
		this.AssetsManagment.add(Jumper, "jumper", LayersScene.ENEMIES);
		this.AssetsManagment.add(MovePlatform, "move platform", LayersScene.MIDDLEGROUND);
	}

	private var LoadScene:Bool = false;
	public function update(): Void {
		
		if(!this.LoadScene){
			
			

			this.room1 = new Scene();
			this.room1.cameraLerpSpeed = 8;
			this.room1.GameManagment = this;
			this.room1.LoadLevel("Content_Maps_TileSettings_ogmo", "Content_Maps_level_1_json", this.AssetsManagment);

			this.room2 = new Scene();
			this.room2.cameraLerpSpeed = 8;
			this.room2.GameManagment = this;
			this.room2.LoadLevel("Content_Maps_TileSettings_ogmo", "Content_Maps_level_2_json", this.AssetsManagment);

			this.room3 = new Scene();
			this.room3.cameraLerpSpeed = 8;
			this.room3.GameManagment = this;
			this.room3.LoadLevel("Content_Maps_TileSettings_ogmo", "Content_Maps_level_3_json", this.AssetsManagment);

			this.room4 = new Scene();
			this.room4.cameraLerpSpeed = 8;
			this.room4.GameManagment = this;
			this.room4.LoadLevel("Content_Maps_TileSettings_ogmo", "Content_Maps_level_4_json", this.AssetsManagment);

			this.Scene.scene = this.room1;

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