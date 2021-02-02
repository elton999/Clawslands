package entities.solids;

import kha.math.Vector2;
import ui.TextBox;
import kha.Color;
import kha.graphics2.Graphics;
import umbrellatoolkit.collision.Solid;

class Gate extends Solid{
	public override function start() {
		this.tag = "gate";
		this.opened = this.valeus.opened;
		if(!this.opened){
			this.add(this.size, this.Position);
			this.scene.AllSolids.push(this);
		}
	}

	public var textBox:TextBox;

	public override function updateData(DeltaTime:Float) {
		if(!this.valeus.boss_gate && !this.opened){
			if(this.check(this.scene.AllActors[0].size, new Vector2(this.scene.AllActors[0].Position.x + 1, this.scene.AllActors[0].Position.y))||
			this.check(this.scene.AllActors[0].size, new Vector2(this.scene.AllActors[0].Position.x - 1, this.scene.AllActors[0].Position.y))){
				if(this.scene.gameManagment.haskey){
					this.open();
					this.scene.gameManagment.haskey = false;
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
	
	public var opened:Bool = false;
	public function open():Void{
		this.Destroy = true;
		this.scene.AllSolids.remove(this);

		this.scene.gameManagment.soundManagement.play("open_gate");

		var gate:Gate = new Gate();
		gate.opened = true;
		gate.scene = this.scene;
		gate.valeus = this.valeus;
		gate.Position = this.Position;
		gate.valeus.boss_gate = false;
		gate.valeus.opened = true;
		this.scene.MiddleGround.push(gate);
		gate.start();
	}

	public override function callFunction(tag:String) {
		super.callFunction(tag);
		if(tag == "open"){
			this.open();
		}
	}

	public override function render(g2:Graphics) {
		if(this.opened){
			g2.drawScaledSubImage(
				this.scene.gameManagment.GameObject.Sprite, 
				22, 
				112, 
				41, 
				80,
				this.Position.x, 
				this.Position.y, 
				41, 
				80
			);
		}else {
			g2.drawScaledSubImage(
				this.scene.gameManagment.GameObject.Sprite, 
				0, 
				112, 
				19, 
				80,
				this.Position.x, 
				this.Position.y, 
				19, 
				80
			);
		}
	}
}