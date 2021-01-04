package gameplay;

import umbrellatoolkit.collision.Actor;

class Danger extends Actor{
	public override function start() {
		super.start();
		this.tag = "danger";
	}

	public override function updateData(DeltaTime:Float) {
		if(this.overlapCheck(this.scene.AllActors[0])){
			this.scene.AllActors[0].OnCollide(this.tag);
		}
	}
}