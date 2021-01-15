package entities.enemies;

import kha.math.FastMatrix3;
import kha.Image;
import kha.Assets;
import umbrellatoolkit.sprite.Animation;
import kha.Color;
import kha.math.Vector2;
import kha.Scheduler;
import kha.graphics2.Graphics;
import umbrellatoolkit.helpers.Point;
import umbrellatoolkit.collision.Solid;

class Spider extends Enemy{

	public override function start() {
		super.start();

		this.initialPosition = new Vector2(this.Position.x, this.Position.y);
		this.scene.AllActors.push(this);
		this.size = new Point(16, 16);
		this.life = 15;
		this.tag = "spider";
		this.flipX ? this.speed = - this.speed : null;
		Assets.loadImage("Content_Sprites_spider", function (done:Image){
			this.Sprite = done;
			this.animation.start("Content_Sprites_spider_json");
		});
	}

	public override function restart() {
		super.restart();
		this.Position = new Vector2(this.initialPosition.x, this.initialPosition.y);
		this.isHide = true;
		this.isActive = true;
		this.life = 15;

		groundLeft = false;
		groundRight = false;
		groundTop = false;
		groundBottom = false;
	}

	public var animation:Animation = new Animation();

	public override function takeDamage(hit:Int) 
	{
		this.speed = - this.speed;
		super.takeDamage(hit);
	}

	public override function onTakeDamage() {
		super.onTakeDamage();
	}


	var _moveB:Bool = false;
	var _moveT:Bool = false;
	var _moveL:Bool = false;
	var _moveR:Bool = false;
	public override function update(DeltaTime:Float) {
		super.update(DeltaTime);
		if((_moveL || _moveR) && _currentMovimentY)
			this.animation.play(DeltaTime, "idle-w", AnimationDirection.LOOP);
		else
			this.animation.play(DeltaTime, "idle-b", AnimationDirection.LOOP);
	}

	private function setAnimationMovement(tag:String){
		_moveB = false;
		_moveT = false;
		_moveL = false;
		_moveR = false;

		if(tag == "moveB")
			_moveB = true;
		else if(tag == "moveT")
			_moveT = true;
		else if(tag == "moveL")
			_moveL = true;
		else if(tag == "moveR")
			_moveR = true;
	}

	var speed:Float = 15;
	var _currentMovimentX:Bool = false;
	var _currentMovimentY:Bool =  false;
	public override function updateData(DeltaTime:Float) {
		if(this.isActive){
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
				super.updateData(DeltaTime);
			}

			_currentMovimentX = false;
			_currentMovimentY = false;

			if(groundRight){
				_currentMovimentY = true;
				setAnimationMovement("moveR");
				moveY(DeltaTime * -speed, function (?tag:String):Void {
					moveX(DeltaTime * speed, null);
				});
			}

			if(groundLeft){
				_currentMovimentY = true;
				setAnimationMovement("moveL");
				moveY(DeltaTime * speed, function (?tag:String):Void {
					moveX(DeltaTime * -speed, null);
				});
			}

			if(groundBottom){
				setAnimationMovement("moveB");
				_currentMovimentX = true;
				moveX(DeltaTime * speed, function (?tag:String):Void {
					moveY(DeltaTime * -speed, null);
				});
			}

			if(groundTop){
				_currentMovimentX = true;
				setAnimationMovement("moveT");
				moveX(DeltaTime * -speed, function (?tag:String):Void {
					moveY(DeltaTime * speed, null);
				});
			}
		}
	}

	public override function render(g2:Graphics) {
		if(this.isVisible && !this.isHide && this.isActive){
			//g2.color = Color.Red;
			//g2.fillRect(this.Position.x, this.Position.y, this.size.x, this.size.y);
			//g2.color = Color.White;

			g2.drawScaledSubImage(
				this.Sprite, 
				this.animation.body.x, 
				this.animation.body.y, 
				this.animation.body.width, 
				this.animation.body.height,
				_moveR || (speed > 0  && _moveB) || (speed < 0  && _moveT) ?  this.Position.x - 8 : this.Position.x + 24, 
				_moveB || (speed > 0  && _moveR) || (speed < 0  && _moveL)? this.Position.y - 8 : this.Position.y + 24, 
				_moveR || (speed > 0  && _moveB) || (speed < 0  && _moveT) ? this.animation.body.width : -this.animation.body.height, 
				_moveB || (speed > 0  && _moveR) || (speed < 0  && _moveL) ? this.animation.body.height : -this.animation.body.height
			);

		}
	}

	public var isHide:Bool = true;
	public override function visible() {
		super.visible();
		this.isHide = false;
	}

	public override function hide() {
		super.hide();
		this.isHide = true;
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