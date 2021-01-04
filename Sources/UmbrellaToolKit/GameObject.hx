package umbrellatoolkit;

import umbrellatoolkit.helpers.Point;
import umbrellatoolkit.helpers.BoxSprite;
import umbrellatoolkit.Scene;
import kha.math.Vector2;
import kha.Image;
import kha.Assets;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;

class GameObject {
	public function new (){
		//this.start();
	}

	public var Sprite:Image;
	public var Scale:Float = 1.0;
	public var Position:Vector2 = new Vector2(0,0);
	public var BoxSprite:BoxSprite;
	public var scene:Scene;
	public var show:Bool = false;
	public var isVisible:Bool = true;
	public var size:Point = new Point(32,32);

	public var valeus:Dynamic;
	public var positionNodes:Array<Vector2>;

	public var Destroy:Bool = false;

	public function start() : Void{}
	public function update(DeltaTime:Float) : Void{}
	public function updateData(DeltaTime:Float) : Void{}
	public function render(g2:kha.graphics2.Graphics): Void{}
	public function visible():Void{}
	public function hide():Void{}

	public function lerp(min:Float, max:Float, value:Float) : Float{
		return min + (max - min) * value;
	}
}