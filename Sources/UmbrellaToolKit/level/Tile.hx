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
	public var squareColor:Color;

	public override function render(g2:Graphics) {
		//render square color
		if(this.squareSize.x != 0){
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
		if(this.Sprite != null){

		}
	}


}