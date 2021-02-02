package entities.solids;

import kha.Image;
import kha.Assets;
import umbrellatoolkit.sprite.Animation;
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
		this.intialPosition = new Vector2(this.positions.x, this.positions.y);
		this.valeus.speed = 1;

		Assets.loadImage("Content_Sprites_platform", function (done:Image){
			this.Sprite = done;
			this.animation.start("Content_Sprites_platform_json");
		});
	}

	public var animation:Animation = new Animation();
	public override function restart() {
		super.restart();
		this.back = false;
		this.positions = new Vector2(this.intialPosition.x, this.intialPosition.y);
	}

	public override function update(DeltaTime:Float) {
		super.update(DeltaTime);
		this.animation.play(DeltaTime, "idle", AnimationDirection.LOOP);
	}

	private var back:Bool = false;
	public override function updateData(DeltaTime:Float) {
		super.updateData(DeltaTime);

		if(!back){
			if(this.positionNodes[0].x == this.positionNodes[1].x){
				if(this.positionNodes[0].y > this.positions.y)
					move(0, this.valeus.speed);
				else
					move(0, -this.valeus.speed);

				if(this.positions.y == this.positionNodes[0].y)
					back = !back;
			} else {
				if(this.positionNodes[0].x > this.positions.x)
					move(this.valeus.speed, 0);
				else
					move(-this.valeus.speed, 0);

				if(this.positions.x == this.positionNodes[0].x)
					back = !back;
			}
		} else {
			if(this.positionNodes[0].x == this.positionNodes[1].x){
				if(this.positionNodes[1].y > this.positions.y)
					move(0, this.valeus.speed);
				else
					move(0, -this.valeus.speed);

				if(this.positions.y == this.positionNodes[1].y)
					back = !back;
			} else {
				if(this.positionNodes[1].x > this.positions.x)
					move(this.valeus.speed, 0);
				else
					move(-this.valeus.speed, 0);

				if(this.positions.x == this.positionNodes[1].x)
					back = !back;
			}
		}
	}


	public override  function render(g2:Graphics) {
		super.render(g2);

		g2.drawSubImage(
			this.Sprite,
			this.positions.x,
			this.positions.y,
			this.animation.body.x,
			this.animation.body.y,
			this.animation.body.width,
			this.animation.body.height
		);
	}

}