package gameplay;

import kha.math.Vector2;
import umbrellatoolkit.collision.Actor;

class Item extends Actor{


	public var initialPosition:Vector2;
	public override function start() {
		super.start();
		this.initialPosition = new Vector2(this.Position.x, this.Position.y);
	}

	var _speed:Float = 8;
	public override function updateData(DeltaTime:Float) {
		//super.updateData(DeltaTime);

		if(this.initialPosition.y - 10 >= this.Position.y || this.initialPosition.y <= this.Position.y)
			this._speed = - this._speed;
		
		this.Position = new Vector2(this.Position.x, this.Position.y - (this._speed * DeltaTime));
	}
}