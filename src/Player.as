package
{
	import flash.geom.Point;
	
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.Sfx;
	
	public class Player extends Character
	{
		[Embed(source='assets/shootGreen.mp3')] private const SHOOT:Class;
		
		public function Player()
		{
			color = 0x00FF00;
			shootSound = new Sfx(SHOOT);
			super();
			startPosition = new Point(0, FP.height - height);
		}
		
		override public function added():void {
			super.added();
			base.y = FP.height - base.height;
		}
		
		override public function collideWithBase(c:Character):void {
			if(Math.abs(c.left - base.right) < Math.abs(base.top - c.bottom)) {
				c.x = base.right;
			}
			else {
				c.y = base.top - c.height;
			}
		}
		
		override public function update():void {
			// movement
			if(Input.check(Key.A)) {
				x -= speed;
			}
			else if(Input.check(Key.D)) {
				x += speed;
			}
			if(Input.check(Key.W)) {
				y -= speed;
			}
			else if(Input.check(Key.S)) {
				y += speed;
			}
			
			// shooting
			if(Input.check(Key.LEFT)) {
				if(Input.check(Key.DOWN)) {
					shoot(new Point(-bulletAngleSpeed, bulletAngleSpeed));
				}
				else if(Input.check(Key.UP)) {
					shoot(new Point(-bulletAngleSpeed, -bulletAngleSpeed));
				}
				else {
					shoot(new Point(-bulletSpeed, 0));
				}
			}
			else if(Input.check(Key.RIGHT)) {
				if(Input.check(Key.DOWN)) {
					shoot(new Point(bulletAngleSpeed, bulletAngleSpeed));
				}
				else if(Input.check(Key.UP)) {
					shoot(new Point(bulletAngleSpeed, -bulletAngleSpeed));
				}
				else {
					shoot(new Point(bulletSpeed, 0));
				}
			}
			else if(Input.check(Key.UP)) {
				if(Input.check(Key.LEFT)) {
					shoot(new Point(-bulletAngleSpeed, -bulletAngleSpeed));
				}
				else if(Input.check(Key.RIGHT)) {
					shoot(new Point(bulletAngleSpeed, -bulletAngleSpeed));
				}
				else {
					shoot(new Point(0, -bulletSpeed));
				}
			}
			else if(Input.check(Key.DOWN)) {
				if(Input.check(Key.LEFT)) {
					shoot(new Point(-bulletAngleSpeed, bulletAngleSpeed));
				}
				else if(Input.check(Key.RIGHT)) {
					shoot(new Point(bulletAngleSpeed, bulletAngleSpeed));
				}
				else {
					shoot(new Point(0, bulletSpeed));
				}
			}
			
			super.update();
		}
		
		override public function incrementEvolve(n:Number):void {
			super.incrementEvolve(n);
		}
		
		override public function evolve():void {
			super.evolve();
			if(winner) {
				GameWorld(FP.world).won();
			}
		}
	}
}