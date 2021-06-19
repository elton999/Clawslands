package;
import ui.HUD;
import ui.TextBox;
import kha.Assets;
import kha.math.Vector2;
import kha.Image;
import kha.Framebuffer;
import umbrellatoolkit.Scene;
import umbrellatoolkit.GameObject;
import umbrellatoolkit.collision.Actor;
import scenes.InitialCreditsScene;
import scenes.FinalCreditsScene;

class SceneManagement{

	public var Scene: Scene;
	public var rooms: Array<Scene> = new Array<Scene>();
	public var GameManagement:GameManagment;

	public var currentRoom:Int = 1;
	public var canRestart:Bool = false;

	public function new (){
		this.Scene = new Scene();
	}

	private var LoadScene:Bool = false;
	private var LoadDone:Bool = false;

	public function update(DeltaTime:Float):Void{
		if(!this.LoadScene){
			this.loadAllScenes();
			this.LoadDone = true;
		}

		if(this.Scene.scene != null){
			if(this.canRestart)
				this.restart();
			if(this.GameManagement.startThegame){
				if(!this._pressAnyButtonHUD.Destroy)
					this.GameManagement.soundManagement.play("press button");
				this._pressAnyButtonHUD.Destroy = true;
			}
			this.Scene.scene.update(DeltaTime);
			this.logoScene.update(DeltaTime);
		}
	}

	public function updateData(DeltaTime:Float):Void {
		if(this.Scene.scene != null && this.LoadDone)
			this.Scene.scene.updateData(DeltaTime);
	}

	public function render(framebuffer: Framebuffer): Void {
		if(this.Scene.scene != null && this.LoadDone){
			this.Scene.scene.render(framebuffer);
			if(this.logoScene.UI.length > 0){
				this.logoScene.Background[0].Sprite = this.Scene.scene._BackBuffer;
				this.logoScene.render(framebuffer);
			}
		}
	}

	public var finalScene:FinalCreditsScene;
	public var logoScene:InitialCreditsScence;
	public var HUD:HUD = new HUD();
	private var _pressAnyButtonHUD:TextBox;
	private var _initialCredits:TextBox;

	public function loadAllScenes(){
		
		this.loadLevels();

		this.loadHud();

		this.loadFinalCredits();

		this.Scene.scene = this.rooms[0];
		this.LoadScene = true;
	}

	private function loadFinalCredits():Void{
		this.finalScene = new FinalCreditsScene();
		this.finalScene.gameManagment = this.GameManagement;
		this.finalScene.start();
	}

	private function loadLevels(){
		// loading tilemap
		Assets.loadImage("Content_Maps_tilemap", function (done:kha.Image){
			this.GameManagement.GameObject.Sprite = done;
			HUD.Sprite = done;
		});

		// loading levels 
		for(i in 0...6){
			this.rooms.push(new Scene());
			this.rooms[i].cameraLerpSpeed = 8;
			this.rooms[i].gameManagment = this.GameManagement;
			this.rooms[i].LoadLevel("Content_Maps_TileSettings_ogmo", "Content_Maps_level_"+(i+1)+"_json", this.GameManagement.GameObject, this.GameManagement.AssetsManagment);
			if(i == 0){
				HUD.scene = this.rooms[i];
				this.rooms[i].UI.push(HUD);
			}
		}
	}
	

	private function loadHud():Void{
		_pressAnyButtonHUD = new TextBox();
		_pressAnyButtonHUD.text = "Press any button to start";
		_pressAnyButtonHUD.positionSpace = new Vector2(60, 50);
		
		this.logoScene = new scenes.InitialCreditsScene.InitialCreditsScence();
		this.logoScene.gameManagment = this.GameManagement;
		this.logoScene.start();

		this.rooms[0].UI.push(_pressAnyButtonHUD);
		_pressAnyButtonHUD.scene = this.rooms[0];
	}

	public function showInitialCredits(){
		_initialCredits = new TextBox();
		_initialCredits.text = "A game by Elton Silva";
		_initialCredits.scene = this.rooms[0];
		_initialCredits.positionSpace = new Vector2(50, 100);
		this.rooms[0].UI.push(_initialCredits);
		_initialCredits.start();
	}

	public function restart():Void {
		this.canRestart = false;

		var _player:Actor = this.rooms[this.currentRoom - 1].AllActors.shift();
		this.rooms[this.currentRoom - 1].Player.shift();
		var _HUD:GameObject = this.rooms[this.currentRoom - 1].UI.shift();

		for(i in 0...this.rooms.length){
			this.rooms[i].restart();
			this.rooms[i].cameraLerpSpeed = 8;
			this.rooms[i].UI = new Array<GameObject>();
		}

		this.currentRoom = 1;
		_HUD.scene = this.rooms[0];
		_HUD.restart();
		_player.scene = this.rooms[0];
		_player.restart();
		this.Scene.scene = this.rooms[this.currentRoom - 1];
		
	}

}