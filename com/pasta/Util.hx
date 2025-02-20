package pasta;

class Util{
    public static inline var FLOAT_MIN = -1.79769313486231e+308;
    public static inline var FLOAT_MAX = 1.79769313486231e+308;
	public inline static function to_degrees(radians:Float):Float{
		return radians * 57.2957795;
	}
	public inline static function to_radians(degrees:Float):Float{
		return degrees * 0.0174532925;
	}
}