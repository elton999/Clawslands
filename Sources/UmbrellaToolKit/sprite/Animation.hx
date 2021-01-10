package umbrellatoolkit.sprite;

import haxe.Json;
import kha.Assets;
import umbrellatoolkit.helpers.Rectangle;

class Animation {
	private var AsepriteDefinitions:AnimationDirectionAseprite;

	private var frame:Int;
	private var frameCurrent:Int;
	private var frameCount:Float;
	private var maxFrame:Array<Float>;
	private var direction:AnimationDirection;
	private var checkedFirstframe:Bool;

	private var a_from:Int;
	private var a_to:Int;
	private var tag:String;

	public var body:Rectangle= new Rectangle(0,0,0,0);

	public function new(){}

	public function start(filename):Void{
		Assets.loadBlob(filename, function (done:kha.Blob.Blob){
			this.AsepriteDefinitions = Json.parse(done.toString());
		});
	}

	public function unload():Void{

	}

	public function lastFrame():Bool{
		 if (this.maxFrame != null)
            if (this.maxFrame[this.maxFrame.length - 1] < this.frameCount && this.tag != null) return true;
		return false;
	}

	public function getCurrentFrame():Int{
		return this.frameCurrent;
	}

	public function play(deltaTime:Float, tag:String, aDirection:AnimationDirection = AnimationDirection.FORWARD){
		 if (tag != this.tag)
            {
                var i:Int = 0;
                while (i < this.AsepriteDefinitions.meta.frameTags.length)
                {
                    if (tag == this.AsepriteDefinitions.meta.frameTags[i].name)
                    {
                        this.a_from = this.AsepriteDefinitions.meta.frameTags[i].from;
                        this.a_to = this.AsepriteDefinitions.meta.frameTags[i].to;
                        this.tag = this.AsepriteDefinitions.meta.frameTags[i].name;
                        this.direction = aDirection;
                        this.frameCurrent = 0;
                        this.frameCount = 0;
                        this.maxFrame = new Array<Float>();
                        this.checkedFirstframe = false;
                        break;
                    }
                    i++;
                }

                i = 0;
                while (i + this.a_from <= this.a_to)
                {
                    var i_frame:Int = this.a_from + i;
                    var last_frame:Int = i - 1;

                    if (i > 0) this.maxFrame.push((this.AsepriteDefinitions.frames[i_frame].duration) + this.maxFrame[last_frame]);
                    else this.maxFrame.push(this.AsepriteDefinitions.frames[i_frame].duration);

                    i++;
                }
            }

            this.frameCount += deltaTime * 1000;
            if (this.frameCount >= this.maxFrame[this.frameCurrent] || (this.frameCurrent == 0 && !checkedFirstframe))
            {
                if (this.a_to > (this.frameCurrent + this.a_from) && checkedFirstframe) this.frameCurrent++;
                else if (this.direction == AnimationDirection.LOOP)
                {
                    this.frameCurrent = 0;
                    this.frameCount = 0;
                    this.checkedFirstframe = false;
                }

                frame = (this.frameCurrent + this.a_from);
				this.body = new Rectangle(
					this.AsepriteDefinitions.frames[frame].frame.x,
					this.AsepriteDefinitions.frames[frame].frame.y,
					this.AsepriteDefinitions.frames[frame].frame.w,
					this.AsepriteDefinitions.frames[frame].frame.h
				);

                this.checkedFirstframe = true;
            }

	}
}

enum AnimationDirection{ FORWARD; LOOP; PING_PONG; }

typedef AnimationDirectionAseprite = {
	var frames:Array<AsepriteFrames>;
	var meta:AsepriteMeta;
}

typedef AsepriteFrames = {
	var filename:String;
	var rotated:Bool;
	var trimmed:Bool;
	var duration:Int;
	var frame:AsepriteFrame;
}

typedef AsepriteFrame = {
	var x:Int;
	var y:Int;
	var w:Int;
	var h:Int;
}

typedef AsepriteMeta = {
	var image:String;
	var scale:Int;
	var frameTags: Array<AsepriteFrameTags>;
}

typedef AsepriteFrameTags = {
	var name:String;
	var from:Int;
	var to:Int;
	var direction:String;
}