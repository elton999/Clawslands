package gameplay;

import kha.Color;
import ui.TextBox;
import kha.math.Vector2;
import kha.graphics2.Graphics;
import umbrellatoolkit.collision.Actor;
import umbrellatoolkit.helpers.Point;


class Life extends Actor{
		public override function start() {
		super.start();

		this.tag = "life";
		this.size = new Point(10,9);

		this.Sprite = this.scene.gameManagment.GameObject.Sprite;
	}

	public override function updateData(DeltaTime:Float) {
		if(this.overlapCheck(this.scene.AllActors[0])){
			this.scene.gameManagment.life++;
			this.scene.gameManagment.totalLife++;
			this.Destroy = true;
			this.scene.AllActors.remove(this);
		}
	}

	public override function render(g2:Graphics) {
		super.render(g2);
		g2.drawSubImage(this.Sprite, this.Position.x, this.Position.y, 0, 72, 10, 9);
	}
}