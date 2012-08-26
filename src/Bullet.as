package
{
	import flash.geom.Point;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	public class Bullet extends Entity
	{
		[Embed(source='assets/bullet.png')] public const BULLET:Class;
		
		public var bulletOwner:Character;
		public var speed:Point = new Point(0, 0);
		public var damage:Number = 5;
		
		public function Bullet()
		{
			graphic = new Image(BULLET);
			width = Image(graphic).width;
			height = Image(graphic).height;
			type = "bullet";
		}
		
		public function destroy():void {
			FP.world.remove(this);
		}
		
		override public function update():void {
			x += speed.x;
			y += speed.y;
			
			// check for off screen
			if(x < -width) {
				destroy();
			}
			else if(x > FP.width) {
				destroy();
			}
			if(y < -height) {
				destroy();
			}
			else if(y > FP.height) {
				destroy();
			}
		}
	}
}