package pasta;

 @:structInit
class Vect {
	public var x:Float;
	public var y:Float;

	public inline static var LEFT:Int = -1;
	public inline static var RIGHT:Int = 1;
	public inline static var ON:Int = 0;

	public inline static var deg_to_rad:Float = 0.0174532925;
	public inline static var rad_to_deg:Float = 57.2957795;

	public function new(x:Float = 0, y:Float = 0) {
		this.x = x;
		this.y = y;
	}


	public inline function set(x:Float, y:Float):Vect {
		this.x = x;
		this.y = y;
		return this;
	}

	public inline function normalize():Vect {
		var l:Float = length;
		if (l == 0) {
			x = 0;
			y = 0;
			return this;
		};
		x /= l;
		y /= l;
		return this;
	}

	public var normal(get, never):Vect;

	private inline function get_normal():Vect {
		var l:Float = length;
		if (l == 0) {
			return new Vect();
		};
		return new Vect(x / l, y / l);
	}

	public static function Normalize(v:Vect):Vect {
		var l:Float = v.length;
		if (l == 0) {
			return new Vect(0, 0);
		};
		return new Vect(v.x / l, v.y / l);
	}

	public var length(get, set):Float;

	private inline function get_length():Float {
		return Math.sqrt(x * x + y * y);
	}

	private inline function set_length(to:Float):Float {
		normalize();
		mult(to);
		return to;
	}

	public var length_squared(get, never):Float;

	private inline function get_length_squared():Float {
		return x * x + y * y;
	}

	/**
		Direction in degrees
	**/
	public var direction(get, set):Float;

	private inline function get_direction():Float {
		return Math.atan2(y, x) / 0.0174532925;
	}

	public var directionRad(get, set):Float;

	private inline function get_directionRad():Float {
		return Math.atan2(y, x);
	}

	public var rightNormal(get, never):Vect;

	private inline function get_rightNormal():Vect {
		return new Vect(-y, x);
	}

	public var leftNormal(get, never):Vect;

	private inline function get_leftNormal():Vect {
		return new Vect(y, -x);
	}

	public var inverse(get, never):Vect;

	private inline function get_inverse():Vect {
		return new Vect(-x, -y);
	}

	public static inline function Dot(v1:Vect, v2:Vect):Float {
		return v1.x * v2.x + v1.y * v2.y;
	}

	public static inline function Cross(v1:Vect, v2:Vect):Float {
		return v1.x * v2.y - v1.y * v2.x;
	}

	public static function Project(v1:Vect, v2:Vect):Vect {
		var denom = v2.x * v2.x + v2.y * v2.y;
		if (denom == 0) {
			return new Vect();
		}
		var u = (v1.x * v2.x + v1.y * v2.y) / denom;
		return new Vect(u * v2.x, u * v2.y);
	}

	public static inline function ScalarProjection(v1:Vect, v2:Vect):Float {
		var denom = v2.x * v2.x + v2.y * v2.y;
		if (denom == 0) {
			return 0;
		}
		return (v1.x * v2.x + v1.y * v2.y) / denom;
	}

	public inline function distanceTo(v:Vect):Float {
		return Math.sqrt((v.x - x) * (v.x - x) + (v.y - y) * (v.y - y));
	}

	public inline function rawDistanceTo(v:Vect):Float {
		return (v.x - x) * (v.x - x) + (v.y - y) * (v.y - y);
	}

	public static function ReflectVect(v:Vect, w:Vect):Vect {
		var dp:Float = Dot(w, new Vect(v.x, v.y));
		return new Vect(v.x - 2 * w.x * dp, v.y - 2 * w.y * dp);
	}

	public inline function add(v:Vect):Vect {
		x += v.x;
		y += v.y;
		return this;
	}

	public inline function snapToGrid(grid_size:Float):Vect{
		var x_step = x % grid_size;
		var y_step = y % grid_size;
		x = x-x_step+(x_step>grid_size/2?grid_size:0);
		y = y-y_step+(y_step>grid_size/2?grid_size:0);
		return this;
	}
	public static inline function SnapToGrid(v:Vect, grid_size:Float):Vect{
		var ret = v.copy();
		var x_step = ret.x % grid_size;
		var y_step = ret.y % grid_size;
		ret.x = ret.x-x_step+(x_step>grid_size/2?grid_size:0);
		ret.y = ret.y-y_step+(y_step>grid_size/2?grid_size:0);
		return ret;
	}

	public inline function addXY(ax:Float, by:Float):Vect {
		x += ax;
		y += by;
		return this;
	}

	public static inline function Add(v1:Vect, v2:Vect):Vect {
		return new Vect(v1.x + v2.x, v1.y + v2.y);
	}

	public inline function sub(v:Vect):Vect {
		x -= v.x;
		y -= v.y;
		return this;
	}

	public inline function subXY(ax:Float, by:Float):Vect {
		x -= ax;
		y -= by;
		return this;
	}

	/**
	 * subtract v2 from v1 (v1-v2)
	 * @param	v1
	 * @param	v2
	 * @return
	 */
	public static inline function Sub(v1:Vect, v2:Vect):Vect {
		return new Vect(v1.x - v2.x, v1.y - v2.y);
	}

	public function rotateByDeg(degrees:Float):Vect{
		var target_angle = this.direction+degrees;
		set_direction(target_angle);
		return this;
	}

	public function rotateByRad(radians:Float):Vect{
		var target_angle = this.directionRad+radians;
		set_directionRad(target_angle);
		return this;
	}

