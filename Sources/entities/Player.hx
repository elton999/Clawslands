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


	public var initialPosition:Vector2;
	public override function start() {
		super.start();
		this.scene.AllActors.push(this);
		this.size = new Point(10, 32);
		this.gravity2D = new Vector2(0, -200);
		this.velocityDecrecent = 2000;
		this.tag = "player";

		this.scene.camera.position.y = 688;
		this.scene.camera.position.x = this.Position.x;
		
		this.initialPosition = new Vector2(this.Position.x, 688);

		this.sword = new SwordPlayer();
		this.sword.player = this;
		this.sword.start();
		
		Assets.loadImage("Content_Sprites_player", function (done:Image){
			this.Sprite = done;
			this.animation.start("Content_Sprites_player_json");
		});
		
		Keyboard.get().notify(OnkeyDown, OnKeyUp);
		Gamepad.get(0).notify(ExisGamepad, ButtonGamepad);
		Gamepad.get(1).notify(ExisGamepad, ButtonGamepad);
	
	}

	public override function restart() {
		super.restart();
		this.scene.gameManagment.canPlay = true;
		this.Position = new Vector2(this.initialPosition.x, this.initialPosition.y);

		this.scene.AllActors.unshift(this);
		this.scene.Player.unshift(this);

		this.scene.camera.position.y = this.Position.y;
		this.scene.camera.position.x = this.Position.x;

		this.cAttack = false;
		this.cStrongAttack = false;
		this.cLeft = false;
		this.cRight = false;
		this.cJump = false;

		this.scene.gameManagment.HUD.showUI();
	}


	var _lastPosition:Vector2 =  new Vector2(0,0);
	var _groundLastFrame:Bool = true;
	public override function update(DeltaTime:Float) {

		if(this.scene.camera != null && this.scene.camera.follow == null && this.scene.gameManagment.canPlay && !this._isFallingStart)
			this.scene.camera.follow = this;
		
		// check fall
		if(!this.isGrounded){
			if(this.speedGravity.y < 0) this.isFalling = true;
			else this.isFalling = false;
		}

		super.update(DeltaTime);
		this.AnimationController(DeltaTime);
		this.jump();

		this.takeDamage(DeltaTime);

		_lastPosition = new Vector2(this.Position.x, this.Position.y);

		if(_groundLastFrame && !this.isGrounded && this.cJump)
			this.scene.gameManagment.soundManagement.play("jump");
		else if(!_groundLastFrame && this.isGrounded)
			this.scene.gameManagment.soundManagement.play("grounded");

		if(this.isGrounded){
			if(!_walterImpactSound){
				this._walterImpactSound = true;
				this.scene.gameManagment.soundManagement.play("walter");
			}
		}

		if(_fast_attack)
			this.scene.gameManagment.soundManagement.play("sword1");

		_groundLastFrame = this.isGrounded;
	}

	public override function OnCollide(?tag:String) {
		if(this.scene.gameManagment.playerCollideDamange.indexOf(tag) != -1){
			if(!this._isTakingDamange){
				this.scene.gameManagment.life -= 1;
				this._isTakingDamange = true;
				if(this.scene.gameManagment.life == 0){
					this.scene.gameManagment.HUD.hideUI();
					this.scene.gameManagment.soundManagement.play("death");
				} else 
					this.scene.gameManagment.soundManagement.play("take_damage");
			}
		}
	}

	public override function updateData(DeltaTime:Float){
		if(this.scene.gameManagment.startThegame)super.updateData(DeltaTime);
		this.checkGrounded();
		this.checkAttackArea();
		this.move(DeltaTime);
	}

	public var mright:Bool = true;

	public var animation:Animation = new Animation();
	public override function render(g2:Graphics) {
		super.render(g2);
		if(this.isVisible && this.animation != null && this.Sprite != null){
			g2.drawScaledSubImage(
				this.Sprite, 
				this.animation.body.x, 
				this.animation.body.y + (_waterImpact ? 8 : 0), 
				this.animation.body.width + _widthSmash, 
				this.animation.body.height + _heightSmash,
				this.mright ? this.Position.x - 27 + _positionXSmash : this.Position.x + 37 - _positionXSmash, 
				this.Position.y - 16 + _positionYSmash, 
				this.mright ? this.animation.body.width  : -this.animation.body.width, 
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

		if(!this.cJump || !this.scene.gameManagment.canPlay)
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

		if((!this.cLeft && !this.cRight) || this.cAttack || this.cStrongAttack || !this.scene.gameManagment.canPlay)
			this.velocity.x = 0;
	}
	// end move

	// Controllers
	public var cRight:Bool = false;
	public var cLeft:Bool = false;
	public var cUp:Bool = false;
	public var cDown:Bool = false;
	public var cAttack:Bool = false;
	public var cStrongAttack:Bool = false;

	public var cJump:Bool = false;
	
	private function OnkeyDown(key:kha.input.KeyCode):Void{
		this.scene.gameManagment.startThegame = true;
		_isgamepad = false;
		if(this.scene.gameManagment.canPlay){
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
					if(!this.cStrongAttack) this.cAttack = true;
				case C:
					if(!this.cAttack && this.scene.gameManagment.hasStrongAttack)
						this.cStrongAttack = true;
				default:
					//none
			}
		}
	}

	private function OnKeyUp(key:kha.input.KeyCode):Void{
		if(this.scene.gameManagment.canPlay){
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
	}

	private var _isgamepad:Bool = false;
	private function ButtonGamepad(button:Int, value:Float){
		this._isgamepad = true;
		this.scene.gameManagment.startThegame = true;
		if(this.scene.gameManagment.canPlay){
			if(button == 15)
				if(value == 1) this.cRight = true;
				else this.cRight = false;
			else if(button == 14)
				if(value == 1) this.cLeft = true;
				else this.cLeft = false;
			else if(button == 0)
				if(value == 1) this.cJump = true;
				else this.cJump = false;
			if(button == 2 && !this.cStrongAttack)
				if(value == 1) this.cAttack = true;
			if(button == 3 && !this.cAttack && this.scene.gameManagment.hasStrongAttack)
				if(value == 1)
					this.cStrongAttack = true;
		}
	}

	private function ExisGamepad(button:Int, value:Float){
		if(this.scene.gameManagment.canPlay){
			if(button == 0){
				if(value > 0.3) this.cRight = true;
				else if(value < -0.3) this.cLeft = true;
				else if(value > -0.3 && value < 0.3){
					this.cRight = false;
					this.cLeft = false;
				}
			}
		}
	}

	// End Controllers

	// sword settings
	public var sword:SwordPlayer;
	var _fast_attack:Bool = false;
	public function checkAttackArea(){
		if(this.cAttack){
			this.sword._fastAttack();
			if(this.animation.getCurrentFrame() > 0){
				this.sword.updateData(0);
				this.sword.CheckAttack();
			}
		} else if(this.cStrongAttack){
			this.sword._strongAttack();
			if(this.animation.getCurrentFrame() > 2){
				this.sword.updateData(0);
				this.sword.CheckAttack();
			}
		}
	}
	// end sword settings


	// animation
	var _attackAnimation:Bool = false;
	var _isFallingStart:Bool = true;
	var _waterImpact:Bool = true;
	var _startGetUp:Bool = false;
	var _startShowPlayer:Bool = false; 
	var _getup:Bool = false;
	var _walterImpactSound:Bool = false;
	public function AnimationController(DeltaTime:Float){
		this.splashAnimation();

		if(this.cLeft)
			this.mright = false;
		if(this.cRight)
			this.mright = true;

		if(!_isFallingStart){
			if(this.isGrounded){
				if(this.scene.gameManagment.life < 1){
					this.animation.play(DeltaTime, "death", AnimationDirection.FORWARD);
					this.scene.gameManagment.canPlay = false;
					if(this.animation.lastFrame())
						this.scene.gameManagment.canRestart = true;
				}else if(this.velocity.x != 0)
					this.animation.play(DeltaTime, "Run-Right", AnimationDirection.LOOP);
				else{
					if(this.cAttack){
						this.animation.play(DeltaTime, "Fast-Attack", AnimationDirection.FORWARD);
						_fast_attack = false;
						if(!_attackAnimation)
							_fast_attack = true;
						_attackAnimation = true;
						if(this.animation.lastFrame()){
							_attackAnimation = false;
							this.cAttack = false;
						}
					} else if(this.cStrongAttack){
						this.animation.play(DeltaTime, "Attack-Right", AnimationDirection.FORWARD);
						_attackAnimation = true;
						if(this.animation.lastFrame()){
							_attackAnimation = false;
							this.cStrongAttack = false;
						}
					}else
						this.animation.play(DeltaTime, "Idle-Right", AnimationDirection.LOOP);
				}			
			} else {
				if(this.cAttack){
					this.animation.play(DeltaTime, "Fast-Attack", AnimationDirection.FORWARD);
					_fast_attack = false;
					if(!_attackAnimation)
						_fast_attack = true;
					_attackAnimation = true;
					if(this.animation.lastFrame()){
						_attackAnimation = false;
						this.cAttack = false;
					}
				}else if(this.cStrongAttack){
						this.animation.play(DeltaTime, "Attack-Right", AnimationDirection.FORWARD);
						_attackAnimation = true;
						if(this.animation.lastFrame()){
							_attackAnimation = false;
							this.cStrongAttack = false;
						}
				} else {
					if(this.isFalling)
						this.animation.play(DeltaTime, "Jump-Down-Right", AnimationDirection.LOOP);
					else
						this.animation.play(DeltaTime, "Jump-Up-Right", AnimationDirection.LOOP);
				}
			}
		} else {
			if(this.isGrounded){
				if(_waterImpact){
					this.animation.play(DeltaTime, "water-impact", AnimationDirection.FORWARD);
					if(this.animation.lastFrame() && !_startShowPlayer){
						_startShowPlayer = true;
						this.scene.gameManagment.showInitialCredits();
						wait(6, function () {
							_waterImpact = false;
						});
					}
				}else if(_getup){
					this.animation.play(DeltaTime, "get up", AnimationDirection.FORWARD);
					if(this.animation.lastFrame()){
						_isFallingStart = false;
						this.scene.gameManagment.canPlay = true;
						this.scene.gameManagment.HUD.showUI();
					}
				}else{
					this.animation.play(DeltaTime, "on the ground", AnimationDirection.FORWARD);
					if(this.animation.lastFrame() && !_startGetUp){
						wait(2, function () { _getup = true;});
						_startGetUp = true;
					}
				}
			}
			else
				this.animation.play(DeltaTime, "fall", AnimationDirection.LOOP);
		}
		
	}
	// end animation

	// splash and smash
	private var last_isgrounded:Bool = true;
	private var _widthSmash:Float = 0;
	private var _positionXSmash:Float = 0;
	private var _heightSmash:Float = 0;
	private var _positionYSmash:Float = 0;
	private var _GroundHit:Bool = false;
	public function splashAnimation(){
		if(!last_isgrounded && this.isGrounded && !_GroundHit){
			_widthSmash = -15;
			_heightSmash = 5;
			_positionXSmash = -9;
			_positionYSmash = 4;
			_GroundHit = true;
			wait(0.2, function (){
				_widthSmash = 0;
				_heightSmash = 0;
				_positionXSmash = 0;
				_positionYSmash = 0;
				_GroundHit = false;
			});
		}else if(this.isHeadHit && ! isGrounded){
			_widthSmash = -10;
			_heightSmash = 5;
			_positionXSmash = -7;
			_positionYSmash = 0;
		} else if(!_GroundHit){
			_widthSmash = 0;
			_heightSmash = 0;
			_positionXSmash = 0;
			_positionYSmash = 0;
		}

		this.last_isgrounded = this.isGrounded;
	}
	// end splash and smash

	// take damange
	private var _damageTimer:Float = 0;
	private var _isTakingDamange:Bool = false;
	private var _MaxTimeDamangeSeconds:Float = 3;
	private var _nextBlink:Float = 0;
	private function takeDamage(deltaTime:Float){
		if(this._isTakingDamange){
			if(this._damageTimer < this._MaxTimeDamangeSeconds){
				//blink effect
				if(this.scene.gameManagment.life > 0){
					if(this._damageTimer >= this._nextBlink){
						this.isVisible = true;
						this._nextBlink = this._damageTimer + 0.2;
					}else
						this.isVisible = false;
				}
				
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
	public var isHeadHit:Bool = false;
	public var isFalling:Bool = false;
	private function checkGrounded():Void{
		this.isGrounded = false;
		this.isHeadHit = false;
		for(ground in this.scene.AllSolids){
			if(ground.check(this.size, new Vector2(this.Position.x, this.Position.y + 1))){
				this.isGrounded = true;
				break;
			}
		}
		for(ground in this.scene.AllSolids){
			if(ground.check(this.size, new Vector2(this.Position.x, this.Position.y - 1))){
				this.isHeadHit = true;
				break;
			}
		}
	}

	public override function squish(?tag:String) {
	}

}