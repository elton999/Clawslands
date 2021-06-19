package gameplay;

import umbrellatoolkit.GameObject;
import umbrellatoolkit.Camera;
import kha.math.Vector2;
import kha.graphics2.Graphics;
import umbrellatoolkit.collision.Actor;

class Door extends Actor{
	public var Player : Actor;
	public var Hud:GameObject;

	public override function start() {
		this.tag = "door";
	}

	public override function updateData(DeltaTime:Float) {
		var sceneManagement:SceneManagement = this.scene.gameManagment.sceneManagement;
		if(this.scene.AllActors.length > 0){
			if(this.overlapCheck(this.scene.AllActors[0])){
				if(this.valeus.room != 100){
					this.Player = this.scene.AllActors[0];
					this.Hud = this.scene.UI[0];
					
					this.scene.AllActors.shift();
					this.scene.UI.shift();
					this.scene.Player.shift();

					sceneManagement.currentRoom = this.valeus.room;
					sceneManagement.Scene.scene = sceneManagement.rooms[sceneManagement.currentRoom - 1];

					this.Player.scene = sceneManagement.Scene.scene;
					this.Hud.scene = sceneManagement.Scene.scene;
					sceneManagement.Scene.scene.Player.push(this.Player);
					sceneManagement.Scene.scene.AllActors.unshift(this.Player);
					sceneManagement.Scene.scene.UI.push(this.Hud);
					sceneManagement.Scene.scene.camera.position = new Vector2 (this.Player.Position.x, this.Player.Position.y);

					this.fixCameraPosition(sceneManagement.Scene.scene.camera);
				} else {
					sceneManagement.Scene.scene = sceneManagement.finalScene;
				}
				
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
	}
}