package gameplay;

import umbrellatoolkit.GameObject;
import ui.HUD;
import umbrellatoolkit.Camera;
import kha.math.Vector2;
import kha.Color;
import kha.graphics2.Graphics;
import umbrellatoolkit.helpers.Point;
import umbrellatoolkit.collision.Actor;

class Door extends Actor{
	public var Player : Actor;
	public var Hud:GameObject;

	public override function start() {
		this.tag = "door";
	}

	public override function updateData(DeltaTime:Float) {
		if(this.scene.AllActors.length > 0){
			if(this.overlapCheck(this.scene.AllActors[0])){
				this.Player = this.scene.AllActors[0];
				this.Hud = this.scene.UI[0];
				
				this.scene.AllActors.shift();
				this.scene.UI.shift();
				this.scene.Player.shift();

				if(this.valeus.room == 1)
					this.scene.GameManagment.Scene.scene = this.scene.GameManagment.room1;
				else if(this.valeus.room == 2)
					this.scene.GameManagment.Scene.scene = this.scene.GameManagment.room2;
				else if(this.valeus.room == 3)
					this.scene.GameManagment.Scene.scene = this.scene.GameManagment.room3;
				else if(this.valeus.room == 4)
					this.scene.GameManagment.Scene.scene = this.scene.GameManagment.room4;
				else if(this.valeus.room == 5)
					this.scene.GameManagment.Scene.scene = this.scene.GameManagment.room5;
				else if(this.valeus.room == 6)
					this.scene.GameManagment.Scene.scene = this.scene.GameManagment.room6;

				this.Player.scene = this.scene.GameManagment.Scene.scene;
				this.Hud.scene = this.scene.GameManagment.Scene.scene;
				this.scene.GameManagment.Scene.scene.Player.push(this.Player);
				this.scene.GameManagment.Scene.scene.AllActors.unshift(this.Player);
				this.scene.GameManagment.Scene.scene.UI.push(this.Hud);
				this.scene.GameManagment.Scene.scene.camera.position = new Vector2 (this.Player.Position.x, this.Player.Position.y);

				this.fixCameraPosition(this.scene.GameManagment.Scene.scene.camera);
			}
		}
	}

	public function fixCameraPosition(camera:Camera){
		if((Player.Position.x - (camera.scene.ScreemSize.x / 2) > camera.maxPosition.x))
			camera.position.x = camera.maxPosition.x + (camera.scene.ScreemSize.x / 2);
		else if((Player.Position.x  - (camera.scene.ScreemSize.x / 2) < camera.minPosition.x))
			camera.position.x = camera.minPosition.x + (camera.scene.ScreemSize.x / 2);

		if((Player.Position.y - (camera.scene.ScreemSize.x / 2) > camera.maxPosition.y))
			camera.position.y = camera.maxPosition.y + (camera.scene.ScreemSize.y / 2);
		else if((Player.Position.y - (camera.scene.ScreemSize.y / 2) < camera.minPosition.y))
			camera.position.y = camera.minPosition.y + (camera.scene.ScreemSize.y / 2);
	}

	public override function render(g2:Graphics) {
		super.render(g2);
		
		//g2.color = Color.Green;
		//g2.fillRect(this.Position.x, this.Position.y, this.size.x, this.size.y);
		//g2.color = Color.White;
	}
}