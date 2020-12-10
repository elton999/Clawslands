package umbrellatoolkit;

import umbrellatoolkit.Scene;
import umbrellatoolkit.helpers.Point;
import kha.math.Vector2;
import umbrellatoolkit.GameObject;
import kha.graphics2.Graphics;
import kha.math.FastMatrix3;

class Camera {
	public var position:Vector2 = new  Vector2(0,0);
	public var trans:FastMatrix3;

	public var follow:umbrellatoolkit.GameObject;
	public var scene:Scene;

	public var allowFollowX:Bool = true;
	public var allowFollowY:Bool = true;

	public function new(){
		trans = FastMatrix3.identity();
	}

	public function update(deltaTime:Float){
		timer = deltaTime;
		if(this.follow != null){
			if(this.allowFollowX)
				this.position.x = this.lerp(this.position.x , this.follow.Position.x, this.scene.cameraLerpSpeed*deltaTime);
			if(this.allowFollowY)
				this.position.y = this.lerp(this.position.y, this.follow.Position.y, this.scene.cameraLerpSpeed*deltaTime);
		}
	}

	public function lerp(min:Float, max:Float, value:Float) : Float{
		return min + (max - min) * value;
	}

	private var timer:Float;
	public function begin(graphics:Graphics){
		graphics.transformation = trans;
		graphics.translate(-this.position.x + (this.scene.ScreemSize.x / 2), -this.position.y + (this.scene.ScreemSize.y / 2));
	}

	public function end(graphics:Graphics){
		graphics.popTransformation();
	}
}