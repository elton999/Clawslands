package;
import kha.audio1.Audio;
import kha.Sound;
import kha.audio1.AudioChannel;
import kha.Assets;

class SoundManagement {
    public var walter_impact:Sound;
    public var walter:AudioChannel;

    public var btn_press_sound:Sound;
    public var btn_press:AudioChannel;

    public function new() {
        walter_impact = Assets.sounds.Content_Sound_sfx_exp_long2;
        this.walter =  Audio.play(walter_impact);
        this.walter.pause();

        btn_press_sound = Assets.sounds.Content_Sound_select_005;
        this.btn_press = Audio.play(this.btn_press_sound);
        this.btn_press.pause();
    }

    public function play(tag:String):Void {
        if(tag == "press button")
            this.btn_press.play();
        else if(tag == "walter")
            this.walter.play();
    }

    public function Update(){
    }
}