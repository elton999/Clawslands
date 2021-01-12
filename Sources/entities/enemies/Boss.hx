package entities.enemies;

import umbrellatoolkit.collision.Actor;
import entities.enemies.Wicth.Witch;
import umbrellatoolkit.collision.Solid;
import kha.Color;
import kha.Image;
import kha.Assets;
import kha.math.Vector2;
import kha.graphics2.Graphics;
import ui.BossFightHUD;
import umbrellatoolkit.GameObject;
import umbrellatoolkit.sprite.Animation;
import umbrellatoolkit.helpers.Point;

class Boss extends Enemy{

	public var totalLife:Int = 250;
	public override function start() {
		super.start();
		this.scene.AllActors.push(this);
		this.size = new Point(16,64);
		this.tag = "boss";
		this.life = this.totalLife;

		this.initialPosition = new Vector2(this.Position.x, this.Position.y);

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
		// boss
		awake = false;
		walking = false;
	  	attack = false;
	  	finishAttack= false;
	  	startAttack = false;
		_firtAttack = false;
		this.Position = new Vector2(this.initialPosition.x, this.initialPosition.y);
		this.life = this.totalLife;
		this.isActive = true;
		
		// restart spawn system
		_spawEnemies = false;
		_finishSpawEnemies = false;
		_spawTimes = 0;
		_nextSpawEnemies = false;

		_allWichts = new Array<Witch>();
		_spawEnemiesPositions = new Array<GameObject>();
	}

	public var bossSword:BossSword;

	var animation:Animation;
	public override function update(DeltaTime:Float) {
		super.update(DeltaTime);
		this.spriteAnimation(DeltaTime);
	}

	private var _spawEnemies:Bool = false;
	private var _finishSpawEnemies:Bool = false;
	private var _nextSpawEnemies:Bool = false;
	private var _spawTimes:Int = 0;
	private var _maxtSpawTimes:Int = 3;
	private var _spawEnemiesPositions:Array<GameObject> = new Array<GameObject>();

	public function canFight():Bool{
		if(this.life < 100 ){
			if(!this._spawEnemies){
				this._spawEnemies = true;
				_spawEnemiesPositions = new Array<GameObject>();
				
				for(i in 0...this.scene.Enemies.length)
					if(this.scene.Enemies[i].tag == "wicth spaw")
						_spawEnemiesPositions.push(this.scene.Enemies[i]);

				this._nextSpawEnemies = true;
			}

			if(this._spawEnemies && !this._finishSpawEnemies)
				return false;
		}
		return true; 
	}


	private var _allWichts:Array<Witch> = new Array<Witch>();
	private function spawWicths(){
		if(this._nextSpawEnemies){
			this._nextSpawEnemies = false;

			for(i in 0...2){
				var _wicth:Witch = new Witch();
				_wicth.scene = this.scene;
				_wicth.Position = new Vector2(this._spawEnemiesPositions[i].Position.x, this._spawEnemiesPositions[i].Position.y);
				_wicth.valeus = this._spawEnemiesPositions[i].valeus;
				_wicth.valeus.spaw_here = false;
				_wicth.valeus.can_follow_when_see = true;
				_wicth.canDestroy = true;
				_wicth.loadingAnimation = true;
				if(i == 1)
					_wicth.flipX = true;
				this.scene.Enemies.push(_wicth);
				_wicth.start();
				_wicth.visible();

				_allWichts.push(_wicth);
			}

			this._spawTimes++;
		}
		
		var _dontExistAWicthAlives:Bool = true;
		for(i in 0...this._allWichts.length)
			if(!this._allWichts[i].Destroy)
				_dontExistAWicthAlives = false;

		if(_dontExistAWicthAlives && this._spawTimes < this._maxtSpawTimes)
			this._nextSpawEnemies = true;
			
		if(this._spawTimes >= this._maxtSpawTimes && _dontExistAWicthAlives)
			this._finishSpawEnemies = true;

	}

	public var speed:Float = 30;
	private var _attackSpeed:Float = 250;
	private var _maxSpaceToAttack:Float = 100;
	public override function updateData(DeltaTime:Float) {
		if(this.canFight()){
			if(this.awake && this.isActive){
				// looking for the player
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

					// attack player
				} else if(attack){
					this.bossSword.updateData(DeltaTime);

					if(this.mright)
						moveX(this._attackSpeed * DeltaTime, null);
					else
						moveX(-(this._attackSpeed * DeltaTime), null);

					super.updateData(DeltaTime);
				}else if(this.startAttack && !this.finishAttack){
					super.updateData(DeltaTime);
				}
			}
		} else {
			this.spawWicths();
		}
		
	}

	private var _gate:Array<Solid> = new Array<Solid>();
	public override function death() {
		this.scene.gameManagment.canPlay = false;

		// get gate solid gameobject
		for(i in 0...this.scene.AllSolids.length){
			if(this.scene.AllSolids[i].tag == "gate")
				this._gate.push(this.scene.AllSolids[i]);
		}

		//cut-scene
		this.scene.camera.follow = this._gate[0];
		this.scene.cameraLerpSpeed = 1;
		this.scene.camera.allowFollowY = false;

		wait(3, function () { this._gate[0].callFunction("open"); });
		wait(4, function (){ this.scene.camera.follow = this.scene.AllActors[0]; });
		wait(7, function (){
			this.scene.gameManagment.canPlay = true;
			this.scene.camera.allowFollowY = true;
			this.scene.cameraLerpSpeed = 8;
		});

		this.isActive = false;
	}
	
	private var _firtAttack:Bool = false;
	private var _HUD:BossFightHUD;
	public override function takeDamage(hit:Int) {
		if(this.awake && this.canFight())
			super.takeDamage(hit);
		else{
			if(!this._firtAttack){
				this.animation.play(0, "awake", AnimationDirection.FORWARD);
				this._firtAttack = true;

				wait(1, function () {
					// Life bar
					this._HUD = new BossFightHUD();
					this._HUD.scene = this.scene;
					this._HUD.boss = this;
					this.scene.UI.push(this._HUD);
				});

				wait(3, function () {
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
		if(!this.awake && !this._firtAttack)
			this.animation.play(DeltaTime, "idle", AnimationDirection.LOOP);
		else if(this.attack){
			this.animation.play(DeltaTime, "atack", AnimationDirection.FORWARD);
			if(this.animation.getCurrentFrame() > 1 && this.animation.getCurrentFrame() < 4)
				this.bossSword.checkAttack();

			if(this.animation.lastFrame() && !this.finishAttack){
				this.attack = false;
				this.finishAttack = true;
				wait(2, function (){ this.walking = true; this.startAttack = false; this.finishAttack = false; });
			}
		}
		else if(this._spawEnemies && !this._finishSpawEnemies)
			this.animation.play(DeltaTime, "idle", AnimationDirection.LOOP);
		else if(this.walking)
			this.animation.play(DeltaTime, "walk", AnimationDirection.LOOP);
		else if(!this.finishAttack)
			this.animation.play(DeltaTime, "awake", AnimationDirection.LOOP);
	}

	public var mright:Bool = true;
	public override function render(g2:Graphics) {
		super.render(g2);
		//this.bossSword.render(g2);
		
		if(this.isVisible && !this.isHide && this.animation != null){
			if(this.isTakingDamage)
				g2.color = Color.Red;
			else
				g2.color = Color.White;

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

			g2.color = Color.White;
		}
	}
}