package entities.solids;

import kha.math.Vector2;
import kha.Color;
import kha.graphics2.Graphics;
import umbrellatoolkit.collision.Solid;

class MovePlatform extends Solid{

	public var intialPosition:Vector2;

	public override function start() {
		super.start();
		this.tag = "movePlatform";
		this.add(this.size, this.Position);
		this.scene.AllSolids.push(this);

		this.positionNodes.push(new Vector2(this.Position.x, this.Position.y));

		this.intialPosition = this.positions[0];
		this.valeus.speed = 1;
	}

	private var back:Bool = false;
	public override function updateData(DeltaTime:Float) {
		super.updateData(DeltaTime);

		if(!back){
			if(this.positionNodes[0].x == this.positionNodes[1].x){
				if(this.positionNodes[0].y > this.positions[0].y)
					move(0, this.valeus.speed);
				else
					move(0, -this.valeus.speed);

				if(this.positions[0].y == this.positionNodes[0].y)
					back = !back;
			} else {
				if(this.positionNodes[0].x > this.positions[0].x)
					move(this.valeus.speed, 0);
				else
					move(-this.valeus.speed, 0);

				if(this.positions[0].x == this.positionNodes[0].x)
					back = !back;
			}
		} else {
			if(this.positionNodes[0].x == this.positionNodes[1].x){
				if(this.positionNodes[1].y > this.positions[0].y)
					move(0, this.valeus.speed);
				else
					move(0, -this.valeus.speed);

				if(this.positions[0].y == this.positionNodes[1].y)
					back = !back;
			} else {
				if(this.positionNodes[1].x > this.positions[0].x)
					move(this.valeus.speed, 0);
				else
					move(-this.valeus.speed, 0);

				if(this.positions[0].x == this.positionNodes[1].x)
					back = !back;
			}
		}
	}


	public override  function render(g2:Graphics) {
		super.render(g2);

		g2.color = Color.Blue;
		g2.fillRect(this.positions[0].x, this.positions[0].y, this.sizes[0].x, this.sizes[0].y);
		g2.color = Color.White;
	}

}