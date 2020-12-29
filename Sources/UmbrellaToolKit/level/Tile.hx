package umbrellatoolkit.level;
import umbrellatoolkit.helpers.Point;
import kha.graphics2.Graphics;
import kha.Color;
import kha.math.Vector2;
import umbrellatoolkit.GameObject;
import umbrellatoolkit.level.TileSet;
import umbrellatoolkit.level.TileMap;

class Tile extends GameObject{
	public var tag:String;
	public var squareSize:Point;
	public var squarePosition:Point;
	public var squareColor:Color;
	public var GameObject:GameObject;

	public override function render(g2:Graphics) {
		//render square color
		if(this.squarePosition == null){
			g2.color = this.squareColor;
			g2.fillRect(
				this.Position.x, 
				this.Position.y, 
				this.squareSize.x, 
				this.squareSize.y
			);
			g2.color = Color.White;
		}

		// render sprite
		if(this.GameObject != null){
			g2.drawScaledSubImage(
				this.GameObject.Sprite,
				this.squarePosition.x,
				this.squarePosition.y,
				this.squareSize.x,
				this.squareSize.y,
				this.Position.x,
				this.Position.y,
				this.squareSize.x,
				this.squareSize.y
			);
		}
	}


}