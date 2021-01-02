package entities;

import kha.math.Vector2;
import umbrellatoolkit.collision.Actor;
import umbrellatoolkit.helpers.Point;

class SwordPlayer extends Actor{
	public var player:Player;

	public override function start() {
		super.start();
		this.size = new Point(18, 32);
		this.tag = "player sword";
	}

	public override function updateData(DeltaTime:Float) {
		super.updateData(DeltaTime);
		if(this.player.mright)
			this.Position = new Vector2(this.player.Position.x + this.player.size.x, this.player.Position.y);
		else
			this.Position = new Vector2(this.player.Position.x - this.size.x, this.player.Position.y);
	}

	public function CheckAttack(){
		for(i in 0...this.player.scene.AllActors.length){
			if(this.overlapCheck(this.player.scene.AllActors[i]))
				this.player.scene.AllActors[i].OnCollide(this.tag);
		}
	}
}