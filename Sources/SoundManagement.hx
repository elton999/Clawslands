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

    public var jump_sound:Sound;
    public var jump:AudioChannel;

    public var touch_ground_sound:Sound;
    public var touch_ground:AudioChannel;

    public var sword1_sound:Sound;
    public var sword1:AudioChannel;

    public var deathWitch_sound:Sound;
    public var deathWitch:AudioChannel;

    public function new() {
        walter_impact = Assets.sounds.Content_Sound_sfx_exp_long2;
        this.walter =  Audio.play(walter_impact);
        this.walter.pause();

        btn_press_sound = Assets.sounds.Content_Sound_select_005;
        this.btn_press = Audio.play(this.btn_press_sound);
        this.btn_press.pause();

        jump_sound = Assets.sounds.Content_Sound_sfx_movement_jump;
        this.jump = Audio.play(this.jump_sound);
        this.jump.pause();

        touch_ground_sound = Assets.sounds.Content_Sound_sfx_thouch_ground;
        this.touch_ground = Audio.play(this.touch_ground_sound);
        this.touch_ground.pause();

        sword1_sound = Assets.sounds.Content_Sound_sfx_wpn_sword1;
        this.sword1 = Audio.play(this.sword1_sound);
        this.sword1.pause();

        deathWitch_sound = Assets.sounds.Content_Sound_sfx_deathscream_human10;
        this.deathWitch = Audio.play(this.deathWitch_sound);
        this.deathWitch.pause();
    }

    public function play(tag:String):Void {
        if(tag == "press button")
            this.btn_press.play();
        else if(tag == "walter")
            this.walter.play();
        else if(tag == "jump")
            this.jump.play();
        else if(tag == "grounded")
            this.touch_ground.play();
        else if(tag == "sword1")
            this.sword1.play();
        else if(tag == "deathWitch")
            this.deathWitch.play();
    }

    public function Update(){
    }
}