package entities.solids;

import kha.math.Vector2;
import ui.TextBox;
import kha.Color;
import kha.graphics2.Graphics;
import umbrellatoolkit.collision.Solid;

class Gate extends Solid{
	public override function start() {
		this.tag = "gate";
		this.add(this.size, this.Position);
		this.scene.AllSolids.push(this);
	}

	public var textBox:TextBox;

	public override function updateData(DeltaTime:Float) {
		if(!this.valeus.boss_gate){
			if(this.check(this.scene.AllActors[0].size, new Vector2(this.scene.AllActors[0].Position.x + 1, this.scene.AllActors[0].Position.y))||
			this.check(this.scene.AllActors[0].size, new Vector2(this.scene.AllActors[0].Position.x - 1, this.scene.AllActors[0].Position.y))){
				if(this.scene.GameManagment.haskey){
					this.Destroy = true;
					this.scene.AllSolids.remove(this);
					this.scene.GameManagment.haskey = false;
				} else if(this.textBox == null){
					this.textBox = new TextBox();
					this.textBox.scene = this.scene;
					this.textBox.text = "The gate is locked";
					this.textBox.positionSpace = new Vector2(20, 0);
					this.textBox.start();
					this.scene.UI.push(this.textBox);
				}
			} else{
				if(this.textBox != null && this.textBox.Destroy)
					this.textBox = null;
			}
		}
	}

	public override function render(g2:Graphics) {
		g2.color = Color.Green;
		g2.fillRect(this.positions.x, this.positions.y, this.sizes.x, this.sizes.y);
		g2.color = Color.White;
	}
}