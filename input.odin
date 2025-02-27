package deep
//
//import rl"vendor:raylib"
//import "core:fmt"
//
//key : rl.KeyboardKey
//
//handle_keyboard_input :: proc(gb: ^Gap_buffer, key: rl.KeyboardKey)  {
//  if rl.IsKeyPressed(.BACKSPACE) {
//    move_cursor(gb, gb.gap_start - 1)
//  } else if rl.IsKeyPressed(.ENTER) {
//    fmt.println("enter key pressed")
//    insert(gb, `\n`)
//  } else if rl.IsKeyPressed(.RIGHT) {
//    if gb.gap_start < gb.capacity {
//      move_cursor(gb, (gb.gap_start + 1))
//    } //otherwise do nothing (don't advance the cursor because it is at the end of the string)
//  } else if rl.IsKeyPressed(.LEFT) {
//    if gb.gap_start > 0{
//      move_cursor(gb, (gb.gap_start - 1))
//    } //otherwise do nothing (don't advance the cursor because it is at the start of the string)
//  } else {
//    char : []u8 
//    //regular character input
//    for current_key := 1; current_key < 512; current_key += 1 {
//      if rl.IsKeyPressed(rl.KeyboardKey(current_key)){
//      //capture the character associated with the key
//      char = get_char_for_key(rl.KeyboardKey(current_key))
//      //insert the character into the gap buffer
//        insert(gb, char)
//        break
//      }
//    }
//  }
//}
//
//get_char_for_key :: proc(char: rl.KeyboardKey) -> []u8{
//
//}
