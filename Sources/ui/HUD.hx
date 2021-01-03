package ui;

import kha.math.Vector2;
import kha.Color;
import kha.graphics2.Graphics;
import umbrellatoolkit.GameObject;

class HUD extends GameObject{

	public var life:Int = 3;

	public override function update(DeltaTime:Float) {
		super.update(DeltaTime);
		this.life = this.scene.GameManagment.life;
	}

	public override function render(g2:Graphics) {
		this.Position = new Vector2(this.scene.camera.position.x - (this.scene.ScreemSize.x / 2), this.scene.camera.position.y - (this.scene.ScreemSize.y / 2));
		super.render(g2);
		g2.color = Color.Black;
		g2.fillRect(this.Position.x, this.Position.y, 426, 32);
		g2.color = Color.White;
		
		// life
		for(i in 0...life)
			g2.drawSubImage(this.Sprite, this.Position.x + 8 + (i * 11), this.Position.y + 5, 0,72, 10, 9);

		//keys
		g2.drawSubImage(this.Sprite, this.Position.x + 8, this.Position.y + 17, 10, 72, 10, 10);
		g2.drawSubImage(this.Sprite, this.Position.x + 20, this.Position.y + 17, 26, 72, 4, 8);
		g2.drawSubImage(this.Sprite, this.Position.x + 24, this.Position.y + 17, 40, 72, 8, 8);

	}
}