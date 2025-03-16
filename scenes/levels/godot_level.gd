extends Node2D
class_name GodotLevel

var telekinesis_projectile: PackedScene = preload("res://scenes/projectiles/telekinesis.tscn")
var link_projectile: PackedScene = preload("res://scenes/projectiles/link.tscn")
var tutorial_dismiss_action: String = ''
var minimap_position: String = 'right'

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
    _setup_world_coords()
    await _clear_overlapping_blocks()
    _bind_block_events()
    _calculate_block_directions()
    if !$"/root/BgMusicPlayer".is_playing():
        $"/root/BgMusicPlayer".play()

    $Linker.clear_bodies()
    $Linker.set_line2d($LinkLine)
    if minimap_position == "right":
        $MinimapCanvas/Control.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT, Control.PRESET_MODE_KEEP_SIZE)
    else:
        $MinimapCanvas/Control.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT, Control.PRESET_MODE_KEEP_SIZE)
    _setup_player()
    SaverLoader.save_current_state()
    
    if Globals.previous_level_texture and (Globals.previous_world_coord > Vector2(-1, -1)) and not Globals.warped_transition:
        var viewport_width: int = ProjectSettings.get_setting("display/window/size/viewport_width")
        var viewport_height: int = ProjectSettings.get_setting("display/window/size/viewport_height")
        var transition_node: LevelTransition = $Transition
        var transition_duration_y: float = transition_node.TRANSITION_DURATION_Y[Globals.transition_speed]
        var transition_duration_x: float = transition_node.TRANSITION_DURATION_X[Globals.transition_speed]
        
        $Transition.texture = Globals.previous_level_texture
        var tween: Tween = create_tween()
        tween.stop()
        tween.set_parallel(true)
        
        # player moved one level to the left, slide in the view left to right
        if (Globals.previous_world_coord.x > Globals.world_coord.x):
            $Transition.position = Vector2(viewport_width, $Transition.position.y)
            #tween.tween_property($Transition, "position", Vector2(viewport_width, $Transition.position.y), 5).from(Vector2(0, $Transition.position.y))
            tween.tween_property($"Camera2D", "offset", Vector2(0, 0), transition_duration_x).from(Vector2(viewport_width, 0))
        # player moved one level to the left, slide in the view right to left
        if (Globals.previous_world_coord.x < Globals.world_coord.x):
            $Transition.position = Vector2(-viewport_width, $Transition.position.y)
            #tween.tween_property($Transition, "position", Vector2(viewport_width, $Transition.position.y), 5).from(Vector2(0, $Transition.position.y))
            tween.tween_property($"Camera2D", "offset", Vector2(0, 0), transition_duration_x).from(Vector2(-viewport_width, 0))
        # player moved one level to the left, slide in the view bottom to top
        if (Globals.previous_world_coord.y > Globals.world_coord.y):
            $Transition.position = Vector2($Transition.position.x, -viewport_height)
            #tween.tween_property($Transition, "position", Vector2(viewport_width, $Transition.position.y), 5).from(Vector2(0, $Transition.position.y))
            tween.tween_property($"Camera2D", "offset", Vector2(0, 0), transition_duration_y).from(Vector2(0, -viewport_height))
        # player moved one level to the left, slide in the view top to bottom
        if (Globals.previous_world_coord.y < Globals.world_coord.y):
            $Transition.position = Vector2($Transition.position.x, viewport_height)
            #tween.tween_property($Transition, "position", Vector2(viewport_width, $Transition.position.y), 5).from(Vector2(0, $Transition.position.y))
            tween.tween_property($"Camera2D", "offset", Vector2(0, 0), transition_duration_y).from(Vector2(0, viewport_height))
        tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
        tween.play()
        get_tree().paused = true
        await tween.finished
        get_tree().paused = false
    $MinimapCanvas.visible = true
    
func _setup_world_coords() -> void :
    var regex: RegEx = RegEx.new()
    regex.compile("^Level_(\\d)_(\\d)$")
    var result: RegExMatch = regex.search(name)
    if result and result.get_group_count() == 2:
        Globals.world_coord = Vector2i(int(result.get_string(1)), int(result.get_string(2)))

