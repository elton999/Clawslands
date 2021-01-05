package entities.enemies;
import kha.math.Vector2;
import umbrellatoolkit.collision.Actor;

class Enemy extends Actor{

	public var isActive = true;
	public var initialPosition:Vector2;

	public override function update(DeltaTime:Float) {
		super.update(DeltaTime);
		this.demageAnimation(DeltaTime);
	}

	public override function updateData(DeltaTime:Float) {
	}

	public function checkPlayer():Void{
		if(!this.isTakingDamage){
			if(this.overlapCheck(this.scene.AllActors[0])){
				this.scene.AllActors[0].OnCollide(this.tag);
			}
		}
	}

	public var life:Int;
	public function takeDamage(hit:Int){
		if(!this.isTakingDamage){
			this.isTakingDamage = true;
			this.onTakeDamage();
			this.life -= hit;
		}
	}

	public function death(){
		//this.isActive = false;
		this.Destroy = true;
	}

	public override function OnCollide(?tag:String) {
		super.OnCollide(tag);
		if(tag == "player sword")
			this.takeDamage(5);
		else if(tag == "player strong attack")
			this.takeDamage(15);
	}	
	
	public function onTakeDamage(){}

	private var _damageTimer:Float = 0;
	private var isTakingDamage:Bool = false;
	private var _MaxTimeDamangeSeconds:Float = 1;
	private var _nextBlink:Float = 0;

	public function demageAnimation(deltaTime:Float){
		if(this.isTakingDamage){
			if(this._damageTimer < this._MaxTimeDamangeSeconds){
				//blink effect
				if(this._damageTimer >= this._nextBlink){
					this.isVisible = true;
					this._nextBlink = this._damageTimer + 0.1;
				}else
					this.isVisible = false;
				
				this._damageTimer += deltaTime;
			} else{
				this.isVisible = true;
				this.isTakingDamage = false;
				this._damageTimer = 0;
				this._nextBlink = 0;

				if(this.life <= 0)
					this.death();
			}
		}
	}
	
}