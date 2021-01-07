package entities.enemies;

import kha.Color;
import kha.graphics2.Graphics;
import kha.math.Vector2;
import umbrellatoolkit.collision.Actor;
import umbrellatoolkit.helpers.Point;

class BossSword extends Actor{
	public var boss:Boss;

	public override function start() {
		super.start();
		this.size = new Point(26*2, 32*2);
		this.tag = "boss sword";
	}

	public override function updateData(DeltaTime:Float) {
		if(this.boss.mright)
			this.Position = new Vector2(this.boss.Position.x + this.boss.size.x, this.boss.Position.y);
		else
			this.Position = new Vector2(this.boss.Position.x - this.size.x, this.boss.Position.y);
	}

	public function checkAttack(){
		if(this.overlapCheck(this.boss.scene.AllActors[0]))
			this.boss.scene.AllActors[0].OnCollide(this.tag);
	}

	public override function render(g2:Graphics) {
		super.render(g2);
		g2.color = Color.Red;
		g2.fillRect(this.Position.x, this.Position.y, this.size.x, this.size.y);
		g2.color = Color.White;
	}

}