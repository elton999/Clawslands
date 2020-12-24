package umbrellatoolkit.collision;

import umbrellatoolkit.GameObject;
import umbrellatoolkit.helpers.Point;
import umbrellatoolkit.collision.Solid;
import kha.math.Vector2;

class Actor extends GameObject{
	public var tag:String;
	public override function updateData(DeltaTime:Float){
		this.gravity(DeltaTime);
	}

	public function Right():Int{
		return Std.int(this.Position.x + this.size.x);
	}

	public function Left():Int{
		return Std.int(this.Position.x);
	}

	public function Top():Int{
		return Std.int(this.Position.y);
	}

	public function Bottom():Int{
		return Std.int(this.Position.y + this.size.y);
	}

	public var gravity2D:Vector2 = new Vector2(0, -350);
	public var speedGravity:Vector2 = new Vector2(0,0);
	public var velocity:Vector2 = new Vector2(0,0);
	public var velocityDecrecent:Float = 200;
	private function gravity(DeltaTime:Float){

		this.speedGravity = new Vector2(this.velocity.x+this.gravity2D.x, this.velocity.y+this.gravity2D.y);

		if(speedGravity.x != 0)
			this.moveX(-(speedGravity.x* DeltaTime), OnCollide);
		if(speedGravity.y != 0)
			this.moveY(-(speedGravity.y* DeltaTime), OnCollide);

		// velocity Controller
		if(this.velocity.y > 0)
			this.velocity.y -= this.velocityDecrecent * DeltaTime;
		else if(this.velocity.y < 0)
			this.velocity.y += this.velocityDecrecent * DeltaTime;
		else
			this.velocity.y = 0;
		
		if(this.velocity.x > 0)
			this.velocity.x -= this.velocityDecrecent * DeltaTime;
		else if(this.velocity.x < 0)
			this.velocity.x += this.velocityDecrecent * DeltaTime;
		else 
			this.velocity.x = 0;
		// end velocity Controller
	}
	
	var xRemainder:Float = 0;
	public function moveX(amount:Float, onCollideFunction:(?String) -> Void):Void{
		xRemainder += amount;
  		var move:Int = Math.round(xRemainder);
		if (move != 0) 
		{	
			xRemainder -= move; 
			var sign:Int = sign(move); 
			while (move != 0) 
			{
				var _position:Vector2 = new Vector2(this.Position.x+ sign, this.Position.y);
				if (!collideAt(this.scene.AllSolids, _position))
				{ 
					this.Position.x += sign; 
					move -= sign; 
				} 
				else 
				{
					if(onCollideFunction != null)
						onCollideFunction();
					break;
				} 
			} 
		} 
	}

	var yRemainder:Float = 0;
	public function moveY(amount:Float, onCollideFunction:(?String) -> Void = null):Void{
		yRemainder += amount;
  		var move:Int = Math.round(yRemainder);

		if (move != 0) 
		{ 
			yRemainder -= move; 
			var sign:Int = sign(move); 
			while (move != 0) 
			{
				var _position:Vector2 = new Vector2(this.Position.x, this.Position.y+ sign);
				if (!collideAt(this.scene.AllSolids, _position))
				{ 
					this.Position.y += sign; 
					move -= sign; 
				} 
				else 
				{ 
					if(onCollideFunction != null)
						onCollideFunction();
					break; 
				} 
			} 
		} 
	}

	public function overlapCheck(actor:Actor):Bool{
		var x_overlaps:Bool = false;
		var y_overlaps:Bool = false;

		var x_width:Int = Std.int(this.Position.x + this.size.x);
		var y_height:Int = Std.int(this.Position.y + this.size.y);
		
		x_overlaps = (
			(actor.Position.x + actor.size.x >= this.Position.x && actor.Position.x + actor.size.x <= x_width) ||
			(actor.Position.x > this.Position.x && actor.Position.x < x_width) ||
			(actor.Position.x <= this.Position.x && actor.Position.x + actor.size.x >= x_width)
		);

		y_overlaps = (
			(actor.Position.y + actor.size.y >= this.Position.y && actor.Position.y + actor.size.y <= y_height) ||
			(actor.Position.y > this.Position.y && actor.Position.y < y_height) ||
			(actor.Position.y <= this.Position.y && actor.Position.y + actor.size.y >= y_height)
		);

		if(x_overlaps && y_overlaps)
			return true;

		return false;
	}

	private function collideAt(solids:Array<Solid>, position:Vector2):Bool{
		var rt:Bool = false;
		for(solid in solids){
			if(solid.check(this.size, position)){
				rt = true;
			}
		}
		return rt;
	}

	public function OnCollide(?tag:String):Void{}

	public function isRiding(solid:Solid):Bool{
		if(solid.check(this.size, new Vector2(this.Position.x, this.Position.y + 1)))
			return true;
		return false;
	}

	public function squish(?tag:String):Void{}

	private function sign(v:Int):Int{
		if(v>0)
			return 1;
		else if(v<0)
			return -1;
		else
			return 0;
	}
}