package pasta;

class Segment{
    public var a:Vect;
    public var b:Vect;

    public var angle(get, never):Float;
	public var angle_deg(get, never):Float;
	public var angle_rad(get, never):Float;
	public var normal(get, never):Vect;
	public var rightNormal(get, never):Vect;
	public var leftNormal(get, never):Vect;	
	public var vector(get, never):Vect;
	public var length(get, never):Float;

    public function new (a:Vect = null, b:Vect = null){
        this.a = a==null?new Vect():a;
        this.b = b==null?new Vect():b;
    }

    /**
	 * Angle in radians from a to b. 
	 */
	private inline function get_angle():Float {
		return Math.atan2(b.y - a.y, b.x - a.x);
	}
	
	/**
	 * Angle in radians from a to b. 
	 */
	private inline function get_angle_rad():Float {
		return Math.atan2(b.y - a.y, b.x - a.x);
	}
		
	
	/**
	 * Angle in degrees from a to b. 
	 */
	private inline function get_angle_deg():Float{
		return Util.to_degrees(Math.atan2(b.y - a.y, b.x - a.x));
	}
	
	/**
	 * direction vector from a to b
	 */
	private inline function get_normal():Vect {
		return Vect.Sub(b, a).normal;
	}
	
	private inline function get_vector():Vect{
		return new Vect(b.x - a.x, b.y - a.y);
	}

	private inline function get_length():Float{
		return a.distanceTo(b);
	}
	
	public function isPointOnSeg(p:Vect):Bool {
		var u:Float = ((p.x - a.x) * (b.x-a.x) + (p.y - a.y) * (b.y-a.y)) / a.rawDistanceTo(b);
		if (u > Util.FLOAT_MIN && u < 1) {
			return true;
		}
		return false;
	}
	
	public function distanceToPoint(p:Vect):Float {			
		var u:Float = ((p.x - a.x) * (b.x-a.x) + (p.y - a.y) * (b.y-a.y)) / a.rawDistanceTo(b);
		
		var ix:Float = a.x + u * (b.x-a.x);
		var iy:Float = a.y + u * (b.y-a.y);
		
		var ixd:Float = ix-p.x;
		var iyd:Float = iy-p.y;
	
		return Math.sqrt(ixd*ixd+iyd*iyd);
	}

	public inline function getPointByBalance(balance:Float):Vect {
		return new Vect(a.x + (b.x - a.x) * balance, a.y + (b.y - a.y) * balance);
	}

	public inline function getBalanceOfPointOnLine(p:Vect):Float {
		return ((p.x - a.x) * (b.x-a.x) + (p.y - a.y) * (b.y-a.y)) / a.rawDistanceTo(b);
	}

	public static inline function GetBalanceOfPointOnLine(A:Vect, B:Vect, p:Vect):Float{
		return ((p.x - A.x) * (B.x-A.x) + (p.y - A.y) * (B.y-A.y)) / A.rawDistanceTo(B);
	}

	public function lineIntersection(w:Segment):Vect {
		var p1:Vect = new Vect(a.x, a.y);
		var p2:Vect = new Vect(b.x, b.y);
		var p3:Vect = new Vect(w.a.x, w.a.y);
		var p4:Vect = new Vect(w.b.x, w.b.y);
		var x1:Float = p1.x, x2:Float = p2.x, x3:Float = p3.x, x4:Float = p4.x;
		var y1:Float = p1.y, y2:Float = p2.y, y3:Float = p3.y, y4:Float = p4.y;
		var z1:Float= (x1 -x2), z2:Float = (x3 - x4), z3:Float = (y1 - y2), z4:Float = (y3 - y4);
		var d:Float = z1 * z4 - z3 * z2;
		 
		//no intersect
		if (d == 0) return new Vect((a.x+b.x)/2, (a.y+b.y)/2);
		 
		// Get the x and y
		var pre:Float = (x1*y2 - y1*x2), post:Float = (x3*y4 - y3*x4);
		var x:Float = ( pre * z2 - z1 * post ) / d;
		var y:Float = ( pre * z4 - z3 * post ) / d;		
		 
		return new Vect(x, y);
	}

	public function particleCollision(p:Vect, radius:Float = 0, buffer:Float = 0):Bool{
		if(isPointOnSeg(p)){
			return distanceToPoint(p)<radius+buffer;
		}
		else{
			return Math.min(a.distanceTo(p), b.distanceTo(p))<radius+buffer;
		}
	}

	public function segmentIntersection(p:Segment):Vect {
		var x1:Float = a.x;
		var x2:Float = b.x;
		var x3:Float = p.b.x;
		var x4:Float = p.a.x;
		
		var y1:Float = a.y;
		var y2:Float = b.y;
		var y3:Float = p.b.y;
		var y4:Float = p.a.y;
		
		var z1:Float = (x1 - x2);
		var z2:Float = (x3 - x4);
		var z3:Float = (y1 - y2);
		var z4:Float = (y3 - y4);
		
		var d:Float = z1 * z4 - z3 * z2;
		 
		//no intersect
		if (d == 0) {
			//trace("Parallel");
			return null;
		}
		 
		// Get the x and y
		var pre:Float = (x1 * y2 - y1 * x2);
		var post:Float = (x3 * y4 - y3 * x4);
		var intersect:Vect = new Vect( ( pre * z2 - z1 * post ) / d, ( pre * z4 - z3 * post ) / d);

		var this_balance:Float = getBalanceOfPointOnLine(intersect);
		if (this_balance > 1 || this_balance < 0){
			return null;
		}
		var that_balance:Float = p.getBalanceOfPointOnLine(intersect);
		if (that_balance > 1 || that_balance < 0){
			return null;
		}
		 
		return intersect;
	}

	public function rotateAroundOffset(offset:Float, balance:Float):Void{
		var l:Float = length;
		var point:Vect = getPointByBalance(balance);
		var target:Vect = Vect.NormalFromRad(angle+(offset) + Math.PI);

		a.makeEqualTo(Vect.Add(point, Vect.Mult(target, balance * length)));
		b.makeEqualTo(Vect.Sub(point, Vect.Mult(target, (1-balance) * length)));
	}

	function get_rightNormal():Vect {
		return new Vect(-(b.y-a.y), b.x-a.x);
	}

	function get_leftNormal():Vect {
		return new Vect(b.y-a.y, -(b.x-a.x));
	}
}