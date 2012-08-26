package
{
	import flash.geom.Point;
	
	import net.flashpunk.FP;
	
	public class AI extends Character
	{
		public const AI_STATE_CHASE_OPPONENT:Number = 0;
		public const AI_STATE_GOTO_SPOT:Number = 1;
		public const AI_STATE_RETURN_TO_BASE:Number = 2;
		
		public var time:Number = 1;
		public var state:Number = 0;
		public var goX:Number = 0;
		public var goY:Number = 0;
		public var aiSpeed:Point = new Point(30, 60);
		
		public function AI()
		{
			super();
		}
		
		override public function update():void {
			super.update();
			
			if(time > 0) {
				time -= 1;
				if(time <= 0) {
					doSomething();
				}
			}
			
			moveTowards(goX, goY, speed);
			shootAtOpponent(getOpponentToChase());
		}
		
		public function doSomething():void {
			var ran:Number = Math.floor(Math.random() * 3);
			if(ran == AI_STATE_CHASE_OPPONENT) {
				var c:Character = getOpponentToChase();
				goX = c.x;
				goY = c.y;
			}
			else if(ran == AI_STATE_GOTO_SPOT) {
				goX = Math.floor(Math.random() * FP.width);
				goY = Math.floor(Math.random() * FP.height);
			}
			else if(ran == AI_STATE_RETURN_TO_BASE) {
				goX = startPosition.x;
				goY = startPosition.y;
			}
			time = Math.floor(Math.random() * (aiSpeed.y - aiSpeed.x)) + aiSpeed.x;
		}
		
		public function getOpponentToChase():Character {
			
			var opponents:Array = [];
			FP.world.getType("character", opponents);
			
			// determine whether to chase the weakest, closest, most evolved, or random
			var ran:Number = Math.floor(Math.random() * 4);
			var c:Character;
			
			if(ran == 0) {
				var closestDistance:Number = 1000;
				var closestOpponent:Character;
				for each(c in opponents) {
					var newDistance:Number = distanceFrom(c);
					if(newDistance < closestDistance && this != c) {
						closestDistance = newDistance;
						closestOpponent = c;
					}
				}
				return closestOpponent;
			}
			else if(ran == 1) {
				var leastHealth:Number = 10000;
				var weakestOpponent:Character;
				for each(c in opponents) {
					if(c.curHealth < leastHealth && this != c) {
						leastHealth = c.curHealth;
						weakestOpponent = c;
					}
				}
				return weakestOpponent;
			}
			else if(ran == 2) {
				var mostEvolve:Number = -1;
				var mostEvolvedOpponent:Character;
				for each(c in opponents) {
					if(c.evolveStage > mostEvolve && this != c) {
						mostEvolve = c.evolveStage;
						mostEvolvedOpponent = c;
					}
				}
				return mostEvolvedOpponent;
			}
			else {
				var opponent:Character;
				while(true) {
					opponent = opponents[Math.floor(Math.random() * opponents.length)];
					if(opponent != this) {
						break;
					}
				}
				return opponent;
			}
		}
		
		public function shootAtOpponent(c:Character):void {
			// shoot at weakest opponent
			var xDifference:Number = Math.abs(x - c.x);
			var yDifference:Number = Math.abs(y - c.y);
			if(xDifference > yDifference) {
				if(x < c.x) {
					if(y < c.y && c.y - y > 50) {
						shoot(new Point(bulletAngleSpeed, bulletAngleSpeed));
					}
					else if(y < c.y && y - c.y > 50) {
						shoot(new Point(bulletAngleSpeed, -bulletAngleSpeed));
					}
					else {
						shoot(new Point(bulletSpeed, 0));
					}
				}
				else if(x > c.x) {
					if(y < c.y && c.y - y > 50) {
						shoot(new Point(-bulletAngleSpeed, bulletAngleSpeed));
					}
					else if(y < c.y && y - c.y > 50) {
						shoot(new Point(-bulletAngleSpeed, -bulletAngleSpeed));
					}
					else {
						shoot(new Point(-bulletSpeed, 0));
					}
				}
			}
			else {
				if(y < c.y) {
					if(x < c.x && c.x - x > 50) {
						shoot(new Point(bulletAngleSpeed, bulletAngleSpeed));
					}
					else if(x > c.x && x - c.x > 50) {
						shoot(new Point(-bulletAngleSpeed, bulletAngleSpeed));
					}
					else {
						shoot(new Point(0, bulletSpeed));
					}
				}
				else if(y > c.y) {
					if(x < c.x && c.x - x > 50) {
						shoot(new Point(bulletAngleSpeed, -bulletAngleSpeed));
					}
					else if(x > c.x && x - c.x > 50) {
						shoot(new Point(-bulletAngleSpeed, -bulletAngleSpeed));
					}
					else {
						shoot(new Point(0, -bulletSpeed));
					}
				}
			}
		}
		
		override public function evolve():void {
			super.evolve();
			if(winner) {
				GameWorld(FP.world).lost();
			}
		}
	}
}