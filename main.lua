-- Samus

log.info("Loading ".._ENV["!guid"]..".")
local envy = mods["LuaENVY-ENVY"]
envy.auto()
mods["RoRRModdingToolkit-RoRR_Modding_Toolkit"].auto()

local PATH = _ENV["!plugins_mod_folder_path"]
local NAMESPACE = "ANXvariable"



-- ========== Main ==========

local initialize = function() 
    local samus = Survivor.new(NAMESPACE, "samus")

    -- Utility function for getting sprite paths concisely
    local load_sprite = function (id, filename, frames, orig_x, orig_y, speed, left, top, right, bottom) 
        local sprite_path = path.combine(PATH, "Sprites",  filename)
        return Resources.sprite_load(NAMESPACE, id, sprite_path, frames, orig_x, orig_y, speed, left, top, right, bottom)
    end
    
    -- Load the common survivor sprites into a table
    local sprites = {
        idle = load_sprite("samus_idle", "sSamusIdle.png", 1, 14, 20),
        walk = load_sprite("samus_walk", "sSamusRun.png", 4, 12, 25),
        jump = load_sprite("samus_jump", "sSamusRun.png", 4, 12, 25),
        jump_peak = load_sprite("samus_jump_peak", "sSamusRun.png", 4, 12, 25),
        fall = load_sprite("samus_fall", "sSamusRun.png", 4, 12, 25),
        climb = load_sprite("samus_climb", "sSamusRun.png", 4, 12, 25),
        climb_hurt = load_sprite("samus_climb_hurt", "sSamusRun.png", 4, 12, 25), 
        death = load_sprite("samus_death", "sSamusRun.png", 4, 12, 25),
        decoy = load_sprite("samus_decoy", "sSamusRun.png", 4, 12, 25),
    }

    --spr_half
    local spr_idle_half = load_sprite("samus_idle_half", "sSamusIdleHalf.png", 1, 14, 20)
    local spr_walk_half = load_sprite("samus_walk_half", "sSamusRunHalf.png", 4, 12, 25)
    local spr_jump_half = load_sprite("samus_jump_half", "sSamusRunHalf.png", 4, 12, 25)
    local spr_jump_peak_half = load_sprite("samus_jump_peak_half", "sSamusRunHalf.png", 4, 12, 25)
    local spr_fall_half = load_sprite("samus_fall_half", "sSamusRunHalf.png", 4, 12, 25)

    local spr_shoot1_half = load_sprite("samus_shoot1_half", "sSamusShoot1Half.png", 4, 12, 25)
    
    --placeholder category, todo organize later
    local spr_skills = load_sprite("samus_skills", "sSamusSkills.png", 5, 0, 0)
    local spr_loadout = load_sprite("samus_loadout", "sSelectSamus.png", 4, 28, 0)
    local spr_portrait = load_sprite("samus_portrait", "sSamusPortrait.png", 3)
    local spr_portrait_small = load_sprite("samus_portrait_small", "sSamusPortraitSmall.png")
    local spr_portrait_cropped = load_sprite("samus_portrait_cropped", "sSamusPortraitC.png")
    local spr_log = load_sprite("samus_log", "sPortraitSamus.png")
    local spr_flashshift = load_sprite("samus_flashshift", "sSamusFlashShift.png", 4, 12, 25)
    local spr_flashshifttrail = load_sprite("samus_flashshifttrail", "sSamusFlashShift.png", 4, 12, 25)
    --local spr_morphandbomb = load_sprite("samus_morphandbomb", "sSamusMorphAndBomb.png", 10, 6, 0)
    local spr_morph = load_sprite("samus_morph", "sSamusMorph.png", 8, 6, 0)
    local spr_beam = load_sprite("samus_beam", "sSamusBeam.png", 4)
    local spr_beam_c0000 = load_sprite("samus_beam_c0000", "sSamusBeamC0000.png", 4, 14, 8)
    local spr_missile = load_sprite("samus_missile", "sSamusMissile.png", 3, 22)
    local spr_missile_explosion = gm.constants.sEfMissileExplosion
    local spr_bomb = load_sprite("samus_bomb", "sSamusBomb.png")
    local spr_powerbomb = load_sprite("samus_powerbomb", "sSamusPowerBomb.png")
    local spr_powerbomb_explosion = load_sprite("samus_powerbomb_explosion", "sSamusPowerBombExplode.png", 1, 683, 384)

    -- Colour for the character's skill names on character select
    samus:set_primary_color(Color.from_rgb(8, 253, 142))

    -- Assign sprites to various survivor fields
    samus.sprite_loadout = spr_loadout
    samus.sprite_portrait = spr_portrait
    samus.sprite_portrait_small = spr_portrait_small
    samus.sprite_portrait_palette = spr_portrait_cropped
    samus.sprite_title = sprites.walk
    samus.sprite_idle = sprites.idle
    samus.sprite_credits = sprites.idle
    samus:set_animations(sprites)
    -- Offset for the Prophet's Cape
    samus:set_cape_offset(-1, -6, 0, -5)

    local samus_log = Survivor_Log.new(samus, spr_log, sprites.walk)

    samus:clear_callbacks()
    samus:onInit(function(actor)
        actor.shiftedfrom = 0
        actor.sprite_idle_half = Array.new({sprites.idle, spr_idle_half, 0})
        actor.sprite_walk_half = Array.new({sprites.walk, spr_walk_half, 0})
        actor.sprite_jump_half = Array.new({sprites.jump, spr_jump_half, 0})
        actor.sprite_jump_peak_half = Array.new({sprites.jump_peak, spr_jump_peak_half, 0})
        actor.sprite_fall_half = Array.new({sprites.fall, spr_fall_half, 0})

        actor:survivor_util_init_half_sprites()
    end)


    -- Survivor stats
    samus:set_stats_base({
        maxhp = 300,
        damage = 16,
        regen = 0.02
    })

    samus:set_stats_level({
        maxhp = 75,
        damage = 4,
        regen = 0.004,
    })

    samus:onStep(function(actor)
        
    end)

    local obj_beam = Object.new(NAMESPACE, "samus_beam")
    obj_beam.obj_sprite = spr_beam
    obj_beam.obj_depth = 1
    obj_beam:clear_callbacks()
    
    obj_beam:onStep(function(instance)
        local data = instance:get_data()
        instance.x = instance.x + data.horizontal_velocity + data.parent.pHspeed

        -- Hit the first enemy actor that's been collided with
        local actor_collisions, _ = instance:get_collisions(gm.constants.pActorCollisionBase)
        for _, other_actor in ipairs(actor_collisions) do
            if data.parent:attack_collision_canhit(other_actor) then
                -- Deal damage
                local damage_direction = 0
                if data.horizontal_velocity < 0 then
                    damage_direction = 180
                end
                data.parent:fire_direct(other_actor, data.damage_coefficient, damage_direction, instance.x, instance.y, spr_none)

                -- Destroy the beam
                instance:destroy()
                return
            end
        end

        -- Hitting terrain destroys the beam
        if instance:is_colliding(gm.constants.pSolidBulletCollision) then
            instance:destroy()
            return
        end

        -- Check we're within stage bounds
        local stage_width = GM._mod_room_get_current_width()
        local stage_height = GM._mod_room_get_current_height()
        if instance.x < -16 or instance.x > stage_width + 16 
           or instance.y < -16 or instance.y > stage_height + 16 
        then 
            instance:destroy()
            return
        end

        -- The beam cannot exist for too long
        if instance.statetime >= 20 + (instance.duration) then
            instance:destroy()
            return
        end
        instance.statetime = instance.statetime + 1
    end)

    local obj_missile = Object.new(NAMESPACE, "samus_missile")
    obj_missile.obj_sprite = spr_missile
    obj_missile.obj_depth = 1
    obj_missile:clear_callbacks()
    
    obj_missile:onStep(function(instance)
        local data = instance:get_data()
        instance.x = instance.x + data.horizontal_velocity + data.parent.pHspeed
        if data.horizontal_velocity < 16
            and data.horizontal_velocity > - 16
        then
            data.horizontal_velocity = gm.sign(instance.image_xscale) * 16 * ((1.15^instance.statetime - 1) / (1.125^32 - 1))
        end
        -- Hit the first enemy actor that's been collided with
        local actor_collisions, _ = instance:get_collisions(gm.constants.pActorCollisionBase)
        for _, other_actor in ipairs(actor_collisions) do
            if data.parent:attack_collision_canhit(other_actor) then
                -- Deal damage
                data.parent:fire_explosion(instance.x, instance.y,  64, 64, data.damage_coefficient, spr_missile_explosion, spr_none)
                instance:sound_play(gm.constants.wExplosiveShot, 0.8, 1)
                -- Destroy the missile
                instance:destroy()
                return
            end
        end

        -- Hitting terrain destroys the missile
        if instance:is_colliding(gm.constants.pSolidBulletCollision) then
            data.parent:fire_explosion(instance.x, instance.y,  64, 64, data.damage_coefficient, spr_missile_explosion, spr_none)
            instance:sound_play(gm.constants.wExplosiveShot, 0.8, 1)
            instance:destroy()
            return
        end

        -- Check we're within stage bounds
        local stage_width = GM._mod_room_get_current_width()
        local stage_height = GM._mod_room_get_current_height()
        if instance.x < -16 or instance.x > stage_width + 16 
           or instance.y < -16 or instance.y > stage_height + 16 
        then 
            instance:destroy()
            return
        end

        -- The missile cannot exist for too long
        if instance.statetime >= 360 then
            instance:destroy()
            return
        end

        local trail = GM.instance_create(instance.x - 18 * instance.image_xscale, instance.y + 5, gm.constants.oEfTrail)
        trail.sprite_index = gm.constants.sEfMissileTrail
        trail.image_index = 0
        trail.image_speed = 8 / 9
        trail.image_xscale = instance.image_xscale * (data.horizontal_velocity / 16)
        trail.image_yscale = 0.8
        trail.depth = instance.depth + 1
        instance.statetime = instance.statetime + 1
    end)
    
    local obj_bomb = Object.new(NAMESPACE, "samus_bomb")
    obj_bomb.obj_sprite = spr_bomb
    obj_bomb.obj_depth = -501
    obj_bomb:clear_callbacks()

    obj_bomb:onStep(function(instance)
        local data = instance:get_data()

        -- Fuse
        if instance.statetime >= 30 then
            local parentalignx = data.parent.x - 4
            local diffx = parentalignx - instance.x
            --if instance.hitowner == 0 then
            --    log.info(instance:distance_to_point(data.parent.x, data.parent.y + 11))
            --end
            if instance:distance_to_point(data.parent.x, data.parent.y + 11) <= 11 and instance.hitowner == 0 then
                if parentalignx ~= instance.x then
                    data.parent.pHspeed = data.parent.pHspeed + 2.8 * gm.sign(diffx)
                end
                data.parent.pVspeed = data.parent.pVmax * -1.25
                instance.hitowner = 1
            end
            if data.fired == 0 then
                data.parent:fire_explosion(instance.x, instance.y,  64, 64, data.damage_coefficient, spr_missile_explosion, spr_none)
                instance:sound_play(gm.constants.wExplosiveShot, 0.8, 1)
                instance.image_alpha = 0
                local skill4 = data.parent:get_active_skill(Skill.SLOT.special)
                skill4.stock = skill4.stock + 1
                data.fired = 1
            end
        end

        if instance.statetime >= 32 then
            instance:destroy()
            return
        end

        instance.statetime = instance.statetime + 1
    end)
    
    local obj_powerbomb = Object.new(NAMESPACE, "samus_powerbomb")
    obj_powerbomb.obj_sprite = spr_powerbomb
    obj_powerbomb.obj_depth = -501
    obj_powerbomb:clear_callbacks()
    
    local obj_powerbomb_explosion = Object.new(NAMESPACE, "samus_powerbomb_explosion")
    obj_powerbomb_explosion.obj_sprite = spr_powerbomb_explosion
    obj_powerbomb_explosion.obj_depth = -501
    obj_powerbomb_explosion:clear_callbacks()

    obj_powerbomb:onStep(function(instance)
        local data = instance:get_data()

        -- Fuse
        if instance.statetime >= 70 then
            local parentalignx = data.parent.x - 4
            local diffx = parentalignx - instance.x
            --if instance.hitowner == 0 then
            --    log.info(instance:distance_to_point(data.parent.x, data.parent.y + 11))
            --end
            if instance:distance_to_point(data.parent.x, data.parent.y + 11) <= 11 and instance.hitowner == 0 then
                if parentalignx ~= instance.x then
                    data.parent.pHspeed = data.parent.pHspeed + 2.8 * gm.sign(diffx)
                end
                data.parent.pVspeed = data.parent.pVmax * -1.25
                instance.hitowner = 1
            end
            if data.fired == 0 then
                --data.parent:fire_explosion(instance.x, instance.y,  1366, 768, data.damage_coefficient * 10, spr_none, spr_none)
                local powerbombex = obj_powerbomb_explosion:create(instance.x + 4, instance.y + 4)
                powerbombex.statetime = 0
                powerbombex.image_xscale = 0
                powerbombex.image_yscale = 0
                powerbombex.image_alpha = 0.8
                local powerbombex_data = powerbombex:get_data()
                powerbombex_data.parent = data.parent
                local damage = data.damage_coefficient
                powerbombex_data.damage_coefficient = damage
                powerbombex_data.fired = 0
                --instance:sound_play(gm.constants.wExplosiveShot, 0.8, 1)
                instance.image_alpha = 0
                data.fired = 1
            end
        end

        if instance.statetime >= 72 then
            instance:destroy()
            return
        end

        instance.statetime = instance.statetime + 1
    end)

    obj_powerbomb_explosion:onStep(function(instance)
        local data = instance:get_data()

        if instance.image_xscale < 1 then
            instance.image_xscale = instance.image_xscale + 0.02
            instance.image_yscale = instance.image_yscale + 0.02
            if math.fmod(instance.statetime, 5) == 0 then
                data.parent:fire_explosion(instance.x, instance.y,  1366 * instance.image_xscale, 768 * instance.image_yscale, data.damage_coefficient / 10, spr_none, spr_none)
                --log.info(instance.statetime)
            end
        else
            if data.fired == 0 then
                data.parent:fire_explosion(instance.x, instance.y,  1366 * instance.image_xscale, 768 * instance.image_yscale, data.damage_coefficient / 10, spr_none, spr_none)
                data.fired = 1
            end
            instance.image_alpha = instance.image_alpha - 0.025
        end
        if instance.image_alpha <= 0 then
            instance:destroy()
            return
        end

        instance.statetime = instance.statetime + 1
    end)
    
    -- Grab references to skills. Consider renaming the variables to match your skill names, in case 
    -- you want to switch which skill they're assigned to in future.
    local skill_primary = samus:get_primary()
    local skill_secondary = samus:get_secondary()
    local skill_utility = samus:get_utility()
    local skill_special = samus:get_special()
    local skill_scepter_special = Skill.new(NAMESPACE, "samusVBoosted")
    skill_special:set_skill_upgrade(skill_scepter_special)

    -- Set the animations for each skill
    skill_primary:set_skill_animation(sprites.walk)
    skill_secondary:set_skill_animation(sprites.walk)
    skill_utility:set_skill_animation(spr_flashshift)
    skill_special:set_skill_animation(spr_morph)
    skill_scepter_special:set_skill_animation(spr_morph)
    
    -- Set the icons for each skill, specifying the icon spritesheet and the specific subimage
    skill_primary:set_skill_icon(spr_skills, 0)
    skill_secondary:set_skill_icon(spr_skills, 1)
    skill_utility:set_skill_icon(spr_skills, 2)
    skill_special:set_skill_icon(spr_skills, 3)
    skill_scepter_special:set_skill_icon(spr_skills, 4)
    
    -- Set the damage coefficient and cooldown for each skill. A damage coefficient of 100% is equal
    -- to 1.0, 150% to 1.5, 200% to 2.0, and so on. Cooldowns are specified in frames, so multiply by
    -- 60 to turn that into actual seconds.
    skill_primary:set_skill_properties(1.2, 0)
    skill_primary.require_key_press = true
    skill_secondary:set_skill_properties(4.0, 120)
    skill_secondary:set_skill_stock(5, 5, true, 1)
    skill_utility:set_skill_properties(0.0, 240)
    skill_utility:set_skill_stock(2, 2, true, 1)
    skill_utility.is_utility = true
    skill_special:set_skill_properties(2.0, 0)
    skill_special.is_primary = true
    skill_special:set_skill_stock(3, 3, false, 1)
    skill_special.require_key_press = true
    skill_special.required_interrupt_priority = State.ACTOR_STATE_INTERRUPT_PRIORITY.skill
    skill_scepter_special:set_skill_properties(30.0, 900)
    skill_scepter_special:set_skill_stock(1, 1, true, 1)
    skill_scepter_special.require_key_press = true
    skill_scepter_special.required_interrupt_priority = State.ACTOR_STATE_INTERRUPT_PRIORITY.skill

    -- Clear callbacks
    skill_primary:clear_callbacks()
    skill_secondary:clear_callbacks()
    skill_utility:clear_callbacks()
    skill_special:clear_callbacks()
    skill_scepter_special:clear_callbacks()

    -- Again consider renaming these variables after the ability itself
    local state_primary = State.new(NAMESPACE, skill_primary.identifier)
    state_primary:clear_callbacks()
    local state_secondary = State.new(NAMESPACE, skill_secondary.identifier)
    state_secondary:clear_callbacks()
    local state_utility = State.new(NAMESPACE, skill_utility.identifier)
    state_utility.activity_flags = State.ACTIVITY_FLAG.allow_rope_cancel
    state_utility:clear_callbacks()
    local state_special = State.new(NAMESPACE, skill_special.identifier)
    state_special:clear_callbacks()
    local state_scepter_special = State.new(NAMESPACE, skill_scepter_special.identifier)
    state_scepter_special:clear_callbacks()
    
    -- Register callbacks that switch states when skills are activated
    skill_primary:onActivate(function(actor, skill, index)
        actor:enter_state(state_primary)
    end)
    
    skill_secondary:onActivate(function(actor, skill, index)
        actor:enter_state(state_secondary)
    end)
    
    skill_utility:onActivate(function(actor, skill, index)
        actor:enter_state(state_utility)
    end)
    
    skill_special:onActivate(function(actor, skill, index)
        actor:enter_state(state_special)
    end)
    
    skill_scepter_special:onActivate(function(actor, skill, index)
        actor:enter_state(state_scepter_special)
    end)


    -- Executed when state_primary is entered
    state_primary:onEnter(function(actor, data)
        actor:skill_util_strafe_init()
        actor:skill_util_strafe_turn_init()
        actor.image_index2 = 0 -- Make sure our animation starts on its first frame
        -- index2 is needed for strafe sprites to work. From here we can setup custom data that we might want to refer back to in onStep
        -- Our flag to prevent firing more than once per attack
        data.fired = 0
        data.charge = 0
        data.beamcharged = 0
        data.released = 0
    end)
    
    -- Executed every game tick during this state
    state_primary:onStep(function(actor, data)
        actor.sprite_index2 = spr_shoot1_half
        -- index2 is needed for strafe sprites to work
        actor:skill_util_strafe_update(0.25 * actor.attack_speed, 1.0) -- 0.25 means 4 ticks per frame at base attack speed
        actor:skill_util_step_strafe_sprites()
        actor:skill_util_strafe_turn_update()
        local waterbucket = not actor:control("skill1", 0)
        local damage = actor:skill_get_damage(skill_primary)
        local direction = GM.cos(GM.degtorad(actor:skill_util_facing_direction()))
        local buff_shadow_clone = Buff.find("ror", "shadowClone")
        local spawn_offset = 5 * direction

        if not waterbucket and data.released == 0 then
            if actor.image_index2 > 0 then
                actor.image_index2 = 0
            end

            if data.charge < 50 then
                data.charge = data.charge + actor.attack_speed
            elseif data.beamcharged == 0 then
                data.beamcharged = 1
                actor:sound_play(gm.constants.wSpiderSpawn, 1, 0.9)
                actor:sound_play(gm.constants.wSpiderHit, 1, 0.9)
                local sparks = GM.instance_create(actor.x + spawn_offset, actor.y, gm.constants.oEfSparks)
                sparks.sprite_index = gm.constants.sSparks18
                sparks.depth = actor.depth - 1
            end
        else
            if actor.image_index2 >= 0 and data.fired == 0 then
                data.fired = 1
                actor:skill_util_update_heaven_cracker(actor, damage)
                if data.beamcharged == 1 then
                    damage = damage * 3
                end
                    for i=0, actor:buff_stack_count(buff_shadow_clone) do 
                        local beam = obj_beam:create(actor.x + spawn_offset, actor.y)
                        local beam_data = beam:get_data()
                        beam.image_speed = 0.25
                        beam.image_xscale = direction
                        if data.beamcharged == 1 then
                            beam.sprite_index = spr_beam_c0000
                            beam.mask_index = beam.sprite_index
                        end
                        beam.statetime = 0
                        beam.duration = math.min(actor.level * 10, 200)
                        beam_data.parent = actor
                        beam_data.horizontal_velocity = 10 * direction
                        beam_data.damage_coefficient = damage
                    end
                actor:sound_play(gm.constants.wSpiderShoot1, 1, 0.8 + math.random() * 0.2)
                data.released = 1
            end
        end

    
    
        -- A convenience function that exits this state automatically once the animation ends
        actor:skill_util_exit_state_on_anim_end()
    end)

    state_primary:onExit(function(actor, data)
        actor:skill_util_strafe_exit()
    end)

    -- Executed when state_secondary is entered
    state_secondary:onEnter(function(actor, data)
        actor:skill_util_strafe_init()
        actor:skill_util_strafe_turn_init()
        actor.image_index2 = 0 -- Make sure our animation starts on its first frame
        -- index2 is needed for strafe sprites to work. From here we can setup custom data that we might want to refer back to in onStep
        -- Our flag to prevent firing more than once per attack
        data.fired = 0
 
    end)
    
    -- Executed every game tick during this state
    state_secondary:onStep(function(actor, data)
        actor.sprite_index2 = spr_shoot1_half
        -- index2 is needed for strafe sprites to work    
        actor:skill_util_strafe_update(0.25 * actor.attack_speed, 1.0) -- 0.25 means 4 ticks per frame at base attack speed
        actor:skill_util_step_strafe_sprites()
        actor:skill_util_strafe_turn_update()

        if actor.image_index2 >= 0 and data.fired == 0 then
            data.fired = 1
    
            local direction = GM.cos(GM.degtorad(actor:skill_util_facing_direction()))
            local buff_shadow_clone = Buff.find("ror", "shadowClone")
            for i=0, actor:buff_stack_count(buff_shadow_clone) do 
                local spawn_offset = 16 * direction
                local missile = obj_missile:create(actor.x + spawn_offset, actor.y)
                missile.image_speed = 0.25
                missile.image_xscale = direction
                missile.statetime = 0
                local missile_data = missile:get_data()
                missile_data.parent = actor
                missile_data.horizontal_velocity = 0
                local damage = actor:skill_get_damage(skill_secondary)
                missile_data.damage_coefficient = damage


            end
            actor:sound_play(gm.constants.wMissileLaunch, 1, 0.8 + math.random() * 0.2)
        end
    
    
        -- A convenience function that exits this state automatically once the animation ends
        actor:skill_util_exit_state_on_anim_end()
    end)

    state_secondary:onExit(function(actor, data)
        actor:skill_util_strafe_exit()
    end)

    -- Executed when state_utility is entered
    state_utility:onEnter(function(actor, data)
        actor.image_index = 0 -- Make sure our animation starts on its first frame
        -- From here we can setup custom data that we might want to refer back to in onStep
        -- Our flag to prevent firing more than once per attack
        actor:sound_play(gm.constants.wHuntressShoot3, 1, 0.8 + math.random() * 0.2)
        actor.shiftedfrom = actor.y
    end)
    
    -- Executed every game tick during this state
    state_utility:onStep(function(actor, data)
        actor:skill_util_fix_hspeed()
        -- Set the animation and animation speed. This speed will automatically have the survivor's 
        -- attack speed bonuses applied (e.g. from Soldier's Syringe)
        local animation = actor:actor_get_skill_animation(skill_utility)
        local animation_speed = 0.25

        -- We don't want attack speed to speed up the dodge itself, because that could end up
        -- reducing the dodge window, so we undo its benefit ahead of time
        if actor.attack_speed > 0 then
            animation_speed = animation_speed / actor.attack_speed
        end

        actor:actor_animation_set(animation, animation_speed)

        local direction = GM.cos(GM.degtorad(actor:skill_util_facing_direction()))
        local buff_shadow_clone = Buff.find("ror", "shadowClone")
        if actor.invincible < 10 then 
            actor.invincible = 10
        end
        actor.pHspeed = direction * actor.pHmax * 6
        actor.pVspeed = 0
        actor.y = actor.shiftedfrom

        local trail = GM.instance_create(actor.x, actor.y, gm.constants.oEfTrail)
        trail.sprite_index = spr_flashshifttrail
        trail.image_index = actor.image_index - 1
        trail.image_xscale = direction
        trail.image_alpha = actor.image_alpha - 0.25
        trail.depth = actor.depth + 1
        
        -- A convenience function that exits this state automatically once the animation ends
        actor:skill_util_exit_state_on_anim_end()
    end)

    state_utility:onExit(function(actor, data)
        if actor.invincible <= 10 then
            actor.invincible = 0
        end
        actor.pHspeed = 0
 
    end)

    -- Executed when state_special is entered
    state_special:onEnter(function(actor, data)
        actor:skill_util_strafe_init()
        actor:skill_util_strafe_turn_init()
        actor.image_index2 = 0 -- Make sure our animation starts on its first frame
        -- index2 is needed for strafe sprites to work. From here we can setup custom data that we might want to refer back to in onStep
        -- Our flag to prevent firing more than once per attack
        actor.image_alpha = 0
        actor.image_yscale = 0.5
        actor.y = actor.y + 6
        data.fired = 0
 
    end)
    
    -- Executed every game tick during this state
    state_special:onStep(function(actor, data)
        actor.sprite_index2 = spr_morph
        -- index2 is needed for strafe sprites to work
        actor:skill_util_strafe_update(0.25 * actor.attack_speed, 1.0) -- 0.25 means 4 ticks per frame at base attack speed
        actor:skill_util_step_strafe_sprites()
        actor:skill_util_strafe_turn_update()

        if actor.image_index2 >= 1 and data.fired == 0 then
            data.fired = 1
            actor:sound_play(gm.constants.wPlayer_TakeDamage, 0.75, 1.5)
            local buff_shadow_clone = Buff.find("ror", "shadowClone")
            for i=0, actor:buff_stack_count(buff_shadow_clone) do
                local bomb = obj_bomb:create(actor.x - 4, actor.y - 3)
                bomb.statetime = 0
                bomb.hitowner = 0
                local bomb_data = bomb:get_data()
                bomb_data.parent = actor
                local damage = actor:skill_get_damage(skill_special)
                bomb_data.damage_coefficient = damage
                bomb_data.fired = 0
            end
        end

        for i=0, 20 do
            local trail = GM.instance_create(actor.x, actor.y - 6, gm.constants.oEfTrail)
            trail.sprite_index = spr_morph
            trail.image_index = actor.image_index2
            trail.image_xscale = actor.image_xscale
            trail.image_alpha = 1 / 10
            trail.depth = actor.depth
        end--this will probably be very laggy
            
        -- A convenience function that exits this state automatically once the animation ends
        actor:skill_util_exit_state_on_anim_end()
    end)

    state_special:onExit(function(actor, data)
        actor:skill_util_strafe_exit()
        actor.image_yscale = 1
        actor.y = actor.y - 6
        actor.image_alpha = 1
    end)

    state_special:onGetInterruptPriority(function(actor, data)
        if actor.image_index2 <= 2 then
            return State.ACTOR_STATE_INTERRUPT_PRIORITY.priority_skill
        else
            return State.ACTOR_STATE_INTERRUPT_PRIORITY.skill_interrupt_period
        end
    end)

    -- Executed when state_scepter_special is entered
    state_scepter_special:onEnter(function(actor, data)
        actor:skill_util_strafe_init()
        actor:skill_util_strafe_turn_init()
        actor.image_index2 = 0 -- Make sure our animation starts on its first frame
        -- index2 is needed for strafe sprites to work. From here we can setup custom data that we might want to refer back to in onStep
        -- Our flag to prevent firing more than once per attack
        actor.image_alpha = 0
        actor.image_yscale = 0.5
        actor.y = actor.y + 6
        data.fired = 0
 
    end)
    
    -- Executed every game tick during this state
    state_scepter_special:onStep(function(actor, data)
        actor.sprite_index2 = spr_morph
        -- index2 is needed for strafe sprites to work
        actor:skill_util_strafe_update(0.25 * actor.attack_speed, 1.0) -- 0.25 means 4 ticks per frame at base attack speed
        actor:skill_util_step_strafe_sprites()
        actor:skill_util_strafe_turn_update()

        if actor.image_index2 >= 1 and data.fired == 0 then
            data.fired = 1
            actor:sound_play(gm.constants.wBossLaser1Fire, 0.8, 1)
            local buff_shadow_clone = Buff.find("ror", "shadowClone")
            for i=0, actor:buff_stack_count(buff_shadow_clone) do
                local powerbomb = obj_powerbomb:create(actor.x - 4, actor.y - 3)
                powerbomb.statetime = 0
                powerbomb.hitowner = 0
                local powerbomb_data = powerbomb:get_data()
                powerbomb_data.parent = actor
                local damage = actor:skill_get_damage(skill_scepter_special)
                powerbomb_data.damage_coefficient = damage
                powerbomb_data.fired = 0
            end
        end

        for i=0, 20 do
            local trail = GM.instance_create(actor.x, actor.y - 6, gm.constants.oEfTrail)
            trail.sprite_index = spr_morph
            trail.image_index = actor.image_index2
            trail.image_xscale = actor.image_xscale
            trail.image_alpha = 1 / 10
            trail.depth = actor.depth
        end--this will probably be very laggy
            
        -- A convenience function that exits this state automatically once the animation ends
        actor:skill_util_exit_state_on_anim_end()
    end)

    state_scepter_special:onExit(function(actor, data)
        actor:skill_util_strafe_exit()
        actor.image_yscale = 1
        actor.y = actor.y - 6
        actor.image_alpha = 1
    end)

    state_scepter_special:onGetInterruptPriority(function(actor, data)
        if actor.image_index2 <= 2 then
            return State.ACTOR_STATE_INTERRUPT_PRIORITY.priority_skill
        else
            return State.ACTOR_STATE_INTERRUPT_PRIORITY.skill_interrupt_period
        end
    end)

    
    
end
Initialize(initialize)

-- ** Uncomment the two lines below to re-call initialize() on hotload **
-- if hotload then initialize() end
-- hotload = true


gm.post_script_hook(gm.constants.__input_system_tick, function(self, other, result, args)
    -- This is an example of a hook
    -- This hook in particular will run every frame after it has finished loading (i.e., "Hopoo Games" appears)
    -- You can hook into any function in the game
    -- Use pre_script_hook 'stead to run code before the function
    -- https://github.com/return-of-modding/ReturnOfModding/blob/master/docs/lua/tables/gm.md
    
end)