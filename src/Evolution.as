package
{
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	
	public class Evolution extends Engine
	{
		public function Evolution()
		{
			super(600, 600, 60, false);
			FP.world = new MainMenu();
			FP.volume = 0.1;
			FP.screen.color = 0x000000;
		}
		
		override public function init():void {
			trace("Evolution started");
		}
	}
}