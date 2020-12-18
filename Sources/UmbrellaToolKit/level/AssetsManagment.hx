package umbrellatoolkit.level;

import umbrellatoolkit.helpers.Point;
import kha.math.Vector2;
import umbrellatoolkit.GameObject;
import umbrellatoolkit.Scene;

class AssetsManagment
{
	private var _GameObjectsList:Map<String, AssetObject> = new Map<String, AssetObject>();

	public var gameManagment:GameManagment;
	
	public function new(){}

	public function start():Void{
		
	}

	public function add(type:Class<GameObject>, tag:String, layer:LayersScene):Void{
		var asset:AssetObject = new AssetObject();
		asset.gameObject = type;
		asset.layer = layer;

		this._GameObjectsList.set(tag, asset);
	}

	public function addEntityOnSene(tag:String, scene:Scene, position:Vector2, ?size:Point, ?values:Dynamic, ?nodes:Array<Vector2>):Void{
		if(this._GameObjectsList.exists(tag)){
			var asset:AssetObject = this._GameObjectsList[tag];
			var gameObject:GameObject = Type.createInstance(asset.gameObject, []);
			
			gameObject.Position = position;
			if(size != null) gameObject.size = size;
			if(values != null) gameObject.valeus = values;
			if(nodes != null) gameObject.positionNodes = nodes;
			gameObject.scene = scene;

			switch (asset.layer){
				case PLAYER:
					gameObject.start();
					scene.Player.push(gameObject);
				case ENEMIES:
					gameObject.start();
					scene.Enemies.push(gameObject);
				case MIDDLEGROUND:
					gameObject.start();
					scene.MiddleGround.push(gameObject);
				default:
					trace("not found");
			}
		}
	}
}

class AssetObject{
	public var gameObject:Class<GameObject>;
	public var layer:LayersScene;
	public function new(){}
}