package
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Text;
	
	public class GameWorld extends World
	{
		// player character
		public var player:Player;
		// AI characters
		public var red:Red;
		public var blue:Blue;
		public var purple:Purple;
		// whether the game has been won or not
		public var gameWon:Boolean = false;
		// win and lose text for the end of the game
		public var winText:Entity;
		public var loseText:Entity;
		// restarting the game variables
		public var restartText:Entity;
		public var restartTimer:Number = 120;
		public var canRestart:Boolean = false;
		// pulsating background pieces
		public var background:Array = new Array();
		
		public function GameWorld()
		{
			reset();
			
			for(var i:Number=0;i<12;i++) {
				for(var j:Number=0;j<12;j++) {
					var b:BackgroundPiece = new BackgroundPiece();
					b.x = i * 50;
					b.y = j * 50;
					background.push(b);
					add(b);
				}
			}
			
			winText = new Entity();
			winText.graphic = new Text("You evolved the fastest.\nCongratulations on wiping out the other species!");
			Text(winText.graphic).align = "center";
			winText.width = Text(winText.graphic).width;
			winText.height = Text(winText.graphic).height;
			winText.x = FP.width * 0.5 - winText.width * 0.5;
			winText.y = FP.height * 0.5 - winText.height * 0.5;
			
			loseText = new Entity();
			loseText.graphic = new Text("You failed to evolve fast enough.\nYour species has been wiped out of existence.");
			Text(loseText.graphic).align = "center";
			loseText.width = Text(loseText.graphic).width;
			loseText.height = Text(loseText.graphic).height;
			loseText.x = FP.width * 0.5 - loseText.width * 0.5;
			loseText.y = FP.height * 0.5 - loseText.height * 0.5;
			
			restartText = new Entity();
			restartText.graphic = new Text("Press SPACE to try again.");
			Text(restartText.graphic).align = "center";
			restartText.width = Text(restartText.graphic).width;
			restartText.height = Text(restartText.graphic).height;
			restartText.x = FP.width * 0.5 - restartText.width * 0.5;
			restartText.y = FP.height * 0.75 - restartText.height * 0.5;
		}
		
		override public function update():void {
			super.update();
			if(gameWon && restartTimer > 0) {
				restartTimer -= 1;
				if(restartTimer <= 0) {
					canRestart = true;
					add(restartText);
				}
			}
		}
		
		public function reset():void {
			player = new Player();
			red = new Red();
			blue = new Blue();
			purple = new Purple();
			add(player);
			add(red);
			add(blue);
			add(purple);
		}
		
		public function restart():void {
			restartTimer = 120;
			gameWon = false;
			canRestart = false;
			remove(winText);
			remove(loseText);
			remove(restartText);
			player.newGame();
			red.newGame();
			blue.newGame();
			purple.newGame();
		}
		
		public function won():void {
			add(winText);
		}
		
		public function lost():void {
			add(loseText);
		}
	}
}