package umbrellatoolkit.level;
import umbrellatoolkit.helpers.Point;
import kha.math.Vector2;
import umbrellatoolkit.Scene;
import haxe.Json;
import kha.Color;
import umbrellatoolkit.GameObject;
import umbrellatoolkit.level.Tile;
import umbrellatoolkit.level.TileSet;
import umbrellatoolkit.level.Layer;
import umbrellatoolkit.collision.Solid;
import umbrellatoolkit.level.AssetsManagment;

class TileMap{
	public var Data:Level;
	private var _TileSet:TileSet;
	private var _Scene:Scene;
	private var _Assets:AssetsManagment;

	public function new(dataString:String, tileSet:TileSet, scene:Scene, assets:AssetsManagment){
		this.Data = Json.parse(dataString);
		this._TileSet = tileSet;
		this._Scene = scene;
		this._Assets = assets;
	}

	public function CreateLevel(){
		var i:Int = 0;
		while (i < this.Data.layers.length){
			var layer = this.Data.layers[i];
			var layers:Layer = new Layer();

			// Grid
			if(layer.grid2D != null){
				this.collisionTiles = new Array<Array<String>>();

				for(layerD in this._TileSet.Data.layers){
					if(layer._eid == layerD.exportID){
						var x = 0;
						var y = 0;
						for (line in layer.grid2D){
							x = 0;
							this.collisionTiles.push(new Array<String>());

							for(row in line){
								// if isn't transparent create a tile color
								if(row != "0"){
									this.collisionTiles[y].push(row);
									/*var tile:Tile = new Tile();
									tile.tag = row;
									tile.squareColor = Color.Yellow; //Color.fromString(layerD.legend[Std.parseInt(row)].substring(0,7));
									tile.squareSize = new Point(layer.gridCellWidth, layer.gridCellHeight);
									tile.Position = new Vector2(layer.gridCellWidth*x, layer.gridCellHeight*y);

									//this.addCollisionLayer(row, tile.squareSize, tile.Position);

									layers.addGameObject(tile);*/
								}else
									this.collisionTiles[y].push("0");

								x++;
							}
							y++;
						}
					}
				}

				// setting tiles colors on Scene
				this.collisionTilesProcess(layers);
				this._Scene.Background.push(layers);
			}//End Grid
			
			// entities
			else if(layer.entities != null){
				for(entity in layer.entities){
					this._Assets.addEntityOnSene(
						entity.name,
						this._Scene,
						new Vector2(entity.x, entity.y),
						entity.height > 0 ? new Point(entity.width, entity.height) : null,
						entity.values,
						entity.nodes
						);
				}
			}// End entities

			i++;
		}

		this._Scene.BackgroundColor = Color.fromString(this._TileSet.Data.backgroundColor.substring(0,7));
	}

	public function addCollisionLayer(tag:String, size:Point, position:Vector2){
		/*var _find:Bool = false;
		var i = 0;
		while(i < this._Scene.AllSolids.length){
			if(this._Scene.AllSolids[i].tag == tag){
				_find = true;
				this._Scene.AllSolids[i].add(size, position);
			}
			i++;
		}

		if(!_find){
			var _collision:Solid = new Solid();
			_collision.tag = tag;
			_collision.add(size, position);
			this._Scene.AllSolids.push(_collision);
		}*/
		var _collision:Solid = new Solid();
		_collision.tag = tag;
		_collision.add(size, position);
		this._Scene.AllSolids.push(_collision);
	}

	var collisionProcessed:Array<Solid>;
	var collisionTiles:Array<Array<String>>;
	public function collisionTilesProcess(layers:Layer){
		this.collisionProcessed = new Array<Solid>();
		var cancel = false;
		while (this.checkCollisionTiles()){
			var x = 0;
			var y = 0;
			cancel = false;
			for(tilex in this.collisionTiles){
				for(tiley in tilex){
					if(tiley != "0"){
						var _tag = tiley;
						var _position:Vector2 = new Vector2(y*8, x*8);
						var _size:Point = new Point(8,8);

						// check width
						var xx = x;
						var yy = y + 1;
						while(yy < this.collisionTiles[xx].length && this.collisionTiles[xx][yy] == _tag){
							_size = new Point(_size.x+8, _size.y);
							yy++;
						}

						xx++;
						var collisionFind = true;
						while(collisionFind){
							var i = y;
							var maxWidth:Int = y + Std.int(_size.x / 8);
							var widthcheck = 0;
							while(i < maxWidth){
								if( xx == this.collisionTiles.length || this.collisionTiles[xx][i] != _tag){
									collisionFind = false;
									break;
								} else {
									widthcheck++;
								}
								i++;
								if(!collisionFind)
									break;
							}
							if(widthcheck == maxWidth -y && collisionFind)
								_size = new Point(_size.x, _size.y+8);
							xx++;
						}
						
						this.removeCollisionInfo( y, y + Std.int(_size.x / 8) - 1, x, x + Std.int(_size.y / 8) - 1);
						this.addCollisionLayer(_tag, _size, _position);

						var tile:Tile = new Tile();
						tile.tag = _tag;
						tile.squareColor = Color.Yellow;
						tile.squareSize = _size;
						tile.Position = _position;

						layers.addGameObject(tile);

						cancel = true;
					}
					if(cancel)
						break;
					y++;
				}
				if(cancel)
					break;
				x++;
				y = 0;
			}

		}
	}

	public function checkCollisionTiles():Bool{
		for(x in this.collisionTiles)
			for(y in x)
				if(y != "0") 
					return true;
		return false;
	}

	public function removeCollisionInfo(xFrom:Int, xTo:Int, yFrom:Int, yTo:Int){
		var x = xFrom;
		while(yFrom <= yTo){
			while(x <= xTo){
					this.collisionTiles[yFrom][x] = "0";
				x++;
			}
			x = xFrom;
			yFrom++;
		}
	}
}

typedef Level = {
	var width:Int;
	var height:Int;
	var offsetX: Int;
	var offsetY: Int;
	var layers:Array<LevelLayer>;
}

typedef LevelLayer = {
	var name:String;
	var _eid:String;
	var offsetX:Int;
	var offsetY:Int;
	var gridCellWidth:Int;
	var gridCellHeight:Int;
	var gridCellsX:Int;
	var gridCellsY:Int;
	var data2D:Array<Array<Int>>;
	var grid2D:Array<Array<String>>;
	var entities:Array<LevelLayerEntities>;
}

typedef LevelLayerEntities = {
	var name:String;
	var _eid:String;
	var x:Int;
	var y:Int;
	var originX:Int;
	var originY:Int;
	var height:Int;
	var width:Int;
	var values:Dynamic;
	var nodes:Array<Vector2>;
}