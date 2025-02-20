package pasta;

class Rect{
    public var left:Float;
    public var right:Float;
    public var top:Float;
    public var bottom:Float;

    public var width(get, never):Float;
    public var height(get, never):Float;

    public function new(left:Float, right:Float, top:Float, bottom:Float){
        this.left=left;
        this.right=right;
        this.top=top;
        this.bottom=bottom;
    }

    public inline function overlaps(r:Rect):Bool{
        return !(left > r.right
            || right < r.left
            || top > r.bottom
            || bottom < r.top);
    }

    public static inline function fromSegment(seg:Segment){
        return new Rect(Math.min(seg.a.x, seg.b.x), Math.max(seg.a.x, seg.b.x), Math.min(seg.a.y, seg.b.y), Math.max(seg.a.y, seg.b.y));
    }

    function get_width() return right-left;
    function get_height() return bottom-top;

	public function serialize():SerializedRect{
		return {l:left, r:right, t:top, b:bottom};
	}

	public function fromSerialized(data:SerializedRect){
		this.left = data.l;
		this.right = data.r;
        this.top = data.t;
        this.bottom = data.b;
	}

	public static function FromSerialized(data:SerializedRect):Rect{
		return new Rect(data.l, data.r, data.t, data.b);
	}
}

typedef SerializedRect = {l:Float, r:Float, t:Float, b:Float};
