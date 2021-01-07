package gameplay;

import kha.Color;
import ui.TextBox;
import kha.math.Vector2;
import kha.graphics2.Graphics;
import umbrellatoolkit.collision.Actor;
import umbrellatoolkit.helpers.Point;

class Key extends Actor{
	public override function start() {
		super.start();

		this.tag = "key";
		this.size = new Point(8,8);
	}

	public var textBox:TextBox;
	public override function updateData(DeltaTime:Float) {
		if(this.overlapCheck(this.scene.AllActors[0])){
			this.scene.GameManagment.haskey = true;
			this.Destroy = true;
			this.scene.AllActors.remove(this);

			this.textBox = new TextBox();
			this.textBox.scene = this.scene;
			this.textBox.text = "A key";
			this.textBox.positionSpace = new Vector2(10, 0);
			this.textBox.start();
			this.scene.UI.push(this.textBox);
		}
	}

	public override function render(g2:Graphics) {
		super.render(g2);
		g2.color = Color.Yellow;
		g2.fillRect(this.Position.x, this.Position.y, this.size.x, this.size.y);
		g2.color = Color.White;
	}
}