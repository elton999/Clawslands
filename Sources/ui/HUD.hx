package ui;

import kha.math.Vector2;
import kha.Color;
import kha.graphics2.Graphics;
import umbrellatoolkit.GameObject;

class HUD extends GameObject{

	public var life:Int = 3;
	public var hasKey:Bool = false;
	private var _position:Vector2 = new Vector2(0,-32);

	public override function restart() {
		super.restart();
		this.scene.UI.push(this);
	}

	public override function update(DeltaTime:Float) {
		super.update(DeltaTime);
		this.life = this.scene.gameManagment.life;
		this.hasKey = this.scene.gameManagment.haskey;

		if(isHiding){
			_position = new Vector2(this._position.x, this._position.y - 1);
			if(this._position.y == -32)
				this.isHiding = false;
		} else if(isShowing){
			_position = new Vector2(this._position.x, this._position.y + 1);
			if(this._position.y == 0)
				this.isShowing= false;
		}
		
	}

	var isHiding:Bool = false;
	public function hideUI(){
		isHiding = true;
	}

	var isShowing:Bool= false;
	public function showUI(){
		isShowing = true;
	}

	public override function render(g2:Graphics) {
		this.Position = new Vector2(this.scene.camera.position.x - (this.scene.ScreemSize.x / 2) + this._position.x, this.scene.camera.position.y - (this.scene.ScreemSize.y / 2) + this._position.y);
		super.render(g2);
		g2.color = Color.Black;
		g2.fillRect(this.Position.x, this.Position.y, 426, 32);
		g2.color = Color.White;
		
		// life
		for(i in 0...this.scene.gameManagment.totalLife)
			if(i < this.life)
				g2.drawSubImage(this.Sprite, this.Position.x + 8 + (i * 11), this.Position.y + 5, 0,72, 10, 9);
			else
				g2.drawSubImage(this.Sprite, this.Position.x + 8 + (i * 11), this.Position.y + 5, 48,72, 10, 9);

		//keys
		g2.drawSubImage(this.Sprite, this.Position.x + 8, this.Position.y + 17, 10, 72, 10, 10);
		if(this.hasKey)
			g2.drawSubImage(this.Sprite, this.Position.x + 20, this.Position.y + 17, 34, 72, 4, 8);
		else
			g2.drawSubImage(this.Sprite, this.Position.x + 20, this.Position.y + 17, 26, 72, 4, 8);
		g2.drawSubImage(this.Sprite, this.Position.x + 24, this.Position.y + 17, 40, 72, 8, 8);

		//strong attack
		if(this.scene.gameManagment.hasStrongAttack){
			g2.color = Color.Orange;
			g2.fillRect(this.Position.x + this.scene.ScreemSize.x - 16, this.Position.y + 8, 8,8);
			g2.color = Color.White;
		}

	}
}