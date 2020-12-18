package gameplay;

import kha.Color;
import kha.graphics2.Graphics;
import umbrellatoolkit.helpers.Point;
import umbrellatoolkit.collision.Actor;

class Door extends Actor{
	public var Player : Actor;

	public override function start() {
		this.tag = "door";
	}

	public override function updateData(DeltaTime:Float) {
		if(this.scene.AllActors.length > 0){
			if(this.overlapCheck(this.scene.AllActors[0])){
				this.Player = this.scene.AllActors[0];
				
				this.scene.AllActors.shift();
				this.scene.Player.shift();

				this.scene.GameManagment.Scene.scene = this.scene.GameManagment.room2;
				this.Player.scene = this.scene.GameManagment.Scene.scene;
				this.scene.GameManagment.Scene.scene.Player.push(this.Player);
				this.scene.GameManagment.Scene.scene.AllActors.unshift(this.Player);
			}
		}
	}

	public override function render(g2:Graphics) {
		super.render(g2);
		
		g2.color = Color.Green;
		g2.fillRect(this.Position.x, this.Position.y, this.size.x, this.size.y);
		g2.color = Color.White;
	}
}