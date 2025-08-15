///|
test "sierpinski" {
  fn sierpinski(n) {
    guard n > 0 else { singleton('*') }
    let s = sierpinski(n - 1)
    s.above([s, singleton(' '), s] |> hconcat())
  }

  inspect(
    sierpinski(5).to_string(),
    content=(
      #|                               *                               
      #|                              * *                              
      #|                             *   *                             
      #|                            * * * *                            
      #|                           *       *                           
      #|                          * *     * *                          
      #|                         *   *   *   *                         
      #|                        * * * * * * * *                        
      #|                       *               *                       
      #|                      * *             * *                      
      #|                     *   *           *   *                     
      #|                    * * * *         * * * *                    
      #|                   *       *       *       *                   
      #|                  * *     * *     * *     * *                  
      #|                 *   *   *   *   *   *   *   *                 
      #|                * * * * * * * * * * * * * * * *                
      #|               *                               *               
      #|              * *                             * *              
      #|             *   *                           *   *             
      #|            * * * *                         * * * *            
      #|           *       *                       *       *           
      #|          * *     * *                     * *     * *          
      #|         *   *   *   *                   *   *   *   *         
      #|        * * * * * * * *                 * * * * * * * *        
      #|       *               *               *               *       
      #|      * *             * *             * *             * *      
      #|     *   *           *   *           *   *           *   *     
      #|    * * * *         * * * *         * * * *         * * * *    
      #|   *       *       *       *       *       *       *       *   
      #|  * *     * *     * *     * *     * *     * *     * *     * *  
      #| *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   * 
      #|* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    ),
  )
}

///|
test "spiral" {
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

  inspect(
    spiral(10),
    content=(
      #|| +-------------------------------------+
      #|| | +---------------------------------+ |
      #|| | | +-----------------------------+ | |
      #|| | | | +-------------------------+ | | |
      #|| | | | | +---------------------+ | | | |
      #|| | | | | | +-----------------+ | | | | |
      #|| | | | | | | +-------------+ | | | | | |
      #|| | | | | | | | +---------+ | | | | | | |
      #|| | | | | | | | | +-----+ | | | | | | | |
      #|| | | | | | | | | | +-+ | | | | | | | | |
      #|| | | | | | | | | | + | | | | | | | | | |
      #|| | | | | | | | | +---+ | | | | | | | | |
      #|| | | | | | | | +-------+ | | | | | | | |
      #|| | | | | | | +-----------+ | | | | | | |
      #|| | | | | | +---------------+ | | | | | |
      #|| | | | | +-------------------+ | | | | |
      #|| | | | +-----------------------+ | | | |
      #|| | | +---------------------------+ | | |
      #|| | +-------------------------------+ | |
      #|| +-----------------------------------+ |
      #|+---------------------------------------+
    ),
  )
}

///|
test "binary tree" {
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

  inspect(
    binary_tree(3),
    content=(
      #|              *              
      #|      *               *      
      #|  *       *       *       *  
      #|*   *   *   *   *   *   *   *
    ),
  )
  inspect(
    binary_tree(4),
    content=(
      #|                              *                              
      #|              *                               *              
      #|      *               *               *               *      
      #|  *       *       *       *       *       *       *       *  
      #|*   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *
    ),
  )
}

///|
test "diamond" {
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

  inspect(
    diamond(3),
    content=(
      #|   *   
      #|  ***  
      #| ***** 
      #|*******
      #| ***** 
      #|  ***  
      #|   *   
    ),
  )
  inspect(
    diamond(8),
    content=(
      #|        *        
      #|       ***       
      #|      *****      
      #|     *******     
      #|    *********    
      #|   ***********   
      #|  *************  
      #| *************** 
      #|*****************
      #| *************** 
      #|  *************  
      #|   ***********   
      #|    *********    
      #|     *******     
      #|      *****      
      #|       ***       
      #|        *        
    ),
  )
}

///|
test "bar chart" {
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

  inspect(
    bar_chart([10, 20, 30, 40, 20]),
    content=(
      #|         ███   
      #|         ███   
      #|         ███   
      #|      ██████   
      #|      ██████   
      #|   ████████████
      #|   ████████████
      #|   ████████████
      #|███████████████
      #|███████████████
      #|███████████████
      #|10 20 30 40 20 
    ),
  )
}

///|
test "square spiral" {
  fn square_spiral(n : Int) -> Box {
    if n <= 0 {
      singleton('■')
    } else {
      let inner = square_spiral(n - 1)
      let (h, w) = inner.dimensions()
      let top = fill('─', 1, w)
      let bottom = fill('─', 1, w)
      let left = fill('│', h, 1)
      let right = fill('│', h, 1)
      grid([
        [singleton('┌'), top, singleton('┐')],
        [left, inner, right],
        [singleton('└'), bottom, singleton('┘')],
      ])
    }
  }

  inspect(
    square_spiral(9),
    content=(
      #|┌─────────────────┐
      #|│┌───────────────┐│
      #|││┌─────────────┐││
      #|│││┌───────────┐│││
      #|││││┌─────────┐││││
      #|│││││┌───────┐│││││
      #|││││││┌─────┐││││││
      #|│││││││┌───┐│││││││
      #|││││││││┌─┐││││││││
      #|│││││││││■│││││││││
      #|││││││││└─┘││││││││
      #|│││││││└───┘│││││││
      #|││││││└─────┘││││││
      #|│││││└───────┘│││││
      #|││││└─────────┘││││
      #|│││└───────────┘│││
      #|││└─────────────┘││
      #|│└───────────────┘│
      #|└─────────────────┘
    ),
  )
}

///|
test "mandelbrot set" {
  fn mandelbrot_char(x : Double, y : Double, max_iter : Int) -> Char {
    let mut zx = 0.0
    let mut zy = 0.0
    let mut i = 0
    while i < max_iter && zx * zx + zy * zy < 4.0 {
      let temp = zx * zx - zy * zy + x
      zy = 2.0 * zx * zy + y
      zx = temp
      i = i + 1
    }
    if i == max_iter {
      '*'
    } else if i > max_iter * 3 / 4 {
      '#'
    } else if i > max_iter / 2 {
      '.'
    } else {
      ' '
    }
  }

  fn mandelbrot(width : Int, height : Int) -> Box {
    let lines = []
    let x_min = -2.5
    let x_max = 1.0
    let y_min = -1.25
    let y_max = 1.25
    for row = 0; row < height; row = row + 1 {
      let chars = []
      for col = 0; col < width; col = col + 1 {
        let x = x_min + (x_max - x_min) * col.to_double() / width.to_double()
        let y = y_min + (y_max - y_min) * row.to_double() / height.to_double()
        chars.push(singleton(mandelbrot_char(x, y, 50)))
      }
      lines.push(hconcat(chars))
    }
    vconcat(lines)
  }

  inspect(
    mandelbrot(50, 40),
    content=(
      #|                                        
      #|                                        
      #|                                        
      #|                                        
      #|                                        
      #|                           *            
      #|                          ***           
      #|                           *            
      #|                       ******** #       
      #|                      #**********       
      #|                      ***********       
      #|                     *************      
      #|                 **  ************       
      #|               ***** ************       
      #|               *****#************       
      #|      **************************        
      #|               *****#************       
      #|               ***** ************       
      #|                 **  ************       
      #|                     *************      
      #|                      ***********       
      #|                      #**********       
      #|                       ******** #       
      #|                           *            
      #|                          ***           
      #|                           *            
      #|                                        
      #|                                        
      #|                                        
      #|                                        
    ),
  )
}

///|
test "julia set" {
  fn julia_char(
    zx : Double,
    zy : Double,
    cx : Double,
    cy : Double,
    max_iter : Int,
  ) -> Char {
    let mut x = zx
    let mut y = zy
    let mut i = 0
    while i < max_iter && x * x + y * y < 4.0 {
      let temp = x * x - y * y + cx
      y = 2.0 * x * y + cy
      x = temp
      i = i + 1
    }
    if i == max_iter {
      '█'
    } else if i > max_iter * 3 / 4 {
      '#'
    } else if i > max_iter / 2 {
      '.'
    } else {
      ' '
    }
  }

  fn julia_set(width : Int, height : Int, cx : Double, cy : Double) -> Box {
    let lines = []
    let zoom = 1.5
    for row = 0; row < height; row = row + 1 {
      let chars = []
      for col = 0; col < width; col = col + 1 {
        let zx = (col.to_double() - width.to_double() / 2.0) *
          zoom /
          width.to_double() *
          4.0
        let zy = (row.to_double() - height.to_double() / 2.0) *
          zoom /
          height.to_double() *
          4.0
        chars.push(singleton(julia_char(zx, zy, cx, cy, 50)))
      }
      lines.push(hconcat(chars))
    }
    vconcat(lines)
  }

  inspect(
    julia_set(30, 15, -0.7, 0.27015),
    content=(
      #|                              
      #|                              
      #|                              
      #|                              
      #|                              
      #|                              
      #|              ██ █            
      #|           ███  ██████        
      #|         ██████  ███          
      #|             █ ██             
      #|                              
      #|                              
      #|                              
      #|                              
      #|                              
    ),
  )
}

///|
test "cantor set" {
  fn cantor_set(level : Int, length : Int) -> Box {
    if level <= 0 {
      fill('█', 1, length)
    } else {
      let third = length / 3
      let left = cantor_set(level - 1, third)
      let middle = space(1, third)
      let right = cantor_set(level - 1, third)
      [left, middle, right] |> hconcat()
    }
  }

  fn cantor_dust(levels : Int) -> Box {
    let lines = []
    let base_length = 81 // 3^4 for clean divisions
    for i = 0; i <= levels; i = i + 1 {
      lines.push(cantor_set(i, base_length))
      lines.push(space(1, base_length)) // spacing between levels
    }
    vconcat(lines)
  }

  inspect(
    cantor_dust(4),
    content=(
      #|█████████████████████████████████████████████████████████████████████████████████
      #|                                                                                 
      #|███████████████████████████                           ███████████████████████████
      #|                                                                                 
      #|█████████         █████████                           █████████         █████████
      #|                                                                                 
      #|███   ███         ███   ███                           ███   ███         ███   ███
      #|                                                                                 
      #|█ █   █ █         █ █   █ █                           █ █   █ █         █ █   █ █
      #|                                                                                 
    ),
  )
}

///|
test "tree fractal" {
  fn tree_fractal(depth : Int, length : Int, angle : Int) -> Box {
    if depth <= 0 || length <= 1 {
      singleton('|')
    } else {
      let trunk = fill('|', length, 1)
      let left_branch = tree_fractal(depth - 1, length * 2 / 3, angle)
      let right_branch = tree_fractal(depth - 1, length * 2 / 3, angle)

      // Simple branching - left and right
      let branches = [left_branch, space(length, 2), right_branch] |> hconcat()
      trunk.above(branches)
    }
  }

  inspect(
    tree_fractal(4, 8, 30),
    content=(
      #|                      |                       
      #|                      |                       
      #|                      |                       
      #|                      |                       
      #|                      |                       
      #|                      |                       
      #|                      |                       
      #|                      |                       
      #|          |                       |           
      #|          |                       |           
      #|          |                       |           
      #|          |                       |           
      #|          |                       |           
      #|    |           |           |           |     
      #|    |           |           |           |     
      #|    |           |           |           |     
      #| |     |     |     |     |     |     |     |  
      #| |     |     |     |     |     |     |     |  
      #||  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
      #|                                              
    ),
  )
}
