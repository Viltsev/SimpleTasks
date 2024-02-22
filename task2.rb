class Node
  attr_accessor :key, :parent, :left, :right

  def initialize(data)
    @key = data
    @parent = nil
    @left = nil
    @right = nil
  end
end

class SplayTree
  attr_accessor :root

  def initialize
    @root = nil
  end

  def left_rotate(x)
    y = x.right
    x.right = y.left
    y.left.parent = x unless y.left.nil?

    y.parent = x.parent
    if x.parent.nil?
      @root = y
    elsif x == x.parent.left
      x.parent.left = y
    else
      x.parent.right = y
    end

    y.left = x
    x.parent = y
  end

  def right_rotate(x)
    y = x.left
    x.left = y.right
    y.right.parent = x unless y.right.nil?

    y.parent = x.parent
    if x.parent.nil?
      @root = y
    elsif x == x.parent.right
      x.parent.right = y
    else
      x.parent.left = y
    end

    y.right = x
    x.parent = y
  end

  def splay(n)
    while n.parent != nil
      if n.parent == @root
        if n == n.parent.left
          right_rotate(n.parent)
        else
          left_rotate(n.parent)
        end
      else
        p = n.parent
        g = p.parent

        if n.parent.left == n && p.parent.left == p
          right_rotate(g)
          right_rotate(p)
        elsif n.parent.right == n && p.parent.right == p
          left_rotate(g)
          left_rotate(p)
        elsif n.parent.right == n && p.parent.left == p
          left_rotate(p)
          right_rotate(g)
        elsif n.parent.left == n && p.parent.right == p
          right_rotate(p)
          left_rotate(g)
        end
      end
    end
  end

  def insert(n)
    y = nil
    temp = @root
    while temp != nil
      y = temp
      if n.key < temp.key
        temp = temp.left
      else
        temp = temp.right
      end
    end

    n.parent = y

    if y.nil?
      @root = n
    elsif n.key < y.key
      y.left = n
    else
      y.right = n
    end

    splay(n)
  end

  def search(n, x)
    if x == n.key
      return n
    elsif x < n.key
      search(n.left, x)
    elsif x > n.key
      search(n.right, x)
    else
      nil
    end
  end

  def delete(n)
    splay(n)

    left_subtree = SplayTree.new
    left_subtree.root = @root.left
    left_subtree.root.parent = nil unless left_subtree.root.nil?

    right_subtree = SplayTree.new
    right_subtree.root = @root.right
    right_subtree.root.parent = nil unless right_subtree.root.nil?

    if !left_subtree.root.nil?
      m = left_subtree.maximum(left_subtree.root)
      left_subtree.splay(m)
      left_subtree.root.right = right_subtree.root
      @root = left_subtree.root
    else
      @root = right_subtree.root
    end
  end

  def print_tree(node = @root)
    return if node.nil?
    parent = node.key
    leftChild = !node.left.nil? ? node.left&.key : "nil"
    rightChild = !node.right.nil? ? node.right&.key : "nil"
    puts "#{node.key}: #{leftChild}, #{rightChild}"

    print_tree(node.left)
    print_tree(node.right)
  end

  def tree_height(node = @root)
    return 0 if node.nil?

    left_height = tree_height(node.left)
    right_height = tree_height(node.right)

    [left_height, right_height].max + 1
  end

  def print_nodes_at_level(level)
    print "Level #{level}: "

    print_nodes_at_level_recursive(@root, level, 1)

    puts
  end

  private

  def print_nodes_at_level_recursive(node, target_level, current_level)
    return if node.nil?

    if target_level == current_level
      print "#{node.key} "
    else
      print_nodes_at_level_recursive(node.left, target_level, current_level + 1)
      print_nodes_at_level_recursive(node.right, target_level, current_level + 1)
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  t = SplayTree.new
  puts "Enter count of nodes: "
  count = gets.chomp.to_i

  for i in 1..count
    puts "Enter value for node #{i}: "
    value = gets.chomp.to_i
    node = Node.new(value)
    t.insert(node)
  end

  puts "Current splay-tree:\n"
  t.print_tree

  puts "---" * 10

  loop do
    puts "\nChoose an action:"
    puts "1. Print tree height"
    puts "2. Print height of a specific node"
    puts "3. Delete a node"
    puts "4. Print the tree"
    puts "5. Print nodes of a specific level"
    puts "6. Exit"

    choice = gets.chomp.to_i

    case choice
    when 1
      puts "Tree height: #{t.tree_height}"
    when 2
      puts "Enter value of the node:"
      value = gets.chomp.to_i
      node = t.search(t.root, value)
      if node.nil?
        puts "Node with value #{value} not found"
      else
        puts "Height of the node #{value}: #{t.tree_height(node)}"
      end
    when 3
      puts "Enter value of the node to delete:"
      value = gets.chomp.to_i
      node = t.search(t.root, value)
      if node.nil?
        puts "Node with value #{value} not found"
      else
        t.delete(node)
        puts "Node with value #{value} deleted"
      end
    when 4
      puts "Printing the tree:"
      t.print_tree
    when 5
      puts "Enter a level which you want to see:"
      level = gets.chomp.to_i
      t.print_nodes_at_level(level)
    when 6
      puts "Exiting..."
      break
    else
      puts "Invalid choice, please try again"
    end
  end
end


