package
{
	import net.flashpunk.Entity;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.tweens.misc.ColorTween;
	import net.flashpunk.graphics.Image;
	
	public class MainMenu extends World
	{
		public var header:Entity;
		public var about:Entity;
		public var playButton:Entity;
		public var tween:ColorTween = new ColorTween();
		public var colorArray:Array = new Array(uint(0xFF0000), uint(0x00FF00), uint(0x0000FF), uint(0xFF00FF));
		public var currentColor:Number = -1;
		
		public var aboutTimer:Number = 60;
		public var playTimer:Number = 120;
		public var changedColor:Boolean = false;
		
		public function MainMenu()
		{
			header = new Entity();
			header.graphic = new Text("EVOLVES!");
			Text(header.graphic).align = "center";
			Text(header.graphic).size = 50;
			header.width = Text(header.graphic).width;
			header.height = Text(header.graphic).height;
			header.x = FP.width * 0.5 - header.width * 0.5;
			header.y = FP.height * 0.25 - header.height * 0.5;
			add(header);
			addTween(tween);
			
			about = new Entity();
			about.graphic = new Text("Created by Kristian Bauer for Ludum Dare 24.");
			Text(about.graphic).align = "center";
			about.width = Text(about.graphic).width;
			about.height = Text(about.graphic).height;
			about.x = FP.width * 0.5 - about.width * 0.5;
			about.y = FP.height * 0.5 - about.height * 0.5;
			
			playButton = new Entity();
			playButton.graphic = new Text("Press SPACE to play");
			Text(playButton.graphic).align = "center";
			playButton.width = Text(playButton.graphic).width;
			playButton.height = Text(playButton.graphic).height;
			playButton.x = FP.width * 0.5 - playButton.width * 0.5;
			playButton.y = FP.height * 0.75 - playButton.height * 0.5;
		}
		
		override public function update():void {
			if(aboutTimer > 0) {
				aboutTimer--;
				if(aboutTimer <= 0) {
					add(about);
					changeColor();
				}
			}
			if(playTimer > 0) {
				playTimer--;
				if(playTimer <= 0) {
					add(playButton);
				}
			}
			if(playTimer <= 0 && Input.check(Key.SPACE)) {
				FP.world = new GameWorld();
			}
			
			if(currentColor >= 0) {
				Text(header.graphic).color = tween.color;
				if(Text(header.graphic).color == colorArray[currentColor]) {
					changeColor();
				}
			}
		}
		
		public function changeColor():void {
			currentColor++;
			if(currentColor >= colorArray.length) {
				currentColor = 0;
			}
			tween.tween(1, Text(header.graphic).color, colorArray[currentColor]);
		}
	}
}