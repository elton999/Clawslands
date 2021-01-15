package;
import kha.audio1.Audio;
import kha.Sound;
import kha.audio1.AudioChannel;
import kha.Assets;

class SoundManagement {
    public var walter_impact:Sound;
    public var walter:AudioChannel;
    public function new() {
        walter_impact = Assets.sounds.Content_Sound_1;
        this.walter =  Audio.play(walter_impact);
        this.walter.pause();
    }

    public function play(tag:String):Void {
        this.walter.play();
    }

    public function Update(){
    }
}