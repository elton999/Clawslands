package entities;

import kha.math.FastMatrix3;
import kha.Image;
import kha.Assets;
import kha.Color;
import kha.input.Keyboard;
import kha.input.Gamepad;
import kha.math.Vector2;
import kha.graphics2.Graphics;
import entities.SwordPlayer;
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

		this.scene.camera.position.y = this.Position.y;

		this.sword = new SwordPlayer();
		this.sword.player = this;
		this.sword.start();
		
		Assets.loadImage("Content_Sprites_player", function (done:Image){
			this.Sprite = done;
			this.animation = new Animation();
			this.animation.start("Content_Sprites_player_json");
		});
		
		Keyboard.get().notify(OnkeyDown, OnKeyUp);
		Gamepad.get(0).notify(ExisGamepad, ButtonGamepad);
		Gamepad.get(1).notify(ExisGamepad, ButtonGamepad);
	
	}

	var _lastPosition:Vector2 =  new Vector2(0,0);
	public override function update(DeltaTime:Float) {
		if(this.scene.camera != null && this.scene.camera.follow == null)
			this.scene.camera.follow = this;
		

		// check fall
		if(!this.isGrounded){
			if(this.speedGravity.y < 0) this.isFalling = true;
			else this.isFalling = false;
		}

		super.update(DeltaTime);
		this.AnimationController(DeltaTime);
		//this.animation.play(DeltaTime, "Idle-Right", AnimationDirection.LOOP);
		this.jump();

		this.takeDamage(DeltaTime);

		_lastPosition = new Vector2(this.Position.x, this.Position.y);
	}

	public override function OnCollide(?tag:String) {
		super.OnCollide(tag);
		if(tag == "spider" || tag == "jumper"){
			if(!this._isTakingDamange){
				this.scene.GameManagment.life -= 1;
				this._isTakingDamange = true;
			}
		}
	}

	public override function updateData(DeltaTime:Float){
		super.updateData(DeltaTime);
		this.checkGrounded();
		this.checkAttackArea();
		this.move(DeltaTime);
	}

	public var mright:Bool = true;

	var animation:Animation;
	public override function render(g2:Graphics) {
		super.render(g2);
		if(this.isVisible){
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

		if((!this.cLeft && !this.cRight) || this.cAttack)
			this.velocity.x = 0;
	}
	// end move

	// Controllers
	public var cRight:Bool = false;
	public var cLeft:Bool = false;
	public var cUp:Bool = false;
	public var cDown:Bool = false;
	public var cAttack:Bool = false;

	public var cJump:Bool = false;
	
	private function OnkeyDown(key:kha.input.KeyCode):Void{
		_isgamepad = false;
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
				this.cAttack = true;
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

	private var _isgamepad:Bool = false;
	private function ButtonGamepad(button:Int, value:Float){
		this._isgamepad = true;
		if(button == 15)
			if(value == 1) this.cRight = true;
			else this.cRight = false;
		else if(button == 14)
			if(value == 1) this.cLeft = true;
			else this.cLeft = false;
		else if(button == 0)
			if(value == 1) this.cJump = true;
			else this.cJump = false;
		else if(button == 2)
			if(value == 1) this.cAttack = true;
	}

	private function ExisGamepad(button:Int, value:Float){
		if(button == 0){
			if(value > 0.3) this.cRight = true;
			else if(value < -0.3) this.cLeft = true;
			else if(value > -0.3 && value < 0.3){
				this.cRight = false;
				this.cLeft = false;
			}
		}
	}

	// End Controllers

	// sword settings
	public var sword:SwordPlayer;
	public function checkAttackArea(){
		if(this.cAttack)
			if(this.animation.getCurrentFrame() > 0){
				this.sword.updateData(0);
				this.sword.CheckAttack();
			}
	}
	// end sword settings


	// animation
	var _attackAnimation:Bool = false;
	public function AnimationController(DeltaTime:Float){
		if(this.cLeft)
			this.mright = false;
		if(this.cRight)
			this.mright = true;

		if(this.isGrounded){
			if(this.velocity.x != 0)
				this.animation.play(DeltaTime, "Run-Right", AnimationDirection.LOOP);
			else{
				if(this.cAttack){
					this.animation.play(DeltaTime, "Fast-Attack", AnimationDirection.FORWARD);
					_attackAnimation = true;
					if(this.animation.lastFrame()){
						_attackAnimation = false;
						this.cAttack = false;
					}
				}else
					this.animation.play(DeltaTime, "Idle-Right", AnimationDirection.LOOP);
			}			
		} else {
			if(this.cAttack){
				this.animation.play(DeltaTime, "Fast-Attack", AnimationDirection.FORWARD);
				_attackAnimation = true;
				if(this.animation.lastFrame()){
					_attackAnimation = false;
					this.cAttack = false;
				}
			} else {
				if(this.isFalling)
					this.animation.play(DeltaTime, "Jump-Down-Right", AnimationDirection.LOOP);
				else
					this.animation.play(DeltaTime, "Jump-Up-Right", AnimationDirection.LOOP);
			}
		}
	}
	// end animation

	// take damange
	private var _damageTimer:Float = 0;
	private var _isTakingDamange:Bool = false;
	private var _MaxTimeDamangeSeconds:Float = 3;
	private var _nextBlink:Float = 0;
	private function takeDamage(deltaTime:Float){
		if(this._isTakingDamange){
			trace(this._damageTimer);
			if(this._damageTimer < this._MaxTimeDamangeSeconds){
				if(this._damageTimer >= this._nextBlink){
					this.isVisible = true;
					this._nextBlink = this._damageTimer + 0.2;
				}else
					this.isVisible = false;
				
				this._damageTimer += deltaTime;
			} else{
				this.isVisible = true;
				this._isTakingDamange = false;
				this._damageTimer = 0;
				this._nextBlink = 0;
			}
		}
	}
	// end take damage

	public var isGrounded:Bool = false;
	public var isFalling:Bool = false;
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