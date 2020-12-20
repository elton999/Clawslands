package gameplay;

import kha.math.Vector2;
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

				if(this.valeus.room == 1)
					this.scene.GameManagment.Scene.scene = this.scene.GameManagment.room1;
				else if(this.valeus.room == 2){
					this.scene.GameManagment.Scene.scene = this.scene.GameManagment.room2;
				}
				else if(this.valeus.room == 3)
					this.scene.GameManagment.Scene.scene = this.scene.GameManagment.room3;

				this.Player.scene = this.scene.GameManagment.Scene.scene;
				this.scene.GameManagment.Scene.scene.Player.push(this.Player);
				this.scene.GameManagment.Scene.scene.AllActors.unshift(this.Player);
				this.scene.GameManagment.Scene.scene.camera.position = new Vector2 (this.Player.Position.x, this.Player.Position.y);

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