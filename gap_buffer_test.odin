package deep

import "core:testing"
import "core:fmt"

@(test)
test_grow_gap_buffer :: proc(t: testing.T) {

}

@(test)
test_text_length :: proc(t: testing.T) {

}

@(test)
test_init_gap_buffer:: proc(t: ^testing.T) {
    buffer, ok := gb.init_gap_buffer(10)
    defer gb.free_gap_buffer(&buffer)
    testing.expect(t, ok, "Initialization failed")
    testing.expect(t, buffer.gap_start == 0, "Gap start should be 0")
    testing.expect(t, buffer.gap_end == 10, "Gap end should be capacity")
    testing.expect(t, gb.text_length(&buffer) == 0, "Initial text length should be 0")
}

@(test)
test_insert :: proc(t: ^testing.T) {
    buffer, _ := gb.init_gap_buffer(10)
    defer gb.free_gap_buffer(&buffer)
    ok := gb.insert(&buffer, "Hello")
    testing.expect(t, ok, "Insertion failed")
    testing.expect(t, buffer.gap_start == 5, "Gap start should move after insertion")
    testing.expect(t, gb.to_string(&buffer) == "Hello", "Text should match inserted string")
}

@(test)
test_move_cursor:: proc(t: ^testing.T) {
    buffer, _ := gb.init_gap_buffer(10)
    defer gb.free_gap_buffer(&buffer)
    gb.insert(&buffer, "Hello")
    gb.move_cursor(&buffer, 2)
    testing.expect(t, buffer.gap_start == 2, "Cursor should be at position 2")
    testing.expect(t, buffer.gap_end == 7, "Gap end should adjust")
    gb.insert(&buffer, "y")
    testing.expect(t, gb.to_string(&buffer) == "Heyllo", "Insertion at cursor should work")
}

@(test)
test_grow_gap_buffer:: proc(t: ^testing.T) {
    buffer, _ := gb.init_gap_buffer(5)
    defer gb.free_gap_buffer(&buffer)
    gb.insert(&buffer, "Hello World")
    testing.expect(t, gb.to_string(&buffer) == "Hello World", "Buffer should grow and insert correctly")
    testing.expect(t, buffer.capacity >= 11, "Capacity should increase")
}

@(test)
test_edge_cases :: proc(t: ^testing.T) {
    buffer, _ := gb.init_gap_buffer(5)
    defer gb.free_gap_buffer(&buffer)
    // Empty insertion
    gb.insert(&buffer, "")
    testing.expect(t, gb.text_length(&buffer) == 0, "Empty insertion should not change length")
    // Cursor out of bounds
    gb.insert(&buffer, "abc")
    gb.move_cursor(&buffer, -1) // Should ignore
    testing.expect(t, buffer.gap_start == 3, "Negative cursor should not move")
    gb.move_cursor(&buffer, 5) // Should ignore
    testing.expect(t, buffer.gap_start == 3, "Beyond-length cursor should not move")
}

main :: proc() {
    t := testing.T{}
    test_initialization(&t)
    test_insertion(&t)
    test_cursor_movement(&t)
    test_growth(&t)
    test_edge_cases(&t)
    fmt.printf("Tests passed: %v\n", !t.failed)
}
