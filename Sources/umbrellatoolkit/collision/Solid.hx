package umbrellatoolkit.collision;
import kha.Color;
import kha.math.Vector2;
import umbrellatoolkit.collision.Actor;
import umbrellatoolkit.collision.Solid;
import umbrellatoolkit.GameObject;
import umbrellatoolkit.helpers.Point;

class Solid extends GameObject {
	public var positions:Vector2;
	public var sizes:Point;
	public var AreaCollision:Int;

	public var Collidable = true;

	private var xRemainder:Float = 0;
	private var yRemainder:Float = 0;

	public function add(size:Point, position:Vector2) : Void{
		this.sizes = size;
		this.positions = position;
	}

	public function Right():Int{
		return Std.int(this.positions.x + this.sizes.x);
	}

	public function Left():Int{
		return Std.int(this.positions.x);
	}

	public function Top():Int{
		return Std.int(this.positions.y);
	}

	public function Bottom():Int{
		return Std.int(this.positions.y + this.sizes.y);
	}

	public function onCollide(tag:String):Void{}

	
	public function move(x:Float, y:Float):Void{
		xRemainder += x; 
  		yRemainder += y;
		
		var moveX:Int = Math.round(xRemainder);
		var moveY:Int = Math.round(yRemainder);

		
		if (moveX != 0 || moveY != 0) 
  		{

			this.Collidable = false;
			var riding:Array<Actor> = this.GetAllRidingActors();

			if (moveX != 0) 
    		{
				xRemainder -= moveX;
				this.positions.x += moveX;

				if(moveX > 0){
					for(i in 0...this.scene.AllActors.length){
						if (overlapCheck(this.scene.AllActors[i])){
							// Push top
							this.scene.AllActors[i].moveX(this.Right() - this.scene.AllActors[i].Left(), this.scene.AllActors[i].squish);
						} else if(riding.indexOf(this.scene.AllActors[i]) != -1) {
							// Carry right
							this.scene.AllActors[i].moveX(moveX, null);
						}
					}
					
				} else {
					for(i in 0...this.scene.AllActors.length){
						if (overlapCheck(this.scene.AllActors[i])){
							// Push left
							this.scene.AllActors[i].moveX(this.Left() - this.scene.AllActors[i].Right(), this.scene.AllActors[i].squish);
						} else if(riding.indexOf(this.scene.AllActors[i]) != -1) {
							// Carry left
							this.scene.AllActors[i].moveX(moveX, null);
						}
					}
				}
			} 

			if(moveY != 0){

				yRemainder -= moveY;
				this.positions.y += moveY;

				if(moveY > 0){
					for(i in 0...this.scene.AllActors.length){
						if (overlapCheck(this.scene.AllActors[i])){
							this.scene.AllActors[i].moveY(this.Bottom() - this.scene.AllActors[i].Top(), this.scene.AllActors[i].squish);
						} else if(riding.indexOf(this.scene.AllActors[i]) != -1) {
							this.scene.AllActors[i].moveY(moveY, null);
						}
					}
					
				} else {
					for(i in 0...this.scene.AllActors.length){
						if (overlapCheck(this.scene.AllActors[i])){
							this.scene.AllActors[i].moveY(this.Top() - this.scene.AllActors[i].Bottom(), this.scene.AllActors[i].squish);
						} else if(riding.indexOf(this.scene.AllActors[i]) != -1) {
							this.scene.AllActors[i].moveY(moveY, null);
						}
					}
				}

			} 
			this.Collidable = true; 
		}
	}

	public function overlapCheck(actor:Actor):Bool{
		var AisToTheRightOfB:Bool = actor.Left() >= this.Right();
		var AisToTheLeftOfB:Bool = actor.Right() <= this.Left();
		var AisAboveB:Bool = actor.Bottom() <= this.Top();
		var AisBelowB:Bool = actor.Top() >= this.Bottom();
		return !(AisToTheRightOfB
			|| AisToTheLeftOfB
			|| AisAboveB
			|| AisBelowB);
	}

	public function check(size:Point, position:Vector2) : Bool{
		var AisToTheRightOfB:Bool = position.x >= this.Right();
		var AisToTheLeftOfB:Bool = position.x+size.x <= this.Left();
		var AisAboveB:Bool = position.y+size.y <= this.Top();
		var AisBelowB:Bool = position.y >= this.Bottom();
		return !(AisToTheRightOfB
			|| AisToTheLeftOfB
			|| AisAboveB
			|| AisBelowB);
	}

	public function valueInRange(value:Int, min:Int, max:Int)
	{ return (value >= min) && (value <= max); }

	public function GetAllRidingActors():Array<Actor>{
		var rt:Array<Actor> = new Array<Actor>();
		var i:Int = 0;
		while(i< this.scene.AllActors.length){
			if(this.scene.AllActors[i].isRiding(this))
				rt.push(this.scene.AllActors[i]);
			i++;
		}

		return rt;
	}

	public override function render(g2:kha.graphics2.Graphics): Void{
		super.render(g2);
		
		//g2.color = Color.Yellow;
		//g2.drawRect(this.Position.x, this.Position.y, this.size.x, this.size.y);
		//g2.color = Color.White;
	}
}

