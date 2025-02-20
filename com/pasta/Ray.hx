package pasta;
using Lambda;

class Ray{
    public var origin:Vect;
    public var direction:Vect;
    public var range:Float;

    public function new(origin:Vect, direction:Vect, range:Float){
        this.origin=origin;
        this.direction=direction;
        this.range=range;
    }

    public function intersectSegments(targets:Array<Segment>):Array<RaySegmentIntersection>{
        var res:Array<RaySegmentIntersection> = [];
        var ray = new Segment(origin, Vect.Add(origin, Vect.Mult(direction.normal, range)));
        for(t in targets){
            var intersection =t.segmentIntersection(ray);
            if(intersection == null) continue;
            res.push(new RaySegmentIntersection(t, intersection, origin.distanceTo(intersection))); 
        }
        res.sort((a, b)->{return a.distance>b.distance?1:a.distance<b.distance?-1:0;});
        for(i in 0...res.length){
            res[i].penetration_depth = i;
        }
        return res;
    }
}

@:structInit
class RaySegmentIntersection{
    public var segment:Segment;
    public var intersection:Vect;
    public var distance:Float;
    public var penetration_depth:Int = 0;
    public function new(segment, interserction, distance, penetration_depth=0) {
        this.segment = segment;
        this.intersection=interserction;
        this.distance=distance;
        this.penetration_depth=penetration_depth;
    }
}

