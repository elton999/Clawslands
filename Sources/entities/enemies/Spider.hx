package entities.enemies;

import kha.Color;
import kha.graphics2.Graphics;
import umbrellatoolkit.helpers.Point;

class Spider extends Enemy{
	public override function start() {
		super.start();

		this.scene.AllActors.push(this);
		this.size = new Point(16, 16);
		this.tag = "spider";
	}


	public override function updateData(DeltaTime:Float) {
		//super.updateData(DeltaTime);
	}

	public override function render(g2:Graphics) {
		g2.color = Color.Red;
		g2.fillRect(this.Position.x, this.Position.y, this.size.x, this.size.y);
		g2.color = Color.White;
	}
}