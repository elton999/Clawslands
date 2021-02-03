package sprite;

import kha.graphics2.Graphics;
import umbrellatoolkit.GameObject;

class Walter extends GameObject{
	public override function start() {
		super.start();
		this.Sprite = this.scene.gameManagment.GameObject.Sprite;

		for(i in 0...Std.int(this.size.x/8)){
			var e = i;
			if(e > 9){
				e = Std.int(e - (Std.int(e/10)*10));
			}

			this._tiles.push(e);
		}
	}

	private var _tiles:Array<Int> = new Array<Int>();
	private var _timer:Float = 0;
	private var _speedAnimation:Float = 200;

	public override function update(DeltaTime:Float) {
		super.update(DeltaTime);
		_timer +=  DeltaTime * 1000;

		if(_timer >= _speedAnimation){
			for(i in 0...this._tiles.length){
				if(this._tiles[i] > 0)
					this._tiles[i]--;
				else
					this._tiles[i] = 9;
			}

			_timer = 0;
		}

	}

	public override function render(g2:Graphics) {
		super.render(g2);

		for(i in 0...this._tiles.length){
			g2.drawScaledSubImage(
				this.Sprite, 
				64 + (this._tiles[i] * 8), 
				168, 
				8, 
				8,
				this.Position.x + (i*8), 
				this.Position.y, 
				8, 
				8
			);
		}
	}

}
