package;
import umbrellatoolkit.helpers.Timer;
import kha.Framebuffer;
	
	class Game{
	public var FullScreem:Bool = true;
	private var DeltaTime:Timer;
	private var DeltaTimeUpdateData:Timer;

	private var GameManagment:GameManagment;

	public function new (){

		this.GameManagment = new GameManagment();

		this.DeltaTime = new Timer();
		this.DeltaTimeUpdateData = new Timer();
	}

	private var LoadScene:Bool = false;
	public function update(): Void {
		this.GameManagment.update(this.DeltaTime.delta);
		this.DeltaTime.update();
	}

	public function updateData():Void{
		this.GameManagment.updateData(this.DeltaTime.delta);
		this.DeltaTimeUpdateData.update();
	}

	public function render(framebuffer: Framebuffer): Void {
		this.GameManagment.render(framebuffer);
	}
}