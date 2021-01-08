package ui;

import entities.enemies.Boss;
import kha.Color;
import kha.math.Vector2;
import kha.graphics2.Graphics;
import umbrellatoolkit.GameObject;

class BossFightHUD extends GameObject{

	public var boss:Boss;

	public override function render(g2:Graphics) {
		super.render(g2);
		this.Position = new Vector2(this.scene.camera.position.x - (this.scene.ScreemSize.x / 2), this.scene.camera.position.y - (this.scene.ScreemSize.y / 2));
		if(this.boss.life > 0){
			g2.color = Color.White;
			g2.fillRect(this.Position.x + 62 , this.Position.y + 40, 302, 7);

			g2.color = Color.fromString("#B21030");
			g2.fillRect(this.Position.x + 63, this.Position.y + 41, (this.boss.life / this.boss.totalLife) * 300, 5);

			g2.color = Color.White;
		}
		
	}
}