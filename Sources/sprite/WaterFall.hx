package sprite;

import umbrellatoolkit.sprite.Animation;
import kha.Image;
import kha.Assets;
import kha.graphics2.Graphics;
import umbrellatoolkit.GameObject;

class WaterFall extends GameObject{
	public override function start() {
		super.start();
		Assets.loadImage("Content_Sprites_waterfall", function (done:Image){
			this.Sprite = done;
			this.animation.start("Content_Sprites_waterfall_json");
		});
	}

	public override function update(DeltaTime:Float) {
		super.update(DeltaTime);
		this.animation.play(DeltaTime, "animation", AnimationDirection.LOOP);
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