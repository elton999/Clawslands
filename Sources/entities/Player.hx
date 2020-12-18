package entities;

import kha.math.FastMatrix3;
import kha.Image;
import kha.Assets;
import kha.Color;
import kha.input.*;
import kha.math.Vector2;
import kha.graphics2.Graphics;
import umbrellatoolkit.GameObject;
import umbrellatoolkit.collision.Actor;
import umbrellatoolkit.collision.Solid;
import umbrellatoolkit.sprite.Animation;
import umbrellatoolkit.helpers.Point;

class Player extends Actor{

	public override function start() {
		
		this.scene.AllActors.push(this);
		this.size = new Point(10, 32);
		this.gravity2D = new Vector2(0, -200);
		this.velocityDecrecent = 2000;
		this.tag = "player";
		this.scene.cameraLerpSpeed = 10;
		
		Assets.loadImage("Content_Sprites_player", function (done:Image){
			this.Sprite = done;
			this.animation = new Animation();
			this.animation.start("Content_Sprites_player_json");
		});
		
		Keyboard.get().notify(OnkeyDown, OnKeyUp);
	}

	public override function update(DeltaTime:Float) {
		if(this.scene.camera != null && this.scene.camera.follow == null)
			this.scene.camera.follow = this;
		
		super.update(DeltaTime);
		this.AnimationController(DeltaTime);
		//this.animation.play(DeltaTime, "Idle-Right", AnimationDirection.LOOP);
		this.jump();
	}

	public override function OnCollide(?tag:String) {
		super.OnCollide(tag);
		if(tag != null)
			trace(tag);
	}

	public override function updateData(DeltaTime:Float){
		super.updateData(DeltaTime);
		this.checkGrounded();
		this.move(DeltaTime);
	}

	public var mright:Bool = true;

	var animation:Animation;
	public override function render(g2:Graphics) {
		super.render(g2);
		
		g2.drawScaledSubImage(
			this.Sprite, 
			this.animation.body.x, 
			this.animation.body.y, 
			this.animation.body.width, 
			this.animation.body.height,
			this.mright ? this.Position.x - 27 : this.Position.x + 37, 
			this.Position.y - 16, 
			this.mright ? this.animation.body.width : -this.animation.body.width, 
			this.animation.body.height
		);
	}

	// Jump
	private var JumpPressedForce:Int = 0;
	private var JumpPressed:Bool = false;
	private var JumpPressedBtn:Bool = false;
	private var JumpForce:Float = 390;

	private function jump():Void{
		if(this.isGrounded && this.cJump){
			this.JumpPressedBtn = true;
			this.JumpPressed = true;
		}

		if(!this.cJump)
			this.JumpPressed = false;

		if(this.JumpPressedBtn && this.JumpPressed && this.JumpPressedForce < 17){
			this.velocity = new Vector2(this.velocity.x, this.JumpForce);
			this.JumpPressedForce += 1;
		}

		if(this.isGrounded && !this.JumpPressed){
			this.JumpPressed = false;
			this.JumpPressedForce = 0;
		}
	}
	// end Jump

	// move
	public var speed:Int = 120;
	public var speedInAir:Int = 100;

	public function move(DeltaTime:Float) : Void{
		if(this.cLeft)
			this.velocity.x = (this.speed);
		if(this.cRight)
			this.velocity.x = -(this.speed);

		if(!this.cLeft && !this.cRight)
			this.velocity.x = 0;
	}
	// end move

	// Controllers
	public var cRight:Bool = false;
	public var cLeft:Bool = false;
	public var cUp:Bool = false;
	public var cDown:Bool = false;

	public var cJump:Bool = false;
	
	private function OnkeyDown(key:kha.input.KeyCode):Void{
		switch (key){
			case Up:
				this.cUp = true;
			case Down:
				this.cDown = true;
			case Left:
				this.cLeft = true;
			case Right:
				this.cRight = true;
			case Z:
				this.cJump = true;
			case X:
				this.scene.camera.allowFollowX = !this.scene.camera.allowFollowX;
			case Y:
				this.scene.camera.allowFollowY = !this.scene.camera.allowFollowY;
			default:
				//none
		}
	}

	private function OnKeyUp(key:kha.input.KeyCode):Void{
		switch (key){
			case Up:
				this.cUp = false;
			case Down:
				this.cDown = false;
			case Left:
				this.cLeft = false;
			case Right:
				this.cRight = false;
			case Z:
				this.cJump = false;
			default:
				//none
		}
	}
	// End Controllers


	// animation
	public function AnimationController(DeltaTime:Float){
		if(this.cLeft)
			this.mright = false;
		if(this.cRight)
			this.mright = true;

		if(this.velocity.x != 0)
			this.animation.play(DeltaTime, "Run-Right", AnimationDirection.LOOP);
		else
			this.animation.play(DeltaTime, "Idle-Right", AnimationDirection.LOOP);

	}
	// end animation

	public var isGrounded:Bool = false;
	private function checkGrounded():Void{
		this.isGrounded = false;
		for(ground in this.scene.AllSolids){
			if(ground.check(this.size, new Vector2(this.Position.x, this.Position.y + 1))){
				this.isGrounded = true;
				break;
			}
		}
	}

	public override function squish(?tag:String) {
	}

}