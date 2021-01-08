package entities.enemies;

import kha.math.Vector2;
import kha.Image;
import kha.Assets;
import kha.graphics2.Graphics;
import entities.enemies.Enemy;
import umbrellatoolkit.collision.Actor;
import umbrellatoolkit.helpers.Point;
import umbrellatoolkit.sprite.Animation;

class Witch extends Enemy {
	public override function start(){
		super.start();

		this.scene.AllActors.push(this);
		this.size = new Point(10, 32);
		this.tag = "wicth";
		this.gravity2D = new Vector2(0, -200);
		this.life = 5;

		this.initialPosition = new Vector2(this.Position.x, this.Position.y);
		
		// loading sprites
		Assets.loadImage("Content_Sprites_player", function (done:Image){
			this.Sprite = done;
			this.animation = new Animation();
			this.animation.start("Content_Sprites_player_json");
		});
	}

	public override function restart() {
		super.restart();
		this.Position = new Vector2(this.initialPosition.x, this.initialPosition.y);
		this.isHide = true;
		this.isActive = true;
		this.life = 5;
		
	}

	public override function update(DeltaTime:Float) {
		super.update(DeltaTime);
		if(this.isActive) this.animation.play(DeltaTime, "wicther-idle", AnimationDirection.LOOP);
	}

	public override function takeDamage(hit:Int) 
	{
		super.takeDamage(hit);
	}

	public override function onTakeDamage() {
		super.onTakeDamage();
	}

	public override function OnCollide(?tag:String) {
		super.OnCollide(tag);
		if(tag == "player sword")
			this.takeDamage(5);
	}

	public var speed:Float = 40;
	public override function updateData(DeltaTime:Float) {
		if(!this.isHide && this.startPatrol && this.isActive){
			this.gravity(DeltaTime);
			if(this.scene.AllActors[0].Position.x > this.Position.x){
				this.mright = true;
				this.moveX(speed * DeltaTime, null);
			}else{
				this.mright = false;
				this.moveX(-(speed * DeltaTime), null);
			}
			super.updateData(DeltaTime);
		}
	}

	public var isHide:Bool = true;
	public var startPatrol:Bool = false;
	public override function visible() {
		super.visible();
		if(this.isHide) wait(0.5, function (){ this.startPatrol = true; });
		this.isHide = false;
	}

	var animation:Animation;
	public var mright:Bool = true;

	public override function render(g2:Graphics) {
		super.render(g2);
		if(this.isVisible && !this.isHide && this.animation != null && this.isActive){
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
}