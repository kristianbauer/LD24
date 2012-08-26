package
{
	import flash.geom.Point;
	import net.flashpunk.Sfx;
	import net.flashpunk.FP;
	
	public class Purple extends AI
	{
		[Embed(source='assets/shootPurple.mp3')] private const SHOOT:Class;
		
		public function Purple()
		{
			color = 0xFF00FF;
			shootSound = new Sfx(SHOOT);
			super();
			startPosition = new Point(FP.width - width, 0);
		}
		
		override public function added():void {
			super.added();
			base.x = FP.width - base.width;
		}
		
		override public function collideWithBase(c:Character):void {
			if(Math.abs(c.right - base.left) < Math.abs(base.bottom - c.top)) {
				c.x = base.left - c.width;
			}
			else {
				c.y = base.bottom;
			}
		}
	}
}