const platform = @import("platform.zig");
const null_platform = @import("null_platform.zig");

pub fn connect() platform.Platform {
    return platform.Platform {
        .platformID = platform.PlatformEnum.GLFW_PLATFORM_NULL,
        .init = init,
        .terminate = terminate,
        .get_cursor_pos = get_cursor_pos,
        .set_cursor_pos = set_cursor_pos,
        .set_cursor_mode = set_cursor_mode,
        .set_raw_mouse_motion = set_raw_mouse_motion,
        .raw_mouse_motion_supported = raw_mouse_motion_supported,
        .create_cursor = create_cursor,
        .create_standard_cursor = create_standard_cursor,
        .destroy_cursor = destroy_cursor,
        .set_cursor = set_cursor,
        .get_scancode_name = get_scancode_name,
        .get_key_scancode = get_key_scancode,
        .set_clipboard_string = set_clipboard_string,
        .get_clipboard_string = get_clipboard_string,
        .init_joysticks = init_joysticks,
        .terminate_joysticks = terminate_joysticks,
        .poll_joystick = poll_joystick,
        .get_mapping_name = get_mapping_name,
        .update_gamepad_guid = update_gamepad_guid,
        .free_monitor = free_monitor,
        .get_monitor_pos = get_monitor_pos,
        .get_monitor_content_scale = get_monitor_content_scale,
        .get_monitor_workarea = get_monitor_workarea,
        .get_video_modes = get_video_modes,
        .get_video_mode = get_video_mode,
        .get_gamma_ramp = get_gamma_ramp,
        .set_gamma_ramp = set_gamma_ramp,
        .create_window = create_window,
        .destroy_window = destroy_window,
        .set_window_title = set_window_title,
        .set_window_icon = set_window_icon,
        .get_window_pos = get_window_pos,
        .set_window_pos = set_window_pos,
        .get_window_size = get_window_size,
        .set_window_size = set_window_size,
        .set_window_size_limits = set_window_size_limits,
        .set_window_aspect_ratio = set_window_aspect_ratio,
        .get_framebuffer_size = get_framebuffer_size,
        .get_window_frame_size = get_window_frame_size,
        .get_window_content_scale = get_window_content_scale,
        .iconify_window = iconify_window,
        .restore_window = restore_window,
        .maximize_window = maximize_window,
        .show_window = show_window,
        .hide_window = hide_window,
        .request_window_attention = request_window_attention,
        .focus_window = focus_window,
        .set_window_monitor = set_window_monitor,
        .window_focused = window_focused,
        .window_iconified = window_iconified,
        .window_visible = window_visible,
        .window_maximized = window_maximized,
        .window_hovered = window_hovered,
        .framebuffer_transparent = framebuffer_transparent,
        .get_window_opacity = get_window_opacity,
        .set_window_resizable = set_window_resizable,
        .set_window_decorated = set_window_decorated,
        .set_window_floating = set_window_floating,
        .set_window_opacity = set_window_opacity,
        .set_window_mouse_passthrough = set_window_mouse_passthrough,
        .poll_events = poll_events,
        .wait_events = wait_events,
        .post_empty_event = post_empty_event,
        .get_egl_platform = get_egl_platform,
        .get_egl_native_display = get_egl_native_display,
        .get_egl_native_window = get_egl_native_window,
        .get_required_instance_extensions = get_required_instance_extensions,
        .get_physical_device_presentation_support = get_physical_device_presentation_support,
        .create_window_surface = create_window_surface
    };
}

