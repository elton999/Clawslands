package umbrellatoolkit;

import umbrellatoolkit.helpers.Point;
import umbrellatoolkit.collision.Actor;
import umbrellatoolkit.collision.Solid;
import umbrellatoolkit.helpers.BoxSprite;
import umbrellatoolkit.Scene;
import kha.math.Vector2;
import kha.Image;

class GameObject {
	public function new (){
		//this.start();
	}

	public var tag:String;
	public var Sprite:Image;
	public var Scale:Float = 1.0;
	public var Position:Vector2 = new Vector2(0,0);
	public var BoxSprite:BoxSprite;
	public var scene:Scene;
	public var show:Bool = false;
	public var isVisible:Bool = true;
	public var size:Point = new Point(32,32);

	public var valeus:Dynamic;
	public var flipX:Bool = false;
	public var positionNodes:Array<Vector2>;

	public var Destroy:Bool = false;

	public function start() : Void{}
	public function restart() :Void{
		// wait functions
		this._allCallbacks = new Array<Void -> Void>();
		this._timers = new Array<Float>();
		this._maxTime = new Array<Float>();
	}
	public function update(DeltaTime:Float) : Void{}
	public function updateData(DeltaTime:Float) : Void{}
	public function render(g2:kha.graphics2.Graphics): Void{}
	public function visible():Void{}
	public function hide():Void{}

	public function getActor():Actor{
		return new Actor();
	}

	public function getSolid():Solid{
		return new Solid();
	}

	public function lerp(min:Float, max:Float, value:Float) : Float{
		return min + (max - min) * value;
	}


	public function callFunction(tag:String):Void{}

	// wait function
	private var _allCallbacks:Array<Void -> Void> = new Array<Void -> Void>();
	private var _timers:Array<Float> = new Array<Float>();
	private var _maxTime:Array<Float> = new Array<Float>();

	public function wait(time:Float, callback:()-> Void):Void {
		this._timers.push(0);
		this._maxTime.push(time);
		this._allCallbacks.push(callback);
	}

	public function processWait(DeltaTime:Float){
		var __allCallbacks:Array<Void -> Void> = new Array<Void -> Void>();
		var __timers:Array<Float> = new Array<Float>();
		var __maxTime:Array<Float> = new Array<Float>();
		
		for(i in 0...this._timers.length){
			this._timers[i] += DeltaTime;
			if(this._timers[i] >= this._maxTime[i]){
				this._allCallbacks[i]();
			} else {
				__allCallbacks.push(this._allCallbacks[i]);
				__timers.push(this._timers[i]);
				__maxTime.push(this._maxTime[i]);
			}
		}

		this._allCallbacks = __allCallbacks;
		this._timers = __timers;
		this._maxTime = __maxTime;
	}
	// end wait function
}