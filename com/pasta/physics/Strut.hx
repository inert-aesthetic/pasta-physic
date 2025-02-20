package pasta.physics;

class Strut{
	public var id(default, null):Int;
	static var next_id:Int = 0;
    public var a:Particle;
    public var b:Particle;
    public var segment:Segment;
	public var mass(get, null):Float;

    public function new(a:Particle, b:Particle){
        this.a = a;
        this.b = b;
        this.segment = new Segment(a, b);
		this.id = next_id++;
    }

    /**
	 * The inverse of the effective mass at a balance between the two points 
	 * @param	balance 0 = mass at a, 1 = mass at b
	 * @return  Inverse mass in kg
	 */
	public function getInverseEffectiveMass(balance:Float):Float{
		var a_mass:Float = a.mass;
		var b_mass:Float = b.mass;
		return 1 / ((a_mass + b_mass) - Math.abs(balance - (1 / (1 + a_mass / b_mass))) * (a_mass + b_mass));
	}

	public function getEffectiveMass(balance:Float):Float{
		var a_mass:Float = a.mass;
		var b_mass:Float = b.mass;
		return ((a_mass + b_mass) - Math.abs(balance - (1 / (1 + a_mass / b_mass))) * (a_mass + b_mass));
	}

	function get_mass():Float{
		return a.mass+b.mass;
	}

    public function shove(d:Vect, balance:Float = 0.5):Void {
		a.x += d.x * (1 - balance);
		a.y += d.y * (1 - balance);
		b.x += d.x * (balance);
		b.y += d.y * (balance);
	}
}