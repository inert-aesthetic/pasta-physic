package pasta.physics.constraints;

import pasta.physics.constraints.IConstraint.ConstraintType;

class FixParticleToStrut implements IConstraint{
    public var strut:Strut;
    public var particle:Particle;
    public var balance:Float = 0.5;
    public var friction:Float = 1;

	public final type:ConstraintType = FIX_PARTICLE_TO_STRUT;

	public function new(strut, particle, balance=0.5, friction=1) {
		this.strut = strut;
		this.particle = particle;
		this.balance = balance;
		this.friction = friction;
	}

    public function solve(){
        var delta:Vect;
		var delta_length:Float;
		var difference:Float;
        var a:Particle = strut.a;
        var b:Particle = strut.b;
        var p:Particle = particle;
        var seg:Segment = strut.segment;

		if(friction==1){
			var line_inverse_mass:Float =  strut.getInverseEffectiveMass(balance);
			//target point on line
			var t:Vect = seg.getPointByBalance(balance);
			var delta:Vect = Vect.Sub(p, t);
			
			var delta_length:Float;
			var difference:Float;
			
			var lateral_delta:Vect = Vect.Project(delta, seg.vector.leftNormal);
			delta_length = lateral_delta.length;
			
			if (delta_length != 0){
				difference = (delta_length) / (delta_length * (p.inverse_mass + line_inverse_mass));
				p.sub(Vect.Mult(lateral_delta, difference * p.inverse_mass));
				strut.shove(Vect.Mult(lateral_delta, difference * line_inverse_mass), balance);
			}
			
			var longitudinal_delta:Vect = Vect.Project(delta, seg.vector);
			
			delta_length = longitudinal_delta.length;
			if (delta_length != 0){
				difference = (delta_length) / (delta_length * (p.inverse_mass + (a.inverse_mass+b.inverse_mass)));
				p.sub(Vect.Mult(longitudinal_delta, difference * p.inverse_mass));
				strut.shove(Vect.Mult(longitudinal_delta, difference * (a.inverse_mass+p.inverse_mass)), balance);
			}
			return;
		}

		var current_balance:Float = seg.getBalanceOfPointOnLine(p);
        var old_balance:Float = balance;
		//trace(balance);
		if (current_balance <= 0){
			balance = 0;
			delta = Vect.Sub(a, p);
			delta_length = delta.length;
			if (delta_length==0){return;}
			difference = (delta_length) / (delta_length * (a.inverse_mass + p.inverse_mass));
			a.sub(Vect.Mult(delta, difference * a.inverse_mass));
			p.add(Vect.Mult(delta, difference * p.inverse_mass));
			return;
		}
		if (current_balance >= 1){
			balance = 1;
			delta = Vect.Sub(p, b);
			delta_length = delta.length;
			if (delta_length==0){return;}
			difference = (delta_length) / (delta_length * (p.inverse_mass + b.inverse_mass));
			p.sub(Vect.Mult(delta, difference * p.inverse_mass));
			b.add(Vect.Mult(delta, difference * b.inverse_mass));
			return;
		}
		var old_point:Vect = seg.getPointByBalance(old_balance);
		var new_point:Vect = seg.getPointByBalance(current_balance);
		var longitudinal_delta:Vect = Vect.Sub(new_point, old_point);
		var lateral_delta:Vect = Vect.Sub(p, new_point);

		longitudinal_delta.mult(friction);
		
		var total_force:Vect = Vect.Add(longitudinal_delta, lateral_delta);
		var total_force_length:Float = total_force.length;
		if (total_force_length == 0){return;}
		var inverse_effective_mass:Float = strut.getInverseEffectiveMass(balance);

		difference = total_force_length / (total_force_length * (p.inverse_mass + inverse_effective_mass));
		p.sub(Vect.Mult(total_force, difference * p.inverse_mass));
		balance = seg.getBalanceOfPointOnLine(p);
		strut.shove(Vect.Mult(total_force, difference * inverse_effective_mass), balance);
    }
}