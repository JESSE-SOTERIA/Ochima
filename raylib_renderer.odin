//the deem renderer for clay based on odin
package deep

import clay "/clay/clay-odin/clay-odin"
import renderer "clay/clay-odin/raylib_renderer"
import "core:c"
import "core:fmt"
import rl "vendor:raylib"

window_width: i32 = 1024
window_height: i32 = 768

target_fps : i32 = 60

font_id_default :: 0

//TODO: make sure to insert color values in these fields.
color_light :: clay.Color({255, 0, 0, 255})
color_dark :: clay.Color({0, 255, 0, 255})
color_neutral :: clay.Color({0, 0, 255, 255})
color_accent :: clay.Color({255, 255, 0, 001})

animation_lerp_value: f32 = -1.0

raylib_font := renderer.RaylibFont{}

load_font :: proc(fontId: u16, fontSize: u16, path: cstring) {
  raylib_font = renderer.RaylibFont {
    font = rl.LoadFontEx(path, cast(i32)fontSize * 2, nil, 0), 
    fontId = cast(u16)fontId,
  }

  rl.GenTextureMipmaps(&raylib_font.font.texture)
  rl.SetTextureFilter(raylib_font.font.texture, rl.TextureFilter.TRILINEAR)
}

sample_string : string = "God is good"

createLayout :: proc(lerp_value: f32, text: string) -> clay.ClayArray(clay.RenderCommand) {
  mobile_screen : bool = window_width < 750 
  clay.BeginLayout()

  if clay.UI(
    clay.ID("outer_container"), 
    clay.Layout({layoutDirection = .TOP_TO_BOTTOM, padding = {x = 16, y = 8}, sizing = {clay.SizingGrow({}),clay.SizingGrow({})}}),
    clay.Rectangle({color = color_accent}),
  ) {
  /*this just means there are no children*/
      clay.Text(text, clay.TextConfig({
      fontId = font_id_default,
      fontSize = 16,
      textColor = {255, 0, 255, 255},
      }))
  }
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
  rl.SetTargetFPS(target_fps)

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

        clay.SetPointerState(transmute(clay.Vector2)rl.GetMousePosition(), rl.IsMouseButtonDown(rl.MouseButton.LEFT))
        clay.UpdateScrollContainers(false, transmute(clay.Vector2)rl.GetMouseWheelMoveV(), rl.GetFrameTime())
        clay.SetLayoutDimensions({cast(f32)rl.GetScreenWidth(), cast(f32)rl.GetScreenHeight()})
        renderCommands: clay.ClayArray(clay.RenderCommand) = createLayout(animation_lerp_value< 0 ? (animation_lerp_value+ 1) : (1 - animation_lerp_value), sample_string)
        rl.BeginDrawing()
        renderer.clayRaylibRender(&renderCommands)
        rl.EndDrawing()
    }
}

