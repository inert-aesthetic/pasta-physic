package pasta.physics.constraints;

import pasta.physics.constraints.IConstraint.ConstraintType;

class FixDistance implements IConstraint{
    public var strut:Strut;
    public var rigidity:Float = 1;
    public var distance:Float = -1;
	public final type:ConstraintType = FIX_DISTANCE;

	public function new(strut, rigidity, distance) {
		this.strut = strut;
		this.rigidity = rigidity;
		this.distance = distance;
        if(distance == -1){
            this.distance = strut.a.distanceTo(strut.b);
        }
    }

    public function solve():Void{
        var a = strut.a;
        var b = strut.b;
        var xd:Float = b.x-a.x;
		var yd:Float = b.y-a.y;
        var rest_length_squared = distance*distance;
		
		
		var dlen:Float = xd * xd + yd * yd; //rolling the length into it to save some cycles
		/*
        if (breakable){
			if (Math.abs(dlen - rest_length_squared) > tolerance * tolerance){
				if (a.pairs.length == 1 && b.pairs.length == 1){ //find a way to break half way here 
					
				}
				else{
					if (a.pairs.length >= b.pairs.length){
						line.replaceParticle(a);
					}
					else{
						line.replaceParticle(b);
					}
					
				}
			}
		}
        */
		dlen += rest_length_squared;
		if (dlen == 0) { return; }; //prevents a divide by zero possibility;
		dlen = (rest_length_squared / dlen - 0.5) * rigidity; 
		xd *= dlen;
		yd *= dlen;
		
		var rat:Float = a.mass / (a.mass + b.mass);
		a.addXY(-xd * (1 - rat) * 2, -yd * (1 - rat) * 2);
		b.addXY(xd * rat * 2, yd * rat * 2);
    }
}