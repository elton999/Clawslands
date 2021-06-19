package umbrellatoolkit;

import kha.Scaler;
import kha.Image;
import kha.Assets;
import kha.Framebuffer;
import kha.System;
import kha.Color;
import umbrellatoolkit.GameObject;
import umbrellatoolkit.Camera;
import umbrellatoolkit.helpers.Point;
import umbrellatoolkit.level.TileSet;
import umbrellatoolkit.level.TileMap;
import umbrellatoolkit.collision.Actor;
import umbrellatoolkit.collision.Solid;
import umbrellatoolkit.level.AssetsManagment;

enum LayersScene {
	UI;
	FORENGROUND;
	PLAYER;
	ENEMIES;
	MIDDLEGROUND;
	BACKGROUND;
}

class Scene {

	public var UI:Array<GameObject> = new Array();
	public var Forenground:Array<GameObject> = new Array();
	public var Player:Array<GameObject> = new Array();
	public var Enemies:Array<GameObject> = new Array();
	public var MiddleGround:Array<GameObject> = new Array();
	public var Background:Array<GameObject> = new Array();
	
	public var BackgroundColor:Color = Color.Blue;
	public var ScreemSize:Point = new Point(426, 240);
	public var cameraLerpSpeed:Float = 0.06;

	public var gameManagment:GameManagment;

	public var _BackBuffer:Image;

	public var SceneReady:Bool = false;
	public var AllSolids:Array<Solid> = new Array<Solid>();
	public var AllActors:Array<Actor> = new Array<Actor>();

	public var scene:umbrellatoolkit.Scene;
	public var camera:Camera;

	public function new (){}

	public function CreateScene(){
		if(this.scene != null){
			this.scene = new umbrellatoolkit.Scene();
		}
	}


	public var TileSet:TileSet;
	public var TileMap:TileMap;
	private var TileSetString:String;
	private var TileMapString:String;
	
	public function LoadLevel(tileSet:String, level:String, tilemapImage:GameObject, assets:AssetsManagment){
		this.TileSetString = tileSet;
		this.TileMapString = level;
		
		this.camera = new Camera();
		this.camera.scene = this;

		Assets.loadBlob(tileSet, function (done:kha.Blob.Blob){
			this.TileSet = new TileSet(done.toString());
			Assets.loadBlob(level, function(done:kha.Blob.Blob){
				this.TileMap = new TileMap(done.toString(), this.TileSet, this, assets);
				this.TileMap.CreateLevel(tilemapImage);
				this.SceneReady = true;
			});
		});
	}

	public function restart(){
		for(gameObject in this.Background) gameObject.restart();
		for(gameObject in this.MiddleGround) gameObject.restart();
		for(gameObject in this.Enemies) gameObject.restart();
		for(gameObject in this.Player) gameObject.restart();
		for(gameObject in this.Forenground) gameObject.restart();
		for(gameObject in this.UI) gameObject.restart();
	}

	public function UloadLevel(){
		
	}

	public function update(deltaTime:Float) : Void{
		if(this.SceneReady){
			this.DestroyGameObjects();
			for(gameObject in this.Background){
				gameObject.update(deltaTime);
				gameObject.processWait(deltaTime);
			}
			for(gameObject in this.MiddleGround){
				gameObject.update(deltaTime);
				gameObject.processWait(deltaTime);
			}
			for(gameObject in this.Enemies){
				gameObject.update(deltaTime);
				gameObject.processWait(deltaTime);
			}
			for(gameObject in this.Player){
				gameObject.update(deltaTime);
				gameObject.processWait(deltaTime);
			}
			for(gameObject in this.Forenground){
				gameObject.update(deltaTime);
				gameObject.processWait(deltaTime);
			}
			for(gameObject in this.UI){
				gameObject.update(deltaTime);
				gameObject.processWait(deltaTime);
			}
		}
	}

	public function updateData(deltaTime:Float) : Void{
		if(this.SceneReady){
			if(this.camera != null) this.camera.update(deltaTime);
			for(i in 0...this.Background.length) this.Background[i].updateData(deltaTime);
			for(i in 0...this.MiddleGround.length) this.MiddleGround[i].updateData(deltaTime);
			for(i in 0...this.Enemies.length) this.Enemies[i].updateData(deltaTime);
			for(i in 0...this.Player.length) this.Player[i].updateData(deltaTime);
			for(i in 0...this.Forenground.length) this.Forenground[i].updateData(deltaTime);
			for(i in 0...this.UI.length) this.UI[i].updateData(deltaTime);

			this.camera.updateData();
		}
	}

	public function render(framebuffer: Framebuffer): Void{
		if(this._BackBuffer != null)
			this._BackBuffer.unload();
		this._BackBuffer = Image.createRenderTarget(this.ScreemSize.x, this.ScreemSize.y);
		
		var graphics = this._BackBuffer.g2;
		graphics.begin(this.BackgroundColor);
			if(this.SceneReady){
				if(this.camera != null) this.camera.begin(graphics);
				for(gameObject in this.Background) gameObject.render(graphics);
				for(gameObject in this.MiddleGround) gameObject.render(graphics);
				for(gameObject in this.Enemies) gameObject.render(graphics);
				for(gameObject in this.Player) gameObject.render(graphics);
				for(gameObject in this.Forenground) gameObject.render(graphics);
				for(gameObject in this.UI) gameObject.render(graphics);
				if(this.camera != null) this.camera.end(graphics);
			} else{
				graphics.fillRect(0,0 ,8,8);
			}
		graphics.end();

		framebuffer.g2.begin();
			Scaler.scale(this._BackBuffer, framebuffer, System.screenRotation);
		framebuffer.g2.end();
	}


	private function DestroyGameObjects():Void{
		var newArray:Array<GameObject> = new Array<GameObject>();
		for(gameObject in this.Background)
			if(!gameObject.Destroy)
				newArray.push(gameObject);
		this.Background = newArray;
		newArray = new Array<GameObject>();

		for(gameObject in this.MiddleGround)
			if(!gameObject.Destroy)
				newArray.push(gameObject);
		this.MiddleGround = newArray;
		newArray= new Array<GameObject>();

		for(gameObject in this.Enemies)
			if(!gameObject.Destroy)
				newArray.push(gameObject);
		this.Enemies = newArray;
		newArray = new Array<GameObject>();

		for(gameObject in this.Player)
			if(!gameObject.Destroy)
				newArray.push(gameObject);
		this.Player = newArray;
		newArray = new Array<GameObject>();

		for(gameObject in this.Forenground)
			if(!gameObject.Destroy)
				newArray.push(gameObject);
		this.Forenground = newArray;
		newArray = new Array<GameObject>();

		for(gameObject in this.UI)
			if(!gameObject.Destroy)
				newArray.push(gameObject);
		this.UI = newArray;
	}
}