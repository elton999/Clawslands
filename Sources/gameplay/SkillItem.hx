package gameplay;

import kha.Color;
import kha.graphics2.Graphics;
import umbrellatoolkit.collision.Actor;
import umbrellatoolkit.helpers.Point;

class SkillItem extends Actor{
	public override function start() {
		super.start();
		this.tag = "skill";
		this.size = new Point(8,8);
	}

	public override function updateData(DeltaTime:Float) {
		if(this.overlapCheck(this.scene.AllActors[0])){
			this.scene.GameManagment.hasStrongAttack = true;
			this.Destroy = true;
			this.scene.AllActors.remove(this);
		}
	}

	public override function render(g2:Graphics) {
		super.render(g2);
		g2.color = Color.Orange;
		g2.fillRect(this.Position.x, this.Position.y, this.size.x, this.size.y);
		g2.color = Color.White;
	}
}