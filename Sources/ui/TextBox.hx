package ui;

import kha.math.Vector2;
import kha.graphics2.Graphics;
import umbrellatoolkit.collision.Actor;

class TextBox extends Actor{

	public var text:String = "";
	public var timeToExit:Float = 5;

	public var positionSpace:Vector2;

	public override function start() {
		super.start();
		wait(this.timeToExit, function (){
			this.Destroy = true;
		});
	}


	public override function render(g2:Graphics) {
		super.render(g2);
		this.Position = new Vector2(
			this.scene.camera.position.x - this.positionSpace.x, // - (this.scene.ScreemSize.x / 2) + , 
			this.scene.camera.position.y + 50 //- (this.scene.ScreemSize.y / 2)
		);
		
		g2.fontSize = 12;
		g2.font = this.scene.GameManagment.font;
		g2.drawString(this.text, this.Position.x, this.Position.y);
	}

}