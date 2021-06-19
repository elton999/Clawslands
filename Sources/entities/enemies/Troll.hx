package entities.enemies;

import kha.Color;
import kha.math.Vector2;
import entities.enemies.Enemy;
import umbrellatoolkit.helpers.Point;

class Troll extends Enemy{
	public override function start(){
		this.scene.AllActors.push(this);
		this.size = new Point(16, 32);
		this.gravity2D = new Vector2(0, -200);
		this.velocityDecrecent = 2000;
		this.tag = "troll";
	}

	public override function updateData(DeltaTime:Float) {
		super.updateData(DeltaTime);
		if(overlapCheck(this.scene.AllActors[0]))
			this.scene.AllActors[0].OnCollide(this.tag);
	}

	public override function render(g2:kha.graphics2.Graphics): Void{
		//super.render(g2);
		g2.color = Color.Red;
		g2.fillRect(this.Position.x, this.Position.y, 16, 32);
		g2.color = Color.White;
	}
}