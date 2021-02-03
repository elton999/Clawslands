package sprite;

import kha.graphics2.Graphics;
import kha.Assets;
import umbrellatoolkit.GameObject;

class Background extends GameObject{
	public override function start() {
		super.start();
		this.Sprite = Assets.images.Content_Sprites_bg;
	}

	public override function render(g2:Graphics) {
		super.render(g2);
		g2.drawScaledImage(this.Sprite, 0,0, this.Sprite.width*this.Scale, this.Sprite.height*this.Scale);
	}
}