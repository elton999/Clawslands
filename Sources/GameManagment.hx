package;
import kha.Assets;
import umbrellatoolkit.GameObject;
import entities.Player;
import gameplay.Door;
import ui.HUD;
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

	public var life: Int = 3;
	public var haskey: Bool = false;

	var GameObject:GameObject = new GameObject();

	private var AssetsManagment:AssetsManagment = new AssetsManagment();

	public function new (){
		this.Scene = new Scene();

		// Set Assets
		this.AssetsManagment.add(Player, "player", LayersScene.PLAYER);
		this.AssetsManagment.add(Door, "exit room", LayersScene.MIDDLEGROUND);
		this.AssetsManagment.add(Troll, "troll", LayersScene.ENEMIES);
		this.AssetsManagment.add(Spider, "spider", LayersScene.ENEMIES);
		this.AssetsManagment.add(Jumper, "jumper", LayersScene.ENEMIES);
		this.AssetsManagment.add(MovePlatform, "move platform", LayersScene.MIDDLEGROUND);
	}

	private var LoadScene:Bool = false;
	public function update(DeltaTime:Float): Void {
		
		if(!this.LoadScene){
			this.loadLevels();
		}

		if(this.Scene.scene != null)
			this.Scene.scene.update(DeltaTime);
	}

	public function updateData(DeltaTime:Float):Void{
		if(this.Scene.scene != null)
			this.Scene.scene.updateData(DeltaTime);
	}

	public function render(framebuffer: Framebuffer): Void {
		if(this.Scene.scene != null){
			this.Scene.scene.render(framebuffer);
		}
	}


	public function loadLevels(){
		// loading tilemap
			var HUD:HUD = new HUD();
			kha.Assets.loadImage("Content_Maps_tilemap", function (done:kha.Image){
				this.GameObject.Sprite = done;
				HUD.Sprite = done;
			});

			// loading levels 
			this.room1 = new Scene();
			this.room1.cameraLerpSpeed = 8;
			this.room1.GameManagment = this;
			HUD.scene = this.room1;
			this.room1.UI.push(HUD);
			this.room1.LoadLevel("Content_Maps_TileSettings_ogmo", "Content_Maps_level_1_json", this.GameObject, this.AssetsManagment);

			this.room2 = new Scene();
			this.room2.cameraLerpSpeed = 8;
			this.room2.GameManagment = this;
			this.room2.LoadLevel("Content_Maps_TileSettings_ogmo", "Content_Maps_level_2_json", this.GameObject, this.AssetsManagment);

			this.room3 = new Scene();
			this.room3.cameraLerpSpeed = 8;
			this.room3.GameManagment = this;
			this.room3.LoadLevel("Content_Maps_TileSettings_ogmo", "Content_Maps_level_3_json", this.GameObject, this.AssetsManagment);

			this.room4 = new Scene();
			this.room4.cameraLerpSpeed = 8;
			this.room4.GameManagment = this;
			this.room4.LoadLevel("Content_Maps_TileSettings_ogmo", "Content_Maps_level_4_json", this.GameObject, this.AssetsManagment);

			this.room5 = new Scene();
			this.room5.cameraLerpSpeed = 8;
			this.room5.GameManagment = this;
			this.room5.LoadLevel("Content_Maps_TileSettings_ogmo", "Content_Maps_level_5_json", this.GameObject, this.AssetsManagment);

			this.room6 = new Scene();
			this.room6.cameraLerpSpeed = 8;
			this.room6.GameManagment = this;
			this.room6.LoadLevel("Content_Maps_TileSettings_ogmo", "Content_Maps_level_6_json", this.GameObject, this.AssetsManagment);

			this.Scene.scene = this.room1;
			this.LoadScene = true;
	}
}