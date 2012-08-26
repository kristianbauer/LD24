package
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.tweens.misc.VarTween;
	
	public class BackgroundPiece extends Entity
	{
		[Embed(source='assets/background.png')] public const BACKGROUND:Class;
		
		public var tween:VarTween = new VarTween();
		public var targetScale:Number = 1;
		
		public function BackgroundPiece()
		{
			graphic = new Image(BACKGROUND);
			Image(graphic).color = 0x111111;
			width = Image(graphic).width;
			height = Image(graphic).height;
			layer = 3;
			addTween(tween);
		}
		
		public function changeScale():void {
			var ranScale:Number = Math.random();
			tween.tween(Image(graphic), "scale", ranScale, 0.75);
			targetScale = ranScale;
		}
		
		override public function update():void {
			if(Image(graphic).scale == targetScale) {
				changeScale();
			}
		}
	}
}