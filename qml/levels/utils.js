/**
  * Returns a random starting point for planes
  */
function getRandomStartingPoint(){

}

/*
  Get distance between 2 points in x, y coordinates
  */
function get2DVectorFromPoints(a, b){

    var result = [b[0]-a[0],b[1]-a[1]];

    return result;
}

/**
 *  Get normalized vector from vector 2d coordinates
 *  If v == [0,0] then return current speed downscaled to minimum possible speed
 *
 *  @param v    vector as a 2d coordinates list e.g. [x,y]
 *  @param max  maximum possible velocity
 */
function getNormalizedVelocityFromVector(v, currentv, max, min){
    var speedScalar = Math.sqrt(Math.pow(v[0],2)+Math.pow(v[1],2));
    var currentSpeedScalar = Math.sqrt(Math.pow(currentv.x,2)+Math.pow(currentv.y,2));

    //ratio is used to downscale / upscale (x,y) velocity components
    var ratio = 1;

    //if new speed is zero, then return current speed downscaled to minimum possible speed
    if(v[0]===0 && v[1]===0){
        ratio = min/currentSpeedScalar;
        return Qt.point(currentv.x*ratio, currentv.y*ratio);
    }


    if (speedScalar > max){
        ratio = max/speedScalar;
    }
    if( speedScalar < min){
        ratio = min/speedScalar;
    }

    return Qt.point(v[0]*ratio, v[1]*ratio);
}
