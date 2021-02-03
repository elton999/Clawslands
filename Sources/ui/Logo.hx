package ui;

import kha.Color;
import kha.Assets;
import kha.graphics2.Graphics;
import umbrellatoolkit.GameObject;

class Logo extends GameObject{
	public override function start() {
		super.start();
		this.Sprite = Assets.images.Content_Sprites_logo;
		
	}
	
	public override function update(DeltaTime:Float) {
		super.update(DeltaTime);
		if(this.scene.gameManagment.startThegame && this.transparent < 1){
			this.transparent += 0.1;
			this.color.A = this.transparent;
			if(this.transparent > 1){
				this.scene.UI.remove(this);
			}
		}
	}

	public var transparent:Float = 0;
	public var color:Color = Color.White;
	public override function render(g2:Graphics) {
		super.render(g2);
		g2.color = this.color;
		g2.drawImage(this.Sprite, 235, 50);
		g2.color = Color.White;
	}
}