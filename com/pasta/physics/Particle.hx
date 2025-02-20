package pasta.physics;
import pasta.Vect;

@:structInit
class Particle extends Vect{

	public var id(default, null):Int;
	static var next_id:Int = 0;
	public var force_acc:Vect;

	public var old_position:Vect;
	public var velocity:Vect;
	public var delta_velocity:Vect;
	public var acceleration:Vect;

	public var active:Bool = false;

	// If true, circle solver will ignore collision forces in b group.
	public var ephemeral:Bool = false;

	public var mass(default, set):Float;
	public var inverse_mass(default, null):Float;

	public var radius(default, set):Float;
	// private var _radius:Float;
	public var radius_squared(default, null):Float;

	// private var _radius_squared:Float;
	public var x_pos(get, set):Float;
	public var y_pos(get, set):Float;

	public var drag:Float;
	public var friction:Float;
	public var elasticity:Float = 1;


	public function new(x:Float, y:Float, mass:Float = 1, radius:Float = 1, drag:Float = 0, friction:Float = 0) {
		super(x, y);
		old_position = copy();
		this.velocity = new Vect();
		this.delta_velocity = new Vect();
		this.acceleration = new Vect();
		this.force_acc = new Vect();
		this.radius = radius;
		this.radius_squared = radius * radius;
		this.mass = mass;
		this.drag = drag;
		this.friction = friction;
		this.id = next_id++;
	}

	private function set_radius(v:Float):Float {
		radius = v;
		radius_squared = v * v;
		return v;
	}

	private function set_mass(v:Float):Float {
		mass = v;
		if (v != 0) {
			inverse_mass = 1 / v;
		} else {
			inverse_mass = 0;
			// trace("Zero mass set!");
		}
		return v;
	}

	public function accelerate(x:Float, y:Float):Void {
		acceleration.addXY(x, y);
	}

	// This function isn't inlined so it can be overridden to handle overspeed etc
	public function applyForces():Void {
		this.add(force_acc);
		force_acc.makeZero();
	}

	public inline function accelerateBy(v:Vect):Void {
		acceleration.add(v);
	}

	/**
	 * Moves this particle with no inertia effects(eg, it will not be integrated)
	 * @param	x
	 * @param	y
	 */
	public inline function moveTo(x:Float, y:Float):Void {
        old_position.subXY(x-this.x, y-this.y);
		this.set(x, y);
	}

	public inline function moveBy(x:Float, y:Float):Void {
		this.addXY(x, y);
        old_position.addXY(x, y);
	}

	public inline function shove(x:Float, y:Float):Void {
		this.addXY(x, y);
	}

	public inline function shoveBy(v:Vect):Void {
		this.add(v);
	}

	private function set_x_pos(to:Float):Float {
		moveTo(to, this.y);
		return to;
	}

	private function set_y_pos(to:Float):Float {
		moveTo(this.x, to);
		return to;
	}

	private function get_x_pos():Float {
		return this.x;
	}

	private function get_y_pos():Float {
		return this.y;
	}

	public function update(dt:Float):Void {
		applyForces();
		accelerate(-velocity.x * friction, -velocity.y * friction);
		accelerateBy(velocity.normal.mult(-velocity.length_squared * drag));
		var temp:Vect = this.copy();
        this.addXY(
            (this.x - old_position.x) + (acceleration.x / mass) * dt,
            (this.y - old_position.y) + (acceleration.y / mass) * dt
        );
		old_position.makeEqualTo(temp);

		temp.makeEqualTo(velocity); // this is the start of our velocity change code
		velocity.makeEqualTo(this); // this is an unrolling to avoid using Vect.Sub, which
		velocity.sub(old_position); // makes a new Vect every time it's used.
		delta_velocity.makeEqualTo(velocity);
		delta_velocity.sub(temp); // this is the change in velocity from the previous frame.
		acceleration.makeZero();
	}
	override public function toString():String{
		return '$id:[$x, $y]';
	}
}
