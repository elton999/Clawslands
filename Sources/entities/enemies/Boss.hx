package entities.enemies;

import umbrellatoolkit.collision.Solid;
import kha.Color;
import kha.Image;
import kha.Assets;
import kha.math.Vector2;
import kha.graphics2.Graphics;
import umbrellatoolkit.sprite.Animation;
import umbrellatoolkit.helpers.Point;

class Boss extends Enemy{

	public override function start() {
		super.start();
		this.scene.AllActors.push(this);
		this.size = new Point(16,64);
		this.tag = "boss";
		
		//this.life = 150;
		this.life = 15;
		Assets.loadImage("Content_Sprites_boss", function (done:Image){
			this.Sprite = done;
			this.animation = new Animation();
			this.animation.start("Content_Sprites_boss_json");
		});

		this.bossSword = new BossSword();
		this.bossSword.boss = this;
		this.bossSword.start();
	}

	public override function restart() {
		super.restart();
		this.isActive = true;
	}

	public var bossSword:BossSword;

	var animation:Animation;
	public override function update(DeltaTime:Float) {
		super.update(DeltaTime);
		this.spriteAnimation(DeltaTime);
	}

	public var speed:Float = 30;
	private var _attackSpeed:Float = 250;
	private var _maxSpaceToAttack:Float = 100;
	public override function updateData(DeltaTime:Float) {
		if(this.awake && this.isActive){
			if(this.walking && !this.startAttack){
				if(this.scene.AllActors[0].Position.x > this.Position.x){
					this.mright = true;
					moveX(this.speed * DeltaTime, null);
					if(this.scene.AllActors[0].Position.x - this.Position.x <= _maxSpaceToAttack){
						wait(1, function () { 
							this.attack = true;
							this.finishAttack = false;
						});
						this.startAttack = true;
						this.walking = false;
					}
				} else{
					this.mright = false;
					moveX(-(this.speed * DeltaTime), null);
					if(this.Position.x - this.scene.AllActors[0].Position.x  <= _maxSpaceToAttack){
						wait(1, function () { 
							this.attack = true;
							this.finishAttack = false;
						});
						this.startAttack = true;
						this.walking = false;
					}
				}

				super.updateData(DeltaTime);
			} else if(attack){
				this.bossSword.updateData(DeltaTime);

				if(this.mright)
					moveX(this._attackSpeed * DeltaTime, null);
				else
					moveX(-(this._attackSpeed * DeltaTime), null);

				super.updateData(DeltaTime);
			}
		}
	}

	private var _gate:Solid;
	public override function death() {
		this.scene.GameManagment.canPlay = false;
		for(i in 0...this.scene.AllSolids.length){
			if(this.scene.AllSolids[i].tag == "gate")
				this._gate = this.scene.AllSolids[i];
		}
		this.scene.camera.follow = this._gate;
		this.scene.cameraLerpSpeed = 1;

		wait(3, function () { this._gate.callFunction("open"); });
		wait(4, function (){ this.scene.camera.follow = this.scene.AllActors[0]; });
		wait(7, function (){
			this.scene.GameManagment.canPlay = true;
			this.scene.cameraLerpSpeed = 8;
		});

		this.isActive = false;
	}
	
	private var _firtAttack:Bool = false;
	public override function takeDamage(hit:Int) {
		if(this.awake)
			super.takeDamage(hit);
		else{
			if(!this._firtAttack){
				this._firtAttack = true;
				wait(2, function () {
					this.awake = true;
					this.walking = true;
				});
			}
		}
	}
	
	public var isHide:Bool = true;
	public override function visible() {
		super.visible();
		this.isHide = false;
	}

	public var awake:Bool = false;
	public var walking:Bool = false;
	public var attack:Bool = false;
	public var finishAttack:Bool= false;
	public var startAttack:Bool = false;
	public function spriteAnimation(DeltaTime:Float){
		if(!this.awake)
			this.animation.play(DeltaTime, "idle", AnimationDirection.LOOP);
		else if(this.attack){
			this.animation.play(DeltaTime, "atack", AnimationDirection.FORWARD);
			if(this.animation.getCurrentFrame() > 1 && this.animation.getCurrentFrame() > 4)
				this.bossSword.checkAttack();

			if(this.animation.lastFrame() && !this.finishAttack){
				this.attack = false;
				this.finishAttack = true;
				wait(4, function (){ this.walking = true; this.startAttack = false; this.finishAttack = false; });
			}
		}else if(this.walking)
			this.animation.play(DeltaTime, "walk", AnimationDirection.LOOP);
		else if(!this.finishAttack)
			this.animation.play(DeltaTime, "idle", AnimationDirection.LOOP);
	}

	public var mright:Bool = true;
	public override function render(g2:Graphics) {
		super.render(g2);
		this.bossSword.render(g2);
		if(this.isVisible && !this.isHide && this.animation != null){
			g2.drawScaledSubImage(
				this.Sprite, 
				this.animation.body.x, 
				this.animation.body.y, 
				this.animation.body.width, 
				this.animation.body.height,
				this.mright ? this.Position.x - 27 * 2 : this.Position.x + 37 * 2, 
				this.Position.y - 32, 
				this.mright ? this.animation.body.width * 2 : -this.animation.body.width * 2, 
				this.animation.body.height * 2
			);
		}
	}
}