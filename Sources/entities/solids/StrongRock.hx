package entities.solids;

import kha.Color;
import kha.graphics2.Graphics;
import umbrellatoolkit.collision.Solid;

class StrongRock extends Solid{
	public override function start() {
		this.tag = "strong rock";
		this.add(this.size, this.Position);
		this.scene.AllSolids.push(this);
	}

	public override function onCollide(tag:String) {
		super.onCollide(tag);
		if(tag == "player strong attack"){
			this.Destroy = true;
			this.scene.AllSolids.remove(this);
		}
	}

	public override function render(g2:Graphics) {
		g2.color = Color.Green;
		g2.fillRect(this.positions.x, this.positions.y, this.sizes.x, this.sizes.y);
		g2.color = Color.White;
	}
}