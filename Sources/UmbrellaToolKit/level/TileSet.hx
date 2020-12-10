package umbrellatoolkit.level;
import kha.Color;
import haxe.Json;
import kha.math.Vector2;

class TileSet{

	public var Data:Ogmo;
	public function new(dataString:String){
		this.Data = Json.parse(dataString);
	}
}

typedef Ogmo = {
	var name:String;
	var ogmoVersion:String;
	var levelPaths:Array<String>;
	var backgroundColor:String;
	var gridColor:String;
	var layerGridDefaultSize:Vector2;
	var layers:Array<Layers>;
}

typedef Layers = {
	var exportID:String;
	var definition:String;
	var name:String;
	var gridSize:Vector2;
	var exportMode:Int;
	var arrayMode:Int;
	var legend:Array<String>;
	var defaultTileset:String;
}

typedef Entity = {
	var exportID:String;
	var name:String;
	var size:Vector2;
	var origin:Vector2;
	var tags:Array<String>;
	var values:Array<String>;
}