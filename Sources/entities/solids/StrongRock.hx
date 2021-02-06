package entities.solids;

import kha.Image;
import kha.Assets;
import kha.Color;
import ui.TextBox;
import kha.math.Vector2;
import kha.graphics2.Graphics;
import umbrellatoolkit.collision.Solid;

class StrongRock extends Solid{
	public override function start() {
		this.tag = "strong rock";
		this.add(this.size, this.Position);
		this.scene.AllSolids.push(this);

		this.Sprite = this.scene.gameManagment.GameObject.Sprite;
	}

	public var textBox:TextBox;
	public override function updateData(DeltaTime:Float) {
		super.updateData(DeltaTime);
		if(this.check(this.scene.AllActors[0].size, new Vector2(this.scene.AllActors[0].Position.x + 1, this.scene.AllActors[0].Position.y))||
		this.check(this.scene.AllActors[0].size, new Vector2(this.scene.AllActors[0].Position.x - 1, this.scene.AllActors[0].Position.y))){
			 if(this.textBox == null && !this.scene.gameManagment.hasStrongAttack){
				this.textBox = new TextBox();
				this.textBox.scene = this.scene;
				this.textBox.text = "This rock is too Big";
				this.textBox.positionSpace = new Vector2(50, 0);
				this.textBox.start();
				this.scene.UI.push(this.textBox);
			}
		} else{
			if(this.textBox != null && this.textBox.Destroy)
				this.textBox = null;
		}
	}


	private var _hits:Int = 0;
	public var _canHitAgain:Bool = true;
	public override function onCollide(tag:String) {
		super.onCollide(tag);
		if(this._hits == 4){
			if(tag == "player strong attack"){
				this.scene.AllSolids.remove(this);
				this.scene.gameManagment.soundManagement.play("open_gate");
			}
		} else if(this._canHitAgain){
			this._canHitAgain = false;
			this._hits += 1;
			wait(1.5, function(){ this._canHitAgain = true; });
		}
		
	}
	public override function render(g2:Graphics) {
		g2.drawSubImage(
				this.Sprite, 
				this.positions.x,
				this.positions.y,
				64 + (48 * this._hits),
				112, 
				48, 
				48
			);
	}
}