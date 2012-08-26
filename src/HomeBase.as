package
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	
	public class HomeBase extends Entity
	{
		[Embed(source='assets/homebase.png')] public const HOMEBASE:Class;
		
		public var owner:Character;
		public var healthBar:Bar;
		public var evolveBar:Bar;
		
		public function HomeBase()
		{
			// set up graphic
			graphic = new Image(HOMEBASE);
			layer = 2;
			type = "homebase";
			
			// set up hitbox
			width = Image(graphic).width;
			height = Image(graphic).height;
		}
		
		public function setColor(newColor:uint):void {
			Image(graphic).color = newColor;
		}
		
		override public function added():void {
			healthBar = new Bar();
			healthBar.setColor(Image(graphic).color & 0x666666);
			healthBar.x = x + 3;
			healthBar.y = y + 34;
			FP.world.add(healthBar);
			
			evolveBar = new Bar();
			evolveBar.setColor(0x00FFFF);
			evolveBar.x = x + 3;
			evolveBar.y = y + 3;
			FP.world.add(evolveBar);
		}
		
		override public function update():void {
			var bullets:Array = [];
			this.collideInto("bullet", x, y, bullets);
			for each(var b:Bullet in bullets) {
				if(b != null && b.bulletOwner != owner) {
					b.destroy();
				}
			}
			
			// update health bar with owner's health
			Image(healthBar.graphic).scaleX = owner.curHealth / owner.maxHealth;
			// update evolve bar with owner's evolve
			Image(evolveBar.graphic).scaleX = owner.curEvolve / owner.maxEvolve;
		}
	}
}