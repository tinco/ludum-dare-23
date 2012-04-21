/**
 * @author mr.doob / http://mrdoob.com/
 * based on http://papervision3d.googlecode.com/svn/trunk/as3/trunk/src/org/papervision3d/objects/primitives/Piece.as
 */

THREE.PieceGeometry = function ( width, height, depth, segmentsWidth, segmentsHeight, segmentsDepth, radius, materials, sides ) {
    THREE.Geometry.call( this );

    var scope = this,
    width_half = width / 2,
    height_half = height / 2,
    depth_half = depth / 2;

    var mpx, mpy, mpz, mnx, mny, mnz;

    if ( materials !== undefined ) {

        if ( materials instanceof Array ) {

            this.materials = materials;

        } else {

            this.materials = [];

            for ( var i = 0; i < 6; i ++ ) {

                this.materials.push( materials );

            }

        }

        mpx = 0; mnx = 1; mpy = 2; mny = 3; mpz = 4; mnz = 5;

    } else {

        this.materials = [];

    }

    this.sides = { px: true, nx: true, py: true, ny: true, pz: true, nz: true };

    if ( sides != undefined ) {

        for ( var s in sides ) {

            if ( this.sides[ s ] !== undefined ) {

                this.sides[ s ] = sides[ s ];

            }

        }

    }

    this.sides.px && buildPlane( 'z', 'y', - 1, - 1, 1, depth, height, width_half, mpx ); // px
    this.sides.nx && buildPlane( 'z', 'y',   1, - 1, -1, depth, height, - width_half, mnx ); // nx
    this.sides.py && buildPlane( 'x', 'z',   1,   1, 1, width, depth, height_half, mpy ); // py
    this.sides.ny && buildPlane( 'x', 'z',   1, - 1, -1,width, depth, - height_half, mny ); // ny
    this.sides.pz && buildPlane( 'x', 'y',   1, - 1, 1,width, height, depth_half, mpz ); // pz
    this.sides.nz && buildPlane( 'x', 'y', - 1, - 1, -1,width, height, - depth_half, mnz ); // nz

    function buildPlane( u, v, udir, vdir, wdir, width, height, depth, material ) {

        var w, ix, iy,
        gridX = segmentsWidth || 1,
        gridY = segmentsHeight || 1,
        width_half = width / 2,
        height_half = height / 2,
        offset = scope.vertices.length;

        if ( ( u === 'x' && v === 'y' ) || ( u === 'y' && v === 'x' ) ) {

            w = 'z';

        } else if ( ( u === 'x' && v === 'z' ) || ( u === 'z' && v === 'x' ) ) {

            w = 'y';
            gridY = segmentsDepth || 1;

        } else if ( ( u === 'z' && v === 'y' ) || ( u === 'y' && v === 'z' ) ) {

            w = 'x';
            gridX = segmentsDepth || 1;

        }

        var gridX1 = gridX + 1,
        gridY1 = gridY + 1,
        segment_width = width / gridX,
        segment_height = height / gridY,
        normal = new THREE.Vector3();

        normal[ w ] = depth > 0 ? 1 : - 1;
        var angle = Math.TAU / width
        var startAngle =  1/2 * angle
        if (w != 'y') {
            for ( iy = 0; iy < gridY1; iy ++ ) {
                for ( ix = 0; ix < gridX1; ix ++ ) {
                    var vector = new THREE.Vector3();
                    var yradius = radius + (iy * segment_height);
                    vector[ u ] = Math.sin(startAngle - ix * (angle / segmentsWidth)) * -yradius * udir;
                    vector[ v ] = (Math.cos(startAngle - iy * (angle / segmentsHeight)) * -yradius +radius + height /2) * vdir;
                    vector[ w ] = (Math.tan(startAngle - angle) * yradius) * wdir;

                    scope.vertices.push( new THREE.Vertex( vector ) );
                }
            }
        } else {
            // top or bottom
            for ( iy = 0; iy < gridY1; iy ++ ) {
                for ( ix = 0; ix < gridX1; ix ++ ) {
                    var vector = new THREE.Vector3();
                    yradius = -radius + depth * 2
                    vector[ u ] = Math.sin(startAngle - ix * (angle / segmentsWidth)) * yradius * udir;
                    vector[ v ] = Math.sin(startAngle - iy * (angle / segmentsHeight)) * yradius * vdir;
                    vector[ w ] = -depth;
                    scope.vertices.push( new THREE.Vertex( vector ) );
                }
            }
        }

        for ( iy = 0; iy < gridY; iy++ ) {

            for ( ix = 0; ix < gridX; ix++ ) {

                var a = ix + gridX1 * iy;
                var b = ix + gridX1 * ( iy + 1 );
                var c = ( ix + 1 ) + gridX1 * ( iy + 1 );
                var d = ( ix + 1 ) + gridX1 * iy;

                var face = new THREE.Face4( a + offset, b + offset, c + offset, d + offset );
                face.normal.copy( normal );
                face.vertexNormals.push( normal.clone(), normal.clone(), normal.clone(), normal.clone() );
                face.materialIndex = material;

                scope.faces.push( face );
                scope.faceVertexUvs[ 0 ].push( [
                            new THREE.UV( ix / gridX, iy / gridY ),
                            new THREE.UV( ix / gridX, ( iy + 1 ) / gridY ),
                            new THREE.UV( ( ix + 1 ) / gridX, ( iy + 1 ) / gridY ),
                            new THREE.UV( ( ix + 1 ) / gridX, iy / gridY )
                        ] );

            }

        }

    }

    this.computeCentroids();
    this.mergeVertices();

};

THREE.PieceGeometry.prototype = new THREE.Geometry();
THREE.PieceGeometry.prototype.constructor = THREE.PieceGeometry;