func _clear_overlapping_blocks() -> void:
    var player_bounds: Rect2 = Rect2(Globals.player_spawn_position - %Player.dimensions/2, %Player.dimensions)
    var children: Array[Node] = $Walls.get_children()
    children.append_array($Floor.get_children())
    children.append_array($Platforms.get_children())
    
    for child in children:
        # Don't destroy portals / things that interact with the player on movement when they spawn on to pof it
        if is_instance_valid(child) and player_bounds.has_point(child.global_position) and not child.is_in_group('disable_on_player_spawn'):
            child.queue_free()
            await child.tree_exited
        else:
            pass
            # print('false', child.global_position)

func _bind_block_events() -> void:
    var children: Array[Node] = $Walls.get_children()
    children.append_array($Floor.get_children())
    children.append_array($Platforms.get_children())
    
    for child in children:
        if child.has_signal('player_killed'):
            child.connect('player_killed', func die() -> void:
                %Player.kill()
            )
    
        if child.has_signal('block_deleted'):
            child.connect('block_deleted', func delete(block: AnimatableBody2D) -> void:
                $Linker.remove_body(block)
                block.queue_free()
            )
        if child.is_in_group('disable_on_player_spawn'):
            var warp_child: Warp = child as Warp
            var player_bounds: Rect2 = Rect2(Globals.player_spawn_position - %Player.dimensions/2, %Player.dimensions)
            if player_bounds.has_point(warp_child.global_position):
                warp_child.is_active = false
                warp_child.connect('body_exited', func enable(_body: CharacterBody2D) -> void:
                    warp_child.is_active = true
                )

func _calculate_block_directions() -> void:
    var children: Array[Node] = $Walls.get_children()
    children.append_array($Floor.get_children())
    var children_grid: Array = []
    children_grid.resize(Globals.LEVEL_HEIGHT * Globals.LEVEL_WIDTH)
    children_grid.fill(null);
    for child in children:
        if "direction" in child:
            children_grid[Globals.px_position_to_grid_index(child.global_position)] = child
    
    for i in children_grid.size():
        var child: Node2D = children_grid[i]
        if (child != null):
            var left_sibling_index: int = i - 1 if (i % Globals.LEVEL_WIDTH) > 0 else -1;
            var left_sibling: Node2D = children_grid[left_sibling_index] if left_sibling_index >= 0 else null
            var right_sibling_index: int = i + 1 if (i % Globals.LEVEL_WIDTH) < Globals.LEVEL_WIDTH-1 else -1;
            var right_sibling: Node2D = children_grid[right_sibling_index] if right_sibling_index >= 0 else null
            var top_sibling_index: int = i - Globals.LEVEL_WIDTH if i > Globals.LEVEL_WIDTH else -1
            var top_sibling: Node2D = children_grid[top_sibling_index] if top_sibling_index >= 0 else null
            var bot_sibling_index: int = i + Globals.LEVEL_WIDTH if i < (children_grid.size() - Globals.LEVEL_WIDTH) else -1
            var bot_sibling: Node2D = children_grid[bot_sibling_index] if bot_sibling_index >= 0 else null

            if top_sibling and right_sibling:
                child.direction = AutoBlock.BLOCK_DIRECTION.CORNER_B_L
            elif top_sibling and left_sibling:
                child.direction = AutoBlock.BLOCK_DIRECTION.CORNER_B_R
            elif bot_sibling and right_sibling:
                child.direction = AutoBlock.BLOCK_DIRECTION.CORNER_T_L
            elif bot_sibling and left_sibling:
                child.direction = AutoBlock.BLOCK_DIRECTION.CORNER_T_R
            # free-standing horizontal blocks
            elif left_sibling or right_sibling and not (top_sibling or bot_sibling):
                if i < Globals.LEVEL_WIDTH:
                    child.direction = AutoBlock.BLOCK_DIRECTION.TOP
                else:
                    child.direction = AutoBlock.BLOCK_DIRECTION.BOTTOM
            # free-standing vertical blocks
            elif top_sibling or bot_sibling and not (left_sibling or right_sibling):
                if i % Globals.LEVEL_WIDTH == 0:
                    child.direction = AutoBlock.BLOCK_DIRECTION.LEFT
                elif i % Globals.LEVEL_WIDTH == Globals.LEVEL_WIDTH-1:
                    child.direction = AutoBlock.BLOCK_DIRECTION.RIGHT
            #elif not left_sibling and not right_sibling and (top_sibling or bot_sibling):
                #if i % Globals.LEVEL_WIDTH == 0:
                    #child.direction = AutoBlock.BLOCK_DIRECTION.LEFT
                #elif i % Globals.LEVEL_WIDTH == Globals.LEVEL_WIDTH-1:
                    #child.direction = AutoBlock.BLOCK_DIRECTION.RIGHT
            #elif not left_sibling:
                #if right_sibling and bot_sibling:
                    #child.direction = AutoBlock.BLOCK_DIRECTION.CORNER_T_L
                #elif right_sibling and top_sibling:
                    #child.direction = AutoBlock.BLOCK_DIRECTION.CORNER_B_L
                #elif right_sibling or top_sibling:
                    #child.direction = AutoBlock.BLOCK_DIRECTION.CORNER_B_L
            #elif not right_sibling:
                #if left_sibling and bot_sibling:
                    #child.direction = AutoBlock.BLOCK_DIRECTION.CORNER_T_R
                #elif right_sibling and top_sibling:
                    #child.direction = AutoBlock.BLOCK_DIRECTION.CORNER_B_R
                #elif left_sibling or top_sibling:
                    #child.direction = AutoBlock.BLOCK_DIRECTION.CORNER_B_R
            #else:
                #child.direction = AutoBlock.BLOCK_DIRECTION.BOTTOM
        

