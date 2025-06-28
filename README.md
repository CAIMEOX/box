# Box

This library provides a set of combinators for creating and manipulating two-dimensional text layouts, inspired by [Box combinators](https://mmapped.blog/posts/41-box-combinators). It's perfect for creating ASCII art, diagrams, charts, and other visual representations in text.

## Core Concepts

- **Box**: A rectangular area containing text data
- **Combinators**: Functions that combine boxes in various ways
- **Alignment**: Control how boxes are positioned relative to each other

## Basic Usage

### Creating Boxes

```moonbit
// Create a single character box
let star = singleton('*')

// Create filled rectangles
let rect = fill('█', 3, 5)  // 3 rows, 5 columns of █

// Create empty space
let gap = space(2, 4)  // 2 rows, 4 columns of spaces
```

### Combining Boxes

```moonbit
// Place boxes side by side
let horizontal = box1.beside(box2)

// Stack boxes vertically
let vertical = box1.above(box2)

// Combine multiple boxes
let combined = hconcat([box1, box2, box3])  // horizontal
let stacked = vconcat([box1, box2, box3])   // vertical
```

## Examples

### Sierpinski Triangle

Create fractal triangles:

```moonbit
fn sierpinski(n) {
  guard n > 0 else { singleton('*') }
  let s = sierpinski(n - 1)
  s.above([s, singleton(' '), s] |> hconcat())
}

sierpinski(4)
```

Output:

```plaintext
       *       
      * *      
     *   *     
    * * * *    
   *       *   
  * *     * *  
 *   *   *   * 
* * * * * * * *
```

### Diamond Pattern

Create diamond shapes:

```moonbit
fn diamond(size : Int) -> Box {
  let lines = []
  // Top half including middle
  for i = 0; i <= size; i = i + 1 {
    let spaces = size - i
    let stars = 2 * i + 1
    let line = space(1, spaces)
      .beside(fill('*', 1, stars))
      .beside(space(1, spaces))
    lines.push(line)
  }
  // Bottom half
  for i = size - 1; i >= 0; i = i - 1 {
    let spaces = size - i
    let stars = 2 * i + 1
    let line = space(1, spaces)
      .beside(fill('*', 1, stars))
      .beside(space(1, spaces))
    lines.push(line)
  }
  vconcat(lines)
}
```

Sample output:

```plaintext
    *    
   ***   
  *****  
 *******
**********
 *******
  *****
   ***
    *
```

### Bar Chart

Create visual data representations:

```moonbit
fn bar_chart(values : Array[Int]) -> Box {
  let max_val = values.fold(init=0, fn(a, b) { if b > a { b } else { a } })
  let bars = values.map(fn(v) {
    let height = v * 10 / max_val + 1
    fill('█', height, 3).above(
      v.to_string().iter().map(singleton).to_array() |> hconcat(),
    )
  })
  hconcat(bars, align=Bottom)
}
```

### Spiral Patterns

Create nested rectangular spirals:

```moonbit
fn spiral(n : Int) -> Box {
  if n <= 0 {
    singleton('+')
  } else {
    let s = spiral(n - 1)
    let (h, w) = s.dimensions()
    let vbar = fill('|', h, 1)
    grid([
      [
        singleton('|').beside(singleton(' ')).beside(singleton('+')),
        fill('-', 1, w),
        singleton('+'),
      ],
      [vbar, singleton(' '), s, singleton(' '), vbar],
      [singleton('+'), fill('-', 1, w + 2), singleton('+')],
    ])
  }
}
```

Output:

```plaintext
| +-------------------------------------+
| | +---------------------------------+ |
| | | +-----------------------------+ | |
| | | | +-------------------------+ | | |
| | | | | +---------------------+ | | | |
| | | | | | +-----------------+ | | | | |
| | | | | | | +-------------+ | | | | | |
| | | | | | | | +---------+ | | | | | | |
| | | | | | | | | +-----+ | | | | | | | |
| | | | | | | | | | +-+ | | | | | | | | |
| | | | | | | | | | + | | | | | | | | | |
| | | | | | | | | +---+ | | | | | | | | |
| | | | | | | | +-------+ | | | | | | | |
| | | | | | | +-----------+ | | | | | | |
| | | | | | +---------------+ | | | | | |
| | | | | +-------------------+ | | | | |
| | | | +-----------------------+ | | | |
| | | +---------------------------+ | | |
| | +-------------------------------+ | |
| +-----------------------------------+ |
+---------------------------------------+
```

### Binary Tree

Create tree structures:

```moonbit
fn binary_tree(depth : Int) -> Box {
  if depth <= 0 {
    singleton('*')
  } else {
    let left = binary_tree(depth - 1)
    let right = binary_tree(depth - 1)
    let root = singleton('*')
    let branches = [left, space(1, 3), right] |> hconcat()
    root.above(branches)
  }
}
```

Output:

```plaintext
              *              
      *               *      
  *       *       *       *  
*   *   *   *   *   *   *   *
```

## API Reference

### Core Types

- `Box`: The main type representing a rectangular text area
- `Vertical`: Alignment enum (Top, Center, Bottom)
- `Horizontal`: Alignment enum (Left, Center, Right)

### Creation Functions

- `singleton(c)`: Create a 1x1 box with character `c`
- `fill(c, h, w)`: Create an `h`×`w` box filled with character `c`
- `space(h, w)`: Create an `h`×`w` box filled with spaces
- `empty()`: Create an empty box

### Combination Functions

- `beside(other, align~)`: Place boxes horizontally
- `above(other, align~)`: Stack boxes vertically
- `hconcat(boxes, align~)`: Combine array of boxes horizontally
- `vconcat(boxes, align~)`: Combine array of boxes vertically
- `grid(matrix)`: Arrange boxes in a 2D grid

### Utility Functions

- `dimensions()`: Get (height, width) of a box
- `height()`: Get height of a box
- `width()`: Get width of a box
- `widen(w, align~)`: Expand box width
- `heighten(h, align~)`: Expand box height
- `framed()`: Add a border around a box

## Advanced Examples

The library can create complex patterns including:

- **Cantor Set**: Mathematical fractal dust patterns
- **Julia Set**: Complex number fractals
- **Tree Fractals**: Recursive branching structures
- **Square Spirals**: Nested square patterns with Unicode box-drawing characters

See the test cases in `examples.mbt` for complete implementations of these patterns.
