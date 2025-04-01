require "minruby"

def evaluate(tree, env)
  case tree[0]
  when "lit"
    tree[1]
  when "*"
    evaluate(tree[1], env) * evaluate(tree[2], env)
  when "/"
    evaluate(tree[1], env) / evaluate(tree[2], env)
  when "+"
    evaluate(tree[1], env) + evaluate(tree[2], env)
  when "-"
    evaluate(tree[1], env) - evaluate(tree[2], env)
  when "%"
    evaluate(tree[1], env) % evaluate(tree[2], env)
  when "**"
    evaluate(tree[1], env) ** evaluate(tree[2], env)
  when "=="
    evaluate(tree[1], env) == evaluate(tree[2], env)
  when ">"
    evaluate(tree[1], env) > evaluate(tree[2], env)
  when ">="
    evaluate(tree[1], env) >= evaluate(tree[2], env)
  when "<"
    evaluate(tree[1], env) < evaluate(tree[2], env)
  when "<="
    evaluate(tree[1], env) <= evaluate(tree[2], env)
  when "func_call"          # 仮の実装
    p(evaluate(tree[2], env))
  when "stmts"
    i = 1
    last = nil
    while tree[i]
      last = evaluate(tree[i], env)
      i += 1
    end
    last
  when "var_assign"
    env[tree[1]] = evaluate(tree[2], env)
  when "var_ref"
    env[tree[1]]
  when "if"
    evaluate(tree[1], env) ? evaluate(tree[2], env) : evaluate(tree[3], env)
  when "while"
    while evaluate(tree[1], env)
      evaluate(tree[2], env)
    end
  when "while2"
    evaluate(tree[2], env)
    while evaluate(tree[1], env)
      evaluate(tree[2], env)
    end
  else
    p("Error")
    p("Can't evaluate : " + tree[0].to_s)
    raise("unknown node")
  end
end

def max(tree)
  p tree
  if tree[0] == "lit"
    tree[1]
  else
    left = max(tree[1])
    right = max(tree[2])
    left >= right ? left : right
  end
end

env = {}
str = minruby_load()
tree = minruby_parse(str)
evaluate(tree, env)