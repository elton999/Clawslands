package;
import kha.WindowOptions;
import kha.Window;
import kha.WindowMode;
import kha.Assets;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;

class Main {
	public static function main() {
		var scale:Float = 2.0;
		var WindowSettins = new WindowOptions();
		WindowSettins.mode = Windowed;
		System.start({title: "Clawslands", width: Std.int(1920 / scale), height: Std.int(1080 / scale), window: WindowSettins}, function (_) {
		//System.start({title: "Clawslands", width: Std.int(800), height: Std.int(480), window: WindowSettins}, function (_) {
			var Game:Game = new Game();
			Scheduler.addTimeTaskToGroup(1,function () { Game.update(); }, 0, 1 / 60);
			Scheduler.addTimeTaskToGroup(0, function () { Game.updateData(); }, 0, 1 / 30);
			System.notifyOnFrames(function (frames) { Game.render(frames[0]); });
		});
	}
}
