@tool
class_name AutoBlock
extends Node2D
enum BLOCK_DIRECTION { TOP, RIGHT, BOTTOM, LEFT, CORNER_T_L, CORNER_T_R, CORNER_B_L, CORNER_B_R, VERT_MIDDLE, CENTER, CORNER_T_L_INNER, CORNER_T_R_INNER, CORNER_B_L_INNER, CORNER_B_R_INNER, CENTER_INNER }

@export var texture_top: Texture2D = null
@export var texture_right: Texture2D = null
@export var texture_bottom: Texture2D = null
@export var texture_left: Texture2D = null
@export var texture_corner_t_l: Texture2D = null
@export var texture_corner_t_r: Texture2D = null
@export var texture_corner_b_l: Texture2D = null
@export var texture_corner_b_r: Texture2D = null
@export var texture_vertical: Texture2D = null
@export var texture_center: Texture2D = null
@export var texture_corner_t_l_inner: Texture2D = null
@export var texture_corner_t_r_inner: Texture2D = null
@export var texture_corner_b_l_inner: Texture2D = null
@export var texture_corner_b_r_inner: Texture2D = null
@export var texture_center_inner: Texture2D = null
@export var direction: BLOCK_DIRECTION = BLOCK_DIRECTION.BOTTOM : set = _set_direction, get = _get_direction
var _direction: BLOCK_DIRECTION = BLOCK_DIRECTION.BOTTOM

func _set_direction(dir: BLOCK_DIRECTION) -> void:
    _direction = dir
    if dir == BLOCK_DIRECTION.BOTTOM:
        $".".texture = texture_bottom
    elif dir == BLOCK_DIRECTION.TOP:
        $".".texture = texture_top
    elif dir == BLOCK_DIRECTION.RIGHT:
        $".".texture = texture_right
    elif dir == BLOCK_DIRECTION.LEFT:
        $".".texture = texture_left
    elif dir == BLOCK_DIRECTION.VERT_MIDDLE:
        $".".texture = texture_vertical
    elif dir == BLOCK_DIRECTION.CORNER_T_L:
        $".".texture = texture_corner_t_l
    elif dir == BLOCK_DIRECTION.CORNER_T_R:
        $".".texture = texture_corner_t_r
    elif dir == BLOCK_DIRECTION.CORNER_B_L:
        $".".texture = texture_corner_b_l
    elif dir == BLOCK_DIRECTION.CORNER_B_R:
        $".".texture = texture_corner_b_r
    elif dir == BLOCK_DIRECTION.CENTER:
        $".".texture = texture_center
    elif dir == BLOCK_DIRECTION.CORNER_T_L_INNER:
        $".".texture = texture_corner_t_l_inner
    elif dir == BLOCK_DIRECTION.CORNER_T_R_INNER:
        $".".texture = texture_corner_t_r_inner
    elif dir == BLOCK_DIRECTION.CORNER_B_L_INNER:
        $".".texture = texture_corner_b_l_inner
    elif dir == BLOCK_DIRECTION.CORNER_B_R_INNER:
        $".".texture = texture_corner_b_r_inner
    elif dir == BLOCK_DIRECTION.CENTER_INNER:
        $".".texture = texture_center_inner

func _get_direction() -> BLOCK_DIRECTION:
    return _direction


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    if direction == BLOCK_DIRECTION.BOTTOM:
        $".".texture = texture_bottom
    elif direction == BLOCK_DIRECTION.TOP:
        $".".texture = texture_top
    elif direction == BLOCK_DIRECTION.RIGHT:
        $".".texture = texture_right
    elif direction == BLOCK_DIRECTION.LEFT:
        $".".texture = texture_left
    elif direction == BLOCK_DIRECTION.CORNER_T_L:
        $".".texture = texture_corner_t_l
    elif direction == BLOCK_DIRECTION.CORNER_T_R:
        $".".texture = texture_corner_t_r
    elif direction == BLOCK_DIRECTION.CORNER_B_L:
        $".".texture = texture_corner_b_l
    elif direction == BLOCK_DIRECTION.CORNER_B_R:
        $".".texture = texture_corner_b_r
    elif direction == BLOCK_DIRECTION.CENTER:
        $".".texture = texture_center
    elif direction == BLOCK_DIRECTION.CORNER_T_L_INNER:
        $".".texture = texture_corner_t_l_inner
    elif direction == BLOCK_DIRECTION.CORNER_T_R_INNER:
        $".".texture = texture_corner_t_r_inner
    elif direction == BLOCK_DIRECTION.CORNER_B_L_INNER:
        $".".texture = texture_corner_b_l_inner
    elif direction == BLOCK_DIRECTION.CORNER_B_R_INNER:
        $".".texture = texture_corner_b_r_inner
    elif direction == BLOCK_DIRECTION.CENTER_INNER:
        $".".texture = texture_center_inner
