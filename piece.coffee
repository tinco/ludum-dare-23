class Piece
    constructor: () ->
        @mesh = new THREE.Mesh(
            new THREE.CubeGeometry(
                piece_size, piece_size, piece_size),
                new THREE.MeshLambertMaterial(
                    color: 0xCC0000))

    onPiece: (piece) ->
        # TODO it's more than this
        @piece.position.z < piece.position.z+piece_size
