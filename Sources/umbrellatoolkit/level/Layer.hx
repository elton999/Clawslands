package umbrellatoolkit.level;

import kha.Color;
import kha.Image;
import kha.graphics2.Graphics;
import umbrellatoolkit.GameObject;
import umbrellatoolkit.helpers.Point;
import kha.math.FastMatrix3;

class Layer extends GameObject{
	public var Items:Array<GameObject> = new Array();
	public var sizeBG:Point;
	public var offsset:Point;
	public var _BackBuffer:Image;
	public var trans:FastMatrix3;

	public function addGameObject(gameObject:GameObject):Void{
		this.Items.push(gameObject);
	}

	public override function render(g2:Graphics) {
		super.render(g2);

		g2.drawImage(this._BackBuffer, this.offsset.x, this.offsset.y);
	}

	public function begin(graphics:Graphics){
		graphics.transformation = trans;
		graphics.translate(-this.offsset.x, -this.offsset.y);
	}

	public function end(graphics:Graphics){
		graphics.popTransformation();
	}

	public function renderBuffer(){
		trans = FastMatrix3.identity();
		this._BackBuffer = Image.createRenderTarget(2000, 2000);
		
		var graphics = this._BackBuffer.g2;
		graphics.begin(Color.Transparent);
			this.begin(graphics);
			for(i in 0...this.Items.length) this.Items[i].render(graphics);
			this.end(graphics);
		graphics.end();

	}
}