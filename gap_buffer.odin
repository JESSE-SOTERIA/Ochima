package deep 
//
////TODO: 
// /* make the data structure more sane
//  - make the buffer appropriate to store codepoint characters to support multiple languages.
//  - check and understand each function that is directly related to the data structure.
//  - study and understand the complexity of the operations of the data structure.
//  - check potential for memory leaks and errors, edge cases for cursor movement
//  - make sure the text that is passed onto the renderer is always a string that the renderer can handle.
//  - change the chosen allocator to context.allocator
//*/
//
//import "core:mem"
//import "core:unicode/utf8"
//
//
//Gap_buffer :: struct {
//  buffer   : []u8,
//  gap_start: int, 
//  gap_end  : int, 
//  capacity : int,
//}
//
////initialize new gap buffer with given capacity
//@(require_results)
//init_gap_buffer :: proc(capacity: int, allocator:= context.allocator) -> (buffer:Gap_buffer, success: mem.Allocator_Error) {
// buf := make([]u8, capacity, allocator) or_return
//  return Gap_buffer {
//    buffer = buf, 
//    gap_start = 0,
//    gap_end = capacity,
//    capacity = capacity,
//  }, mem.Allocator_Error.None
//}
//
////free the gap buffer
//free_gap_buffer :: proc(gb: ^Gap_buffer) {
//  delete(gb.buffer)
//  gb^ = {}
//}
//
//// insert a string at the cursor
////TODO: should we loop to text_len or to < text_len because of the null terminated C strings?
//insert :: proc(gb: ^Gap_buffer, character: []rune) -> bool{
//  // to handle utf8 text
//  utf8_buf := utf8.runes_to_string(character)
//  utf8.rune_count_in_bytes()
//  byte_count := size_of(utf8_buf)
//    // Check if there's enough space in the gap
//    gap_size := gb.gap_end - gb.gap_start
//    if gap_size < byte_count {
//
//    post_size := gb.capacity - gb.gap_end
//    //pre_size is just gap_start
//        // Resize the buffer
//        new_capacity := max(len(gb.buffer) * 2, len(gb.buffer) + byte_count)
//        new_data := make([]u8, new_capacity)
//        //new_gap_size := new_capacity - gap_buffer_len(gb)
//
//        // Copy pre-gap and post-gap content
//        copy(new_data[0:gb.gap_start], gb.buffer[0:gb.gap_start])
//        copy(new_data[new_capacity:], gb.buffer[gb.gap_end:])
//
//
//    }
//
//    // Insert the UTF-8 bytes into the gap
//    for i in 0..<byte_count {
//        gb.data[gb.gap_start + i] = utf8_bytes[i]
//    }
//    gb.gap_start += byte_count
//}
//
////Move the cursor to a new position
//move_cursor :: proc(gb: ^Gap_buffer, new_position: int) {
//  if new_position < 0 || new_position > text_length(gb) do return
//  for new_position < gb.gap_start {
//    gb.gap_end -= 1
//    gb.gap_start -= 1
//    gb.buffer[gb.gap_end] = gb.buffer[gb.gap_start]
//  }
//
//  for new_position > gb.gap_start {
//    gb.buffer[gb.gap_start] = gb.buffer[gb.gap_end]
//    gb.gap_start += 1
//    gb.gap_end += 1
//  }
//}
//
////get the total text lenghth exclusive of the gap
//text_length :: proc(gb: ^Gap_buffer) -> int{
//  return gb.capacity - (gb.gap_end- gb.gap_start) 
//}
//
////grow the buffer when the gap is too small
//grow_gap_buffer :: proc(gb: ^Gap_buffer, min_additional: int, allocator := context.allocator) -> (success: mem.Allocator_Error){
//  new_capacity := gb.capacity *  2 + min_additional
//  new_buffer := make([]u8, new_capacity, allocator) or_return
//
//  //copy pre_gap
//  copy(new_buffer[0:gb.gap_start], gb.buffer[0:gb.gap_start])
//  //copy post_gap to new position
//  new_gap_end := new_capacity - (gb.capacity - gb.gap_end)
//  copy(new_buffer[new_gap_end:], gb.buffer[gb.gap_end:])
//
//  //free old buffer and update
//  delete(gb.buffer)
//  gb.buffer = new_buffer
//  gb.gap_end = new_gap_end
//  gb.capacity = new_capacity
//
//  return success
//}
//
////get the full text as a string
//to_string :: proc(gb: ^Gap_buffer, allocator:= context.allocator) -> string {
//  total_len := text_length(gb)
//  result := make([]u8, total_len, allocator)
//  copy(result[0:gb.gap_start], gb.buffer[0:gb.gap_start])
//  copy(result[gb.gap_start:], gb.buffer[gb.gap_end:])
//  return string(result)
//}
