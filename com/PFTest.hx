package;

import pasta.physics.Particle;
import pasta.physics.Strut;
class PFTest{


    public static function main(){
        var a = new Particle(0, 0);
        var b = new Particle(10, 10);
        var s = new Strut(a, b);
    }
}