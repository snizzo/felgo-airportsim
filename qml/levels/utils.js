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
 *  @param v    vector as a 2d coordinates list e.g. [x,y]
 *  @param max  maximum possible velocity
 */
function getNormalizedVelocityFromVector(v, max){
    var longest = v[0] > v[1] ? v[0] : v[1]

    var ratio = 1;
    if (longest>max){
        ratio = max/longest;
    }

    return Qt.point(v[0]*ratio,v[1]*ratio);
}
