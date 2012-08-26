package
{
	import flash.geom.Point;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.tweens.misc.ColorTween;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	public class Character extends Entity
	{
		[Embed(source='assets/character.png')] public const CHARACTER:Class;
		[Embed(source='assets/die.mp3')] private const DIE:Class;
		[Embed(source='assets/evolve.mp3')] private const EVOLVE:Class;
		[Embed(source='assets/hit1.mp3')] private const HIT1:Class;
		[Embed(source='assets/hit2.mp3')] private const HIT2:Class;
		[Embed(source='assets/hit3.mp3')] private const HIT3:Class;
		[Embed(source='assets/hit4.mp3')] private const HIT4:Class;
		[Embed(source='assets/particle.png')] public const PARTICLE:Class;
		
		public var speed:Number = 5;
		public var bulletSpeed:Number = 10;
		public var bulletAngleSpeed:Number = bulletSpeed * 0.70710678118;
		public var bulletDamage:Number = 1;
		public var color:uint;
		public var curEvolve:Number = 0;
		public var maxEvolve:Number = 20;
		public var maxHealth:Number = 10;
		public var curHealth:Number = maxHealth;
		public var shootColor:uint;
		public var shootTime:Number = 7;
		public var shootTimer:Number = shootTime;
		public var base:HomeBase;
		public var startPosition:Point = new Point(0, 0);
		public var evolveStage:Number = 0;
		public var inBase:Boolean = false;
		public var winner:Boolean = false;
		public var tween:ColorTween = new ColorTween();
		public var currentColor:Number = -1;
		public var colorArray:Array = new Array(uint(0xFF0000), uint(0x00FF00), uint(0x0000FF), uint(0xFF00FF), uint(0xFFFF00), uint(0x00FFFF));
		public var dieSound:Sfx = new Sfx(DIE);
		public var evolveSound:Sfx = new Sfx(EVOLVE);
		public var hit1:Sfx = new Sfx(HIT1);
		public var hit2:Sfx = new Sfx(HIT2);
		public var hit3:Sfx = new Sfx(HIT3);
		public var hit4:Sfx = new Sfx(HIT4);
		public var shootSound:Sfx;
		public var emitter:Emitter;
		
		public function Character()
		{	
			// set up graphic
			graphic = new Image(CHARACTER);
			Image(graphic).color = color;
			addTween(tween);
			
			// set up hitbox
			width = Image(graphic).width;
			height = Image(graphic).height;
			type = "character";
			
			emitter = new Emitter(PARTICLE, 2, 2);
			emitter.newType("trail", [0]);
			emitter.setAlpha("trail", 1, 0);
			emitter.setMotion("trail", 0, 0, 0.5, 10, 5, 0.25);
			emitter.setColor("trail", color, 0x000000);
			emitter.relative = false;
			
			emitter.newType("hit", [0]);
			emitter.setAlpha("hit", 1, 1);
			emitter.setMotion("hit", 0, 0, 1, 360, 100, 0.5);
			emitter.setColor("hit", color, color);
			
			emitter.newType("die", [0]);
			emitter.setAlpha("die", 1, 1);
			emitter.setColor("die", 0xFFFF00, 0xFFFF00);
			emitter.setMotion("die", 0, 0, 2, 360, 50, 0);
			this.addGraphic(emitter);
		}
		
		public function getGraphic(index:Number):Graphic {
			return Graphiclist(graphic).children[index];
		}
		
		public function getImage(index:Number):Image {
			return Image(getGraphic(index));
		}
		
		override public function added():void {
			base = new HomeBase();
			base.setColor(color);
			base.owner = this;
			FP.world.add(base);
			reset();
		}
		
		override public function update():void {
			checkConstraints();
			checkBulletCollisions();
			checkBaseCollisions();
			
			if(shootTimer > 0) {
				shootTimer -= 1;
			}
			if(winner) {
				getImage(0).color = tween.color;
				emitter.setColor("trail", tween.color, 0x000000);
				emitter.setColor("hit", tween.color, tween.color);
				if(getImage(0).color == colorArray[currentColor]) {
					changeColor();
				}
				
				if(Input.check(Key.SPACE) && GameWorld(FP.world).canRestart) {
					GameWorld(FP.world).restart();
				}
			}
			emitter.emit("trail", centerX, centerY);
		}
		
		public function newGame():void {
			speed = 5;
			bulletSpeed = 10;
			bulletAngleSpeed = bulletSpeed * 0.70710678118;
			bulletDamage = 1;
			curEvolve = 0;
			maxEvolve = 20;
			maxHealth = 50;
			curHealth = maxHealth;
			shootTime = 7;
			shootTimer = shootTime;
			evolveStage = 0;
			winner = false;
			getImage(0).color = color;
			x = startPosition.x;
			y = startPosition.y;
			getImage(0).scale = 1;
			width = getImage(0).width * getImage(0).scale;
			height = getImage(0).height * getImage(0).scale;
			emitter.setColor("trail", color, 0x000000);
			emitter.setColor("hit", color, color);
		}
		
		public function shoot(bulletSpeed:Point):void {
			if(shootTimer <= 0) {
				var bullet:Bullet = new Bullet();
				Image(bullet.graphic).color = color;
				bullet.x = centerX - bullet.halfWidth;
				bullet.y = centerY - bullet.halfHeight;
				bullet.speed = bulletSpeed;
				bullet.bulletOwner = this;
				bullet.damage = bulletDamage;
				FP.world.add(bullet);
				shootSound.play(0.15);
				if(inBase) {
					shootTimer = 2 * shootTime;
				}
				else {
					shootTimer = shootTime;
				}
			}
		}
		
		public function reset():void {
			curHealth = maxHealth;
			x = startPosition.x;
			y = startPosition.y;
		}
		
		public function die():void {
			for(var i:Number=0;i<50;i++) {
				emitter.emit("die", centerX, centerY);
			}
			dieSound.play();
			incrementEvolve(-3 * evolveStage);
			reset();
		}
		
		public function collideWithBase(c:Character):void {
			
		}
		
		public function incrementEvolve(n:Number):void {
			curEvolve += n;
			curEvolve = Math.min(maxEvolve, curEvolve);
			curEvolve = Math.max(0, curEvolve);
			
			if(curEvolve == maxEvolve) {
				evolve();
			}
		}
		
		public function evolve():void {
			if(evolveStage < 5 && !GameWorld(FP.world).gameWon) {
				evolveSound.play();
				maxHealth += 20;
				maxEvolve += 40;
				curEvolve = 0;
				evolveStage++;
				getImage(0).scale += 0.75;
				width = getImage(0).width * getImage(0).scale;
				height = getImage(0).height * getImage(0).scale;
				
				if(evolveStage == 1) {
					speed += 2;
				}
				else if(evolveStage == 2) {
					shootTime -= 2;
				}
				else if(evolveStage == 3) {
					bulletSpeed += 5;
					bulletAngleSpeed = bulletSpeed * 0.70710678118;
				}
				else if(evolveStage == 4) {
					bulletDamage += 10;
				}
				else if(evolveStage == 5) {
					GameWorld(FP.world).gameWon = true;
					winner = true;
					changeColor();
				}
			}
		}
		
		public function changeColor():void {
			currentColor++;
			if(currentColor >= colorArray.length) {
				currentColor = 0;
			}
			tween.tween(0.5, getImage(0).color, colorArray[currentColor]);
		}
		
		public function checkBulletCollisions():void {
			var bullets:Array = [];
			collideInto("bullet", x, y, bullets);
			for each(var b:Bullet in bullets) {
				if(b != null && b.bulletOwner != this) {
					if(!GameWorld(FP.world).gameWon)
					{						
						b.bulletOwner.incrementEvolve((evolveStage+1) * 1);
						curHealth -= b.damage;
						// check to see if character has died
						if(curHealth <= 0) {
							b.bulletOwner.incrementEvolve((evolveStage+1) * 3);
							die();
						}
					}
					var ran:Number = Math.floor(Math.random() * 4);
					if(ran == 0) {
						hit1.play(0.5);
					}
					else if(ran == 1) {
						hit2.play(0.5);
					}
					else if(ran == 2) {
						hit3.play(0.5);
					}
					else {
						hit4.play(0.5);
					}
					
					for(var i:Number=0;i<25;i++) {
						emitter.emit("hit", b.centerX, b.centerY);
					}
					b.destroy();
				}
			}
		}
		
		public function checkBaseCollisions():void {
			var b:HomeBase = null;
			inBase = false;
			do {
				b = collide("homebase", x, y) as HomeBase;
				if(b != null) {
					if(b.owner != this) {
						b.owner.collideWithBase(this);
					}
					else {
						//TODO: heal?
						inBase = true;
						b = null;
					}
				}
			} while(b != null);
			if(b != null && b.owner != this) {
				if(right > b.left) {
					x = b.x - width;
				}
				if(bottom > b.top) {
					y = b.y - height;
				}
			}
		}
		
		public function checkConstraints():void {
			if(x < 0) {
				x = 0;
			}
			else if(x > FP.width - width) {
				x = FP.width - width;
			}
			if(y < 0) {
				y = 0;
			}
			else if(y > FP.height - height) {
				y = FP.height - height;
			}
		}
	}
}