package;
import umbrellatoolkit.helpers.Timer;
import kha.Framebuffer;
	
class Game{
	public var FullScreem:Bool = true;
	private var DeltaTime:Timer;
	private var DeltaTimeUpdateData:Timer;

	public var gameManagment:GameManagment;

	public function new (){

		this.gameManagment = new GameManagment();

		this.DeltaTime = new Timer();
		this.DeltaTimeUpdateData = new Timer();
	}

	private var LoadScene:Bool = false;
	public function update(): Void {
		this.gameManagment.update(this.DeltaTime.delta);
		this.DeltaTime.update();
	}

	public function updateData():Void{
		this.gameManagment.updateData(this.DeltaTimeUpdateData.delta);
		this.DeltaTimeUpdateData.update();
	}

	public function render(framebuffer: Framebuffer): Void {
		this.gameManagment.render(framebuffer);
	}
}