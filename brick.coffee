class Brick
    constructor: () ->
        @pieces = (new Piece() for n in [1..4])

class IBrick extends Brick
class TBrick extends Brick
class OBrick extends Brick
class LBrick extends Brick
class JBrick extends Brick
class SBrick extends Brick
class ZBrick extends Brick

window.BrickKinds = [IBrick,
                     TBrick,
                     OBrick,
                     LBrick,
                     JBrick,
                     SBrick,
                     ZBrick]
