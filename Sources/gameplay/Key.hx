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

		this.Sprite = this.scene.gameManagment.GameObject.Sprite;
	}

	public var textBox:TextBox;
	public override function updateData(DeltaTime:Float) {
		if(this.overlapCheck(this.scene.AllActors[0])){
			this.scene.gameManagment.haskey = true;
			this.Destroy = true;
			this.scene.AllActors.remove(this);

			this.textBox = new TextBox();
			this.textBox.scene = this.scene;
			this.textBox.text = "A key";
			this.textBox.positionSpace = new Vector2(10, 0);
			this.textBox.start();
			this.scene.UI.push(this.textBox);
			this.scene.gameManagment.soundManagement.play("collect_item");
		}
	}

	public override function render(g2:Graphics) {
		super.render(g2);
		g2.drawSubImage(this.Sprite, this.Position.x, this.Position.y, 10, 72, 10, 10);
	}
}