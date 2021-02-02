package ui;
import kha.graphics2.Graphics;
import kha.Assets;
import kha.Image;
import umbrellatoolkit.GameObject;

class FinalCredits extends GameObject{

	public override function start() {
		super.start();
		this.spriteThanks = Assets.images.Content_Sprites_thanks;
		this.spriteCredits = Assets.images.Content_Sprites_credits;

		this.Sprite = this.spriteThanks;
		wait(18, function (){ this.showCredits = true; });
		wait(22, function (){ this.Sprite = this.spriteCredits; });
	}

	var spriteThanks:Image;
	var spriteCredits:Image;
	var transparent:Float = 0;

	var startShow:Bool = false;
	var showCredits:Bool = false;

	public override function update(DeltaTime:Float) {
		super.update(DeltaTime);
	}


	public override function render(g2:Graphics) {
		super.render(g2);
		
		if(this.showCredits)
			g2.drawImage(this.Sprite, 0, 0);
	}
	

}