package;
import kha.audio1.Audio;
import kha.Sound;
import kha.audio1.AudioChannel;
import kha.Assets;

class SoundManagement {
    public var water_impact:Sound;
    public var water:AudioChannel;

    public var btn_press_sound:Sound;
    public var btn_press:AudioChannel;

    // player sounds
    public var jump_sound:Sound;
    public var jump:AudioChannel;

    public var touch_ground_sound:Sound;
    public var touch_ground:AudioChannel;

    public var sword1_sound:Sound;
    public var sword1:AudioChannel;

    public var sword2_sound:Sound;
    public var sword2:AudioChannel;

    public var death_sound:Sound;
    public var death:AudioChannel;

    public var take_damage_sound:Sound;
    public var take_damage:AudioChannel;
    // end player sounds

    public var collect_item_sound:Sound;
    public var collect_item:AudioChannel;

    public var open_gate_sound:Sound;
    public var open_gate:AudioChannel;

    public var death_alien_sound:Sound;
    public var death_alien:AudioChannel;

    public var deathWitch_sound:Sound;
    public var deathWitch:AudioChannel;

    public var sword_boss_sound:Sound;
    public var sword_boss:AudioChannel;

    // music
    public var music_sound:Sound;
    public var music:AudioChannel;

    public var music_boss_sound:Sound;
    public var music_boss:AudioChannel;

    public function new() {

        music_sound = Assets.sounds.Content_Sound_Music_Contemplation;
        this.music = Audio.play(music_sound, true);

        music_boss_sound = Assets.sounds.Content_Sound_Music_battleThemeA;
        this.music_boss = Audio.play(this.music_boss_sound, true);
        this.music_boss.stop();

        water_impact = Assets.sounds.Content_Sound_sfx_exp_long2;
        this.water =  Audio.play(water_impact);
        this.water.pause();

        btn_press_sound = Assets.sounds.Content_Sound_select_005;
        this.btn_press = Audio.play(this.btn_press_sound);
        this.btn_press.pause();


        // player
        jump_sound = Assets.sounds.Content_Sound_sfx_movement_jump;
        this.jump = Audio.play(this.jump_sound);
        this.jump.pause();

        touch_ground_sound = Assets.sounds.Content_Sound_sfx_thouch_ground;
        this.touch_ground = Audio.play(this.touch_ground_sound);
        this.touch_ground.pause();

        sword1_sound = Assets.sounds.Content_Sound_sfx_wpn_sword1;
        this.sword1 = Audio.play(this.sword1_sound);
        this.sword1.pause();

        sword2_sound = Assets.sounds.Content_Sound_sfx_wpn_sword2;
        this.sword2 = Audio.play(this.sword2_sound);
        this.sword2.pause();

        take_damage_sound = Assets.sounds.Content_Sound_sfx_damage_hit1;
        this.take_damage = Audio.play(this.take_damage_sound);
        this.take_damage.pause();

        death_sound = Assets.sounds.Content_Sound_sfx_death;
        this.death = Audio.play(this.death_sound);
        this.death.pause();
        // end player

        deathWitch_sound = Assets.sounds.Content_Sound_sfx_deathscream_human10;
        this.deathWitch = Audio.play(this.deathWitch_sound);
        this.deathWitch.pause();

        death_alien_sound = Assets.sounds.Content_Sound_sfx_deathscream_alien2;
        this.death_alien = Audio.play(this.death_alien_sound);
        this.death_alien.pause();

        // items and gate
        collect_item_sound = Assets.sounds.Content_Sound_sfx_collect_item;
        this.collect_item = Audio.play(this.collect_item_sound);
        this.collect_item.pause();

        open_gate_sound = Assets.sounds.Content_Sound_sfx_open_gate;
        this.open_gate = Audio.play(this.open_gate_sound);
        this.open_gate.pause();

        sword_boss_sound = Assets.sounds.Content_Sound_sfx_wpn_sword_boss;
        this.sword_boss = Audio.play(this.sword_boss_sound);
        this.sword_boss.pause();

    }

    public function play(tag:String):Void {
        if(tag == "press button")
            this.btn_press.play();
        else if(tag == "water")
            this.water.play();
        else if(tag == "jump")
            this.jump.play();
        else if(tag == "grounded")
            this.touch_ground.play();
        else if(tag == "sword1")
            this.sword1.play();
        else if(tag == "sword2")
            this.sword2.play();
        else if(tag == "take_damage")
            this.take_damage.play();
        else if(tag == "death")
            this.death.play();
        else if(tag == "deathWitch")
            this.deathWitch.play();
        else if(tag == "death_enemies")
            this.death_alien.play();
        else if(tag == "collect_item")
            this.collect_item.play();
        else if(tag == "open_gate")
            this.open_gate.play();
        else if(tag == "sword_boss")
            this.sword_boss.play();
    }

    public var isplaymusic:Bool = true;
    public function playMusicBoss(){
        isplaymusic = false;
        this.music.stop();
        this.music_boss = Audio.play(this.music_boss_sound, true);
        this.music_boss.volume = 0.5;
    }

    public function playMusic(){
        if(!isplaymusic){
            this.music_boss.stop();
            this.music = Audio.play(this.music_sound, true);
            isplaymusic = true;
        }
       
    }

    public function Update(){
    }
}