package entities.enemies;

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
		
		this.life = 1000;
		Assets.loadImage("Content_Sprites_boss", function (done:Image){
			this.Sprite = done;
			this.animation = new Animation();
			this.animation.start("Content_Sprites_boss_json");
		});
	}

	var animation:Animation;

	public override function update(DeltaTime:Float) {
		super.update(DeltaTime);
		this.spriteAnimation(DeltaTime);
		this.processWait(DeltaTime);
	}

	public override function updateData(DeltaTime:Float) {
		super.updateData(DeltaTime);
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
	public function spriteAnimation(DeltaTime:Float){
		if(!this.awake)
			this.animation.play(DeltaTime, "idle", AnimationDirection.LOOP);
		else
			this.animation.play(DeltaTime, "walk", AnimationDirection.LOOP);
	}

	public var mright:Bool = true;
	public override function render(g2:Graphics) {
		super.render(g2);
		if(this.isVisible && !this.isHide &&  this.Sprite != null){
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

	// wait function
	private var _allCallbacks:Array<Void -> Void> = new Array<Void -> Void>();
	private var _timers:Array<Float> = new Array<Float>();
	private var _maxTime:Array<Float> = new Array<Float>();

	public function wait(time:Float, callback:()-> Void):Void {
		this._timers.push(0);
		this._maxTime.push(time);
		this._allCallbacks.push(callback);
	}

	public function processWait(DeltaTime:Float){
		var __allCallbacks:Array<Void -> Void> = new Array<Void -> Void>();
		var __timers:Array<Float> = new Array<Float>();
		var __maxTime:Array<Float> = new Array<Float>();
		
		for(i in 0...this._timers.length){
			this._timers[i] += DeltaTime;
			if(this._timers[i] >= this._maxTime[i]){
				this._allCallbacks[i]();
			} else {
				__allCallbacks.push(this._allCallbacks[i]);
				__timers.push(this._timers[i]);
				__maxTime.push(this._maxTime[i]);
			}
		}

		this._allCallbacks = __allCallbacks;
		this._timers = __timers;
		this._maxTime = __maxTime;
	}
	// end wait function
}