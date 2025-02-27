//the deem renderer for clay based on odin
package deep

import clay "/clay/clay-odin/clay-odin"
import renderer "clay/clay-odin/raylib_renderer"
import "core:c"
import "core:fmt"
import rl "vendor:raylib"

window_width: i32 = 1024
window_height: i32 = 768

font_id_default :: 0

//TODO: make sure to insert color values in these fields.
color_light :: clay.Color({255, 0, 0, 255})
color_dark :: clay.Color({0, 255, 0, 255})
color_neutral :: clay.Color({0, 0, 255, 255})
color_accent :: clay.Color({255, 255, 0, 001})

animation_lerp_value: f32 = -1.0

raylibFonts := [10]renderer.RaylibFont{}

load_font :: proc(fontId: u16, fontSize: u16, path: cstring) {
    raylibFonts[fontId] = renderer.RaylibFont {
        font   = rl.LoadFontEx(path, cast(i32)fontSize * 2, nil, 0),
        fontId = cast(u16)fontId,
    }
    rl.SetTextureFilter(raylibFonts[fontId].font.texture, rl.TextureFilter.TRILINEAR)
}

//measureText:: proc "c" (text: ^clay.String, config: ^clay.TextElementConfig) ->clay.Dimensions {
//  text_size : clay.Dimensions = {0,0}
//
//  max_text_width : f32 = 0
//  line_text_width : f32 = 0
//
//  text_height := cast(f32)config.fontSize
//  font_to_use := raylibFonts[config.fontId].font
//
//    for i in 0 ..< int(text.length) {
//        if (text.chars[i] == '\n') {
//            max_text_width = max(max_text_width, line_text_width)
//            line_text_width = 0
//            continue
//        }
//        index := cast(i32)text.chars[i] - 32
//        if (font_to_use.glyphs[index].advanceX != 0) {
//            line_text_width += cast(f32)font_to_use.glyphs[index].advanceX
//        } else {
//            line_text_width += (font_to_use.recs[index].width + cast(f32)font_to_use.glyphs[index].offsetX)
//        }
//    }
//
//  max_text_width = max(max_text_width, line_text_width)
//
//  text_size.width = max_text_width/2
//  text_size.height = text_height
//
//  return text_size
//}
//
sample_string : string = "this is the thing that I wanted to render in the somethign int healkfj"

createLayout :: proc(lerp_value: f32) -> clay.ClayArray(clay.RenderCommand) {
  mobile_screen : bool = window_width < 750 
  clay.BeginLayout()

  if clay.UI(
    clay.ID("outer_container"), 
    clay.Layout({layoutDirection = .TOP_TO_BOTTOM, sizing = {clay.SizingGrow({}),clay.SizingGrow({})}}),
    clay.Rectangle({color = color_accent}),
  ) {/*this just means there are no children*/}
 
  return clay.EndLayout()
}

main :: proc() {
  min_memory_size : u32 = clay.MinMemorySize()
  memory := make([^]u8, min_memory_size)
  arena : clay.Arena = clay.CreateArenaWithCapacityAndMemory(min_memory_size, memory)
  clay.SetMeasureTextFunction(renderer.measureText)
  clay.Initialize(arena, {cast(f32)rl.GetScreenWidth(), cast(f32)rl.GetScreenHeight()})


  rl.SetConfigFlags({.VSYNC_HINT, .WINDOW_RESIZABLE, .WINDOW_HIGHDPI, .MSAA_4X_HINT})
  rl.InitWindow(window_width, window_height, "diatiro")
  rl.SetTargetFPS(rl.GetMonitorRefreshRate(0))

  load_font(font_id_default, 16, "C:/Windows/Fonts/arial.ttf")

  clay.SetDebugModeEnabled(false)

    for !rl.WindowShouldClose() {
        defer free_all(context.temp_allocator)

        animation_lerp_value += rl.GetFrameTime()
        if animation_lerp_value> 1 {
            animation_lerp_value = animation_lerp_value- 2
        }
        window_width = rl.GetScreenWidth()
        window_height = rl.GetScreenHeight()

    //TODO: research on the new version of debug mode and how we can do the checks below with the new style of just calling a function.
        //if (rl.IsKeyPressed(.D)) {
        //    debugModeEnabled = !debugModeEnabled
        //    clay.SetDebugModeEnabled(debugModeEnabled)
        //}

        clay.SetPointerState(transmute(clay.Vector2)rl.GetMousePosition(), rl.IsMouseButtonDown(rl.MouseButton.LEFT))
        clay.UpdateScrollContainers(false, transmute(clay.Vector2)rl.GetMouseWheelMoveV(), rl.GetFrameTime())
        clay.SetLayoutDimensions({cast(f32)rl.GetScreenWidth(), cast(f32)rl.GetScreenHeight()})
        renderCommands: clay.ClayArray(clay.RenderCommand) = createLayout(animation_lerp_value< 0 ? (animation_lerp_value+ 1) : (1 - animation_lerp_value))
        rl.BeginDrawing()
        renderer.clayRaylibRender(&renderCommands)
        rl.EndDrawing()
    }
}

