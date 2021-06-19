package;
import sprite.Water;
import sprite.WaterFall;
import kha.Font;
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
import entities.enemies.*;
import entities.solids.MovePlatform;
import umbrellatoolkit.Scene;
import umbrellatoolkit.level.AssetsManagment;
import kha.Framebuffer;
import SoundManagement;
import SceneManagement;

class GameManagment {
	

	public var font:Font;
	public var startThegame:Bool = false;

	// player infos
	public var totalLife: Int = 5;
	public var life: Int = 5;
	public var hasStrongAttack:Bool = false;
	public var haskey: Bool = false;
	public var canPlay: Bool = false;

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

	public var AssetsManagment:AssetsManagment = new AssetsManagment();
	public var soundManagement:SoundManagement;
	public var sceneManagement:SceneManagement;

	public function new (){
		kha.Assets.loadFont("Content_Fonts_Kenney_Pixel", function (done:Font){ this.font = done; });
		this.soundManagement = new SoundManagement();
		this.sceneManagement = new SceneManagement();
		this.sceneManagement.GameManagement = this;
		

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

		this.AssetsManagment.add(Water, "water", LayersScene.MIDDLEGROUND);
		this.AssetsManagment.add(WaterFall, "water fall", LayersScene.MIDDLEGROUND);
	}

	
	public function update(DeltaTime:Float): Void {
		
		this.soundManagement.Update();

		this.sceneManagement.update(DeltaTime);
	}

	public function updateData(DeltaTime:Float):Void{
		this.sceneManagement.updateData(DeltaTime);
	}

	public function render(framebuffer: Framebuffer): Void {
		this.sceneManagement.render(framebuffer);
	}

	

	public function restart(){
		this.life = this.totalLife;
		this.canPlay = true;
		this.soundManagement.playMusic();
		this.sceneManagement.restart();
	}
}