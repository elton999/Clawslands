package entities.enemies;
import umbrellatoolkit.collision.Actor;

class Enemy extends Actor{


	public override function update(DeltaTime:Float) {
		super.update(DeltaTime);
		this.demageAnimation(DeltaTime);
	}

	public override function updateData(DeltaTime:Float) {
		if(this.overlapCheck(this.scene.AllActors[0])){
			this.scene.AllActors[0].OnCollide(this.tag);
		}
	}

	public var life:Int;
	public function takeDamage(hit:Int){
		if(!this.isTakingDamage){
			this.blinkTimes = 0;
			this.isTakingDamage = true;
			this.onTakeDamage();
			this.life -= hit;
		}
	}

	public function death(){
		this.Destroy = true;
	}
	
	public function onTakeDamage(){}

	private var isTakingDamage:Bool = false;
	private var blinkTimes:Int = 0;
	public function demageAnimation(deltaTime:Float){
		if(this.isTakingDamage){
			if(deltaTime % 4 < 2){
				this.blinkTimes += 1;
				this.isVisible = false;
			} else
				this.isVisible = true;

			if(this.blinkTimes > 20){ 
				this.isTakingDamage = false;
				this.isVisible = true;
				if(this.life <= 0)
					this.death();
			}
		}
	}
	
}