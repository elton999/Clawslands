package;
import umbrellatoolkit.collision.Actor;
import kha.Font;
import kha.Assets;
import umbrellatoolkit.GameObject;
import entities.Player;
import entities.solids.Gate;
import entities.solids.StrongRock;
import entities.enemies.Wicth;
import entities.enemies.Boss;
import gameplay.Door;
import gameplay.Danger;
import gameplay.Key;
import gameplay.SkillItem;
import ui.HUD;
import entities.enemies.*;
import entities.solids.MovePlatform;
import umbrellatoolkit.Scene;
import umbrellatoolkit.level.AssetsManagment;
import umbrellatoolkit.helpers.Timer;
import kha.Framebuffer;

class GameManagment {
	public var Scene: Scene;

	public var rooms: Array<Scene> = new Array<Scene>();

	public var font:Font;

	// player infos
	public var totalLife: Int = 5;
	public var life: Int = 5;
	public var hasStrongAttack:Bool = true;
	public var haskey: Bool = false;
	public var canPlay: Bool = true;
	public var currentRoom:Int = 1;

	public var playerCollideDamange:Array<String> = [
		"spider",
		"jumper",
		"danger",
		"wicth",
		"boss",
		"boss sword"
	];

	public var GameObject:GameObject = new GameObject();

	private var AssetsManagment:AssetsManagment = new AssetsManagment();

	public function new (){
		kha.Assets.loadFont("Content_Fonts_Kenney_Pixel", function (done:Font){
			this.font = done;
		});

		this.Scene = new Scene();

		// Set Assets
		this.AssetsManagment.add(Player, "player", LayersScene.PLAYER);
		this.AssetsManagment.add(Door, "exit room", LayersScene.MIDDLEGROUND);
		this.AssetsManagment.add(Key, "key", LayersScene.MIDDLEGROUND);
		this.AssetsManagment.add(SkillItem, "new skill", LayersScene.MIDDLEGROUND);
		this.AssetsManagment.add(Witch, "wicth", LayersScene.ENEMIES);
		this.AssetsManagment.add(Spider, "spider", LayersScene.ENEMIES);
		this.AssetsManagment.add(Jumper, "jumper", LayersScene.ENEMIES);
		this.AssetsManagment.add(Boss, "boss", LayersScene.ENEMIES);
		this.AssetsManagment.add(Danger, "danger", LayersScene.MIDDLEGROUND);
		this.AssetsManagment.add(MovePlatform, "move platform", LayersScene.MIDDLEGROUND);
		this.AssetsManagment.add(Gate, "gate", LayersScene.MIDDLEGROUND);
		this.AssetsManagment.add(StrongRock, "strong rock", LayersScene.MIDDLEGROUND);
	}

	private var LoadScene:Bool = false;
	private var LoadDone:Bool = false;
	public function update(DeltaTime:Float): Void {
		
		if(!this.LoadScene){
			this.loadLevels();
			this.LoadDone = true;
		}

		if(this.Scene.scene != null){
			if(this.life < 1)
				this.restart();
			this.Scene.scene.update(DeltaTime);
		}
	}

	public function updateData(DeltaTime:Float):Void{
		if(this.Scene.scene != null && this.LoadDone)
			this.Scene.scene.updateData(DeltaTime);
	}

	public function render(framebuffer: Framebuffer): Void {
		if(this.Scene.scene != null && this.LoadDone){
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
			for(i in 0...6){
				this.rooms.push(new Scene());
				this.rooms[i].cameraLerpSpeed = 8;
				this.rooms[i].GameManagment = this;
				this.rooms[i].LoadLevel("Content_Maps_TileSettings_ogmo", "Content_Maps_level_"+(i+1)+"_json", this.GameObject, this.AssetsManagment);
				if(i == 0){
					HUD.scene = this.rooms[i];
					this.rooms[i].UI.push(HUD);
				}
			}
			
			this.Scene.scene = this.rooms[0];
			this.LoadScene = true;
	}

	public function restart(){

		var _player:Actor = this.rooms[this.currentRoom - 1].AllActors.shift();
		this.rooms[this.currentRoom - 1].Player.shift();
		var _HUD:GameObject = this.rooms[this.currentRoom - 1].UI.shift();

		for(i in 0...this.rooms.length){
			this.rooms[i].restart();
			this.rooms[i].cameraLerpSpeed = 8;
			this.rooms[i].UI = new Array<GameObject>();
		}

		this.currentRoom = 1;
		this.life = this.totalLife;
		this.canPlay = true;
		_HUD.scene = this.rooms[0];
		_HUD.restart();
		_player.scene = this.rooms[0];
		_player.restart();
		this.Scene.scene = this.rooms[this.currentRoom - 1];
	}
}