package
{
	import net.flashpunk.FP;
	import flash.geom.Point;
	import net.flashpunk.Sfx;
	
	public class Blue extends AI
	{
		[Embed(source='assets/shootBlue.mp3')] private const SHOOT:Class;
		
		public function Blue()
		{
			color = 0x0000FF;
			shootSound = new Sfx(SHOOT);
			super();
			startPosition = new Point(FP.width - width, FP.height - height);
		}
		
		override public function added():void {
			super.added();
			base.y = FP.height - base.height;
			base.x = FP.width - base.width;
		}
		
		override public function collideWithBase(c:Character):void {
			if(Math.abs(c.right - base.left) < Math.abs(base.top - c.bottom)) {
				c.x = base.left - c.width;
			}
			else {
				c.y = base.top - c.height;
			}
		}
	}
}