pub fn init() void {
    memset(_glfw.null.keycodes, -1, sizeof(_glfw.null.keycodes));
    memset(_glfw.null.scancodes, -1, sizeof(_glfw.null.scancodes));

    _glfw.null.keycodes[GLFW_NULL_SC_SPACE]         = GLFW_KEY_SPACE;
    _glfw.null.keycodes[GLFW_NULL_SC_APOSTROPHE]    = GLFW_KEY_APOSTROPHE;
    _glfw.null.keycodes[GLFW_NULL_SC_COMMA]         = GLFW_KEY_COMMA;
    _glfw.null.keycodes[GLFW_NULL_SC_MINUS]         = GLFW_KEY_MINUS;
    _glfw.null.keycodes[GLFW_NULL_SC_PERIOD]        = GLFW_KEY_PERIOD;
    _glfw.null.keycodes[GLFW_NULL_SC_SLASH]         = GLFW_KEY_SLASH;
    _glfw.null.keycodes[GLFW_NULL_SC_0]             = GLFW_KEY_0;
    _glfw.null.keycodes[GLFW_NULL_SC_1]             = GLFW_KEY_1;
    _glfw.null.keycodes[GLFW_NULL_SC_2]             = GLFW_KEY_2;
    _glfw.null.keycodes[GLFW_NULL_SC_3]             = GLFW_KEY_3;
    _glfw.null.keycodes[GLFW_NULL_SC_4]             = GLFW_KEY_4;
    _glfw.null.keycodes[GLFW_NULL_SC_5]             = GLFW_KEY_5;
    _glfw.null.keycodes[GLFW_NULL_SC_6]             = GLFW_KEY_6;
    _glfw.null.keycodes[GLFW_NULL_SC_7]             = GLFW_KEY_7;
    _glfw.null.keycodes[GLFW_NULL_SC_8]             = GLFW_KEY_8;
    _glfw.null.keycodes[GLFW_NULL_SC_9]             = GLFW_KEY_9;
    _glfw.null.keycodes[GLFW_NULL_SC_SEMICOLON]     = GLFW_KEY_SEMICOLON;
    _glfw.null.keycodes[GLFW_NULL_SC_EQUAL]         = GLFW_KEY_EQUAL;
    _glfw.null.keycodes[GLFW_NULL_SC_A]             = GLFW_KEY_A;
    _glfw.null.keycodes[GLFW_NULL_SC_B]             = GLFW_KEY_B;
    _glfw.null.keycodes[GLFW_NULL_SC_C]             = GLFW_KEY_C;
    _glfw.null.keycodes[GLFW_NULL_SC_D]             = GLFW_KEY_D;
    _glfw.null.keycodes[GLFW_NULL_SC_E]             = GLFW_KEY_E;
    _glfw.null.keycodes[GLFW_NULL_SC_F]             = GLFW_KEY_F;
    _glfw.null.keycodes[GLFW_NULL_SC_G]             = GLFW_KEY_G;
    _glfw.null.keycodes[GLFW_NULL_SC_H]             = GLFW_KEY_H;
    _glfw.null.keycodes[GLFW_NULL_SC_I]             = GLFW_KEY_I;
    _glfw.null.keycodes[GLFW_NULL_SC_J]             = GLFW_KEY_J;
    _glfw.null.keycodes[GLFW_NULL_SC_K]             = GLFW_KEY_K;
    _glfw.null.keycodes[GLFW_NULL_SC_L]             = GLFW_KEY_L;
    _glfw.null.keycodes[GLFW_NULL_SC_M]             = GLFW_KEY_M;
    _glfw.null.keycodes[GLFW_NULL_SC_N]             = GLFW_KEY_N;
    _glfw.null.keycodes[GLFW_NULL_SC_O]             = GLFW_KEY_O;
    _glfw.null.keycodes[GLFW_NULL_SC_P]             = GLFW_KEY_P;
    _glfw.null.keycodes[GLFW_NULL_SC_Q]             = GLFW_KEY_Q;
    _glfw.null.keycodes[GLFW_NULL_SC_R]             = GLFW_KEY_R;
    _glfw.null.keycodes[GLFW_NULL_SC_S]             = GLFW_KEY_S;
    _glfw.null.keycodes[GLFW_NULL_SC_T]             = GLFW_KEY_T;
    _glfw.null.keycodes[GLFW_NULL_SC_U]             = GLFW_KEY_U;
    _glfw.null.keycodes[GLFW_NULL_SC_V]             = GLFW_KEY_V;
    _glfw.null.keycodes[GLFW_NULL_SC_W]             = GLFW_KEY_W;
    _glfw.null.keycodes[GLFW_NULL_SC_X]             = GLFW_KEY_X;
    _glfw.null.keycodes[GLFW_NULL_SC_Y]             = GLFW_KEY_Y;
    _glfw.null.keycodes[GLFW_NULL_SC_Z]             = GLFW_KEY_Z;
    _glfw.null.keycodes[GLFW_NULL_SC_LEFT_BRACKET]  = GLFW_KEY_LEFT_BRACKET;
    _glfw.null.keycodes[GLFW_NULL_SC_BACKSLASH]     = GLFW_KEY_BACKSLASH;
    _glfw.null.keycodes[GLFW_NULL_SC_RIGHT_BRACKET] = GLFW_KEY_RIGHT_BRACKET;
    _glfw.null.keycodes[GLFW_NULL_SC_GRAVE_ACCENT]  = GLFW_KEY_GRAVE_ACCENT;
    _glfw.null.keycodes[GLFW_NULL_SC_WORLD_1]       = GLFW_KEY_WORLD_1;
    _glfw.null.keycodes[GLFW_NULL_SC_WORLD_2]       = GLFW_KEY_WORLD_2;
    _glfw.null.keycodes[GLFW_NULL_SC_ESCAPE]        = GLFW_KEY_ESCAPE;
    _glfw.null.keycodes[GLFW_NULL_SC_ENTER]         = GLFW_KEY_ENTER;
    _glfw.null.keycodes[GLFW_NULL_SC_TAB]           = GLFW_KEY_TAB;
    _glfw.null.keycodes[GLFW_NULL_SC_BACKSPACE]     = GLFW_KEY_BACKSPACE;
    _glfw.null.keycodes[GLFW_NULL_SC_INSERT]        = GLFW_KEY_INSERT;
    _glfw.null.keycodes[GLFW_NULL_SC_DELETE]        = GLFW_KEY_DELETE;
    _glfw.null.keycodes[GLFW_NULL_SC_RIGHT]         = GLFW_KEY_RIGHT;
    _glfw.null.keycodes[GLFW_NULL_SC_LEFT]          = GLFW_KEY_LEFT;
    _glfw.null.keycodes[GLFW_NULL_SC_DOWN]          = GLFW_KEY_DOWN;
    _glfw.null.keycodes[GLFW_NULL_SC_UP]            = GLFW_KEY_UP;
    _glfw.null.keycodes[GLFW_NULL_SC_PAGE_UP]       = GLFW_KEY_PAGE_UP;
    _glfw.null.keycodes[GLFW_NULL_SC_PAGE_DOWN]     = GLFW_KEY_PAGE_DOWN;
    _glfw.null.keycodes[GLFW_NULL_SC_HOME]          = GLFW_KEY_HOME;
    _glfw.null.keycodes[GLFW_NULL_SC_END]           = GLFW_KEY_END;
    _glfw.null.keycodes[GLFW_NULL_SC_CAPS_LOCK]     = GLFW_KEY_CAPS_LOCK;
    _glfw.null.keycodes[GLFW_NULL_SC_SCROLL_LOCK]   = GLFW_KEY_SCROLL_LOCK;
    _glfw.null.keycodes[GLFW_NULL_SC_NUM_LOCK]      = GLFW_KEY_NUM_LOCK;
    _glfw.null.keycodes[GLFW_NULL_SC_PRINT_SCREEN]  = GLFW_KEY_PRINT_SCREEN;
    _glfw.null.keycodes[GLFW_NULL_SC_PAUSE]         = GLFW_KEY_PAUSE;
    _glfw.null.keycodes[GLFW_NULL_SC_F1]            = GLFW_KEY_F1;
    _glfw.null.keycodes[GLFW_NULL_SC_F2]            = GLFW_KEY_F2;
    _glfw.null.keycodes[GLFW_NULL_SC_F3]            = GLFW_KEY_F3;
    _glfw.null.keycodes[GLFW_NULL_SC_F4]            = GLFW_KEY_F4;
    _glfw.null.keycodes[GLFW_NULL_SC_F5]            = GLFW_KEY_F5;
    _glfw.null.keycodes[GLFW_NULL_SC_F6]            = GLFW_KEY_F6;
    _glfw.null.keycodes[GLFW_NULL_SC_F7]            = GLFW_KEY_F7;
    _glfw.null.keycodes[GLFW_NULL_SC_F8]            = GLFW_KEY_F8;
    _glfw.null.keycodes[GLFW_NULL_SC_F9]            = GLFW_KEY_F9;
    _glfw.null.keycodes[GLFW_NULL_SC_F10]           = GLFW_KEY_F10;
    _glfw.null.keycodes[GLFW_NULL_SC_F11]           = GLFW_KEY_F11;
    _glfw.null.keycodes[GLFW_NULL_SC_F12]           = GLFW_KEY_F12;
    _glfw.null.keycodes[GLFW_NULL_SC_F13]           = GLFW_KEY_F13;
    _glfw.null.keycodes[GLFW_NULL_SC_F14]           = GLFW_KEY_F14;
    _glfw.null.keycodes[GLFW_NULL_SC_F15]           = GLFW_KEY_F15;
    _glfw.null.keycodes[GLFW_NULL_SC_F16]           = GLFW_KEY_F16;
    _glfw.null.keycodes[GLFW_NULL_SC_F17]           = GLFW_KEY_F17;
    _glfw.null.keycodes[GLFW_NULL_SC_F18]           = GLFW_KEY_F18;
    _glfw.null.keycodes[GLFW_NULL_SC_F19]           = GLFW_KEY_F19;
    _glfw.null.keycodes[GLFW_NULL_SC_F20]           = GLFW_KEY_F20;
    _glfw.null.keycodes[GLFW_NULL_SC_F21]           = GLFW_KEY_F21;
    _glfw.null.keycodes[GLFW_NULL_SC_F22]           = GLFW_KEY_F22;
    _glfw.null.keycodes[GLFW_NULL_SC_F23]           = GLFW_KEY_F23;
    _glfw.null.keycodes[GLFW_NULL_SC_F24]           = GLFW_KEY_F24;
    _glfw.null.keycodes[GLFW_NULL_SC_F25]           = GLFW_KEY_F25;
    _glfw.null.keycodes[GLFW_NULL_SC_KP_0]          = GLFW_KEY_KP_0;
    _glfw.null.keycodes[GLFW_NULL_SC_KP_1]          = GLFW_KEY_KP_1;
    _glfw.null.keycodes[GLFW_NULL_SC_KP_2]          = GLFW_KEY_KP_2;
    _glfw.null.keycodes[GLFW_NULL_SC_KP_3]          = GLFW_KEY_KP_3;
    _glfw.null.keycodes[GLFW_NULL_SC_KP_4]          = GLFW_KEY_KP_4;
    _glfw.null.keycodes[GLFW_NULL_SC_KP_5]          = GLFW_KEY_KP_5;
    _glfw.null.keycodes[GLFW_NULL_SC_KP_6]          = GLFW_KEY_KP_6;
    _glfw.null.keycodes[GLFW_NULL_SC_KP_7]          = GLFW_KEY_KP_7;
    _glfw.null.keycodes[GLFW_NULL_SC_KP_8]          = GLFW_KEY_KP_8;
    _glfw.null.keycodes[GLFW_NULL_SC_KP_9]          = GLFW_KEY_KP_9;
    _glfw.null.keycodes[GLFW_NULL_SC_KP_DECIMAL]    = GLFW_KEY_KP_DECIMAL;
    _glfw.null.keycodes[GLFW_NULL_SC_KP_DIVIDE]     = GLFW_KEY_KP_DIVIDE;
    _glfw.null.keycodes[GLFW_NULL_SC_KP_MULTIPLY]   = GLFW_KEY_KP_MULTIPLY;
    _glfw.null.keycodes[GLFW_NULL_SC_KP_SUBTRACT]   = GLFW_KEY_KP_SUBTRACT;
    _glfw.null.keycodes[GLFW_NULL_SC_KP_ADD]        = GLFW_KEY_KP_ADD;
    _glfw.null.keycodes[GLFW_NULL_SC_KP_ENTER]      = GLFW_KEY_KP_ENTER;
    _glfw.null.keycodes[GLFW_NULL_SC_KP_EQUAL]      = GLFW_KEY_KP_EQUAL;
    _glfw.null.keycodes[GLFW_NULL_SC_LEFT_SHIFT]    = GLFW_KEY_LEFT_SHIFT;
    _glfw.null.keycodes[GLFW_NULL_SC_LEFT_CONTROL]  = GLFW_KEY_LEFT_CONTROL;
    _glfw.null.keycodes[GLFW_NULL_SC_LEFT_ALT]      = GLFW_KEY_LEFT_ALT;
    _glfw.null.keycodes[GLFW_NULL_SC_LEFT_SUPER]    = GLFW_KEY_LEFT_SUPER;
    _glfw.null.keycodes[GLFW_NULL_SC_RIGHT_SHIFT]   = GLFW_KEY_RIGHT_SHIFT;
    _glfw.null.keycodes[GLFW_NULL_SC_RIGHT_CONTROL] = GLFW_KEY_RIGHT_CONTROL;
    _glfw.null.keycodes[GLFW_NULL_SC_RIGHT_ALT]     = GLFW_KEY_RIGHT_ALT;
    _glfw.null.keycodes[GLFW_NULL_SC_RIGHT_SUPER]   = GLFW_KEY_RIGHT_SUPER;
    _glfw.null.keycodes[GLFW_NULL_SC_MENU]          = GLFW_KEY_MENU;

    for (null_platform.ScancodeEnum) |scancode|
    {
        if (_glfw.null.keycodes[scancode] > 0)
            _glfw.null.scancodes[_glfw.null.keycodes[scancode]] = scancode;
    }

    _glfwPollMonitorsNull();
    return GLFW_TRUE;
}

pub fn terminate() void {
    //free(_glfw.null.clipboardString);
    //_glfwTerminateOSMesa();
    //_glfwTerminateEGL();
}
