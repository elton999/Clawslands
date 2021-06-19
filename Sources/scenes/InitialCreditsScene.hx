package scenes;
import kha.Color;
import kha.math.Vector2;
import umbrellatoolkit.Scene;
import umbrellatoolkit.Camera;
import umbrellatoolkit.helpers.Point;
import sprite.Background.Background;

class InitialCreditsScence extends Scene {

	public function start():Void{
		this.BackgroundColor = Color.Transparent;
		this.camera = new Camera();
		this.camera.scene = this;
		this.ScreemSize = new Point(Std.int(this.ScreemSize.x * 2), Std.int(this.ScreemSize.y * 2));
		this.camera.position = new Vector2(this.ScreemSize.x / 2, this.ScreemSize.y / 2);
		
		this.createLogo();
		this.createBackground();
		this.SceneReady = true;
	}

	private function createLogo():Void{
		var logo:ui.Logo = new ui.Logo();
		logo.start();
		logo.scene = this;
		this.UI.push(logo);
	}

	private function createBackground(){
		var bgscene = new Background();
		bgscene.Scale = 2;
		this.Background.push(bgscene);
	}

}