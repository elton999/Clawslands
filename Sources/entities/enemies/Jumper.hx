package entities.enemies;

import kha.Image;
import kha.Assets;
import kha.Color;
import kha.math.Vector2;
import kha.graphics2.Graphics;
import umbrellatoolkit.helpers.Point;
import umbrellatoolkit.collision.Solid;
import umbrellatoolkit.sprite.Animation;

class Jumper extends Enemy{
	public override function start() {
		super.start();

		this.scene.AllActors.push(this);
		this.size = new Point(16, 16);
		this.life = 5;
		this.tag = "jumper";

		this.initialPosition = new Vector2(this.Position.x, this.Position.y);

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
		this._timer = 0;
		this.life = 5;

		moveRight = false;
		moveLeft = false;
		speed = 250;
		startJump = false;
		MaxWaitTime = 250;
		_timer = 0;
	}

	public override function update(DeltaTime:Float) {
		super.update(DeltaTime);
		this.animationUpdate(DeltaTime);
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

	// take damege
	public override function OnCollide(?tag:String) {
		super.OnCollide(tag);
		if(tag == "player sword")
			this.takeDamage(5);
	}

	public override function takeDamage(hit:Int) 
	{
		this.speed = - this.speed;
		super.takeDamage(hit);
	}

	public override function onTakeDamage() {
		super.onTakeDamage();
	}

	public override function death() {
		this.scene.gameManagment.soundManagement.play("death_enemies");
		super.death();
	}
	// end take damege

	var moveRight:Bool = false;
	var moveLeft:Bool = false;
	var speed:Float = 250;
	var startJump:Bool = false;
	var MaxWaitTime:Float = 250;
	var _timer:Float = 0;
	
	public override function updateData(DeltaTime:Float) {
		if(this.isActive){
			_timer += DeltaTime;
			this.checkGround();

			if(groundLeft){
				moveRight = true;
				moveLeft = false;
				if(!startJump) _timer = 0;
				startJump = true;
			} else if(groundRight) {
				moveRight = false;
				moveLeft = true;
				if(!startJump) _timer = 0;
				startJump = true;
			}

			if(_timer * 1000 > MaxWaitTime){
				startJump = false;
				if(moveRight) moveX((DeltaTime * speed), null);
				if(moveLeft) moveX(-(DeltaTime * speed), null);
			}

			super.updateData(DeltaTime);
		}
		
	}


	public var groundLeft:Bool = false;
	public var groundRight:Bool = false;
	public override function isRiding(solid:Solid):Bool {
		var rt:Bool = false;
		if(solid.check(this.size, new Vector2(this.Position.x + 1, this.Position.y))){
			rt = true;
			groundRight = true;
		} else if(solid.check(this.size, new Vector2(this.Position.x - 1, this.Position.y))){
			rt = true;
			groundLeft = true;
		}
		return rt;
	}

	public function checkGround(){
		groundLeft = false;
		groundRight = false;
		for(solid in this.scene.AllSolids){
			this.isRiding(solid);
		}
	}

	public var animation:Animation = new Animation();
	public function animationUpdate(deltaTime:Float){
		if(this.groundLeft || this.groundRight)
			this.animation.play(deltaTime, "grounded-j", AnimationDirection.FORWARD);
		else
			this.animation.play(deltaTime, "idle-j", AnimationDirection.FORWARD);
	}

	public override function render(g2:Graphics) {
		if(!this.isHide && this.isActive){
			//g2.color = Color.Purple;
			//g2.fillRect(this.Position.x, this.Position.y, this.size.x, this.size.y);
			//g2.color = Color.White;

			g2.drawScaledSubImage(
				this.Sprite, 
				this.animation.body.x, 
				this.animation.body.y, 
				this.animation.body.width, 
				this.animation.body.height,
				moveRight ? this.Position.x - 7 : this.Position.x + 23, 
				this.Position.y - 8,
				moveRight ? this.animation.body.width : -this.animation.body.width, 
				this.animation.body.height
			);
		}
	}
}