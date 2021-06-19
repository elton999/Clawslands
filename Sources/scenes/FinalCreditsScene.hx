package scenes;

import kha.Color;
import kha.math.Vector2;
import umbrellatoolkit.Scene;
import umbrellatoolkit.Camera;
import umbrellatoolkit.helpers.Point;
import sprite.PlayerAnimation;
import ui.FinalCredits;
import sprite.Background.Background;

class FinalCreditsScene extends Scene{
	
	public function start():Void{

		this.BackgroundColor = Color.Black;
		this.SceneReady = true;
		this.camera = new Camera();
		this.camera.scene = this;
		this.camera.position = new Vector2(this.ScreemSize.x / 2, this.ScreemSize.y / 2);

		this.createCredits();
		this.createBackground();
		this.createCutScene();
	}

	private function createCutScene():Void{
		var playerAnimation:PlayerAnimation = new PlayerAnimation();
		playerAnimation.scene = this;
		playerAnimation.start();
		
		this.Player.push(playerAnimation);
	}

	private function createBackground():Void{
		var bg:Background = new Background();
		bg.start();
		this.Background.push(bg);
	}

	private function createCredits():Void{
		var credits:FinalCredits = new FinalCredits();
		credits.start();
		this.UI.push(credits);
	}

}