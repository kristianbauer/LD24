package
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	
	public class Bar extends Entity
	{
		[Embed(source='assets/homebaseBar.png')] public const BAR:Class;
		
		public function Bar()
		{
			// set up graphic
			graphic = new Image(BAR);
			layer = 1;
			
			// set up hitbox
			width = Image(graphic).width;
			height = Image(graphic).height;
		}
		
		public function setColor(newColor:uint):void {
			Image(graphic).color = newColor;
		}
	}
}