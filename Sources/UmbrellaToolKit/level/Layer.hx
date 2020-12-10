package umbrellatoolkit.level;

import kha.Color;
import kha.Image;
import kha.graphics2.Graphics;
import umbrellatoolkit.GameObject;

class Layer extends GameObject{
	private var Items:Array<GameObject> = new Array();

	public function addGameObject(gameObject:GameObject):Void{
		this.Items.push(gameObject);
	}

	public override function render(g2:Graphics) {
		super.render(g2);
		for(i in 0...this.Items.length) this.Items[i].render(g2);
	}
}