func _setup_player() -> void:
    %Player.position = Globals.player_spawn_position
    %Player/Crosshair.position = Globals.player_crosshair_spawn_position
    %Player/Sprite2D.scale = Globals.player_spawn_scale
    %Player.velocity = Globals.player_spawn_velocity
    

func _process(_delta: float) -> void:
    if Input.is_action_just_pressed("Reset Room") and not get_tree().paused:
        Globals.reset_level()
    if Input.is_action_just_pressed("Pause"):
        if not get_tree().paused:
            pause_game()
        else:
            resume_game()

func _physics_process(_delta: float) -> void:
    if %Player.position.x > Globals.LEVEL_WIDTH_PX / 2:
        var new_world_coord: Vector2 = Vector2(Globals.world_coord.x+1, Globals.world_coord.y)
        if Globals.world_coordinate_exists(new_world_coord):
            var player_spawn_position: Vector2 = Vector2((-Globals.LEVEL_WIDTH_PX/2+1), %Player.position.y)
            var player_spawn_velocity: Vector2 = %Player.velocity            
            Globals.transition_to_level(new_world_coord, player_spawn_position, player_spawn_velocity, %Player, get_viewport())
        else:
            %Player.velocity.x = -1000
            %Player.move_and_slide()
    elif %Player.position.x < (-Globals.LEVEL_WIDTH_PX / 2):
        var new_world_coord: Vector2 = Vector2(Globals.world_coord.x-1, Globals.world_coord.y)
        if Globals.world_coordinate_exists(new_world_coord):
            var player_spawn_position: Vector2 = Vector2((Globals.LEVEL_WIDTH_PX/2-1), %Player.position.y)
            var player_spawn_velocity: Vector2 = %Player.velocity
            Globals.transition_to_level(new_world_coord, player_spawn_position, player_spawn_velocity, %Player, get_viewport())
        else:
            %Player.velocity.x = 1000
            %Player.move_and_slide()
    elif %Player.position.y < (-Globals.LEVEL_HEIGHT_PX / 2):
        var new_world_coord: Vector2 = Vector2(Globals.world_coord.x, Globals.world_coord.y+1)
        if Globals.world_coordinate_exists(new_world_coord):
            var player_spawn_position: Vector2 = Vector2(%Player.position.x, (Globals.LEVEL_HEIGHT_PX/2-2))
            # When we move up, make sure we can make the jump into the room by adding some extra upward velocity.
            # We also increased the spawn_position_offset to two pixels instead of one, to ensure the correct blocks get cleared on spawn.
            var player_spawn_velocity: Vector2 = %Player.velocity + Vector2(0, -300)
            Globals.transition_to_level(new_world_coord, player_spawn_position, player_spawn_velocity, %Player, get_viewport())
        else:
            %Player.velocity.y = 500
            %Player.move_and_slide()
    elif %Player.position.y > (Globals.LEVEL_HEIGHT_PX / 2):
        var new_world_coord: Vector2 = Vector2(Globals.world_coord.x, Globals.world_coord.y-1)
        if Globals.world_coordinate_exists(new_world_coord):
            var player_spawn_position: Vector2 = Vector2(%Player.position.x, (-Globals.LEVEL_HEIGHT_PX/2+1))
            var player_spawn_velocity: Vector2 = %Player.velocity
            Globals.transition_to_level(new_world_coord, player_spawn_position, player_spawn_velocity, %Player, get_viewport())
        else:
            %Player.velocity.y = -500
            %Player.move_and_slide()
            %Player.play_sound_jump()
    
    if tutorial_dismiss_action.length() and Input.is_action_just_pressed(tutorial_dismiss_action):
        $TutorialCanvas/TutorialOverlay.fadeOut()
        tutorial_dismiss_action = ''
        

