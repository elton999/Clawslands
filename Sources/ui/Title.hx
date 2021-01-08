package ui;

import kha.math.Vector2;
import kha.graphics2.Graphics;
import umbrellatoolkit.GameObject;

class Title extends GameObject{

	public override function render(g2:Graphics) {
		super.render(g2);
		this.Position = new Vector2(
			this.scene.camera.position.x, // - (this.scene.ScreemSize.x / 2) + , 
			this.scene.camera.position.y + 50 //- (this.scene.ScreemSize.y / 2)
		);
		
		g2.fontSize = 12;
		g2.font = this.scene.GameManagment.font;
		g2.drawString("Imagine uma cut scene legal aqui hehehehehe", this.Position.x - 100, this.Position.y);
	}
}