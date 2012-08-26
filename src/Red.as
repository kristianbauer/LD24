package
{
	import net.flashpunk.FP;
	import flash.geom.Point;
	import net.flashpunk.Sfx;
	
	public class Red extends AI
	{
		[Embed(source='assets/shootRed.mp3')] private const SHOOT:Class;
		
		public function Red()
		{
			color = 0xFF0000;
			shootSound = new Sfx(SHOOT);
			super();
		}
		
		override public function collideWithBase(c:Character):void {
			if(Math.abs(c.left - base.right) < Math.abs(base.bottom - c.top)) {
				c.x = base.right;
			}
			else {
				c.y = base.bottom;
			}
		}
	}
}