func _on_player_shoot_tk_projectile(angle: Vector2) -> void:
    var projectile: Area2D = telekinesis_projectile.instantiate() as Area2D
    projectile.angle = angle
    projectile.position = %Player.global_position
    var size: int = $Projectiles.get_children().filter(
        func find_tk_projectile(child: Area2D) -> bool:
            return 'is_telekinesis' in child
    ).size()
    if size == 0:
        $Projectiles.add_child(projectile)


func _on_player_shoot_link_projectile(angle: Vector2) -> void:
    if $Linker.linked_bodies.size() >= 2:
        return
    var projectile: Area2D = link_projectile.instantiate() as Area2D
    projectile.angle = angle
    projectile.position = %Player.global_position
    projectile.connect("on_hit", self._on_link_hit)    
    var size: int = $Projectiles.get_children().filter(
        func find_link_projectile(child: Area2D) -> bool:
            return 'is_link' in child
    ).size()
    if size == 0:
        $Projectiles.add_child(projectile)

func _on_link_hit(body: Node2D) -> void:
    # This enables the shader for the green borders
    $Linker.add_body(body)


func _on_player_gain_telekinesis() -> void:
    var input_actions: String = Globals.get_input_action_keyname('Shoot')
    $TutorialCanvas/TutorialOverlay.set_content("New ability unlocked! \n Press <%s>\nto use telekinesis" % input_actions)
    $TutorialCanvas/TutorialOverlay.fadeIn(.5)
    tutorial_dismiss_action = 'Shoot'


func _on_player_gain_link() -> void:
    var input_actions: String = Globals.get_input_action_keyname('Link')
    $TutorialCanvas/TutorialOverlay.set_content("New ability unlocked! \n Press <%s>\nto link two targeted blocks together" % input_actions)
    $TutorialCanvas/TutorialOverlay.fadeIn(.5)
    tutorial_dismiss_action = 'Link'
    $Linker.connect('body_linked', check_if_two_linked)
    
    
func _on_player_gain_sprint() -> void:
    var input_actions: String = Globals.get_input_action_keyname('Sprint')
    $TutorialCanvas/TutorialOverlay.set_content("New ability unlocked! \n Press <%s>\nto sprint" % input_actions)
    $TutorialCanvas/TutorialOverlay.fadeIn(.5)
    tutorial_dismiss_action = 'Sprint'
    

func check_if_two_linked(_body: AnimatableBody2D) -> void:
    if $Linker.linked_bodies.size() == 2:
        var reset_input_actions: String = Globals.get_input_action_keyname('Clear Link')
        $TutorialCanvas/TutorialOverlay.set_content("Linked blocks move together. \n Press <%s>\nto reset" % reset_input_actions)
        $TutorialCanvas/TutorialOverlay.fadeIn(.5)
        tutorial_dismiss_action = 'Clear Link'
        $Linker.disconnect('body_linked', check_if_two_linked)

func pause_game() -> void:
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    $PauseMenuCanvas.visible = true
    get_tree().paused = true
    
func resume_game() -> void:
    Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
    $PauseMenuCanvas.visible = false
    get_tree().paused = false

func _on_pause_menu_reset_click() -> void:
    get_tree().paused = false
    Globals.reset_level()

func _on_pause_menu_resume_click() -> void:
    resume_game()

func _on_pause_menu_save_quit_click() -> void:
    get_tree().paused = false
    get_tree().change_scene_to_file('res://scenes/main_menu.tscn')
