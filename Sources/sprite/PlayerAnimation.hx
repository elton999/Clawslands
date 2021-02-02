package sprite;

import kha.math.Vector2;
import kha.Image;
import kha.Assets;
import umbrellatoolkit.sprite.Animation;
import kha.graphics2.Graphics;
import umbrellatoolkit.GameObject;

class PlayerAnimation extends GameObject{

	public override function start() {
		super.start();
		
		this.Position = new Vector2(-50, 144);
		Assets.loadImage("Content_Sprites_player", function (done:Image){
			this.Sprite = done;
			this.animation.start("Content_Sprites_player_json");
		});
	}


	public override function update(DeltaTime:Float) {
		super.update(DeltaTime);
		this.animation.play(DeltaTime, "walk-black", LOOP);

		this.Position = new Vector2(this.Position.x + (DeltaTime * 5), this.Position.y);
	}


	public var animation:Animation = new Animation();
	public override function render(g2:Graphics) {
		super.render(g2);
		g2.drawScaledSubImage(
				this.Sprite, 
				this.animation.body.x, 
				this.animation.body.y, 
				this.animation.body.width, 
				this.animation.body.height,
				this.Position.x, 
				this.Position.y, 
				this.animation.body.width, 
				this.animation.body.height
			);
	}
}