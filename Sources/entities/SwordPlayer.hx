package entities;

import kha.math.Vector2;
import umbrellatoolkit.collision.Actor;
import umbrellatoolkit.helpers.Point;

class SwordPlayer extends Actor{
	public var player:Player;

	public override function start() {
		super.start();
		this.tag = "player sword";
	}

	var _fastAttackMode:Bool = false;
	public function _fastAttack(){
		this.size = new Point(18, 32);
		_fastAttackMode = true;
		_strongAttackMode = false;
	}

	var _strongAttackMode:Bool = false;
	public function _strongAttack(){
		this.size = new Point(28, 32);
		_fastAttackMode = false;
		_strongAttackMode = true;
	}

	public override function updateData(DeltaTime:Float) {
		super.updateData(DeltaTime);
		if(this.player.mright)
			this.Position = new Vector2(this.player.Position.x + this.player.size.x, this.player.Position.y);
		else
			this.Position = new Vector2(this.player.Position.x - this.size.x, this.player.Position.y);
	}

	public function CheckAttack(){
		for(i in 0...this.player.scene.AllActors.length){
			if(this.overlapCheck(this.player.scene.AllActors[i]))
				if(_fastAttackMode) this.player.scene.AllActors[i].OnCollide(this.tag);
				else this.player.scene.AllActors[i].OnCollide("player strong attack");
		}
		if(this._strongAttackMode){
			for(i in 0...this.player.scene.AllSolids.length){
				if(this.player.scene.AllSolids[i].tag == "strong rock"){
					if(this.player.scene.AllSolids[i].overlapCheck(this)){
						this.player.scene.AllSolids[i].onCollide("player strong attack");
						i = this.player.scene.AllSolids.length;
						break;
					}
				}
			}
		}
	}
}