	private function set_direction(degrees:Float):Float{
		var nv:Vect = Vect.NormalFromAngle(degrees);
		var len:Float = this.length;
		x = nv.x * len;
		y = nv.y * len;
		return degrees;
	}

	private function set_directionRad(radians:Float):Float{
		var nv:Vect = Vect.NormalFromRad(radians);
		var len:Float = this.length;
		x = nv.x * len;
		y = nv.y * len;
		return radians;
	}

	public inline function mult(n:Float):Vect {
		x *= n;
		y *= n;
		return this;
	}

	public static inline function Mult(v:Vect, n:Float):Vect {
		return new Vect(v.x * n, v.y * n);
	}

	public inline function div(n:Float):Vect {
		x /= n;
		y /= n;
		return this;
	}

	public static inline function Div(v:Vect, n:Float):Vect {
		return new Vect(v.x / n, v.y / n);
	}

	public inline function copy():Vect {
		return new Vect(x, y);
	}

	public inline function isZero():Bool {
		return x == 0 && y == 0;
	}

	/**
	 * returns -1 for left side, 1 for right side, 0 for on the line
	 * @param	start
	 * @param	end
	 * @param	point
	 * @return
	 */
	public static function getPointSide(start:Vect, end:Vect, point:Vect):Int {
		var line:Vect = Sub(end, start);
		var query:Vect = Sub(point, start);
		var r:Float = Cross(line, query);
		if (r < 0) {
			return LEFT;
		} else if (r > 0) {
			return RIGHT;
		}
		return ON;
	}

	public static var Zero(get, never):Vect;

	public static inline function get_Zero():Vect {
		return new Vect(0, 0);
	}

	public inline function makeZero():Void {
		x = y = 0;
	}

	public static function Partway(from:Vect, to:Vect, percent:Float = 0.5, target:Vect = null):Vect {
		//a + (b -a ) * x;
		var res = target==null?new Vect():target;
		return res.set(
			from.x+(to.x-from.x)*percent,
			from.y+(to.y-from.y)*percent
		);
	}

	public static inline function NormalFromAngle(a:Float):Vect {
		return new Vect(Math.cos(a * deg_to_rad), Math.sin(a * deg_to_rad));
	}

	public static inline function NormalFromRad(r:Float):Vect {
		return new Vect(Math.cos(r), Math.sin(r));
	}

	public inline function vectTo(target:Vect):Vect {
		return new Vect(target.x - x, target.y - y);
	}

	public inline function radiansTo(target:Vect):Float {
		return Math.atan2(target.y - y, target.x - x);
	}

	public inline function degreesTo(target:Vect):Float {
		return Math.atan2(target.y - y, target.x - x) / 0.0174532925;
	}

	public inline static function ProjectPointOnSeg(p:Vect, a:Vect, b:Vect):Vect {
		if(a.equals(b)) return new Vect(a.x, a.y);
		var u:Float = ((p.x - a.x) * (b.x - a.x) + (p.y - a.y) * (b.y - a.y)) / a.rawDistanceTo(b);

		return new Vect(a.x + u * (b.x - a.x), a.y + u * (b.y - a.y));
	}

	/**
	 * 
	 * @param	o Ray origin
	 * @param	d Ray direction
	 * @param	a Segment start
	 * @param	b Segment end
	 * @return
	 */
	public static function RayIntersectSegment(o:Vect, d:Vect, a:Vect, b:Vect):Float {
		var v1:Vect = Vect.Sub(o, a);
		var v2:Vect = Vect.Sub(b, a);
		var v3:Vect = new Vect(-d.y, d.x);

		// var n:Null<Float> = null;

		var dot:Float = Vect.Dot(v2, v3);
		if (Math.abs(dot) < 0.000001) {
			return -1;
		}

		var t1:Float = Vect.Cross(v2, v1) / dot;
		var t2:Float = Vect.Dot(v1, v3) / dot;
		if (t1 >= 0.0 && (t2 >= 0.0 && t2 <= 1.0)) {
			return t1;
		}
		return -1;
	}

	public inline function equals(b:Vect):Bool {
		return x == b.x && y == b.y;
	}

	/**
	 * 
	 * @param	o Ray origin
	 * @param	d Ray direction
	 * @param	a line point a
	 * @param	b line point b
	 * @return
	 */
	public static function RayIntersectLine(o:Vect, d:Vect, a:Vect, b:Vect):Float {
		if (o.equals(a)) {
			return 0;
		}

		if (o.equals(b)) {
			return 1;
		}

		var v1:Vect = Vect.Sub(o, a);
		var v2:Vect = Vect.Sub(b, a);
		var v3:Vect = new Vect(-d.y, d.x);

		var dot:Float = Vect.Dot(v2, v3);

		var t2:Float = Vect.Dot(v1, v3) / dot;
		return t2;

	}

	public inline function makeEqualTo(v:Vect):Vect {
		this.x = v.x;
		this.y = v.y;
		return this;
	}

	public function toString():String {
		return "[" + Math.floor(x * 100) / 100 + "," + Math.floor(y * 100) / 100 + "]";
	}

	public function serialize():SerializedVect{
		return {x:x, y:y};
	}

	public function fromSerialized(data:SerializedVect){
		this.x = data.x;
		this.y = data.y;
	}

	public static function FromSerialized(data:SerializedVect):Vect{
		return new Vect(data.x, data.y);
	}
}

typedef SerializedVect = {x:Float, y:Float};
