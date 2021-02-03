package;
import umbrellatoolkit.helpers.Point;
import ui.FinalCredits;
import sprite.PlayerAnimation;
import sprite.Background.Background;
import sprite.Walter;
import sprite.WalterFall;
import kha.Sound;
import kha.audio1.Audio;
import kha.math.Vector2;
import ui.TextBox;
import kha.Blob;
import kha.Image;
import kha.Color;
import ui.Title;
import umbrellatoolkit.Camera;
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
import gameplay.Life;
import gameplay.SkillItem;
import ui.HUD;
import entities.enemies.*;
import entities.solids.MovePlatform;
import umbrellatoolkit.Scene;
import umbrellatoolkit.level.AssetsManagment;
import umbrellatoolkit.helpers.Timer;
import kha.Framebuffer;
import SoundManagement;

class GameManagment {
	public var Scene: Scene;
	public var rooms: Array<Scene> = new Array<Scene>();

	public var font:Font;
	public var startThegame:Bool = false;

	// player infos
	public var totalLife: Int = 5;
	public var life: Int = 5;
	public var hasStrongAttack:Bool = true;
	public var haskey: Bool = false;
	public var canPlay: Bool = false;
	public var currentRoom:Int = 1;
	public var canRestart:Bool = false;

	public var isUsingGamepad:Bool = false;

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
	public var soundManagement:SoundManagement;

	public function new (){
		kha.Assets.loadFont("Content_Fonts_Kenney_Pixel", function (done:Font){ this.font = done; });
		this.soundManagement = new SoundManagement();
		this.Scene = new Scene();

		// Set Assets
		this.AssetsManagment.add(Player, "player", LayersScene.PLAYER);
		this.AssetsManagment.add(Door, "exit room", LayersScene.MIDDLEGROUND);
		this.AssetsManagment.add(Key, "key", LayersScene.MIDDLEGROUND);
		this.AssetsManagment.add(Life, "life", LayersScene.MIDDLEGROUND);
		this.AssetsManagment.add(SkillItem, "new skill", LayersScene.MIDDLEGROUND);
		this.AssetsManagment.add(Witch, "wicth", LayersScene.ENEMIES);
		this.AssetsManagment.add(Spider, "spider", LayersScene.ENEMIES);
		this.AssetsManagment.add(Jumper, "jumper", LayersScene.ENEMIES);
		this.AssetsManagment.add(Boss, "boss", LayersScene.ENEMIES);
		this.AssetsManagment.add(Danger, "danger", LayersScene.MIDDLEGROUND);
		this.AssetsManagment.add(MovePlatform, "move platform", LayersScene.MIDDLEGROUND);
		this.AssetsManagment.add(Gate, "gate", LayersScene.MIDDLEGROUND);
		this.AssetsManagment.add(StrongRock, "strong rock", LayersScene.MIDDLEGROUND);

		this.AssetsManagment.add(Walter, "walter", LayersScene.MIDDLEGROUND);
		this.AssetsManagment.add(WalterFall, "walter fall", LayersScene.MIDDLEGROUND);
	}

	private var LoadScene:Bool = false;
	private var LoadDone:Bool = false;
	public function update(DeltaTime:Float): Void {
		if(!this.LoadScene){
			this.loadLevels();
			this.LoadDone = true;
		}
		this.soundManagement.Update();

		if(this.Scene.scene != null){
			if(this.canRestart)
				this.restart();
			if(this.startThegame){
				if(!this._pressAnyButtonHUD.Destroy)
					this.soundManagement.play("press button");
				this._pressAnyButtonHUD.Destroy = true;
			}
			this.Scene.scene.update(DeltaTime);
			this.logoScene.update(DeltaTime);
		}
	}

	public function updateData(DeltaTime:Float):Void{
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

	public var finalScene:Scene;
	public var logoScene:Scene;
	public var HUD:HUD = new HUD();
	private var _pressAnyButtonHUD:TextBox;
	private var _initialCredits:TextBox;
	public function loadLevels(){
		// loading tilemap
		Assets.loadImage("Content_Maps_tilemap", function (done:kha.Image){
			this.GameObject.Sprite = done;
			HUD.Sprite = done;
		});

		_pressAnyButtonHUD = new TextBox();
		_pressAnyButtonHUD.text = "Press any button to start";
		_pressAnyButtonHUD.positionSpace = new Vector2(60, 50);

		// loading levels 
		for(i in 0...6){
			this.rooms.push(new Scene());
			this.rooms[i].cameraLerpSpeed = 8;
			this.rooms[i].gameManagment = this;
			this.rooms[i].LoadLevel("Content_Maps_TileSettings_ogmo", "Content_Maps_level_"+(i+1)+"_json", this.GameObject, this.AssetsManagment);
			if(i == 0){
				HUD.scene = this.rooms[i];
				this.rooms[i].UI.push(HUD);
			}
		}

		this.finalScene = new Scene();
		this.finalScene.gameManagment = this;
		this.finalScene.BackgroundColor = Color.Black;
		this.finalScene.SceneReady = true;
		this.finalScene.camera = new Camera();
		this.finalScene.camera.scene = this.finalScene;
		this.finalScene.camera.position = new Vector2(this.finalScene.ScreemSize.x / 2, this.finalScene.ScreemSize.y / 2);
		// background 
		var bg:Background = new Background();
		bg.start();

		var credits:FinalCredits = new FinalCredits();
		credits.start();
		// player animation cutscene
		var playerAnimation:PlayerAnimation = new PlayerAnimation();
		playerAnimation.start();
		
		this.finalScene.Player.push(playerAnimation);
		this.finalScene.Background.push(bg);
		this.finalScene.UI.push(credits);

		//logo
		this.logoScene = new Scene();
		this.logoScene.BackgroundColor = Color.Transparent;
		this.logoScene.camera = new Camera();
		this.logoScene.camera.scene = this.logoScene;
		this.logoScene.gameManagment = this;
		this.logoScene.ScreemSize = new Point(Std.int(this.logoScene.ScreemSize.x * 2), Std.int(this.logoScene.ScreemSize.y * 2));
		this.logoScene.camera.position = new Vector2(this.logoScene.ScreemSize.x / 2, this.logoScene.ScreemSize.y / 2);
		var logo:ui.Logo = new ui.Logo();
		logo.start();
		logo.scene = this.logoScene;
		this.logoScene.UI.push(logo);
		this.logoScene.SceneReady = true;
		var bgscene = new Background();
		bgscene.Scale = 2;
		this.logoScene.Background.push(bgscene);
		
		this.rooms[0].UI.push(_pressAnyButtonHUD);
		_pressAnyButtonHUD.scene = this.rooms[0];
		
		this.Scene.scene = this.rooms[0];
		//this.Scene.scene = this.finalScene;

		this.LoadScene = true;
	}

	public function showInitialCredits(){
		_initialCredits = new TextBox();
		_initialCredits.text = "A game by Elton Silva";
		_initialCredits.scene = this.rooms[0];
		_initialCredits.positionSpace = new Vector2(50, 100);
		this.rooms[0].UI.push(_initialCredits);
		_initialCredits.start();
	}

	public function restart(){
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
		this.life = this.totalLife;
		this.canPlay = true;
		_HUD.scene = this.rooms[0];
		_HUD.restart();
		_player.scene = this.rooms[0];
		_player.restart();
		this.Scene.scene = this.rooms[this.currentRoom - 1];
	}
}