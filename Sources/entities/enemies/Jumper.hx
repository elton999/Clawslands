package entities.enemies;

import kha.Color;
import kha.math.Vector2;
import kha.graphics2.Graphics;
import umbrellatoolkit.helpers.Point;
import umbrellatoolkit.collision.Solid;

class Jumper extends Enemy{
	public override function start() {
		super.start();

		this.scene.AllActors.push(this);
		this.size = new Point(16, 16);
		this.life = 5;
		this.tag = "jumper";
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
	// end take damege

	var moveRight:Bool = false;
	var moveLeft:Bool = false;
	var speed:Float = 250;
	var startJump:Bool = false;
	var MaxWaitTime:Float = 250;
	var _timer:Float = 0;
	
	public override function updateData(DeltaTime:Float) {
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

	public override function render(g2:Graphics) {
		g2.color = Color.Purple;
		g2.fillRect(this.Position.x, this.Position.y, this.size.x, this.size.y);
		g2.color = Color.White;
	}
}