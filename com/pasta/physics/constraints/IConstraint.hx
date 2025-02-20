package pasta.physics.constraints;

interface IConstraint{
    public function solve():Void;
    public var strut:Strut;
    public final type:ConstraintType;
}

enum ConstraintType {
    FIX_DISTANCE;
    FIX_PARTICLE_TO_STRUT;
}