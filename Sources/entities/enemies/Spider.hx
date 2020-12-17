package entities.enemies;

import kha.Color;
import kha.math.Vector2;
import kha.Scheduler;
import kha.graphics2.Graphics;
import umbrellatoolkit.helpers.Point;
import umbrellatoolkit.collision.Solid;

class Spider extends Enemy{

	public override function start() {
		super.start();

		this.scene.AllActors.push(this);
		this.size = new Point(16, 16);
		this.tag = "spider";
	}

	var speed:Float = 15;
	var _currentMovimentX:Bool = false;
	var _currentMovimentY:Bool =  false;
	public override function updateData(DeltaTime:Float) {
		var t:Float = Scheduler.time();
		this.checkGround();

		if(!(groundLeft && groundRight && groundTop && groundBottom)){
			var i = 0;
			for(i in 0...this.scene.AllSolids.length){
				if(
					(
						this.scene.AllSolids[i].check(this.size, new Vector2(this.Position.x - 1, this.Position.y + 1)) ||
						this.scene.AllSolids[i].check(this.size, new Vector2(this.Position.x + 1, this.Position.y + 1))
					)
					&& _currentMovimentX
				){
					moveY(1, null);
				}

				if(
					(
						this.scene.AllSolids[i].check(this.size, new Vector2(this.Position.x - 1, this.Position.y - 1)) ||
						this.scene.AllSolids[i].check(this.size, new Vector2(this.Position.x + 1, this.Position.y - 1))
					)
					&& _currentMovimentX
				){
					moveY(-1, null);
				}

				if(
					(
						this.scene.AllSolids[i].check(this.size, new Vector2(this.Position.x + 1, this.Position.y + 1)) ||
						this.scene.AllSolids[i].check(this.size, new Vector2(this.Position.x + 1, this.Position.y - 1))
					)
					&& _currentMovimentY
				){
					moveX(1, null);
				}

				if(
					(
						this.scene.AllSolids[i].check(this.size, new Vector2(this.Position.x - 1, this.Position.y + 1)) ||
						this.scene.AllSolids[i].check(this.size, new Vector2(this.Position.x - 1, this.Position.y - 1))
					)
					&& _currentMovimentY
				){

					moveX(-1, null);
				}
			}
			
		}

		_currentMovimentX = false;
		_currentMovimentY = false;

		if(groundRight){
			_currentMovimentY = true;
			moveY(DeltaTime * -speed, function (?tag:String):Void {
				moveX(DeltaTime * speed, null);
			});
		}

		if(groundLeft){
			_currentMovimentY = true;
			moveY(DeltaTime * speed, function (?tag:String):Void {
				moveX(DeltaTime * -speed, null);
			});
		}

		if(groundBottom){
			_currentMovimentX = true;
			moveX(DeltaTime * speed, function (?tag:String):Void {
				moveY(DeltaTime * -speed, null);
			});
		}

		if(groundTop){
			_currentMovimentX = true;
			moveX(DeltaTime * -speed, function (?tag:String):Void {
				moveY(DeltaTime * speed, null);
			});
		}
	}

	public override function render(g2:Graphics) {
		g2.color = Color.Red;
		g2.fillRect(this.Position.x, this.Position.y, this.size.x, this.size.y);
		g2.color = Color.White;
	}


	public var groundLeft:Bool = false;
	public var groundRight:Bool = false;
	public var groundTop:Bool = false;
	public var groundBottom:Bool = false;
	public var solidBuffer_groundRight:Solid;
	public var solidBuffer_groundLeft:Solid;
	public var solidBuffer_groundBottom:Solid;
	public var solidBuffer_groundTop:Solid;

	public override function isRiding(solid:Solid):Bool {
		var rt:Bool = false;
		if(solid.check(this.size, new Vector2(this.Position.x + 1, this.Position.y))){
			rt = true;
			groundRight = true;
			solidBuffer_groundRight = solid;
		} else if(solid.check(this.size, new Vector2(this.Position.x - 1, this.Position.y))){
			rt = true;
			groundLeft = true;
			solidBuffer_groundLeft = solid;
		}

		if(solid.check(this.size, new Vector2(this.Position.x, this.Position.y + 1))){
			rt = true;
			groundBottom = true;
			solidBuffer_groundBottom = solid;
		} else if(solid.check(this.size, new Vector2(this.Position.x, this.Position.y - 1))){
			rt = true;
			groundTop = true;
			solidBuffer_groundTop = solid;
		}
		return rt;
	}

	public function checkGround(){
		groundLeft = false;
		groundRight = false;
		groundTop = false;
		groundBottom = false;
		
		for(i in 0...this.scene.AllSolids.length){
			this.isRiding(this.scene.AllSolids[i]);
		}
		
	}
}